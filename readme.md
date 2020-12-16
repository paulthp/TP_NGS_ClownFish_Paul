# TP NGS ClownFish

## Titre
### Sous titre
*Italic*
_Italic_
**bold**

Readme du projet NGS

## Objective


## Dataset, paper of interest

The reads are available on NCBI SRA dataset, under BioProject PRJNA482393 and BioProject PRJNA482578. 

## Process with Rscript

There are several steps to complete this study. The reads are download from the NCBI. They are 50 nucleotides length. First we determine there quality to know the validity of the study performed. Then the qua

# Download the data

_Download.sh_
Download the reads for the study. 

# Determine the quality of the reads

_FastQC.sh_
Create an HTML file for each file of reads with the quality of sequences

_MultiQC.sh_
Create one HTML file with the summary of the quality of all the files

# Quantify the expression of the transcripts 

_Trinity.sh_
Assemble the reads of sequencing

_Salmon.sh_
quantify the expression of the transcripts. This script uses the reads and the 

_reference.sh_
Download the genes of the reference species (stegastes partitus)
https://reefguide.org/pix/bicolordamsel5.jpg

_transcod.sh_
prepare the genes of the studied species to be able to annotate them with a reference species 


### Commands

_cd_ go in a specific folder
_mkdir folder_ create a folder (mkdir -p folder to avoid to create again a folder which already exists) 
_cat_ open a file (ONLY little files)
_less_ open a file (better), use :q to quit

_$file/folder_ $ is use when we want to do something from a variable or a file (cd $data ...)
_var=$folder/*.fastq_ make a list with all the .fastq files of the folder

_chmod +x script.sh_ give the right to use a script 
_nohup ./script.sh >& nohup.script &_ run a script and put the informations in a file nohup.script

_htop_ have a look at the current processes (precise)
_ps_ have a look at the current processes (not precise)

_grep "Mapping rate" nohup.salmon_ find the sentences with "Mapping rate" in the file nohup.salmon







