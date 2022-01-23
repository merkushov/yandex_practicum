FROM python:3.9

LABEL maintainer="Victor Merkushov <merkushov.victor@gmail.com>"

RUN apt-get -y update \
    && apt-get install -y gettext

# Нам нужно создать пользователя с таким же UID
# как и у хостового пользователя
ARG uid=1000
ARG gid=1000

ENV USER=ticket_man
ENV GROUP=ticket_man
ENV HOMEDIR=/home/${USER}
ENV APP_HOME=/usr/src/app
ENV APP_STATIC=/usr/src/app/static
ENV APP_REQUIREMENTS=/usr/src/app/requirements
ENV PATH="/home/${USER}/.local/bin:${PATH}"

RUN mkdir $APP_HOME
RUN mkdir static
RUN mkdir $APP_REQUIREMENTS
WORKDIR $APP_HOME

RUN groupadd -g $gid ${GROUP} && \
    useradd -d ${HOMEDIR} -s /bin/bash -u $uid -g $gid ${USER} && \
    mkdir ${HOMEDIR} && \
    chown -R ${USER}:${GROUP} ${HOMEDIR}

# copy project
COPY --chown=${USER}:${USER} services/s1_admin/movies_admin ${APP_HOME}

# обход ограничения на монтирование папки не под root пользователем
RUN chown -R ${USER}:${GROUP} $APP_HOME

USER ${USER}

# устанавливаем пакеты под обычным пользователем
COPY --chown=${USER}:${USER} services/s1_admin/movies_admin/requirements ${APP_REQUIREMENTS}
RUN pip install --upgrade pip
RUN pip install -r ./requirements/dev.txt