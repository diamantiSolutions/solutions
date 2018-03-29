#!/bin/bash
#mkdir abc
#cd abc
#rm scale.txt

#echo "Paramter Name :".$1."  <br>" >>scale.txt
#echo "Parameter Scale :".$2"  <br>">>scale.txt

print chomp(`kubectl scale statefulsets $1 $2`);
