#!/bin/bash
nano /etc/locale.gen
locale-gen
hwclock --systohc
nano /etc/locale.conf
nano /etc/vconsole.conf

nano /etc/hostname
nano /etc/hosts
passwd
useradd -mG wheel kevo
passwd kevo
EDITOR=nano visudo

grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
systemctl enable NetworkManager

echo "DONE."
