#!/bin/bash

set -e

################################## VARIABLES ###################################

mainuser_name=${MAINUSER_NAME:-mainuser}
mainuser_nopassword=${MAINUSER_NOPASSWORD:-false}

################### INCLUDE SCRIPTS FROM /opt/startup-early ####################

for i in /opt/startup-early/*.sh; do
    [ -f "$i" ] || continue
    # shellcheck source=/dev/null
    . "$i"
done

################################## MAIN USER ###################################

if [ "$mainuser_name" = root ]; then
    echo 'The main user is root'
    mainuser_home=/root
else
    mainuser_home=/home/$mainuser_name

    # If the user already exists
    if id "$mainuser_name" >/dev/null 2>&1; then
        echo "User $mainuser_name already exists"

        if [ ! -d "$mainuser_home" ]; then
            echo "Creating home directory $mainuser_home"
            install -d -o"$mainuser_name" -g"$mainuser_name" "$mainuser_home"
        fi
    else
        echo "Creating user $mainuser_name"
        useradd -UGsudo -ms/bin/bash "$mainuser_name"
    fi

    if [ "$mainuser_nopassword" = true ]; then
        echo "Enabling sudo without password for user $mainuser_name"
        install -m440 <(echo "$mainuser_name ALL=(ALL) NOPASSWD: ALL") \
            "/etc/sudoers.d/$mainuser_name-nopassword"
    fi
fi

################################ SSH HOST KEYS #################################

# Get host keys from the volume
rm -f /etc/ssh/ssh_host_*_key /etc/ssh/ssh_host_*_key.pub
install -m600 -t/etc/ssh /ssh-host-keys/ssh_host_*_key 2>/dev/null || :
install -m644 -t/etc/ssh /ssh-host-keys/ssh_host_*_key.pub 2>/dev/null || :

# Generate the missing host keys
ssh-keygen -A

# Copy the (previously missing) generated host keys to the volume
cp -n /etc/ssh/ssh_host_*_key /ssh-host-keys/ 2>/dev/null || :
cp -n /etc/ssh/ssh_host_*_key.pub /ssh-host-keys/ 2>/dev/null || :

############################### SSH CLIENT KEYS ################################

if [ ! -e "$mainuser_home/.ssh/authorized_keys" ]; then
    install -d -o"$mainuser_name" -g"$mainuser_name" -m700 "$mainuser_home/.ssh"
    # shellcheck disable=SC3001
    install -o"$mainuser_name" -g"$mainuser_name" -m600 \
        <(cat /ssh-client-keys/*.pub 2>/dev/null || :) \
        "$mainuser_home/.ssh/authorized_keys"
fi

#################### INCLUDE SCRIPTS FROM /opt/startup-late ####################

for i in /opt/startup-late/*.sh; do
    [ -f "$i" ] || continue
    # shellcheck source=/dev/null
    . "$i"
done

############################## START SUPERVISORD ###############################

# Start supervisord with "exec" to let it become the PID 1 process. This ensures
# it receives all the stop signals correctly and reaps all the zombie processes
# inside the container
echo 'Starting supervisord'
exec /usr/bin/supervisord -nc /etc/supervisor/supervisord.conf
