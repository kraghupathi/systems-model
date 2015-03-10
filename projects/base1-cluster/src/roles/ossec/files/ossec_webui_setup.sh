#!/usr/bin/expect -f
 
spawn ./setup.sh

expect "Username:" 
send "saurabh\r"
expect "password:" 
send "rekall123\r"
expect "password:"
send "rekall123\r"
expect "user name"
send "apache\r"
expect "directory path"
send "/var/ossec\r"

expect "anything that will not be there krati is responsible"
send_user "$expect_out(buffer)"

