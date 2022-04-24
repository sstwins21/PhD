#!/usr/bin/perl
#finding different gene from two gene lists

($gene_1, $gene_2) = @ARGV;


@uniq_gene1 = `uniq -c $gene_1 | awk '{print \$2}'`;




foreach $a (@uniq_gene1) {
  $a =~ s/\R//g;
  @common = `grep -w "$a" $gene_2`;
  
  
  #print "$a $#common\n";
  if($#common > -1) {
    #print "$a\n"; 
    
  }else{
    #@common = `grep -w "$a" $gene_3`;
   
      #print "$a\n";
   
      print "$a\n";
    
  }


}