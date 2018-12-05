# Cloudsearch Service 배포 및 운영을 위한 ansible script

## [Prerequisite]
### 1. SSH 설정
#### - 1. Ansible 서버에서 원격서버로 접속하기 위한 ssh 설정 필요
- 사전에 ssh 연결을 설정하여, 필요한 인증정보를 로컬에 저장해야 함. (known_hosts)


## [STEP 1. Create Elasticsearch cluster]
### 1) Request example
```
# staging
> ansible-playbook -i inventories/hosts cloudsearch.yml -e "stack_name=cloudsearch11 es_port=9500 kibana_port=5801 es_cluster_name=mycluster11 es_mem=4096m es_cpu_core=1500 es_jvm_heap=2g  es_type=C1 rancher_api_key_user=8EC0A7BA9B3659F5DF9B rancher_api_key_pass=SPdGTa6JtLR5KTsDEeaSyRpLEQQXLpPzXbeFBuYo rancher_server=169.56.72.230 rancher_port=8080"

# public
> ansible-playbook -i inventories/hosts cloudsearch.yml -e "stack_name=cloudsearch11 es_port=9500 kibana_port=5801 es_cluster_name=mycluster11 es_mem=4096m es_cpu_core=1500 es_jvm_heap=2g  es_type=C1 rancher_api_key_user=18A2BFF00FA06D6EDFEE rancher_api_key_pass=6rXCpK5vxVizZoB7saqXZkyGcZTQuJxCSukJxFmM rancher_server=169.56.72.243 rancher_port=8080"

> ansible-playbook -i inventories/hosts cloudsearch.yml -e "stack_name=cloudsearch12 es_port=9666 kibana_port=5991 es_cluster_name=mycluster12 es_mem=2048m es_cpu_core=1000 es_jvm_heap=1g  es_type=C1"
```
####  INPUT Parameter 설명
  * stack_name : rancher의 고유 stack 명 (중복되지 않도록 UseridClusteridYYMMDDHHmmss, 특수문자 사용불가)
  * es_cluster_name : elasticsearch 설정을 위한 clustername
  * es_port : elasticsearch에 접근 가능한 port
  * kibana_port : kibana에 접근 가능한 port
  * es_mem : elasticsearch node(master, data)의 container에 할당할 memory (mb)
  * es_cpu_core : elasticsearch node(master, data)의 container에 할당할 cpu core
    - 1core : 1000
  * es_jvm_heap : elasticsearch node에 할당할 java heap memory
    - jvm heap size는 es_mem 크기의 50%만 할당 하도록 한다.
    - 동일하게 할당 할 경우, 메모리가 부족하여 ES Node가 장상동작하지 못함.
  * es_type : 기존 정의된 es clustar type 코드 (C1, C2, C3)


### 2) Response example
```json
{
    "changed": false,
    "msg": {
        "data_node": [
            {
                "instance_id": "1i1126",
                "ip": "169.56.72.226",
                "name": "DataNode1, 1",
                "port": "59543",
                "service_id": "1s788"
            },
            {
                "instance_id": "1i1127",
                "ip": "169.56.72.226",
                "name": "DataNode2, 2",
                "port": "61501",
                "service_id": "1s786"
            },
            {
                "instance_id": "1i1124",
                "ip": "169.56.72.226",
                "name": "DataNode3, 3",
                "port": "51992",
                "service_id": "1s787"
            }
        ],
        "elasticsearch_endpoint": "169.56.72.226:9200",
        "error_msg": "",
        "kibana_endpoint": "169.56.72.226:5601",
        "kibana_node": {
            "instance_id": "1i1125",
            "ip": "169.56.72.226",
            "name": "Kibana",
            "port": "5601",
            "service_id": "1s789"
        },
        "master_node": {
            "instance_id": "1i1123",
            "ip": "169.56.72.226",
            "name": "MasterNode",
            "port": "9200",
            "service_id": "1s785"
        },
        "project_id": "1a5",
        "result_code": "200",
        "stack_id": "1st280"
    }
}
```
#### OUTPUT Data 설명
  * result_code : 응답 코드 (200, 정상), 상세 오류코드는 아래 참고
  * error_msg : 에러에 대한 상세 메세지
  * elasticsearch_endpoint : elasticsearch 접속 정보
  * kibana_endpoint : kibana 접속 정보
  * project_id : rancher project_id
  * stack_id : rancher stack_id
  * master_node : master 노드에 대한 상세 정보 (instance_id는 container id와 동일)
  * data_node : data 노드에 대한 상세 정보 (instance_id는 container id와 동일)
  * kibana_node : data 노드에 대한 상세 정보 (instance_id는 container id와 동일)

### 3) ERROR_CODE 설명
```
# 1001 : Rancher compose yml Error
# 1002 : Rancher stack creatte es cluster error
# 1003 : Rancher service link connection error (Status code was not [200]: HTTP Error 404: Not Found)
# 1004 : rancher master_node service_link error (Status code was not [200]: HTTP Error 404: Not Found)
# 1005 : Elasticsearch connection error ("Status code was not [200]: Request failed: <urlopen error [Errno 111] Connection refused>")
# 1006 : Rancher data_node service_link error (Status code was not [200]: HTTP Error 404: Not Found)
# 1007 : Rancher kibana_node service_link error (Status code was not [200]: HTTP Error 404: Not Found)
# 1100 : No healthy hosts with sufficient resources available

# healthState : healthy, unhealthy, updating-healthy, updating-unhealthy, initializing
# 에러는 unhealthy,
# https://rancher.com/docs/rancher/v1.3/en/cattle/health-checks/
# 1101 : No healthy hosts with sufficient resources available
```


## [STEP 2. Add Elasticsearch data node]
### 1) Request example
```
> ansible-playbook -i inventories/hosts cloudsearch_add_node.yml -e "rancher_node_name=DataNode9 es_node_name=DataNode9 stack_id=1st130 es_master_instance_id=1i670 es_cluster_name=mycluster11 es_mem=2048m es_cpu_core=1000 es_jvm_heap=1g rancher_api_key_user=8EC0A7BA9B3659F5DF9B rancher_api_key_pass=SPdGTa6JtLR5KTsDEeaSyRpLEQQXLpPzXbeFBuYo rancher_server=stg01 rancher_port=8080"
```





