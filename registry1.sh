#!/bin/bash
echo "Configuring container registry part 1, please wait..."
#give passwordless sudo to student temporarily
echo "student ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/student
#here we login once to activate student user
su - student << 'EOF'
export XDG_RUNTIME_DIR=/run/user/$(id -u student)
export DBUS_SESSION_BUS_ADDRESS=/run/user/$(id -u student)/bus
mkdir -pv ~/registry &>> /dev/null
sudo loginctl enable-linger student &>> /dev/null
EOF
sleep 5
#here we create our local registry and activate it
su - student << 'EOF'
export XDG_RUNTIME_DIR=/run/user/$(id -u student)
export DBUS_SESSION_BUS_ADDRESS=/run/user/$(id -u student)/bus
podman run -d --name registry -p 5000:5000 -v ~/registry:/var/lib/registry:Z registry:2
mkdir -pv ~/.config/systemd/user &>> /dev/null
EOF
#here we undo the passwordless sudo for student
echo "Container registry part 1 done. Please proceed to run \'registry2.sh\'"
