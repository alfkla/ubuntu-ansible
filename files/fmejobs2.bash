#/bin/bash
#set -x

jobs=$(curl -s 'https://fme-drift2.webdmz.no/fmerest/v3/transformations/jobs/running?fmetoken=0a663ff4c041eae323166debd3b6d82d2d56d619' | jq -r  .'items|.[]  '|egrep 'timeStarted|"workspace"')
now=$(date --iso-8601=seconds)
epoch_now=$(date --date="$now" +%s)

#for i in $jobs;do echo Skriver linje $i;done
if [ -z "$jobs" ]
then
      echo "Ingen jobber kjører"
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

*"timeStarted"*)
lesinn=$line
timeStarted=$(echo $lesinn|sed 's/,//g'|sed 's/"//g' |awk '{print $2}')
epoch_timeStarted=$(date --date="$timeStarted" +%s)
diff=$(expr $epoch_now \- $epoch_timeStarted)
# Printer ut antall sekunder delt på 3600 for å finne timer siden jobben startet
echo "timeStarted $timeStarted, for `expr $diff \/ 3600` timer siden - $diff sekunder siden"

  ;;
esac

done <<< "$(curl -s 'https://fme-drift2.webdmz.no/fmerest/v3/transformations/jobs/running?fmetoken=0a663ff4c041eae323166debd3b6d82d2d56d619' | jq -r  .'items|.[]  '|egrep 'timeStarted|"workspace"')" | tr -d '\n'
exit $exitverdi
fi
