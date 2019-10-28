
# Docker Direct-lvm 구성

## [STEP 0] Prerequisite (파티션 생성)
- docker volume을 저장할 디스크를 추가하고, 파티션을 생성한다.
- 아래의 경우 추가한 disk의 storage명이 /dev/sdb
```
# 아래는 기존에 partition이 있는 경우 primary를 삭제
> parted -s /dev/sdb rm 1

# 아래는 parted 모드에서 disk의 파티션의 라벨을 지정 (GPT는 2t 이상의 디스크 인식하는 용도 )
> sudo parted /dev/sdb
(parted) mklabel gpt
(parted) print
Model: Google PersistentDisk (scsi)
Disk /dev/sdb: 107GB
Sector size (logical/physical): 512B/4096B
Partition Table: gpt

# 추가된 disk partition에 디스크를 할당한다. (여기서는 100% 할당)
> sudo parted -s /dev/sdb mkpart primary 0% 100%
```

- 아래 명령어로 확인해 보면 disk가 정상적으로 할당 된 것이 확인 가능
- 아직 mount는 하지 않은 상태
```
> sudo lsblk
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda      8:0    0  100G  0 disk
└─sda1   8:1    0  100G  0 part /
sdb      8:16   0  100G  0 disk
└─sdb1   8:17   0  100G  0 part
```


## [STEP 1]. 물리 볼륨 생성 및 논리적 볼륨그룹 할당
- 물리 볼륨을 생성하고,
- 생성한 물리볼륨을 docker volume group을 이용하여 묶는다  
- 여러개의 물리볼륨을 하나의 볼륨그룹으로 통합하여 관리 가능
```
> sudo pvcreate -y /dev/sdb1
  Physical volume "/dev/sdb1" successfully created.

> sudo vgcreate docker /dev/sdb1
  Volume group "docker" successfully created
```

## [STEP 2]. thinpool과 thinpoolmeta라는 이름의 논리 볼륨 생성
- 생성된 논리 볼륨을 위에서 생성한
```
> sudo lvcreate --wipesignatures y -n thinpool docker -l 96%VG
  Logical volume "thinpool" created.

> sudo lvcreate --wipesignatures y -n thinpoolmeta docker -l 1%VG
    Logical volume "thinpoolmeta" created.

> sudo lvconvert -y --zero n -c 512k --thinpool docker/thinpool --poolmetadata docker/thinpoolmeta
  Thin pool volume with chunk size 512.00 KiB can address at most 126.50 TiB of data.
  WARNING: Converting docker/thinpool and docker/thinpoolmeta to thin pool's data and metadata volumes with metadata wiping.
  THIS WILL DESTROY CONTENT OF LOGICAL VOLUME (filesystem etc.)
  Converted docker/thinpool and docker/thinpoolmeta to thin pool.
```

## [STEP 3]. LVM 프로필을 이용하여 해당 풀의 자동 확장 기능을 설정
- thin_pool_autoextend_threshold: autoextend가 발생되는 시기를 정의하는 %값
- thin_pool_autoextend_percent: autoextend가 진행되었을 때 확장 가능한 디스크 %을 설정
```
> sudo vi /etc/lvm/profile/docker-thinpool.profile
activation {
thin_pool_autoextend_threshold = 80
thin_pool_autoextend_percent = 20
}

# 위 변경사항을 lvm에 적용한다.
> sudo lvchange --metadataprofile docker-thinpool docker/thinpool
  Logical volume docker/thinpool changed

# 생성된 lv가 정상적으로 모니터링 되는지 확인
> sudo lvs -o+seg_monitor
  LV       VG     Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert Monitor
  thinpool docker twi-a-t--- <96.00g             0.00   1.58                             monitored
```

## [STEP 4]. docker daemon설정 변경
```
> sudo vi /etc/docker/daemon.json
{
    "storage-driver": "devicemapper",
    "storage-opts": [
    "dm.thinpooldev=/dev/mapper/docker-thinpool",
    "dm.use_deferred_removal=true",
    "dm.use_deferred_deletion=true"
    ]
}
```

## [All Script] 위의 모든 단계를 script로 구성
- shell script
```shell
#!/bin/bash

#DIRECTORY=/var/lib/docker

# sleep 1
# sudo parted -s /dev/sdb mkpart primary 0% 100%

sleep 1
pvcreate -y /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1
vgcreate docker /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1

lvcreate --wipesignatures y -n thinpool docker -l 96%VG
lvcreate --wipesignatures y -n thinpoolmeta docker -l 1%VG

lvconvert -y --zero n -c 512k --thinpool docker/thinpool --poolmetadata docker/thinpoolmeta

cat << EOF > /etc/lvm/profile/docker-thinpool.profile
activation {
thin_pool_autoextend_threshold = 80
thin_pool_autoextend_percent = 20
}
EOF


lvchange --metadataprofile docker-thinpool docker/thinpool
lvs -o+seg_monitor

# check daemon.json
cat << EOF > /etc/docker/daemon.json
{
    "storage-driver": "devicemapper",
    "storage-opts": [
    "dm.thinpooldev=/dev/mapper/docker-thinpool",
    "dm.use_deferred_removal=true",
    "dm.use_deferred_deletion=true"
    ]
}
EOF
```


### ETC
#### 참고자료
- http://blog.naver.com/PostView.nhn?blogId=hymne&logNo=220977353373 (parted 사용법)
- https://xoit.tistory.com/18 (direct-lvm설명)
- https://jangpd007.tistory.com/235 (linux lvm 이해)

#### LVM관련 참고
- https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/logical_volume_manager_administration/vg_create_cluster

```
# list logical volume group
> vgs

# remove volume group 
> vgremove -f docker
```


## Disk Setting
### Fdisk guide
- https://victorydntmd.tistory.com/216
- fdisk를 이용한 파티션 생성 및 디렉토리 마운트
#### 1) create partition
```
> sudo fdisk /dev/sdb
....
Command (m for help): n
Partition type:
   p   primary (0 primary, 0 extended, 4 free)
   e   extended
Select (default p): p
Partition number (1-4, default 1):
First sector (2048-209715199, default 2048):
Using default value 2048
Last sector, +sectors or +size{K,M,G} (2048-209715199, default 209715199):
Using default value 209715199
Partition 1 of type Linux and of size 100 GiB is set
Command (m for help): w <-- 저장해야 생성된 partition 정보가 유지된다.
The partition table has been altered!

> sudo lsblk
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda      8:0    0  100G  0 disk
└─sda1   8:1    0  100G  0 part /
sdb      8:16   0  100G  0 disk
└─sdb1   8:17   0  100G  0 part
```

#### 2) format 
```
> sudo mkfs.ext4 /dev/sdb1
mke2fs 1.42.9 (28-Dec-2013)
>
```

#### 3) mount disk 
```
> sudo mkdir /data1
> sudo mount /dev/sdb1 /data1 
> sudo lsblk
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda      8:0    0  100G  0 disk
└─sda1   8:1    0  100G  0 part /
sdb      8:16   0  100G  0 disk
└─sdb1   8:17   0  100G  0 part /data1
```

#### 4) unmount disk (데이터는 삭제 하지 않음)
```
> umount /dev/sdb1
```