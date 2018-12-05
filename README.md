# cs-install-automation
Automate the cs installing process using ansible scripts in a closed network

## Install Ansible
### Install ansible in offline on centos
- https://www.linuxschoolonline.com/how-to-install-ansible-offline-on-centos-or-redhat/
- https://github.com/pingcap/docs/blob/master/op-guide/offline-ansible-deployment.md
```
wget https://download.pingcap.org/ansible-2.5.0-pip.tar.gz
tar -xzvf ansible-2.5.0-pip.tar.gz
cd ansible-2.5.0-pip/
chmod u+x install_ansible.sh
./install_ansible.sh
```

## System setting
### Add user
- 패스워드 암호화
```
> python -c 'import crypt; print crypt.crypt("freepsw", "$1$SomeSalt$")'
```

- AWS에서 ssh 암호로 접속가능하도록 사용자 생성하기
- https://aws.amazon.com/ko/premiumsupport/knowledge-center/new-user-accounts-linux-instance/
```
> sudo adduser new_user --disabled-password
```

## Install Docker

### Get pip
```
> wget https://pypi.debian.net/pip/pip-18.1-py2.py3-none-any.whl
```

### Get docker-py
```
> pip download docker-py
```

## Docker Registry & Web UI

### Get docker-registry image file
```
> docker pull registry:2
> docker save registry:2 | gzip -c > docker-registry.tar.gz

> docker pull hyper/docker-registry-web
> docker save hyper/docker-registry-web | gzip -c > docker-registry-web.tar.gz
```
### Run doker-registry and docker-registry-webui
- https://github.com/mkuchin/docker-registry-web
```
# run docker-registry
> docker run -d -p 5000:5000 --name registry-srv registry:2

# run docker-registry-webui
# --link : registry-server 실행시 입력한 컨테이너 네임
# REGISTRY_URL : registry web ui에서 접속할 registry 서버의 IP. (gce에서 localhost로 지정하면 접속오류가 발생했음)
> docker run -it -p 8081:8080 --name registry-web --link registry-srv -e REGISTRY_URL=http://35.220.xxx.xxx:5000/v2 -e REGISTRY_NAME=localhost:5000 hyper/docker-registry-web
```

### 사용법
- https://novemberde.github.io/2017/04/09/Docker_Registry_0.html
- docker image를 내가 만든 docker-registry에 등록할 수 있도록 이미지명을 변경해야 함.
```
> docker pull hello-world

# "localhost:5000"과 같이 나의 docker-registry주소를 추가한다.
> docker tag hello-world localhost:5000/hello-world
> docker tag rancher/server:v1.6.23 35.220.xxx.xx:5000/rancher/server:v1.6.23
> docker tag rancher/agent:v1.2.11 35.220.xxx.xx:5000/rancher/agent:v1.2.11

# docker registry에 등록 (별도의 옵션없이 push)
> docker push localhost:5000/hello-world
> docker push 35.220.xxx.xx:5000/rancher/server:v1.6.23
> docker push 35.220.xxx.xx:5000/rancher/agent:v1.2.11

# 내 registry에 등록되었는지 확인
> curl -X GET http://localhost:5000/v2/_catalog
{"repositories":["hello-world"]}
```


### 원격지 노드에서 registry에 등록하기
- https://docs.docker.com/registry/insecure/#deploy-a-plain-http-registry
- docker registry는 http 프로토콜만 지원하지만,
- docker push/pull은 https를 사용한다.
- 따라서, 원격지 노드에서 https 설정을 disable하거나, 인증서를 사용하도록 변경해야 햔다.
- 여기서는 간단하게 https를 disable해 보자.
```
> sudo vi /etc/docker/daemon.json
{
  "insecure-registries" : ["docker-registry-ip:5000"]
}

> sudo systemctl restart docker

> docker tag rancher/server 35.220.xxx.xx:5000/rancher/server
```

### Docker Registry Web ui

