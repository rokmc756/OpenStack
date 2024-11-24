ps -eo pcpu,pid,user,args | tail -n +2 | sort -k1 -r -n | head -10
