# syntax=docker/dockerfile:1
FROM ubuntu:18.04

WORKDIR /CherrypyDocker

COPY gitea_deploy_key /CherrypyDocker
COPY gitea_deploy_key.pub /CherrypyDocker

ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN=true
## preesed tzdata, update package index, upgrade packages and install needed software
# RUN echo "tzdata tzdata/Areas select America" > /tmp/preseed.txt; \
#     echo "tzdata tzdata/Zones/America select New York" >> /tmp/preseed.txt; \
#     debconf-set-selections /tmp/preseed.txt && \
#     apt-get -o Acquire::Max-FutureTime=86400 update && \
#     apt-get install -y tzdata

RUN apt-get -o Acquire::Max-FutureTime=86400 update
RUN apt -y install software-properties-common
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get install -y curl
RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash -

RUN apt-get install --assume-yes \
    python3.6 \
    build-essential \
    nodejs \
    python3.6-dev \
    python2.7-dev \
    libldap2-dev \
    libsasl2-dev \
    slapd \
    ldap-utils \
    tox \
    lcov \
    valgrind \
    python3.6-venv \
    wget \
    mysql-client-core-5.7 \
    openssh-client \
    git \
    && apt-get clean

RUN wget https://bootstrap.pypa.io/pip/3.6/get-pip.py
RUN python3 get-pip.py

RUN mkdir -p -m 0600 ~/.ssh && \
    ssh-keyscan -H git.mindmodeling.org >> ~/.ssh/known_hosts
RUN cp gitea_deploy_key ~/.ssh/id_rsa
RUN cp gitea_deploy_key.pub ~/.ssh/id_rsa.pub

RUN chmod 0600 ~/.ssh/id_rsa