## Rancher
- 인터넷 접속이 되지 않는 환경에서 rancher cluster 설치
- https://rancher.com/docs/rancher/v1.3/en/installing-rancher/installing-server/no-internet-access/
### Get rancher images(docker) files
```
> docker pull rancher/server:v1.6.23
> docker save rancher/server:v1.6.23 | gzip -c > racher_server.tar.gz

> docker pull rancher/agent:v1.2.11
> docker save rancher/agent:v1.2.11 | gzip -c > racher_agent.tar.gz

# copy image tar file from remote server
> scp -r user@35.220.xxx.xxx:/home/user/racher_server.tar.gz   .

# copy files to remote server
scp -i ~/.ssh/freepsw03_rsa cloudsearch.scripts2.tar.gz freepsw_03@35.187.xxx.xxx:~
```


## Ansible performance tuning
- ansible.cfg 설정 변경
- mac은 ansible.cfg가 생성되지 않으므로, /etc/ansible/ansible.cfg를 생성해서 설정
### ssh pipeling
- 한번의 ssh 연결로 다수의 task를 실행하는 설정
pipelining = True


## Rancher

### Rancher CLI
```
> wget https://releases.rancher.com/cli/v0.6.12/rancher-linux-amd64-v0.6.12.tar.gz
> tar xvf rancher-linux-amd64-v0.6.12.tar.gz

access-key: A0B9A7F77402D7B253D1
secret-key: aJx6x9976D2qnBVaZrLBUqF8p7ZiNG6HbV9baV43
```

### create host label when create rancher-agent
> sudo docker run -e CATTLE_HOST_LABELS='foo=bar' -d --privileged \
-v /var/run/docker.sock:/var/run/docker.sock rancher/agent:v0.8.2 \
http://<rancher-server-ip>:8080/v1/projects/1a5/scripts/<registrationToken>

sudo docker run -e CATTLE_AGENT_IP="35.220.xx.xx "  --rm --privileged -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/rancher:/var/lib/rancher rancher/agent:v1.2.11 http://35.220.xxx.xxx:8080/v1/scripts/D02ED42357B1CA64F19A:1514678400000:M0WH6CijjOICLYv3JG6dh1vwbI


## DB mairadb
```
> docker run --name some-mariadb -v /home/freepsw_03/temp/docker-db/dpcore_search_dump.sql:/etc/mysql/conf.d -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mariadb:tag

> docker save mariadb:10.3 | gzip -c > docker-mariadb.tar.gz
```

## docker-cs
### core-module-cloudsearch 변경시 compile -> docker image build 재실행
- jar 파일 변경에 따라서, 아래 과정 자동화 필요

```
> vi /home/freepsw_02/dpbds-cloudsearch/core-module-cloudsearch/src/main/resources/profiles/docker/config-cloudsearch.properties
> mvn clean package -DskipTests=true -P docker_staging -pl core-module-cloudsearch -am
> docker build . -t docker.registry.server:5000/dpcore/core-module-cloudsearch
> docker save docker.registry.server:5000/dpcore/core-module-cloudsearch | gzip -c > core-module-cloudsearch.tar.gz
> docker push docker.registry.server:5000/dpcore/core-module-cloudsearch
```


## docker-cs-scripts

### Ansible 변수 수정
#### hosts 파일 수정
- localhost가 controller가 되도록 변경  (inventories/hosts)

#### group_vars 변수 수정
- inventories/group_vars/main.yml
```
# Rancher가 구동중인 서버의 IP/PORT
rancher_server: "rancher-server"
rancher_port: 8080

# Rancher에서 발급한 Access/Secret Key
rancher_api_key_user: "8EC0A7BA9B3659F5DF9B"
rancher_api_key_pass: "SPdGTa6JtLR5KTsDEeaSyRpLEQQXLpPzXbeFBuYo"

# Docker-registry url 변경
docker_es: "docker.registry.server:5000/dpcore/es-gotty:6.3.1"
docker_kibana: "docker.registry.server:5000/dpcore/kibana-gotty:6.3.1"
docker_hq: "docker.registry.server:5000/dpcore/elasticsearch-hq:3.4.0"
```

