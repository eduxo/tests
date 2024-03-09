#!/bin/bash

docker stop ubuntu
docker container rm ubuntu
docker image rm ubuntu:latest
