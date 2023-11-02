FROM alpine:latest AS deno

ARG DENO_VERSION

RUN apk --update --no-cache add curl
RUN curl -Ls https://github.com/denoland/deno/releases/download/${DENO_VERSION}/deno-x86_64-unknown-linux-gnu.zip | unzip -q -d /tmp -

FROM gcr.io/distroless/cc-debian12:latest

COPY --from=deno --chown=root:root --chmod=755 /tmp/deno /bin/

USER nonroot
ENTRYPOINT ["/bin/deno"]
CMD ["eval", "console.log('Welcome to Deno!');"]