for file in *.cm;
do
	weight=$(esl-weight --idf 0.95 -f ${file:0:9}.merged.stk | esl-alistat - | awk 'FNR == 3 {print $4}')
	total=$(esl-alistat ${file:0:9}.merged.stk | awk 'FNR == 3 {print $4}')
	diff=$( expr $total - $weight )
	#Can adjust to allow more or less sequences to pass
	if (( $total <= 25 )) && (( $diff <= 5 ))
	then
		echo ${file:0:9}
		esl-weight --idf 1.0 -f -o ${file:0:9}.weighted.stk ${file:0:9}.merged.stk

	else
		esl-weight --idf 0.95 -f -o ${file:0:9}.weighted.stk ${file:0:9}.merged.stk
	fi
done
