Khala deploy dockerfiles
====

This repo contains dockerfiles for deployment

## Usage

### KhalaNode

#### Build

`docker build --build-arg PHALA_GIT_TAG=master -f node.Dockerfile -t khala-node:TAG_NAME .`

#### Run

`docker run -dti --rm --name khala-node -e NODE_NAME=my-khala-node -p 9615:9615 -p 9933:9933 -p 9944:9944 -p 30333:30333 -v $(pwd)/data:/root/data -e NODE_ROLE="FULL" khala-node:TAG_NAME`

`NODE_ROLE` can be `""` (empty string), `"FULL"`, `"VALIDATOR"` (case sensitive)

## Cheatsheets

### Clean build

Add `--no-cache` for a clean build

### Start & stop a container

Start

`docker start khala-node`

Safe stop

`docker stop khala-node`

Force stop

`docker kill khala-node`

### Remove a container

`docker rm khala-node`

### Show logs

`docker logs khala-node`

`docker attach --sig-proxy=false --detach-keys=ctrl-c khala-node`

### Run shell

`docker exec -it khala-node bash`

### Clean up

`docker image prune -a`

`docker builder prune`

## Build, Push, Pull to GitHub

`docker build --build-arg PHALA_GIT_TAG=master -f node.Dockerfile -t docker.pkg.github.com/phala-network/khala-docker/khala-node:TAG_NAME .`

`docker push docker.pkg.github.com/phala-network/khala-docker/khala-node:TAG_NAME`

`docker pull docker.pkg.github.com/phala-network/khala-docker/khala-node:TAG_NAME`

## References

- Proxy and other Systemd relates configurations <https://docs.docker.com/config/daemon/systemd/>
- Manage Docker as a non-root user (avoid `sudo`) <https://docs.docker.com/engine/install/linux-postinstall/>
- Add `--restart=unless-stopped` to `docker run` to improve availability
- You can use `docker create` instead of `docker run` for create the container but not run it immediately

## License

This project is licensed under the terms of the MIT license.
