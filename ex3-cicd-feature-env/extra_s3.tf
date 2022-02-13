resource "aws_s3_bucket" "TestBucket2" {
  bucket = replace("${var.branch}-my-tf-test-bucket-uyhghuygugjhfgjhf2", "_", "-")
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = var.branch
  }

  versioning {
    enabled = true
  }

}
