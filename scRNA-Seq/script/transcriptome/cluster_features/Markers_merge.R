#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
library(reshape2)

combined <- readRDS(args[1])
mt <- combined@meta.data
cluster.df <- as.data.frame(t(as.matrix(apply(combined@assays$integrated@data,1,tapply,mt$seurat_clusters,mean))))
cluster.df <- cluster.df[rownames(cluster.df) != "NLCSFV3-EGFP",]
cluster.df.s <- as.data.frame(t(as.data.frame(apply(cluster.df,1,scale))))
colnames(cluster.df.s) <- as.character(1:9)
cluster.df <- cluster.df.s
cluster.df$gene <- rownames(cluster.df)
cluster.df$cluster <- NA
out <- cluster.df[NULL,]
for (i in as.character(1:9)) {
  cm <- read.table(paste(args[2],i,".txt",sep=""),sep="\t",header=T,check.names=F)
  am <- read.table(paste(args[3],i,".txt",sep=""),sep="\t",header=T,check.names=F)
  ms <- merge(cm,am,by="gene")
  ms.f <- ms[order(abs(ms$avg_logFC),decreasing=T),]
  cluster.df.f <- cluster.df[cluster.df$gene %in% ms.f$gene,]
  cluster.df.f$cluster <- i
  cluster.df.f <- cluster.df.f[order(cluster.df.f[,i],decreasing=T),]
  out <- rbind(out,cluster.df.f)
}
rownames(out) <- 1:nrow(out)
out2 <- out[,c(11,10,1,2,3,4,5,6,7,8,9)]
write.table(out2,args[4],quote=F,sep="\t",row.names=F)

