sh alimerge-list.sh

#takes the files from alimerge-list script
#uses esl-alimerge to merge the .stk files together for each refseq
sh merge.sh

#takes the merged .stk files from ALIGN step 3 and uses esl-weight to filter sequences
#so no sequence is more than 95% similiar to each other
sh weight.sh

#input: all the refseqs .minfo files together
#output: cds-start-end.txt files
minfo=$1
python3 cds_start_end.py $1

#creates a list of all the .cmalign files (created from QALIGN.sh script) for each refseq
sh cmalign-list.sh

#extracts the start and end points of each seq from the .cmalign files for each refseq
sh combined.cmalign.sh

#extracts the selected sequences from .updated.stk files
sh extract_seq_cmalign.sh

#takes the sequences that have passed the esl-weight step and the 
#extracted start and stop positions from each sequence from the combined.cmalign script
#filters out sequences from esl-weight step that does not start before the first CDS position
#and does not stop after the last position of the CDS (obtained from cds-start-end.txt) 
python3 filter.py

#
sh rm_seq_stk.sh

sh qsub.sh
