ifndef VERBOSE
.SILENT:
endif

.DEFAULT_GOAL := help

help:	## список доступных команд
	@grep -E '^[a-zA-Z0-9_\-\/]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'
	@echo "(Other less used targets are available, open Makefile for details)"
.PHONY: help

# вызываем make находящийся в подкаталоге с настройками окружения
SUBMAKE_DEVOPS=$(MAKE) --silent -C devops/docker

setup:	## настроить окружение для разработки/тестирования
	$(SUBMAKE_DEVOPS) setup_stage
.PHONY: setup

up: ## поднять уже настроенное окружение
	$(SUBMAKE_DEVOPS) up
.PHONY: up

down:	## опустить запущенное окружение
	$(SUBMAKE_DEVOPS) down
.PHONY: down

#
# Доступ в консоль уже запущенных контейнеров
#

bash/admin:	## подключиться к консоли контейнера Админки
	$(SUBMAKE_DEVOPS) admin/bash

bash/admin_pg:	## подключиться к консоли БД Админки
	$(SUBMAKE_DEVOPS) admin_pg/bash

bash/nginx:	## подключиться к консоли Nginx
	$(SUBMAKE_DEVOPS) nginx/bash

bash/etl:	## подключиться к консоли ETL
	$(SUBMAKE_DEVOPS) etl/bash

bash/movie_api:	## подключиться к консоли MovieAPI
	$(SUBMAKE_DEVOPS) movie_api/bash

bash/movie_es:	## подключиться к консоли ES сервиса MovieAPI
	$(SUBMAKE_DEVOPS) movie_es/bash

bash/auth_api:	## подключиться к консоли AuthAPI
	$(SUBMAKE_DEVOPS) auth_api/bash

bash/auth_pg:	## подключиться к консоли БД сервиса AuthAPI
	$(SUBMAKE_DEVOPS) auth_pg/bash

bash/auth_redis:	## подключиться к консоли Redis сервиса AuthAPI
	$(SUBMAKE_DEVOPS) auth_redis/bash

.PHONY: bash/admin, bash/admin_pg, bash/nginx, bash/etl, bash/movie_api, bash/movie_es, bash/auth_api, bash/auth_pg, auth_redis/bash