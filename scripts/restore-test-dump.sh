#!/usr/bin/env bash
arangod &

mkdir test-dump
tar -zxf ${ARANGO_TEST_BACKUP_PATH} -C test-dump

sleep 5

arangorestore \
    --server.username ${ARANGO_USER} \
    --server.password '' \
    --server.database ${ARANGO_DB_NAME} \
    --create-database true \
    --input-directory "test-dump"
