#!/bin/bash

echo "XFCE DESKTOP FULL INSTALLER SCRIPT FOR PTEROVM MADE BY RYNOX "
echo "Updating system packages..."
apt update
apt upgrade -y
echo "Installing Desktop Environment(XFCE)"
apt install task-xfce-desktop -y
echo "Installing VNC server"
apt install tigervnc-standalone-server tigervnc-common tightvncserver -y
export DISPLAY=:1
echo "Set password for vnc server by sending password 2 times and n(Not gonna explain)"
vncpasswd

# Prompt to create .vnc/xstartup file
read -p "Do you want to create .vnc/xstartup file? (y/n): " create_xstartup
if [[ "$create_xstartup" == "y" ]]; then
    echo "Creating startup file..."
    cat <<EOT > .vnc/xstartup
rm /tmp/.X1-lock
startxfce4 -- :1 &
[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
[ -r \$HOME/.Xresources ] && xrdb \$HOME/.Xresources
xsetroot -solid grey
vncconfig -iconic &
exit
EOT
    echo "Created .vnc/xstartup file."
fi

# Prompt to create bin/vncstart file
read -p "Do you want to create bin/vncstart file? (y/n): " create_vncstart
if [[ "$create_vncstart" == "y" ]]; then
    echo "Making vncstart command..."
    cat <<EOT > bin/vncstart
#!/bin/bash
vncserver :1 -rfbport \$SERVER_PORT -localhost no
EOT
    echo "Created bin/vncstart file."
fi

# Make vncstart command executable
chmod +x ./bin/vncstart
echo "Running VNC server..."
./bin/vncstart
echo "Opening firefox and terminal..."
firefox &
xfce4-terminal & 
echo "To open vnc next time send vncstart command"
echo "For firefox send firefox command and for terminal send xfce4-terminal command"
echo "NOTE: They are blocking commands, so if you want both running start with terminal cause from terminal you can create tabs and run Firefox as well"
echo "Thanks for using Rynox Script!" 
