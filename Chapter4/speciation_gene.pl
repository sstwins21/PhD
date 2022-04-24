#!/usr/bin/perl
#identifying the speciation genes

@species = `cat "/scale_wlg_nobackup/filesets/nobackup/ga02470/RNA/hisat2/gatk/AD/HEB_2/cor/david/david_only/speciation_gene.txt"`;



checking("inermis_1");
checking("inermis_2");

checking("prasina_1");
checking("prasina_2");



sub checking () {

  $sample = $_[0];
  
  foreach $a (@species) {
    $a =~ s/\R//g;
    @temp  = split(/\s+/, $a);
    
    @data = `grep "$a" -w /scale_wlg_nobackup/filesets/nobackup/ga02470/RNA/hisat2/gatk/AD/HEB_2/cor/david/$sample.txt`;
    
    foreach $b (@data) {
      $b =~ s/\R//g;
      @temp2  = split(/\s+/, $b);
      print "$sample\t$temp2[1]\t$temp2[2]\n";
    
    }
  
  }

}
