for file in *.cm;
do

	input="${file:0:9}.cmalign.sorted.txt"
	echo $input

	while read -r line;
	do
		echo "$line"
		length="$(wc -l $line | awk '{print $1}')"
		end=$(($length-2-16))
		tail -n +17 $line | head -n $end | awk '{print $2, $4, $5}' >> ${file:0:9}.combined.cmalign

	done < "$input"
done
