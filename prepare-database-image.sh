#!/usr/bin/env bash

db_image_name=vitaliikobrin/arangodb

docker build -t $db_image_name .
docker push $db_image_name
