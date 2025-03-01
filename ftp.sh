#!/bin/bash

# Define the target directory
FTP_DIRECTORY="/mnt/files"

# Ensure the directory exists
mkdir -p "$FTP_DIRECTORY"

# List of files to create
FILES=(
    "iron_cross.data"
    "3_point_molly.data"
    "dark_side.data"
    "come_dont_come.data"
    "odds.data"
    ".house_secrets.data"
    "pass_line.data"
    "risky_roller.data"
    "covered_call.data"
    "married_put.data"
    "bull_call.data"
    "protective_collar.data"
    "long_straddle.data"
    "long_strangle.data"
    "long_call_butteryfly.data"
    "iron_condor.data"
    "iron_butterfly.data"
    "short_put.data"
    "data_dump_1.bin"
    "data_dump_2.bin"
    "data_dump_3.bin"
    "datadump.bin"
)

# Create each file
for file in "${FILES[@]}"; do
    touch "$FTP_DIRECTORY/$file"
done

# Set correct permissions (optional)
chmod 644 "$FTP_DIRECTORY"/*

echo "All files have been created in $FTP_DIRECTORY"
