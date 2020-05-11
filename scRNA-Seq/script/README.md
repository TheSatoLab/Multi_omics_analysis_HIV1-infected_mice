# Descriptions

This directory contains programs to analyse scRNA-Seq data (GEO: DRA008999-DRA009013 & GEO: GSE126030).

The analytical pipeline are described in detail elsewhere ([Aso, Nagaoka and Kawakami et al, Cell Reports, 2020]).

## main.sh
Main script file  
Please execute this file at **script/**
Simply run this program and the descendent scripts will run recursively.

## Usage
bash main.sh

## Dependencies
This script depends on the following environments and programs:
* Ubuntu (16.04 LTS)
* python (v2.7.17)
* R (v3.6.0)
* cutadapt (v1.16)
* prinseq-lite (v0.20.4)
* STAR (v2.5.3a)
* featureCounts (v1.6.2)
* Seurat (v3.0.2)
* GSVA (v1.32.0)


