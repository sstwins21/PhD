#!/usr/bin/perl
#masking phase information excluding the phase block of interest
#perl "/scale_wlg_nobackup/filesets/nobackup/ga02470/prevent_from_delete/script/masking_phase.pl" start_pos end_pos vcf


my ($start, $end, $vcf) = @ARGV;




my @sample = `cat $vcf`;

foreach $a (@sample) {

  $a =~ s/\R//g;
  @temp = split(/\s+/, $a);
  
  if(index($a, "#") > -1){
    #print "got in ?$a\n";
  }else{
    if($start <= $temp[1] && $temp[1] <= $end) {
      print "$a\n";
    }else{
      $a =~ tr/\|/\//;
      print "$a\n";
    }
  } 

}

