#!/usr/bin/env bash

db_image_name=vitaliikobrin/arangodb:2.2.1

docker build -t $db_image_name .
docker push $db_image_name
