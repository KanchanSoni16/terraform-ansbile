
resource "aws_iam_policy" "s3_bucket_policy" {
  name        = "s3_bucket_policy"
  path        = "/"
  description = "S3 put object permission generation policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "s3:PutObject",
        ]
        "Effect" : "Allow",
        "Resource" : "${aws_s3_bucket.s3_bucket.arn}/*"
      }
    ]
  })
}

resource "aws_iam_role" "ec2_s3" {
  name = "EC2_to_S3"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "Ec2 to S3 Role"
  }
}

resource "aws_iam_role_policy_attachment" "policy_attachment" {
  role       = aws_iam_role.ec2_s3.name
  policy_arn = aws_iam_policy.s3_bucket_policy.arn
}