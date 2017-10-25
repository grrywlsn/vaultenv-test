FROM ubuntu:17.04
RUN apt-get -qq update && apt-get -qq -y install curl jq

ADD https://github.com/channable/vaultenv/releases/download/v0.5.0/vaultenv-0.5.0_x86_64-ubuntu-linux.2_x86_64-linux /usr/bin/vaultenv
RUN chmod +x /usr/bin/vaultenv

COPY write-env-to-file.sh /opt/write-env-to-file.sh
RUN chmod +x /opt/write-env-to-file.sh

ENTRYPOINT ["/opt/write-env-to-file.sh"]
