ifndef VERBOSE
.SILENT:
endif

ifeq ($(STAGE), prod)
DOCKER_COMPOSE_FILE=-f docker-compose.prod.yml
else
DOCKER_COMPOSE_FILE=-f docker-compose.dev.yml
endif

DOCKER_COMPOSE=docker-compose -f docker-compose.yml $(DOCKER_COMPOSE_FILE)
DOCKER_COMPOSE_TEST=docker-compose -f docker-compose.test.yml

help:	## список доступных команд
	@grep -E '^[a-zA-Z0-9_\-\/]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'
	@echo "(Other less used targets are available, open Makefile for details)"
.PHONY: help