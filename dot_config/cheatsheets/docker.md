# docker

> Manage containers, images, volumes, networks, and disk garbage collection.
> Tags: #container #devops #cleanup #storage #redis #postgres #network
> Docs: <https://docs.docker.com/reference/cli/docker/>

---

## 1. Run & Lifecycle

- Run ephemeral test container with auto-cleanup (zero disk garbage on exit):
`docker run --rm -d --name {{name}} -p {{host_port}}:{{container_port}} {{image}}`

- Run persistent service with named volume and auto-restart policy:
`docker run -d --restart unless-stopped --name {{name}} -v {{volume_name}}:{{container_path}} {{image}}`

- List currently running containers:
`docker ps`

- List all containers (including exited and stopped):
`docker ps -a`

- Show actual disk usage of container write layers:
`docker ps -s`

- Stop a running container gracefully:
`docker stop {{container_name}}`

- Force stop and remove container in a single command:
`docker rm -f {{container_name}}`

## 2. Exec & Debugging

- Open an interactive shell inside a container:
`docker exec -it {{container_name}} {{sh|bash}}`

- Run a single command directly without opening shell:
`docker exec -it {{container_name}} {{command}}`

- Stream logs in real time with timestamp (last 100 lines):
`docker logs -f --tail 100 -t {{container_name}}`

- Inspect container metadata, IP address, and mounts (JSON format):
`docker inspect {{container_name}}`

- Extract container IPv4 address directly:
`docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' {{container_name}}`

- List active processes running inside a container:
`docker top {{container_name}}`

## 3. Resource Limits & Monitoring

- Monitor CPU, RAM, Network, and Block I/O metrics in real time:
`docker stats`

- Run container with strict RAM and CPU caps:
`docker run -d --memory="512m" --memory-swap="1g" --cpus="1.5" {{image}}`

## 4. Storage & Volumes

- List all volumes on host:
`docker volume ls`

- Create a named volume explicitly:
`docker volume create {{volume_name}}`

- Inspect physical host mount path of a volume:
`docker volume inspect {{volume_name}}`

- Remove an unused named volume:
`docker volume rm {{volume_name}}`

- Prune all dangling/anonymous volumes (crucial for reclaiming disk space):
`docker volume prune -f`

## 5. Networks

- Create a custom user-defined bridge network (enables automatic DNS service discovery):
`docker network create {{network_name}}`

- Connect container to custom network:
`docker run -d --name {{name}} --network {{network_name}} {{image}}`

- Remove all unused networks:
`docker network prune -f`

## 6. Disk Space Audit & Safe Garbage Collection

- Audit Docker physical disk space usage and reclaimable quota:
`docker system df`

- Detailed breakdown of reclaimable artifacts:
`docker system df -v`

- Remove stopped containers:
`docker container prune -f`

- Remove untagged/dangling images (<none>):
`docker image prune -f`

- Remove all unused images not associated with a container:
`docker image prune -a -f`

- Deep clean testing environment (removes stopped containers, dangling volumes, unused networks, and images):
`docker system prune -a --volumes -f`

---

## Essential Flags Reference

| Flag | Full Option | Purpose |
| :--- | :--- | :--- |
| `-d` | `--detach` | Run container in background (free current terminal) |
| `--rm` | N/A | Automatically delete container and associated anonymous volumes on exit |
| `-p` | `--publish` | Map port `<host_port>:<container_port>` |
| `-v` | `--volume` | Bind mount storage `<volume_name>:<container_path>` |
| `-e` | `--env` | Set environment variable `<KEY>=<VAL>` |
| `-it` | `-i --tty` | Allocate pseudo-TTY and keep STDIN open (interactive shell) |
| `--restart` | N/A | Restart policy: `always`, `unless-stopped`, `on-failure` |
