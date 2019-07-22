#extracts the selected sequences from .updated.stk files
#step done after esl-weight filters the sequences 
for file in *.cm;
do
	length="$(esl-alistat ${file:0:9}.updated.stk | awk 'FNR == 3 {print $4}')"
	tail -n +4 ${file:0:9}.updated.stk | head -n $length | awk '{print $2}' > ${file:0:9}.selected.txt
done
