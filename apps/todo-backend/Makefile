THIS_FILE := $(lastword $(MAKEFILE_LIST))
SHELL := /bin/bash

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

# .PHONY clean
# clean:
# 	docker stop $(docker ps -a -q)
# 	docker rm $(docker ps -a -q)
# 	docker rmi $(docker images -q)
# 	go clean
#
# .PHONY start
# start:
# 	docker-compose up
#
# .PHONY stop
# stop:
# 	docker-compose down
#
