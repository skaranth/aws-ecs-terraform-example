terragrunt = {
  terraform {
    source = "../../modules//setup"
  }

  include {
    path = "${find_in_parent_folders()}"
  }
}