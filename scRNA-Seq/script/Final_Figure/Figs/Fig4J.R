#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
library(cowplot)
library(ggplot2)
library(reshape2)

Seurat1 <- readRDS(args[1])
Seurat2 <- readRDS(args[2])
mt1 <- Seurat1@meta.data
mt2 <- Seurat2@meta.data
color1 <- unique(mt1$seurat_clusters)
color2 <- unique(mt2$seurat_clusters)

#boxplot
theme <- theme(axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank())
jit <- geom_jitter(aes(color=seurat_clusters),size = 0.5)
yaxis <- scale_y_continuous(breaks=seq(-0.25,0.5,length=4),limits=c(-0.25,0.5))

p2_1 <- ggplot(mt1,aes(x=seurat_clusters,y=commonISG,color=seurat_clusters)) +geom_boxplot(outlier.shape = NA,color=color1)+theme+yaxis
p2_2 <- ggplot(mt2,aes(x=seurat_clusters,y=commonISG,color=seurat_clusters)) +geom_boxplot(outlier.shape = NA,color=color2)+theme+yaxis

#heatmap
cor.df <- read.table(args[3],header=T,check.names=F,row.names=1,sep="\t")
cor.df1 <- cor.df[gsub("__[0-9]+","",rownames(cor.df)) == "Donor1",]
cor1 <- data.frame(seurat_clusters = gsub("Donor.__","",rownames(cor.df1)), spearman = cor.df1[,"HuMice__5"],data = "-1.11")
cor.df2 <- cor.df[gsub("__[0-9]+","",rownames(cor.df)) == "Donor2",]
cor2 <- data.frame(seurat_clusters = gsub("Donor.__","",rownames(cor.df2)), spearman = cor.df2[,"HuMice__5"],data = "-2.22")

colors <- c("blue1","white","red1")
breaks <- c(-0.25,-0.5,0,0.25,0.5)
limits <- c(-0.5,0.5)
sfg <- scale_fill_gradientn(colors = colors,breaks=breaks,limits=limits)

p4_1 <- ggplot(cor1,aes(x=seurat_clusters, y=data, fill=spearman))
p4_1 <- p4_1 + geom_tile(aes(x=seurat_clusters, y=data, fill=spearman)) + sfg
p4_2 <- ggplot(cor2,aes(x=seurat_clusters, y=data, fill=spearman)) + geom_tile(aes(x=seurat_clusters, fill=spearman)) + sfg
p4_2 <- p4_2 + geom_tile(aes(x=seurat_clusters, y=data, fill=spearman)) + sfg

#pdf
p <- plot_grid(plot_grid(p2_1,NULL,p2_2,NULL, ncol = 4,align = "h",rel_widths=c(1,0.2,1,0.2)),
               plot_grid(p4_1,p4_2, ncol = 2,align = "h",rel_widths=c(1,1)),
               ncol=1,rel_heights=c(1,0.3))

pdf(args[4],height=8, width=12)
print(p)
dev.off()


