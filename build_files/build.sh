#!/bin/bash

set -ouex pipefail

# Update dconf databases from config files
dconf update

# Configure tuned-ppd to use my_powersave profile
sed -i 's/power-saver=powersave/power-saver=my_powersave/' /etc/tuned/ppd.conf

# Remove steam auto-start
rm /etc/skel/.config/autostart/steam.desktop

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 install -y gnome-shell-extension-gpaste
dnf5 install -y hwinfo

# Add Koi
dnf5 -y copr enable birkch/Koi
dnf5 -y install Koi

# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

### Install non-packaged tools
# chezmoi
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /usr/bin

### Add flatpaks
echo com.discordapp.Discord >> /usr/share/ublue-os/bazzite/flatpak/install
echo ca.desrt.dconf-editor >> /usr/share/ublue-os/bazzite/flatpak/install

# Install adwaita nerd-font
curl -Lo /tmp/AdwaitaMono.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/AdwaitaMono.zip
unzip /tmp/AdwaitaMono.zip -d /usr/share/fonts/adwaita-mono-nerd-fonts/
fc-cache

#### Example for enabling a System Unit File

systemctl enable podman.socket
systemctl enable fw-fanctrl.service

dnf5 clean all
