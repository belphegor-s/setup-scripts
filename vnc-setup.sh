#!/bin/sh
sudo apt update -y && sudo apt upgrade -y

sudo apt install xfce4 xfce4-goodies

sudo apt install tightvncserver

printf 'n\n' | vncserver

vncserver -kill :1

mv ~/.vnc/xstartup ~/.vnc/xstartup.bak

echo "#!/bin/bash\nxrdb $HOME/.Xresources\nstartxfce4 &" > ~/.vnc/xstartup

chmod +x ~/.vnc/xstartup

vncserver -geometry 1366x768 -localhost

echo "Use the following command to connect"
echo "\n"
echo "ssh -L 5900:localhost:5901 -N -f -l root <server-public-ipv4>"
