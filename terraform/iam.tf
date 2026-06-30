data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "app_role" {
  name               = "${var.project_name}-${var.environment}-app-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "app_permissions" {
  statement {
    sid     = "S3Artifacts"
    effect  = "Allow"
    actions = ["s3:GetObject", "s3:PutObject", "s3:ListBucket"]
    resources = [
      aws_s3_bucket.artifacts.arn,
      "${aws_s3_bucket.artifacts.arn}/*",
    ]
  }
  statement {
    sid       = "DynamoAccess"
    effect    = "Allow"
    actions   = ["dynamodb:GetItem", "dynamodb:PutItem", "dynamodb:Query"]
    resources = [aws_dynamodb_table.app_table.arn]
  }
  statement {
    sid       = "SqsAccess"
    effect    = "Allow"
    actions   = ["sqs:SendMessage", "sqs:ReceiveMessage", "sqs:DeleteMessage"]
    resources = [aws_sqs_queue.main.arn]
  }
}

resource "aws_iam_role_policy" "app_policy" {
  name   = "${var.project_name}-${var.environment}-app-policy"
  role   = aws_iam_role.app_role.id
  policy = data.aws_iam_policy_document.app_permissions.json
}

resource "aws_iam_instance_profile" "app_profile" {
  name = "${var.project_name}-${var.environment}-app-profile"
  role = aws_iam_role.app_role.name
}
