FROM arangodb:3.6.1

COPY scripts .

CMD arangod --log.level queries=debug --server.descriptors-minimum 128
