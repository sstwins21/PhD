#!/usr/bin/perl
#printing stop gained genes and their statistics
use List::MoreUtils qw(uniq);
use List::Util qw(first);

%DAVID = ();

@data = `cat /scale_wlg_nobackup/filesets/nobackup/ga02470/Kate/uniprot/ver_2/DAVID_id.txt`;

foreach $a (@data) {
  $a =~ s/\R//g;
  @temp = split(/\s+/, $a);
  $DAVID{$temp[0]} = $temp[1];

}



@data = `grep "stop_gained" $ARGV[0] | grep -v "WARNING_TRANSCRIPT_NO_START_CODON"`;


($hom, $het) = (0, 0);
 
#`>$ARGV[1]/hom_gained.txt`;
#`>$ARGV[1]/het_gained.txt`;

foreach $a (@data) {
  @hap = ();
  $a =~ s/\R//g;
  @temp = split(/\s+/, $a);
  
  #@gene = split(/ANN=/, $temp[7]);
  #print "$temp[8]\n";
  
  #print "$gene[1]\n";
  
  my @info = split(/\:/, $temp[9]);
  @gene = split(/\|/, $temp[7]);
  if(index($info[0] , "/") > -1) {
    @hap =  split(/\//, $info[0]);
      #print "gotin 1: $hap[0] $hap[1]\n"
    
  }else{
    @hap =  split(/\|/, $info[0]);
      #print "gotin 2: $hap[0] $hap[1]\n"
  }
  

  
  @uniq = uniq @hap;
  
  @temp2 = split(/ANN=/, $temp[7]);
  @temp3 = split(/,/, $temp2[1]);
  $anno_hom = "true";
  %hap_anno = ();
  $hap_anno{0} = "ref";
    
  for($i = 0; $i < $#temp3 + 1; $i ++) {
  
    @anno = split(/\|/, $temp3[$i]);
    $index = $i+1;
    #print "index is $index $temp3[$i]\n";
    $hap_anno{$index} = $anno[1];  
  }
  
  foreach $b (@uniq){
    #print "annot for $b: $hap_anno{$b}\n";
    if($hap_anno{$b} ne "stop_gained") {
      $anno_hom = "false";
    }
  }
  
  
  #print "$temp[0] $temp[1] $anno_hom\n";
  if($DAVID{$gene[3]} ne "") {
    if($#uniq > 0 && $anno_hom eq "false") {
      $het = $het + 1;
   
      #print "$temp[8]\n";
       
      `echo $DAVID{$gene[3]} >> $ARGV[1]/het_gained.txt`;
  
    }else{
      $hom = $hom + 1;
      `echo $DAVID{$gene[3]} >> $ARGV[1]/hom_gained.txt`;
    
    }
  }

}

print "hom: $hom het: $het\n";  