FROM arangodb:3.8.1

# Install AWS CLI
RUN apk update && apk upgrade \
	&& apk add --no-cache bash curl python3 \
	&& rm -rf /var/cache/apk/* \
	&& python3 -V \
	&& curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py" \
	&& python3 get-pip.py \
	&& pip install --no-cache-dir awscli \
	&& pip install -U pip \
	&& aws --version

COPY scripts .

CMD ./set-up-backup-by-schedule.sh && ./run-arangodb.sh
