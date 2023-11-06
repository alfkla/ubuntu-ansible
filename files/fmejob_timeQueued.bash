
curl -s 'https://fme-drift2.webdmz.no/fmerest/v3/transformations/jobs/queued?fmetoken=0a663ff4c041eae323166debd3b6d82d2d56d619' | jq -r  .'items|.[]  '|egrep 'timeQueued|"workspace"' |cut -d':' -f2 |tr -d '\n';printf '\n'

#Sjekk om linjen inneholder workspace eller timeQueued og kutt av første bolk slik:  cut -d':' -f2 
