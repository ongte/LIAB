#!/bin/bash
echo "Configuring container registry, please wait..."
#give passwordless sudo to student temporarily
echo "student ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/student
#here we login once to activate student user
su - student << 'EOF'
export XDG_RUNTIME_DIR=/run/user/$(id -u student)
export DBUS_SESSION_BUS_ADDRESS=/run/user/$(id -u student)/bus
mkdir -pv ~/registry &>> /dev/null
EOF
#here we create our local registry and activate it
su - student << 'EOF'
export XDG_RUNTIME_DIR=/run/user/$(id -u student)
export DBUS_SESSION_BUS_ADDRESS=/run/user/$(id -u student)/bus
sudo loginctl enable-linger student &>> /dev/null
podman run -d --name registry -p 5000:5000 -v ~/registry:/var/lib/registry:Z registry:2
sleep 5
mkdir -pv ~/.config/systemd/user &>> /dev/null
cd ~/.config/systemd/user
podman generate systemd -n registry -f &>> /dev/null
systemctl --user daemon-reload &>> /dev/null
podman pull docker.io/library/httpd &>> /dev/null
podman pull docker.io/library/mariadb &>> /dev/null
podman tag docker.io/library/httpd server1:5000/httpd &>> /dev/null
podman tag docker.io/library/mariadb server1:5000/mariadb &>> /dev/null
podman push server1:5000/httpd &>> /dev/null
podman push server1:5000/mariadb &>> /dev/null
podman stop registry &>> /dev/null
systemctl --user enable --now container-registry.service &>> /dev/null
EOF
#here we undo the passwordless sudo for student
rm -f /etc/sudoers.d/student
echo "Container registry created."
