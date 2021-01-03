library("tximport")
library("readr")
library(apeglm)
library("DESeq2",quietly = T)

#Import the data
#Create a table containing the conditions (name of the runs and color of the skin analyzed)
dir <- '/home/rstudio/data/mydatalocal/data'
samp.name <- c("SRR7591064","SRR7591065","SRR7591066","SRR7591067","SRR7591068","SRR7591069")
samp.color <- c("orange", "white", "orange", "orange", "white", "white")
samples <- data.frame(run=samp.name, condition=samp.color)

#Create a variable containing the path to each quant.sf file
files <- file.path(dir, "data_salmon",samples$run, "quant.sf")
names(files) <- samples$run

#Create a table containing col1=gene, col2=transcript
tx2gene <- read.table(file=paste(dir,"/sra_data_Trinity/Trinity.fasta.gene_trans_map", sep=""),
                      header=FALSE,sep="\t",col.names=c("geneid", "transcript_name"))[,c(2,1)]

#tximport
txi <- tximport(files, type="salmon",tx2gene=tx2gene)

#DE
ddsTxi <- DESeqDataSetFromTximport(txi, colData=samples, design= ~ condition)

#Keep only expressed genes
keep <- rowSums(counts(ddsTxi)) >= 10
dds <- ddsTxi[keep,]

#Decide which condition is the reference 
dds$condition <- relevel(dds$condition, ref= "white")

#Run DESeq
dds <- DESeq(dds)
resultsNames(dds)

#Create a MA plot
res <- results(dds)

library(ggplot2)
ggplot(data=as.data.frame(res), mapping=aes(x=log10(baseMean),y=log2FoldChange)) + 
  geom_point() + theme_bw()

#Create a MA_plot_shrinked and take into account the relation between fold change and baseMean
resLFC<-lfcShrink(dds, coef = "condition_orange_vs_white", type = "apeglm")
maplot <- ggplot(data = as.data.frame(resLFC), mapping=aes(x=log10(baseMean),
                                                           y=log2FoldChange, 
                                                           color=padj<1e-20,
                                                           size=padj<1e-20, 
                                                           shape=padj<1e-20,
                                                           alpha=padj<1e-20,
                                                           fill=padj<1e-20,)) + 
  geom_point() + 
  scale_color_manual(values=c("#999999","#FF6600")) +
  scale_size_manual(values=c(0.1,1)) +
  scale_alpha_manual(values=c(0.5,1)) +
  scale_shape_manual(values=c(21,21)) +
  scale_fill_manual(values=c("#999999","#000000")) +
  theme_bw() + theme(legend.position = 'none')

#Volcano plot
volcano_plot <- ggplot(data=as.data.frame(resLFC), mapping=aes(x=log2FoldChange,y=-log10(padj),
                                                               color=padj<1e-20, 
                                                               alpha=padj<1e-20)) + 
  geom_point() + 
  scale_color_manual(values=c("#000000", "#FF6600")) +
  scale_alpha_manual(values=c(0.5, 1)) +
  theme(legend.position = 'none') +
  theme_bw()

#Sortir les gènes différentiellement exprimés 
resLFC[is.na(resLFC$pvalue),"pvalue"] <- 1
resLFC[is.na(resLFC$padj),"padj"] <- 1
top_DE_genes <- resLFC[resLFC$padj<1e-20 & abs(resLFC$log2FoldChange)>2,]

top_DE_neg <- top_DE_genes[top_DE_genes$log2FoldChange<0,] #14 genes
top_DE_pos <- top_DE_genes[top_DE_genes$log2FoldChange>0,] #16 genes

top_sorted_DE_neg <- top_DE_neg[order(top_DE_neg$padj),]
top_sorted_DE_pos <- top_DE_pos[order(top_DE_pos$padj),]


#Plot PCA
rld <- rlog(dds, blind=FALSE)
plotPCA(rld, intgroup=c("condition")) + 
  theme_bw()

