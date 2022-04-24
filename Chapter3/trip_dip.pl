#!/usr/bin/perl


use List::MoreUtils qw(uniq);
use List::Util qw(first);


@sample = ();
@trip = (AXX_AB_11, AXX_AB_13, AXX_AB_14, AXX_AB_15, AXX_AB_16, AXP_WB_6, AXP_WB_2021_2, AXP_WB_2021_4, AXP_WB_2021_8, AXP_WB_2021_9, AXX_WB_10, AXX_WB_11, AXX_WB_13, AXX_WB_14, AXX_WB_9, axg, axx, axp);


@header = `bcftools view -h $ARGV[0] | grep "#"`;

foreach $a (@header) {

  print "$a";
}



my $line = `bcftools view -h $ARGV[0] | grep "CHROM"`;
$line =~ s/\R//g;
my @temp = split(/\s+/, $line);


for($i = 9; $i < $#temp + 1; $i ++) {
  #print "$temp[$i]\n";
  push(@sample, $temp[$i]);    
}
  

@final_list = `bcftools view -H $ARGV[0]`;


foreach $a (@final_list){
  $tri = "false";
  $a =~ s/\R//g;
  my @temp = split(/\s+/, $a);
  $line = "$temp[0]\t$temp[1]\t$temp[2]\t$temp[3]\t$temp[4]\t$temp[5]\t$temp[6]\t$temp[7]\t$temp[8]";
  #print "$#temp\n";
  
  for($i =9; $i < $#temp + 1; $i ++) {
    #print "$sample[$i-9] $#temp\n";
    if($sample[$i-9] ~~ @trip) {
      #print "got into trip\n";
      my @info = split(/\:/, $temp[$i]);
      my @hap =  split(/\//, $info[0]);
      my @uniq = uniq @hap;
      #print "$#uniq\n";
      if($#uniq == 2) {
        $tri = "true";
        last;
      }else{
        if($#uniq == 1) {
          $line = "$line\t$uniq[0]/$uniq[1]";
        }else{
          $line = "$line\t$uniq[0]/$uniq[0]";
        }
        
        for($u = 1; $u < $#info + 1; $u ++) {
          $line = "$line:$info[$u]"
        
        }
        
      }
    
    }else{
    
      $line = "$line\t$temp[$i]";
    }
  
  
  }
  
  if($tri eq "false") {
    #print "$#uniq\n";
    print "$line\n";
  }


}