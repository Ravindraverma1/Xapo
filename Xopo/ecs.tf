
resource "aws_ecs_cluster" "btc_cluster" {
  name = "btc-cluster" # Naming the cluster
}

resource "aws_ecs_task_definition" "btc_task" {
  family                   = "btc-task" # Naming our first task
  container_definitions    = <<DEFINITION
  [
    {
      "name": "btc-task",
      "image": "${aws_ecr_repository.btc_ecr_repo.repository_url}",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 8332,
          "hostPort": 3000
        },
        {
          "containerPort": 8333,
          "hostPort": 3001
        }
      ],
      "memory": 512,
      "cpu": 256
    }
  ]
  DEFINITION
  requires_compatibilities = ["FARGATE"] # Stating that we are using ECS Fargate
  network_mode             = "awsvpc"    # Using awsvpc as our network mode as this is required for Fargate
  memory                   = 512         # Specifying the memory our container requires
  cpu                      = 256         # Specifying the CPU our container requires
  execution_role_arn       = "${aws_iam_role.ecsTaskExecutionRole.arn}"
  volume {
    name  = "btc-volume"
    efs_volume_configuration {
      file_system_id = aws_efs_file_system.btc.id
    }
/*multiline comment - another alternative
  volume {
    name = "service-storage"

   docker_volume_configuration {
    scope         = "shared"
    autoprovision = true
    driver        = "local"

    driver_opts = {
      "type"   = "nfs"
      "device" = "${aws_efs_file_system.fs.dns_name}:/"
      "o"      = "addr=${aws_efs_file_system.fs.dns_name},rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport"
    }
   }
  }
 */
  }
}

