#########################################################################
#      File Name: run.sh
#    > Author: hwlu
#    > Mail: hongweilu@genetics.ac.cn 
# Created Time: Tue 06 Jul 2021 08:36:02 PM CST
#########################################################################
#!/bin/bash

sh run_mummer.sh $ref $query $prefix  $core

sort -k 1,1 -k 2,2n ${prefix}.filter.linkage >${prefix}.filter.linkage.sorted

perl merge.pl ${prefix}.filter.linkage.sorted  >${prefix}.filter.linkage.sorted.info;done

perl chain_ctg_2_chr.pl  $query  ${prefix}.filter.linkage.sorted.info

mv ${prefix}.filter.linkage.sorted.info ${prefix}.fix.info