##
## Policies
##

resource "aws_iam_policy" "amazon_grafana_cloudwatch" {
  name        = "AmazonGrafanaCloudWatchPolicy-mvtbrulbO"
  description = "Allows Amazon Grafana to access CloudWatch"
  path        = "/service-role/"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowReadingMetricsFromCloudWatch",
            "Effect": "Allow",
            "Action": [
                "cloudwatch:DescribeAlarmsForMetric",
                "cloudwatch:DescribeAlarmHistory",
                "cloudwatch:DescribeAlarms",
                "cloudwatch:ListMetrics",
                "cloudwatch:GetMetricStatistics",
                "cloudwatch:GetMetricData",
                "cloudwatch:GetInsightRuleReport"
            ],
            "Resource": "*"
        },
        {
            "Sid": "AllowReadingLogsFromCloudWatch",
            "Effect": "Allow",
            "Action": [
                "logs:DescribeLogGroups",
                "logs:GetLogGroupFields",
                "logs:StartQuery",
                "logs:StopQuery",
                "logs:GetQueryResults",
                "logs:GetLogEvents"
            ],
            "Resource": "*"
        },
        {
            "Sid": "AllowReadingTagsInstancesRegionsFromEC2",
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeTags",
                "ec2:DescribeInstances",
                "ec2:DescribeRegions"
            ],
            "Resource": "*"
        },
        {
            "Sid": "AllowReadingResourcesForTags",
            "Effect": "Allow",
            "Action": "tag:GetResources",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "cloudwatch_grafana" {
  name = "CloudWatchGrafanaPolicy"

  tags = {
    policy-name = "cloudwatch-grafana"
  }

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowReadingMetricsFromCloudWatch",
            "Effect": "Allow",
            "Action": [
                "cloudwatch:DescribeAlarmsForMetric",
                "cloudwatch:DescribeAlarmHistory",
                "cloudwatch:DescribeAlarms",
                "cloudwatch:ListMetrics",
                "cloudwatch:GetMetricStatistics",
                "cloudwatch:GetMetricData"
            ],
            "Resource": "*"
        },
        {
            "Sid": "AllowReadingLogsFromCloudWatch",
            "Effect": "Allow",
            "Action": [
                "logs:DescribeLogGroups",
                "logs:GetLogGroupFields",
                "logs:StartQuery",
                "logs:StopQuery",
                "logs:GetQueryResults",
                "logs:GetLogEvents"
            ],
            "Resource": "*"
        },
        {
            "Sid": "AllowReadingTagsInstancesRegionsFromEC2",
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeTags",
                "ec2:DescribeInstances",
                "ec2:DescribeRegions"
            ],
            "Resource": "*"
        },
        {
            "Sid": "AllowReadingResourcesForTags",
            "Effect": "Allow",
            "Action": "tag:GetResources",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "kms_encrypt_decrypt" {
  name        = "KmsEncryptAndDecrypt"
  path        = "/"
  description = "Allow Decrypt and Encrypt"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "kms:Decrypt",
                "kms:Encrypt"
            ],
            "Resource": "arn:aws:kms:*:979370138172:key/*"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "s3_strapi_upload_access" {
  name   = "S3-Strapi-Upload-Access"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:ListStorageLensConfigurations",
                "s3:GetAccessPoint",
                "s3:PutAccountPublicAccessBlock",
                "s3:GetAccountPublicAccessBlock",
                "s3:ListAllMyBuckets",
                "s3:ListAccessPoints",
                "s3:ListJobs",
                "s3:PutStorageLensConfiguration",
                "s3:CreateJob"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::*/*",
                "arn:aws:s3:::stockperks-strapi-uploads"
            ]
        }
    ]
}
EOF
}

##
## Policy attachments
##

resource "aws_iam_policy_attachment" "cloudwatch_grafana" {
  name       = "grafana-policy-attachment"
  users      = [aws_iam_user.grafana.name]
  groups     = [aws_iam_group.administrators.name]
  policy_arn = aws_iam_policy.cloudwatch_grafana.arn
}

resource "aws_iam_policy_attachment" "ecr_readonly" {
  name = "ecr-readonly-policy-attachment"
  users = [
    aws_iam_user.ecr_readonly.name,
    aws_iam_user.infra_tools.name
  ]
  groups = [aws_iam_group.developers.name]
  roles = [
    "developer-assume-role",
    "jenkins-executors-role-TaskExecutionRole-D1IJR5EGH5MW",
    "jenkins-executors-role-TaskRole-TXLOBYPXSW2Z",
  ]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_policy_attachment" "kms_encrypt_decrypt" {
  name = "kms-encrypt-decrypt-policy-attachment"
  users = [
    aws_iam_user.infra_tools.name,
    aws_iam_user.strapi.name
  ]
  groups     = [aws_iam_group.developers.name]
  roles      = ["developer-assume-role"]
  policy_arn = aws_iam_policy.kms_encrypt_decrypt.arn
}

resource "aws_iam_policy_attachment" "s3_full_access" {
  name       = "s3-full-access-policy-attachment"
  users      = [aws_iam_user.tatiana.name]
  groups     = [aws_iam_group.developers.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_policy_attachment" "s3_strapi_upload" {
  name       = "strapi-upload-access"
  users      = [aws_iam_user.strapi.name]
  policy_arn = aws_iam_policy.s3_strapi_upload_access.arn
}

resource "aws_iam_policy_attachment" "netframe" {
  for_each = {
    ec2-full-access = "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    net-admin       = "arn:aws:iam::aws:policy/job-function/NetworkAdministrator",
    nm-full-access  = "arn:aws:iam::aws:policy/AWSNetworkManagerFullAccess"
  }

  name       = "${aws_iam_user.netframe.name}-${each.key}-policy-attachment"
  users      = [aws_iam_user.netframe.name]
  policy_arn = each.value
}

resource "aws_iam_policy_attachment" "sebastian" {
  for_each = {
    ses-full-access = "arn:aws:iam::aws:policy/AmazonSESFullAccess"
    sns-role        = "arn:aws:iam::aws:policy/service-role/AmazonSNSRole"
    sns-full-access = "arn:aws:iam::aws:policy/AmazonSNSFullAccess"
  }

  name       = "${aws_iam_user.sebastian.name}-${each.key}-policy-attachment"
  users      = [aws_iam_user.sebastian.name]
  policy_arn = each.value
}
