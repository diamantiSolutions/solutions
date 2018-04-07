echo "./kubectl exec  $POD_NAME -c postgres /opt/cpm/bin/stopPg.sh"
./kubectl exec  $POD_NAME -c postgres sh /opt/cpm/bin/stopPg.sh
