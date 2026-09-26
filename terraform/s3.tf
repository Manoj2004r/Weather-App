resource "aws_s3_bucket" "frontend" {
  bucket = "${var.project_name}-${data.aws_caller_identity.current.account_id}"

  force_destroy = true
}


resource "aws_s3_bucket_website_configuration" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  depends_on = [
    aws_s3_bucket_public_access_block.frontend
  ]

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "PublicRead"
        Effect = "Allow"

        Principal = "*"

        Action = [
          "s3:GetObject"
        ]

        Resource = "${aws_s3_bucket.frontend.arn}/*"
      }
    ]
  })
}

resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.frontend.id

  key  = "index.html"
  content = file("${path.module}/../frontend/index.html")

  content_type = "text/html"
}

resource "aws_s3_object" "style" {
  bucket = aws_s3_bucket.frontend.id

  key  = "style.css"
  content = file("${path.module}/../frontend/style.css")

  content_type = "text/css"
}

resource "aws_s3_object" "script" {
  bucket = aws_s3_bucket.frontend.id

  key  = "script.js"
  content = file("${path.module}/../frontend/script.js")

  content_type = "application/javascript"
}
resource "aws_s3_object" "config" {
  bucket = aws_s3_bucket.frontend.id
  key    = "config.js"

  content = <<-EOF
    const API_URL = "${aws_api_gateway_stage.weather_stage.invoke_url}/weather";
  EOF

  content_type = "application/javascript"
}
