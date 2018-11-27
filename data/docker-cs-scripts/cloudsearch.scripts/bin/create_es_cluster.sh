
#!bin/bash


path=$1
cd ${path}
name=$2
es_port=$3
kibana_port=$4
es_mem=$5
es_cpu_core=$6
es_jvm_heap=$7
es_type=$8
rancher_api_key_user=$9
rancher_api_key_pass=${10}


ansible-playbook -i inventories/hosts cloudsearch.yml -e \
"\
stack_name=$name \
es_port=$es_port \
kibana_port=$kibana_port \
es_cluster_name=$name \
es_mem=$es_mem \
es_cpu_core=$es_cpu_core \
es_jvm_heap=$es_jvm_heap \
es_type=$es_type \
rancher_api_key_pass=$rancher_api_key_pass \
rancher_api_key_user=$rancher_api_key_user
"