####  INPUT Parameter 설명
* rancher_node_name : rancher 서비스 명
* es_node_name : elasticsearch data node 명
* es_cluster_name : data node에서 접근할 elasticsearch cluster name
* es_master_instance_id: data node에서 "master node"로 접속할 수 있는 master node의 instance_id
* stack_id : kibana에 접근 가능한 port
* es_mem : elasticsearch node(master, data)의 container에 할당할 memory (mb)
* es_cpu_core : elasticsearch node(master, data)의 container에 할당할 cpu core
  - 1core : 1000
* es_jvm_heap : elasticsearch node에 할당할 java heap memory

### 2) Response example
```json
{
  "error_msg": "",
  "node_info": {
      "instance_id": "1i1465",
      "ip": "169.56.72.226",
      "name": "data-node-5",
      "port": "64589",
      "service_id": "1s1017"
  },
  "result_code": "200"
  }
```
#### OUTPUT Data 설명
  * result_code : 응답 코드 (200, 정상), 상세 오류코드는 아래 참고
  * error_msg : 에러에 대한 상세 메세지
  - node_info : 추가된 node에 대한 정보


### 3) ERROR_CODE 설명
```
# 2001 : Rancher compose yml syntax error
# 2002 : Add rancher service(data node) error
# 2003 : Rancher service link connection error (Status code was not [200]: HTTP Error 404: Not Found)
```

## [STEP 3. Create Built in service - Monitoring System]
### 1) Request example
#### 1-1) Install built-in system module
```
> ansible-playbook -i inventories/hosts builtin_install.yml -e '{"domains": [{"ip":"10.178.50.103", "port":"22", "user":"rts", "pass":"!rts!"}, {"ip":"10.178.50.106", "port":"22", "user":"rts", "pass":"!rts!"} ], "es_endpoint": "169.56.72.226:9500", "kibana_endpoint":"169.56.72.226:5801", "module_type": "001",  "conf_file": "conf_system.yml"}'

> ansible-playbook -i inventories/hosts builtin_install.yml -e '{"domains": [{"ip":"169.56.72.226", "port":"22", "user":"rts", "pass":"!rts!"}], "es_endpoint": "169.56.72.226:9500", "kibana_endpoint":"169.56.72.226:5801", "module_type": "001",  "conf_file": "conf_system.yml"}'


-- old version
"conf_text": "- module: system\n  period: 10s \n  metricsets:    \n   - cpu    \n   - load     \n   - memory   \n   - network    \n   - process    \n   - process_summary"}'
```

#### 1-2) Install built-in mysql module
```
> ansible-playbook -i inventories/hosts builtin_install.yml -e '{"domains": [{"ip":"172.16.118.132", "port":"22", "user":"rts", "pass":"!rts!"} ], "es_endpoint": "169.56.72.226:9500", "kibana_endpoint": "169.56.72.226:5801", "module_type": "002",  "conf_file": "conf_mysql.yml"}'
```


#### 1-3) Install built-in kafka module
```
> ansible-playbook -i inventories/hosts builtin_install.yml -e '{"domains": [{"ip":"172.16.118.133", "port":"22", "user":"rts", "pass":"!rts!"},{"ip":"172.16.118.132", "port":"22", "user":"rts", "pass":"!rts!"} ], "es_endpoint": "169.56.72.226:9500", "kibana_endpoint": "169.56.72.226:5801", "module_type": "004",  "conf_file": "conf_kafka.yml"}'
```

#### 1-4) Install built-in apache2 module
```
> ansible-playbook -i inventories/hosts builtin_install.yml -e '{"domains": [{"ip":"169.56.72.226", "port":"22", "user":"rts", "pass":"!rts!"} ], "es_endpoint": "169.56.72.226:9500", "kibana_endpoint": "169.56.72.226:5801", "module_type": "003",  "conf_file": "conf_apache.yml" }'
```

#### 1-5) Install built-in logstash
```
> ansible-playbook -i inventories/hosts builtin_install.yml -e '{"domains": [{"ip":"172.16.118.132", "port":"22", "user":"rts", "pass":"!rts!"}], "es_endpoint": "169.56.72.226:9500", "kibana_endpoint": "169.56.72.226:5801", "module_type": "005",  "conf_file": "conf_logstash.conf" }'

# Vert.X 로그 수집 배포

> ansible-playbook -i inventories/hosts builtin_install.yml -e '{"domains": [{"ip":"169.56.124.28", "port":"2202", "user":"dpcore", "pass":"1234qwer"}], "es_endpoint": "169.56.72.226:9500", "kibana_endpoint": "169.56.72.226:5801", "module_type": "005",  "conf_file": "conf_logstash_vertx.conf" }'
```

#### 1-20) Install built-in heartbeat module
```
> ansible-playbook -i inventories/hosts builtin_install.yml -e '{"domains": [{"ip":"169.56.124.19", "port":"22", "user":"rts", "pass":"!rts!"} ], "es_endpoint": "169.56.72.226:9500", "kibana_endpoint": "169.56.72.226:5801", "module_type": "020",  "conf_file": "conf_heartbeat.yml" }'
```
- heartbeat 은 동적 configuration 업데이트를 지원하지 않음
- 따라서, 설정을 변경하기 위해서는 heartbeat를 중지한 후, 다시 시작해야 한다.


####  INPUT Parameter 설명
```
  * domains : service(beats)를 설치할 host 정보 (config 문자열을 추가필요)
  * es_endpoint : beats configuration 파일에 적용할 es_endpoint
  * kibana_endpoint : beats configuration 파일에 적용할 kibana_endpoint
  * module_type : built-in service의 종류
    - 001 : system
    - 002 : mysql
    - 003 : apache2
    - 004 : kafka
    - 005 : logstash
    - 010 : heartbeat
  * conf_text : 관련된 설정
```


#### 2-1) Update built-in system configuration
```
> ansible-playbook -i inventories/hosts builtin_update_conf.yml -e '{"domains": [{"ip":"172.16.118.132", "port":"22", "user":"rts", "pass":"!rts!"} ], "es_endpoint": "169.56.72.226:9500", "kibana_endpoint":"169.56.72.226:5801", "module_type": "001",  "conf_text": "- module: system\n  period: 10s \n  metricsets:    \n   - cpu    \n   - load     \n   - memory   \n   - network    \n   - process    \n   - process_summary"}'

> ansible-playbook -i inventories/hosts builtin_update_conf.yml -e '{"domains": [{"ip":"172.16.118.132", "port":"22", "user":"rts", "pass":"!rts!"} ], "es_endpoint": "169.56.72.226:9500", "kibana_endpoint":"169.56.72.226:5801", "module_type": "001",  "conf_file": "config_396_001.conf"}'

```

