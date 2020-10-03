#!/usr/bin/env bash

backup_prefix="${ARANGO_DB_NAME}-${BAKCUP_NAME_SUFFIX}-backup"
s3_backup_dir=${ARANGO_S3_BACKUP_DIR}

files_list=$(aws s3 ls s3://${s3_backup_dir}/ | grep ${backup_prefix})
backup_files_count=$(echo "$files_list" | wc -l)

if [ "$backup_files_count" -gt "$ARANGO_BACKUP_FILES_COUNT" ]
then
    files_to_remove=$(echo "$files_list" \
        | head -n -$ARANGO_BACKUP_FILES_COUNT \
        | awk -v backup_path="$s3_backup_dir" '{print "s3://"backup_path"/"$4}')

    echo "Removing obsolete backup files"
    echo $files_to_remove | xargs -n1 aws s3 rm
fi
