#!/bin/bash

eval 'stdin=$(cat)'

readarray -t ARRAY < <(echo "$stdin" |jq -r ".id, .client.name, .client.address, .check.name, .action, .occurrences")

ID=${ARRAY[0]}
CLIENT_NAME=${ARRAY[1]}
CLIENT_ADDR=${ARRAY[2]}
NAME=${ARRAY[3]}
ACT=${ARRAY[4]}
OCC=${ARRAY[5]}

# send alert if $ACT=create AND is first occurrence; then resolve when $ACT=resolve
if [ $ACT == "create" ]
then
    [ $OCC == 1 ] && echo $stdin|jq .| mail -s "[Sensu Alert: $CLIENT_NAME $CLIENT_ADDR $NAME $ID ]" $ALERT_EMAIL
elif [ $ACT == "resolve" ]
then
    echo $stdin|jq .| mail -s "[Sensu Resolved: $CLIENT_NAME $CLIENT_ADDR $NAME $ID ]" $ALERT_EMAIL
fi
