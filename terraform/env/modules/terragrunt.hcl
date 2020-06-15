remote_state {
	backend = "s3"

	config = {
  		encrypt        = true
  		bucket         = "tg-dev-setup"
  		key            = "${path_relative_to_include()}/terraform.tfstate"
  		region         = "us-east-1"
  		dynamodb_table = "tg-dev-setup"
	}
}

terraform {
	extra_arguments "bucket" {
		commands = get_terraform_commands_that_need_vars()
		arguments = [
			"-var-file=./terraform.tfvars",
			"-var-file=../terraform.tfvars"
		]
	}
}

