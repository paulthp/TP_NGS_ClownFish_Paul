# TP NGS ClownFish

## Titre
### Sous titre
*Italique*
_Italique_
**test**

Readme du projet NGS


_Download.sh_
&nbsp;Download the reads for the study

_FastQC.sh_
&nbsp;Create an HTML file for each file of reads with the quality of sequences

_MultiQC.sh_
&nbsp;Create one HTML file with the summary of the quality of all the files

_Trinity.sh_
&nbsp;Assemble the reads of sequencing

_Salmon.sh_
quantify the expression of the transcripts


###Commands
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









