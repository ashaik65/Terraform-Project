/*
terraform {
  backend "s3" {
    bucket = "demo-project-bucket2"
    key = "new-state/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-demo-project-table"
  }
}
*/