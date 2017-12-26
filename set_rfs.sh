#!/bin/bash

dev=/sys/class/net/eth0

nqueue=`ls -la $dev/queues |grep rx- |wc -l`
rps_sock_flow_entries=32768

echo $rps_sock_flow_entries > /proc/sys/net/core/rps_sock_flow_entries
let rps_flow_cnt=$rps_sock_flow_entries/$nqueue

for i in `seq 1 $nqueue`
do
  let que=i-1
  echo "$rps_flow_cnt" > $dev/queues/rx-$que/rps_flow_cnt
  echo "ffffffff" > $dev/queues/rx-$que/rps_cpus
done;
