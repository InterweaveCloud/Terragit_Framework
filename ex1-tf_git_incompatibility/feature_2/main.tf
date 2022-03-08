//  Retrieve AWS Account number on which terraform is executing
data "aws_caller_identity" "current" {}

// Generate a globally unique id to append to the resource bucket name
resource "random_id" "s3_append" {
  byte_length = 4
}

// Create a bucket name including the AWS account number and unique ID to ensure it is globally unique
// (requirement for S3 bucket names)
locals {
  bucket_name  = "ex1-bucket-${data.aws_caller_identity.current.account_id}-${lower(random_id.s3_append.id)}"
}

resource "aws_s3_bucket" "TestBucket" {
  bucket = local.bucket_name
  acl    = "private"

  tags = {
    Name        = local.bucket_name
    Environment = "Dev"
  }
}




resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "GameScores"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "UserId"
  range_key      = "GameTitle"

  attribute {
    name = "UserId"
    type = "S"
  }

  attribute {
    name = "GameTitle"
    type = "S"
  }

  tags = {
    Name        = "dynamodb-table-1"
    Environment = "production"
  }
}