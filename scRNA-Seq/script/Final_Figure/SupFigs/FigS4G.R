#!/usr/bin/env R

args <- commandArgs(trailingOnly=T)
library(Seurat)
library(amap)
library(ComplexHeatmap)
library(circlize)

combined <- readRDS(args[1])

embeddings <- Embeddings(combined,reduction="pca")[,1:20]
calc_meanPC <- function(x) {
  cells <- WhichCells(object = combined, idents = x)
  if (length(cells) == 1) cells <- c(cells, cells)
  temp <- colMeans(embeddings[cells, ])
}
data.dims <- lapply(levels(combined),calc_meanPC)
data.dims <- do.call(what = 'cbind', args = data.dims)
colnames(data.dims) <- levels(combined)
data.dist <- dist(t(data.dims))

dist_mat <- as.matrix(data.dist)
diag(dist_mat) <- NA
c <- hclust(data.dist, method="ward.D2")

pdf(args[2],height=5,width=5)
ht1 = Heatmap(as.matrix(dist_mat),
              name = "Dist",
              cluster_columns=as.dendrogram(c),
              cluster_rows=as.dendrogram(c),
              col = colorRamp2(c(10,20,30),c("red","yellow","white"))
              )
draw(ht1)
dev.off()




