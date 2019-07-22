for file in *.cm;
do

	esl-alimanip --seq-k ${file:0:9}.good.txt ${file:0:9}.updated.stk > ${file:0:9}.final.stk
done
