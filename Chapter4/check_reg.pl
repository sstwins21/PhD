#!/usr/bin/perl
#getting gene IDs from DAVID ID

@data = `cat $ARGV[0]`;

foreach $a (@data) {
  $a =~ s/\R//g;
  
  $result = `grep -w $a /scale_wlg_nobackup/filesets/nobackup/ga02470/RNA/hisat2/count_2/filter_final/hook/$ARGV[1].csv`;
  $result =~ s/\R//g;
  
  if($result ne "") {
    @temp = split(/\,/, $result);
    if($temp[6] >= 0.05) {
      #print "$a NOT significant\n";
    }else{

      $david = `grep $a -w /scale_wlg_nobackup/filesets/nobackup/ga02470/Kate/uniprot/ver_2/DAVID_id.txt`;
      
      $david =~ s/\R//g;
          
      @temp2 = split(/\s+/, $david);
      $cli = `grep $temp2[1] /scale_wlg_nobackup/filesets/nobackup/ga02470/RNA/hisat2/gatk/AD/HEB/cor/david/ch_$ARGV[2].gene.txt`;
      $acan = `grep $temp2[1] /scale_wlg_nobackup/filesets/nobackup/ga02470/RNA/hisat2/gatk/AD/HEB/cor/david/gh_$ARGV[2].gene.txt`;
      $BHE = `grep $temp2[1] /scale_wlg_nobackup/filesets/nobackup/ga02470/RNA/hisat2/gatk/AD/HEB/cor/david/BHE_$ARGV[2].gene.txt`;
      $num = `grep $temp2[1] -w /scale_wlg_nobackup/filesets/nobackup/ga02470/Kate/uniprot/ver_2/DAVID_id.txt |wc -l`;
      $num =~ s/\R//g;  
      
      
      if($cli ne "" || $acan ne "") {
        print "$david\t$temp[2]\t$num";
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
