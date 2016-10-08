#!/bin/bash
# by ds

cp ceph.conf /etc/ceph/ceph.conf

pkill ceph-mon
pkill ceph-mds
cmd=`pwd`/deploy.sh # deploy.sh is needed in pwd
conf=/etc/ceph/ceph.conf # ceph.conf is needed in pwd
dir=/home/ceph
rm -rf $dir
mkdir -p $dir

dir0=$dir/osd/ceph-0
dir1=$dir/osd/ceph-1
mkdir -p $dir0 $dir1

mon_a=$dir/mon/ceph-a
mkdir -p $mon_a

bash $cmd deploy_mon $conf

ceph-mon -c $conf -i a --mon-data $mon_a

host=master
scp $conf ${host}:/etc/ceph/
ssh $host "pkill ceph-osd"
ssh $host "pkill ceph-osd"
ssh $host "rm -rf $dir0"
ssh $host "mkdir -p $dir0"
bash $cmd add_osd $conf $host $dir0 $dir0/journal

host=server013
scp $conf ${host}:/etc/ceph/
ssh $host "pkill ceph-osd"
ssh $host "pkill ceph-osd"
ssh $host "rm -rf $dir1"
ssh $host "mkdir -p $dir1"
bash $cmd add_osd $conf $host $dir1 $dir1/journal

logdir=/var/log/ceph/*
host=master
ssh $host "ceph-osd -i 0"
ssh $host "rm -rf $logdir"
host=server013
ssh $host "ceph-osd -i 1"
ssh $host "rm -rf $logdir"

ceph osd pool set rbd size 2

