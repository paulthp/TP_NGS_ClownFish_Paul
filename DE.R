#DE analysis

#executer une ligne dans R : ctrl + entrer

#Libraries
library("tximport")
library("readr")
library(apeglm)
library("DESeq2",quietly = T)

dir <- "/home/rstudio/data/mydatalocal/data"

#On construit un tableau sample avec le nom de chaque échantillon et leur condition

samp.name <- c("SRR7591064","SRR7591065","SRR7591066","SRR7591067","SRR7591068","SRR7591069")
samp.type <- c ("orange","white","orange","white","orange","white")
#verifier que ca correspond pour les couleurs
samples_table <- data.frame(run=samp.name,condition=samp.type)

#on recupere fichiers dans salmon. On cree une variable ou on met la localisation de chaque sortie de salmon
#on aurait pu ecrire a la main commme dans samp.name
#samples_table$run : donne colonne run dans le tableau samples_table
path_files <- file.path(dir,"data_salmon", samples_table$run, "quant.sf")
#on nomme chaque fichier stocké dans files
names(path_files) <- samples$run

tx2gene <- read.table(file = paste(dir,"/sra_data_Trinity/Trinity.fasta.gene_trans_map",sep=""),header = FALSE,sep = "\t",col.names = c("geneid","txname"))[,c(2,1)]
#on regarde début du tableau en faisant head(tx2gene)

txi <- tximport(path_files,type="salmon",tx2gene=tx2gene)
#head(txi$count) interessant a regarder

#Utilisation de DESeq
ddsTxi <- DESeqDataSetFromTximport(txi,colData = samples,design = ~ condition)

#on fait la somme des valeurs de chaque ligne de table de comptes et on ne garde que celles >= à 10. On enlève gènes qui ont moins de 10 reads. 
#Ce sont des gènes très faiblement exprimés. Cela permet de faire moins de test et donc moins de corrections de tests multiples.
keep <- rowSums(counts(ddsTxi)) >=10
dds <- ddsTxi[keep,]
#on indique le blanc comme ref (pareil), mais important a savoir pour interpreter resultats
dds$condition <- relevel(dds$condition, ref = "white")
#on fait tourner DESeq du tableau
dds <- DESeq(dds)
resultsNames(dds)
