for file in *.stk;
do

	#perl ~husg/vadr-install/vadr/miniscripts/build-add-blast-db.pl ${file:0:9}.minfo ${file:0:9}.final.stk ${file:0:9}.vadr
	perl /panfs/pan1/dnaorg/virseqannot/code/vadr-install/vadr/miniscripts/build-add-blast-db.pl ${file:0:9}.minfo ${file:0:9}.final.stk ${file:0:9}.vadr
done
