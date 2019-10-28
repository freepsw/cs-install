# Rancher Network

## Docker Network check

```
> yum install -y net-tools
> ifconfig docker0

# https://ahnseungkyu.com/243
> yum install -y bridge-utils
> brctl show
bridge name	bridge id		STP enabled	interfaces
docker0		8000.0242323b579e	no

> netstat -rn
Kernel IP routing table
Destination     Gateway         Genmask         Flags   MSS Window  irtt Iface
0.0.0.0         192.168.20.1    0.0.0.0         UG        0 0          0 eth0
172.17.0.0      0.0.0.0         255.255.0.0     U         0 0          0 docker0
192.168.20.0    0.0.0.0         255.255.255.0   U         0 0          0 eth0

> docker network ls
> docker network inspect bridge




# interface link 상태 확인
> ethtool docker0
> ip link show
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
    link/ether 02:00:51:cc:00:74 brd ff:ff:ff:ff:ff:ff
3: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN mode DEFAULT group default
    link/ether 02:42:3e:6c:49:e9 brd ff:ff:ff:ff:ff:ff

> ip link set dev docker0 down
> ip link set dev docker0 up
>



# docker0 inteface 구동 (docker를 재구동하면 인터페이스 정상 동작)
> systemctl restart docker

```
