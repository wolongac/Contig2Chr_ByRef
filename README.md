# Contig2Chr_ByRef
mapping contig to chr and link the contig to chr by mapping result

**###run.sh**

target=$1
query=$2
prefix=$3
core=$4

sh run_mummer.sh $ref $query $prefix  $core

sort -k 1,1 -k 2,2n ${prefix}.filter.linkage >${prefix}.filter.linkage.sorted

perl merge.pl ${prefix}.filter.linkage.sorted  >${prefix}.filter.linkage.sorted.info;done

perl chain_ctg_2_chr.pl  $query  ${prefix}.filter.linkage.sorted.info

mv ${prefix}.filter.linkage.sorted.info ${prefix}.fix.info
