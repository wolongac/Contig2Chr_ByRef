#########################################################################
#      File Name: chain_ctg_2_chr.pl
#    > Author: hwlu
#    > Mail: hongweilu@genetics.ac.cn 
#    Created Time: Wed 07 Jul 2021 09:31:25 AM CST
#########################################################################

#!/usr/bin/perl -w
use strict;

my $ctg_file = shift;
my $info     = shift;

open(IN,"$info");
my %info;

print "read info..\n";
while(<IN>){
    chomp;
    my @line = split /\s+/,$_;
    $info{'idx'}{$line[1]}=$.;
    $info{'strand'}{$line[1]}=$line[2];
}
close IN;

print "reads fasta...\n";
open(IN,"$ctg_file");
my %fasta;

my $name;
while(<IN>){
    chomp;
    next if ($_ =~ /^\s*$/);
    if($_ =~ />/){
	$name = $_;
	$name =~ s/\s.*//g;
	$name =~ s/>//;
    }else{
	$fasta{$name}.=$_;
    }
}
close IN;

open(OUT,">$ctg_file.log");

print "sort ctg...\n";
my @chr;
foreach my $ctg (sort {$info{'idx'}{$a} <=> $info{'idx'}{$b}} keys %{$info{'idx'}}){
    print OUT "$ctg\tChr\n";
    my $seq = $fasta{$ctg};
    if($info{'strand'}{$ctg} eq "-"){
	$seq = reverse($seq);
	$seq =~ tr/[ATCGatcg]/[TAGCtagc]/;
    }
    push(@chr,$seq);
}

my @unchr;
print OUT "ChrUN...\n";

foreach my $ctg (sort {length($fasta{$b}) <=> length($fasta{$a}) } keys %fasta){
    next if (exists $info{'idx'}{$ctg});
    print OUT "$ctg\tChrUN\n";
    push(@unchr,$fasta{$ctg});
}
close OUT;
print "link ctg 2 chr...\n";
my $sep = "N" x 100;
my $chr = join "$sep", @chr;
my $unchr = join "$sep", @unchr;


print "output...\n";
open(OUT,">$ctg_file.fixed");
my $seqid = $ctg_file;
$seqid =~ s/_Y\.fa//g;
print OUT ">$seqid\_Y\n$chr\n>$seqid\_UN\n$unchr\n";
close OUT;



sub format_fasta{
    my $fa = shift;
    my $len = shift;
    for(my $i=0;$i<=length($fa);$i+=$len){
	if($i+$len>length($fa)){
	    $len = length($fa)-$i;
	}
	my $seq = substr($fa,$i,$len);
	print OUT "$seq\n";
    }
}
