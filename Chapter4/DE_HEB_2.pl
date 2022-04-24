#!/usr/bin/perl
#assiginging regulation to homolgue exression level 

$tar_sample = $ARGV[0];


@sample = `cat /scale_wlg_nobackup/filesets/nobackup/ga02470/RNA/hisat2/gatk/AD/HEB_2/cor/david/$tar_sample.txt`;
#@reg = `cat /scale_wlg_nobackup/filesets/nobackup/ga02470/RNA/hisat2/count_2/filter_final/hook/$tar_reg.summary.txt`;

foreach $a (@sample) {
  $a =~ s/\R//g;
  @temp = split(/\s+/, $a);
  
  $reg = `grep -w "$temp[0]" /scale_wlg_nobackup/filesets/nobackup/ga02470/RNA/hisat2/gatk/AD/HEB_2/cor/david/R/$tar_sample.exp.txt`;
  $reg =~ s/\R//g;
  @temp2 = split(/\s+/, $reg);
  if($temp2[0] ne "") {
    print "$temp2[0]\t$temp[1]\t$temp[2]\t$temp2[1]\n";
  }else{
    #print "missing: $a\n";
  }
}