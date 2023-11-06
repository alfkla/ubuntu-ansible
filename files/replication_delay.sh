sudo su - postgres -c "psql -c 'select now() - pg_last_xact_replay_timestamp() AS replication_delay'" | egrep -v '\--|row'| sed ':a;N;$!ba;s/\n/ /g'
