terraform {
  backend "s3" {
    bucket         = "statefile-bucket-002"
    key            = "Infra/s3-terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
  }
}