#### 2-2) Update built-in mysql configuration
```
> ansible-playbook -i inventories/hosts builtin_update_conf.yml -e '{"domains": [{"ip":"172.16.118.132", "port":"22", "user":"rts", "pass":"!rts!"} ], "es_endpoint": "169.56.72.226:9500", "kibana_endpoint":"169.56.72.226:5801", "module_type": "002",  "conf_text": "- module: mysql\n  metricsets: ['\''status'\'']\n  period: 5s\n  hosts: ['\''root:@tcp(169.56.124.28:3306)/'\'']"}'

> ansible-playbook -i inventories/hosts builtin_update_conf.yml -e '{"domains": [{"ip":"169.56.72.226", "port":"22", "user":"rts", "pass":"!rts!"} ], "es_endpoint": "169.56.72.226:9500", "kibana_endpoint":"169.56.72.226:5801", "module_type": "001",  "conf_file": "conf_system.yml"}'
```

#### 2-3) Update built-in kafka configuration
```
> ansible-playbook -i inventories/hosts builtin_update_conf.yml -e '{"domains": [{"ip":"172.16.118.132", "port":"22", "user":"rts", "pass":"!rts!"} ], "es_endpoint": "169.56.72.226:9500", "kibana_endpoint":"169.56.72.226:5801", "module_type": "004",  "conf_text": ""}'
```

#### 2-4) Update built-in apache2 configuration
```
> ansible-playbook -i inventories/hosts builtin_update_conf.yml -e '{"domains": [{"ip":"172.16.118.132", "port":"22", "user":"rts", "pass":"!rts!"} ], "es_endpoint": "169.56.72.226:9500", "kibana_endpoint":"169.56.72.226:5801", "module_type": "003", "conf_file": "config_kafka.conf"}'
```
#### 2-5) Update built-in apache2 configuration
```
> ansible-playbook -i inventories/hosts builtin_update_conf.yml -e '{"domains": [{"ip":"172.16.118.132", "port":"22", "user":"rts", "pass":"!rts!"}], "es_endpoint": "169.56.72.226:9500", "kibana_endpoint": "169.56.72.226:5801", "module_type": "005",  "conf_file": "config_apache.conf"}'
```

#### 2-20) Update built-in heartbeat configuration
```
> ansible-playbook -i inventories/hosts builtin_update_conf.yml -e '{"domains": [{"ip":"169.56.124.19", "port":"22", "user":"rts", "pass":"!rts!"}], "es_endpoint": "169.56.72.226:9500", "kibana_endpoint": "169.56.72.226:5801", "module_type": "020",  "conf_file": "conf_heartbeat.yml"}'
```
- heartbeat module은 동적 업데이트를 지원하지 않는다.
- 띠리서 이 script는 단순히 설정파일을 복사만 하게되고,
- 실제 변경된 설정을 적용하기 위해서는
- heartbeat module을 중지하고, 재시작 해야 한다.

####  INPUT Parameter 설명
```
  * domains : service(beats)를 설치할 host 정보 (config 문자열을 추가필요)
  * es_endpoint : beats configuration 파일에 적용할 es_endpoint
  * kibana_endpoint : beats configuration 파일에 적용할 kibana_endpoint
  * module_type : built-in service의 종류
    - 001 : system
    - 002 : mysql
    - 003 : apache2
    - 004 : kafka
    - 005 : logstash
  * conf_text : 관련된 설정
```

#### 3-1) Delete built-in system service
```
> ansible-playbook -i inventories/hosts builtin_delete.yml -e '{"domains": [{"ip":"169.56.124.19", "port":"22", "user":"rts", "pass":"!rts!"} ], "module_type": "001", "pids": [{"ip":"169.56.124.19", "pid":"37439"}] }'
```

#### 3-2) Delete built-in mysql service
```
> ansible-playbook -i inventories/hosts builtin_delete.yml -e '{"domains": [{"ip":"172.16.118.132", "port":"22", "user":"rts", "pass":"!rts!"},{"ip":"172.16.118.133", "port":"22", "user":"rts", "pass":"!rts!"} ], "module_type": "002", "pids": [{"ip":"172.16.118.132", "pid":"102213"}, {"ip":"172.16.118.133", "pid":"102213"}] }'
```

#### 3-3) Delete built-in kafka service
```
> ansible-playbook -i inventories/hosts builtin_delete.yml -e '{"domains": [{"ip":"172.16.118.132", "port":"22", "user":"rts", "pass":"!rts!"},{"ip":"172.16.118.133", "port":"22", "user":"rts", "pass":"!rts!"} ], "module_type": "004", "pids": [{"ip":"172.16.118.132", "pid":"8632"}, {"ip":"172.16.118.133", "pid":"8632"}] }'
```

#### 3-4) Delete built-in apache2 service
```
> ansible-playbook -i inventories/hosts builtin_delete.yml -e '{"domains": [{"ip":"169.56.72.226", "port":"22", "user":"rts", "pass":"!rts!"}], "module_type": "003", "pids": [{"ip":"169.56.72.226", "pid":"15277"}] }'
```

#### 3-5) Delete built-in logstash service
```
> ansible-playbook -i inventories/hosts builtin_delete.yml -e '{"domains": [{"ip":"172.16.118.132", "port":"22", "user":"rts", "pass":"!rts!"} ], "module_type": "005", "pids": [{"ip":"172.16.118.132", "pid":"94634"}] }'
```

#### 3-20) Delete built-in logstash service
```
> ansible-playbook -i inventories/hosts builtin_delete.yml -e '{"domains": [{"ip":"169.56.124.19", "port":"22", "user":"rts", "pass":"!rts!"} ], "module_type": "020", "pids": [{"ip":"169.56.124.19", "pid":"47493"}] }'
```

####  INPUT Parameter 설명

