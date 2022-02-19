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


output "test_output" { value = "test_output" }

resource "aws_s3_bucket" "TestBucket2" {
  bucket = replace("${var.branch}-second-test-bucket", "_", "-")
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = var.branch
  }

  versioning {
    enabled = true
  }

}

