FROM alpine:3.6

ENV NETLIFYCTL_VERSION 0.2.2

ADD https://github.com/netlify/netlifyctl/releases/download/v${NETLIFYCTL_VERSION}/netlifyctl-linux-amd64-${NETLIFYCTL_VERSION}.tar.gz /tmp/netlify.tar.gz

RUN cd /tmp \
  && tar -zxvf netlify.tar.gz \
  && cp netlify /usr/bin/netlify \
  && rm -rf /tmp/netlify*
