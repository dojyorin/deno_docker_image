# **Deno Docker Image**
![actions:test](https://github.com/dojyorin/deno_docker_image/actions/workflows/test.yaml/badge.svg)
![actions:release](https://github.com/dojyorin/deno_docker_image/actions/workflows/release.yaml/badge.svg)
![actions:push](https://github.com/dojyorin/deno_docker_image/actions/workflows/push.yaml/badge.svg)
![shields:license](https://img.shields.io/github/license/dojyorin/deno_docker_image)
![shields:release](https://img.shields.io/github/release/dojyorin/deno_docker_image)

The simple and small deno docker image.

This image is published on DockerHub and synchronized with latest version of [denoland/deno](https://github.com/denoland/deno) every day at `06:00` UTC.

- Distroless: [dojyorin/deno:distroless](https://hub.docker.com/r/dojyorin/deno/tags?name=distroless) (default)
- Alpine: [dojyorin/deno:alpine](https://hub.docker.com/r/dojyorin/deno/tags?name=alpine)

# How to use
Easy to introduce in your project.

**⚠ Notes ⚠**
- When starting container, be sure to add `--init` flag (`docker run`) or `init: true` property (`docker-compose.yml`) to avoid [PID 1 Problem](https://www.docker.com/blog/keep-nodejs-rockin-in-docker#:~:text=PID%201%20Problem).
- For security reasons, default runtime user is `nonroot` in distroless and `nobody` in other distributions.

**As single image**
```sh
# Run REPL.
docker run --rm --init -it dojyorin/deno:latest

# Run script.
docker run --rm --init --restart always -p 0.0.0.0:8000:80 -v ./src:/data:ro dojyorin/deno:latest run /data/main.ts
```

**As compose**
```yaml
name: my_project
services:
    image: dojyorin/deno:latest
    init: true
    restart: always
    ports:
        - 0.0.0.0:8000:80
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
EXPOSE 80
CMD ["run", "/data/main.ts"]
```

# Difference with official image

This project was created to solve the problems faced by [deno_docker](https://github.com/denoland/deno_docker) official images.

- [tini](https://github.com/krallin/tini) is redundant
- Alpine dependent on third-party image
- Using old debian in Distroless (Uses 11, latest is 12)

If official images solve those issues, this project will be unnecessary...