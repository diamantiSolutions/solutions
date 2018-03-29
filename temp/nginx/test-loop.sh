#!/bin/sh  


kubectl delete ns nginx-lb
kubectl delete ns haproxy-lb



itration=1

#echo "======> test by starting all instances  everytime"
#for number in 1 2 4 8 16 24 30
#do
#    ./runPlus.sh $number
#    sleep $((100 * $itration))
#    echo "log for $number instances:"
#    kubectl logs  --tail=0  -l app=wrk -n nginx-lb | grep -e "Requests/sec"
#    ((itration++))
#done




echo "======> test by reusing already running lb/ws instances everytime"

itration=1
./runPlus.sh 30
for number in 1 2 4 8 16 20 24 30
#for number in 20 24 30
do
    ./test.sh $number
#    sleep $((100 * $itration))
#    echo "log for $number instances:"
#    kubectl logs  --tail=0  -l app=wrk -n nginx-lb | grep -e "Requests/sec"
    ((itration++))
done

echo "======> test for direclty connecting to Webserver"

for number in 1 2 4 8 16 20 24 30
#for number in 20 24 30
do
    ./test-web.sh $number
#    sleep $((100 * $itration))
#    echo "log for $number instances:"
#    kubectl logs  --tail=0  -l app=wrk -n nginx-lb | grep -e "Requests/sec"
    ((itration++))
done



kubectl delete ns nginx-lb

cd /dwshome/agupta/work/solutions/github2/haproxy/specs/perf
echo "======> test HAproxy"

itration=1
./run.sh 30
for number in 1 2 4 8 16 20 24 30
#for number in 20 24 30
do
    ./test.sh $number
#    sleep $((100 * $itration))
#    echo "log for $number instances:"
#    kubectl logs  --tail=0  -l app=wrk -n nginx-lb | grep -e "Requests/sec"
    ((itration++))
done





#20-39,0-19 0000000000000000000100000000000000000000 0000000000000000001000000000000000000000 0000000000000000010000000000000000000000 0000000000000000100000000000000000000000 0000000000000001000000000000000000000000 0000000000000010000000000000000000000000 0000000000000100000000000000000000000000 0000000000001000000000000000000000000000 0000000000010000000000000000000000000000 0000000000100000000000000000000000000000 0000000001000000000000000000000000000000 0000000010000000000000000000000000000000 0000000100000000000000000000000000000000 0000001000000000000000000000000000000000 0000010000000000000000000000000000000000 0000100000000000000000000000000000000000 0001000000000000000000000000000000000000 0010000000000000000000000000000000000000 0100000000000000000000000000000000000000 1000000000000000000000000000000000000000 0000000000000000000000000000000000000001 0000000000000000000000000000000000000010 0000000000000000000000000000000000000100 0000000000000000000000000000000000001000 0000000000000000000000000000000000010000 0000000000000000000000000000000000100000 0000000000000000000000000000000001000000 0000000000000000000000000000000010000000 0000000000000000000000000000000100000000 0000000000000000000000000000001000000000 0000000000000000000000000000010000000000 0000000000000000000000000000100000000000 0000000000000000000000000001000000000000 0000000000000000000000000010000000000000 0000000000000000000000000100000000000000 0000000000000000000000001000000000000000 0000000000000000000000010000000000000000 0000000000000000000000100000000000000000 0000000000000000000001000000000000000000 0000000000000000000010000000000000000000


#0-19, 20-39, 0000000000000000000000000000000000000001 0000000000000000000000000000000000000010 0000000000000000000000000000000000000100 0000000000000000000000000000000000001000 0000000000000000000000000000000000010000 0000000000000000000000000000000000100000 0000000000000000000000000000000001000000 0000000000000000000000000000000010000000 0000000000000000000000000000000100000000 0000000000000000000000000000001000000000 0000000000000000000000000000010000000000 0000000000000000000000000000100000000000 0000000000000000000000000001000000000000 0000000000000000000000000010000000000000 0000000000000000000000000100000000000000 0000000000000000000000001000000000000000 0000000000000000000000010000000000000000 0000000000000000000000100000000000000000 0000000000000000000001000000000000000000 0000000000000000000010000000000000000000 0000000000000000000100000000000000000000 0000000000000000001000000000000000000000 0000000000000000010000000000000000000000 0000000000000000100000000000000000000000 0000000000000001000000000000000000000000 0000000000000010000000000000000000000000 0000000000000100000000000000000000000000 0000000000001000000000000000000000000000 0000000000010000000000000000000000000000 0000000000100000000000000000000000000000 0000000001000000000000000000000000000000 0000000010000000000000000000000000000000 0000000100000000000000000000000000000000 0000001000000000000000000000000000000000 0000010000000000000000000000000000000000 0000100000000000000000000000000000000000 0001000000000000000000000000000000000000 0010000000000000000000000000000000000000 0100000000000000000000000000000000000000 1000000000000000000000000000000000000000


