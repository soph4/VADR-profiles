#!/bin/sh
#PATH="/panfs/pan1/infernal/sophia/HCV-v2/scripts/VADR-profiles/align-scripts"
#takes all the sequences that passed per refseq and aligns them to the refeq
sh /panfs/pan1/infernal/sophia/HCV-v2/scripts/VADR-profiles/align-scripts/qalign.sh

#mkdir qalign
#mv *.fa.* qalign
#cd qalign

#creates a sorted list of all the .stk files for each refseq
sh /panfs/pan1/infernal/sophia/HCV-v2/scripts/VADR-profiles/align-scripts/alimerge-list.sh;

#takes the files from alimerge-list script
#uses esl-alimerge to merge the .stk files together for each refseq
#sh $PATH/merge.sh

#takes the merged .stk files from ALIGN step 3 and uses esl-weight to filter sequences
#so no sequence is more than 95% similiar to each other
sh /panfs/pan1/infernal/sophia/HCV-v2/scripts/VADR-profiles/align-scripts/weight.sh;

#input: all the refseqs .minfo files together
#output: cds-start-end.txt files
minfo=$1
python3 /panfs/pan1/infernal/sophia/HCV-v2/scripts/VADR-profiles/align-scripts/cds_start_end.py $1;

#creates a list of all the .cmalign files (created from QALIGN.sh script) for each refseq
sh /panfs/pan1/infernal/sophia/HCV-v2/scripts/VADR-profiles/align-scripts/cmalign-list.sh;

#extracts the start and end points of each seq from the .cmalign files for each refseq
sh /panfs/pan1/infernal/sophia/HCV-v2/scripts/VADR-profiles/align-scripts/combined.cmalign.sh;

#extracts the selected sequences from .updated.stk files
sh /panfs/pan1/infernal/sophia/HCV-v2/scripts/VADR-profiles/align-scripts/extract_seq_cmalign.sh;

#takes the sequences that have passed the esl-weight step and the 
#extracted start and stop positions from each sequence from the combined.cmalign script
#filters out sequences from esl-weight step that does not start before the first CDS position
#and does not stop after the last position of the CDS (obtained from cds-start-end.txt) 
python3 /panfs/pan1/infernal/sophia/HCV-v2/scripts/VADR-profiles/align-scripts/filter.py;

#removes the sequences from the .stk files that do not exceed the start or end CDS positions
sh /panfs/pan1/infernal/sophia/HCV-v2/scripts/VADR-profiles/align-scripts/rm_seq_stk.sh;

#takes the .final.stk from ALIGN step 10 and builds a new CM
#sh /panfs/pan1/infernal/sophia/HCV-v2/scripts/VADR-profiles/align-scripts/qsub.sh
