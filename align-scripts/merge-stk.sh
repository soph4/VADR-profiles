#!/bin/sh

#creates list of stk files created from the qalign step
for file in *.fa;
do      
        
	wc -l ${file:0:9}.*stk | awk '{print $2}' > ${file:0:9}.txt
	length="$(wc -l ${file:0:9}.txt | awk '{print $1}')"
	
	if (( $length != 1 ));
	then
		head -n -1 ${file:0:9}.txt > ${file:0:9}.stk.list
		rm ${file:0:9}.txt
	else
		mv ${file:0:9}.txt ${file:0:9}.stk.list
	fi

	sort -V -k1,1 ${file:0:9}.stk.list > ${file:0:9}.sorted.stk.list

done

#merges all the .stk files together 
for file in *.fa;
do
	length="$(wc -l ${file:0:9}.sorted.stk.list | awk '{print $1}')"
	echo $length
	if (( $length != 1 ));
	then
		esl-alimerge --list -o ${file:0:9}.merged.stk ${file:0:9}.sorted.stk.list
	else
		cp ${file:0:9}.fa.*r1.stk ${file:0:9}.merged.stk
	fi
done

rm *.stk.list
