#/bin/sh!


valeurAttributs=$(echo $1|sed 's/,/ /g'|sed 's/'"'"'//g')
arrayValeur=($valeurAttributs)
attrs=$(echo $@|cut -d " " -f 2-)
arrayAttrs=($attrs)
arrayAttrToValeur=()
counter=0
counterBis=0

for attr in $(seq 1 22); do
    aux=${arrayAttrs[$counter]}
    if [ "$attr" == "$aux" ]
    then
        arrayAttrToValeur[$attr]=${arrayValeur[$counter]}
        let "counter++"
    else
        arrayAttrToValeur[$attr]=none
    fi
done
# if ($i=="'\''valeurs[i]'\''")
sed 's/'"'"'//g' mushrooms_wekaT.arff \
|awk -F "," \
    -v a="${arrayAttrToValeur[*]}" 'BEGIN {split(a, valeurs, / /);flag=0}
    { for (i=1; i<=22; i++) { 
        if ($i!=valeurs[i] && valeurs[i]!="none") {print; continue} 
        else {
            if (i==22 && $NF=="e") {flag=flag+1}
        }
        } 
    } #END { print "with the rule and edible" flag}' \
|sed '26,$ s/^/'"'"'/g' \
|sed '26,$ s/,/'"'"','"'"'/g' \
|sed '26,$ s/$/'"'"'/g' > tempMushrooms

newNLines=$(wc -l tempMushrooms|cut -d " " -f1)
oldNLines=$(wc -l mushrooms_wekaT.arff|cut -d " " -f1)
remaining=$(egrep "'e'$" tempMushrooms|wc -l)

echo "Removed " $(($oldNLines-$newNLines)) ", remains " $remaining 

cp tempMushrooms mushrooms_wekaT.arff

