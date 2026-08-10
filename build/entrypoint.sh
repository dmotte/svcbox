#!/bin/bash

set -e

readonly setup_supervisorctl=${SVCBOX_SUPERVISORCTL:-false}
readonly supervisor_sock_chmod=${SVCBOX_SUPERVISOR_SOCK_CHMOD:-0600}
readonly setup_sshd=${SVCBOX_SSHD:-true}

################################################################################

find /tmp -mindepth 1 -delete

USER=$(id -un); export USER
export HOME=~

################################################################################

export SSHSET_SETUP_SERVER=${SSHSET_SETUP_SERVER:-$setup_sshd}

if [ "$SSHSET_SETUP_SERVER" = true ] || [ "$SSHSET_SETUP_CLIENT" = true ]; then
    bash /opt/sshset/main.sh
fi

################################################################################

install -dvm700 ~/.supervisor{,/conf.d,/log}

if [ ! -e ~/.supervisor/supervisord.conf ]; then
    cfg_supervisorctl=''

    cfg_programs=''

    ############################################################################

    if [ "$setup_supervisorctl" = true ]; then
        cfg_supervisorctl+=$'[unix_http_server]\n'
        cfg_supervisorctl+=$'file=/tmp/supervisor.sock\n'
        cfg_supervisorctl+="chmod=$supervisor_sock_chmod"$'\n'

        cfg_supervisorctl+=$'[rpcinterface:supervisor]\n'
        cfg_supervisorctl+='supervisor.rpcinterface_factory = '
        cfg_supervisorctl+=$'supervisor.rpcinterface:make_main_rpcinterface\n'
    fi

    ############################################################################

    if [ "$setup_sshd" = true ]; then
        cfg_programs+=$'[program:sshd]\n'

        if [ "$EUID" = 0 ]; then
            cfg_programs+=$'command=/usr/sbin/sshd -De\n'
        else
            cfg_programs+='command=/usr/sbin/sshd -Def '
            cfg_programs+=$'%(ENV_HOME)s/.ssh/sshd_config\n'
        fi
    fi

    ############################################################################

    install -Tvm644 /dev/stdin ~/.supervisor/supervisord.conf << EOF
[supervisord]
nodaemon=true
logfile=%(here)s/log/supervisord.log
pidfile=%(here)s/supervisord.pid
childlogdir=%(here)s/log

$cfg_supervisorctl

$cfg_programs

[include]
files=%(here)s/conf.d/*.conf
EOF
fi

################################################################################

exec /usr/bin/supervisord -nc ~/.supervisor/supervisord.conf

# TODO test this file thoroughly
