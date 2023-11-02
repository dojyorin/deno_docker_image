FROM alpine:latest AS deno

RUN apk --update --no-cache add curl
RUN curl -Ls https://github.com/denoland/deno/releases/download/v1.38.0/deno-x86_64-unknown-linux-gnu.zip | unzip -q -d /tmp -

FROM gcr.io/distroless/cc-debian12:latest AS cc

FROM alpine:latest

COPY --from=deno --chown=root:root --chmod=755 /tmp/deno /usr/local/bin/
COPY --from=cc /lib/x86_64-linux-gnu/* /lib/x86_64-linux-gnu/
COPY --from=cc /etc/nsswitch.conf /etc/
COPY --from=cc /etc/ld.so.conf.d/x86_64-linux-gnu.conf /etc/ld.so.conf.d/
COPY --from=cc /usr/lib/x86_64-linux-gnu/gconv/* /usr/lib/x86_64-linux-gnu/gconv/
RUN mkdir /lib64 && ln -s /lib/x86_64-linux-gnu/ld-linux-x86-64.so.2 /lib64/

USER nonroot
ENTRYPOINT ["/usr/local/bin/deno"]
CMD ["eval", "console.log('Welcome to Deno!');"]