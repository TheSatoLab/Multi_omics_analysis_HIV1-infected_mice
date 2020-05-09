#!/usr/bin/env bash

mkdir -p ../output/fastq
tail -n +2 ../input/sample.info.txt | xargs -n 8 -P 5 sh -c \
  '
  if [ ${5} = "1" ] ; then
    mkdir -p ../output/fastq/${1}/${3}
    unpigz -dc ../input/rawdata/${4}*.fastq.gz | cat >../output/fastq/${1}/${3}/before.fastq
    cutadapt \
    -a AAGCAGTGGTATCAACGCAGAGTACTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT \
    -g AAGCAGTGGTATCAACGCAGAGTAC \
    -O 10 \
    -j 8 \
    -e 0.2 \
    -m 18 \
    -o ../output/fastq/${1}/${3}/sample.noadapter.fastq \
    ../output/fastq/${1}/${3}/before.fastq
    ##remove low quality reads
    prinseq-lite.pl -fastq ../output/fastq/${1}/${3}/sample.noadapter.fastq -min_qual_mean 25 -out_good ../output/fastq/${1}/${3}/after
    rm ../output/fastq/${1}/${3}/sample.noadapter.fastq
    rm ../output/fastq/${1}/${3}/sample_prinseq_bad*
    rm ../output/fastq/${1}/${3}/before.fastq
  fi
  '



