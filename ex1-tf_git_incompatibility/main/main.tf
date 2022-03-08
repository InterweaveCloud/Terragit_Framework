data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "TestBucket" {
  bucket = "my-tf-test-bucket-${data.aws_caller_identity.current.account_id}"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
