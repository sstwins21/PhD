#!/usr/bin/perl
#getting gene IDs from DAVID ID

@data = `cat $ARGV[0]`;

foreach $a (@data) {
  $a =~ s/\R//g;
  $cli = `grep $a /scale_wlg_nobackup/filesets/nobackup/ga02470/RNA/hisat2/gatk/AD/HEB/cor/david/ch_$ARGV[2].gene.txt`;
  $acan = `grep $a /scale_wlg_nobackup/filesets/nobackup/ga02470/RNA/hisat2/gatk/AD/HEB/cor/david/gh_$ARGV[2].gene.txt`;
  $BHE = `grep $a /scale_wlg_nobackup/filesets/nobackup/ga02470/RNA/hisat2/gatk/AD/HEB/cor/david/BHE_$ARGV[2].gene.txt`;
  $num = `grep $a -w /scale_wlg_nobackup/filesets/nobackup/ga02470/Kate/uniprot/ver_2/DAVID_id.txt |wc -l`;
  $num =~ s/\R//g;
  
  if($cli ne "" || $acan ne "") {
    @gene = `grep "$a" -w /scale_wlg_nobackup/filesets/nobackup/ga02470/Kate/uniprot/ver_2/DAVID_id.txt`;
    
    foreach $b (@gene) {
      $b =~ s/\R//g;
      @temp = split(/\s+/, $b);
      $result = `grep "$temp[0]" $ARGV[1]`;
      $result =~ s/\R//g;
      
      @temp = split(/\,/, $result);
      
      if($temp[6] >= 0.05) {
        print "$temp[0]\t$temp[2]\t$num";
        if($cli ne "") {
          print "\tCLI";
        }
        
        if($acan ne "") {
          print "\tACAN";
        }
        if($BHE ne "") {
          print "\tBHE";
        }
        
        print "\n";  
      
      }
       
    }
  
  }
  
    
}

