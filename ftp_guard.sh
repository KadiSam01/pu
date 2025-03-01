#!/bin/bash

# Configuration
FTP_SERVICE="vsftpd"
FTP_DIR="/mnt/files"
BACKUP_DIR="/backup"
SCRIPT_PATH="/usr/local/bin/.ftp_guard.sh"
VSFTPD_CONF="/etc/vsftpd/vsftpd.conf"
USER_LIST="/etc/vsftpd/user_list"
LOG_FILE="/var/log/ftp_security.log"
CRON_JOB="*/2 * * * * root $SCRIPT_PATH"
SCORING_USERS=(
    "camille_jenatzy" "gaston_chasseloup" "leon_serpollet" "william_vanderbilt"
    "henri_fournier" "maurice_augieres" "arthur_duray" "henry_ford"
    "louis_rigolly" "pierre_caters" "paul_baras" "victor_hemery"
    "fred_marriott" "lydston_hornsted" "kenelm_guinness" "rene_thomas"
    "ernest_eldridge" "malcolm_campbell" "ray_keech" "john_cobb"
    "dorothy_levitt" "paula_murphy" "betty_skelton" "rachel_kushner"
    "kitty_oneil" "jessi_combs" "andy_green"
)

FILES_TO_CHECK=(
    "iron_cross.data" "3_point_molly.data" "dark_side.data"
    "come_dont_come.data" "odds.data" ".house_secrets.data"
    "pass_line.data" "risky_roller.data" "covered_call.data"
    "married_put.data" "bull_call.data" "protective_collar.data"
    "long_straddle.data" "long_strangle.data" "long_call_butteryfly.data"
    "iron_condor.data" "iron_butterfly.data" "short_put.data"
    "data_dump_1.bin" "data_dump_2.bin" "data_dump_3.bin" "datadump.bin"
)

# Ensure backup directory and log file exist
mkdir -p "$BACKUP_DIR"
touch "$LOG_FILE"
chmod 600 "$LOG_FILE"  # Secure the log file

echo "🚀 FTP Security Monitor Started" | tee -a "$LOG_FILE"

# 🔄 Ensure `vsftpd` is running
restart_ftp() {
    systemctl restart "$FTP_SERVICE"
    sleep 3
    if systemctl is-active --quiet "$FTP_SERVICE"; then
        echo "✅ FTP service restored." | tee -a "$LOG_FILE"
    else
        echo "❌ FTP service failed to restart!" | tee -a "$LOG_FILE"
    fi
}

# 🔄 Restore vsftpd config if tampered
restore_vsftpd_config() {
    if [[ ! -f "$VSFTPD_CONF" ]] || ! cmp -s "$VSFTPD_CONF" "$BACKUP_DIR/vsftpd.conf.bak"; then
        echo "⚠️ Restoring vsftpd.conf" | tee -a "$LOG_FILE"
        cp "$BACKUP_DIR/vsftpd.conf.bak" "$VSFTPD_CONF"
        restart_ftp
    fi
    chattr +i "$VSFTPD_CONF"
}

# 🔄 Restrict FTP access to authorized users only
secure_user_list() {
    echo "" > "$USER_LIST"
    for user in "${SCORING_USERS[@]}"; do
        echo "$user" >> "$USER_LIST"
    done
    chattr +i "$USER_LIST"
}

# 🔄 Ensure scoring files exist
verify_ftp_read() {
    for FILE in "${FILES_TO_CHECK[@]}"; do
        FILE_PATH="$FTP_DIR/$FILE"
        BACKUP_FILE="$BACKUP_DIR/$FILE"

        if [[ ! -f "$FILE_PATH" ]]; then
            echo "⚠️ Restoring missing file: $FILE" | tee -a "$LOG_FILE"
            cp "$BACKUP_FILE" "$FILE_PATH"
        elif ! cmp -s "$FILE_PATH" "$BACKUP_FILE"; then
            echo "⚠️ Restoring modified file: $FILE" | tee -a "$LOG_FILE"
            cp "$BACKUP_FILE" "$FILE_PATH"
        fi
    done
}

# 🔄 Ensure FTP directory is writable
set_ftp_permissions() {
    chmod 770 "$FTP_DIR"
    chown ftpuser:ftpgroup "$FTP_DIR"
    setfacl -m u:ftpuser:rwx "$FTP_DIR"
}

# 🔄 Protect script from tampering
protect_script() {
    cp "$SCRIPT_PATH" "$BACKUP_DIR/.ftp_guard.sh.bak"
    chattr +i "$SCRIPT_PATH"
}

# 🔄 Restore script if deleted
ensure_script_persistence() {
    grep -q "$SCRIPT_PATH" /etc/crontab || echo "$CRON_JOB" >> /etc/crontab
    chattr +i /etc/crontab
    
    if [[ ! -f "$SCRIPT_PATH" ]]; then
        cp "$BACKUP_DIR/.ftp_guard.sh.bak" "$SCRIPT_PATH"
        chmod +x "$SCRIPT_PATH"
    fi
}

# 🚀 Main Execution Loop
while true; do
    restore_vsftpd_config
    secure_user_list
    verify_ftp_read
    set_ftp_permissions  # Allow writing
    protect_script
    ensure_script_persistence
    restart_ftp
    sleep 1800
done
