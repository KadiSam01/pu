#!/bin/bash

# List of allowed users (Scoring Users)
SCORING_USERS=(
    "camille_jenatzy" "gaston_chasseloup" "leon_serpollet" "william_vanderbilt"
    "henri_fournier" "maurice_augieres" "arthur_duray" "henry_ford"
    "louis_rigolly" "pierre_caters" "paul_baras" "victor_hemery"
    "fred_marriott" "lydston_hornsted" "kenelm_guinness" "rene_thomas"
    "ernest_eldridge" "malcolm_campbell" "ray_keech" "john_cobb"
    "dorothy_levitt" "paula_murphy" "betty_skelton" "rachel_kushner"
    "kitty_oneil" "jessi_combs" "andy_green"
)

# Get all real users on the system (excluding system accounts)
CURRENT_USERS=$(awk -F: '{ if ($3 >= 1000) print $1}' /etc/passwd)

# Loop through system users
for user in $CURRENT_USERS; do
    # Check if user is in the allowed list
    if [[ ! " ${SCORING_USERS[@]} " =~ " $user " ]]; then
        echo "❌ Deleting unauthorized user: $user"
        sudo userdel -r "$user"
    else
        echo "✅ User is authorized: $user"
    fi
done

echo "🚀 Cleanup completed."
