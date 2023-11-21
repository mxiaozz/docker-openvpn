#!/bin/bash

log_date=`date +"%Y-%m-%d %H:%M:%S"`

db_path="/etc/openvpn/ovpn_users.db"

sql_exec() {
    rst=`echo $1 | sqlite3 $db_path`
    if [[ $? -ne 0 ]];then
        exit 1
    fi
    echo $rst
}

if [[ -z "$bytes_received" ]];then
    sql_exec "insert into ovpn_users(user_name, ipaddr, login_location, status, msg, login_time) values('"$username"', '"$untrusted_ip"', 'openvpn', '1', 'connected', '"$log_date"');"
else
    sql_exec "insert into ovpn_users(user_name, ipaddr, login_location, status, msg, login_time) values('"$username"', '"$untrusted_ip"', 'openvpn', '1', 'disconnected', '"$log_date"');"
fi
