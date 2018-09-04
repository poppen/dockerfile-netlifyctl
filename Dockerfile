FROM golang:latest AS build

ENV PROJECT /go/src/github.com/netlify/netlifyctl
ENV GOBIN /gobin
ENV PATH $PATH:/gobin

RUN apt-get update && apt-get install -y --no-install-recommends \
  upx \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p $PROJECT $GOBIN

WORKDIR ${PROJECT}

RUN git clone https://github.com/netlify/netlifyctl.git . \
  && go get github.com/pwaller/goupx \
  && curl https://glide.sh/get | sh \
  && glide install \
  && CGO_ENABLED=0 go build -ldflags "-s -w" -o bin/netlifyctl main.go \
  && goupx bin/netlifyctl

FROM alpine:3.8

ENV PROJECT /go/src/github.com/netlify/netlifyctl

RUN apk add --no-cache ca-certificates

COPY --from=build $PROJECT/bin/* /usr/bin/

ENTRYPOINT ["/usr/bin/netlifyctl"]
CMD ["help"]
