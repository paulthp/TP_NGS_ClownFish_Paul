#!/bin/bash

#Make a trinity on the fastq data to assemble the reads
  

# Create a working directory:
data="/home/rstudio/data/mydatalocal/data"
cd $data


#Launch the Trinity process. 
#| = on prend le resultat et on l'envoie dans la suite
#avec paste on colle les noms en les séparant avec une virgule (besoin pour trinity)
FASTQ=$(ls $data/sar_data/*.fastq |paste -s -d, -)
echo $FASTQ

#Trinity --seqType fq --max_memory 50G --single FASTQ --SS_lib_type R --output sra_data_Trinity --CPU 14 --normalize_by_read_set


# Remove length and path in sequence names to avoid bug with blast ( sequence name length > 1000)
#sed -re "s/(>[_a-zA-Z0-9]*)( len=[0-9]*)( path=.*)/\1/"



#launch script with      nohup ./MultiQC.sh >& nohup.Trinity &
