FROM golang:latest AS build

ENV PROJECT /go/src/github.com/netlify/netlifyctl

RUN mkdir -p $PROJECT

WORKDIR ${PROJECT}

RUN git clone https://github.com/netlify/netlifyctl.git . \
  && go get -v ./... \
  && CGO_ENABLED=0 go build -o bin/netlifyctl main.go

FROM alpine:3.6

ENV PROJECT /go/src/github.com/netlify/netlifyctl

COPY --from=build $PROJECT/bin/* /usr/bin/
