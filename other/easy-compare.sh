file=$1
source ~husg/.bashrc
while read line;
do
	echo $line	
	esearch -db nuccore -query "$line" | efetch -format fasta > $line.fa
	#wait;	
	#qsub -N vadr -b y -v SGE_FACILITIES -P unified -S /bin/bash -cwd -V -j n -o /dev/null -e cm.err -l m_mem_free=16G,h_rt=2880000,mem_free=16G,h_vmem=16G -m n "v-annotate.pl -f -p --keep -m hcv-r1.cm -i ../2seq-per-CM-extend-refseq-r2/new.minfo -b ../2seq-per-CM-extend-refseq-r2/blastx_db/ $line.fa $line-vadr-r1"
	#qsub -N vadr -b y -v SGE_FACILITIES -P unified -S /bin/bash -cwd -V -j n -o /dev/null -e cm.err -l m_mem_free=16G,h_rt=2880000,mem_free=16G,h_vmem=16G -m n "v-annotate.pl -f -p --keep -m hcv-extend-refseq-r2.cm -i ../2seq-per-CM-extend-refseq-r2/new.minfo -b ../2seq-per-CM-extend-refseq-r2/blastx_db/ $line.fa $line-vadr-r2"

	

done < $file
