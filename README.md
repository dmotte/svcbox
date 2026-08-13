# svcbox

![icon](icon.svg)

[![GitHub main workflow](https://img.shields.io/github/actions/workflow/status/dmotte/svcbox/main.yml?branch=main&logo=github&label=main&style=flat-square)](https://github.com/dmotte/svcbox/actions)
[![Docker Pulls](https://img.shields.io/docker/pulls/dmotte/svcbox?logo=docker&style=flat-square)](https://hub.docker.com/r/dmotte/svcbox)

:rocket: Docker image for running **multiple supervised services**, with **log management** and (optional) **sshd**.

> :package: This image is also on **Docker Hub** as [`dmotte/svcbox`](https://hub.docker.com/r/dmotte/svcbox) and runs on **several architectures** (e.g. amd64, arm64, ...). To see the full list of supported platforms, please refer to the [`.github/workflows/main.yml`](.github/workflows/main.yml) file. If you need an architecture that is currently unsupported, feel free to open an issue.

## Usage

> **Note**: this Docker image runs [userngo](https://github.com/dmotte/misc/tree/main/scripts/userngo) at startup to handle user creation and setup. See https://github.com/dmotte/misc/tree/main/scripts/userngo#examples for documentation and usage examples.

> **Note**: this Docker image runs [sshset](https://github.com/dmotte/misc/tree/main/scripts/sshset) to handle SSH configuration, keys, and other files. See https://github.com/dmotte/misc/tree/main/scripts/sshset#examples for documentation and usage examples.

The [`docker-compose.yml`](docker-compose.yml) file contains a complete usage example for this image. Feel free to simplify it and adapt it to your needs. Unless you want to build the image from scratch, comment out the `build: build` line to use the pre-built one from _Docker Hub_ instead.

To start the Docker-Compose stack in daemon (detached) mode:

```bash
docker-compose up -d
```

Then you can view the logs using this command:

```bash
docker-compose logs -ft
```

This image includes **`logtosupd`**, an embedded system to gather and process logs from programs running in `supervisord`, and write them directly to `supervisord`'s `stdout`. In order to send logs to `logtosupd`, a program must have `stdout_events_enabled=true` and `stderr_events_enabled=true` defined in the `supervisord` configuration.

## Development

If you want to contribute to this project, you can use the following one-liner to **rebuild the image** and bring up the **Docker-Compose stack** every time you make a change to the code:

```bash
docker-compose down && docker-compose up --build
```
