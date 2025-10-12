FROM docker.io/library/debian:12

EXPOSE 22

RUN apt-get update && \
    apt-get install -y sudo supervisor openssh-server && \
    rm -rf /var/lib/apt/lists/* && \
    rm -fv /etc/ssh/ssh_host_*_key /etc/ssh/ssh_host_*_key.pub && \
    mkdir -p /run/sshd && \
    sed -Ei /etc/ssh/sshd_config \
        -e 's/^#?PermitRootLogin[ \t].*$/PermitRootLogin no/' \
        -e 's/^#?HostbasedAuthentication[ \t].*$/HostbasedAuthentication no/' \
        -e 's/^#?PermitEmptyPasswords[ \t].*$/PermitEmptyPasswords no/' \
        -e 's/^#?PasswordAuthentication[ \t].*$/PasswordAuthentication no/'

COPY --chown=root:root --chmod=755 startup.sh /

RUN install -dvm700 /opt/startup-early /opt/startup-late \
    /ssh-host-keys /ssh-client-keys

COPY --chown=root:root --chmod=644 supervisord.conf /etc/supervisor/supervisord.conf

ENV LC_ALL=C.UTF-8
RUN echo '#!/bin/bash\n\nexport LC_ALL=C.UTF-8' \
    > /etc/profile.d/set-c-utf8-locale.sh

ENTRYPOINT ["/startup.sh"]
