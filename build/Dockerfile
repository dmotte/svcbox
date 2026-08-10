# syntax=docker/dockerfile:1

FROM docker.io/library/debian:13

RUN <<'EOF' /bin/bash -e
    apt-get update; apt-get install -y tini gosu supervisor sudo openssh-server
    rm -rf /var/lib/apt/lists/*

    rm -fv /etc/ssh/ssh_host_*_key /etc/ssh/ssh_host_*_key.pub

    install -dvm755 /opt/{userngo,sshset{,/data},svcbox}

    # We use the "/tmp" directory for the supervisord socket because the
    # default "/var/run" is not writable by unprivileged users
    echo c6125754a5de7e68b3520854e6b076603dc412bf1ec4b72c026bc407de154f70 \
        /etc/supervisor/supervisord.conf | sha256sum -c
    sed -i 's|/var/run/supervisor\.sock|/tmp/supervisor.sock|' \
        /etc/supervisor/supervisord.conf
EOF

ADD --chown=root:root --chmod=755 \
    --checksum=sha256:b350a393494f8de7d51b3309d8f7f40274392826938ef73a5da9cd9631541b62 \
    https://raw.githubusercontent.com/dmotte/misc/refs/heads/main/scripts/userngo/userngo-debian.sh \
    /opt/userngo/main.sh

ADD --chown=root:root --chmod=755 \
    --checksum=sha256:977ab60310f3882f34874a828413b5711f7632b229226668b2bb5b45ff0783e8 \
    https://raw.githubusercontent.com/dmotte/misc/refs/heads/main/scripts/sshset/sshset.sh \
    /opt/sshset/main.sh

COPY --chown=root:root --chmod=755 *.sh /opt/svcbox/

# To avoid warnings about non-UTF-8 locale # TODO recheck and rethink
ENV LC_ALL=C.UTF-8

ENTRYPOINT ["/usr/bin/tini", "--", "/bin/bash", "/opt/userngo/main.sh", \
    "/bin/bash", "/opt/svcbox/entrypoint.sh"]
