THIS_FILE := $(lastword $(MAKEFILE_LIST))
SHELL := /bin/bash
DEV_ECR := 606688274854.dkr.ecr.us-east-1.amazonaws.com/dev-todo-backend

.PHONY: build
build:
	docker build \
		-t todo-backend \
		.

.PHONY: localb
localb:
	rm -rf bin
	mkdir ./bin
	go build -o ./bin/main

.PHONY: localr
localr:
	$(MAKE) -f $(THIS_FILE) start_deps
	./bin/main

.PHONY: clean
clean:
	rm -rf ./bin
	$(MAKE) -f $(THIS_FILE) stop
	go clean

.PHONY: start
start:
	$(MAKE) -f $(THIS_FILE) start_deps
	sleep 5
	docker-compose up todo-backend

.PHONY: start_deps
start_deps:
	docker-compose up -d postgres

.PHONY: stop
stop:
	docker-compose down

.PHONY: publish
publish:
	docker tag todo-backend ${DEV_ECR}
	docker push ${DEV_ECR}:latest

.PHONY: prmote_test
promote_test:
	docker tag todo-backend ${DEV_ECR}
	docker push ${DEV_ECR}:latest
