# svcbox

![icon](icon.svg)

[![GitHub main workflow](https://img.shields.io/github/actions/workflow/status/dmotte/svcbox/main.yml?branch=main&logo=github&label=main&style=flat-square)](https://github.com/dmotte/svcbox/actions)
[![Docker Pulls](https://img.shields.io/docker/pulls/dmotte/svcbox?logo=docker&style=flat-square)](https://hub.docker.com/r/dmotte/svcbox)

:rocket: Docker image with **supervisord** and **sshd**.

TODO remember to put warning in readme to make the `/ssh-xxx-keys` volumes root dirs `700`, to be sure that the regular users won't be able to read the keys

TODO regarding the SSH keys management, write just "the ssh host and client keys management is similar to docker-portmap-server (link) except for the ssh-client-keys which are all inside the root of the volume and all for the main user, and are not generated automatically if missing. And they are not put into authorized_keys if it already exists"
