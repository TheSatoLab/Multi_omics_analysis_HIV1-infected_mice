#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)

combined <- readRDS(args[1])
combined$cluster_sampletype <- paste(combined$seurat_clusters,combined$sample_type.new,sep="__")

pn <- subset(combined,subset= sample_type.new != "Mock")
mt <- pn@meta.data

t <- data.frame(matrix(rep(NA, (9 * 2)),nrow=9))
colnames(t) <- c("cluster","p_value")
rownames(t) <- as.character(1:9)
t$cluster <- as.character(1:9)
for (i in as.character(1:9)) {
  mti <- mt[mt$seurat_clusters == i,]
  mto <- mt[mt$seurat_clusters != i,]
  a <- as.numeric(mti$commonISG)
  b <- as.numeric(mto$commonISG)
  res <- wilcox.test(a,b,alternative="less")
  t[i,"p_value"] <- res$p.value
}
t$padj <- p.adjust(t$p_value, method="BH")
t$log10P <- round(log10(t$p_value),3)
t$log10Padj <- round(log10(t$padj),3)
write.table(t,args[4],sep="\t",quote=F,row.names=F)




