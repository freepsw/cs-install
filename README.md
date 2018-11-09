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
- https://github.com/mkuchin/docker-registry-web
```
> docker run -d -p 5000:5000 --name registry-srv registry:2

# --link : registry-server 실행시 입력한 컨테이너 네임
# REGISTRY_URL : registry web ui에서 접속할 registry 서버의 IP. (gce에서 localhost로 지정하면 접속오류가 발생했음)
> docker run -it -p 8081:8080 --name registry-web --link registry -e REGISTRY_URL=http://35.220.xxx.xx:5000/v2 -e REGISTRY_NAME=localhost:5000 hyper/docker-registry-web
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
> docker push localhost:5000/rancher/server:v1.6.23
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

> docker tag rancher/server localhost:5000/rancher/server
```

### Docker Registry Web ui

## Rancher
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
### create host label when create rancher-agent
sudo docker run -e CATTLE_AGENT_IP="35.220.xx.xx "  --rm --privileged -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/rancher:/var/lib/rancher rancher/agent:v1.2.11 http://35.220.211.63:8080/v1/scripts/D02ED42357B1CA64F19A:1514678400000:M0WH6CijjOICLYv3JG6dh1vwbI