### Build elasticsearch docker Images and push to Docker_Registry
```
> docker build . -t docker.registry.server:5000/dpcore/core-module-cloudsearch-scripts:v1.0.0
> docker save docker.registry.server:5000/dpcore/core-module-cloudsearch-scripts:v1.0.0 | gzip -c > core-module-cloudsearch-scripts.tar.gz
> docker push docker.registry.server:5000/dpcore/core-module-cloudsearch-scripts:v1.0.0
> docker load < core-module-cloudsearch-scripts.tar.gz

> docker build . -t docker.registry.server:5000/dpcore/es-gotty:6.3.1
> docker save docker.registry.server:5000/dpcore/es-gotty | gzip -c > docker-es.tar.gz
> docker push docker.registry.server:5000/dpcore/es-gotty:6.3.1


> docker build . -t docker.registry.server:5000/dpcore/kibana-gotty:6.3.1
> docker save docker.registry.server:5000/dpcore/kibana-gotty:6.3.1 | gzip -c > docker-kibana.tar.gz
> docker push docker.registry.server:5000/dpcore/kibana-gotty:6.3.1


# ElasticHQ는 build하여 사용했을때 gunicorn 오류가 발생함
# 그래서 docker pull로 다운받은 이미지를 save하여 저장함.
> docker build . -t docker.registry.server:5000/dpcore/elasticsearch-hq:3.4.1
> docker pull elastichq/elasticsearch-hq:latest
>  docker tag elastichq/elasticsearch-hq docker.registry.server:5000/dpcore/elasticsearch-hq:3.4.1
> docker save docker.registry.server:5000/dpcore/elasticsearch-hq:3.4.1 | gzip -c > docker-es-hq.tar.gz
> docker push docker.registry.server:5000/dpcore/elasticsearch-hq:3.4.1
>
```


## docker-core-oauth
```
> mvn clean package -DskipTests=true -Pdocker-stg -pl core-oauth-server -am
> docker build . -t docker.registry.server:5000/dpcore/core-oauth-server:stg02
> docker save docker.registry.server:5000/dpcore/core-oauth-server:stg02 | gzip -c > core-module-oauth.tar.gz
> docker push docker.registry.server:5000/dpcore/core-oauth-server:stg02
```


## docker-core-sso
```
> mvn clean package -DskipTests=true -Pdocker-stg -pl core-sso-server -am
> docker build . -t docker.registry.server:5000/dpcore/core-sso-server:stg02
> docker save docker.registry.server:5000/dpcore/core-sso-server:stg02 | gzip -c > core-module-sso.tar.gz
> docker push docker.registry.server:5000/dpcore/core-sso-server:stg02
```


## docker-core-api
```
> mvn clean package -DskipTests=true -Pdocker-stg -pl core-api-gateway -am
> docker build . -t docker.registry.server:5000/dpcore/core-api-gateway:stg02
> docker save docker.registry.server:5000/dpcore/core-api-gateway:stg02 | gzip -c > core-module-api.tar.gz
> docker push docker.registry.server:5000/dpcore/core-api-gateway:stg02
```

## docker-web-cs
```
> git clone  --recurse-submodules https://xxxx.xxxx/scm/dpbds/cloudsearch.web.git
> cd cloudsearch.web
> docker build . --build-arg PROFILE="stg" -t docker.registry.server:5000/dpcore/cloudsearch-nginx-stg
> docker save docker.registry.server:5000/dpcore/cloudsearch-nginx-stg | gzip -c > web-module-cs.tar.gz
> docker push docker.registry.server:5000/dpcore/cloudsearch-nginx-stg
```

### On-premis 환경
- z 인증없이, 자제 인증서버(core-api-sso)를 활용하기 위한 설정들
- nginx reverse proxy를 이용하여 web nginx에서 요청을 forwarding
  - web(nginx) -> core-sso
  - web(nginx) -> core-cs

#### WEB NGINX 설정
```
upstream cloudsearch_backend_api {
  server core-module-portal:7070;
}

# SSO 인증을 위한 API, 추후 변경 필요
upstream auth_api {
  server core-module-portal:7080;
}

server {
listen       80;
server_name  cloudsearch-web;

gzip on;
gzip_http_version 1.1;
gzip_disable      "MSIE [1-6]\.";
gzip_min_length   256;
gzip_vary         on;
gzip_proxied      expired no-cache no-store private auth;
gzip_types        text/plain text/css application/json application/javascript application/x-javascript text/xml application/xml application/xml+rss text/javascript;
gzip_comp_level   9;

location /api {
  proxy_pass         http://cloudsearch_backend_api;
  proxy_redirect     off;
  proxy_set_header   Host $host;
  proxy_set_header   X-Real-IP $remote_addr;
  proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
  proxy_set_header   X-Forwarded-Host $server_name;
}

location /auth {
  rewrite ^/auth(.*) $1 break;
  proxy_pass         http://auth_api;
  proxy_redirect     off;
  proxy_set_header   Host $host;
  proxy_set_header   X-Real-IP $remote_addr;
  proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
  proxy_set_header   X-Forwarded-Host $server_name;
}

location / {
  root   /usr/share/nginx/html;
  index  index.html index.htm;
}
}
```

