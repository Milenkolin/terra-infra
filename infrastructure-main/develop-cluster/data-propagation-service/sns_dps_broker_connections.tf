resource "aws_sns_topic" "broker_connections" {
  name   = "broker-connections_${local.env}"
  policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": [
        "SNS:GetTopicAttributes",
        "SNS:SetTopicAttributes",
        "SNS:AddPermission",
        "SNS:RemovePermission",
        "SNS:DeleteTopic",
        "SNS:Subscribe",
        "SNS:ListSubscriptionsByTopic",
        "SNS:Publish"
      ],
      "Resource": "arn:aws:sns:${local.region}:979370138172:broker-connections_${local.env}",
      "Condition": {
        "StringEquals": {
          "AWS:SourceOwner": "979370138172"
        }
      }
    }
  ]
}
EOF
}

resource "aws_sqs_queue" "dps_broker_connections" {
  name   = "data-propagation-service_broker-connections_${local.env}"
  policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "allow-messages-from-sns",
      "Effect": "Allow",
      "Principal": {
        "Service": "sns.amazonaws.com"
      },
      "Action": "sqs:SendMessage",
      "Resource": "arn:aws:sqs:${local.region}:979370138172:data-propagation-service_broker-connections_${local.env}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "arn:aws:sns:${local.region}:979370138172:${aws_sns_topic.broker_connections.name}"
        }
      }
    },
    {
      "Sid": "allow-ecs-read-messages",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sqs:ReceiveMessage",
      "Resource": "arn:aws:sqs:${local.region}:979370138172:data-propagation-service_broker-connections_${local.env}",
      "Condition": {
        "ArnLike": {
          "aws:SourceArn": "arn:aws:ecs:${local.region}:979370138172:*"
        }
      }
    }
  ]
}
EOF
}

resource "aws_sns_topic_subscription" "broker_connections_dps_sqs" {
  topic_arn            = aws_sns_topic.broker_connections.arn
  protocol             = "sqs"
  endpoint             = aws_sqs_queue.dps_broker_connections.arn
  raw_message_delivery = false
}
