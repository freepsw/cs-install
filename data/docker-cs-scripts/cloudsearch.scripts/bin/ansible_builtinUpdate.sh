
cd $1
CONF_STR=$2

#echo "==================="
#echo ${CONF_STR}
#echo "ansible-playbook -i inventories/hosts builtin_install.yml -e '${CONF_STR}'"
#echo "==================="

ansible-playbook -i inventories/hosts builtin_install.yml -e ${CONF_STR}

