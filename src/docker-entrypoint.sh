#!/bin/sh

addgroup \
	-g $GID \
	-S \
	$FTP_USER

adduser \
	-D \
	-G $FTP_USER \
	-h /home/$FTP_USER \
	-s /bin/false \
	-u $UID \
	$FTP_USER

config_file="/etc/vsftpd.conf"

config_line_addr="pasv_address="
new_config_line_addr="pasv_address=$PASV_ADDRESS"
sed -i "s/$config_line_addr.*/$new_config_line_addr/" "$config_file"

config_line_min="pasv_min_port="
new_config_line_min="pasv_min_port=$PASV_MIN_PORT"
sed -i "s/$config_line_min.*/$new_config_line_min/" "$config_file"

config_line_max="pasv_max_port="
new_config_line_max="pasv_max_port=$PASV_MAX_PORT"
sed -i "s/$config_line_max.*/$new_config_line_max/" "$config_file"



mkdir -p /home/$FTP_USER
chown -R $FTP_USER:$FTP_USER /home/$FTP_USER
echo "$FTP_USER:$FTP_PASS" | /usr/sbin/chpasswd

touch /var/log/vsftpd.log
tail -f /var/log/vsftpd.log | tee /dev/stdout &
touch /var/log/xferlog
tail -f /var/log/xferlog | tee /dev/stdout &

exec "$@"
