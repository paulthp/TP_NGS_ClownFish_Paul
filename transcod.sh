#! /bin/bash

#Make a transcoder to annotate the genes of the studied specie with a reference one (Stegastes partitus)


# Create a working directory:
data="/home/rstudio/data/mydatalocal/data"
cd $data

mkdir -p data_transdecoder
cd data_transdecoder

mkdir -p data_transdecoder_files

# Step 1: extract the long open reading frames. We look for the start and stop codons. Then we potentially find several cds (coding sequences) for one gene.
TransDecoder.LongOrfs -t $data/sra_data_Trinity/Trinity.fasta --gene_trans_map $data/sra_data_Trinity/Trinity.fasta.gene_trans_map -m 100 -S -O data_transdecoder_files

# Step 2: (facultative) identify ORFs with homology to known proteins via blast or pfam searches. 
# It is used to decide then which cds to keep or not. 

# Step 3: predict the likely coding regions. Sort to find which cds we keep, here we keep the longer cds which is the most likely to be the good one.
TransDecoder.Predict -t $data/sra_data_Trinity/Trinity.fasta --single_best_only --cpu 14 -O data_transdecoder_files



#launch script with      nohup ./transcod.sh >& nohup.transcod &