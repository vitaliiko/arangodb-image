#!/usr/bin/env bash

artifacts_dir=backup_restore_artifacts
backups_dir=$AWS_WORKING_S3_BUCKET/$AWS_S3_BACKUP_DIR

print_log () {
  echo
  echo $(date '+%Y-%m-%dT%H:%M:%SZ') "|" $1
}

latest_backup_file_name=$(aws s3 ls s3://${backups_dir}/ | awk '{print $4}' | sort | tail -n 1)

if [[ $? -ne 0 ]]
then
  print_log "Failed to get list of backups"
  exit 1
fi

print_log "Latest DB backup file is $latest_backup_file_name"

mkdir -p $artifacts_dir && cd $artifacts_dir

print_log "Download and unpack $backups_dir/$latest_backup_file_name file from S3"
aws s3 cp s3://$backups_dir/$latest_backup_file_name $latest_backup_file_name

if [[ $? -ne 0 ]]
then
  print_log "Failed to download backup file"
  exit 1
fi

print_log "Unzipping backup"
tar -zxvf $latest_backup_file_name

if [[ $? -ne 0 ]]
then
  print_log "Failed to unzip backup"
  exit 1
fi

print_log "Restore backup"
arangorestore \
  --server.endpoint tcp://${ARANGO_HOST}:${ARANGO_PORT} \
  --server.username ${ARANGO_USER} \
  --server.password ${ARANGO_ROOT_PASSWORD} \
  --server.database ${ARANGO_DB_NAME} \
  --create-database true \
  --input-directory "$BACKUP_DIR_NAME"

if [[ $? -ne 0 ]]
then
  print_log "Failed to restore backup"
  exit 1
fi

print_log "Remove database backup artifacts"
rm -rf $artifacts_dir

print_log "Done!"
