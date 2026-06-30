output "s3_bucket_name" {
  value = aws_s3_bucket.artifacts.bucket
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.app_table.name
}

output "sqs_queue_url" {
  value = aws_sqs_queue.main.url
}

output "sqs_dlq_url" {
  value = aws_sqs_queue.dlq.url
}

output "iam_role_arn" {
  value = aws_iam_role.app_role.arn
}

output "vpc_id" {
  value = aws_vpc.main.id
}
