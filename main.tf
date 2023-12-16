provider "aws" {
  region = "us-east-1"  # You can choose your preferred region
}

resource "aws_ecs_cluster" "my_cluster" {
  name = "my-cluster"
}

resource "aws_ecs_task_definition" "my_task" {
  family                = "my-task-family"
  network_mode          = "awsvpc"
  task_role_arn =  "arn:aws:iam::224356329163:role/AWSECSTaskExecutionRole"
  execution_role_arn    = "arn:aws:iam::224356329163:role/AWSECSTaskExecutionRole"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024  # 1 vCPU
  memory                   = 3072  # 3 GB
  runtime_platform  {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }
  container_definitions = jsonencode([
    {
      name  = "my-container",
      image = "224356329163.dkr.ecr.us-east-1.amazonaws.com/product-service:develop",
      portMappings = [
        {
          containerPort = 80,
          hostPort      = 80
        },
        {
          containerPort = 8080,
          hostPort      = 8080
        }
      ]
      environment = [
        {
          name  = "PRODUCT_AWS_ACCESS_KEY_ID",
          value = "AKIATIPFN43F63CPN2Y6"
        },
        {
          name  = "PRODUCT_AWS_SECRET_ACCESS_KEY",
          value = "HhYuuClPQDx6CVDmqdTkKx5s3FOGbIAEnOOw3EU7"
        }
      ],
    }
  ])
}

resource "aws_ecs_service" "my_service" {
  name            = "my-service"
  cluster         = aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.my_task.arn
  launch_type     = "FARGATE"

  network_configuration {
    subnets = [
      "subnet-0200e170b196e6174"
    ]
    security_groups = ["sg-0117c74397ad2c38c"]
    assign_public_ip = true
  }

  desired_count = 1
}

resource "aws_iam_role" "ecs_execution_role" {
  name = "ecs_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

