#!/bin/bash

# Define the allowed FTP users
FTP_USERS=(
  camille_jenatzy gaston_chasseloup leon_serpollet william_vanderbilt henri_fournier
  maurice_augieres arthur_duray henry_ford louis_rigolly pierre_caters paul_baras
  victor_hemery fred_marriott lydston_hornsted kenelm_guinness rene_thomas
  ernest_eldridge malcolm_campbell ray_keech john_cobb dorothy_levitt paula_murphy
  betty_skelton rachel_kushner kitty_oneil jessi_combs andy_green
)

# Path to vsftpd user list
VSFTPD_USER_LIST="/etc/vsftpd.user_list"

# Backup the existing user list
cp $VSFTPD_USER_LIST ${VSFTPD_USER_LIST}.bak

# Add allowed users to vsftpd.user_list
echo "Updating FTP allowed users..."
> $VSFTPD_USER_LIST  # Clear existing file
for user in "${FTP_USERS[@]}"; do
  echo "$user" >> $VSFTPD_USER_LIST
done

# Ensure vsftpd.conf allows user_list
VSFTPD_CONF="/etc/vsftpd.conf"
if ! grep -q "^userlist_enable=YES" $VSFTPD_CONF; then
  echo "userlist_enable=YES" >> $VSFTPD_CONF
fi
if ! grep -q "^userlist_file=$VSFTPD_USER_LIST" $VSFTPD_CONF; then
  echo "userlist_file=$VSFTPD_USER_LIST" >> $VSFTPD_CONF
fi
if ! grep -q "^userlist_deny=NO" $VSFTPD_CONF; then
  echo "userlist_deny=NO" >> $VSFTPD_CONF
fi

# Restart vsftpd service
echo "Restarting vsftpd..."
systemctl restart vsftpd

echo "FTP users successfully updated and vsftpd restarted!"
