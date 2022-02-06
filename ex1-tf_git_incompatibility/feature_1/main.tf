resource "aws_s3_bucket" "TestBucket" {
  bucket = "my-tf-test-bucket-uyhgyhgjhghuygu"
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    prefix  = "config/"
    enabled = true

    noncurrent_version_transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    noncurrent_version_transition {
      days          = 60
      storage_class = "GLACIER"
    }

    noncurrent_version_expiration {
      days = 90
    }
  }

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
