file=/var/lib/pgsql/scripts/antall_connections_users.out
linjer=$(cut -d'-' -f2 $file |awk '{print $1}'|tail -13|sort -u |wc -l)
usr_conn_list=$(tail -$linjer $file |cut -d'-' -f2|sed 's/har//g' |sed 's/connections//g')
timestamp=$(cut -f1 -d'-' $file |tail -1)
echo $timestamp $usr_conn_list
