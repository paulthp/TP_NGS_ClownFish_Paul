# TP NGS ClownFish

------------------------------------------------

![screenshot](poisson_clown.jpg)

## Titre
### Sous titre
*Italic*  
_Italic_  
**bold**  
**_italic bold_**


## Objective

Actinopterygien fishes present a high diversity of pigmentation with more than 8 various cells from the scales. To undesrtand the causes of this diveristy, the clownfish, whci harbor white bars over a darker orange body is an interesting model. By electron microscopy, cells from these white bars appeared to be similar to iridophores which make a reflective scales as it can be found in Zebrafishes. Other cells called leucophores could be responsible of the white pigmentation.  
We wonder then if the white bars are composed of iridophores, leucophores or both. To this purpose, transcriptomic analyses of white and orange scales where performed on 3 organisms and data were collected to compare transcriptomes. 


## Dataset, paper of interest

The reads are available on NCBI SRA dataset, under BioProject PRJNA482393 and BioProject PRJNA482578. Reads are found in 6 files, from SRR7591064 to SRR7591069.

## Workflow

There are several steps to complete this study. The reads are download from the NCBI. They are 50 nucleotides length. First we determine there quality to know the validity of the study performed. Then the qua

### Download the data

* **_Download.sh_**  
Download the reads for the study. 

For each file, a *fastq-dump* has been performed to download the data as fastq files
Using awk, sequence names has been renamed (trinity need that their name ends with "/1" for R1 and "/2" for R2)

```awk  '{ if (NR%2 == 1 ) {gsub("\\.","_");print $1"/1"}  else  { print $0}}' $A.fastq > $A.fastq.modif mv $A.fastq.modif $A.fastq```

----------------
Exemple of fastq file: (line 4 corresponds to the quality sequence)  

    @SRR7591064_1/1
    NGCACACAGAGCTCCAACCAAAATGATAATGCCACCTGCCATGGCAATGC
    +SRR7591064_1/1
    #AAFFJJJJJJJJAJJAFJFJFFFFAJJJFJJJJJJ-AJ<JJJJFJJJJ<
    @SRR7591064_2/1
    NTTCACAAGTTATTGTTAAATTAAGACACGCTTTATAACATCTGACCACC
    +SRR7591064_2/1
    #AAAFJJJJJJJJJJJ-FJJ-FJFJJFJ7-A<FJJJJJJJJ-<A-F-FFJ

----------------



### Determine the quality of the reads

**_FastQC.sh_**  
Create an HTML file for each file of reads with the quality of sequences

Here is an exemple of a fastqc result obtained with our data. The quality was good enough, considering that a high duplication level is normal in RNAseq, and the Per "Base Sequence Content" is caused by a common problem of the primers synthesis.

![legende](images/fastqc_exemple.jpg)


**_MultiQC.sh_**  
Create one HTML file with the summary of the quality of all the files. The same results than fastqc are obtained but with all the different files represented on the different graphs. It is usefull to detect an eventual issue when many files are used. 

### Quantify the expression of the transcripts 

**_Trinity.sh_**  
![legende](images/trinity2.jpg)

Assemble the reads of sequencing

----------------

Exemple of a transcript obtained with Trinity

    TRINITY_DN18_c0_g1_i1 len=919 path=[0:0-918]
    GTGAGGCTGAGTGGAGTCTGCAGGGCGCACCGATGCCCGACAGCCTGGACTGGAAGGCCGTGTATGAAGCCAGGCCGCTGGGAAGAAACTTACTGAAGAACCCCGCACCTCACGGGTTGAGTAAAGATGTTCCTCCACCTGAACCCGAGCTGGCTCAAGTGCTCACACGTGGACCTCCACGTTTTCAGCCTGATGGTGACTTCACCGGCTGGACCACGAGCATAGAAGTCCTGCCCTATGATGACAGTGGCATCCCAGAAGGTGCTGTGGTCTGTGCTTTGCCTACATATAGCTGGTTCACTATGGAGCAGGTTGTGGACCTGAAGGCAGAGGGACTGTGGGACGAGCTGCTGGATGCTTTTCAGCCTGAAATAGTCATCCAAGACTGGTATGAGGAGAGTCAGCTGCATAAATCCATCTACCAGCTGCATGTGAAGTTACTGGGTGCGGACAAAAGCACGGTGATCTCAGAGCACTCTGTCAGCCCCACTGAGGAGCTCAGCGTTTACTCACACAACTGGAAGGAGGTGTCGCATGTGTTCTCCGGCTATGGACCCGGGGTCAGATATGTCCACTTCGTTCACCGACTGAAGAACAGTTTCCTGAATGGGTTCTTTCCCACGCTGTTCACCGGCAGCTCAGTGATTGTGAAACCAATCAAAACCAGCCCATAGGACAAATCCTGCCATGCACGTGTAGCTGCTCATATACCCAACCAGTTTTATCAGCCAGTTTGGTCTTTAGGCTGGCAACTGAAAAGAACGTAACAGTCTTTTTATTGACTAGTTTTGATTTGTTTGTCGGAGTTGATTTTTGCAATAGCTTTTGAGATATTTTTCAAATAAGGTCAAACTTCGTTGTCTTCTGAGGGTTGCTGTGTGGTGCAATAATAAAAAATACAGTTCACATAAAAAAAAAA

