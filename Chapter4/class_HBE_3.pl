#!/usr/bin/perl
#classifing if the gene is biased/ mono / balanced
#perl /scale_wlg_nobackup/filesets/nobackup/ga02470/prevent_from_delete/script/RNA/class_HBE.pl

$bed_file = $ARGV[0];
@sample_bed = `cat $bed_file`;
@gene_bed = `cat "/scale_wlg_nobackup/filesets/nobackup/ga02470/Kate/gene.bed"`;

foreach $a (@gene_bed) {
  $a =~ s/\R//g;
  @temp = split(/\s+/, $a);
  @name = split(/=/, $temp[3]);
  #print "$temp[3] $name[1]\n";
  
  @data = `awk '{if(\$1 == "$temp[0]" && \$2 >= $temp[1] && \$3 <= $temp[2]) print \$0}' $bed_file`;
  #print "$name[1] $temp[0] $temp[1] $temp[2]: $#data\n";

  if($#data > -1) {
    #print "$name[1] $temp[0] $temp[1] $temp[2]: $#data\n";
    ($final_acan, $final_cli, $final_BHE, $loci_acan, $loci_cli, $loci_BHE, $loci_monoH, $loci_monoG, $final_monoH, $final_monoG) = (0,0,0,0,0,0,0,0,0,0);
    $prev = "";
    

    foreach $b (@data) {
      $b =~ s/\R//g;
      @temp2 = split(/\s+/, $b);
      #print "$b\n";
      #print "$prev ne $temp2[2] && ($loci_cli > 0 || $loci_BHE > 0 || $loci_acan > 0\n";
      if($prev ne $temp2[2] && ($loci_cli > 0 || $loci_BHE > 0 || $loci_acan > 0 || $loci_monoH > 0 || $loci_monoG > 0)) {
        $loci_cli = $loci_cli + $loci_monoH;
        $loci_acan = $loci_acan + $loci_monoG;
        $total = $loci_cli + $loci_acan + $loci_BHE;
        #print "$prev ne $temp2[2] && ($loci_cli > 0 || $loci_BHE > 0 || $loci_acan > 0\n";
        
        if($loci_monoH/$total > 0.7){
          $final_monoH ++;
        }elsif($loci_monoG/$total > 0.7) {
          $final_monoG ++;
        }elsif($loci_cli/$total > 0.7) {
          $final_cli ++;
        }elsif($loci_acan/$total > 0.7) {
          $final_acan ++;
        }else{
          $final_BHE ++;
        }
        ($loci_acan, $loci_cli, $loci_BHE, $loci_monoH, $loci_monoG) = (0,0,0,0,0);
      }
      
      if($temp2[3] eq "geisovii") {
        #print "got in\n";
        $loci_acan ++;
      }elsif($temp2[3] eq "hookeri") {
        $loci_cli ++;
      }elsif($temp2[3] eq "balanced") {
        #print "got in to adding\n";
        $loci_BHE ++; 
      }elsif($temp2[3] eq "mono_hook") {
        $loci_monoH ++;
        #print "got in \n";
      }elsif($temp2[3] eq "mono_gei") {
        #print "got in \n";
        $loci_monoG ++;
      }
      $prev = $temp2[2];
      #print "$prev\n";
    }
    
    $loci_cli = $loci_cli + $loci_monoH;
    $loci_acan = $loci_acan + $loci_monoG;
    $total = $loci_cli + $loci_acan + $loci_BHE + $loci_monoH + loci_monoG;
    #print "$temp2[3] : $total = $loci_cli + $loci_acan + $loci_BHE\n";
    #print "$prev ne $temp2[2] && ($loci_cli > 0 || $loci_BHE > 0 || $loci_acan > 0\n";
    if($loci_monoH/$total > 0.7){
      $final_monoH ++;
    }elsif($loci_monoG/$total > 0.7) {
      $final_monoG ++;
    }elsif($loci_cli/$total > 0.7) {
      $final_cli ++;
    }elsif($loci_acan/$total > 0.7) {
      $final_acan ++;
    }else{
      $final_BHE ++;
    }
    
    
    $final_cli = $final_cli + $final_monoH;
    $final_acan = $final_acan + $final_monoG;
    $total = $final_cli + $final_acan + $final_BHE;
    #print "$name[1] $final_cli $final_acan $final_BHE $#data\n";
    print "$name[1]\t";
    
    if($final_monoH/$total > 0.7) {
      print "mono_hook\t";
    }elsif($final_monoG/$total > 0.7) {
      print "mono_gei\t";
    }elsif($final_cli/$total > 0.7) {
      print "hookeri\t";
    }elsif($loci_acan/$total > 0.7) {
      print "geisovii\t";
    }else{
      print "balanced\t";
        
    }
    
    print "$final_cli\t$final_acan\t$final_BHE\t$final_monoH\t$final_monoG\n";

  }
}

