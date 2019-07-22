General Pipeline:
1. Run 1st round of VADR on subset of viral sequences (with original refseqs)
2. Take sequences that passed 1st round of VADR and build profile to capture diversity in viruses that one refseq cannot capture
3. With new profile run 2nd round of VADR on the same subset of viral sequences

Pipeline details:
1. Run 1st round of VADR on subset of viral sequences (with original refseqs)

        Command: v-annotate.pl <fasta seq file> <output directory>

2. Take sequences that passed 1st round of VADR and build profile to capture diversity in viruses that one refseq cannot capture

        a. FILTER (for sequences that PASS 1st VADR run)

                Commands:

                        1. filter.sh <sqa file from 1st round of VADR> <fasta file of seqs>

                        - filters the vadr.sqa.tbl file for sequences that have PASSED
                        - creates fasta file with those sequences according to their refseq

        b. ALIGN + BUILD (align filtered sequences and refseq and build new CM)

                Commands:

                        align.sh (calls all the scripts below)

			------------------------------------------------------------------------------------------

                        1. qalign.sh
                        - Takes the fasta files from the FILTER step and uses cmalign 
			  to align the sequences to their refseq

                        2. aligmerge-list.sh
                        - creates a list of all the .stk files (created from ALIGN step 1) 
			  that need to be merged
                          for each refseq

                        3. merge.sh
                        - takes the files from ALIGN step 2, uses esl-alimerge to merge the 
		          .stk files together for each refseq

                        4. weight.sh
                        - takes the merged .stk files from ALIGN step 3 and uses esl-weight 
			  to filter sequences so no sequence is more than 95% similiar to each other

                        5. cds_start_end.py
			- extracts the start and stop position for each refseq from the .minfo files 
			- creates cds_start_end.txt file

                        6. cmalign-list.sh
			- takes the files from ALIGN step 1 and creates list of ordered cmalign files 
			  for each refseq

                        7. combined.cmalign.sh
			- extracts the start and end points of each seq from the .cmalign files f
                          or each refseq

                        8. extract_seq_cmalign.sh
			- extracts the selected sequences from .updated.stk files

                        9. filter.py
			- takes the sequences that have passed the esl-weight step and the 
			  extracted start and stop positions from each sequence from the combined.cmalign script
			  filters out sequences from esl-weight step that does not start before the first CDS position
			  and does not stop after the last position of the CDS (obtained from cds-start-end.txt) 

                        10. rm_seq_stk.sh
			- removes the sequences from the .stk files that do not exceed the start or end CDS positions

                        11. qsub.sh
			- takes the .final.stk from ALIGN step 10 and builds a new CM


3. With new profile run 2nd round of VADR on the same subset of viral sequences

        Command: v-annotate.pl -f -p -m <new CM> -i <minfo file> -b <blastx dir> <fasta sequence file> <output dir>
