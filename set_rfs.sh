#!/bin/bash

# 対象デバイス
dev=/sys/class/net/eth0


# vCPU数からマスクを生成
n_of_cpu=`cat /proc/cpuinfo |grep processor |wc -l`
let n_of_mask=n_of_cpu/4
mask=""
for i in `seq 1 $n_of_mask`
do
    mask=$mask"f"
done;


# NICキューの数
nqueue=`ls -la $dev/queues |grep rx- |wc -l`
rps_sock_flow_entries=32768

echo $rps_sock_flow_entries > /proc/sys/net/core/rps_sock_flow_entries
let rps_flow_cnt=$rps_sock_flow_entries/$nqueue


# キュー単位に設定
for i in `seq 1 $nqueue`
do
  let que=i-1
  echo "$rps_flow_cnt" > $dev/queues/rx-$que/rps_flow_cnt
  echo "$mask" > $dev/queues/rx-$que/rps_cpus
done;
