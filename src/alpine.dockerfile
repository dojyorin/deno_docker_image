FROM alpine:latest AS deno

ARG DENO_VERSION="v1.38.0"

RUN apk --update --no-cache add curl
RUN curl -Ls https://github.com/denoland/deno/releases/download/${DENO_VERSION}/deno-$(arch)-unknown-linux-gnu.zip | unzip -q -d /tmp -

FROM gcr.io/distroless/cc-debian12:latest AS cc

RUN cp -rf /lib/$(arch)-linux-gnu /tmp/cc
RUN cp -rf /usr/lib/$(arch)-linux-gnu/gconv /tmp/gconv
RUN cp -f /etc/nsswitch.conf /tmp/
RUN cp -f /etc/ld.so.conf.d/$(arch)-linux-gnu.conf /tmp/cc.conf
RUN sed -r -i -e "s/$(arch)-linux-gnu/cc/g" /tmp/cc.conf

FROM alpine:latest

COPY --from=deno --chown=root:root --chmod=755 /tmp/deno /usr/local/bin/

COPY --from=cc /tmp/nsswitch.conf /etc/
COPY --from=cc /tmp/cc.conf /etc/ld.so.conf.d/
COPY --from=cc /tmp/cc /lib/cc
COPY --from=cc /tmp/gconv /usr/lib/cc/gconv
RUN mkdir /lib64 && ln -s /lib/cc/ld-linux-*.so.2 /lib64/

USER nobody
ENTRYPOINT ["/usr/local/bin/deno"]
CMD ["eval", "console.log('Welcome to Deno!');"]