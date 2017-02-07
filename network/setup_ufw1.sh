
ufw deny all
ufw add ssh
ufw add ntp
ufw add http
ufw add 2200/tcp
ufw enable

cp /etc/ssh/sshd_config /etc/ssh/sshd_config.old
cat /etc/ssh/sshd_config.old | sed 's/^Port/Port 22/' >/etc/ssh/sshd_config

echo "Now log out and ssh back in
