#!/bin/sh

for file_name in *.stk;
do
	echo $file_name
	esl-alistat $file_name > out
	num=$(awk 'FNR == 3 {print $4}' out)
	rm out	

	longest=""
	max=0
	for ((i=1; i<=$num; i++));
	do
		seq=$(cat $file_name | cut -d'.' -f6 | sed '/^$/d' | awk "FNR == $i" | awk '{print $1}')
		echo $seq
		length=$(esearch -db nuccore -query $seq | efetch -format docsum | grep Slen | cut -d '>' -f2 | cut -d '<' -f1)
		echo $length
		if [ $max -lt $length ]
		then
			longest=$seq
			max=$length
		fi
	done
	echo "max = $longest"

	v-build.pl --skipbuild $longest $file_name.$longest.minfo 
done
