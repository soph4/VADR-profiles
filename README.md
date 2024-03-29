General Pipeline:
1. Run 1st round of VADR on subset of viral sequences (with original refseqs)
2. Take sequences that passed 1st round of VADR and build profile to capture diversity in viruses that one refseq cannot capture
3. With new profile run 2nd round of VADR on the same subset of viral sequences
4. Repeat steps 3 and 4 until the number of sequences that PASS and FAIL stop changing

Pipeline details:
1. Run 1st round of VADR on subset of viral sequences (with original refseqs)

        Command: v-annotate.pl <fasta seq file> <output directory>

2. Take sequences that passed 1st round of VADR and build profile to capture diversity in viruses that one refseq cannot capture
	- All of these scripts should be run in the same directory
	
        a. FILTER (for sequences that PASS 1st VADR run)

                Commands:

                        1. filter.sh <sqa file from 1st round of VADR> <refseq_summary file> <fasta file of seqs>

                        - filters the vadr.sqa.tbl file for sequences that have PASSED
                        - creates fasta file with those sequences according to their refseq
			- refseq_summary file: contains 2 columns (1st: refseqs, 2nd: length of refseqs)
			- output files: .fa files: fasta file with all the sequences that have passed for each refseq
				        .reverse.list.txt with a list of sequences that passed for each refseq

        b. ALIGN + BUILD (align filtered sequences and refseq and build new CM)

                Commands:

                        align.sh (calls all the scripts below)
			- currently does not work (run the steps independently)		
	
			------------------------------------------------------------------------------------------
			Sub-sccripts in the align-scripts directory

                        1. qalign.sh (takes some time to run)
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
			- the perecent similarity can be changed in the script to allow more sequences
			  in or to restrict the number of sequecnes

                        5. cds_start_end.py
			- input: concatenated file of all the refseqs .minfo files
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

			11. if any refseq gets 3 or less sequences in the .final.stk file duplicate refseq 
			    in the .final.stk file until the number of sequences reaches a total of 4. 
			    (allows the resulting ere score of the CM to be comparable to the other CMs built with a lot more sequences)

                        12. qsub.sh (takes time to run)
			- takes the .final.stk from ALIGN step 10 or 11 and builds a new CM for that refseq

			13. cat *build.out > hcv.cm
			- concatenates all the .build.out files to create one CM file
			- this is the new CM that will be used when VADR is run again

3. With new profile run 2nd round of VADR on the same subset of viral sequences

        Command: v-annotate.pl -f -p -m <new CM> -i <minfo file> -b <blastx dir> <fasta sequence file> <output dir>
