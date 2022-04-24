#!/usr/bin/perl
#adding exon length per gene for regression model
#input sample and gene list: inermis_1 mito 


($sample_data, $name) = @ARGV;

@sample = `cat  $sample_data`;
@HBE_data = `cat /scale_wlg_nobackup/filesets/nobackup/ga02470/RNA/hisat2/gatk/AD/HEB_2/new/$name.HBE2.txt`;
%HBE = ();

#print "/scale_wlg_nobackup/filesets/nobackup/ga02470/RNA/hisat2/gatk/AD/HEB_2/cor/$name.HBE2.txt";
foreach $a (@HBE_data) {
  
  $a =~ s/\R//g;
  #print "is it printing $a\n";
  @temp = split(/\s+/, $a);
  $cli = $temp[2]/($temp[2] + $temp[3] + $temp[4]);
  $acan = $temp[3]/($temp[2] + $temp[3] + $temp[4]);
  $bal = $temp[4]/($temp[2] + $temp[3] + $temp[4]);
  $HBE{$temp[0]} = "$cli $acan $bal";   
  #print "$temp[0]\n";
  
}

foreach $a (@sample) {

  $a =~ s/\R//g;
  @temp = split(/\s+/, $a);
  
  #print "$temp[0]\t";
  
  @exon = `grep -w "$temp[0]" /scale_wlg_nobackup/filesets/nobackup/ga02470/Kate/exon.bed`;
  
  $length = 0;
  foreach $b (@exon) {
    $b =~ s/\R//g;
    @temp2 = split(/\s+/, $b);
    $length = $length + (($temp2[2] - $temp2[1])/3);
    
  
  }
  
  
  if(exists($HBE{$temp[0]})) {
    $rate = $temp[2]/$length;
    #print "$a $rate\n";
    print "$a $rate $HBE{$temp[0]}\n";
    
  }else{
    #print "$a\n";
  }
  $rate = $temp[2]/$length;
  #print "$a $rate\n";
  #print "$a $rate $HBE{$temp[0]}\n";
}

