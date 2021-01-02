#!/bin/bash

#Make a salmon to quantify the expression of the transcripts


# Create a working directory:
data="/home/rstudio/data/mydatalocal/data"
cd $data

mkdir -p data_salmon

# Index the transcriptome
salmon index -k 25 -t $data/sra_data_Trinity/Trinity.fasta -i $data/sra_data_Trinity/trinity_index

# Quantification
# In name we create a folder to avoid replacing the data in the file every loop. 
#-p numbre of threads = hearth number of the computer

fastq=$(ls $data/sra_data/*.fastq)

for A in $fastq
do

Name=$(basename -s .fastq $A)
salmon quant -l SR --validateMappings --gcBias -p 16 -i $data/sra_data_Trinity/trinity_index \
-o data_salmon/$Name -r $A

done

#open quant.sf with less to see the results of salmon
#grep "Mapping rate" nohup.salmon     to find the % of mapping in a doc.
#launch script with      nohup ./salmon.sh >& nohup.salmon &