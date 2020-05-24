#!/usr/bin/env bash

db_image=vitaliikobrin/arangodb
data_volume=ArangoDB_Data
db_container_name=test-arangodb

echo
echo Create volume for DB
docker volume create $data_volume

echo
echo Create network
docker network create app_network

echo
echo Run DB container based on $db_image image
docker run -d \
	--name $db_container_name \
	--network=app_network \
	-v $data_volume:/var/lib/arangodb3 \
	-v "$(pwd)"/backups:/artifacts \
	-p 8529:8529 \
	--env-file arangodb-properties.env \
	--ulimit nofile=65535:65535 \
	$db_image
