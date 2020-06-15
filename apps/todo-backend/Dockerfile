FROM golang:1.14.3-alpine

RUN mkdir /app

ADD . /app

WORKDIR /app

RUN go mod download

run go build -o main

ENV ENV="local"

ENTRYPOINT ["/app/main"]
