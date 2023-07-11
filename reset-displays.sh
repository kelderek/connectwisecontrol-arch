#!/bin/sh
echo "**Do NOT run this as root or with sudo, run it as a normal user**"
echo "Stopping the ConnectWise service then running it manually as the current user."
echo "After 30 seconds it should have started and updated the display info on the"
echo "server, so it will be stopped and the service will be restarted."
echo
read -p "Press ctrl-c to cancel or enter to continue..."
sudo systemctl stop connectwisecontrol-CONNECTWISEID
timeout 30 $(grep launchCommandLine= /opt/connectwisecontrol-CONNECTWISEID/connectwisecontrol-CONNECTWISEID.initrd | cut -d\' -f2)
sudo systemctl start connectwisecontrol-CONNECTWISEID
