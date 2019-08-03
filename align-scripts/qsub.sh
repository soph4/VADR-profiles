#builds new round 2 CMs
#Inout:  .final.stk file
#Output: .build.out files 
#	 files can be concatenated to create one CM file

for file in *.cm;
do
	#CMs were already built 
	#this step avoids rebuilding again
	#if [ ${file:0:9} = "NC_009823" ] || [ ${file:0:9} = "NC_030791" ]
	#then
	#	echo ${file:0:9}
	#else
		#echo "here"
	qsub -N cm1 -b y -v SGE_FACILITIES -P unified -S /bin/bash -cwd -V -j n -o /dev/null -e cm.err -l m_mem_free=16G,h_rt=2880000,mem_free=16G,h_vmem=16G -m n "cmbuild --ere 1.0 --hand -n ${file:0:9} ${file:0:9}.build.out ${file:0:9}.final.stk"
	#fi
done
