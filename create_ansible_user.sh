#!/bin/bash

# Check if the script is being run as root
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root" >&2
  exit 1
fi

# Create the ansible-user
useradd -m -s /bin/bash ansible-user

# Set a password for ansible-user (change 'yourpassword' to the desired password)
echo "ansible-user:Ansible17@" | chpasswd

# Add ansible-user to the sudoers file with no password requirement
echo "ansible-user ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ansible-user

# Set correct permissions for the sudoers file
chmod 0440 /etc/sudoers.d/ansible-user

# Verify the user was created and has sudo privileges
if id "ansible-user" &>/dev/null; then
  echo "User ansible-user created successfully."
  echo "User ansible-user has been granted sudo privileges."
else
  echo "Failed to create user ansible-user." >&2
  exit 1
fi