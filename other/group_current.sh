#r1=$1
#r2=$2
file_r1=$1
file_r2=$2
common=$3
r1=$4
r2=$5

rm p_lin-errors-r1.txt
rm p_lin-errors-r2.txt
rm c-lss-errors-r1.txt
rm c-lss-errors-r2.txt
rm c-lse-errors-r1.txt
rm c-lse-errors-r2.txt


while read line;
do
	refseq="$(grep -v b_per $file_r1 | grep -m1 $line | awk '{print $3}')"
        #ftr_type="$(grep -v b_per $file_r1 | grep $r1_line | awk '{print $4}')"
        grep -v b_per $file_r1 | grep $line | awk '{print $4}' > ftr_type.txt
        #ftr_name="$(grep -v b_per $file_r1 | grep $r1_line | awk '{print $5}')"
        grep -v b_per $file_r1 | grep $line | awk '{print $5}' > ftr_name.txt
        #alert="$(grep -v b_per $file_r1 | grep $r1_line | awk '{print $7}')"
        grep -v b_per $file_r1 | grep $line | awk '{print $7}' > alert.txt
        #desc="$(grep -v b_per $file_r1 | grep $r1_line | awk '{$1=$2=$3=$4=$5=$6=$7=$8=$9=""; print $0}')"
        grep -v b_per $file_r1 | grep $line | awk '{$1=$2=$3=$4=$5=$6=$7=$8=$9=""; print $0}' > desc.txt     
        
	alert="$(cat alert.txt | sort | uniq)"
        IFS=' ' read -r -a array <<< $alert

        for element in "${array[@]}"
        do
		if [ $element = "p_lin" ];
		then
			echo $line >> p_lin-errors-r1.txt
		fi
		if [ $element = "c_lss" ];
                then
                        echo $line >> c-lss-errors-r1.txt
                fi
		if [ $element = "c_lse" ];
                then
                        echo $line >> c-lse-errors-r1.txt
                fi
        done
	
	echo -e "" >> ftr_type.txt
	echo -e "" >> ftr_name.txt
	echo -e "" >> alert.txt	
	echo -e "" >> desc.txt
		
        refseq2="$(grep -v b_per $file_r2 | grep -m1 $line | awk '{print $3}')"
        #ftr_type2="$(grep -v b_per $file_r2 | grep $r2_line | awk '{print $4}')"
        grep -v b_per $file_r2 | grep $line | awk '{print $4}' >> ftr_type.txt
        #ftr_name2="$(grep -v b_per $file_r2 | grep $r2_line | awk '{print $5}')"
        grep -v b_per $file_r2 | grep $line | awk '{print $5}' >> ftr_name.txt
        #alert2="$(grep -v b_per $file_r2 | grep $r2_line | awk '{print $7}')"
        grep -v b_per $file_r2 | grep $line | awk '{print $7}' >> alert.txt
        #desc2="$(grep -v b_per $file_r2 | grep $r2_line | awk '{$1=$2=$3=$4=$5=$6=$7=$8=$9=""; print $0}')"
        grep -v b_per $file_r2 | grep $line | awk '{$1=$2=$3=$4=$5=$6=$7=$8=$9=""; print $0}' >> desc.txt

       
	#alerts="$(cat alert.txt | sort | uniq > alert2.txt)"
	#IFS='\n' read -r -a array <<< alert2.txt
	alert="$(grep -v b_per $file_r2 | grep $line | awk '{print $7}' | sort | uniq)"
	IFS=' ' read -r -a array <<< $alert

	for element in "${array[@]}"
	do
    		if [ $element = "p_lin" ];
		then 
                        echo $line >> p_lin-errors-r2.txt
		fi
		if [ $element = "c_lss" ];
		then
			echo $line >> c-lss-errors-r2.txt
		fi
		if [ $element = "c_lse" ];
                then
                        echo $line >> c-lse-errors-r2.txt
                fi
	done
	

	#cat ftr_type.txt
	#cat "\n"
		
	if [ $refseq = $refseq2 ];
        then
                echo -e "$line   $line   $refseq   $refseq2   SAME" >> refseq.txt
        else
                echo -e "$line   $line   $refseq   $refseq2   DIFF" >> refseq.txt
                
        fi
        paste ftr_type.txt ftr_name.txt| awk -F'\t' '{ printf("%-20s %s\n", $1, $2) }' >> output.txt
        paste output.txt alert.txt | awk -F'\t' '{ printf("%-60s %s\n", $1, $2) }' >> output1.txt
        paste output1.txt desc.txt | awk -F'\t' '{ printf("%-30s %s\n", $1, $2) }'>> output2.txt

	#sort -V -k1,1 output2.txt | uniq > output3.txt

        paste refseq.txt output2.txt | awk -F'\t' '{ printf("%-55s %s\n", $1, $2) }' >> output3.txt 
	echo "---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" >> output3.txt	
        
	cat output3.txt >>  errors.txt
        rm output3.txt
        rm output2.txt
        rm output1.txt
        rm output.txt 
        rm refseq.txt
        rm ftr_type.txt
        rm alert.txt
        rm ftr_name.txt
        rm desc.txt
	#rm output4.txt

