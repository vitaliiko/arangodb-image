FROM arangodb:3.6.1

RUN apk update && apk upgrade && apk add bash curl

# Install AWS CLI
RUN apk update && apk upgrade \
	&& apk add --no-cache bash curl python3 \
	&& python3 -V \
	&& curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py" \
    && python3 get-pip.py \
    && pip install --no-cache-dir awscli \
    && pip install -U pip \
    && aws --version

COPY scripts .

CMD ./set-up-backup-by-schedule.sh \
	&& arangod --log.level queries=debug --server.descriptors-minimum 128
