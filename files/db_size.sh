su - postgres -c "psql -c '\l+' | cut -d'|' -f'1,7' |egrep 'GB|MB'|sed 's/|//g'" |sed ':a;N;$!ba;s/\n/+ /g' | sed 's/ \{1,\}/ /g'
