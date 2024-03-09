#!/bin/bash

docker build -t centos-rh124 .
docker run -h rh124.eduxo.lab -d -p 80:80 -p 22:22 --name rh124 centos-rh124:latest
docker container inspect rh124 | grep -i IPAddress | tail -n 1 | tr -d ' "'
