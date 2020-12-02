# ===========================
# S3
# ===========================
resource "aws_s3_bucket" "websites" {
  bucket = "${var.app}-${var.env}-websites"
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
      "Resource": "arn:aws:s3:::${var.app}-${var.env}-websites/*"
    }
  ]
}
POLICY

  website {
    index_document = "index.html"
  }
}


resource "aws_s3_bucket" "bucket" {
  bucket = "${var.app}-${var.env}-bucket"
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

resource "aws_s3_bucket" "templates" {
  bucket = "${var.app}-${var.env}-templates"
  acl    = "private"
}
