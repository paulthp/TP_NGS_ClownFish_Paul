#!/bin/bash

#Make a trinity on the fastq data to assemble the reads
  

# Create a working directory:
data="/home/rstudio/data/mydatalocal/data"
cd $data


#Launch the Trinity process. 
#| = take the result and put it in the next of the sentence  / Paste : we separate the name just with a "," (needed for Trinity)

mkdir -p sra_data_Trinity

FASTQ=$(ls $data/sra_data/*.fastq |paste -s -d, -)

Trinity --seqType fq --max_memory 50G --single $FASTQ --SS_lib_type R --output sra_data_Trinity --CPU 14 --normalize_by_read_set


# Remove length and path in sequence names to avoid bug with blast ( sequence name length > 1000)
#sed -re "s/(>[_a-zA-Z0-9]*)( len=[0-9]*)( path=.*)/\1/"



#launch script with      nohup ./Trinity.sh >& nohup.Trinity &
