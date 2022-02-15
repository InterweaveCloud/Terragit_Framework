resource "aws_s3_bucket" "TestBucket" {
  bucket = replace("${var.branch}-my-tf-test-bucket-uyhgyhgjhghuygugjhfgjhf2", "_", "-")
  acl    = "private"

  			tags = {
    Name        = "My bucket"
    Environment = var.branch
  }

  			versioning {
    enabled = true
  }

}
