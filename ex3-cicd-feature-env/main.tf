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


# Create a KMS key for the S3 bucket
resource "aws_kms_key" "mykey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}
