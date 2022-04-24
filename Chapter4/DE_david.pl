#!/usr/bin/perl
#getting gene IDs from DAVID ID
($gene, $DE) = @ARGV;

@data = `cat $gene`;

foreach $a (@data) {
  $a =~ s/\R//g;
 
  $csv = `grep -w "$a" $DE `;
  $result = `grep -w "$a" /scale_wlg_nobackup/filesets/nobackup/ga02470/Kate/uniprot/ver_2/DAVID_id.txt`;
  
  print "grep -w $a $DE\n";
  
  @temp = split(/\,/, $csv);
  @david = split(/\s+/, $result);
  
  if($temp[6] < 0.05) {
    print "$david[1]\t$temp[1]\n";
  
  }

}
