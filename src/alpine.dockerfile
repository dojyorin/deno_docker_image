FROM alpine:latest AS deno

ARG DENO_VERSION="v1.38.1"

RUN apk --update --no-cache add curl
RUN curl -Ls https://github.com/denoland/deno/releases/download/${DENO_VERSION}/deno-$(arch)-unknown-linux-gnu.zip | unzip -q -d /tmp -

FROM gcr.io/distroless/cc-debian12:latest AS cc

FROM alpine:latest

ENV LD_LIBRARY_PATH="/usr/local/lib"

COPY --from=deno --chown=root:root --chmod=755 /tmp/deno /usr/local/bin/
COPY --from=cc --chown=root:root --chmod=755 /lib/*-linux-gnu/* /usr/local/lib/

RUN mkdir /lib64 && \
    ln -s /usr/local/lib/ld-linux-*.so.2 /lib64/ && \
    sed -i -e 's|nobody:/|nobody:/home/nobody|' /etc/passwd && \
    install -d -o nobody -g nobody -m 700 /home/nobody

USER nobody
ENTRYPOINT ["/usr/local/bin/deno"]