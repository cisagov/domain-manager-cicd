resource "aws_s3_bucket" "templates" {
  bucket = "${var.app}-${var.env}-templates"
}

resource "aws_s3_bucket_acl" "templates" {
  bucket = aws_s3_bucket.templates.id
  acl    = "private"
}

resource "aws_s3_bucket_policy" "templates" {
  bucket = aws_s3_bucket.templates.id
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Public",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${var.app}-${var.env}-templates/*"
    }
  ]
}
POLICY
}

resource "aws_s3_bucket_website_configuration" "templates" {
  bucket = aws_s3_bucket.templates.id

  index_document {
    suffix = "home.html"
  }
}
