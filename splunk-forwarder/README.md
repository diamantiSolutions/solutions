# Splunk Forwarder on Diamanti
This is a simple walk through deploying an inputs.conf to a Diamanti cluster in.
## Modifying inputs.conf
Modify the following variables `{{ HOSTNAME }}`,`{{ DEFAULT INDEX TO PUSH TO }}` in the supplied inputs.conf

If you would like to push certain types of logs to certain indexes then please uncomment and modify the following `{{ SOME INDEX NAME FOR SYSTEM LEVEL LOGS }}`,`{{ SOME INDEX NAME FOR CONTAINER LOGS }}`

## Things to keep in mind
