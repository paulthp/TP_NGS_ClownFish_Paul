#DE analysis

#THIS SCRIPT IS NOT WORKING -----> SEE DE2.R !


#execute a line: CTRL + enter 
#en cas de probleme : aller dans environnement (à côté onglet Git) et faire la brosse pour nettoyer.

#Libraries
library("tximport")
library("readr")
library(apeglm)
library("DESeq2",quietly = T)

dir <- "/home/rstudio/data/mydatalocal/data"

#We build a sample table with the name and the condition of each sample (color of the skin).
samp.name <- c("SRR7591064","SRR7591065","SRR7591066","SRR7591067","SRR7591068","SRR7591069")
samp.type <- c ("orange","white","orange","white","orange","white")
samples_table <- data.frame(run=samp.name,condition=samp.type)

#We take the data from salmon.
#We put in a variable the localisation of each salmon output.
path_files <- file.path(dir,"data_salmon", samples_table$run, "quant.sf")
#We rename the files obtained
names(path_files) <- samples_table$run

#we import the transcripts identities from the Trinity trans_map
tx2gene <- read.table(file = paste(dir,"/sra_data_Trinity/Trinity.fasta.gene_trans_map",sep=""),header = FALSE,sep = "\t",col.names = c("geneid","txname"))[,c(2,1)]
#We import salmon data of quantification with the identity of the transcripts
txi <- tximport(path_files,type="salmon",tx2gene=tx2gene)


#DESeq
ddsTxi <- DESeqDataSetFromTximport(txi,colData = samples_table,design = ~ condition)

#We do the sum of each lines and we keep only when the genes with more that 10 reads (to do much less tests of correlations)
keep <- rowSums(counts(ddsTxi)) >=10
dds <- ddsTxi[keep,]
#We put the white as reference (doesn't matter)
dds$condition <- relevel(dds$condition, ref = "white")
dds <- DESeq(dds)
resultsNames(dds)

#We obtain the table of results by using one of the next two sentences
resLFC <- results(dds)
resLFC <- lfcShrink(dds, coef="condition_orange_vs_white", type = "apeglm")
#BaseMean: gene expression level. A high BaseMean correspond to a high expressed gene.
#log2FoldChange: compare the treatment (white) to the control. (FC=1: same expression / FC=2: 2x more in the treatment / FC=0.5: 2x more in the control). We take a log2 to have a symetrical parameter (log2FC>0: overexpression with the treatment)
#stat: test statistic. padj = pvalue adjusted with FDR.


library(ggplot2)
#we do a plot of resFLC (by converting in data.frame). (mapping def the axes, and geom the type of plot). We put another color when pvalue<0.05.
ggplot(data = as.data.frame(resLFC),mapping = aes(x=log10(baseMean),y = log2FoldChange,color=padj<0.05,size=padj<0.05,shape=padj<0.05,alpha=padj<0.05,fill=padj<0.05)) + geom_point() +  scale_color_manual(values=c("#FF1EBB","#F3FE08")) + scale_size_manual(values = c(0.1,1)) + scale_alpha_manual(values = c(0.5,1)) + scale_shape_manual(values = c(21,21)) + scale_fill_manual(values=c("#35EF45","#4D4FE7")) + theme_bw() + theme(legend.position = 'none')
#pb : on a une relation entre baseMean et log2FC. Les genes avec une faible expression ont un Log2FC eleve. On utilise donc lfcshrink
#on change couleur pour bien distinguer quand pvalue<0.05 (site pour code : colourco.de)
#Resultat bizarre : possibilité est que k est plus bas donc il y'a plus de faux positifs. 
#avec dim(resLFC[is.na(resLFC$padj),]), on voit que ce sont probablement des genes avec padj = NA

#volcanoplot  -> plus un gène est haut = plus il est signif = plus pval est basse
ggplot(data = as.data.frame(resLFC),mapping = aes(x=resLFC$log2FoldChange, y=-log10(padj),color=padj<0.05,size=padj<0.05,shape=padj<0.05,alpha=padj<0.05,fill=padj<0.05)) + geom_point() +  scale_color_manual(values=c("#A413E8","#000FFF")) + scale_size_manual(values = c(0.1,1)) + scale_alpha_manual(values = c(0.5,1)) + scale_shape_manual(values = c(21,21)) + scale_fill_manual(values=c("#000000","#000FFF")) + theme_bw() + theme(legend.position = 'none')

#Sort the table with BaseMEan to find the most and less expressed genes 
resLFC_sort=resLFC[order(resLFC$baseMean),]
#We delete the NA to execute the following command
resLFC[is.na(resLFC$pvalue),"pvalue"] <- 1
resLFC[is.na(resLFC$padj),"padj"] <- 1
top_DE_genes <- resLFC[resLFC$padj<1e-2& abs(resLFC$log2FoldChange)>2,]
top_DE_genes <- top_DE_genes[order(top_DE_genes$padj),]
print(top_DE_genes[0:10,])
