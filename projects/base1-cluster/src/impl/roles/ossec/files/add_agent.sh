#!/bin/bash

cat > ossec_agent_input.txt <<EOF
A
$1
$1

y
Q
EOF

/var/ossec/bin/manage_agents < ossec_agent_input.txt

rm -f ossec_agent_input.txt

exit 0

