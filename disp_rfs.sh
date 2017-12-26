#!/bin/bash

dev=/sys/class/net/eth0

nqueue=`ls -la ${dev}/queues |grep rx- |wc -l`

for i in `seq 1 $nqueue`
do
  let que=i-1
  rps_cpus=`cat ${dev}/queues/rx-$que/rps_cpus`
  rps_flow_cnt=`cat ${dev}/queues/rx-$que/rps_flow_cnt`
  printf "que=%d flow_cnt=%d %s\n" $que $rps_flow_cnt $rps_cpus
done;
