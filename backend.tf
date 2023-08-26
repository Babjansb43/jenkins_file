terraform {
  backend "s3" {
    bucket         = "s3buckerforbackend"
    key            = "s3buckerforbackend/terraform.tfstate"
    region         = "eu-north-1"
    encrypt        = true
    dynamodb_table = "terraform_locks"
  }
}