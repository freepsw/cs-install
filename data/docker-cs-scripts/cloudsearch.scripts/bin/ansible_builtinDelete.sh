
cd $1
DATA=$2
#DATA=`echo ${DATA} | awk '{gsub(" ", "\\\u0200", $0); print}'`

echo "=============="
echo ${DATA}
echo "=============="

#echo "ansible-playbook -i inventories/hosts builtin_install.yml -e ${DATA}"

ansible-playbook -i inventories/hosts builtin_delete.yml -e "${DATA}"

