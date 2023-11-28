FROM alpine:latest AS deno

ARG DENO_VERSION

RUN apk --update --no-cache add curl
RUN curl -Ls https://github.com/denoland/deno/releases/download/${DENO_VERSION}/deno-$(arch)-unknown-linux-gnu.zip | unzip -q -d /tmp -

FROM gcr.io/distroless/cc-debian12:latest AS cc

FROM gcr.io/distroless/static-debian12:latest

ENV LD_LIBRARY_PATH="/usr/local/lib"

COPY --from=deno --chown=root:root --chmod=755 /tmp/deno /usr/local/bin/
COPY --from=cc --chown=root:root --chmod=755 /lib/*-linux-gnu/* /usr/local/lib/
COPY --from=cc --chown=root:root --chmod=755 /lib64/* /lib64/

USER nonroot
ENTRYPOINT ["/usr/local/bin/deno"]