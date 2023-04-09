FROM ubuntu

RUN apt-get update && apt-get install -y curl tini

COPY entrypoint.sh /entrypoint.sh

CMD ["tini", "--", "/entrypoint.sh"]

