resource "aws_sqs_queue" "portfolio_manager_service_perks" {
  name   = "portfolio-manager-service_perks_${local.env}"
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
      "Resource": "arn:aws:sqs:${local.region}:979370138172:portfolio-manager-service_perks_${local.env}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "arn:aws:sns:${local.region}:979370138172:perks_${local.env}"
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
      "Resource": "arn:aws:sqs:${local.region}:979370138172:portfolio-manager-service_perks_${local.env}",
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

resource "aws_sns_topic_subscription" "perks_portfolio_manager_service_sqs" {
  topic_arn            = "arn:aws:sns:${local.region}:979370138172:perks_${local.env}"
  protocol             = "sqs"
  endpoint             = aws_sqs_queue.portfolio_manager_service_perks.arn
  raw_message_delivery = true
}
