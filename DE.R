#DE analysis

#executer une ligne dans R : ctrl + entrer
#en cas de probleme : aller dans environnement (pas loin onglet Git) et faire la brosse pour nettoyer.

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
names(path_files) <- samples_table$run

tx2gene <- read.table(file = paste(dir,"/sra_data_Trinity/Trinity.fasta.gene_trans_map",sep=""),header = FALSE,sep = "\t",col.names = c("geneid","txname"))[,c(2,1)]
#on regarde début du tableau en faisant head(tx2gene)

txi <- tximport(path_files,type="salmon",tx2gene=tx2gene)
#head(txi$count) interessant a regarder

#Utilisation de DESeq
ddsTxi <- DESeqDataSetFromTximport(txi,colData = samples_table,design = ~ condition)

#on fait la somme des valeurs de chaque ligne de table de comptes et on ne garde que celles >= à 10. On enlève gènes qui ont moins de 10 reads. 
#Ce sont des gènes très faiblement exprimés. Cela permet de faire moins de test et donc moins de corrections de tests multiples.
keep <- rowSums(counts(ddsTxi)) >=10
dds <- ddsTxi[keep,]
#on indique le blanc comme ref (pareil), mais important a savoir pour interpreter resultats
dds$condition <- relevel(dds$condition, ref = "white")
#on fait tourner DESeq du tableau
dds <- DESeq(dds)
resultsNames(dds)
#on genere le tableau de resultat. 
#BaseMean : moyenne des comptes normalisés du gène sur l'échantillon. Cela représente le niveau d'expression gu gène. Un basemean élévé = un gène fortement exprimé donc bcp de signal
#log2FoldChange : condition traitement (peau orange)/condition controle (blanc). Foldchange de 2 : expression 2x plus grande dans orange, et de 0.5 si 2x plus grande dans blanc. S'il vaut 1, l'expression est la meme. On passe cette valeur en log2 pour avoir quelque chose de symetrique. Si FC est de 1, log2FC est 0. Gene surexprimes >0, sous exprime <0, et la c'est symetrique ! FC augmente 1, log2Fc multiplie par 2
#stat : statistique du test. pvalue=pvalue du test. padj = pvalue corrigée avec FDR.
#pvalue : H0 (hyp absence effet cad gene pas differentielmt exprimé dans 2 conditions), alpha = seuil pour rejetter H0 (en general 5%). pvalue = proba de rejetter hyp nulle alors qu'elle est vraie. Plus pvalue est faible et plus on est confiant. On voit que gene avec pvalue faible on un log2FC different de 0

#on choisit une de ces 2 sentences selon ce qui est indiqué dans les commentaires en dessous
resLFC <- results(dds)
resLFC <- lfcShrink(dds, coef="condition_orange_vs_white", type = "apeglm")

library(ggplot2)
#on fait un plot de resFLC (qu'on convetit en data.frame), mapping donne ce qu'on veut sur quel axe, geom donne ce qu'on veut comme format de resultats (histogrammes, point,...)
ggplot(data = as.data.frame(resLFC),mapping = aes(x=log10(baseMean),y = log2FoldChange,color=padj<0.05,size=padj<0.05,shape=padj<0.05,alpha=padj<0.05,fill=padj<0.05)) + geom_point() +  scale_color_manual(values=c("#FF1EBB","#F3FE08")) + scale_size_manual(values = c(0.1,1)) + scale_alpha_manual(values = c(0.5,1)) + scale_shape_manual(values = c(21,21)) + scale_fill_manual(values=c("#35EF45","#4D4FE7")) + theme_bw() + theme(legend.position = 'none')
#pb : on a une relation entre baseMean et log2FC. Les genes avec une faible expression ont un Log2FC eleve. On utilise donc lfcshrink
#on change couleur pour bien distinguer quand pvalue<0.05 (site pour code : colourco.de)
#Resultat bizarre : possibilité est que k est plus bas donc il y'a plus de faux positifs. 
#avec dim(resLFC[is.na(resLFC$padj),]), on voit que ce sont probablement des genes avec padj = NA

#volcanoplot  -> plus un gène est haut = plus il est signif = plus pval est basse
ggplot(data = as.data.frame(resLFC),mapping = aes(x=resLFC$log2FoldChange, y=-log10(padj),color=padj<0.05,size=padj<0.05,shape=padj<0.05,alpha=padj<0.05,fill=padj<0.05)) + geom_point() +  scale_color_manual(values=c("#A413E8","#000FFF")) + scale_size_manual(values = c(0.1,1)) + scale_alpha_manual(values = c(0.5,1)) + scale_shape_manual(values = c(21,21)) + scale_fill_manual(values=c("#000000","#000FFF")) + theme_bw() + theme(legend.position = 'none')

#on peut utiliser ligne suivante pour trier tableau en fonction de baseMean et trouver les genes les plus et les moins exprimés
resLFC_sort=resLFC[order(resLFC$baseMean),]
#On supprime les NAs pour la commande suivante
resLFC[is.na(resLFC$pvalue),"pvalue"] <- 1
resLFC[is.na(resLFC$padj),"padj"] <- 1
top_DE_genes <- resLFC[resLFC$padj<1e-2& abs(resLFC$log2FoldChange)>2,]
top_DE_genes <- top_DE_genes[order(top_DE_genes$padj),]
print(top_DE_genes[0:10,])
