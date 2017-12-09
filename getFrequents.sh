#!/bin/sh

rm temp*

if [ -f attrFreq ]; then rm attrFreq; fi
if [ -f detailFrequents ]; then rm detailFrequents; fi


function projectAttributes { #attr $1+

    attributs=$(echo $@|sed 's/ /,/g')

    tail -n +26 mushrooms_wekaT.arff \
        |head -n -3 \
        |cut -d, -f $attributs,23 \
        |sort \
        |uniq -c \
        |sed 's/^ *//' > temp
    
    egrep "'e'$" temp > temp_e
    egrep "'p'$" temp|rev|cut -d "," -f2-|rev > temp_p
}


function getFrequentItemsets { #minsupp $1 #minconf $2 #attrs $3+

    numAttribs=$(echo $@|cut -d " " -f 3-|sed 's/ /-/g')
    itemsetSize=$(echo $numAttribs|awk -F "-" '{print NF}')

    cat temp_e | while read line; do
        attribs=$(echo $line|cut -d " " -f2-|rev|cut -d"," -f2-|rev)
        supp_p=$(grep "$attribs" temp_p|cut -d " " -f1)
        supp=$(echo "$line" |cut -d " " -f1)

        if [ $(($supp)) -gt $(($1)) ] 
        then
            if [ -n "$supp_p" ]
            then
                #echo $attribs suppp $supp $supp_p $numAttribs
                total=$(($supp+$supp_p))
                conf=$(bc <<<"scale=2; $supp / $total") 
            else
                conf=1
            fi

            is_conf=$(echo $conf'>='$2 | bc -l)

            if [ "$is_conf" -eq "1" ]
            then
                echo $line >> temp$numAttribs 
                echo $supp $itemsetSize "supp "$supp "conf "$conf \
                    "attrib "$attribs "numero " $numAttribs  \
                    |sed 's/-/ /g'  >> detailFrequents
                #echo $line "conf=" $conf
            fi
        fi
    done
}

for attribut in $(seq 1 22); do

    projectAttributes $attribut

    getFrequentItemsets $1 $2 $attribut

done

if [ -f detailFrequents ];
then
    cat detailFrequents|rev|cut -d " " -f1|rev|sort -n|uniq > attrFreq
    
    rm temp
    counter=1
    
    for attribut1 in $(cat attrFreq); do
        let "counter++"
    
        for attribut2 in $(tail -n +$counter attrFreq); do
    
            projectAttributes $attribut1 $attribut2
    
            getFrequentItemsets $1 $2 $attribut1 $attribut2
    
        done
    done
fi
