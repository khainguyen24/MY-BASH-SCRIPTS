#!/bin/bash

outFile=out.ident.csv
server=10.21.2.59
shard=identities_shard1_replica1
fileIdent=summary.csv

curl "http://$server:8983/solr/$shard/select?q=*.*&fq=bid%3A*&fl=bid&wt=csv&indent=true" |grep -v bid>  terms/bids.txt

bldData () {
searchTerms="";
IFS=",";while read enable term;do if [[ $enable = 1 ]];then bldSTerms;fi;done < terms/s.enable.term.csv
bidAll="";
IFS=",";while read bid;do if [[ $bidAll != "" ]];then bidAll="$bidAll+or+$bid";else bidAll=$bid;fi;done < terms/bids.txt
}

bldSTerms () {
if [[ $enable = 1 ]];then
searchTerms=$searchTerms$term%2C;
fi;

}

bldBids () {
bidAll=$bidAll+or+$bid
}

bldData;

curl "http://$server:8983/solr/$shard/select?q=*.*&fl=$searchTerms&wt=csv&indent=true&csv.mv.separator=%7C" |sed 's/\^//g' > $outFile

#curl "http://$server:8983/solr/$shard/select?q=*.*&fl=$searchTerms&wt=xml&indent=true&csv.mv.separator=%7C" >1.txt
#curl "http://$server:8983/solr/$shard/select?q=*.*&fq=bid%3A$bid1+or+$bid2&fl=$searchTerms&wt=csv&indent=true&csv.mv.separator=%7C" |sed 's/\^//g'


curl "http://$server:8983/solr/$shard/select?q=*.*&fq=bid%3A$bidAll&fl=id.bid&wt=csv&indent=true&csv.mv.separator=%7C" |sed 's/\^//g' |grep -v id.bid >terms/id.bid.csv


~
~
~
