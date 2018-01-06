#makefile for building and running this docker image
# import config.
# You can change the default config with `make cnf="config_special.env" build`
cnf ?= config.env
include $(cnf)
export $(shell sed 's/=.*//' $(cnf))

# import deploy config
# You can change the default deploy config with `make cnf="deploy_special.env" release`
dpl ?= deploy.env
include $(dpl)
export $(shell sed 's/=.*//' $(dpl))

# grep the version from the mix file
VERSION=$(shell ./version.sh)


# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help


# DOCKER TASKS
# Build the container
build: ## Build the container
	docker build -t $(APP_NAME) .

build-nc: ## Build the container without caching
	docker build --no-cache -t $(APP_NAME) .

run: ## Run container on port configured in `config.env`
	docker run -i -t --privileged --rm --device /dev/ttyAMA0:/dev/ttyAMA0 --device /dev/mem:/dev/mem --env-file=./config.env -p=$(PORT):$(PORT) --name="$(CONTAINER_NAME)" $(APP_NAME)


shell: ## Run and get access to the container's shell without starting NodeRED
	docker run -i -t --privileged --device /dev/ttyAMA0:/dev/ttyAMA0 --device /dev/mem:/dev/mem --env-file=./config.env -p=$(PORT):$(PORT) --name="$(CONTAINER_NAME)" --entrypoint /bin/sh $(APP_NAME)

up: build run ## Run container on port configured in `config.env` (Alias to run)

stop: ## Stop and remove a running container
	docker stop $(CONTAINER_NAME); docker rm $(CONTAINER_NAME)

release: build-nc tag ## Make a release by building and tagging the `{version}` and `latest` versions of the image

# Docker tagging
tag: tag-latest tag-version ## Generate container tags for the `{version}` ans `latest` tags

tag-latest: ## Generate container `{version}` tag
	@echo 'create tag latest'
	docker tag $(APP_NAME) $(DOCKER_REPO)/$(APP_NAME):latest

tag-version: ## Generate container `latest` tag
	@echo 'create tag $(VERSION)'
	docker tag $(APP_NAME) $(DOCKER_REPO)/$(APP_NAME):$(VERSION)

version: ## Output the current version
	@echo $(VERSION)
