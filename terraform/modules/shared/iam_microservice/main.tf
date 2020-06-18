data "aws_iam_policy_document" "microservice_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "microservice_task_execution_role" {
  name               = "${var.env}-${var.service_name}-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.microservice_role_policy.json
}



resource "aws_iam_role_policy_attachment" "microservice_task_execution_policy" {
  role       = aws_iam_role.microservice_task_execution_role.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "ecs_task_role_assume_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"

      identifiers = [
        "ecs-tasks.amazonaws.com",
      ]
    }
  }
}

