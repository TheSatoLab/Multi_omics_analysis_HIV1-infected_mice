#!/usr/bin/env bash

mkdir -p ../output/summary
R --vanilla --slave --args \
../input/sample.info.txt \
../output/featureCounts/ \
../output/summary/summary.fil.txt \
../output/summary/counts.fil.rds \
< MakeSummaryData/make_table.R

tail -n +2 ../output/featureCounts/278F3_GFP-_170418_l6/counts.txt \
| cut -f 1,6 \
> ../output/summary/GeneLength.txt
