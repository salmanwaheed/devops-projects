output "bucket_url" {
  value = aws_s3_bucket.main.bucket_regional_domain_name
}

output "static_website_url" {
  value = aws_route53_record.main.name
}

output "cloudfront_url" {
  value = aws_cloudfront_distribution.main.domain_name
}