----------------

**_Salmon.sh_**  
![legende](images/salmon2.jpg)

quantify the expression of the transcripts. This script takes the transcripts from Trinity and makes first an index. Then it uses this index to quantify for each transcript the number of associated reads. 
One important parameter to choose in the "salmon index" is the k, to indicate the sensibility of alignement between the reads and the transcripts.

Mapping percentage ?


```
salmon index -k 25 -t $data/sra_data_Trinity/Trinity.fasta -i $data/sra_data_Trinity/trinity_index
salmon quant -l SR --validateMappings --gcBias -p 16 -i $data/sra_data_Trinity/trinity_index -o data_salmon/$Name -r $A
```

Importance of k !
Nohup informations ?

----------------

Exemple of results obtained with salmon. The first column indicates the name of a transcript assemble by Trinity, and the last column the number of reads associated with it.

             Name          Length   EffectiveLength      TPM         NumReads
    TRINITY_DN92_c0_g1_i3   1670      1338.838        0.000000        0.000
    TRINITY_DN32_c0_g1_i4   1927      1787.007        0.000000        0.000
    TRINITY_DN32_c0_g1_i5   2277      2112.714        8.443555        2501.624
    TRINITY_DN32_c0_g1_i6   1927      1788.113        14.277959       3580.280
    TRINITY_DN32_c0_g1_i7   2277      2111.608        0.000000        0.000
    TRINITY_DN32_c0_g1_i1   1255      1080.733        4.774877        723.663
    TRINITY_DN32_c0_g1_i2   1802      1672.297        0.000000        0.000
    TRINITY_DN32_c0_g1_i3   1802      1682.080        3.596785        848.432

----------------

**_reference.sh_**  
Download the genes of the reference species (stegastes partitus)

![legende](images/reference_joke.jpg)

```wget -O data_reference/spartitus_coding.fa.gz http://ftp.ensembl.org/pub/release-102/fasta/stegastes_partitus/cds/Stegastes_partitus.Stegastes_partitus-1.0.2.cds.all.fa.gz```

Then the name was change to make it more clear with a complicated script, parse.awk

----------------

Exemple of data obtained with reference.sh

    ENSSPAT00000000002.1 cds primary_assembly:Stegastes_partitus-1.0.2:KK580071.1:9353:21963:-1 gene:ENSSPAG00000000002.1 gene_biotype:protein_coding transcript_biotype:protein_coding gene_symbol:homer3a description:homer protein homolog 3-like [Source:NCBI gene;Acc:103352799]
    ATGGGATGTCAGCCGATCTTCAGCGCCCGGGCCCACGTCTTCCAGATCGACCCCAACACC
    AAGAGGAACTGGATCCCTGCCAGTAAACATGCCGTCACCGTGTCCTTCTTCTACGATGCC
    AATCGCAACGTGTATCGCATCATCAGCGTGGGCGGGACCAAGGCGATCATCAACTGCACC


Same exemple of data renamed with with reference.sh

    ENSSPAG00000000002.1|homer3a
    ATGGGATGTCAGCCGATCTTCAGCGCCCGGGCCCACGTCTTCCAGATCGACCCCAACACC
    AAGAGGAACTGGATCCCTGCCAGTAAACATGCCGTCACCGTGTCCTTCTTCTACGATGCC
    AATCGCAACGTGTATCGCATCATCAGCGTGGGCGGGACCAAGGCGATCATCAACTGCACC

---------------


**_transcod.sh_**  
prepare the genes of the studied species to be able to annotate them with a reference species 


## Commands

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







