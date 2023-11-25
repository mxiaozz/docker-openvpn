#!/bin/bash

if [ "$common_name" == "$username" ]; then
	exit 0
else
	echo "cn: $common_name 与 username: $username 不一致"
	exit 1
fi

