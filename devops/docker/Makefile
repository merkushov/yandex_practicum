ifndef VERBOSE
.SILENT:
endif

ifeq ($(STAGE), prod)
DOCKER_COMPOSE_FILE=-f docker-compose.prod.yml
else ifeq ($(STAGE), test)
DOCKER_COMPOSE_FILE=-f docker-compose.test.yml
else
DOCKER_COMPOSE_FILE=-f docker-compose.dev-volumes.yml -f docker-compose.$(STAGE).yml --env-file ../.dev.env
endif

DOCKER_COMPOSE=docker-compose $(DOCKER_COMPOSE_FILE)

# имя контейнеров в docker-compose
DOCKER_ADMIN=s1_admin
DOCKER_ADMIN_PG=s1_admin_pg
DOCKER_NGINX=s2_nginx
DOCKER_ETL=s3_etl
DOCKER_MOVIE_ES=s4_movie_es
DOCKER_MOVIE_API=s4_movie_api
DOCKER_MOVIE_REDIS=s4_movie_redis
DOCKER_AUTH_API=s5_auth_api
DOCKER_AUTH_PG=s5_auth_pg
DOCKER_AUTH_REDIS=s5_auth_redis

help:	## список доступных команд для make
	@grep -E '^[a-zA-Z0-9_\-\/]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'
	@echo "(Other less used targets are available, open Makefile for details)"
.PHONY: help

# вызвать настройщики для стейджей, при вызове глобального setup_stage
ifeq ($(STAGE), dev-sprint2)
setup_stage: setup setup_stage_sprint2
else ifeq ($(STAGE), dev-sprint3)
setup_stage: setup setup_stage_sprint3
else ifeq ($(STAGE), dev-sprint4)
setup_stage: setup setup_stage_sprint4
else ifeq ($(STAGE), dev-sprint6)
setup_stage: setup setup_stage_sprint6
else ifeq ($(STAGE), dev)
setup_stage: setup setup_stage_dev
else ifeq ($(STAGE), test)
setup_stage: setup setup_stage_test
else
setup_stage: no_stage_config
endif

setup:
	@make env_setup
	@make destroy
	@make build
	@make up
.PHONY: setup

setup_stage:
	@echo "Stage setup complete"
.PHONY: stage_setup

setup_stage_dev:	## настроить dev stage
	@echo "Setup $(STAGE)"
	@make admin_pg/waiting_for_readiness
	@make admin/init
	@make movie_es/waiting_for_readiness
	@make etl/init
	@make auth_pg/waiting_for_readiness
	@make auth_api/init
.PHONY: setup_stage_dev

setup_stage_test:	## настроить test stage
	@echo "Setup $(STAGE)"
	@make admin_pg/waiting_for_readiness
	@make admin/init
	@make movie_es/waiting_for_readiness
	@make etl/init
	@make auth_pg/waiting_for_readiness
	@make auth_api/init
.PHONY: setup_stage_dev

setup_stage_sprint2:	## настроить содержимое контейнеров для спринта 2
	@echo "Setup $(STAGE)"
	@make admin_pg/waiting_for_readiness
	@make admin/init
.PHONY: setup_stage_sprint2

setup_stage_sprint3:	## настроить содержимое контейнеров для спринта 3
	@echo "Setup $(STAGE)"
	@make admin_pg/waiting_for_readiness
	@make admin/init
	@make movie_es/waiting_for_readiness
	@make etl/init
.PHONY: setup_stage_sprint3

setup_stage_sprint4:	## настроить содержимое контейнеров для спринта 4
	@echo "Setup $(STAGE)"
	@make admin_pg/waiting_for_readiness
	@make admin/init
	@make movie_es/waiting_for_readiness
	@make etl/init
.PHONY: setup_stage_sprint4

setup_stage_sprint6:	## настроить содержимое контейнеров для спринта 6
	@echo "Setup $(STAGE)"
	@make auth_pg/waiting_for_readiness
	@make auth_api/init
.PHONY: setup_stage_sprint6

no_stage_config:
	@echo "There is no setup config for STAGE=$(STAGE)"

