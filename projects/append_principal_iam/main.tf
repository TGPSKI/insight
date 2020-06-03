data "aws_iam_policy_document" "append" {
  version = "2012-10-17"

  statement {
    actions = [
      "s3:Put*",
      "s3:Get*",
      "s3:Create*",
      "s3:Abort*",
      "s3:List*"
    ]

    resources = [
      "arn:aws:s3:::aws157-logs-prod/*",
      "arn:aws:s3:::aws157-logs-prod/*"
    ]
  }

  statement {
    actions = [
      "s3:Put*",
      "s3:Get*",
      "s3:Create*",
      "s3:Abort*",
      "s3:List*"
    ]

    resources = [
      "arn:aws:s3:::aws157/*",
      "arn:aws:s3:::aws157-logs/*"
    ]
  }
}

locals {
  platform = {
    department = "Engineering"
    division   = "Platform"
  }
  administrators = [
    {
      department = "Engineering"
      division   = "Backend"
    }
  ]

  teams = toset(
    [for team in concat(
      [local.platform], [for admin in local.administrators :
      admin if ! (admin.department == local.platform.department && admin.division == local.platform.division)]
      ) : "${team.department}-${team.division}"
  ])


  policy_json = [
    for statement in jsondecode(data.aws_iam_policy_document.append.json)["Statement"] : merge({ "Principal" = "*" }, statement)
  ]
  constructed_policy = jsonencode(
    merge(
      {
        "Version" = "2012-10-17"
      },
      {
        "Statement" = [
        for statement in jsondecode(data.aws_iam_policy_document.append.json)["Statement"] : merge({ "Principal" = "*" }, statement)]
      }
    )
  )
}

resource "null_resource" "foo" {
  for_each = local.teams
  triggers = {
    ""  = each.value
    "1" = split("-", each.value)[0]
    "2" = split("-", each.value)[1]
  }
}

output "teams" {
  value = local.teams
}

# output "policy_json" {
#   value = local.policy_json
# }
# output "constructed_policy" {
#   value = local.constructed_policy
# }

provider "aws" {}
