# outputs.tf - Information displayed after deployment

output "cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.main.name
}

output "service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.webapp.name
}

output "log_group_name" {
  description = "CloudWatch log group name"
  value       = aws_cloudwatch_log_group.webapp.name
}

output "security_group_id" {
  description = "Security group ID"
  value       = aws_security_group.webapp_sg.id
}

output "task_definition_arn" {
  description = "Task definition ARN"
  value       = aws_ecs_task_definition.webapp.arn
}

output "next_steps" {
  description = "What to do next"
  value = <<EOF
Your infrastructure is ready! Next steps:

1. Check ECS Console: https://console.aws.amazon.com/ecs/home?region=${var.aws_region}#/clusters/${aws_ecs_cluster.main.name}
2. Find your running task and get its public IP
3. Open http://[PUBLIC_IP] in your browser
4. Check logs in CloudWatch: https://console.aws.amazon.com/cloudwatch/home?region=${var.aws_region}#logStream:group=${aws_cloudwatch_log_group.webapp.name}

To get the public IP via CLI:
aws ecs list-tasks --cluster ${aws_ecs_cluster.main.name} --service-name ${aws_ecs_service.webapp.name}
EOF
}