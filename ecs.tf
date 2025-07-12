resource "aws_ecr_repository" "this" {
  name                 = "${local.name_prefix}-ecr"
  force_delete         = true
  image_tag_mutability = "MUTABLE"

  tags = {
    Name = "${local.name_prefix}-ecr"
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
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
    Version = "2012-10-17"
  })
  description = "Allows ECS tasks to call AWS services on your behalf."
  name        = "ecsTaskExecutionRole"
  path        = "/"

  tags = {
    Name = "${local.name_prefix}-ecs-task-execution-role"
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


resource "aws_ecs_cluster" "this" {
  name = "${local.name_prefix}-cluster"

  tags = {
    Name = "${local.name_prefix}-cluster"
  }
}

resource "aws_ecs_cluster_capacity_providers" "this" {
  cluster_name       = aws_ecs_cluster.this.name
  capacity_providers = ["FARGATE", "FARGATE_SPOT"]
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/ecs/logs/${local.name_prefix}/fastapi"
  retention_in_days = 1
}

resource "aws_cloudwatch_log_group" "codedeploy" {
  name              = "/ecs/logs/terraform/fastapi"
  retention_in_days = 1
}

resource "aws_ecs_task_definition" "this" {
  family                   = "${local.name_prefix}-task-definition"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "fastapi"
      image     = "${data.aws_caller_identity.current.account_id}.dkr.ecr.ap-northeast-1.amazonaws.com/${aws_ecr_repository.this.name}:latest"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 8000
          protocol      = "tcp"
        },
      ]
      environment = [
        {
          name  = "AWS_DEFAULT_REGION"
          value = "ap-northeast-1"
        },
        {
          name  = "AWS_REGION"
          value = "ap-northeast-1"
        },
        {
          name  = "REGION"
          value = "ap-northeast-1"
        },
        {
          name  = "USERPOOL_ID"
          value = "${aws_cognito_user_pool.this.id}"
        },
        {
          name  = "APP_CLIENT_ID"
          value = "${aws_cognito_user_pool_client.app.id}"
        },
        {
          name  = "BEDROCK_REGION"
          value = "us-east-1"
        },
        {
          name  = "ENVIRONMENT"
          value = "${var.environment}"
        },
        {
          name  = "CORS_ORIGINS"
          value = "https://${var.domain_name},http://localhost:5173,http://localhost:3000"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.this.name
          "awslogs-region"        = "ap-northeast-1"
          "awslogs-stream-prefix" = "${local.name_prefix}-fastapi"
        }
      }
    },
  ])
}

resource "aws_ecs_service" "this" {
  name = "${local.name_prefix}-ecs-service"

  capacity_provider_strategy {
    base              = 1
    capacity_provider = "FARGATE_SPOT"
    weight            = 1
  }
  cluster       = aws_ecs_cluster.this.id
  desired_count = 1
  network_configuration {
    subnets = [
      aws_subnet.private["1a"].id,
      aws_subnet.private["1c"].id
    ]
    security_groups  = [aws_security_group.backend.id]
    assign_public_ip = false
  }
  task_definition                   = aws_ecs_task_definition.this.arn
  health_check_grace_period_seconds = 300

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.blue.arn
    container_name   = "fastapi"
    container_port   = 8000
  }

  tags = {
    "Name" = "${local.name_prefix}-ecs-service"
  }

  lifecycle {
    ignore_changes = [
      task_definition,
      desired_count,
      load_balancer,
    ]
  }

  depends_on = [
    aws_lb_listener.tcp
  ]
}

