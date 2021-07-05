FROM alpine:latest
RUN apk add --update htop && rm -rf /var/cache/apk/*
ENTRYPOINT ["htop"]
