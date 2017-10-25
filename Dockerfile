FROM busybox:glibc
RUN apt-get -qq update && apt-get -qq -y install curl jq

ADD https://github.com/channable/vaultenv/releases/download/v0.5.0/vaultenv-0.5.0_x86_64-ubuntu-linux.2_x86_64-linux /usr/bin/vaultenv
RUN chmod +x /usr/bin/vaultenv

CMD ["vaultenv"]
