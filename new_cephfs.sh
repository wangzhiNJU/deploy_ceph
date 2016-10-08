#!/bin/sh
ceph osd pool create cephfs_data 64
ceph osd pool create cephfs_metadata 64
ceph osd pool set cephfs_data size 1
ceph osd pool set cephfs_metadata size 1
ceph fs new cephfs cephfs_metadata cephfs_data
ceph osd pool set rbd size 1
