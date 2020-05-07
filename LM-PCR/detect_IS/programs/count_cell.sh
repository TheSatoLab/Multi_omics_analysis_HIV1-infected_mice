#!/usr/bin/env bash

#  Usage:
#  bash count_cell.sh <input.txt> <output.txt> 
tail -n +2 ${1} | cut -f 1-2,4 | sort | uniq -c | sort -nr | sed -E "s/[ ]+/\t/g"  | sed -E "s/^\s//g" | awk 'BEGIN{OFS="\t"}{print $2,$3,$4,$1}' | sed -e "1i #Chrom\tPosition\tStrand\tCount" > ${2}
