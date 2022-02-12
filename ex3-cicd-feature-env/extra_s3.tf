resource "aws_s3_bucket" "TestBucket2" {
  bucket = "${var.branch}-my-tf-test-bucket-uyhgyhgjhghuygugjhfgjhf2"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = var.branch
  }

  versioning {
    enabled = true
  }

}
