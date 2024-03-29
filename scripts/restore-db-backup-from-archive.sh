#!/usr/bin/env bash

print_log "Unzipping backup"
tar -zxvf resources/db-backup.tar.gz

print_log "Restore backup"
arangorestore \
  --server.endpoint tcp://${ARANGO_HOST}:${ARANGO_PORT} \
  --server.username ${ARANGO_USER} \
  --server.password ${ARANGO_ROOT_PASSWORD} \
  --server.database ${ARANGO_DB_NAME} \
  --create-database true \
  --input-directory ${BACKUP_DIR_NAME}

print_log "Done!"
