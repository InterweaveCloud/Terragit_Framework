resource "aws_s3_bucket" "TestBucket" {
  bucket = "my-tf-test-bucket-uyhgyhgjhghuygu"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