#### envieonment.stg.ts
- core-api-gateway의 url로 변경
```
# portal을 사용하는 경우
api: changeDomain('http://core-module-portal:7080'),

# api-gateway로 직접 연결하는 경우
api: 'http://localhost:4203/api/v1/cloudsearch',
```

#### common-module-environment.common.ts
##### xxx_sso 설정
- 실행할 Environment에 해당하는 apiToken 변경
- cloudz를 이용한 인증을 하지 않으므로, enable: false 변경
- useCookieDomain를 false로 변경 (cookie명을 domain name을 사용하지 않음)
- Service url은 로그인 했을때 연결되는 url을 의미함.
  - 포털이 있는 경우 : 포털의 해당 url을 지정하며, nginx에서 url mapping을 하여 서비스로 연결됨. (Loadbalance를 주로 활용)
  - 서비스만 존재하는 경우 : 해당 서비스로 직접 연결할 수 있도록 url을 변경
```
export const CommonModuleEnvironmentSTG = {
  apiToken: {
    url: 'http://localhost:4203/auth'
  },
  xxxx_sso: {
    domainName: '.xxxx.co.kr',
    login: {
      enable: false, // false : on-premiss 용 login
      url: 'https://dev-auth.xxxx.co.kr/auth',
      tokenRefreshConditionMin : 5,
      requestMessageId: ''
    }
  },
  useCookieDomain: false,
  serviceUrls: {
    CLOUD_SEARCH: {
      label: 'Cloud Search',
      url: 'http://localhost:4203',
      console: '#',
      use: true
    },
```

### browser에서 직접 sso, api-gateway에 접속하도록 hosts 설정 추가
```
> vi /etc/hosts
35.200.xxx.xxx core-module-portal
```

### browser 접속
- http://core-module-portal:4203
- ip로 접속시 CORS 오류 발생







# ETC
### ssh server + ansible dockerfile
- https://docs.docker.com/engine/examples/running_ssh_service/#run-a-test_sshd-container
- https://github.com/ansible/ansible-docker-base
- 외부에서 ansible이 설치된 서버에 ssh로 접속하여, ansible script를 실행하는 용
```
FROM ubuntu:16.04

RUN useradd -d /home/dpcore -ms /bin/bash -g root -G sudo dpcore -p 1234qwer
RUN echo 'dpcore:1234qwer' | chpasswd
#RUN echo 'dpcore' | passwd --stdin dpcore
USER dpcore
RUN mkdir -p /home/dpcore/data-api-svc/core-module-cloudsearch-1.0-SNAPSHOT/script


USER root
# STEP 1. Install ansible
RUN apt-get update && \
    apt-get install --no-install-recommends -y software-properties-common && \
    apt-add-repository ppa:ansible/ansible && \
    apt-get update && \
    apt-get install -y ansible

RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:screencast' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
```


```
> docker build -t docker.registry.server:5000:/dpcore/core-module-cloudsearch-script .
> docker run -d -p 2202:22 freepsw/ansible
> docker run -d -p 2202:22 -v $HOME/temp/ansible/script:/home/dpcore/data-api-svc/core-module-cloudsearch-1.0-SNAPSHOT/script --add-host rancher-server:35.187.xx.xxx  freepsw/ansible-1
> ssh  -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no dpcore@35.187.xxx.xxx -p 2202

> sh /home/dpcore/data-api-svc/core-module-cloudsearch-1.0-SNAPSHOT/script/bin/create_es_cluster.sh /home/dpcore/data-api-svc/core-module-cloudsearch-1.0-SNAPSHOT/script helloworld 10001 15001 4096m 1000 2g C1 8EC0A7BA9B3659F5DF9B SPdGTa6JtLR5KTsDEeaSyRpLEQQXLpPzXbeFBuYo
```






