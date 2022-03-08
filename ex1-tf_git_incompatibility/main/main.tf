data "aws_caller_identity" "current" {}

resource "random_id" "s3_append" {
  byte_length = 4
}

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
