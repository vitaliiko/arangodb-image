#!/usr/bin/env bash

if [ "$ARANGO_DB_RUN_OPTION" == "MINIMUM_MEMORY_USAGE" ]; then
    arangod --log.level queries=warn \
        --server.descriptors-minimum 1024 \
        --rocksdb.max-total-wal-size 1024000 \
        --rocksdb.write-buffer-size 2048000 \
        --rocksdb.max-write-buffer-number 2 \
        --rocksdb.total-write-buffer-size 81920000 \
        --rocksdb.dynamic-level-bytes false \
        --rocksdb.block-cache-size 2560000 \
        --rocksdb.enforce-block-cache-size-limit true
else
    arangod --log.level queries=debug \
        --server.descriptors-minimum 128
fi