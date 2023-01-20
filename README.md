# connectwisecontrol-arch
PKGBUILD scripts to convert a connectwise control deb file for use on arch

1) Download the repo into a folder
2) Edit the PKGBUILD file to use to server's deb file download (Access > Build > set type to .deb > copy URL)
3) Go to the folder with the PKGBUILD file and run makepkg -si

That should be all you need!  It will download the deb file, extract it, install jre8-openjdk, configure and install ConnectWise Control, and setup a systemd service set to autostart.

Why Java 8?  I know it is ancient but that is the only version that worked properly in my testing.  The deb package lists java5-runtime as a dependency.

Uninstalling from the ConnectWise web GUI doesn't work, you will need to use pacman -S connectwisecontrol

The folder and service names use the annoying connectwisecontrol-biglongserverid format so it shouldn't conflict with multiple ConnectWise Control installs, but you would need to modify the pkgname field in PKGBUILD file in order to use this package multiple times.
