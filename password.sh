#!/bin/bash

# Define the password hash
PASSWORD_HASH='$6$KHk2hJlrIZKWxWA9$z2OrpVg05wxoUp/BL12VY9rvxvgyZhta.qKf9SwckeNMcW4QvCJACSA4QyBwy88UpPAGDrskbu7rb7sh8fbnM1'

# List of FTP scoring users
USERS=(
    camille_jenatzy gaston_chasseloup leon_serpollet william_vanderbilt
    henri_fournier maurice_augieres arthur_duray henry_ford louis_rigolly
    pierre_caters paul_baras victor_hemery fred_marriott lydston_hornsted
    kenelm_guinness rene_thomas ernest_eldridge malcolm_campbell ray_keech
    john_cobb dorothy_levitt paula_murphy betty_skelton rachel_kushner
    kitty_oneil jessi_combs andy_green
)

# Loop through each user and update their password
for user in "${USERS[@]}"; do
    if id "$user" &>/dev/null; then
        echo "$user exists, updating password..."
        sudo usermod --password "$PASSWORD_HASH" "$user"
    else
        echo "$user does not exist, skipping..."
    fi
done

echo "Password update process completed."
