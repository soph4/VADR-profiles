for file in *.cm;
do
	length="$(wc -l ${file:0:9}.sorted.stk.list | awk '{print $1}')"
	echo $length
	if (( $length != 1 ));
	then
		esl-alimerge --list -o ${file:0:9}.merged.stk ${file:0:9}.sorted.stk.list
	else
		cp ${file:0:9}.fa.*r1.stk ${file:0:9}.merged.stk
	fi
done
