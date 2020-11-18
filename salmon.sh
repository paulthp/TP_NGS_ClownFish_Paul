#!/bin/bash

#Make a salmon to quantify the expression of the transcripts


# Create a working directory:
data="/home/rstudio/data/mydatalocal/data"
cd $data

mkdir -p data_salmon

# Index the transcriptome
salmon index -k 25 -t $data/sra_data_Trinity/Trinity.fasta -i $data/data_salmon/trinity_index

# Quantification
# Dans Name on met le nom des variables sans .fastq pour pouvoir créer un dossier à chaque boucle du nom du fichier sans fastq (pas beau)
# Pour éviter que a chaque boucle on remplace les données d'avant
#-p numbre of threads = nombre de coeurs (pour l'ordinateur)

fastq=$(ls $data/sra_data/*.fastq)
echo $fastq
for A in $fastq
do

Name=$(basename -s .fastq $A)
salmon quant -l SR --validateMappings --gcBias -p 16 -i $data/sra_data_Trinity/trinity_index \
-o data_salmon/$Name -r $A

done

#launch script with      nohup ./salmon.sh >& nohup.salmon &