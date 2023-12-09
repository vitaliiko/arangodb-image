#!/usr/bin/env bash

backups_dir=$AWS_WORKING_S3_BUCKET/$AWS_S3_BACKUP_DIR
files_list=$(aws s3 ls s3://${backups_dir}/ | grep ${BACKUP_DIR_NAME})
backup_files_count=$(echo "$files_list" | wc -l)

if [ "$backup_files_count" -gt "$ARANGO_BACKUP_FILES_COUNT" ]
then
  files_to_remove=$(echo "$files_list" \
    | head -n -$ARANGO_BACKUP_FILES_COUNT \
    | awk -v backup_path="$backups_dir" '{print "s3://"backup_path"/"$4}')

  if [[ $? -ne 0 ]]
  then
    echo "Failed get list of backups"
    exit 1
  fi

  echo "Removing obsolete backup files"
  echo $files_to_remove | xargs -n1 aws s3 rm

  if [[ $? -ne 0 ]]
  then
    echo "Failed remove obsolete backup files"
    exit 1
  fi

  echo Obsolete backups are cleaned up

else
  echo Skip obsolete backups removing
fi
