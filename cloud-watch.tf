provider "aws" {
  region = "us-east-1"
}

resource "aws_cloudwatch_log_group" "react_log_group" {
  name              = "/aws/ec2/react-app"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_stream" "react_log_stream" {
  name           = "react-app-log-stream"
  log_group_name = aws_cloudwatch_log_group.react_log_group.name
}

resource "aws_cloudwatch_metric_alarm" "high_cpu_utilization" {
  alarm_name                = "HighCPUUtilization"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = "5"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This alarm triggers when CPU utilization exceeds 80% for 5 consecutive minutes."
  actions_enabled           = true
  alarm_actions             = [aws_sns_topic.react_alert.arn]
  insufficient_data_actions = []
  ok_actions                = []

  dimensions = {
    InstanceId = aws_instance.react-app.id
  }

  tags = {
    Name = "high-cpu-utilization"
  }
}

resource "aws_sns_topic" "react_alert" {
  name = "react-alert-topic"
}

resource "aws_sns_topic_subscription" "react_alert_email" {
  topic_arn = aws_sns_topic.react_alert.arn
  protocol  = "email"
  endpoint  = "mohammedkhashif02@gmail.com"  # replace with your email address
}

output "cloudwatch_alarm_arn" {
  value = aws_cloudwatch_metric_alarm.high_cpu_utilization.arn
}
