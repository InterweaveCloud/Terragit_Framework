resource "aws_s3_bucket" "TestBucket" {
  bucket = "my-tf-test-bucket-uyhgyhgjhghuygugjhfgjhf"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }

  versioning {
    enabled = true
  }

}


