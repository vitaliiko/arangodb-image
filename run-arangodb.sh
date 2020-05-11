#!/usr/bin/env bash

echo
echo Create volume for DB
docker volume create ArangoDB_Data
echo Volume created

echo
echo Run DB container based on vitaliikobrin/arangodb image
docker run -d \
	--name $db_container_name \
	--network=app_network \
	-v ArangoDB_Data:/var/lib/arangodb3 \
	-v "$(pwd)"/backups:/artifacts \
	-p 8529:8529 \
	--env-file arangodb-properties.env \
	--ulimit nofile=65535:65535 \
	vitaliikobrin/arangodb
