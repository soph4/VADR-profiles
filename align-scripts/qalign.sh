#!/bin/bash
#input: 
#	.fa files: generated from filter step
#	.reverse.list.txt files: generated from filter step
#	.cm files: needs every refseqs CM

#Output: aligns the sequences that passed round 1 of VADR to the refseqs CM
#	 .stk files
#	 .cmalign files

for file in *.fa; do
	echo "$(basename "$file")"

	length="$(wc -l ${file:0:9}.reverse.list.txt | awk '{print $1}')"
	if (($length > 10))
	then
		#will need to update path if it changes
		OUTPUT="$(perl /panfs/pan1/dnaorg/virseqannot/code/vadr-install/Bio-Easel/scripts/esl-ssplit.pl ${file:0:9}.fa 5)"
		for line in ${file:0:9}.fa.*;
		do
			qsub -N "${line}" -b y -v SGE_FACILITIES -P unified -S /bin/bash -cwd -V -j n -o /dev/null -e cm.err -l m_mem_free=16G,h_rt=2880000,mem_free=16G,h_vmem=16G -m n "cmalign --cpu 0 --mxsize 8000 -o ${line}.r1.stk ${file:0:9}.cm ${line} > ${line}.r1.cmalign"
		
		done
					
	else
		qsub -N cm -b y -v SGE_FACILITIES -P unified -S /bin/bash -cwd -V -j n -o /dev/null -e cm.err -l m_mem_free=16G,h_rt=2880000,mem_free=16G,h_vmem=16G -m n "cmalign --cpu 0 --mxsize 8000 -o ${file:0:9}.fa.r1.stk ${file:0:9}.cm ${file:0:9}.fa > ${file:0:9}.fa.r1.cmalign"	
	fi
done	
