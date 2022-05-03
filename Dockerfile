FROM debian:bookworm-slim

WORKDIR /var/www

RUN apt-get update \
	&& apt-get install wget -y \
	&& rm -rf /var/lib/apt/lists/*

RUN wget https://install.speedtest.net/ooklaserver/ooklaserver.sh && chmod a+x ooklaserver.sh
RUN ./ooklaserver.sh install -f
RUN rm ooklaserver.sh

# Disables useLetsEncrypt to use Traefik
RUN echo 'OoklaServer.ssl.useLetsEncrypt = false' >> OoklaServer.properties

RUN useradd --create-home --shell /bin/bash guest
USER guest

EXPOSE 8080 5060

ARG DEBIAN_FRONTEND=noninteractive

LABEL maintainer="f.fabrizi@m-lab.it"

CMD ["./OoklaServer", "start"]