env_setup:	## настройка переменных окружения для dev|test
	@cp ../env_example/s1_admin_pg.env ../.s1_admin_pg.env
	@cp ../env_example/s1_admin.env ../.s1_admin.env
	@cp ../env_example/s2_nginx.env ../.s2_nginx.env
	@cp ../env_example/s3_etl.env ../.s3_etl.env
	@cp ../env_example/s4_movie_api.env ../.s4_movie_api.env
	@cp ../env_example/s4_movie_es.env ../.s4_movie_es.env
	@cp ../env_example/s4_movie_redis.env ../.s4_movie_redis.env
	@cp ../env_example/s5_auth_api.env ../.s5_auth_api.env
	@cp ../env_example/s5_auth_pg.env ../.s5_auth_pg.env
	@cp ../env_example/s5_auth_redis.env ../.s5_auth_redis.env
	@cp ../env_example/stage.dev.env ../.dev.env
	@cp ../env_example/stage.prod.env ../.prod.env
	@cp ../env_example/stage.test.env ../.test.env

	# сгенерировать рандомные пароли для PostgreSQL
	`env LC_CTYPE=C tr -dc 'a-zA-Z0-9' < /dev/urandom | head -c 42 | xargs -i sed -i -e 's/POSTGRES_PASSWORD=[a-zA-Z0-9]*/POSTGRES_PASSWORD={}/' -e 's/DB_PASSWORD=[a-zA-Z0-9]*/DB_PASSWORD={}/' ../.s1_admin_pg.env`
	`env LC_CTYPE=C tr -dc 'a-zA-Z0-9' < /dev/urandom | head -c 42 | xargs -i sed -i -e 's/POSTGRES_PASSWORD=[a-zA-Z0-9]*/POSTGRES_PASSWORD={}/' -e 's/DB_PASSWORD=[a-zA-Z0-9]*/DB_PASSWORD={}/' ../.s5_auth_pg.env`

	# сгенерировать рандомный пароль для суперпользователя в Django
	`env LC_CTYPE=C tr -dc 'a-zA-Z0-9' < /dev/urandom | head -c 10 | xargs -i sed -i 's/DJANGO_SUPERUSER_PASSWORD=[a-zA-Z0-9]*/DJANGO_SUPERUSER_PASSWORD={}/' ../.s1_admin.env`

	# сгенерировать рандомный SECRET_KEY
	`env LC_CTYPE=C tr -dc 'a-zA-Z0-9' < /dev/urandom | head -c 32 | xargs -i sed -i 's/SECRET_KEY=[a-zA-Z0-9\-]*/SECRET_KEY={}/' ../.s1_admin.env`
	`env LC_CTYPE=C tr -dc 'a-zA-Z0-9' < /dev/urandom | head -c 32 | xargs -i sed -i 's/SECRET_KEY=[a-zA-Z0-9\-]*/SECRET_KEY={}/' ../.s5_auth_api.env`

	# сгенерировать рандомный JWT_SECRET_KEY
	`env LC_CTYPE=C tr -dc 'a-zA-Z0-9' < /dev/urandom | head -c 32 | xargs -i sed -i 's/JWT_SECRET_KEY=[a-zA-Z0-9\-]*/JWT_SECRET_KEY={}/' ../.s5_auth_api.env`

	# установить HOST_UID = UID текущего пользователя. Это влияет на UID пользователя внутри контейнера.
	# Нужно для совместимости прав доступа к сгенерированным файлам у хостового пользователя
	`id -u | xargs -i sed -i 's/HOST_UID=.*/HOST_UID={}/' ../.dev.env`
	`id -g | xargs -i sed -i 's/HOST_GID=.*/HOST_GID={}/' ../.dev.env`
.PHONY: env_setup

show_docker_compose:
	@echo $(DOCKER_COMPOSE)
.PHONY: show_docker_compose

#
# Докер
#

build:	## построить все контейнеры
	$(DOCKER_COMPOSE) build
.PHONY: build

up:		## поднять контейнеры окружения в фоновом режиме
	$(DOCKER_COMPOSE) up -d
