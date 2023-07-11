# connectwisecontrol-arch
PKGBUILD script to convert a ConnectWise Control deb file to an Arch linux package

### Installation
1. **Wayland is not supported**, so make sure you either switch to an X11 session at logon or disable Wayland altogether by uncommenting the following line in /etc/gdm/custom.conf and reboot: ```WaylandEnable=false```
2. Download the repo into a folder (in your browser or with ```git clone https://github.com/Kelderek/connectwisecontrol-arch```)
3. Edit the PKGBUILD file to use your server's deb file with either URL or a downloaded file:
* For a deb file, copy it to the folder with the files from this repo.  In PKGBUILD set the connectwiseurl to the name of the deb file. Make sure it is enclosed in quotes!
* For the URL, on your ConnectWise website go to Access, click Build +, set the type to .deb, set any other info on that screen that you want, and click Copy URL.  Open the PKGBUILD file and paste the URL in to the connectwiseurl variable.  Make sure it is enclosed in quotes!
4. In the folder with the PKGBUILD file and run ```makepkg -si```  That will install the control agent, its dependencies, and setup a systemd service set to autostart.
5. As a regular user with sudo rights, run ```/opt/connectwisecontol-{yourServerId}/reset-displays.sh```.  **Do not run it _as_ root or with sudo**!  It will prompt for credentials when needed, but it needs to start the agent as a regular logged in user.  Further discussion on this is in the notes below.
6. **Here's the critical bit** - because it doesn't detect the displays properly on newer systems, when connecting remotely you will need to _right click_ the agent in the website and choose "Join with Options".  It should look something like this, and you will probably want either :0 or :1.  It may be different on your system, but generally the one that is a : and a number is the one you want.
![Join Options](https://github.com/kelderek/connectwisecontrol-arch/assets/6126101/cead9cd4-2065-4644-93aa-18bffe3ff349)

### Notes
The agent seems to have trouble detecting the X session and connecting to it on a modern system.  Some of that I was able to mitigate with the dependencies I added, but it still has trouble.  Fixing that is beyond my control - ConnectWise will have to do it.  In the meantime I added the reset-displays.sh script, which temporarily runs the agent as the user instead of the system so it can find the correct X11 display(s).  Unfortunately, when the agent restarts as system the regular join method can't see those options anymore, but luckily the are still cached in the server's session manager service, so you can use Join with Options as described in the installation instructions above to tell it what display server you need.

The problem is those cached optinos will get lost periodically, for example whenever the session manager service is restarted on the ConnectWise Control server.  The specific session you need to pick may also change based on something happening on the system like an Xorg update, or possibly adding/removing monitors.  If something like that happens, you can run the reset-displays.sh script again and it should pick up the changes.  It isn't an elegant solution, but it is the best I could do; ConnectWise are the only ones who can really fix it.

The agent will connect before logon, but will not display the logon screen.  As far as I can tell, this is a limitation of ConnectWise Control for Linux systems as it works that way on Ubuntu and Fedora as well.  You are still able to issue commands to the agent through the ConnectWise Control website and once the system is logged in it will be able to connect the video.

The folder and service names use the connectwisecontrol-{connectwiseid} format so it shouldn't conflict with multiple ConnectWise Control installs.  Most people won't need multiple agents installed on the same system, but if you need that you will need to modify the pkgname field in PKGBUILD file in order to use this package multiple times.  The install folder, service, etc. will all follow what is in the deb file.

Uninstalling from the ConnectWise website doesn't work, you will need to run ```pacman -Rs connectwisecontrol```

### Dependencies
* jre-openjdk - the control agent is Java based so java is required.  If you want a different version of java you can change this.  I have seen it work with jre8-openjdk and jre17-openjdk.   It will probably work with other versions as well
* inetutils - this is for the hostname command that the agent uses internally when getting display info and connecting to X.
* xorg-xdpyinfo - the agent uses this get information on the display session.  This one isn't _strictly_ necessary but it does reduce the number of bogus displays listed

### Modifications to the ConnectWise Control agent
1) The package name itself is just connectwisecontrol instead of the deb package's name of connectwisecontrol-{connectwiseid}
2) The deb package's postinst script is added to the connectwise files in /opt so it is available for pkgbuild to run post install
3) The initrd script is given an initrd extension and moved to the connectwise files in the /opt folder for use starting and stopping the service
4) Added the reset-displays.sh script and connectwisecontrol-{connectwiseid}.service systemd unit file
5) I didn't install the /usr/share/lintian/overrides/connectwisecontrol-{connectwiseid} because Lintian is a Debian package checker and therefore not relevant in this case
