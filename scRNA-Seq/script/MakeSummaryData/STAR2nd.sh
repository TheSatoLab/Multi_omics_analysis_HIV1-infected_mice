#!/usr/bin/env bash

mkdir -p ../output/STAR
tail -n +2 ../input/sample.info.txt | xargs -n 8 -P 3 sh -c \
  '
  if [ ${5} = "1" ] ; then
    mkdir -p ../output/STAR/${1}/${3}
    STAR \
    --runThreadN 8 \
    --outBAMsortingThreadN 8 \
    --genomeLoad LoadAndKeep \
    --limitBAMsortRAM 10000000000 \
    --genomeDir ../output/STARIndex2nd/ \
    --readFilesIn ../output/fastq/${1}/${3}/after.fastq \
    --outFilterMismatchNmax 2 \
    --outSJfilterOverhangMin 12 8 8 8 \
    --outFileNamePrefix ../output/STAR/${1}/${3}/${1}_${3} \
    --outSAMtype BAM SortedByCoordinate \
    --chimOutType WithinBAM \
    --chimSegmentMin 8 \
    --chimJunctionOverhangMin 8
  fi
  '

mkdir -p STAR_remove
cd STAR_remove/
STAR \
--genomeLoad Remove \
--genomeDir ../../output/STARIndex2nd/
cd ../
rm -r STAR_remove


