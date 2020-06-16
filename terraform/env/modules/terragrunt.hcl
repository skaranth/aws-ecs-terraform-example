remote_state {
	backend = "s3"

	config = {
  		encrypt        = true
  		bucket         = "tg-demo-dev-setup"
  		key            = "${path_relative_to_include()}/terraform.tfstate"
  		region         = "us-east-1"
  		dynamodb_table = "tg-demo-dev-setup"
	}
}

terraform {
	extra_arguments "bucket" {
		commands = get_terraform_commands_that_need_vars()
		arguments = [
			"-var-file=/Users/skaranth/root/work/git/aws-ecs-terraform-example/terraform/./env/modules/env.tfvars",
		]
	}
}

