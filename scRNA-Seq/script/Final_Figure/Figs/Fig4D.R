#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
library(ggplot2)
library(ggrepel)

combined <- readRDS(args[1])
combined$HIV <- combined@assays$integrated@scale.data["NLCSFV3-EGFP",]
GFPposi <- subset(combined,subset=sample_type.new=="GFPposi")
GFPnega <- subset(combined,subset=sample_type.new=="GFPnega")
pn <- rbind(table(GFPposi$seurat_clusters),table(GFPnega$seurat_clusters))
rownames(pn) <- c("GFPposi","GFPnega")
for (i in 1:9) pn[,i] <- pn[,i]/sum(pn[,i])
pH <- cbind(pn["GFPposi",],tapply(GFPposi@meta.data$HIV,GFPposi@meta.data$seurat_clusters,median))
colnames(pH) <- c("GFPposi","HIV")
pH <- as.data.frame(pH)
corr.p <- paste("r=",round(cor(pH$GFPposi,pH$HIV,method="spearman"),3),"\n",
              "p=",round(cor.test(pH$GFPposi,pH$HIV,method="spearman")$p.value,6),sep="")

pd <- ggplot(pH,aes(x=GFPposi,y=HIV,label=rownames(pH))) + geom_point()
pd <- pd + geom_text_repel() + xlim(0,1) + ylim(-1,1.5)
pd <- pd + stat_smooth(method="lm",se=F,color="black",fullrange=T)
pd <- pd + annotate("text",x=-Inf,y=Inf,label=corr.p,hjust=-.2,vjust=2)

pdf(args[2],height=5,width=5)
pd
dev.off()


