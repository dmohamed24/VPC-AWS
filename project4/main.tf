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

resource "aws_iam_user" "s3_user" {
  name = "limited-s3-user"
}

resource "aws_iam_access_key" "s3_user_key" {
  user = aws_iam_user.s3_user.name
}

data "aws_iam_policy_document" "s3_read_policy" {
  statement {
    effect = "Allow"
    actions = ["s3:ListBucket",
    "s3:GetObject"]
    resources = ["*"]
  }
}

resource "aws_iam_user_policy" "s3_user_attach" {
  name   = "test"
  user   = aws_iam_user.s3_user.name
  policy = data.aws_iam_policy_document.s3_read_policy.json
}