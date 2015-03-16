#!/bin/bash

#Run site.yaml for setting up or enforcing site policies
ansible-playbook --syntax-check --list-tasks -i hosts/host_only site.yaml
RETURN_CODE=$?

if [[ "$RETURN_CODE" = "0" ]]; then
    ansible-playbook -i hosts/host_only site.yaml
fi

