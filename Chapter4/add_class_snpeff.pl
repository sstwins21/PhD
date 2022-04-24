#!/usr/bin/perl
#adding class to snpeff report: scaff region cli_hybrid  acan_hybrid cli_allele acan_allele

($bed_all, $HBE_all) = @ARGV;

@bed = `cat $bed_all`;
@HBE = `cat $HBE_all`;

%class = ();

foreach $a (@bed) {
  $a =~ s/\R//g;
  @temp  = split(/\s+/, $a);
  $class{$temp[0]}{$temp[1]} = $temp[3]
}


foreach $a (@HBE) {
  $a =~ s/\R//g;
  @temp  = split(/\s+/, $a);
  
  if(exists($class{$temp[0]}{$temp[1]})) {
    print "$a\t$class{$temp[0]}{$temp[1]}\n";
  
  }else{
    "$temp[0]\t$temp[1] something is wrong\n";
  }

}


