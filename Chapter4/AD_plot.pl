#!/usr/bin/perl
#geting AD for heterozygous regions for mulitiple samples
#info: GT:AD:DP:GQ:PL
use List::MoreUtils qw(uniq);

@vcf = `grep "#" -v $ARGV[0]`;
@result = ();
foreach $a (@vcf) {
  $a =~ s/\R//g;
  @temp = split(/\s+/, $a);
  @geno = ();
  
  push(@geno, $temp[3]);
  @alt = split(/\,/, $temp[4]);
  foreach $g (@alt) {
    push(@geno, $g);
  } 
  
  for($i = 9; $i < $#temp + 1; $i ++) {
  
     @temp2 = split(/\:/, $temp[$i]); 

     
     if(index($temp2[0], "/") != -1) {
      @hap = split(/\//, $temp2[0]); 
    
      
    }else{
      @hap = split(/\|/, $temp2[0]);
      
    }
    
    @uniq = uniq(@hap);
    #print "$temp[0] $temp[1] $#uniq\n";
    if($#uniq > 0 && $temp2[2] > 0 ) {
      @AD = split(/\,/, $temp2[1]);
      
      foreach $uniq_snp (@uniq) {
        if($temp2[2] == 0 ) {
          print "wrong at: $a\n";
        }
        $prop = $AD[$uniq_snp]/$temp2[2] * 100;
        print "$prop\n";
        push(@result, $prop);

      }
    
    }
  
  }
}