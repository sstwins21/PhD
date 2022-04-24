#!/usr/bin/perl
#identifying the speciation genes_2
use List::MoreUtils qw(uniq);

@species = `cat "/scale_wlg_nobackup/filesets/nobackup/ga02470/RNA/hisat2/gatk/AD/HEB_2/cor/david/david_only/speciation_gene.txt"`;

foreach $a (@species) {
  
  @pop = ();
  $a =~ s/\R//g;
  @data = `grep "$a" -w "/scale_wlg_nobackup/filesets/nobackup/ga02470/RNA/hisat2/gatk/AD/HEB_2/cor/david/david_only/spec_add.txt"`;
  
  foreach $b (@data) {
    $b =~ s/\R//g;
    @temp  = split(/\s+/, $b);
  
    #print "$temp[2]\n";
    push(@pop, $temp[2]);
  
  }
  @uniq_pop = uniq @pop;
  if($#uniq_pop == 0) {
      print "$temp[1]\t$pop[0]\n";
  
  }
}