.PHONY: up

down:	## остановить все контейнеры
	$(DOCKER_COMPOSE) down
.PHONY: down

destroy:	## удалить все контейнеры и очистить данные
	$(DOCKER_COMPOSE) down --volumes --remove-orphans
.PHONY: destroy

#
# Административная панель
#

admin/init:	## инициализировать Административную панель
	$(DOCKER_COMPOSE) exec $(DOCKER_ADMIN) python manage.py migrate --noinput
	$(DOCKER_COMPOSE) exec $(DOCKER_ADMIN) python manage.py createsuperuser --noinput
	$(DOCKER_COMPOSE) exec $(DOCKER_ADMIN) python manage.py compilemessages
	$(DOCKER_COMPOSE) exec $(DOCKER_ADMIN) python manage.py collectstatic --no-input --clear
	$(DOCKER_COMPOSE) exec $(DOCKER_ADMIN) python manage.py loaddata test_data.json
.PHONY: admin/init

admin/bash:		## доступ в контейнер
	$(DOCKER_COMPOSE) exec $(DOCKER_ADMIN) bash
.PHONY: admin/bash

admin/log:	## посмотреть логи контейнера Админки
	$(DOCKER_COMPOSE) logs --follow $(DOCKER_ADMIN)
.PHONY: admin/log

admin/fake_data:	## загрузить фейковых данных для тестирования
	$(DOCKER_COMPOSE) exec $(DOCKER_ADMIN) python manage.py fake_data --count_genres 100 --count_persons 3000 --count_movies 20000
.PHONY: admin/fake_data

#
# База данных Административной панели
#

admin_pg/bash:		## доступ в контейнер с БД
	$(DOCKER_COMPOSE) exec $(DOCKER_ADMIN_PG) bash
.PHONY: admin_pg/bash

admin_pg/log:		## посмотреть логи контейнера БД
	$(DOCKER_COMPOSE) logs --follow $(DOCKER_ADMIN_PG)
.PHONY: admin_pg/log

admin_pg/psql:		## интерактивный терминал PostgreSQL
	$(DOCKER_COMPOSE) exec $(DOCKER_ADMIN_PG) bash -c 'psql -U $${POSTGRES_USER} $${POSTGRES_DB}'
.PHONY: admin_pg/psql

admin_pg/waiting_for_readiness:
	$(DOCKER_COMPOSE) exec $(DOCKER_ADMIN_PG) bash -c 'until pg_isready 2>/dev/null; do sleep 1 ; done; echo "Database ready."'
.PHONY: admin_pg/waiting_for_readiness

#
# Nginx (внешний) общий для всех сервисов
#

nginx/bash:		## доступ в контейнер c Nginx
	$(DOCKER_COMPOSE) exec $(DOCKER_NGINX) bash
.PHONY: nginx/bash

nginx/log:		## посмотреть логи контейнера Nginx
	$(DOCKER_COMPOSE) logs --follow $(DOCKER_NGINX)
.PHONY: nginx/log

#
# ETL - Сервис по перекачиванию данных из Админки в MovieAPI
#

etl/init:	## инициализирует ElasticSearch
	$(DOCKER_COMPOSE) exec $(DOCKER_ETL) bash -c 'python3 init_es.py'
.PHONY: etl/init

etl/bash:	## доступ в контейнер с ETL
	$(DOCKER_COMPOSE) exec $(DOCKER_ETL) bash
.PHONY: etl/bash

etl/log: 	## посмотреть логи контейнера etl
	$(DOCKER_COMPOSE) logs --follow $(DOCKER_ETL)
.PHONY: etl/log

etl/test: 	## авто-тесты внутри контейнера
	$(DOCKER_COMPOSE) exec $(DOCKER_ETL) bash -c 'PYTHONPATH=. pytest -rP tests'
.PHONY: etl/test

# etl/pipe:	## запустить pipe перекачки данных из Pg в ES
# 	$(DOCKER_COMPOSE) exec $(DOCKER_ETL) python etl.py
# .PHONY: etl/pipe

#
# MovieAPI
#

