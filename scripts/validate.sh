#!/usr/bin/env bash
set -euo pipefail

ENDPOINT="${LOCALSTACK_ENDPOINT:-http://localhost:4566}"
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=us-east-1

aws() { command aws --endpoint-url="$ENDPOINT" "$@"; }

echo "S3 buckets:"
aws s3 ls

echo "DynamoDB tables:"
aws dynamodb list-tables

echo "SQS queues:"
aws sqs list-queues

echo "IAM roles:"
aws iam list-roles --query 'Roles[].RoleName' --output table

echo "VPCs:"
aws ec2 describe-vpcs --query 'Vpcs[].VpcId' --output table
