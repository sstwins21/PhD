#!/usr/bin/perl
#summarising DE report

$csv = $ARGV[0];

@data = `tail -n+2 $csv`;


foreach $a (@data) {
  $a =~ s/\R//g;
  @temp = split(/\,/, $a);
  $david = `grep -w "$temp[0]" /scale_wlg_nobackup/filesets/nobackup/ga02470/Kate/uniprot/ver_2/DAVID_id.txt`;
  $david =~ s/\R//g;
  
  if($david ne "") {
    print "$david\t$temp[2]\t$temp[6]\n";
  }

}