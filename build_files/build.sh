#!/bin/bash

set -ouex pipefail

# Update dconf databases from config files
dconf update

# Remove steam auto-start
rm /etc/skel/.config/autostart/steam.desktop

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 install -y gnome-shell-extension-gpaste

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

dnf5 -y copr enable atim/starship
dnf5 -y install starship

### Install non-packaged tools
# chezmoi
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /usr/bin

# ble.sh
mkdir -p /tmp/blesh
pushd /tmp/blesh
git clone https://github.com/akinomyoga/ble.sh.git
make -C ble.sh install PREFIX=/usr
popd
rm -rf /tmp/blesh

### Add flatpaks
echo com.discordapp.Discord >> /usr/share/ublue-os/bazzite/flatpak/install
echo ca.desrt.dconf-editor >> /usr/share/ublue-os/bazzite/flatpak/install

#### Example for enabling a System Unit File

systemctl enable podman.socket

dnf5 clean all
