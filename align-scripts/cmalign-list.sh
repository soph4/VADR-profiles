dir=$1

for file in *.cm;
do      
        
	wc -l $dir*${file:0:9}.fa.*cmalign | awk '{print $2}' > ${file:0:9}.cmalign.list.txt
	sort -V -k1,1 ${file:0:9}.cmalign.list.txt > ${file:0:9}.cmalign.sorted.txt
 	rm ${file:0:9}.cmalign.list.txt	 	
	
	length="$(wc -l ${file:0:9}.cmalign.sorted.txt | awk '{print $1}')"
	if (( $length != 1 ));
	then
		head -n -1 ${file:0:9}.cmalign.sorted.txt > ${file:0:9}.cmalign.sorted2.txt
		rm ${file:0:9}.cmalign.sorted.txt
		mv ${file:0:9}.cmalign.sorted2.txt ${file:0:9}.cmalign.sorted.txt
	fi

done
