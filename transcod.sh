#! /bin/bash

#Make a transcoder to annotate the genes of the studied specie with a reference one (Stegastes partitus)


# Create a working directory:
data="/home/rstudio/data/mydatalocal/data"
cd $data

mkdir -p data_transdecoder
cd data_transdecoder

mkdir -p data_transdecoder_files

# Step 1: extract the long open reading frames. Cherche les codons start et stop et fait des cds.
#On peut avoir pleins de cds pour un gene.  Lequel on garde ?
TransDecoder.LongOrfs -t $data/sra_data_Trinity/Trinity.fasta --gene_trans_map $data/sra_data_Trinity/Trinity.fasta.gene_trans_map -m 100 -S -O data_transdecoder_files

# Step 2: (facultative) identify ORFs with homology to known proteins via blast or pfam searches. 
#Fais des annotations des cds trouvés avec des alignements avec des bases de donées

# Step 3: predict the likely coding regions. tri pour dire quel cds on garde ou non. 
#Si on ne fait pas l'étape 2, cet étape se base seulement sur la longeur des cds. Ici on va garder le plus long
#On est pas sur que c'est bon mais c'est le mieux. Avec un alignement ca aurait été top.
TransDecoder.Predict -t $data/sra_data_Trinity/Trinity.fasta --single_best_only --cpu 14 -O data_transdecoder_files



#launch script with      nohup ./transcod.sh >& nohup.transcod &