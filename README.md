#VADR-profiles

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

        b. ALIGN (filtered sequences and refseq to each other)

                Commands:

                        1. qalign.sh
                        - Takes the fasta files from the FILTER step and uses cmalign to align the sequences to their refseq

                        2. aligmerge-list.sh
                        - creates a list of all the .stk files (created from ALIGN step 1) that need to be merged 
                          for each refseq

                        3. merge.sh
                        - takes the files from ALIGN step 2, uses esl-alimerge to merge the .stk files together for each refseq

                        4. weight.sh
                        - takes the merged .stk files from ALIGN step 3 and uses esl-weight to filter sequences 
                          so no sequence is more than 95% similiar to each other

                        5.

        c. BUILD CM

                Commnads:


3. With new profile run 2nd round of VADR on the same subset of viral sequences

        Command: v-annotate.pl -f -p -m <new CM> -i <minfo file> -b <blastx dir> <fasta sequence file> <output dir>