movie_api/bash:	## доступ к контейнеру с MovieAPI
	$(DOCKER_COMPOSE) exec $(DOCKER_MOVIE_API) bash
.PHONY: api/bash

movie_api/log:	## логи контейнера
	$(DOCKER_COMPOSE) logs --follow $(DOCKER_MOVIE_API)
.PHONY: api/logs

#
# ElasticSearch сервиса MovieAPI
#

movie_es/bash:	## доступ в контейнер с ElasticSearch
	$(DOCKER_COMPOSE) exec $(DOCKER_MOVIE_ES) bash
.PHONY: movie_es/bash

movie_es/waiting_for_readiness:
	$(DOCKER_COMPOSE) exec $(DOCKER_MOVIE_ES) bash -c 'until curl --silent --output /dev/null http://localhost:9200/_cat/health?h=st; do printf "."; sleep 5; done; echo "ES ready."'
.PHONY: movie_es/waiting_for_readiness

#
# Redis сервиса MovieAPI
#

movie_redis/bash:	## доступ в контейнер с Redis сервиса MovieAPI
	$(DOCKER_COMPOSE) exec $(DOCKER_MOVIE_REDIS) bash
.PHONY: movie_redis/bash

movie_redis/waiting_for_readiness:	## ожидать готовности Redis сервиса AuthAPI
	$(DOCKER_COMPOSE_TEST) exec $(DOCKER_MOVIE_REDIS) sh -c 'until redis-cli -u redis://localhost:6379 ping 1>/dev/null; do printf "."; sleep 1; done; echo "Redis ready."'
.PHONY: movie_redis/waiting_for_readiness

#
# AuthAPI
#

auth_api/init:	## инициализировать контейнер AuthAPI
	@make auth_api/migrate
.PHONY: auth_api/init

auth_api/bash:		## доступ в контейнер с Django
	$(DOCKER_COMPOSE) exec $(DOCKER_AUTH_API) bash
.PHONY: auth_api/bash

auth_api/log:	## посмотреть логи контейнера Приложения
	$(DOCKER_COMPOSE) logs --follow $(DOCKER_AUTH_API)
.PHONY: auth_api/log

auth_api/migrate:	## применить миграции
	$(DOCKER_COMPOSE) exec $(DOCKER_AUTH_API) flask db upgrade
.PHONY: auth_api/migrate


#
# База данных сервиса AuthAPI
#

auth_pg/bash:		## доступ в контейнер с БД сервиса AuthAPI
	$(DOCKER_COMPOSE) exec $(DOCKER_AUTH_PG) bash
.PHONY: auth_pg/bash

auth_pg/log:		## посмотреть логи контейнера БД сервиса AuthAPI
	$(DOCKER_COMPOSE) logs --follow $(DOCKER_AUTH_PG)
.PHONY: auth_pg/log

auth_pg/psql:		## интерактивный терминал PostgreSQL
	$(DOCKER_COMPOSE) exec $(DOCKER_AUTH_PG) bash -c 'psql -U $${POSTGRES_USER} $${POSTGRES_DB}'
.PHONY: auth_pg/psql

auth_pg/waiting_for_readiness:	## ожидать готовности PostgreSQL
	$(DOCKER_COMPOSE) exec $(DOCKER_AUTH_PG) bash -c 'until pg_isready 2>/dev/null; do sleep 1 ; done; echo "Database ready."'
.PHONY: auth_pg/waiting_for_readiness

#
# Redis сервиса AuthAPI
#

auth_redis/bash:	## доступ в контейнер с Redis сервиса AuthAPI
	$(DOCKER_COMPOSE) exec $(DOCKER_AUTH_REDIS) bash
.PHONY: auth_redis/bash

auth_redis/waiting_for_readiness:	## ожидать готовности Redis сервиса AuthAPI
	$(DOCKER_COMPOSE_TEST) exec $(DOCKER_AUTH_REDIS) sh -c 'until redis-cli -u redis://localhost:6379 ping 1>/dev/null; do printf "."; sleep 1; done; echo "Redis ready."'
.PHONY: auth_redis/waiting_for_readiness