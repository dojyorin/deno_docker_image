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
- When starting container, be sure to add `--init` flag (`docker run`) or `init: true` property (`docker-compose.yml`) to avoid [PID 1 Problem](https://www.docker.com/blog/keep-nodejs-rockin-in-docker/#:~:text=PID%201%20Problem).
- For security reasons, default runtime user is `nonroot` in distroless and `nobody` in other distributions.

**As single image**
```sh
# Run REPL.
docker run --init --rm -it denoland/deno:latest

# Run script.
docker run --init --rm -p 0.0.0.0:80:8080 -v /project:/project:ro denoland/deno:latest run /project/main.ts
```

**As compose**
```yaml
name: my_project
services:
    image: dojyorin/deno:latest
    init: true
    restart: always
    ports:
        - 0.0.0.0:80:8000
    volumes:
        - /project:/project:ro
    command:
        - run
        - /project/main.ts
```

**As base image**
```dockerfile
FROM dojyorin/deno:latest
COPY /project/* /project/
EXPOSE 8000
CMD ["run", "/project/main.ts"]
```

# Difference with official image

This project was created to solve the problems faced by official images.

- Duplicate [tini](https://github.com/krallin/tini)
- Alpine dependent on third-party image
- Deprecated Distroless tag

- Use tini integrated with docker.
- Clone glibc required by Alpine from Distroless.

If official images solve those issues, this project will be unnecessary...