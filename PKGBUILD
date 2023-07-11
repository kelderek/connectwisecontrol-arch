# Created 01/19/2023 by Michael Magill
# https://github.com/Kelderek/connectwisecontrol-arch

# YOU NEED TO EDIT THE LINE BELOW!
connectwiseurl="YOUR SERVER'S DEB FILE DOWNLOAD LINK OR THE FILENAME IF YOU ALREADY DOWNLOADED THE DEB FILE"
# e.g.
# connectwiseurl="ConnectWiseControl.ClientSetup.deb"
# or
# connectwiseurl="https://myserver.mydomain.com/ScreenConnect/Bin/ConnectWiseControl.ClientSetup.deb?h=myserserver.mydomain.com&p=8041&k=really long key"
# if using the url, expect it to be 500+ characters long.  Just make sure the whole thing is in quotes!

pkgname="connectwisecontrol"
pkgver="2.0"
pkgrel="2.0"
pkgdesc="Install ConnectWise Control based on the deb file"
arch=("x86_64")
depends=("jre-openjdk"
   "inetutils"
   "xorg-xdpyinfo")
install=connectwisecontrol.install
source=("ConnectWiseControl.ClientSetup.deb::${connectwiseurl}"
   "reset-displays.sh"
   "connectwisecontrol.service")
# Skipping the checksum for the source deb package as it will be different for every setup
sha512sums=("SKIP"
   "f7bb99d41d5f1cfc4d81dff1020c7fe60413c1cc2604e9c37998c90734b1cb146a499fb334eeb33ac6aec2095772fcb7984cc06ed03cd3b63879b543741df67d"
   "5a786bee7a2059785ee5b98963fd8f52ff45e825aaa028b2a5ee4176b6e8089e8a3e21feafcd4c95196d7c4a2473f6f5a2d60e6a613a71e7f2317c59aee11554")

package() {
   tar xf "data.tar.gz"
   tar xf "control.tar.gz"
   cp -rp "${srcdir}/opt" "${pkgdir}/opt"
   connectwiseid=$(ls ${srcdir}/opt | sed 's/connectwisecontrol-//')
   cp -p "${srcdir}/postinst" "${pkgdir}/opt/connectwisecontrol-${connectwiseid}/postinst"
   sed -i "s/CONNECTWISEID/${connectwiseid}/g" reset-displays.sh
   install -m555 "${srcdir}/reset-displays.sh" "${pkgdir}/opt/connectwisecontrol-${connectwiseid}/reset-displays.sh"
   install -m744 "${srcdir}/etc/init.d/connectwisecontrol-${connectwiseid}" "${pkgdir}/opt/connectwisecontrol-${connectwiseid}/connectwisecontrol-${connectwiseid}.initrd"
   sed -i "s/CONNECTWISEID/${connectwiseid}/g" connectwisecontrol.service
   install -Dm644 "${srcdir}/connectwisecontrol.service" "${pkgdir}/opt/connectwisecontrol-${connectwiseid}/connectwisecontrol-${connectwiseid}.service"
   mkdir -p "${pkgdir}/etc/systemd/system/"
   ln -s "/opt/connectwisecontrol-${connectwiseid}/connectwisecontrol-${connectwiseid}.service" "${pkgdir}/etc/systemd/system/connectwisecontrol-${connectwiseid}.service"
}
