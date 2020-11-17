#!/bin/bash
 
#This script control the quality of fastqc data

# Create a working directory:
data="/home/rstudio/data/mydatalocal/data"
mkdir -p $data
cd $data


# Create a folder for the fastqc
mkdir -p sra_data_quality


# Create a loop, for each fastq file we do a fastqc to access to the quality of the read
# and put it in mydatalocal/data/sra_data_quality

sra_data="/home/rstudio/data/mydatalocal/data/sra_data"
fastq=$sra_data/*.fastq

for A in $fastq
do

fastqc -o sra_data_quality -t 16 $A

done

#lancer script avec      nohup ./FastQC.sh >& nohup.fastqc &
# suivre progression        tail -f nohup.fastqc