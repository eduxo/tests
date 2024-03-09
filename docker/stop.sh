#!/bin/bash

docker stop rh124
docker container rm rh124
docker image rm centos-rh124:latest
