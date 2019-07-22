for file in *.cm;
do
	esl-weight --idf 0.95 -f -o ${file:0:9}.updated.stk ${file:0:9}.merged.stk
	#esl-weight --idf 0.95 -f -o ${file:0:9}.updated.stk ${file:0:9}.filtered.stk
done
