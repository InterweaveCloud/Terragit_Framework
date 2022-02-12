resource "aws_s3_bucket" "TestBucket" {
  bucket = "${var.branch}-my-tf-test-bucket-uyhgyhgjhghuygugjhfgjhf"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = var.branch
  }

  versioning {
    enabled = true
  }

}
