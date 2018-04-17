# Splunk Forwarder on Diamanti
This is a simple walk through deploying an `inputs.conf` to a Diamanti cluster.

## Requirements
- This assumes that you already have a working Splunk installation.
- You have installed and configured the Universal Splunk Forwarder, the RPM can be aquired from [Splunk Downloads](https://www.splunk.com/en_us/download/universal-forwarder.html)

## Modifying inputs.conf
Modify the following variables `{{ HOSTNAME }}`,`{{ DEFAULT INDEX TO PUSH TO }}` in the supplied inputs.conf

If you would like to push certain types of logs to certain indexes then please uncomment and modify the following `{{ SOME INDEX NAME FOR SYSTEM LEVEL LOGS }}`,`{{ SOME INDEX NAME FOR CONTAINER LOGS }}`

## Things to keep in mind

The Docker json logging driver treats each line as a separate message. When using the Docker logging driver, there is no direct support for multi-line messages. You need to handle multi-line messages at the logging agent level or higher
