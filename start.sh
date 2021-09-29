#!/bin/sh
/etc/init.d/xinetd start;

echo $FLAG > /home/ctf/flag
ln /home/ctf/flag /flag
chmod 744 /flag
chmod 744 /home/ctf/flag
FLAG=not_flag
USER=u
PASS=p

rm -rf /root/*.sh

sleep 5s
/usr/bin/tail -f /dev/null
