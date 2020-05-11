#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
library(ggpubr)

combined <- readRDS(args[1])
mt <- combined@meta.data
mt$sample_type.new <- factor(mt$sample_type.new,levels = c("GFPposi","GFPnega","Mock"))
mt_l <- tapply(as.vector(mt$seurat_clusters),mt$sample_type.new,table)
p.df <- as.data.frame(mt_l$GFPposi)
p.df$sp <- "GFPposi"
n.df <- as.data.frame(mt_l$GFPnega)
n.df$sp <- "GFPnega"
m.df <- as.data.frame(mt_l$Mock)
m.df$sp <- "Mock"
df <- rbind(p.df,n.df,m.df)
df$sp <- factor(df$sp,levels = c("GFPposi","GFPnega","Mock"))
colnames(df) <- c("cluster","Freq","sample_type")

sum_df <- tapply(df$Freq,df$cluster,sum)
df$percent <- c(round(p.df$Freq/sum_df*100,2),
                round(n.df$Freq/sum_df*100,2),
                round(m.df$Freq/sum_df*100,2))

pdf(args[2],height=6, width=6)
ggbarplot(df, x = "cluster", y = "percent",fill = "sample_type", 
          color = "sample_type",palette = c("limegreen","indianred1","cornflowerblue"),
          label = TRUE, lab.col = "white", lab.pos = "in")
dev.off()



