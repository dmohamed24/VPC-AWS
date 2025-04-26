terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}

resource "aws_s3_bucket" "static_site" {
  bucket        = "my-tf-bucket-982"
  force_destroy = true

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}


resource "aws_s3_bucket_website_configuration" "static_website" {
  bucket = aws_s3_bucket.static_site.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_object" "object" {
  bucket       = aws_s3_bucket.static_site.id
  key          = "index.html"
  source       = "index.html"
  content_type = "text/html"
  etag         = filemd5("index.html")
}


data "aws_iam_policy_document" "public_read" {
  statement {
    effect = "Allow"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.static_site.arn}/*"
    ]
  }
}

resource "aws_s3_bucket_policy" "public_policy" {
  bucket = aws_s3_bucket.static_site.id
  policy = data.aws_iam_policy_document.public_read.json

    depends_on = [
    aws_s3_bucket_public_access_block.public_access
  ]
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.static_site.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

locals {
  s3_origin_id = "myS3Origin"
}

resource "aws_cloudfront_distribution" "cdn" {
  origin {
    domain_name = aws_s3_bucket.static_site.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = "" # Optional if you want to add security later
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CDN for static site"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true # use AWS default cert (*.cloudfront.net)
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}

output "cdn_domain" {
  value = aws_cloudfront_distribution.cdn.domain_name
}

output "website_url" {
  value = aws_s3_bucket_website_configuration.static_website.website_endpoint
}