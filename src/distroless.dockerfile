FROM alpine:latest AS deno

ARG DENO_VERSION

RUN apk add -Uu --no-cache curl
RUN curl -Ls https://github.com/denoland/deno/releases/download/${DENO_VERSION}/deno-$(arch)-unknown-linux-gnu.zip | unzip -pq - 'deno' > /tmp/deno

FROM gcr.io/distroless/cc-debian12:latest AS cc

FROM alpine:latest AS sym

COPY --from=cc --chmod=755 --chown=root:root /lib/*-linux-gnu/ld-linux-* /usr/local/lib/

RUN mkdir -p /tmp/lib
RUN ln -s /usr/local/lib/ld-linux-* /tmp/lib/

FROM gcr.io/distroless/static-debian12:latest

ENV LD_LIBRARY_PATH="/usr/local/lib"

COPY --from=deno --chmod=755 --chown=root:root /tmp/deno /usr/local/bin/
COPY --from=cc --chmod=755 --chown=root:root /lib/*-linux-gnu/* /usr/local/lib/
COPY --from=sym --chmod=755 --chown=root:root /tmp/lib /lib
COPY --from=sym --chmod=755 --chown=root:root /tmp/lib /lib64

USER nonroot
ENTRYPOINT ["/usr/local/bin/deno"]