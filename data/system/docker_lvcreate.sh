if [ -z "$1" ]
  then
    echo "Input device"
    exit
else
  pvcreate -f $1
  
  printf "\n1)pvs\n"
  pvs
  printf "==============\n"

  vgcreate docker $1

  lvcreate --wipesignatures y -n thinpool docker -l 95%VG
  lvcreate --wipesignatures y -n thinpoolmeta docker -l 1%VG
  printf "\n2)lvs\n"
  lvs
  print "===============\n"

  lvconvert -y --zero n -c 512k --thinpool docker/thinpool --poolmetadata docker/thinpoolmeta

  cat << EOF > /etc/lvm/profile/docker-thinpool.profile
activation {
thin_pool_autoextend_threshold = 80
thin_pool_autoextend_percent = 20
}
EOF

  printf "\n3)cat /etc/lvm/profile/docker-thinpool.profile\n"
  cat /etc/lvm/profile/docker-thinpool.profile
  printf "========================\n"

  lvchange --metadataprofile docker-thinpool docker/thinpool
  lvs -o+seg_monitor
  lvs
  
  printf "\n4)lsblk\n"
  lsblk
  printf "========================"

fi