### 2) Response example
```json
{
        "error_msg": "",
        "pids": "[u'172.16.118.132 : 82336', u'172.16.118.133 : 70520']",
        "kibana_dashboard": "http://169.56.72.226:5801/app/kibana#/dashboard/Metricbeat-system-overview?_g=(refreshInterval:('$$hashKey':'object:1869',display:'5%20seconds',pause:!f,section:1,value:5000),time:(from:now-15m,mode:quick,to:now))&_a=(description:'',filters:!(),fullScreenMode:!f,options:(darkTheme:!f,useMargins:!f),panels:!((gridData:(h:1,i:'9',w:12,x:0,y:0),id:System-Navigation,panelIndex:'9',type:visualization,version:'6.2.2'),(embeddableConfig:(vis:(defaultColors:('0%20-%20100':'rgb(0,104,55)'))),gridData:(h:2,i:'11',w:2,x:0,y:1),id:c6f2ffd0-4d17-11e7-a196-69b9a7a020a9,panelIndex:'11',type:visualization,version:'6.2.2'),(embeddableConfig:(vis:(defaultColors:('0%20-%20100':'rgb(0,104,55)'))),gridData:(h:5,i:'12',w:6,x:6,y:3),id:fe064790-1b1f-11e7-bec4-a5e9ec5cab8b,panelIndex:'12',type:visualization,version:'6.2.2'),(gridData:(h:5,i:'13',w:6,x:0,y:3),id:'855899e0-1b1c-11e7-b09e-037021c4f8df',panelIndex:'13',type:visualization,version:'6.2.2'),(embeddableConfig:(vis:(defaultColors:('0%25%20-%2015%25':'rgb(247,252,245)','15%25%20-%2030%25':'rgb(199,233,192)','30%25%20-%2045%25':'rgb(116,196,118)','45%25%20-%2060%25':'rgb(35,139,69)'))),gridData:(h:6,i:'14',w:12,x:0,y:8),id:'7cdb1330-4d1a-11e7-a196-69b9a7a020a9',panelIndex:'14',type:visualization,version:'6.2.2'),(embeddableConfig:(vis:(defaultColors:('0%20-%20100':'rgb(0,104,55)'))),gridData:(h:2,i:'16',w:2,x:8,y:1),id:'522ee670-1b92-11e7-bec4-a5e9ec5cab8b',panelIndex:'16',type:visualization,version:'6.2.2'),(gridData:(h:2,i:'17',w:2,x:10,y:1),id:'1aae9140-1b93-11e7-8ada-3df93aab833e',panelIndex:'17',type:visualization,version:'6.2.2'),(gridData:(h:2,i:'18',w:2,x:6,y:1),id:'825fdb80-4d1d-11e7-b5f2-2b7c1895bf32',panelIndex:'18',type:visualization,version:'6.2.2'),(gridData:(h:2,i:'19',w:2,x:4,y:1),id:d3166e80-1b91-11e7-bec4-a5e9ec5cab8b,panelIndex:'19',type:visualization,version:'6.2.2'),(gridData:(h:2,i:'20',w:2,x:2,y:1),id:'83e12df0-1b91-11e7-bec4-a5e9ec5cab8b',panelIndex:'20',type:visualization,version:'6.2.2')),query:(language:lucene,query:(query_string:(analyze_wildcard:!t,default_field:'*',query:'*'))),timeRestore:!f,title:'%5BMetricbeat%20System%5D%20Overview',viewMode:view)",
        "result_code": "200"
    }
```
#### OUTPUT Data 설명
  * result_code : 응답 코드 (200, 정상), 상세 오류코드는 아래 참고
  * error_msg : 에러에 대한 상세 메세지
  * pids : beat module의 process id의 배열 (나중에 해당 process를 삭제하기 위한 용도로 사용)
    [host ip : process id]의 맵형식으로 리턴됨. DB Table(BUILT_IN_COLLECT_LIST에 저장
  * kibana_dashboard : kibana dashborad 링크(URL)

### 3) ERROR_CODE 설명
```
# 3001 : Check beats error (ps -ef command)
# 3002 : Download beat file error (wget command)
# 3003 : Delete kibana error
# 3004 : Copy conf file error
# 3009 : Run metricbeat error
# 3010 : Create directory error
# 3101 : Delete beat error
# 9001 : Return message error
```

## ETC 1) Elasticsearch 관련

### - container 외부에서 elk cluster로 접속하지 못하도록 설정
- ports 옵션을 이용하여, 오픈된 port에 접속할 수 있는 IP를 제한한다.  
```
# 아래와 같은 설정은 본인(서버)만 제외하고는 외부에서 9200에 접속할 수 없다.
# 결과적으로 외부에서는 9200에 접속할 수 없고, 클러스터 내부 컨테이너 노드간에는 통신이 가능하다.
> docker run -p 127.0.0.1:9200:9200
```
- 참고 https://medium.com/@preslavrachev/securing-your-elasticsearch-instances-6c5ec68c8fc7

### - elasticsearch의 네트워크 설정
- 외부에서 es에 접속하는 설정과 클러스터의 노드간 통신을 위한 설정으로 구분
- 기본 설정은 network.host만 정의하면 위 2개의 설정이 동일하게 세팅된다.
- https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-network.html#common-network-settings
- 하지만, 좀 더 세부적으로 네트워크를 관리하려는 경우
- (예를 들면 proxy를 통해 외부접근은 제한하고, 내부 노드간 통신은 특정 I/F만 사용하는 경우)
- 2개의 설정을 다르게 해야 함.
- network.bind_host (외부접속)
  - 설정이 없으면 network.host를 따름
  - 여러개의 network I/F를 지정할 수 있다.
- network.publish_host (클러스터 노드간 통신)
  - 하나의 network I/F만 지정할 수 있으며, 이 I/F를 통해서 노드간 통신을 함
  - 만약 지정하지 않으면, network.host에 지정된 값중 하나를 선택

### - elasticsearch jvm heap size 확인
```
http://169.56.72.226:9200/_nodes/stats/jvm
> heap_max_in_bytes: 2075918336 (byte)  -> 2g로 확인 가능

http://169.56.72.226:9200/_cat/nodes?h=heap*&v
heap.current heap.percent heap.max
     622.7mb           31    1.9gb
       515mb           52  989.8mb
```


### - elasticsearch 설치를 위한 설정
  - vm.max_map_count kernel setting needs to be set to at least 262144 for production use
  ```
  # 설정
  > sysctl -w vm.max_map_count=262144
  # 조회
  > cat /proc/sys/vm/max_map_count
  ```

  ### - elasticsearch settings

  ```
  curl -XPUT 'localhost:10300/_cluster/settings?pretty' -H 'Content-Type: application/json' -d'
  {
      "persistent" : {
          "http.host" : "0.0.0.0"
      }
  }
  '

  curl -XPUT 'localhost:10300/_cluster/settings?pretty' -H 'Content-Type: application/json' -d'
  {
      "persistent" : {
          "indices.recovery.max_bytes_per_sec" : "40mb"
      },
      "transient" : {
          "indices.recovery.max_bytes_per_sec" : "20mb"
      }
  }
  '



  curl -XGET localhost:9200/_cluster/settings
  ```

### - metricbeat live configuration reloading
- https://www.elastic.co/guide/en/beats/metricbeat/6.2/_live_reloading.html


## ETC 2) Docker 관련

### - docker disk 사용량 제한
#### 1) docker 기본 설정 변경
- 아래와 같은 방법은 docker image가 다운로드되어 실행되는 시점에
- docker에 할당되는 disk 허용량을 지정하는 방법이다.
- https://docs.docker.com/engine/reference/commandline/dockerd/
```
> sudo dockerd --storage-opt dm.basesize=50G
```
- 위 방법으로 실행하는 것은 명령어에서 직접 실행하는 것이고,
- 운영을 위해서는 systemctl의 service로 등록해야 한다.
- 이 방법 역시 2가지 방식 (docker.service 사용 or deamon.json 사용)
##### docker.service 파일에 등록하여 systemctl 명령어 실행시 동작
```
> vi /usr/lib/systemd/system/docker.service

[Service]
Type=notify
# the default is not to use systemd for cgroups because the delegate issues still
# exists and systemd currently does not support the cgroup feature set required
# for containers run by docker
#ExecStart=/usr/bin/dockerd
ExecStart=/usr/bin/dockerd --insecure-registry=registry.accuinsight.io --storage-driver=devicemapper --storage-opt=dm.basesize=200G --storage-opt=dm.thinpooldev=/dev/mapper/docker-thinpool --storage-opt=dm.use_deferred_removal=true --storage-opt=dm.use_deferred_deletion=true
ExecReload=/bin/kill -s HUP $MAINPID
# Having non-zero Limit*s causes performance problems due to accounting overhead
# in the kernel. We recommend using cgroups to do container-local accounting.
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity
# Uncomment TasksMax if your systemd version supports it.
# Only systemd 226 and above support this version.
#TasksMax=infinity
TimeoutStartSec=0
# set delegate yes so that systemd does not reset the cgroups of docker containers
Delegate=yes
# kill only the docker process, not all processes in the cgroup
KillMode=process
# restart the docker process if it exits prematurely
Restart=on-failure
StartLimitBurst=3
StartLimitInterval=60s

[Install]
WantedBy=multi-user.target
```



#### 2) docker 실행시점에 volume 옵션 활용
- 다른 방법으로는 volume 옵션을 이용하여,
- local 자원의 파티션을 연결하여 특정 폴더의 용량을 확장할 수 있다.
- 예를 들어 docker 실행시 volume option으로 100GB의 사이즈의 파티션과
- docker내부의 특정 폴더를 매핑하면 docker에 할당된 공간 이상을 상요할 수 있다.
##### 단점
- docker container 종료 후에, 다른 호스트에서 동작하게 되면 기존 파티션의 내용 유실

#### 3) volume 조회
##### Default volume size (docker run시에 할당한 storage-opt 크기)
- http://www.projectatomic.io/blog/2016/03/daemon_option_basedevicesize/
```
> sudo docker info
Containers: 34
 Running: 34
 Paused: 0
 Stopped: 0
Images: 183
Server Version: 17.12.1-ce
Storage Driver: devicemapper
 Pool Name: docker-thinpool
 Pool Blocksize: 524.3kB
 Base Device Size: 214.7GB
 Backing Filesystem: xfs
 ...
```

##### docker에서 할당한 disk사용량을 용도(image, container, volume..)별로 보여준다.
```
> sudo docker system df
TYPE                TOTAL               ACTIVE              SIZE                RECLAIMABLE
Images              1                   1                   1.082GB             0B (0%)
Containers          1                   1                   8.414MB             0B (0%)
Local Volumes       2                   2                   44.31MB             0B (0%)
Build Cache                                                 0B                  0B


> sudo docker system df -v
Images space usage:

REPOSITORY          TAG                 IMAGE ID            CREATED ago         SIZE                SHARED SIZE         UNIQUE SiZE         CONTAINERS
rancher/server      latest              9f086c15073d        6 weeks ago ago     1.082GB             0B                  1.082GB             1

Containers space usage:

CONTAINER ID        IMAGE               COMMAND                  LOCAL VOLUMES       SIZE                CREATED ago         STATUS              NAMES
f7304d732b31        rancher/server      "/usr/bin/entry /usr…"   2                   8.41MB              4 weeks ago ago     Up 4 weeks          goofy_meninsky
```


### - Rancher 서비스의 자원 할당
- Service(container)가 사용하는 자원을 할당하는 옵션들 (Security/Host)
#### 1) cpu 할당
  - cpu pinning
    * 컨테이너가 사용하는 가상 vCPU가 실제 특정 물리 pCPU에서 동작하도록 지정하는 옵션
    * https://www.ovirt.org/documentation/sla/cpu-pinning/
#### 2) memory 할당
  - mem_limit (hard limit): container에서 최대로 사용할 수 있는 메모리 사이즈
  - mem_reservation (soft limit) : 프로세스의 최대 메모리 사용량(hard limit은 초과 불가)
  - memswap_limit : mem_limit 이상의 가상메모리를 사용하고자 할때 지정. 전체 메모리 = mem_limit + memswap_limit

### - 컨테이너에 할당된 자원을 조회하는 명령어
```
> docker stats --all --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}" <컨테이너 명>
```
- https://docs.docker.com/engine/reference/commandline/stats/#examples


### - gotty를 이용한 container console 접근
- Elasticsearch cluster를 구성하는 node에 console로 접근하기 위한 설정
- Dockerfile을 수정하여, 각 node에 gotty를 설치하고 daemon으로 실행 (port 오픈)
- Master node와 kibana node는 1개만 존재하므로, port가 중복될 가능성은 없음
  - [문제]
    * Data node는 확장할 경우, 하나의 host에 여러개 container가 구동되면서 port가 충돌하는 현상 발생
  - [해결1]
    * container가 host별로 1개씩만 존재하도록 스케줄링
    * 장점 : port 중복 해결
    * 단점 : data node를 host 별로 1개만 동작할 수 있어, 자원 활용도 저하



### - docker build (gotty + elasticsearch / gotty + kibana)
```
> docker build . -t registry.dataplatform.io/dpcore/es-gotty:6.2.4
> docker build . -t registry.dataplatform.io/dpcore/kibana-gotty:6.2.4
```

### - docker build (elasticsearch-hq)
```
> git clone https://github.com/ElasticHQ/elasticsearch-HQ.git
> docker build . -t registry.dataplatform.io/dpcore/elasticsearch-hq:3.4.0
```

### - docker run 문제 해결
##### 문제 1.
- Error response from daemon: Cannot restart container foo: failed to create endpoint foo on network bridge: iptables failed: iptables -t filter -A DOCKER ! -i docker0 -o docker0 -p tcp -d 172.17.0.9 --dport 1234 -j ACCEPT: iptables: No chain/target/match by that name.
 (exit status 1)

##### 해결 1.
```
> ip link delete docker0
> systemctl restart docker
```


## ETC 3) Rancher 관련

### rancher stack 생성

```
curl -u "${CATTLE_ACCESS_KEY}:${CATTLE_SECRET_KEY}" \
-X POST \
-H 'Accept: application/json' \
-H 'Content-Type: application/json' \
-d '{"name":"cloudsearch1", "system":false, "dockerCompose":"{\r\n \"version\": \"2\", \r\n \"services\": {\r\n \"ElkCloud\": {\r\n \"mem_limit\": 4294967296, \r\n \"image\": \"docker.elastic.co/elasticsearch/elasticsearch:6.2.2\", \r\n \"environment\": {\r\n \"http.host\": \"0.0.0.0\", \r\n \"transport.host\": \"127.0.0.1\"\r\n }, \r\n \"stdin_open\": true, \r\n \"tty\": true, \r\n \"ports\": [\r\n \"8200:9200/tcp\"\r\n ], \r\n \"labels\": {\r\n \"io.rancher.container.pull_image\": \"always\"\r\n }\r\n }\r\n }\r\n}", "rancherCompose":"{\r\n \"version\": \"2\", \r\n \"services\": {\r\n \"ElkCloud\": {\r\n \"milli_cpu_reservation\": 1000, \r\n \"scale\": 1, \r\n \"start_on_create\": true\r\n }\r\n }\r\n}", "binding":null}' \
'http://169.56.124.19:8080/v2-beta/projects/1a5/stacks'
```

```
HTTP/1.1 POST /v2-beta/projects/1a5/stacks
Host: 169.56.124.19:8080
Accept: application/json
Content-Type: application/json
Content-Length: 891

{
"name": "cloudsearch1",
"system": false,
"dockerCompose": "{\r\n   \"version\": \"2\",\r\n   \"services\": {\r\n      \"ElkCloud\": {\r\n         \"mem_limit\": 4294967296,\r\n         \"image\": \"docker.elastic.co/elasticsearch/elasticsearch:6.2.2\",\r\n         \"environment\": {\r\n            \"http.host\": \"0.0.0.0\",\r\n            \"transport.host\": \"127.0.0.1\"\r\n         },\r\n         \"stdin_open\": true,\r\n         \"tty\": true,\r\n         \"ports\": [\r\n            \"8200:9200/tcp\"\r\n         ],\r\n         \"labels\": {\r\n            \"io.rancher.container.pull_image\": \"always\"\r\n         }\r\n      }\r\n   }\r\n}",
"rancherCompose": "{\r\n   \"version\": \"2\",\r\n   \"services\": {\r\n      \"ElkCloud\": {\r\n         \"milli_cpu_reservation\": 1000,\r\n         \"scale\": 1,\r\n         \"start_on_create\": true\r\n      }\r\n   }\r\n}",
"startOnCreate": true,
"binding": null
}
```

### rancher service 생성
- https://www.foreach.be/blog/meet-neos-automated-environment-setup-using-docker
```
HTTP/1.1 POST /v2-beta/projects/1a5/services
Host: 169.56.124.19:8080
Accept: application/json
Content-Type: application/json
Content-Length: 222

{
  "name": "test-service4",
  "stackId": "1st188",
  "scale": 1,
  "scalePolicy": "",
  "launchConfig": {
    "count": 1,
    "imageUuid": "docker:tomcat:8.0",
    "ports": ["8089:8080/tcp"],
    "startOnCreate": true
  },
  "secondaryLaunchConfigs": [],
  "publicEndpoints": [],
  "assignServiceIpAddress": false,
  "startOnCreate": true,
  "lbConfig": ""
}
```

```
curl -u "${CATTLE_ACCESS_KEY}:${CATTLE_SECRET_KEY}" \
-X POST \
-H 'Accept: application/json' \
-H 'Content-Type: application/json' \
-d '{"name":"test-service", "stackId":"1st188", "scale":1, "scalePolicy":"", "launchConfig":{"count":1, "imageUuid":"docker:tomcat:8.0"}, "secondaryLaunchConfigs":[], "publicEndpoints":[], "assignServiceIpAddress":false, "lbConfig":""}' \
'http://169.56.124.19:8080/v2-beta/projects/1a5/services'
```


- LaunchConfig examples MasterNode
```
launchConfig": {
  "type": "launchConfig",
  "environment": {
    "ELASTIC_PASSWORD": "changeme",
    "ES_JAVA_OPTS": "-Xms2g -Xmx2g",
    "cluster.name": "My-first-cluster11",
    "discovery.zen.join_timeout": "100s",
    "discovery.zen.ping_timeout": "100s",
    "network.host": "0.0.0.0"
  },
  "imageUuid": "docker:docker.elastic.co/elasticsearch/elasticsearch:6.2.2",
  "instanceTriggeredStop": "stop",
  "kind": "container",
  "labels": {
    "io.rancher.container.pull_image": "always",
    "io.rancher.service.hash": "1da3997ff59eeadf4791677abd7b624e2073c7e8"
  },
    "logConfig": {
    "type": "logConfig"
  },
  "memory": 4294967296,
  "milliCpuReservation": 1000,
  "networkMode": "managed",
  "ports": [
    "9800:9200/tcp"
  ],
  "privileged": true,
  "publishAllPorts": false,
  "readOnly": false,
  "runInit": false,
  "startOnCreate": true,
  "stdinOpen": true,
  "system": false,
  "tty": true,
  "version": "0",
  "vcpu": 1,
  "drainTimeoutMs": 0
  },
```

- LaunchConfig Example DataNode
```
launchConfig": {
  "type": "launchConfig",
  "environment": {
    "ES_JAVA_OPTS": "-Xms2g -Xmx2g",
    "cluster.name": "My-first-cluster11",
    "discovery.zen.join_timeout": "100s",
    "discovery.zen.ping.unicast.hosts": "elasticsearch",
    "discovery.zen.ping_timeout": "100s",
    "network.host": "0.0.0.0",
    "node.data": "true",
    "node.master": "false"
  },
  "imageUuid": "docker:docker.elastic.co/elasticsearch/elasticsearch:6.2.2",
  "instanceTriggeredStop": "stop",
  "kind": "container",
  "labels": {
  "io.rancher.container.pull_image": "always",
  "io.rancher.service.hash": "4073c709fd90682af78075f70391ac5586f58324"
  },
  "logConfig": {
  "type": "logConfig"
  },
  "memory": 4294967296,
  "milliCpuReservation": 1000,
  "networkMode": "managed",
  "privileged": false,
  "publishAllPorts": false,
  "readOnly": false,
  "runInit": false,
  "startOnCreate": true,
  "stdinOpen": true,
  "system": false,
  "tty": true,
  "version": "0",
  "vcpu": 1,
  "drainTimeoutMs": 0
},
```

### - Rancher status code
#### 422 code
```
4×× CLIENT ERROR
422 UNPROCESSABLE ENTITY
The server understands the content type of the request entity (hence a 415 Unsupported Media Type status code is inappropriate), and the syntax of the request entity is correct (thus a 400 Bad Request status code is inappropriate) but was unable to process the contained instructions.
For example, this error condition may occur if an XML request body contains well-formed (i.e., syntactically correct), but semantically erroneous, XML instructions.

```


### - Rancher compose schedule
- scheduler를 이용한 host 할당
```
\"Kibana\": {\
          \"mem_limit\": {{ kibana_mem }},\
          \"image\": \"{{ docker_kibana }}\",\
          \"labels\": { \
             \"io.rancher.scheduler.affinity:host_label\": \"{{ label_text }}\" \
          }, \
          \"environment\": {\
              \"elasticsearch.url\": \"http://elasticsearch:{{ es_port }}\" \
          },\
          \"links\": [ \"MasterNode:elasticsearch\" ], \
          \"stdin_open\": true,\
          \"tty\": true,\
          \"ports\": [ \"{{ kibana_port }}:5601/tcp\", \"8088\" ] \
      },\
```

- group_vars/main.yml
```yml
label_text: "cloudsearch=true"
```

- C2.josn (scheduler를 적용한 예시)
```json
{
"name": "{{ stack_name }}",
"system": false,
"dockerCompose": "{\
  \"version\": \"2\",\
  \"services\": {\
      \"MasterNode\": {\
          \"privileged\": true,\
          \"mem_limit\": {{ es_mem }},\
          \"image\": \"{{ docker_es }}\",\
          \"labels\": { \
             \"io.rancher.scheduler.affinity:host_label\": \"{{ label_text }}\" \
          }, \
          \"environment\": {\
              \"network.host\": \"0.0.0.0\",\
              \"cluster.name\": \"{{ es_cluster_name }}\", \
              \"node.name\": \"MasterNode\", \
              \"ELASTIC_PASSWORD\": \"changeme\", \
              \"discovery.zen.join_timeout\": \"100s\", \
              \"discovery.zen.ping_timeout\": \"100s\", \
              \"ES_JAVA_OPTS\": \"-Xms{{ es_jvm_heap | default('1g') }} -Xmx{{ es_jvm_heap | default('1g') }}\" \
          },\
          \"stdin_open\": true,\
          \"tty\": true,\
          \"ports\": [ \"{{ es_port }}:9200/tcp\", \"8088\"  ] \
      },\
      \"DataNode1\": {\
          \"mem_limit\": {{ es_mem }},\
          \"image\": \"{{ docker_es }}\",\
          \"labels\": { \
             \"io.rancher.scheduler.affinity:host_label\": \"{{ label_text }}\" \
          }, \
          \"environment\": {\
              \"network.host\": \"0.0.0.0\",\
              \"cluster.name\": \"{{ es_cluster_name }}\", \
              \"node.name\": \"DataNode1\", \
              \"node.master\": \"false\", \
              \"node.data\": \"true\", \
              \"discovery.zen.ping.unicast.hosts\": \"elasticsearch\", \
              \"discovery.zen.join_timeout\": \"100s\", \
              \"discovery.zen.ping_timeout\": \"100s\", \
              \"ES_JAVA_OPTS\": \"-Xms{{ es_jvm_heap | default('1g') }} -Xmx{{ es_jvm_heap | default('1g') }}\" \
          },\
          \"links\": [ \"MasterNode:elasticsearch\" ], \
          \"stdin_open\": true,\
          \"tty\": true, \
          \"ports\": [ \"8088\"  ] \
      },\
      \"DataNode2\": {\
          \"mem_limit\": {{ es_mem }},\
          \"image\": \"{{ docker_es }}\",\
          \"labels\": { \
             \"io.rancher.scheduler.affinity:host_label\": \"{{ label_text }}\" \
          }, \
          \"environment\": {\
              \"network.host\": \"0.0.0.0\",\
              \"cluster.name\": \"{{ es_cluster_name }}\", \
              \"node.name\": \"DataNode2\", \
              \"node.master\": \"false\", \
              \"node.data\": \"true\", \
              \"discovery.zen.ping.unicast.hosts\": \"elasticsearch\", \
              \"discovery.zen.join_timeout\": \"100s\", \
              \"discovery.zen.ping_timeout\": \"100s\", \
              \"ES_JAVA_OPTS\": \"-Xms{{ es_jvm_heap | default('1g') }} -Xmx{{ es_jvm_heap | default('1g') }}\" \
          },\
          \"links\": [ \"MasterNode:elasticsearch\" ], \
          \"stdin_open\": true,\
          \"tty\": true, \
          \"ports\": [ \"8088\"  ] \
      },\
      \"Kibana\": {\
          \"mem_limit\": {{ kibana_mem }},\
          \"image\": \"{{ docker_kibana }}\",\
          \"labels\": { \
             \"io.rancher.scheduler.affinity:host_label\": \"{{ label_text }}\" \
          }, \
          \"environment\": {\
              \"elasticsearch.url\": \"http://elasticsearch:{{ es_port }}\" \
          },\
          \"links\": [ \"MasterNode:elasticsearch\" ], \
          \"stdin_open\": true,\
          \"tty\": true,\
          \"ports\": [ \"{{ kibana_port }}:5601/tcp\", \"8088\" ] \
      },\
      \"HQNode\": {\
          \"mem_limit\": {{ hq_mem }},\
          \"image\": \"{{ docker_hq }}\",\
          \"labels\": { \
             \"io.rancher.scheduler.affinity:host_label\": \"{{ label_text }}\" \
          }, \
          \"links\": [ \"MasterNode:elasticsearch\" ], \
          \"stdin_open\": true,\
          \"tty\": true,\
          \"ports\": [ \"5000\" ] \
      }\
  }\
}",
"rancherCompose": "{\
    \"version\": \"2\",\
    \"services\": {\
        \"MasterNode\": {\
            \"milli_cpu_reservation\": {{ es_cpu_core }},\
            \"scale\": 1,\
            \"start_on_create\": true \
        },\
        \"DataNode1\": {\
            \"milli_cpu_reservation\": {{ es_cpu_core }},\
            \"scale\": 1,\
            \"start_on_create\": true \
        },\
        \"DataNode2\": {\
            \"milli_cpu_reservation\": {{ es_cpu_core }},\
            \"scale\": 1,\
            \"start_on_create\": true \
        },\
        \"Kibana\": {\
            \"milli_cpu_reservation\": {{ kibana_cpu_core }},\
            \"scale\": 1,\
            \"start_on_create\": true \
        },\
        \"HQNode\": {\
            \"milli_cpu_reservation\": {{ hq_cpu_core }},\
            \"scale\": 1,\
            \"start_on_create\": true \
        }\
    }\
}",
"startOnCreate": true,
"binding": null
}
```


## ETC 4) Ansible 옵션
### - Run ansible-playbook without inventory
- i 옵션에서 ,로 구분하여 실행할 host 정보를 입력한다.
- "-k" 옵션을 추가하면, 접속시 패스워드를 입력해야한다.
```
> ansible-playbook -i 10.200.23.10,dev01 -u username playbook.yml
```


## ETC 5) Ansible script 설치 절차

### 1. Install ansible and edit configuration
- SSH host key 설정
- https://docs.ansible.com/ansible/latest/user_guide/intro_getting_started.html#host-key-checking
```
> sudo yum install -y ansible
> sudo vi /etc/ansible/ansible.cfg
# SSH key host checking을 비활성화 한다. (주석 해제)
host_key_checking = False

또는
> export ANSIBLE_HOST_KEY_CHECKING=False
```

### 2. ssh로 접속할 ansible agent 서버 ip/port/user/password를 변경한다
```
> vi inventories/hosts
# 아래 내용으로 변경
[Agents]
agent1 ansible_ssh_port=<포트번호> ansible_ssh_host=<ansible을 실행할 서버>  ansible_user=<ssh유저> ansible_ssh_pass=<패스워드>
```

### 3. Rancher server 정보 수정 (ip, port)
```
> vi inventories/group_vars/main.yml
# 아래 값을 변경한다.
rancher_server: "<랜처서버 IP?"
rancher_port: <랜처서버 PORT>
label_text: "cloudsearch=true" # 설치할 대상 host의 label로 변경
```


### 4. OS 설정 변경
- https://www.elastic.co/guide/en/elasticsearch/reference/current/system-config.html
- elasticsearch가 실행되는 모든 host에 아래 설정을 반영한다.

#### Virtual memory (필수)
```
> sysctl -w vm.max_map_count=262144
```
```
- virtual memory error 해결
시스템의 nmap count를 증가기켜야 한다.
https://www.elastic.co/guide/en/elasticsearch/reference/current/vm-max-map-count.html
# 1) 현재 서버상태에서만 적용하는 방식
> sudo sysctl -w vm.max_map_count=262144

# 2) 영구적으로 적용 (서버 재부팅시 자동 적용)
> sudo vi /etc/sysctl.conf
# 아래 내용 추가
vm.max_map_count = 262144

> sudo sysctl -p
```

#### File Descriptor 오류 해결
```
> sudo vi /etc/security/limits.conf
# 아래 내용 추가 (rts는 사용자 계정명)
* hard nofile 70000
* soft nofile 70000
root hard nofile 70000
root soft nofile 70000

# 적용을 위해 콘솔을 닫고 다시 연결한다.
# 적용되었는지 확인
> ulimit -a
core file size          (blocks, -c) 0
data seg size           (kbytes, -d) unlimited
scheduling priority             (-e) 0
file size               (blocks, -f) unlimited
pending signals                 (-i) 59450
max locked memory       (kbytes, -l) 64
max memory size         (kbytes, -m) unlimited
open files                      (-n) 70000  #--> 정상적으로 적용됨을 확인함
```

#### Disable swapping (선택)
```
# Disable all swap filesedit
> sudo swapoff -a

# Enable bootstrap.memory_lock
> config/elasticsearch.yml
bootstrap.memory_lock: true

# GET _nodes?filter_path=**.mlockall 로 적용여부 확인
```

#### File Descriptors (선택)
```
> sudo ulimit -n 65536

# 확인
> ulimit -Sa

# GET _nodes/stats/process?filter_path=**.max_file_descriptors 명령어로 적용여부 확인
```

#### Number threads (선택)
```
> sudo ulimit -u 4096
```
