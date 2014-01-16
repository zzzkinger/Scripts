#!/bin/sh

clearLog="/opt/bladefs/clearLogs/result.log"
dsList="/opt/bladefs/clearLogs/ds_list.txt"
date > $clearLog

for ds_ip in `cat $dsList`
do
        ssh $ds_ip \
        '\
        today=`date -d today '+%Y%m'`; 
        reserve_prefix="dataserver.log."$today; 
        for((i=1;i<=12;i++));
        do
                rmlist=`ls /data$i/dataservice*/log | grep "dataserver.log.2" | grep -v $reserve_prefix`;
                cd /data$i/dataservice*/log;
                rm -f $rmlist
        done
        '

        result=$?
        if [ $result -eq 0 ];then
                echo $ds_ip"  [OK]" >> $clearLog
        else
                echo $ds_ip"  [ERROR]" >> $clearLog
        fi
done
