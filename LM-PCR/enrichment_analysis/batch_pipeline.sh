#!/usr/bin/env bash

#Calculating the fold enrichment of overlaps between HIV-1 ISs and specific histone marks
python2 programs/calcEnrichmentForRandomExpectation.py \
	test_data/untreated_GFP_posi.clustered.merged.bed \
	test_data/chrom_list.txt \
	test_data/cd4t_histone_list.txt \
	test_data/chip_dir/ \
	> test_data/res_enrichment_to_random_expectation.txt
