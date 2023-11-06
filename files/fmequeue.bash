#/bin/bash
#set -x

jobs=$(curl -s 'https://fme-drift2.webdmz.no/fmerest/v3/transformations/jobs/queued?fmetoken=0a663ff4c041eae323166debd3b6d82d2d56d619' | jq -r  .'items|.[]  '|egrep 'timeQueued|"workspace"')
now=$(date --iso-8601=seconds)
epoch_now=$(date --date="$now" +%s)
antall_jobber=$(curl -s 'https://fme-drift2.webdmz.no/fmerest/v3/transformations/jobs/queued?fmetoken=0a663ff4c041eae323166debd3b6d82d2d56d619' | jq -r  '.totalCount')

#for i in $jobs;do echo Skriver linje $i;done
if [ -z "$jobs" ]
then
      echo "OK - $antall_jobber jobber - Ingen jobber venter"; exit 0
else


while read -r line
do
#    echo "$line"
    
case ${line} in

*"workspacePath"*)
  Message="$line er workspacePath"
echo "UNKNOWN  - $line er workspacePath   -  denne skjer vel aldri, fordi den er ikke med i curl setningen"
exitverdi=3
  ;;

*"workspace"*)
  Message="$line er workspace"
echo "$line " |cut -d':' -f2
jobbnavn=$(printf $line |cut -d':' -f2)
echo $jobbnavn
  ;;

*"timeQueued"*)
lesinn=$line
timeQueued=$(echo $lesinn|sed 's/,//g'|sed 's/"//g' |awk '{print $2}')
epoch_timeQueued=$(date --date="$timeQueued" +%s)
diff=$(expr $epoch_now \- $epoch_timeQueued)
# Printer ut antall sekunder delt på 3600 for å finne timer siden jobben startet
echo "timeQueued $timeQueued, for `expr $diff \/ 60` minutter siden - $diff sekunder siden"

  ;;
esac

done <<< "$(curl -s 'https://fme-drift2.webdmz.no/fmerest/v3/transformations/jobs/queued?fmetoken=0a663ff4c041eae323166debd3b6d82d2d56d619' | jq -r  .'items|.[]  '|egrep 'timeQueued|"workspace"')" | tr -d '\n'

exit $exitverdi
fi
