#!/usr/bin/perl
#running RAxML on alignment files

my ($dir, $out) = @ARGV;

@aln = `ls $dir/*.aln`;

foreach $a (@aln) {
  $a =~ s/\R//g;
  @temp = split(/\//, $a);
  print "raxmlHPC -T 2 -m GTRCAT -f d -s $a -n $temp[-1] -w $out -N 2 -p 1\n";
  `raxmlHPC -T 2 -m GTRCAT -f d -s $a -n $temp[-1] -w $out -N 2 -p 1`;

}