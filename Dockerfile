# dockerfile: https://gist.github.com/mvdan/3d29633ed1700bd1f495ced0f50c4f76
# credits to: https://gist.github.com/mvdan
FROM golang:1.13 AS builder

RUN apt-get update && apt-get install -y ca-certificates

RUN git clone -b master --depth=1 https://github.com/drone/drone
RUN cd drone && go install -tags "oss nolimit" ./cmd/drone-server

FROM debian:buster-slim

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /go/bin/drone-server /

EXPOSE 80 443
VOLUME /data

ENV GODEBUG netdns=go
ENV XDG_CACHE_HOME /data
ENV DRONE_DATABASE_DRIVER sqlite3
ENV DRONE_DATABASE_DATASOURCE /data/database.sqlite
ENV DRONE_RUNNER_OS=linux
ENV DRONE_RUNNER_ARCH=amd64
ENV DRONE_SERVER_PORT=:80
ENV DRONE_SERVER_HOST=localhost

ENTRYPOINT ["/drone-server"]
