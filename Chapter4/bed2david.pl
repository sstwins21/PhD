#!/usr/bin/perl
#getting DAVID IDs from bed file

@data = `cat $ARGV[0]`;

foreach $a (@data) {
  $a =~ s/\R//g;
  @temp  = split(/\s+/, $a);
  
  @temp2  = split(/\./, $temp[3]);
  @temp3  = split(/\=/, $temp2[0]);
  
  $temp3[1] =~ s/\R//g;
  
  print "$temp3[1]\n";

}

