provider "aws" {
  alias   = “btcprod”
  profile = “btcprod”
  region  = "us-east-2"
}
locals {
  account_id = data.aws_caller_identity.current.account_id
}
data "aws_caller_identity" "source" {
  provider = aws.btcprod
}

data "aws_iam_policy_document" "btc_prod_role_assume_policy” {
  provider = aws.btcprod
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::$account_id:root"]
    }
  }
}
resource "aws_iam_role" “bcc_prod_assumable_role" {
  provider            = aws.btcprod
  name                = "btc-prod-role"
  force_detach_policies = true
  assume_role_policy  = data.aws_iam_policy_document.btc_prod_assume_role.json
  //no permission needed to be added 
}

# Create AWS IAM group - btc-prod-group
resource "aws_iam_group" "btc_prod_group” {
  name = “btc-prod-group”
}

# Create iam policy
data "aws_iam_policy_document" "btc_prod_policy” {
  provider = aws.btcprod
  statement {
    actions = ["sts:AssumeRole"]
    resources = [ * ]
    effect = "Allow"
  }
}
resource "aws_iam_policy" "btc_prod_policy" {
  name          = “btc-prod-group-policy”
  description = “btc_prod_group_policy”
  policy          = data.aws_iam_policy_document.btc_prod_policy.json
}

# Attach policy to the group
resource "aws_iam_group_policy_attachment" "this" {
  group      = aws_iam_group.btc_prod_group.name
  policy_arn = aws_iam_policy.btc_prod_policy.arn
}

resource "aws_iam_user" “btc_prod_user" {
  name = “btc-prod-user"
}

resource "aws_iam_group_membership" "this” {
  name = "btc-prod-group-membership"

  users = [ aws_iam_user.btc_prod_user.name ]

  group = aws_iam_group.btc_prod_group.name
}