### ERROR 1
#### Problem : known_host 변경으로 인한 오류 발생
- host_key check 없이 접속하는 방식 (known_hosts를 확인하지 않음)
- docker container가 재구동되면, 기존 known_hosts의 내용이 변경되어 ssh connection오류 발생
```
> ssh dpcore@35.187.1xx.xxx -p 2202
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
Someone could be eavesdropping on you right now (man-in-the-middle attack)!
It is also possible that a host key has just been changed.
The fingerprint for the ECDSA key sent by the remote host is
SHA256:fGm7ZwEwtIotwXDjtwbdLNvBp20jwzkPexEmqKPgmLM.
Please contact your system administrator.
Add correct host key in /home/freepsw_03/.ssh/known_hosts to get rid of this message.
Offending ECDSA key in /home/freepsw_03/.ssh/known_hosts:1
```
#### Solution
- ssh connection 시에 known_host에 대한 검증을 하지 않도록 변경 (내부 네트워크에서)
```
> ssh  -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no dpcore@35.187.xxx.xxx -p 2202
```











### Ansible docker
- ansible 환경을 docker로 구성
- http://ruleoftech.com/2017/dockerizing-all-the-things-running-ansible-inside-docker-container 참고
### Dockerfile
```
FROM alpine:3.7

ENV ANSIBLE_VERSION 2.5.0

ENV BUILD_PACKAGES \
  bash \
  curl \
  tar \
  openssh-client \
  sshpass \
  git \
  python \
  py-boto \
  py-dateutil \
  py-httplib2 \
  py-jinja2 \
  py-paramiko \
  py-pip \
  py-yaml \
  ca-certificates

# If installing ansible@testing
#RUN \
#	echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> #/etc/apk/repositories

RUN set -x && \
    \
    echo "==> Adding build-dependencies..."  && \
    apk --update add --virtual build-dependencies \
      gcc \
      musl-dev \
      libffi-dev \
      openssl-dev \
      python-dev && \
    \
    echo "==> Upgrading apk and system..."  && \
    apk update && apk upgrade && \
    \
    echo "==> Adding Python runtime..."  && \
    apk add --no-cache ${BUILD_PACKAGES} && \
    pip install --upgrade pip && \
    pip install python-keyczar docker-py && \
    \
    echo "==> Installing Ansible..."  && \
    pip install ansible==${ANSIBLE_VERSION} && \
    \
    echo "==> Cleaning up..."  && \
    apk del build-dependencies && \
    rm -rf /var/cache/apk/* && \
    \
    echo "==> Adding hosts for convenience..."  && \
    mkdir -p /etc/ansible /ansible && \
    echo "[local]" >> /etc/ansible/hosts && \
    echo "localhost" >> /etc/ansible/hosts

ENV ANSIBLE_GATHERING smart
ENV ANSIBLE_HOST_KEY_CHECKING false
ENV ANSIBLE_RETRY_FILES_ENABLED false
ENV ANSIBLE_ROLES_PATH /ansible/playbooks/roles
ENV ANSIBLE_SSH_PIPELINING True
ENV PYTHONPATH /ansible/lib
ENV PATH /ansible/bin:$PATH
ENV ANSIBLE_LIBRARY /ansible/library

WORKDIR /ansible/playbooks

ENTRYPOINT ["ansible-playbook"]
```

### docker build and run
```
> docker build . -t dpcore/core-module-cloudsearch-ansible
> docker save dpcore/core-module-cloudsearch-ansible | gzip -c > core-module-cloudsearch-ansible.tar.gz
> docker run --rm -it -v $(pwd):/ansible/playbooks dpcore/core-module-cloudsearch-ansible --version
```

### ETC
```
sudo ansible-galaxy install udondan.ssh-reconnect
Password:
- downloading role 'ssh-reconnect', owned by udondan
- downloading role from https://github.com/udondan/ansible-role-ssh-reconnect/archive/master.tar.gz
- extracting udondan.ssh-reconnect to /etc/ansible/roles/udondan.ssh-reconnect
- udondan.ssh-reconnect (master) was installed successfully
```



## [TO-DO]
### dpcore-module-cs
- log4j설정에서 log directory 수정 /data/log_data (public 환경과 동일하게)
