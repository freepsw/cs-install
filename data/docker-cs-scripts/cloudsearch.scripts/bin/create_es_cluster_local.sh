
#!bin/bash 

#path=$1 

#cd ${path}
cd ..


ansible-playbook -i inventories/hosts cloudsearch.yml -e \
"\
stack_name=cloudsearchchoi \
es_port=9300 \
kibana_port=5601 \
es_cluster_name=cloudsearchchoi \
es_mem=4096m \
es_cpu_core=1500 \
es_jvm_heap=2g \
es_type=C3 \
"






