FROM alpine:latest AS deno

ARG DENO_VERSION="v1.38.0"

RUN apk --update --no-cache add curl
RUN curl -Ls https://github.com/denoland/deno/releases/download/${DENO_VERSION}/deno-$(arch)-unknown-linux-gnu.zip | unzip -q -d /tmp -

FROM gcr.io/distroless/cc-debian12:latest AS cc

FROM alpine:latest

COPY --from=deno --chown=root:root --chmod=755 /tmp/deno /usr/local/bin/
COPY --from=cc --chown=root:root --chmod=755 /lib/*-linux-gnu/* /lib/

RUN mkdir /lib64 && \
    ln -s /lib/ld-linux-*.so.2 /lib64/ && \
    sed -i -e 's|nobody:/|nobody:/home/nobody|' /etc/passwd && \
    install -d -o nobody -g nobody -m 700 /home/nobody

USER nobody
ENTRYPOINT ["/usr/local/bin/deno"]
CMD ["repl"]