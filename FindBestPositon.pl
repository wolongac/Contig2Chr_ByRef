#########################################################################
#      File Name: FindBestPositon.pl
#    > Author: hwlu
#    > Mail: hongweilu@genetics.ac.cn 
#    Created Time: Tue 06 Jul 2021 07:48:12 PM CST
#########################################################################

#!/usr/bin/perl -w
use strict;

my $file=shift;
open(IN,"$file");

my $ctg="-";

my %hash;
my $num;

while(<IN>){
    chomp;
    my @line = split /\s+/,$_;
    if($line[3] ne $ctg ){
	$num++;
	$ctg = $line[3];
    }
    my $strand = "+";
    if($line[4]>$line[5]){
	$strand = "-";
    }
    my $len = abs ( $line[5] - $line[4] )  + 1;
    $hash{$num}{$ctg}{$strand}+=$len;
}

my %hash_2;
my %hash_3;
foreach my $block (sort {$a <=> $b} keys %hash){
    foreach my $ctg (keys %{$hash{$block}}){
	if(!exists $hash{$block}{$ctg}{"+"}){
	    $hash{$block}{$ctg}{"+"}=0;
	}
	if(!exists $hash{$block}{$ctg}{"-"}){
	    $hash{$block}{$ctg}{"-"}=0;
	}

	$hash_2{$block}{$ctg}{'len'}=$hash{$block}{$ctg}{"+"} + $hash{$block}{$ctg}{"-"};
	$hash_3{$ctg}{$block} = $hash{$block}{$ctg}{"+"} + $hash{$block}{$ctg}{"-"};
	if($hash{$block}{$ctg}{"+"} > $hash{$block}{$ctg}{"-"}){
	   $hash_2{$block}{$ctg}{'strand'} = "+";
	}else{
	   $hash_2{$block}{$ctg}{'strand'} = "-";
	}
    }
}

my %hash_4;
foreach my $ctg (keys %hash_3){
    foreach my $block (sort {$hash_3{$ctg}{$b} <=> $hash_3{$ctg}{$a}} keys %{$hash_3{$ctg}}){
	$hash_4{$block}{$ctg}=1;
	last;
    }
}

foreach my $block (sort {$a <=> $b} keys %hash_2){
    foreach my $ctg (keys %{$hash_2{$block}}){
	next if (!exists $hash_4{$block}{$ctg});
	print "$block\t$ctg\t$hash_2{$block}{$ctg}{'strand'}\n";
    }
}

