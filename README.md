# VM configuration

- RAM : 4GB
- processors : 4
- hard drive : 20 GB

## partition and logical volumes

| Type    | mounted at                             | size (GB) | for  |
|---------|----------------------------------------|-----------|------|
| primary | /                                      | 6         |      |
| primary | none                                   | 2         | swap |
| primary | /var                                   |           |      |
| logical | /var/log                               | 0.5       |      |
| logical | /var/lib/docker/volumes/mariadb_data   | 2         |      |
| logical | /var/lib/docker/volumes/wp_data        | 2         |      |
| logical | /var/lib/docker/volumes/redis_data     | 1         |      |
| logical | /var/lib/docker/volumes/other_services | 1         |      |
| logical | /var/lib/docker/volumes/portainer      | 0.5       |      |


## extra configuration

- add user to sudoers
```bash
su -
adduser <user> sudo
```
- install a text editor (vim, ..)

# Docker

## installation (on Debian based distribution)

1. install dependencies

- `ca-certificates` 
- `curl` command line tool for various protocols (HTTP, FTP...) (alternative to wget for downloading)
- `gnupg` (GNU privacy guard) to verify software signatures, encrypt or decrypt data (alternative to pgp)
- `lsb-release` to display Linux Standard Base versioning info. Otherwise we can read `/etc/*relase` files manually

2. create directory for apt keys and setting its permissions.

`$ sudo install -m 0755 -d /etc/apt/keyrings/`

3. store the repository gpg keys

```bash
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
```

4. adding the Docker repository to the list of trusted ones

```bash
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```

5. download Docker packages

[Docker Install doc](https://docs.docker.com/engine/install/debian/)

##

## Docker files

⚠️ Docker creates a layer with each RUN instruction -> strive to minimize RUN

everything runs as root inside Docker builds

## Docker CLI

## Containerd

## Docker compose

### monitoring

# Nginx

## installation (on Alpine)

https://wiki.alpinelinux.org/wiki/Nginx

## certificate generation

### self-signed

how not to regenerate a different certificate at build time, and keep a constant identity ?

⚠️ security-wise the cert is inside the image

# Maria DB

## installation (on Alpine)

# Wordpress

## installation (on Alpine)

# Redis

## installation (on Alpine)

# Adminer

## installation (on Alpine)

```bash
# check MEM usage
docker stats --no-stream <container>
```