output "vpc_id" {
  description = "ID of the VPC"
  value       = data.aws_vpc.default.id
}

output "web_server_id" {
  description = "ID of the web server instance"
  value       = module.ec2_web.id
}

output "web_server_public_ip" {
  description = "Public IP of the web server"
  value       = module.ec2_web.public_ip
}

output "app_server_id" {
  description = "ID of the app server instance"
  value       = module.ec2_app.id
}

output "app_server_private_ip" {
  description = "Private IP of the app server"
  value       = module.ec2_app.private_ip
}

output "db_server_id" {
  description = "ID of the database server instance"
  value       = module.ec2_db.id
}

output "db_server_private_ip" {
  description = "Private IP of the database server"
  value       = module.ec2_db.private_ip
}

# output "sqs_queue_url" {
#   description = "URL of the demo SQS queue"
#   value       = module.sqs_queue.queue_url
# }

# output "sqs_queue_arn" {
#   description = "ARN of the demo SQS queue"
#   value       = module.sqs_queue.queue_arn
# }

# output "sns_topic_arn" {
#   description = "ARN of the demo SNS topic"
#   value       = module.sns_topic.topic_arn
# }

# output "sns_topic_name" {
#   description = "Name of the demo SNS topic"
#   value       = module.sns_topic.topic_name
# }

output "web_security_group_id" {
  description = "ID of the web security group"
  value       = module.sg_web.security_group_id
}

output "app_security_group_id" {
  description = "ID of the app security group"
  value       = module.sg_app.security_group_id
}

output "db_security_group_id" {
  description = "ID of the database security group"
  value       = module.sg_db.security_group_id
}
