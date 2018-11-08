# cs-install-automation
Automate the cs installing process using ansible scripts in a closed network


## Download necessary files

### Get pip
```
> wget https://pypi.debian.net/pip/pip-18.1-py2.py3-none-any.whl
```

### Get docker-py
```
> pip download docker-py
```

### Get rancher images(docker) files
```
> docker pull rancher/server:v1.6.23
> docker save rancher/server:v1.6.23 | gzip -c > racher_server.tar.gz

> docker pull rancher/agent:v1.2.11
> docker save rancher/agent:v1.2.11 | gzip -c > racher_agent.tar.gz

@ copy image tar file from remote server
> scp -r user@35.220.xxx.xxx:/home/user/racher_server.tar.gz   .
```

야근에.. 주식도 재미없는데..
근처에 스벅있으면 시원하게 한잔해요~



## Ansible performance tuning
- ansible.cfg 설정 변경
- mac은 ansible.cfg가 생성되지 않으므로, /etc/ansible/ansible.cfg를 생성해서 설정
### ssh pipeling
- 한번의 ssh 연결로 다수의 task를 실행하는 설정
pipelining = True



sudo docker run -e CATTLE_AGENT_IP="35.220.163.59 "  --rm --privileged -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/rancher:/var/lib/rancher rancher/agent:v1.2.11 http://35.220.211.63:8080/v1/scripts/D02ED42357B1CA64F19A:1514678400000:M0WH6CijjOICLYv3JG6dh1vwbI
