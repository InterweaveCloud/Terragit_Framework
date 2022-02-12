resource "aws_s3_bucket" "TestBucket3" {
  bucket = "my-tf-test-bucket-uyhgyhgjhghuygugjhfgjhf3"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }

  versioning {
    enabled = true
  }

}
