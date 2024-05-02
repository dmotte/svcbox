# svcbox

![icon](icon.svg)

[![GitHub main workflow](https://img.shields.io/github/actions/workflow/status/dmotte/svcbox/main.yml?branch=main&logo=github&label=main&style=flat-square)](https://github.com/dmotte/svcbox/actions)
[![Docker Pulls](https://img.shields.io/docker/pulls/dmotte/svcbox?logo=docker&style=flat-square)](https://hub.docker.com/r/dmotte/svcbox)

:rocket: Docker image with **supervisord** and **sshd**.

If you want a **rootless** version of this image, check out [dmotte/svcbox-rootless](https://github.com/dmotte/svcbox-rootless).

> :package: This image is also on **Docker Hub** as [`dmotte/svcbox`](https://hub.docker.com/r/dmotte/svcbox) and runs on **several architectures** (e.g. amd64, arm64, ...). To see the full list of supported platforms, please refer to the [`.github/workflows/main.yml`](.github/workflows/main.yml) file. If you need an architecture which is currently unsupported, feel free to open an issue.

## Usage

The first things you need are **host keys** for the OpenSSH server and an **SSH key pair** for a client to be able to connect. See the usage example of [dmotte/docker-portmap-server](https://github.com/dmotte/docker-portmap-server) for how to get them. Note that all the **SSH client keys** must be put directly into the root of the `/ssh-client-keys` volume instead of subdirectories, and the image doesn't generate a key pair automatically if they are missing. Note also that the `authorized_keys` file is not regenerated if it already exists.

**Warning**: it's a good practice to set the permissions of the root directory of the `/ssh-host-keys` and `/ssh-client-keys` volumes to `700`, to prevent regular users from reading their content.

The [`docker-compose.yml`](docker-compose.yml) file contains a complete usage example for this image. Feel free to simplify it and adapt it to your needs. Unless you want to build the image from scratch, comment out the `build: build` line to use the pre-built one from _Docker Hub_ instead.

To start the Docker-Compose stack in daemon (detached) mode:

```bash
docker-compose up -d
```

Then you can view the logs using this command:

```bash
docker-compose logs -ft
```

This image supports **running commands at container startup** by mounting custom scripts at `/opt/startup-early/*.sh` and `/opt/startup-late/*.sh`. This is the same approach used by [dmotte/desktainer](https://github.com/dmotte/desktainer).

## Environment variables

List of supported **environment variables**:

| Variable              | Required               | Description                                                               |
| --------------------- | ---------------------- | ------------------------------------------------------------------------- |
| `MAINUSER_NAME`       | No (default: mainuser) | Name of the main user                                                     |
| `MAINUSER_NOPASSWORD` | No (default: `false`)  | Whether or not the main user should be allowed to `sudo` without password |

## Development

If you want to contribute to this project, you can use the following one-liner to **rebuild the image** and bring up the **Docker-Compose stack** every time you make a change to the code:

```bash
docker-compose down && docker-compose up --build
```

> **Note**: I know that this Docker image has many **layers**, but this shouldn't be a problem in most cases. If you want to reduce its number of layers, there are several techniques out there, e.g. see [this](https://stackoverflow.com/questions/39695031/how-make-docker-layer-to-single-layer)
