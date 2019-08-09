file=$1
#ext=$2

while read -r line;
do
	grep $line *r1.vadr.sqa.tbl | grep PASS | awk '{print $2}' | sort -V -k1 > $line-pass-r1
	grep $line *r1.vadr.sqa.tbl | grep FAIL | awk '{print $2}' | sort -V -k1 > $line-fail-r1
	grep $line *r2.vadr.sqa.tbl | grep PASS | awk '{print $2}' | sort -V -k1 > $line-pass-r2
	grep $line *r2.vadr.sqa.tbl | grep FAIL | awk '{print $2}' | sort -V -k1 > $line-fail-r2

	comm -1 -2 $line-pass-r1 $line-fail-r2 > $line-pass-fail
	comm -1 -2 $line-fail-r1 $line-pass-r2 > $line-fail-pass	

done < $file
