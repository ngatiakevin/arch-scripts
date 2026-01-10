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
mkdir -p ~/Documents/scripts/
mkdir -p ~/.local/share/rofi/themes/

wget -P ~/Documents/scripts/ https://raw.githubusercontent.com/sszn4kev/My-Arch-Install-Scripts-Files/main/scripts/style.css
wget -P ~/Documents/scripts/ https://raw.githubusercontent.com/sszn4kev/My-Arch-Install-Scripts-Files/main/scripts/reloadwaybar.sh
wget -P ~/Documents/scripts/ https://raw.githubusercontent.com/sszn4kev/My-Arch-Install-Scripts-Files/main/scripts/hyprland.conf
wget -P ~/Documents/scripts/ https://raw.githubusercontent.com/sszn4kev/My-Arch-Install-Scripts-Files/main/scripts/config.jsonc
wget -P ~/Documents/scripts/ https://raw.githubusercontent.com/sszn4kev/My-Arch-Install-Scripts-Files/main/scripts/wofi-toggle
wget -P ~/Documents/scripts/ https://raw.githubusercontent.com/sszn4kev/My-Arch-Install-Scripts-Files/main/scripts/menu-theme.rasi
wget -P ~/Documents/scripts/ https://raw.githubusercontent.com/sszn4kev/My-Arch-Install-Scripts-Files/main/scripts/clipboard-theme.rasi 

ln -sf ~/Documents/scripts/clipboard-theme.rasi ~/.local/share/rofi/themes/menu-theme.rasi
ln -sf ~/Documents/scripts/menu-theme.rasi ~/.local/share/rofi/themes/clipboard-theme.rasi 

sudo chmod +x ~/Documents/scripts/reloadwaybar.sh
# sudo chmod +x ~/Documents/scripts/
# sudo chmod +x ~/Documents/scripts/
# sudo chmod +x ~/Documents/scripts/

ln -sf ~/Documents/scripts/style.css ~/.config/waybar/style.css
ln -sf ~/Documents/scripts/config.jsonc ~/.config/waybar/config.jsonc
ln -sf ~/Documents/scripts/hyprland.conf ~/.config/hypr/hyprland.conf
cd ~

#download files from github 


### ---- PACMAN PACKAGES ----
sudo pacman -S --noconfirm --needed\
  wget brightnessctl hyprland swaylock hyprshot waybar dolphin \
  alacritty konsole sddm power-profiles-daemon \
  xorg-xhost polkit xorg-xauth \
  linux-zen linux-zen-headers \
  git base-devel kate nano mesa gwenview okular ark bluedevil powerdevil cliphist rofi


### ---- INSTALL YAY ----
if ! command -v yay >/dev/null 2>&1; then
  cd /tmp
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si --noconfirm
fi

### ---- AUR PACKAGES ----
yay -S --noconfirm \
  wlogout \
  visual-studio-code-insiders-bin \
  timeshift-autosnap google-chrome-beta


### ---- GRUB ----
sudo grub-mkconfig -o /boot/grub/grub.cfg


### ---- ENABLE SERVICES ----
sudo systemctl enable sddm
sudo systemctl enable bluetooth


### ---- DAEMON RELOAD ----
sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo systemctl daemon-reload
echo "DONE."