done < $common

while read line;
do
	refseq="$(grep -v b_per $file_r1 | grep -m1 $line | awk '{print $3}')"
        #ftr_type="$(grep -v b_per $file_r1 | grep $r1_line | awk '{print $4}')"
        grep -v b_per $file_r1 | grep $line | awk '{print $4}' > ftr_type.txt
        #ftr_name="$(grep -v b_per $file_r1 | grep $r1_line | awk '{print $5}')"
        grep -v b_per $file_r1 | grep $line | awk '{print $5}' > ftr_name.txt
        #alert="$(grep -v b_per $file_r1 | grep $r1_line | awk '{print $7}')"
        grep -v b_per $file_r1 | grep $line | awk '{print $7}' > alert.txt
        #desc="$(grep -v b_per $file_r1 | grep $r1_line | awk '{$1=$2=$3=$4=$5=$6=$7=$8=$9=""; print $0}')"
        grep -v b_per $file_r1 | grep $line | awk '{$1=$2=$3=$4=$5=$6=$7=$8=$9=""; print $0}' > desc.txt
	
	alert="$(cat alert.txt | sort | uniq)"
        IFS=' ' read -r -a array <<< $alert
	for element in "${array[@]}"
        do
                if [ $element = "p_lin" ];
                then
                        echo $line >> p_lin-errors-r1.txt
                fi
		if [ $element = "c_lss" ];
                then
                        echo $line >> c-lss-errors-r1.txt
                fi
		if [ $element = "c_lse" ];
                then
                        echo $line >> c-lss-errors-r1.txt
                fi
	
        done

	echo -e "$line                $refseq   $refseq   r1  " >> refseq.txt

	paste ftr_type.txt ftr_name.txt| awk -F'\t' '{ printf("%-20s %s\n", $1, $2) }' >> output.txt
        paste output.txt alert.txt | awk -F'\t' '{ printf("%-60s %s\n", $1, $2) }' >> output1.txt
        paste output1.txt desc.txt | awk -F'\t' '{ printf("%-30s %s\n", $1, $2) }'>> output2.txt
        paste refseq.txt output2.txt | awk -F'\t' '{ printf("%-55s %s\n", $1, $2) }' >> output3.txt
	echo "---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" >> output3.txt

	cat output3.txt >>  errors.txt
        rm output3.txt
        rm output2.txt
        rm output1.txt
        rm output.txt
        rm refseq.txt
        rm ftr_type.txt
        rm alert.txt
        rm ftr_name.txt
        rm desc.txt
done < $r1

while read line;
do
        refseq="$(grep -v b_per $file_r2 | grep -m1 $line | awk '{print $3}')"
        #ftr_type="$(grep -v b_per $file_r1 | grep $r1_line | awk '{print $4}')"
        grep -v b_per $file_r2 | grep $line | awk '{print $4}' > ftr_type.txt
        #ftr_name="$(grep -v b_per $file_r1 | grep $r1_line | awk '{print $5}')"
        grep -v b_per $file_r2 | grep $line | awk '{print $5}' > ftr_name.txt
        #alert="$(grep -v b_per $file_r1 | grep $r1_line | awk '{print $7}')"
        grep -v b_per $file_r2 | grep $line | awk '{print $7}' > alert.txt
        #desc="$(grep -v b_per $file_r1 | grep $r1_line | awk '{$1=$2=$3=$4=$5=$6=$7=$8=$9=""; print $0}')"
        grep -v b_per $file_r2 | grep $line | awk '{$1=$2=$3=$4=$5=$6=$7=$8=$9=""; print $0}' > desc.txt

	alert="$(cat alert.txt | sort | uniq)"
        IFS=' ' read -r -a array <<< $alert
	for element in "${array[@]}"
        do
                if [ $element = "p_lin" ];
                then
                        echo $line >> p_lin-errors-r2.txt
                fi
		if [ $element = "c_lss" ];
                then
                        echo $line >> c-lss-errors-r2.txt
                fi
		if [ $element = "c_lse" ];
                then
                        echo $line >> c-lse-errors-r2.txt
                fi
        done

        echo -e "             $line   $refseq   $refseq   r2  " >> refseq.txt

        paste ftr_type.txt ftr_name.txt| awk -F'\t' '{ printf("%-20s %s\n", $1, $2) }' >> output.txt
        paste output.txt alert.txt | awk -F'\t' '{ printf("%-60s %s\n", $1, $2) }' >> output1.txt
        paste output1.txt desc.txt | awk -F'\t' '{ printf("%-30s %s\n", $1, $2) }'>> output2.txt
        paste refseq.txt output2.txt | awk -F'\t' '{ printf("%-55s %s\n", $1, $2) }' >> output3.txt
	echo "---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------" >> output3.txt

        cat output3.txt >>  errors.txt
        rm output3.txt
        rm output2.txt
        rm output1.txt
        rm output.txt
        rm refseq.txt
        rm ftr_type.txt
        rm alert.txt
        rm ftr_name.txt
        rm desc.txt
done < $r2

