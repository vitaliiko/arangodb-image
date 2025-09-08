#!/usr/bin/env bash

x86_image_name=vitaliikobrin/arangodb:2.2.3
arm_image_name=vitaliikobrin/arangodb:2.2.4-arm

docker build -t $x86_image_name .
docker push $x86_image_name

docker build -t $arm_image_name -f Dockerfile.arm .
docker push $arm_image_name
