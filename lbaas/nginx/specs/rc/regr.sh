kubectl delete -f wrk2.yaml ; sleep 60; sed -e 's~<numcore>~1~g' wrk2.yaml | kubectl create -f - ; sleep 80s ; kubectl get pods -o wide; for i in {1..1}; do  kubectl exec -it  wrk2 cat $i.log   ; done ; sleep 10

kubectl delete -f wrk2.yaml ; sleep 60; sed -e 's~<numcore>~2~g' wrk2.yaml | kubectl create -f - ; sleep 90s ; kubectl get pods -o wide; for i in {1..2}; do  kubectl exec -it  wrk2 cat $i.log   ; done ; sleep 10

kubectl delete -f wrk2.yaml ; sleep 60; sed -e 's~<numcore>~4~g' wrk2.yaml | kubectl create -f - ; sleep 100s ; kubectl get pods -o wide; for i in {1..4}; do  kubectl exec -it  wrk2 cat $i.log   ; done ; sleep 10

kubectl delete -f wrk2.yaml ; sleep 60; sed -e 's~<numcore>~8~g' wrk2.yaml | kubectl create -f - ; sleep 110s ; kubectl get pods -o wide; for i in {1..8}; do  kubectl exec -it  wrk2 cat $i.log   ; done ; sleep 10

kubectl delete -f wrk2.yaml ; sleep 60; sed -e 's~<numcore>~16~g' wrk2.yaml | kubectl create -f - ; sleep 120s ; kubectl get pods -o wide; for i in {1..16}; do  kubectl exec -it  wrk2 cat $i.log   ; done ; sleep 10

kubectl delete -f wrk2.yaml ; sleep 60; sed -e 's~<numcore>~32~g' wrk2.yaml | kubectl create -f - ; sleep 130s ; kubectl get pods -o wide; for i in {1..32}; do  kubectl exec -it  wrk2 cat $i.log   ; done ; sleep 10

kubectl delete -f wrk2.yaml ; sleep 60; sed -e 's~<numcore>~36~g' wrk2.yaml | kubectl create -f - ; sleep 140s ; kubectl get pods -o wide; for i in {1..36}; do  kubectl exec -it  wrk2 cat $i.log   ; done ; sleep 10
