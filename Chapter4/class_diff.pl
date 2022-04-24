#!/usr/bin/perl
#getting the differences between allele SNP effect

$all_data = $ARGV[0];

@data = `cat $all_data`;

foreach $a (@data) {
  $a =~ s/\R//g;
  @temp  = split(/\s+/, $a);
  @cli = ();
  @acan = ();
  @h_cli = ();
  @h_acan = ();
  
  
  


}