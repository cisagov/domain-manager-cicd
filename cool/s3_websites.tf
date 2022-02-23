resource "aws_s3_bucket" "websites" {
  bucket = "${var.app}-${var.env}-websites"
}

resource "aws_s3_bucket_acl" "websites" {
  bucket = aws_s3_bucket.websites.id
  acl    = "private"
}

resource "aws_s3_bucket_policy" "websites" {
  bucket = aws_s3_bucket.websites.id
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Public",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${var.app}-${var.env}-websites/*"
    }
  ]
}
POLICY
}

resource "aws_s3_bucket_website_configuration" "websites" {
  bucket = aws_s3_bucket.websites.id

  index_document {
    suffix = "home.html"
  }
}
