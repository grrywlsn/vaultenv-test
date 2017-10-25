FROM frolvlad/alpine-glibc:latest

RUN apk add --update curl && \
    rm -rf /var/cache/apk/*

RUN curl -o /usr/bin/jq http://stedolan.github.io/jq/download/linux64/jq \
    && chmod +x /usr/bin/jq

RUN curl -o /usr/bin/vaultenv https://github.com/channable/vaultenv/releases/download/v0.5.0/vaultenv-0.5.0_x86_64-ubuntu-linux.2_x86_64-linux \
    && chmod +x /usr/bin/vaultenv

CMD ["vaultenv"]