#0-9, 20-29,10-19,30-39 0000000000000000000000000000000000000001 0000000000000000000000000000000000000010 0000000000000000000000000000000000000100 0000000000000000000000000000000000001000 0000000000000000000000000000000000010000 0000000000000000000000000000000000100000 0000000000000000000000000000000001000000 0000000000000000000000000000000010000000 0000000000000000000000000000000100000000 0000000000000000000000000000001000000000 0000000000000000000100000000000000000000 0000000000000000001000000000000000000000 0000000000000000010000000000000000000000 0000000000000000100000000000000000000000 0000000000000001000000000000000000000000 0000000000000010000000000000000000000000 0000000000000100000000000000000000000000 0000000000001000000000000000000000000000 0000000000010000000000000000000000000000 0000000000100000000000000000000000000000 0000000000000000000000000000010000000000 0000000000000000000000000000100000000000 0000000000000000000000000001000000000000 0000000000000000000000000010000000000000 0000000000000000000000000100000000000000 0000000000000000000000001000000000000000 0000000000000000000000010000000000000000 0000000000000000000000100000000000000000 0000000000000000000001000000000000000000 0000000000000000000010000000000000000000 0000000001000000000000000000000000000000 0000000010000000000000000000000000000000 0000000100000000000000000000000000000000 0000001000000000000000000000000000000000 0000010000000000000000000000000000000000 0000100000000000000000000000000000000000 0001000000000000000000000000000000000000 0010000000000000000000000000000000000000 0100000000000000000000000000000000000000 1000000000000000000000000000000000000000

#10-19,30-39, 0-9, 20-29, 0000000000000000000000000000010000000000 0000000000000000000000000000100000000000 0000000000000000000000000001000000000000 0000000000000000000000000010000000000000 0000000000000000000000000100000000000000 0000000000000000000000001000000000000000 0000000000000000000000010000000000000000 0000000000000000000000100000000000000000 0000000000000000000001000000000000000000 0000000000000000000010000000000000000000 0000000001000000000000000000000000000000 0000000010000000000000000000000000000000 0000000100000000000000000000000000000000 0000001000000000000000000000000000000000 0000010000000000000000000000000000000000 0000100000000000000000000000000000000000 0001000000000000000000000000000000000000 0010000000000000000000000000000000000000 0100000000000000000000000000000000000000 1000000000000000000000000000000000000000 0000000000000000000000000000000000000001 0000000000000000000000000000000000000010 0000000000000000000000000000000000000100 0000000000000000000000000000000000001000 0000000000000000000000000000000000010000 0000000000000000000000000000000000100000 0000000000000000000000000000000001000000 0000000000000000000000000000000010000000 0000000000000000000000000000000100000000 0000000000000000000000000000001000000000 0000000000000000000100000000000000000000 0000000000000000001000000000000000000000 0000000000000000010000000000000000000000 0000000000000000100000000000000000000000 0000000000000001000000000000000000000000 0000000000000010000000000000000000000000 0000000000000100000000000000000000000000 0000000000001000000000000000000000000000 0000000000010000000000000000000000000000 0000000000100000000000000000000000000000



#0-9,30-39, 20-29,10-19 0000000000000000000000000000000000000001 0000000000000000000000000000000000000010 0000000000000000000000000000000000000100 0000000000000000000000000000000000001000 0000000000000000000000000000000000010000 0000000000000000000000000000000000100000 0000000000000000000000000000000001000000 0000000000000000000000000000000010000000 0000000000000000000000000000000100000000 0000000000000000000000000000001000000000 0000000001000000000000000000000000000000 0000000010000000000000000000000000000000 0000000100000000000000000000000000000000 0000001000000000000000000000000000000000 0000010000000000000000000000000000000000 0000100000000000000000000000000000000000 0001000000000000000000000000000000000000 0010000000000000000000000000000000000000 0100000000000000000000000000000000000000 1000000000000000000000000000000000000000 0000000000000000000100000000000000000000 0000000000000000001000000000000000000000 0000000000000000010000000000000000000000 0000000000000000100000000000000000000000 0000000000000001000000000000000000000000 0000000000000010000000000000000000000000 0000000000000100000000000000000000000000 0000000000001000000000000000000000000000 0000000000010000000000000000000000000000 0000000000100000000000000000000000000000 0000000000000000000000000000010000000000 0000000000000000000000000000100000000000 0000000000000000000000000001000000000000 0000000000000000000000000010000000000000 0000000000000000000000000100000000000000 0000000000000000000000001000000000000000 0000000000000000000000010000000000000000 0000000000000000000000100000000000000000 0000000000000000000001000000000000000000 0000000000000000000010000000000000000000


