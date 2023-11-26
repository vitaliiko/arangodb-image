#!/usr/bin/env bash

artifacts_dir=backup_artifacts
current_date_time=$(date '+%Y-%m-%d-%H-%M-%S')
backup_name=$BACKUP_DIR_NAME-$current_date_time.tar.gz

mkdir -p $artifacts_dir && cd $artifacts_dir

print_log () {
  echo
  echo $(date '+%Y-%m-%dT%H:%M:%SZ') "|" $1
}

print_log "Prepare $ARANGO_DB_NAME database backup"
arangodump \
  --server.endpoint tcp://${ARANGO_HOST}:${ARANGO_PORT} \
  --server.username ${ARANGO_USER} \
  --server.password ${ARANGO_ROOT_PASSWORD} \
  --server.database ${ARANGO_DB_NAME} \
  --output-directory ${BACKUP_DIR_NAME} \
  --compress-output

print_log "Compress $ARANGO_DB_NAME database backup"
tar -zcvf $backup_name $BACKUP_DIR_NAME/

print_log "Upload backup to S3"
aws s3 cp $backup_name s3://$AWS_WORKING_S3_BUCKET/backups/

print_log "Remove $ARANGO_DB_NAME database backup artifacts"
rm -rf $BACKUP_DIR_NAME

/remove-obsolete-backup-files.sh

print_log "Done!"
