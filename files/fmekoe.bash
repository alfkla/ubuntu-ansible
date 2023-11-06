#!/bin/bash
jobsqueued=$(curl -s https://fme-drift2.webdmz.no/fmerest/v3/transformations/jobs/queued?fmetoken=0a663ff4c041eae323166debd3b6d82d2d56d619 |jq '.totalCount')
#echo "`date` Nå er køen på $jobsqueued jobber" >> /var/lib/pgsql/scripts/count_fmejobs_queued.out


while read -r line
do
    
case ${line} in
0)
  Message="Ok $line jobs queued, that is good"
  exitverdi=0
  ;;
[1-9])
  Message="Ok $line jobs queued, under 10 is normal"
  exitverdi=0
  ;;
1[0-9])
  Message="Ok $line jobs queued, under 20 is fine"
  exitverdi=0
  ;;
2[0-9])
  Message="Warning $line jobs queued, more than 20 is a bit to many"
  exitverdi=1
  ;;
30-99)
  Message="Critical - $line jobs in fme queue, send alarm"
  exitverdi=2
  ;;
*)
  Message="Det er $line jobs queued, som er utenfor definert område!"
  exitverdi=3
  ;;
esac

#done <<< "$(curl -s 'https://fme-drift2.webdmz.no/fmerest/v3/transformations/jobs/running?fmetoken=0a663ff4c041eae323166debd3b6d82d2d56d619' | jq '.totalCount')"
done <<< "$(curl -s 'https://fme-drift2.webdmz.no/fmerest/v3/transformations/jobs/queued?fmetoken=0a663ff4c041eae323166debd3b6d82d2d56d619' | jq '.totalCount')"


echo $Message - exitverdi is $exitverdi
exit $exitverdi