#30-39, 0-9, 20-29,10-19 0000000001000000000000000000000000000000 0000000010000000000000000000000000000000 0000000100000000000000000000000000000000 0000001000000000000000000000000000000000 0000010000000000000000000000000000000000 0000100000000000000000000000000000000000 0001000000000000000000000000000000000000 0010000000000000000000000000000000000000 0100000000000000000000000000000000000000 1000000000000000000000000000000000000000 0000000000000000000000000000000000000001 0000000000000000000000000000000000000010 0000000000000000000000000000000000000100 0000000000000000000000000000000000001000 0000000000000000000000000000000000010000 0000000000000000000000000000000000100000 0000000000000000000000000000000001000000 0000000000000000000000000000000010000000 0000000000000000000000000000000100000000 0000000000000000000000000000001000000000 0000000000000000000100000000000000000000 0000000000000000001000000000000000000000 0000000000000000010000000000000000000000 0000000000000000100000000000000000000000 0000000000000001000000000000000000000000 0000000000000010000000000000000000000000 0000000000000100000000000000000000000000 0000000000001000000000000000000000000000 0000000000010000000000000000000000000000 0000000000100000000000000000000000000000 0000000000000000000000000000010000000000 0000000000000000000000000000100000000000 0000000000000000000000000001000000000000 0000000000000000000000000010000000000000 0000000000000000000000000100000000000000 0000000000000000000000001000000000000000 0000000000000000000000010000000000000000 0000000000000000000000100000000000000000 0000000000000000000001000000000000000000 0000000000000000000010000000000000000000

#30-39,20-29, 10-19, 0-9 0000000001000000000000000000000000000000 0000000010000000000000000000000000000000 0000000100000000000000000000000000000000 0000001000000000000000000000000000000000 0000010000000000000000000000000000000000 0000100000000000000000000000000000000000 0001000000000000000000000000000000000000 0010000000000000000000000000000000000000 0100000000000000000000000000000000000000 1000000000000000000000000000000000000000 0000000000000000000100000000000000000000 0000000000000000001000000000000000000000 0000000000000000010000000000000000000000 0000000000000000100000000000000000000000 0000000000000001000000000000000000000000 0000000000000010000000000000000000000000 0000000000000100000000000000000000000000 0000000000001000000000000000000000000000 0000000000010000000000000000000000000000 0000000000100000000000000000000000000000 0000000000000000000000000000010000000000 0000000000000000000000000000100000000000 0000000000000000000000000001000000000000 0000000000000000000000000010000000000000 0000000000000000000000000100000000000000 0000000000000000000000001000000000000000 0000000000000000000000010000000000000000 0000000000000000000000100000000000000000 0000000000000000000001000000000000000000 0000000000000000000010000000000000000000 0000000000000000000000000000000000000001 0000000000000000000000000000000000000010 0000000000000000000000000000000000000100 0000000000000000000000000000000000001000 0000000000000000000000000000000000010000 0000000000000000000000000000000000100000 0000000000000000000000000000000001000000 0000000000000000000000000000000010000000 0000000000000000000000000000000100000000 0000000000000000000000000000001000000000


#20-29, 10-19, 30-39, 0-9 0000000000000000000100000000000000000000 0000000000000000001000000000000000000000 0000000000000000010000000000000000000000 0000000000000000100000000000000000000000 0000000000000001000000000000000000000000 0000000000000010000000000000000000000000 0000000000000100000000000000000000000000 0000000000001000000000000000000000000000 0000000000010000000000000000000000000000 0000000000100000000000000000000000000000 0000000000000000000000000000010000000000 0000000000000000000000000000100000000000 0000000000000000000000000001000000000000 0000000000000000000000000010000000000000 0000000000000000000000000100000000000000 0000000000000000000000001000000000000000 0000000000000000000000010000000000000000 0000000000000000000000100000000000000000 0000000000000000000001000000000000000000 0000000000000000000010000000000000000000 0000000001000000000000000000000000000000 0000000010000000000000000000000000000000 0000000100000000000000000000000000000000 0000001000000000000000000000000000000000 0000010000000000000000000000000000000000 0000100000000000000000000000000000000000 0001000000000000000000000000000000000000 0010000000000000000000000000000000000000 0100000000000000000000000000000000000000 1000000000000000000000000000000000000000 0000000000000000000000000000000000000001 0000000000000000000000000000000000000010 0000000000000000000000000000000000000100 0000000000000000000000000000000000001000 0000000000000000000000000000000000010000 0000000000000000000000000000000000100000 0000000000000000000000000000000001000000 0000000000000000000000000000000010000000 0000000000000000000000000000000100000000 0000000000000000000000000000001000000000 
