# Descriptions

This directory contains input files to analyse scRNA-Seq data (GEO: DRA008999-DRA009013 & GEO: GSE126030).

The analytical pipeline is described in detail elsewhere (Aso, Nagaoka and Kawakami et al, Cell Reports, 2020).

## sample\.info\.txt
Cellular information of scRNA-Seq data of HIV1-GFP infected humanized mice (GEO: DRA008999-DRA009013)

## rawdata
Fastq files are placed at this directory.
Data are available at GEO(DRA008999-DRA009013).

## hg38_HIVGFP_RU3.fa
The custom genome sequence comprises the sequence of the human reference genome (hg38) and a partial sequence of HIV1-GFP (**input/NLCSFV3_EGFP_RU3.fa**), in which untranscribed regions (5' U3 and 3' U5 sequences) were excluded.

This file is not in this repository because of file size limitation.

## gencode\.v22\.annotation\.without\_retained\_intron\_sorted\.unique\.Id\_HIVGFP\_RU3\_1row\.gtf
The gene annotation GENCODE (v22) (www.gencodegenes.org)

This file is not in this repository because of file size limitation.

## NatCom\.txt
Sample information for scRNA-Seq data of CD4 T cells from healthy donors (GEO: GSE126030)

## NatCom\_Fig6\.txt
Cell annotation file for scRNA-Seq data (GEO: GSE126030)
This data is acquired from "https://doi.org/10.1038/s41467-019-12464-3".

## ISGlist\.txt
A list of Interferon Stimulated Genes (ISGs) in HIV-1 target cells.
This list is defined in the paper ([Aso et al., Frontiers in Microbiology, 2019](https://doi.org/10.3389/fmicb.2019.00429))

## HGNC\.txt
This file is generated from the HGNC BioMart server (https://biomart.genenames.org).

## association\_msigdbGO\_BP\.txt
Gene set information defined in MSigDB (v6.2) (http://software.broadinstitute.org/gsea/msigdb/collections.jsp#C5)

## Cluster\_Marker\_genes\.txt
This file is for declaring which gene names are described in Figure 4E.



