# cs-install-automation
Automate the cs installing process using ansible scripts in a closed network

## Docker

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
> docker run -it -p 8081:8080 --name registry-web --link registry-srv -e REGISTRY_URL=http://35.220.232.130:5000/v2 -e REGISTRY_NAME=localhost:5000 hyper/docker-registry-web
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

@ copy image tar file from remote server
> scp -r user@35.220.xxx.xxx:/home/user/racher_server.tar.gz   .
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
sudo docker run -e CATTLE_HOST_LABELS='foo=bar' -d --privileged \
-v /var/run/docker.sock:/var/run/docker.sock rancher/agent:v0.8.2 \
http://<rancher-server-ip>:8080/v1/projects/1a5/scripts/<registrationToken>

sudo docker run -e CATTLE_AGENT_IP="35.220.xx.xx "  --rm --privileged -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/rancher:/var/lib/rancher rancher/agent:v1.2.11 http://35.220.211.63:8080/v1/scripts/D02ED42357B1CA64F19A:1514678400000:M0WH6CijjOICLYv3JG6dh1vwbI


## DB mairadb
```
> docker save mariadb:10.3 | gzip -c > docker-mariadb.tar.gz
```

## dpcore_cs
### core-module 변경시 compile -> docker image build 재실행
- jar 파일 변경에 따라서, 아래 과정 자동화 필요

```
> vi /home/freepsw_02/dpbds-cloudsearch/core-module-cloudsearch/src/main/resources/profiles/docker/config-cloudsearch.properties
> mvn clean package -DskipTests=true -P docker -pl core-module-cloudsearch -am
> docker build . -t docker_repo:5000/dpcore/core-module-cloudsearch
> docker tag dpcore/core-module-cloudsearch docker_repo:5000/dpcore/core-module-cloudsearch
> docker push 35.243.72.220:5000/dpcore/core-module-cloudsearch
```



```
mariadb:
  image: mariadb:10.3
  environment:
    MYSQL_ROOT_PASSWORD: secret
    MYSQL_DATABASE: dpcore_search
    MYSQL_USER: user
    MYSQL_PASSWORD: password
  stdin_open: true
  volumes:
  - /home/freepsw_02/temp/db/dpcore_search_dump.sql:/docker-entrypoint-initdb.d/dpcore_search_dump.sql
  tty: true
  ports:
  - 3307:3306/tcp
  labels:
    io.rancher.container.pull_image: always


    docker-compose.yml
version: '2'
services:
  tees:
    image: ubuntu:14.04.3
    stdin_open: true
    external_links:
    - stack1/mariadb:mariadb
    tty: true
    labels:
      io.rancher.container.pull_image: always

      version: '2'
      services:
        core-module-cloudsearch:
          image: 35.243.72.220:5000/dpcore/core-module-cloudsearch:latest
          hostname: core-module-cloudsearch
          stdin_open: true
          external_links:
          - stack1/mariadb-cs:mariadb
          tty: true
          ports:
          - 7081:7081/tcp
          cpu_shares: 1024
          labels:
            io.rancher.container.pull_image: always

version: '2'
services:
  core-module-cloudsearch:
    scale: 1
    start_on_create: true

    external_links:
    - stack1/mariadb-cs:mariadb
```

###
```
sudo ansible-galaxy install udondan.ssh-reconnect
Password:
- downloading role 'ssh-reconnect', owned by udondan
- downloading role from https://github.com/udondan/ansible-role-ssh-reconnect/archive/master.tar.gz
- extracting udondan.ssh-reconnect to /etc/ansible/roles/udondan.ssh-reconnect
- udondan.ssh-reconnect (master) was installed successfully
```
