su - postgres -c "psql -x -c 'table pg_stat_replication'" | egrep -v 'location|RECORD|client_hostname|backend_xmin' |  sed 's/|//g' | sed ':a;N;$!ba;s/\n/, /g'| sed 's/ \{1,\}/ /g'
