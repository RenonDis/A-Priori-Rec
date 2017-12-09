#/bin/sh!

minSup=$1

minConf=$2

while [ "$remain" != "0" ]; do
    
    echo "minSup=" $minSup " minConf=" $minConf
    bash getFrequents.sh $minSup $minConf
    
    if [ -f detailFrequents ];
    then
        mostFrequent=$(sort -k1,1rn -k2rn detailFrequents|sed '2,$d'|cut -d " " -f8,10-)

        detailMostFrequent=$(sort -k1,1rn -k2rn detailFrequents|sed '2,$d')
        echo "New Rule Found ! " $detailMostFrequent
        echo $detailMostFrequent >> apriori.rules

        echo "removing " $mostFrequent "..."
        filter=$(bash removePredicted.sh $mostFrequent)

        echo $filter

        remain=$(echo $filter|cut -d " " -f5)
    else
        echo "No frequents found, decreasing minSup"
        minSup=$(($minSup/2))
    fi
done
