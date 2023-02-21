FROM debian:11-slim

ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

RUN apt-get -y update \
	&& apt-get install -y curl wget sqlite3 \
	&& apt-get clean

COPY ./root /

RUN chmod + /gitea_script.sh
RUN /gitea_script.sh

CMD ["sleep","infinity"]
