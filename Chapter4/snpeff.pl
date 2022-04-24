#!/usr/bin/perl
#getting gene IDs

@data = `cat $ARGV[0]`;

foreach $a (@data) {
  $a =~ s/\R//g;
  @temp = split(/\s+/, $a);
  
  @gene = split(/\|/, $temp[7]);
  #print "$temp[8]\n";
  
  print "$gene[3]\n";


}  