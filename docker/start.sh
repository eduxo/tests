#!/bin/bash

docker build -t ubuntu .
docker run -h ubuntu.eduxo.lab -d -p 80:80 -p 22:22 --name ubuntu ubuntu:latest
docker container inspect rh124 | grep -i IPAddress | tail -n 1 | tr -d ' "'
