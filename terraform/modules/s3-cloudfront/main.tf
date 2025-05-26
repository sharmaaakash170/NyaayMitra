resource "aws_s3_bucket" "this" {
  bucket = "${var.env}-frontend-bucket-786029090"

  tags = merge(var.tags, {
    Environment = var.env
  })
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls = false 
  block_public_policy = false 
  ignore_public_acls = false 
  restrict_public_buckets = false 
}

resource "aws_s3_bucket_policy" "public_access" {
  bucket = aws_s3_bucket.this.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.this.arn}/*"
      }
    ]
  })

  depends_on = [ aws_s3_bucket_public_access_block.this ]
}

resource "aws_s3_bucket_website_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_cloudfront_distribution" "cdn" {
  enabled = true
  default_root_object = "index.html"

  origin {
    domain_name = aws_s3_bucket_website_configuration.this.website_endpoint
    origin_id = "S3-${aws_s3_bucket.this.id}"

    custom_origin_config {
      http_port = 80
      https_port = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols = [ "TLSv1.2" ]
    }
  }

  default_cache_behavior {
    allowed_methods = [ "GET", "HEAD" ]
    cached_methods = [ "GET", "HEAD" ]
    target_origin_id = "S3-${aws_s3_bucket.this.id}"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false 

      cookies {
        forward = "none"
      }
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = merge(var.tags, {
    Environment = var.env 
  })

  depends_on = [aws_s3_bucket_website_configuration.this]
}