# ===========================
# S3
# ===========================
resource "aws_s3_bucket" "templates" {
  bucket = "${var.app}-${var.env}-templates"
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
      "Resource": "arn:aws:s3:::${var.app}-${var.env}-templates/*"
    }
  ]
}
POLICY

  website {
    index_document = "home.html"
  }
}

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
    index_document = "home.html"
  }
}


resource "aws_s3_bucket" "emails" {
  bucket = "${var.app}-${var.env}-emails"
  acl    = "public-read"
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowSESPuts",
            "Effect": "Allow",
            "Principal": {
                "Service": "ses.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${var.app}-${var.env}-emails/*"
        }
    ]
}
POLICY
}
