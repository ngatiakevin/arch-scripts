#!/bin/bash
set -eu

# -----------------------------
# Initial Checks
# -----------------------------
echo "===================================="
echo "Hybrid Arch Installer (Interactive)"
echo "All data on /dev/sda will be erased!"
echo "===================================="
read -rp "Type YES to continue: " CONFIRM
[[ "$CONFIRM" == "YES" ]] || exit 1

# Confirm UEFI
if [[ ! -d /sys/firmware/efi ]]; then
  echo "ERROR: System not booted in UEFI mode"
  exit 1
fi

timedatectl set-ntp true
cat /sys/firmware/efi/fw_platform_size

# -----------------------------
# Partitioning (Interactive)
# -----------------------------
echo
echo "=== Partition the disk using cfdisk ==="
echo "Create partitions:"
echo "1) EFI 512MB"
echo "2) Root 236G"
echo "3) Swap 2G"
echo "Write and exit cfdisk to continue"
sudo cfdisk /dev/sda

# -----------------------------
# Filesystems & Mounting
# -----------------------------
echo
echo "=== Creating filesystems ==="
sudo mkfs.fat -F 32 /dev/sda1
sudo mkfs.btrfs -f /dev/sda2
sudo mkswap /dev/sda3
sudo swapon /dev/sda3

echo
echo "=== Mounting root and creating Btrfs subvolumes ==="
sudo mount /dev/sda2 /mnt
sudo btrfs subvolume create /mnt/@
sudo btrfs subvolume create /mnt/@home
sudo umount /mnt

sudo mount -o compress=zstd,subvol=@ /dev/sda2 /mnt
sudo mkdir -p /mnt/home
sudo mount -o compress=zstd,subvol=@home /dev/sda2 /mnt/home

sudo mkdir -p /mnt/efi
sudo mount /dev/sda1 /mnt/efi

# -----------------------------
# Install Base System
# -----------------------------
echo
echo "=== Installing base system ==="
sudo pacstrap -K /mnt \
  base base-devel linux-zen linux-zen-headers intel-ucode nano linux-firmware git btrfs-progs \
  grub efibootmgr grub-btrfs inotify-tools timeshift \
   networkmanager pipewire pipewire-alsa pipewire-pulse pipewire-jack \
  wireplumber reflector zsh zsh-completions zsh-autosuggestions  man sudo sddm 

echo
echo "=== Generating fstab ==="
genfstab -U /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab


arch-chroot /mnt 