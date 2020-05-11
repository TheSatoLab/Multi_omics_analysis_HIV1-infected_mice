#!/usr/bin/env bash

mkdir -p ../output
bash MakeSummaryData/main.sh
bash transcriptome/main.sh
bash NatCom/main.sh
bash Final_Figure/main.sh

