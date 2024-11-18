# Deno Docker Image
![actions:test](https://github.com/dojyorin/deno_docker_image/actions/workflows/test.yaml/badge.svg)
![actions:release](https://github.com/dojyorin/deno_docker_image/actions/workflows/release.yaml/badge.svg)
![actions:cron](https://github.com/dojyorin/deno_docker_image/actions/workflows/cron.yaml/badge.svg)
![shields:license](https://img.shields.io/github/license/dojyorin/deno_docker_image)
![shields:release](https://img.shields.io/github/release/dojyorin/deno_docker_image)

The simple and small deno docker image.

This image is published on DockerHub and synchronized with latest version of [denoland/deno](https://github.com/denoland/deno) every day at `00:00` UTC.

Now, let's start using it!

- [`docker.io/dojyorin/deno`](https://hub.docker.com/r/dojyorin/deno)

## Tags
|OS|Tag|Arch|
|:--|:--|:--|
|[distroless](https://github.com/googlecontainertools/distroless) (default)|`latest` `vX.Y.Z` `distroless` `distroless-vX.Y.Z`|`amd64` `arm64`|
|[alpine](https://github.com/alpinelinux/docker-alpine)|`alpine` `alpine-vX.Y.Z`|`amd64` `arm64`|

## How to use
Easy to introduce in your project.

**⚠ Note ⚠**
- When starting container, be sure to add `--init` flag (`docker run`) or `init: true` property (`docker-compose.yml`) to avoid [PID1 problem](https://www.docker.com/blog/keep-nodejs-rockin-in-docker#:~:text=PID%201%20Problem).
- For security reasons, default runtime user is `nonroot` in distroless and `nobody` in other distributions.

**As single image**
```sh
# Run repl
docker run --init --rm -it dojyorin/deno:latest

# Run script
docker run --init --rm --restart always -p 0.0.0.0:8000:8000 -v $(pwd)/src:/data:ro dojyorin/deno:latest run /data/main.ts
```

**As compose**
```yaml
name: my_project
services:
    image: dojyorin/deno:latest
    init: true
    restart: always
    ports:
        - 0.0.0.0:8000:8000
    volumes:
        - ./src:/data:ro
    command:
        - run
        - /data/main.ts
```

**As base image**
```dockerfile
FROM dojyorin/deno:latest
COPY ./src /data
EXPOSE 8000
CMD ["run", "/data/main.ts"]
```

## Difference from official image
This project was created to solve some issues by [deno_docker](https://github.com/denoland/deno_docker) official images.

- [tini](https://github.com/krallin/tini) is redundant.
- Alpine relies on third-party image.
- Distroless refers to old debian. (Using 11, latest is 12)

If official images solve those issues, this project will be unnecessary...