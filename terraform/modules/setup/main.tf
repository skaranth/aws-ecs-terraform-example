module "todo-backend" {
  source              = "../../shared/ecr"
  env_name            = "${var.env}"
  service_name           = "todo-backend"
}
