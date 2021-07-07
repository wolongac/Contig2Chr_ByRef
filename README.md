# Contig2Chr_ByRef
mapping contig to chr and link the contig to chr by mapping result

**###run.sh**

target=$1
query=$2
prefix=$3
core=$4

sh run_mummer.sh $ref $query $prefix  $core

sort -k 1,1 -k 2,2n ${prefix}.filter.linkage >${prefix}.filter.linkage.sorted

perl FindBestPositon.pl ${prefix}.filter.linkage.sorted  >${prefix}.fix.info;done

perl chain_ctg_2_chr.pl  $query  ${prefix}.fix.info
 
