#!/bin/bash
echo "Configuring user podman, please wait..."
#here we login once to activate student user
su - student << 'EOF'
export XDG_RUNTIME_DIR=/run/user/$(id -u student)
export DBUS_SESSION_BUS_ADDRESS=/run/user/$(id -u student)/bus
EOF
su - student << 'EOF'
export XDG_RUNTIME_DIR=/run/user/$(id -u student)
export DBUS_SESSION_BUS_ADDRESS=/run/user/$(id -u student)/bus
mkdir -pv ~/registry &>> /dev/null
podman run -d --name registry -p 5000:5000 -v ~/registry:/var/lib/registry:Z registry:2 &>> /dev/null
EOF
echo "User podman configured."
