# ===========================
# S3
# ===========================
resource "aws_s3_bucket" "bucket" {
  bucket = "${var.app}-${var.env}"
  acl    = "public-read"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Public",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${var.app}-${var.env}-bucket/*"
    }
  ]
}
POLICY

  website {
    index_document = "index.html"
  }
}
