FROM alpine:latest AS deno

FROM gcr.io/distroless/cc-debian12:latest AS cc

FROM alpine:latest

COPY --from=cc /lib/x86_64-linux-gnu/* /lib/x86_64-linux-gnu/
COPY --from=cc /etc/nsswitch.conf /etc/
COPY --from=cc /etc/ld.so.conf.d/x86_64-linux-gnu.conf /etc/ld.so.conf.d/
COPY --from=cc /usr/lib/x86_64-linux-gnu/gconv/* /usr/lib/x86_64-linux-gnu/gconv/
RUN mkdir /lib64 && ln -s /lib/x86_64-linux-gnu/ld-linux-x86-64.so.2 /lib64/