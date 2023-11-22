#!/bin/bash

log_date=`date +"%Y-%m-%d %H:%M:%S"`

# chmod 777 sqlite3.db
# chmod 777 /etc/openvpn
db_path="/etc/openvpn/sqlite3.db"

sql_exec() {
    rst=`echo $1 | sqlite3 $db_path`
    if [[ $? -ne 0 ]];then
        exit 1
    fi
    echo $rst
}

if [[ -z "$bytes_received" ]];then
    sql_exec "insert into sys_logininfor(user_name, ipaddr, login_location, browser, status, msg, login_time) values('$username', '$untrusted_ip', 'openvpn', '$ifconfig_pool_local_ip', '0', 'connected', '$log_date');"
else
    sql_exec "insert into sys_logininfor(user_name, ipaddr, login_location, browser, os, status, msg, login_time) values('$username', '$untrusted_ip', 'openvpn', '$bytes_received', '$bytes_sent', '0', 'disconnected', '$log_date');"
fi
