module "env_size" {
  source = "../env_size"
  size = var.size
}

resource "aws_ecs_cluster" "service_cluster" {
  name = "${var.env}-${var.service_name}-cluster"
}

data "template_file" "ecs_task_definition" {
  template = "${file("${path.module}/templates/task_definition.tpl")}"
  vars = {
    env = var.env,
    service_name = var.service_name,
    product_code = var.product_code,
    role_arn = var.role_arn
    image_url = "${var.ecr_repo}:${var.product_version}"
    cpu = module.env_size.ecs_cpu
    memory = module.env_size.ecs_memory
    app_port = var.app_port

  }
}

resource "aws_ecs_task_definition" "service_definition" {
  family = "app"
  network_mode = "awsvpc"
  requires_compatibilities = [
    "FARGATE"]
  cpu = module.env_size.ecs_cpu
  memory = module.env_size.ecs_memory
  execution_role_arn = var.execution_role_arn

  container_definitions = data.template_file.ecs_task_definition.rendered
}

data "aws_availability_zones" "available" {}

resource "aws_ecs_service" "app_service" {
  name = "${var.env}-${var.service_name}"
  cluster = aws_ecs_cluster.service_cluster.id
  task_definition = aws_ecs_task_definition.service_definition.arn
  desired_count = module.env_size.ecs_desired_count
  iam_role = var.role_arn
  depends_on = [
    aws_ecs_cluster.service_cluster,
    aws_ecs_task_definition.service_definition]

  ordered_placement_strategy {
    type = "binpack"
    field = "cpu"
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name = "${var.env}-${var.service_name}"
    container_port = var.app_port
  }

//  placement_constraints {
//    type = "memberOf"
//    expression = "attribute:ecs.availability-zone in ${data.aws_availability_zones.available.all_availability_zones}"
//  }
}
