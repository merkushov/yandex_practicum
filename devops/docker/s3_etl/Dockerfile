FROM python:3.9.7-slim-bullseye

LABEL maintainer="Victor Merkushov <merkushov.victor@gmail.com>"

RUN apt-get -y update \
    && apt-get install -y gcc musl-dev libpq-dev

# Нам нужно создать пользователя с таким же UID
# как и у хостового пользователя
ARG uid=1000
ARG gid=1000

ENV USER=delivery_man
ENV GROUP=delivery_man
ENV HOMEDIR=/home/${USER}
ENV APP_HOME=/usr/src/app
ENV APP_STATIC=/usr/src/app/static
ENV APP_REQUIREMENTS=/usr/src/app/requirements
ENV PATH="/home/${USER}/.local/bin:${PATH}"

RUN mkdir $APP_HOME
RUN mkdir $APP_REQUIREMENTS

WORKDIR $APP_HOME

RUN groupadd -g $gid ${GROUP} && \
    useradd -d ${HOMEDIR} -s /bin/bash -u $uid -g $gid ${USER} && \
    mkdir ${HOMEDIR} && \
    chown -R ${USER}:${GROUP} ${HOMEDIR}

RUN chown -R ${USER}:${GROUP} ${APP_HOME}

RUN apt-get install -y vim make curl git tree jq

COPY --chown=${USER}:${GROUP} services/s3_etl/postgres_to_es ${APP_HOME}

USER ${USER}

COPY --chown=${USER}:${USER} services/s3_etl/postgres_to_es/requirements.txt "${APP_REQUIREMENTS}/requirements.txt"
RUN pip install --upgrade pip
RUN pip install -r ./requirements.txt