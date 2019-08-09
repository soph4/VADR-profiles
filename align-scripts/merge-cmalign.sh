
#makes a list of all the cmalign files
#obtains the start and ends of each sequence in the cmalign files
#input: all the cmalign files created from the qalign script
#output: <refseq>.combined.cmalign file
for file in *.fa;
do      
        
	wc -l ${file:0:9}.fa.*cmalign | awk '{print $2}' > ${file:0:9}.cmalign.list.txt
	sort -V -k1,1 ${file:0:9}.cmalign.list.txt > ${file:0:9}.cmalign.sorted.txt
 	rm ${file:0:9}.cmalign.list.txt	 	
	
	length="$(wc -l ${file:0:9}.cmalign.sorted.txt | awk '{print $1}')"
	if (( $length != 1 ));
	then
		head -n -1 ${file:0:9}.cmalign.sorted.txt > ${file:0:9}.cmalign.sorted2.txt
		rm ${file:0:9}.cmalign.sorted.txt
		mv ${file:0:9}.cmalign.sorted2.txt ${file:0:9}.cmalign.sorted.txt
	fi

	input="${file:0:9}.cmalign.sorted.txt"

	while read -r line;
	do
		echo "$line"
		length="$(wc -l $line | awk '{print $1}')"
		end=$(($length-2-16))
		tail -n +17 $line | head -n $end | awk '{print $2, $4, $5}' >> ${file:0:9}.combined.cmalign

	done < "$input"
done

rm *cmalign.sorted.txt
