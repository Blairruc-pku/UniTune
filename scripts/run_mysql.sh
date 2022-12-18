#!/usr/bin/env bash
# run_mysql.sh  queries_dir  tpch_queries_list.txt  output	MYSQL_SOCK

printf "query\tlat(ms)\n" > $3

while read a || [[ -n ${a} ]]
  do
  {
    query=`echo ${a%.*}`
    start=$(date +%s%N)
    result=`mysql -uroot -S$4 $5 < $1/$a`
    if [[ -z $result ]];
    then
      lat=$6
    else
    end=$(date +%s%N)
    lat=$(( ($end - $start) / 1000000 ))
    fi
  printf "$query\t$lat\n" >> $3
  } &
done < $2