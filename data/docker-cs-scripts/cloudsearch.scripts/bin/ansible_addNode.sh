
#!bin/bash

cd $1
ansible-playbook -i inventories/hosts cloudsearch_add_node.yml -e "$2 $3 $4 $5 $6 $7 $8 $9 $10"


