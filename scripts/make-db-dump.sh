#!/usr/bin/env bash

backup_directory_name="${ARANGO_DB_NAME}-${STAGE}-backup"

cd artifacts

echo $(date '+%Y-%m-%dT%H:%M:%SZ') "|" Prepare $ARANGO_DB_NAME $STAGE database backup
echo 

arangodump \
	--server.username ${ARANGO_USER} \
	--server.password ${ARANGO_ROOT_PASSWORD} \
	--server.database ${ARANGO_DB_NAME} \
	--output-directory ${backup_directory_name} \
	--compress-output

echo
echo $(date '+%Y-%m-%dT%H:%M:%SZ') "|" Compress $ARANGO_DB_NAME $STAGE database backup
echo

current_date_time=$(date '+%Y-%m-%d-%H-%M-%S')
tar -zcvf $backup_directory_name-$current_date_time.tar.gz $backup_directory_name/

echo
echo $(date '+%Y-%m-%dT%H:%M:%SZ') "|" Remove $ARANGO_DB_NAME $STAGE database backup artifacts
echo

rm -rf $backup_directory_name

echo 
echo $(date '+%Y-%m-%dT%H:%M:%SZ') "|" Done!
