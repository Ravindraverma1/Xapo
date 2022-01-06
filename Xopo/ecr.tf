resource "aws_ecr_repository" "btc_ecr_repo" {
  name = "btc-ecr-repo" # creating repository for my btc docker image as easier to pull from ecr to ecs
}
