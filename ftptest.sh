#!/bin/bash

# Define the FTP group and directory
FTP_GROUP="ftpuser"
FTP_DIR="/mnt/files"

# List of scoring users
SCORING_USERS=(
    "camille_jenatzy" "gaston_chasseloup" "leon_serpollet" "william_vanderbilt"
    "henri_fournier" "maurice_augieres" "arthur_duray" "henry_ford"
    "louis_rigolly" "pierre_caters" "paul_baras" "victor_hemery"
    "fred_marriott" "lydston_hornsted" "kenelm_guinness" "rene_thomas"
    "ernest_eldridge" "malcolm_campbell" "ray_keech" "john_cobb"
    "dorothy_levitt" "paula_murphy" "betty_skelton" "rachel_kushner"
    "kitty_oneil" "jessi_combs" "andy_green"
)

# Ensure the ftpuser group exists
if ! grep -q "^$FTP_GROUP:" /etc/group; then
    echo "Creating group: $FTP_GROUP"
    sudo groupadd "$FTP_GROUP"
else
    echo "Group $FTP_GROUP already exists."
fi

# Add each user to the ftpuser group
for USER in "${SCORING_USERS[@]}"; do
    if id "$USER" &>/dev/null; then
        echo "Adding $USER to $FTP_GROUP..."
        sudo usermod -aG "$FTP_GROUP" "$USER"
    else
        echo "User $USER does not exist, skipping..."
    fi
done

# Change the group ownership of /mnt/files
echo "Setting group ownership of $FTP_DIR to $FTP_GROUP..."
sudo chown -R :$FTP_GROUP "$FTP_DIR"

# Set proper permissions
echo "Setting permissions for $FTP_DIR..."
sudo chmod -R 770 "$FTP_DIR"

# Ensure ACLs are applied so the group retains access
echo "Applying ACL permissions..."
sudo setfacl -m g:$FTP_GROUP:rwx "$FTP_DIR"

echo "✅ All valid users added to $FTP_GROUP, and $FTP_DIR is secured!"
