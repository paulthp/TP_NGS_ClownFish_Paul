#! /bin/bash

# Create a working directory:
data="/home/rstudio/data/mydatalocal/data"
data_reference="$data/data_reference"
data_blast="$data/data_blast"
data_Trinity="$data/sra_data_Trinity"
out_blast="$data/data_blast/out_blast"
db="$data_blast/Spartitus_db"
data_transdecoder="$data/data_transdecoder"

mkdir -p $db
mkdir -p $data_blast
mkdir -p $out_blast

cd $data_blast

#identify with the reference species the genes corresponding to the transcripts obtained.
#Trinity file was modified with : awk '{print $1}' Trinity.fasta.transdecoder.cds > Trinity.fasta.transdecoder.rename.cds

#build reference database. Change our data to allow blast to be performed on them.
makeblastdb -dbtype nucl -in $data_reference/spartitus_coding_format.fa -out $db

#blast transdecoder data against the ref db. (-evalue determine the threshold to control the hits/false positive rate)
blastn -db $db -query $data_transdecoder/Trinity.fasta.transdecoder.rename.cds -evalue 1e-20 -outfmt 6 -out $out_blast/blast_file


#determine the number of sequences that have been aligned: cut -f1 blast_file |sort |uniq |wc -l  __ we found 25.000 (count the word number in the first column).
#launch script with      nohup ./blast.sh >& nohup.blast &

