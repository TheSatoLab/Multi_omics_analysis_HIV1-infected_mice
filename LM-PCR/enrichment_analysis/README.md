# Descriptions

This directory contains programs to calculate the fold enrichment of overlaps between HIV-1 ISs and specific histone marks.
The genomic regions of histone marks can be extended in a user defined manner. In the default, 2kb extantion is performed (see **programs/calcEnrichmentForRandomExpectation.py**). 

## batch\_pipeline.sh
Main script file  
This script depends on the following environments and programs:
* Ubuntu (18.04.4 LTS)
* python2 (v2.7.17)
  * sys
  * subprocess
  * numpy
  * scipy
* bedtools (v2.27.0)

### Description of output file (**res_enrichment_to_random_expectation.txt**):
1. Chip_name: ChIP-Seq name
2. Observed_count: Number of observed overlaps
3. Enrichment: Fold enrichment on random expectation
4. Pval\_norm: P-value calculated under the assumption that counts in the randomized dataset follow Normal distribution
5. Pval\_poisson: P-value calculated under the assumption that counts in the randomized dataset follow Poission distribution
6. FER\_norm: Familywise error rate for Pval\_norm
7. FER\_poisson: Familywise error rate for Pval\_poisson
8. Mean\_in\_random: Mean of the overlaps in the randomized dataset
9. Var\_in\_random: Variance of the overlaps in the randomized dataset
10. Std\_in\_random: Standard deviation of the overlaps in the randomized dataset


## programs
Directory containing programs used in **batch\_pipeline.sh**.


## test_data
Directory containing demo data.  
In addition, the final output (**res_enrichment_to_random_expectation.txt**) of this pipeline is also included.

