# Logging with Elastic in Kubernetes

## Deploying
`kubectl create -f manifests-all-diamanti.yaml`

### Post Deploy
Grab the IP and Port of Kibana's endpoint: `kubectl get endpoints -n logging | grep kibana`
Visit the `IP:Port/app/kibana#/management/kibana/indices` in your browser in order to set the index pattern in Kibana choose `fluentd-*`, then switch to the `IP:Port/app/kibana#/discover` view.
Every log line by containers running within the Kubernetes cluster is enhanced by meta data like `namespace_name`, `labels` and so on. This way it is easy to group and filter down on specific parts.

By default Kibana does not have a list of useful fields to display when searching through data. In order to set some sane defaults visit `IP:Port/app/kibana#/management/kibana/settings` scroll down until you see `defaultColumns` and edit it, replacing the defaults with a slightly more useful set of fields such as the following: `kubernetes.namespace_labels.name,kubernetes.pod_name,message`

Go back to the "Discover" tab and you should now see log data ordered with `timestamp`,`namespace`,`pod name` and `actual log message`

## Undeploying the Stack
`kubectl delete ns logging`

## Notes
There is no access control for the Kibana web interface. If you want to run this in public you need to secure your setup. The provided manifests here are for demonstration purposes only.

This is a simple non-failover deployment of EFK. This means its a single node elasticsearch cluster, with a single Kibana instance.
