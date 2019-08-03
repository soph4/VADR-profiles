#!/bin/sh
#dir=$1

for file in *.cm;
do      
        
	wc -l ${file:0:9}.*stk | awk '{print $2}' > ${file:0:9}.txt
	length="$(wc -l ${file:0:9}.txt | awk '{print $1}')"
	#echo $length
	if (( $length != 1 ));
	then
		#echo $file in if statement
		head -n -1 ${file:0:9}.txt > ${file:0:9}.stk.list
		rm ${file:0:9}.txt
	else
		#echo $file in else statement
		mv ${file:0:9}.txt ${file:0:9}.stk.list
	fi

done

#rm *stk.list

for file in *.fa;
do
	sort -V -k1,1 ${file:0:9}.stk.list > ${file:0:9}.sorted.stk.list

done
