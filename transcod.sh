#! /bin/bash

#Make a transcoder to annotate the genes of the studied specie with a reference one (Stegastes partitus)


# Create a working directory:
data="/home/rstudio/data/mydatalocal/data"
cd $data

mkdir -p data_transcod

# Step 1: extract the long open reading frames
TransDecoder.LongOrfs -t $data/sra_data_Trinity/Trinity.fasta -m ???

# Step 2: (facultative) identify ORFs with homology to known proteins via blast or pfam searches.

# Step 3: predict the likely coding regions
TransDecoder.Predict -t $data/sra_data_Trinity/Trinity.fasta [ homology options ] --output_dir $data/data_transcod



#launch script with      nohup ./transcod.sh >& nohup.transcod &