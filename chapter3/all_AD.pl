#!/usr/bin/perl
#getting average AD in geneblock for a sample in given region

use List::MoreUtils qw(uniq);

$vcf = $ARGV[0];

@loci = `grep "#" -v  $vcf`;
@AD = ();

foreach $a (@loci) {
  $a =~ s/\R//g;
  @geno = ();

    if(index($a, "#") < 0) {
     @temp = split(/\s+/, $a);
     @temp2 = split(/\:/, $temp[9]); 

     
     if(index($temp2[0], "/") != -1) {
      @hap = split(/\//, $temp2[0]); 
    
      
    }else{
      @hap = split(/\|/, $temp2[0]);
      
    }
    
    push(@geno, $temp[3]);
    @alt = split(/\,/, $temp[4]);
    foreach $g (@alt) {
      push(@geno, $g);
    } 
    
    @uniq = uniq(@hap);
    #print "$temp2[0] $#uniq\n";
    @temp3 = split(/\,/, $temp2[2]);
    if($#uniq > 0 ) {
      
      $prop = $temp3[0]/$temp2[1] * 100;
      #print "$prop\n";
      push(@AD, $prop);
      $prop = $temp3[1]/$temp2[1] * 100;
      push(@AD, $prop);
      #print "$prop\n";
      
    }elsif(index($geno[$uniq[0]], "N") < 0) {
    #}else{
      $prop = $temp3[$uniq[0]]/$temp2[1];
      $prop = $prop/2 * 100;
      push(@AD, $prop);
      push(@AD, $prop);
      #print "$prop\n$prop\n";
    
    }  
  }

}

$sum = 0;
foreach $b (@AD) {
  #print "$b\n";
  $sum = $sum + $b;

}

$denom = $#AD + 1;
$result = $sum/$denom * 100;

print "$result";



