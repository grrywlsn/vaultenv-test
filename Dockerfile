FROM frolvlad/alpine-glibc:latest

RUN apk add --update curl bash && \
    rm -rf /var/cache/apk/*

RUN curl -L -k -o /usr/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 \
    && chmod +x /usr/bin/jq

RUN curl -L -k -o /usr/bin/vaultenv https://github.com/channable/vaultenv/releases/download/v0.5.0/vaultenv-0.5.0_x86_64-ubuntu-linux.2_x86_64-linux \
    && chmod +x /usr/bin/vaultenv

CMD ["vaultenv"]
