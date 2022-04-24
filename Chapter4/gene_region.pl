#!/usr/bin/perl
#getting the regions by gene ID

@genes = `cat $ARGV[0]`;


foreach $a (@genes) {
  $a =~ s/\R//g;
  #print "$a\n";
  $bed = `grep -w "$a" "/scale_wlg_nobackup/filesets/nobackup/ga02470/Kate/gene.bed"`;
  print "$bed";


}