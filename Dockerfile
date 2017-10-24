FROM alpine:latest
RUN apk add --update curl && rm -rf /var/cache/apk/*

ADD https://github.com/channable/vaultenv/releases/download/v0.5.0/vaultenv-0.5.0_x86_64-ubuntu-linux.2_x86_64-linux /usr/bin/vaultenv
RUN chmod +x /usr/bin/vaultenv

COPY /secrets/secrets.file /secrets/secrets.file
ENV DOCKERFILE test
#RUN /usr/bin/vaultenv --token abc123 --no-connect-tls --secrets-file /secrets/secrets.file ./usr/bin/printenv
CMD ["printenv"]
