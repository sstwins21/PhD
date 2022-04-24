#!/usr/bin/perl
#getting phase rates for a sample
#perl /scale_wlg_nobackup/filesets/nobackup/ga02470/prevent_from_delete/script/phase_rate.pl /scale_wlg_nobackup/filesets/nobackup/ga02470/freebayes/lowCov/freebayes_3/whatshap/busco/all/indel_conserv/ axw2


use List::MoreUtils qw(uniq);

$vcf = $ARGV[0];
$phased = "false";



@loci = `grep "#" -v $vcf`;
($phased_count, $total_count) = (0, 0);

foreach $a (@loci) {
  $a =~ s/\R//g;
  
  if(index($a, "#") < 0) {
     @temp = split(/\s+/, $a);
     @temp2 = split(/\:/, $temp[9]);
     
     if(index($temp2[0], "/") != -1) {
      @hap = split(/\//, $temp2[0]); 
      $phased = "false";
      
    }else{
      @hap = split(/\|/, $temp2[0]);
      $phased = "true";
    }
    
    @uniq = uniq(@hap);
    #print "$temp2[0] $#uniq\n";
    if($#uniq == 0 || $phased eq "true") {
      $phased_count ++;
      $total_count ++;
      
    }elsif($#uniq > 0 && $phased eq "false") {
      $total_count ++;    
    
    } 
  
  }else{
  
  }

}
if($total_count > 0) {
  $result_rate = $phased_count/$total_count *100;
}else{
  $result_rate = 0;
}
print "$result_rate";