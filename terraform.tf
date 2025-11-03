terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.54.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.2"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}
resource "random_id" "rand_id" {
  byte_length = 8
}
###########################################################
# S3 Bucket Creation
###########################################################
resource "aws_s3_bucket" "supplychain_bucket" {
  bucket        = var.bucket_name_prefix != "" ? "${var.bucket_name_prefix}-${random_id.rand_id.hex}" : "my-website-bucket-${random_id.rand_id.hex}"
  force_destroy = true

  tags = {
    Name        = "Non-prod website Bucket"
    Environment = var.environment
  }
}
###########################################################
# S3 Version enabled
###########################################################
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.supplychain_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}
###########################################################
# Ownership controls -  replacement for ACL
###########################################################
resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.supplychain_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
###########################################################
# Enable Public Access 
###########################################################
resource "aws_s3_bucket_public_access_block" "public_block" {
  bucket = aws_s3_bucket.supplychain_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
#################################################################
# Upload object with explicit ACL since object ACL is still valid
##################################################################
resource "aws_s3_object" "bucket_data" {
  bucket = aws_s3_bucket.supplychain_bucket.id
  source = var.file_path
  key    = var.file_key
}
###########################################################
# Lifecycle rule to expire objects after 30 days
###########################################################
resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
  bucket = aws_s3_bucket.supplychain_bucket.id

  rule {
    id     = "expire-old-objects"
    status = "Enabled"

    expiration {
      days = 30
    }
  }
}
###########################################################
# Lifecycle rule to expire objects after 30 days
###########################################################
resource "aws_s3_bucket_policy" "policy" {
  bucket = aws_s3_bucket.supplychain_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = {
        AWS = var.allowed_user_arn
      }
      Action    = [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:ListBucket"
      ]
      Resource = [
        "${aws_s3_bucket.supplychain_bucket.arn}",
        "${aws_s3_bucket.supplychain_bucket.arn}/*"
      ]
    }]
  })
}
#################################################
