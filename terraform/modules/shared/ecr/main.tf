resource "aws_ecr_repository" "service_repo" {
  name = "${var.service_name}"

  lifecycle {
    create_before_destroy = true
  }
}