resource "aws_s3_bucket" "main" {
  bucket = var.bucket_name
}

# Deprecated: Instead, use "aws_s3_bucket_ownership_controls" and "aws_s3_bucket_policy"
# resource "aws_s3_bucket_acl" "main" {
#   bucket = aws_s3_bucket.main.id
#   # public-read or public-read-write
#   acl = "private" # not needed if "BucketOwnerEnforced" is set

#   depends_on = [
#     aws_s3_bucket_ownership_controls.main
#   ]
# }

# Controls object ownership (Disable ACLs)
resource "aws_s3_bucket_ownership_controls" "main" {
  bucket = aws_s3_bucket.main.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# true, Block bucket's public access
# false, if using "aws_s3_bucket_policy"
resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# https://awspolicygen.s3.amazonaws.com/policygen.html
# Replace ACLs with bucket Policies
# Control access via policies
resource "aws_s3_bucket_policy" "main" {
  bucket = aws_s3_bucket.main.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = ["s3:GetObject"]
        Resource = ["${aws_s3_bucket.main.arn}/*"]
      }
    ]
  })

  depends_on = [
    aws_s3_bucket_public_access_block.main
  ]
}

# disable, if using CloudFront as static-site including HTTPs support.
# this feature supports only http protocol.
# resource "aws_s3_bucket_website_configuration" "main" {
#   bucket = aws_s3_bucket.main.id

#   index_document {
#     suffix = "index.html"
#   }

#   error_document {
#     key = "error.html"
#   }
# }

# # disable, if using CloudFront CORS (cache_policy, origin_request_policy, response_headers_policy)
# resource "aws_s3_bucket_cors_configuration" "main" {
#   bucket = aws_s3_bucket.main.id

#   cors_rule {
#     max_age_seconds = 0
#     allowed_methods = ["GET"]
#     allowed_headers = ["*"]
#     allowed_origins = ["*"]
#   }
# }

# Control caching behavior.
# if using "Managed-CachingOptimized", invalidations required without waiting for TTL expiration.
data "aws_cloudfront_cache_policy" "main" {
  name = "Managed-CachingDisabled"
}

# Control which headers, cookies, and query strings forwards to the origin.
data "aws_cloudfront_origin_request_policy" "main" {
  name = "Managed-CORS-S3Origin"
}

# Access-Control-Allow-Origin: '*'
data "aws_cloudfront_response_headers_policy" "main" {
  name = "Managed-SimpleCORS"
}

# requests go through CloudFront and not directly to bucket origin.
resource "aws_cloudfront_origin_access_control" "main" {
  name                              = "cf-to-s3"
  description                       = "OAC for CloudFront to S3"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "main" {
  origin {
    domain_name              = aws_s3_bucket.main.bucket_regional_domain_name # aws_s3_bucket.main.website_endpoint
    origin_id                = local.origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.main.id
  }

  enabled             = true
  is_ipv6_enabled     = true
  http_version        = "http2and3"
  default_root_object = "index.html"
  aliases             = [var.static_website_domain]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.origin_id

    cache_policy_id            = data.aws_cloudfront_cache_policy.main.id
    origin_request_policy_id   = data.aws_cloudfront_origin_request_policy.main.id
    response_headers_policy_id = data.aws_cloudfront_response_headers_policy.main.id

    viewer_protocol_policy = "redirect-to-https"
    compress               = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn            = aws_acm_certificate.main.arn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2021"
  }

  depends_on = [
    aws_acm_certificate_validation.main
  ]
}

resource "aws_acm_certificate" "main" {
  provider = aws.virginia

  domain_name               = var.static_website_domain
  validation_method         = "DNS"
  subject_alternative_names = []
}

resource "aws_acm_certificate_validation" "main" {
  provider = aws.virginia

  certificate_arn         = aws_acm_certificate.main.arn
  validation_record_fqdns = [for r in aws_route53_record.cert-validation : r.fqdn]
}

# aws route53 list-hosted-zones-by-name --dns-name testingyalla.xyz
data "aws_route53_zone" "main" {
  zone_id = var.hosted_zone_id
}

resource "aws_route53_record" "main" {
  type    = "A"
  name    = var.static_website_domain
  zone_id = data.aws_route53_zone.main.id

  alias {
    evaluate_target_health = true
    name                   = aws_cloudfront_distribution.main.domain_name
    zone_id                = aws_cloudfront_distribution.main.hosted_zone_id
  }

  depends_on = [
    aws_cloudfront_distribution.main
  ]
}

resource "aws_route53_record" "cert-validation" {
  for_each = {
    for dv in aws_acm_certificate.main.domain_validation_options : dv.domain_name => {
      type  = dv.resource_record_type
      name  = dv.resource_record_name
      value = dv.resource_record_value
    }
  }

  type    = each.value.type
  name    = each.value.name
  records = [each.value.value]
  zone_id = data.aws_route53_zone.main.id
  ttl     = 10
}
