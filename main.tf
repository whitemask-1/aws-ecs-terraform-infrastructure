# main.tf - Creates ECS infrastructure on AWS

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Get the default VPC (every AWS account has one)
data "aws_vpc" "default" {
  default = true
}

# Get subnets in the default VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Create ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = var.cluster_name

  tags = {
    Name        = var.cluster_name
    Environment = var.environment
    Project     = "my-first-aws-infrastructure"
  }
}

# Create CloudWatch Log Group for container logs
resource "aws_cloudwatch_log_group" "webapp" {
  name              = "/ecs/${var.cluster_name}-webapp"
  retention_in_days = 7

  tags = {
    Name        = "${var.cluster_name}-webapp-logs"
    Environment = var.environment
  }
}

# Create IAM role for ECS task execution
resource "aws_iam_role" "ecs_execution_role" {
  name = "${var.cluster_name}-ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "${var.cluster_name}-ecs-execution-role"
    Environment = var.environment
  }
}

# Attach the AWS managed policy for ECS task execution
resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Create Security Group for the web app
resource "aws_security_group" "webapp_sg" {
  name        = "${var.cluster_name}-webapp-sg"
  description = "Security group for web application"
  vpc_id      = data.aws_vpc.default.id

  # Allow HTTP traffic on port 80
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.cluster_name}-webapp-sg"
    Environment = var.environment
  }
}

# Create ECS Task Definition
resource "aws_ecs_task_definition" "webapp" {
  family                   = "${var.cluster_name}-webapp"
  network_mode            = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                     = "256"
  memory                  = "512"
  execution_role_arn      = aws_iam_role.ecs_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "webapp"
      image = var.container_image
      portMappings = [
        {
          containerPort = 80
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.webapp.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
      environment = [
        {
          name  = "ENVIRONMENT"
          value = var.environment
        }
      ]
    }
  ])

  tags = {
    Name        = "${var.cluster_name}-webapp-task"
    Environment = var.environment
  }
}

# Create ECS Service
resource "aws_ecs_service" "webapp" {
  name            = "${var.cluster_name}-webapp-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.webapp.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = data.aws_subnets.default.ids
    security_groups  = [aws_security_group.webapp_sg.id]
    assign_public_ip = true
  }

  tags = {
    Name        = "${var.cluster_name}-webapp-service"
    Environment = var.environment
  }
}