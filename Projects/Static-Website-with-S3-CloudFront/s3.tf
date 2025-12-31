# ========================================
# S3 Bucket Configuration
# ========================================

# Primary S3 bucket for hosting static website files
resource "aws_s3_bucket" "f-s3-bucket" {
  bucket = var.bucket_name
}

# Block all public access to S3 bucket
# Security best practice: Content served exclusively through CloudFront
resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.f-s3-bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ========================================
# CloudFront Origin Access Control (OAC)
# ========================================

# OAC allows CloudFront to access private S3 bucket
# Replaces legacy Origin Access Identity (OAI) with enhanced security
resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "f-oac"
  description                       = "OAC for static website S3 bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# ========================================
# S3 Bucket Policy
# ========================================

# Bucket policy granting CloudFront read access
# Ensures only CloudFront can access bucket contents
resource "aws_s3_bucket_policy" "allow_cf" {
  bucket     = aws_s3_bucket.f-s3-bucket.id
  depends_on = [aws_s3_bucket_public_access_block.block]

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AllowCloudFront",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "cloudfront.amazonaws.com"
        },
        "Action" : [
          "s3:GetObject",    # Allow reading objects
          "s3:ListBucket"    # Allow listing bucket contents
        ],
        # Grant access to bucket and all objects within
        "Resource" : ["${aws_s3_bucket.f-s3-bucket.arn}", "${aws_s3_bucket.f-s3-bucket.arn}/*"],
        # Restrict access to specific CloudFront distribution
        "Condition" : {
          "StringEquals" : {
            "AWS:SourceArn" : aws_cloudfront_distribution.s3_distribution.arn
          }
        }
      }
    ]
  })
}

# ========================================
# S3 Objects - Static Website Files
# ========================================

# Upload all files from static directory to S3
# Automatically detects and sets appropriate MIME types
resource "aws_s3_object" "website_files" {
  for_each = fileset("${path.module}/static", "**/*")

  bucket = aws_s3_bucket.f-s3-bucket.id
  key    = each.value
  source = "${path.module}/static/${each.value}"

  # ETag triggers re-upload when file content changes
  etag = filemd5("${path.module}/static/${each.value}")

  # Set Content-Type header based on file extension
  # Ensures browsers render files correctly
  content_type = lookup({
    "html" = "text/html",
    "css"  = "text/css",
    "js"   = "application/javascript",
    "json" = "application/json",
    "png"  = "image/png",
    "jpg"  = "image/jpeg",
    "jpeg" = "image/jpeg",
    "gif"  = "image/gif",
    "svg"  = "image/svg+xml",
    "ico"  = "image/x-icon",
    "txt"  = "text/plain"
  }, split(".", each.value)[length(split(".", each.value)) - 1], "application/octet-stream")
}

# ========================================
# CloudFront Distribution
# ========================================

# CDN distribution for global content delivery
# Provides HTTPS, caching, and low-latency access worldwide
resource "aws_cloudfront_distribution" "s3_distribution" {
  # Origin configuration - S3 bucket as content source
  origin {
    domain_name              = aws_s3_bucket.f-s3-bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
    origin_id                = local.s3_origin_id
  }

  # Distribution settings
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront distribution for static website"
  default_root_object = "index.html"

  # Cache behavior and content delivery settings
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    # Legacy cache settings (consider using cache policies for new projects)
    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    # Force HTTPS for all viewer requests
    viewer_protocol_policy = "redirect-to-https"

    # TTL settings for cached objects (in seconds)
    min_ttl     = 0       # Minimum cache time
    default_ttl = 3600    # Default cache time (1 hour)
    max_ttl     = 86400   # Maximum cache time (24 hours)
  }

  # Use only North America and Europe edge locations (cost optimization)
  price_class = "PriceClass_100"

  # Geographic restrictions
  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE"]
    }
  }

  # SSL/TLS certificate configuration
  # Using default CloudFront certificate (*.cloudfront.net)
  viewer_certificate {
    cloudfront_default_certificate = true
  }
}