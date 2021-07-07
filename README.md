# Contig2Chr_ByRef
mapping contig to chr and link the contig to chr by mapping result

target=$1
query=$2
prefix=$3
core=$4

nucmer  --mum  --prefix=$prefix         --threads=$core $target $query
delta-filter -q -r -1 $prefix.delta > $prefix.filter.delta
mummerplot -png --medium -p $prefix.filter -R $target -Q $query $prefix.filter.delta
show-coords -T -q ${prefix}.filter.delta |awk '{print $8"\t"$1"\t"$2"\t"$9"\t"$3"\t"$4}' >${prefix}.filter.coor
sed 1,4d ${prefix}.filter.coor >${prefix}.filter.linkage

sort -k 1,1 -k 2,2n ${prefix}.filter.linkage >${prefix}.filter.linkage.sorted

perl merge.pl ${prefix}.filter.linkage.sorted  >${prefix}.filter.linkage.sorted.info;done
perl chain_ctg_2_chr.pl  $query  ${prefix}.filter.linkage.sorted.info
mv ${prefix}.filter.linkage.sorted.info ${prefix}.fix.info
