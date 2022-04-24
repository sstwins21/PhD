#!/usr/bin/perl
#getting gene IDs


@data = `cat $ARGV[0]`;

for $a (@data) {
  $a =~ s/\R//g;
  @temp = split(/\s+/, $a);
  
  $result = `grep -w $temp[0] /scale_wlg_nobackup/filesets/nobackup/ga02470/Kate/uniprot/ver_3/DAVID_id.txt`;
  @temp2 = split(/\s+/, $result);
  
  if($temp2[0] ne "") {
    $temp[1] =~ s/\R//g;
    if($ARGV[1] eq "gene") {
      print "$temp[0] $temp2[1]\n";
    }else{
      print "$temp2[1]\n";
    }
  }

}