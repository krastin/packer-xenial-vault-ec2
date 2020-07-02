#!/usr/bin/env bash

## Standard boostrap + workaround for failing apt-get update
apt-get clean
rm -rf /var/lib/apt/lists/partial
apt-get update -o Acquire::CompressionTypes::Order::=gz
apt-get -y install cloud-init
apt-get update
apt-get -y upgrade

## Vault setup
# Add no-password sudo config for vault user
useradd -m vault 
echo "%vault ALL=NOPASSWD:ALL" > /etc/sudoers.d/vault
chmod 0440 /etc/sudoers.d/vault
# Add vault to sudo group
usermod -a -G sudo vault
# Set up vault installer
mv /tmp/configure_vault.sh /home/vault/
chown vault:vault /home/vault/configure_vault.sh
chmod +x /home/vault/configure_vault.sh

## Consul setup
# Add no-password sudo config for consul user
useradd -m consul 
echo "%consul ALL=NOPASSWD:ALL" > /etc/sudoers.d/consul
chmod 0440 /etc/sudoers.d/consul
# Add vault to sudo group
usermod -a -G sudo consul
# Set up vault installer
mv /tmp/configure_consul.sh /home/consul/
chown consul:consul /home/consul/configure_consul.sh
chmod +x /home/vault/configure_vault.sh

# Install Linux headers and compiler toolchain
apt-get -y install build-essential linux-headers-$(uname -r)

# unattended apt-get upgrade
DEBIAN_FRONTEND=noninteractive DEBIAN_PRIORITY=critical apt-get -q -y -o "Dpkg::Options::=--force-confdef" -o "Dpkg::Options::=--force-confold" upgrade

# Install some tools
apt-get -y install jq curl unzip vim tmux cloud-init language-pack-en

apt-get autoremove -y
apt-get clean

# Removing leftover leases and persistent rules
echo "cleaning up dhcp leases"
rm /var/lib/dhcp/*
