# This is code for s3 bucket

resource "aws_s3_bucket" "my_webapp_s3" {
  bucket = "arh-tf-static-bucket"

  tags = {
    Name = "arh-terraform-static-bucket"
  }
}
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.my_webapp_s3.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.my_webapp_s3.id
  policy = jsonencode(
    {
      Version = "2012-10-17",
      Statement = [
        {
          Sid       = "PublicReadGetObject",
          Effect    = "Allow",
          Principal = "*",
          Action    = "s3:GetObject"
          Resource  = "arn:aws:s3:::${aws_s3_bucket.my_webapp_s3.id}/*"

        }
      ]
    }
  )
}

resource "aws_s3_bucket_website_configuration" "myapp" {
  bucket = aws_s3_bucket.my_webapp_s3.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.my_webapp_s3.bucket
  source = "./index.html"
  key    = "index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "style_css" {
  bucket = aws_s3_bucket.my_webapp_s3.bucket
  source = "./style.css"
  key    = "style.css"
  content_type = "text/css"
}
