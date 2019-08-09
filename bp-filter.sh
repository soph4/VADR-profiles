#!/bin/bash
#Command: sh 1-filter.sh <sqa file> <refseq_summary.txt file><fasta file>
#sqa file from round 1 of VADR
#refseq file contains 2 columns (1st: refseq accession numner, 2nd: length of refseq)
#fasta file: contains the sequences that will be looked at

#checks if arguements exists
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]
then
	echo "Command: bp-filter.sh <.sqa file> <refseq_summary file> <.fa file>"

	if [ -z "$1" ]
	then
		echo "error: sqa file does not exist"
	fi

	if [ -z "$2" ]
	then
		echo "error: refseq file does not exist"
	fi

	if [ -z "$3" ]
	then
		echo "error: fasta file does not exist"
	fi
	exit 1
else

	sqa=$1
	refseq_summary=$2

	#Input: requires the .sqa.tbl file
	#Output: pass.txt files with all the sequences that passed in their individual refseq groups
	#will need to change the path
	python3 /panfs/pan1/infernal/sophia/HCV-v2/scripts/VADR-profiles/bp-separate.py $1 $2

	#Input: pass.txt file
	#Output: reverse.list.txt 
	#	(obtains a list of PASSING sequences for each refseq in order from longest to shortest)
	for file in NC_*;
	do
		#sorts the sequences from longest to shortest
		sort -k2,2 -r -n ${file:0:9}.pass.txt > ${file:0:9}.reverse.txt	
		#adds the refseq to the top of the list
		#other sequences will be compared to it in the esl-weight step
		echo ${file:0:9}.1 > ${file:0:9}.reverse.pass.list.txt
		awk '{print $1}' ${file:0:9}.reverse.txt >> ${file:0:9}.reverse.pass.list.txt		
	
	done

	#Input: .reverse.list.txt files
	#Output: .fa files
	#	 (fetches fasta for selected sequences)
	fa=$3
	for file in *reverse.pass.list.txt;
	do
		esl-sfetch -f $fa ${file:0:9}.reverse.pass.list.txt > ${file:0:9}.fa;
	
		#fetches those sequences that are not in fasta file provided by the user
		length=$(wc -l ${file:0:9}.fa | awk '{print $1}')
		if (( $length == 0 ));
		then
			rm ${file:0:9}.fa
			sequences="$(cat $file)"        
        		esearch -db nuccore -query "$sequences" | efetch -format fasta > ${file:0:9}.fa	
		fi 
	done

	#removes unnecessary intermediate files
	rm *pass.txt
	rm *reverse.txt
fi
