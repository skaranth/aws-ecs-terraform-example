THIS_FILE := $(lastword $(MAKEFILE_LIST))
SHELL := /bin/bash

apply:
	./env/run_terraform.sh $(env) $(module)

apply_setup:
	$(MAKE) -f $(THIS_FILE) apply env=$(env) module=setup