provider "aws" {
  region  = var.region
}


resource "aws_s3_bucket" "b" {
  bucket = "myawsbucketasbabjan"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

variable "region" {
  
}