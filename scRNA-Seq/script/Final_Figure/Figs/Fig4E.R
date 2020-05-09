#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(circlize)
library(ComplexHeatmap)

out <- read.table(args[1],sep="\t",header=T)
colnames(out) <- c("cluster","gene",as.character(1:9))
check <- read.table(args[2],header=T,sep="\t")
check.fil <- check[check$Check == 1,]
c_exp <- out[,c(3:11)]
rownames(c_exp) <- paste(out$cluster,out$gene,sep="__")

ra1 <- rowAnnotation(foo = anno_mark(at = c(1:nrow(check))[which(check$Check == 1)],
                                     labels = check.fil$gene
                                    )
                    )
oa <- data.frame(cluster = as.character(out$cluster))
rownames(oa) <- rownames(c_exp)
ra2 <- rowAnnotation(
      df  = oa,
      col = list(cluster = c("1"=1,"2"=2,"3"=3,"4"=4,"5"=5,"6"=6,"7"=7,"8"=8,"9"=9)))

ht <- Heatmap(as.matrix(c_exp), name = "Z-score", cluster_rows = FALSE, cluster_columns = FALSE,left_annotation = ra2,
              right_annotation = ra1,show_row_names=F,colorRamp2(c(-2,0,2),c("blue","white", "red")))

pdf(args[3], height=40, width=16)
draw(ht)
dev.off()


