FROM busybox:latest AS busybox

FROM alpine:latest AS deno

ARG DENO_VERSION="v1.38.0"

RUN apk --update --no-cache add curl
RUN curl -Ls https://github.com/denoland/deno/releases/download/${DENO_VERSION}/deno-$(arch)-unknown-linux-gnu.zip | unzip -q -d /tmp -

FROM gcr.io/distroless/cc-debian12:latest AS cc

COPY --from=busybox --chown=root:root --chmod=755 /bin/busybox /
SHELL ["/busybox", "sh", "-c"]

RUN /busybox cp -rf /lib/$(/busybox arch)-linux-gnu /tmp/cc
RUN /busybox cp -rf /usr/lib/$(/busybox arch)-linux-gnu/gconv /tmp/gconv
RUN /busybox cp -f /etc/nsswitch.conf /tmp/
RUN /busybox cp -f /etc/ld.so.conf.d/$(/busybox arch)-linux-gnu.conf /tmp/cc.conf
RUN /busybox sed -r -i -e "s/$(/busybox arch)-linux-gnu/cc/g" /tmp/cc.conf

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