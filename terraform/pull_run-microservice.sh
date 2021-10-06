#!/bin/bash

function update_install() {
  yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
  yum update -y
  yum install -y yum-utils device-mapper-persistent-data lvm2
  yum install -y docker

}

function docker_utiles() {
  systemctl start docker
  systemctl enable docker
  usermod -aG docker centos
  usermod -aG docker $(whoami)
}

function pull_run() {
  docker pull amitshochat66/app:latest
  docker run --name app-alpine -p 80:5000 amitshochat66/app:latest

}

update_install
docker_utiles
pull_run
echo "app.py running"
