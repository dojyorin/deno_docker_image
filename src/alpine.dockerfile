FROM alpine:latest AS deno

ARG DENO_VERSION

RUN apk --update --no-cache add curl
RUN curl -Ls https://github.com/denoland/deno/releases/download/${DENO_VERSION}/deno-$(arch)-unknown-linux-gnu.zip | unzip -q -d /tmp - 'deno'

FROM gcr.io/distroless/cc-debian12:latest AS cc

FROM alpine:latest AS sym

COPY --from=cc --chown=root:root --chmod=755 /lib/*-linux-gnu/ld-linux-* /usr/local/lib/

RUN mkdir -p /tmp/lib
RUN ln -s /usr/local/lib/ld-linux-* /tmp/lib/

FROM alpine:latest

ENV LD_LIBRARY_PATH="/usr/local/lib"

COPY --from=deno --chown=root:root --chmod=755 /tmp/deno /usr/local/bin/
COPY --from=cc --chown=root:root --chmod=755 /lib/*-linux-gnu/* /usr/local/lib/
COPY --from=sym --chown=root:root --chmod=755 /tmp/lib /lib
COPY --from=sym --chown=root:root --chmod=755 /tmp/lib /lib64

RUN sed -i -e 's|nobody:/|nobody:/home|' /etc/passwd && chown nobody:nobody /home

USER nobody
ENTRYPOINT ["/usr/local/bin/deno"]