#!/bin/bash

#Make a MultiQC analysis : it look at the quality of several fastq files and sum them

# Create a working directory:
data="/home/rstudio/data/mydatalocal/data"
cd $data


# Create a folder for the fastqc
mkdir -p sra_data_multiqc

multiqc $data/sra_data_quality/*.zip -o sra_data_multiqc

#lancer script avec      nohup ./MultiQC.sh >& nohup.multiqc &

