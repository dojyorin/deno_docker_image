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

# Usage
Easy to introduce in your project.

**⚠Notes**
- When starting container, be sure to add `--init` flag (`docker run`) or `init: true` property (`docker-compose.yml`) to avoid [PID 1 Problem](https://www.docker.com/blog/keep-nodejs-rockin-in-docker/#:~:text=PID%201%20Problem).
- For security reasons, default runtime user is `nonroot` in distroless and `nobody` in other distributions.

**As single image**
```sh
# Run REPL.
docker run -it --init --rm denoland/deno:latest

# Run script.
docker run --init --rm -p 0.0.0.0:80:8080 -v /project:/project:ro denoland/deno:latest run /project/main.ts
```

**As compose**
```yaml
name: my_project
services:
    image: dojyorin/deno:latest
    restart: always
    init: true
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