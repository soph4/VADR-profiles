
#Command: sh 1-filter.sh <sqa file> <fasta file>

sqa=$1
#Step 1
#Input: requires the .sqa.tbl file
#Output: .txt files with all the sequences that passed in their individual refseq groups

python3 ~husg/HCV-v2/scripts/seperate.py $1 

#Step 2
#Input: .txt file
#Output: reverse.txt
for file in NC_*;
do

	sort -k2,2 -r -n ${file:0:9}.txt > ${file:0:9}.reverse.txt	

done

#Step 3
#Input: .reverse.txt files
#Output: .reverse.list.txt

for file in *reverse*;
do
	echo ${file:0:9}.1 > ${file:0:9}.reverse.list.txt
	awk '{print $1}' ${file:0:9}.reverse.txt >> ${file:0:9}.reverse.list.txt		
	
done

#Step 4
#Input: .reverse.list.txt files
#Output: .fa files

fa=$2
for file in *reverse.list.txt;
do

	if [ ${file:0:9} == NC_038425 ];
	then
		sequences="$(cat $file)"	
		esearch -db nuccore -query "$sequences" | efetch -format fasta > ${file:0:9}.fa
	else
		esl-sfetch -f $fa ${file:0:9}.reverse.list.txt > ${file:0:9}.fa 
	fi
done


rm *reverse.txt
rm *reverse.list.txt

