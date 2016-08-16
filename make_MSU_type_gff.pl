use strict;
use warnings;

my $locusgff = "locus.gff";
my $cdsgff = "transcripts.gff";
my $exongff = "transcripts_exon.gff";
my $outfile = "rapdb.MSU.gff";

my %hash_locus;
my %hash_mRNA;

open(IN,"<$locusgff") or die $!;
while(<IN>){
	chomp;
	my $line = $_;
	#chr01   irgsp1_locus    gene    2983    10815   .       +       .       ID=Os01g0100100;Name=Os01g0100100;Note=
	my($chr,$source,$type,$start,$end,undef,$strand,$step,$attr) = split/\t/;
	$line =~ s/^chr0/Chr/;
	$line =~ s/^chr/Chr/;
	my($locus) = $attr =~ /ID=(\S+?);/;
	$hash_locus{$locus}{line} = $line;
}
close IN;

open(IN,"<$exongff") or die $!;
while(<IN>){
	chomp;
	my $line = $_;
	my($chr,$source,$type,$start,$end,undef,$strand,$step,$attr) = split/\t/;
	next unless($type eq "exon");
	$line =~ s/^chr0/Chr/;
	$line =~ s/^chr/Chr/;
	my @tmp = split/;/,$attr;
	my($mRNA) = $tmp[0] =~ /Parent=(\S+)/;
	$hash_mRNA{$mRNA}{exonlines} .= "$line\n";
}

open(IN,"<$cdsgff") or die $!;
open(OUT,">$outfile");

my $locus_tmp = "";

while(<IN>){
	chomp;
	my $line = $_;
	#chr01   irgsp1_rep      mRNA    2983    10815   .       +       .       ID=Os01t0100100-01;Name=Os01t0100100-01;GO=
	my($chr,$source,$type,$start,$end,undef,$strand,$step,$attr) = split/\t/;
	$line =~ s/^chr0/Chr/;
	$line =~ s/^chr/Chr/;
	if($type eq "mRNA"){
		my($mRNA) = $attr =~ /ID=(\S+?);/;
		my($locus) = $mRNA =~ /(\S+?)\-\d/;
		$locus =~ s/t/g/;
		if($locus ne $locus_tmp){
			print OUT $hash_locus{$locus}{line}."\n";
			$locus_tmp = $locus;
		}
		$line =~ s/;$//;
		$line .= ";Parent=$locus\n";
		$line .= "$hash_mRNA{$mRNA}{exonlines}";
	}
	unless($line =~ /\n$/){
		$line .= "\n";
	}
	print OUT $line;
}
close IN;
close OUT;
