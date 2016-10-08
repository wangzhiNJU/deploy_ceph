#!/bin/sh
#部署mds
mkdir -p /var/lib/ceph/mds/ceph-a

mkdir /var/lib/ceph/bootstrap-mds
ceph-authtool --create-keyring /var/lib/ceph/bootstrap-mds/ceph.keyring --gen-key -n client.bootstrap-mds
ceph auth add client.bootstrap-mds mon 'allow profile bootstrap-mds' -i /var/lib/ceph/bootstrap-mds/ceph.keyring
ceph --name client.bootstrap-mds --keyring /var/lib/ceph/bootstrap-mds/ceph.keyring auth get-or-create mds.a osd 'allow rwx' mds 'allow' mon 'allow profile mds' -o /var/lib/ceph/mds/ceph-a/keyring

