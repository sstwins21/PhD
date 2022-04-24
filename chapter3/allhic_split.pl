#!/usr/bin/perl



@list = `cat $ARGV[0]`;




foreach $a (@list) {
  $a =~ s/\R//g;
  
  `samtools faidx $ARGV[1] $a >> output.fasta`;

}

