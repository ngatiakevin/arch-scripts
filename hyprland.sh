#!/bin/bash
set -e
sudo pacman -S grub --noconfirm
sudo mkdir -p /boot/grub/themes/fallout
wget https://github.com/sszn4kev/My-Arch-Install-Scripts-Files/blob/main/scripts/fallout-grub-theme.txt
wget https://github.com/sszn4kev/My-Arch-Install-Scripts-Files/blob/main/scripts/fallout_grub_2560x1440.jpg

sudo mv fallout-grub-theme.txt \
  /boot/grub/themes/fallout/fallout-grub-theme.txt

sudo mv fallout_grub_2560x1440.jpg \
  /boot/grub/themes/fallout/fallout_grub_2560x1440.jpg

### ---- WAYBAR / HYPRLAND CONFIG SYMLINKS ----
mkdir -p ~/.config/waybar ~/.config/hypr
mkdir -p ~/Documents ~/Downloads ~/Pictures ~/Videos
mkdir -p ~/Documents/scripts
cd Documents
cd scripts
wget https://raw.githubusercontent.com/sszn4kev/My-Arch-Install-Scripts-Files/main/scripts/style.css
wget https://raw.githubusercontent.com/sszn4kev/My-Arch-Install-Scripts-Files/main/scripts/reloadwaybar.sh
wget https://raw.githubusercontent.com/sszn4kev/My-Arch-Install-Scripts-Files/main/scripts/hyprland.conf
wget https://raw.githubusercontent.com/sszn4kev/My-Arch-Install-Scripts-Files/main/scripts/config.jsonc
wget https://raw.githubusercontent.com/sszn4kev/My-Arch-Install-Scripts-Files/main/scripts/wofi-toggle


ln -sf ~/Documents/scripts/style.css ~/.config/waybar/style.css
ln -sf ~/Documents/scripts/config.jsonc ~/.config/waybar/config.jsonc
ln -sf ~/Documents/scripts/hyprland.conf ~/.config/hypr/hyprland.conf
cd ~

#download files from github 


### ---- PACMAN PACKAGES ----
sudo pacman -S --noconfirm --needed\
  wget brightnessctl hyprland swaylock wofi waybar dolphin \
  alacritty konsole sddm power-profiles-daemon \
  chromium polkit xorg-xhost xorg-xauth nm-applet \
  linux-zen linux-zen-headers \
  git base-devel kate nano mesa gwenview okular ark bluedevil powerdevil 


### ---- INSTALL YAY ----
if ! command -v yay >/dev/null 2>&1; then
  cd /tmp
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si --noconfirm
fi

### ---- AUR PACKAGES ----
yay -S --noconfirm \
  librewolf-bin \
  visual-studio-code-insiders-bin \
  timeshift-autosnap wlogout google-chrome-beta 


### ---- GRUB ----

sudo grub-mkconfig -o /boot/grub/grub.cfg


### ---- ENABLE SERVICES ----
sudo systemctl enable sddm
sudo systemctl enable bluetooth
systemctl --user enable --now waybar.service



### ---- DAEMON RELOAD ----
sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo systemctl daemon-reload
echo "DONE."
