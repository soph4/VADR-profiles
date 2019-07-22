#!/bin/bash

for file in *.cm*; do
	echo "$(basename "$file")"

	#OUTPUT="$(ls -1)"
	#echo "${OUTPUT}"
	length="$(wc -l ${file:0:9}.reverse.list.txt | awk '{print $1}')"
	#echo "${length}"

	if (($length > 10))
	then
		OUTPUT="$(perl ~husg/vadr-install/Bio-Easel/scripts/esl-ssplit.pl ${file:0:9}.fa 5)"
		for line in ${file:0:9}.fa.*;
		do
			#echo "${line}"
			#echo "executing qsub code here"
			qsub -N "${line}" -b y -v SGE_FACILITIES -P unified -S /bin/bash -cwd -V -j n -o /dev/null -e cm.err -l m_mem_free=16G,h_rt=2880000,mem_free=16G,h_vmem=16G -m n "cmalign --cpu 0 --mxsize 8000 -o ${line}.r1.stk ${file:0:9}.cm ${line} > ${line}.r1.cmalign"
		
		done
					
	else
		#echo "executing qsub code here"	
		qsub -N cm -b y -v SGE_FACILITIES -P unified -S /bin/bash -cwd -V -j n -o /dev/null -e cm.err -l m_mem_free=16G,h_rt=2880000,mem_free=16G,h_vmem=16G -m n "cmalign --cpu 0 --mxsize 8000 -o ${file:0:9}.fa.r1.stk ${file:0:9}.cm ${file:0:9}.fa > ${file:0:9}.fa.r1.cmalign"	
	fi
    
done
