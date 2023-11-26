#!/usr/bin/env bash

artifacts_dir=backup_restore_artifacts
backups_dir=$AWS_WORKING_S3_BUCKET/backups

print_log () {
  echo
  echo $(date '+%Y-%m-%dT%H:%M:%SZ') "|" $1
}

latest_backup_file_name=$(aws s3 ls s3://${backups_dir}/ --recursive | awk '{print $4}' | sort | tail -n 1)

print_log "Latest DB backup is $latest_backup_file_name"

mkdir -p $artifacts_dir && cd $artifacts_dir

print_log "Download and unpack backup from S3"
echo $backups_dir/$latest_backup_file_name
aws s3 cp s3://$backups_dir/$latest_backup_file_name $latest_backup_file_name

print_log "Unzipping backup"
tar -zxvf $latest_backup_file_name

print_log "Restore backup"
arangorestore \
  --server.endpoint tcp://${ARANGO_HOST}:${ARANGO_PORT} \
  --server.username ${ARANGO_USER} \
  --server.password ${ARANGO_ROOT_PASSWORD} \
  --server.database ${ARANGO_DB_NAME} \
  --create-database true \
  --input-directory "$BACKUP_DIR_NAME"

print_log "Remove database backup artifacts"
rm -rf $artifacts_dir

print_log "Done!"
