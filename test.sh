#!/bin/sh

totalFalse=0
nEdible1=$(cat mushrooms_wekaT.arff|egrep "'e'$"|wc -l)

cat rules |while read rule; do

    nNonEdible1=$(cat mushrooms_wekaT.arff|egrep "'p'$"|wc -l)

    filter=$(bash removePredicted.sh $rule)
    echo $filter
    
    remain=$(echo $filter|cut -d " " -f5) 

    nNonEdible2=$(cat mushrooms_wekaT.arff|egrep "'p'$"|wc -l)

    falsePositive=$(($nNonEdible1-$nNonEdible2))
    echo $falsePositive

    totalFalse=$(($totalFalse+$falsePositive))
    echo $totalFalse

done

nEdible2=$(cat mushrooms_wekaT.arff|egrep "'e'$"|wc -l)
echo "remaining " $nEdible2 "edible mushrooms"
