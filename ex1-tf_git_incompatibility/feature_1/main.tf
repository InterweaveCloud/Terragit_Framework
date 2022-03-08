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

# Create a KMS key for the S3 bucket
resource "aws_kms_key" "mykey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

