# connectwisecontrol-arch
PKGBUILD scripts to convert a connectwise control deb file for use on arch

### Usage
1. Download the repo into a folder
2. Edit the PKGBUILD file to use your server's deb file with either URL or a downloaded file:
* For a deb file, copy it to the folder with the files from this repo.  In PKGBUILD set the connectwiseurl to the name of the deb file. Make sure it is enclosed in quotes!
* For the URL go to Access, click Build +, set the type to .deb, set any other info on that screen that you want, and click Copy URL.  In PKGBUILD set the connectwiseurl to the copied URL.  Make sure it is enclosed in quotes!
3. Go to the folder with the PKGBUILD file and run ```makepkg -si```

That should be all you need!  It will download the deb file, extract it, install jre8-openjdk, configure and install ConnectWise Control, and setup a systemd service set to autostart.

### Notes
Why Java 8?  I know it is ancient but that is the only version that worked properly in my testing.  The deb package lists java5-runtime as a dependency.

Uninstalling from the ConnectWise web GUI doesn't work, you will need to use ```pacman -S connectwisecontrol```

The folder and service names use the annoying connectwisecontrol-biglongserverid format so it shouldn't conflict with multiple ConnectWise Control installs, but you would need to modify the pkgname field in PKGBUILD file in order to use this package multiple times.

### Modification to the way the client works
1) The package name itself is just connectwisecontrol instead of the deb package's name of connectwisecontrol-{connectwiseid}
2) The deb package's postinst script is added to the connectwise files in /opt so it is available for pkgbuild to run post install
3) The initrd script is given an initrd extension and moved to the connectwise files in the /opt folder for use starting and stopping the service
4) I didn't install the /usr/share/lintian/overrides/connectwisecontrol-{connectwiseid} because Lintian is Debian package checker and therefore not relevant in this case
