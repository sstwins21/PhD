#!/usr/bin/perl
#comparing VCFs

use List::MoreUtils qw(uniq);
use List::Util qw(first);

$name = $ARGV[0];

%gatk = ();
%freebayes = ();

gatk_hashing("gatk_$name.vcf");
freebayes_hashing("feebayes_$name.vcf");

$overlap = 0;
$identical = 0;


@keys = keys %gatk;
$total_gatk = @keys;

@keys = keys %freebayes;
$total_freebayes = @keys;
#print  "$total_gatk $total_freebayes\n";


foreach my $key (keys %freebayes) {
  #print "kets: $key\n";
  if(exists($gatk{$key})) {
    $same = "false";
    
    $overlap ++;
    @gtk = split(/\s+/, $gatk{$key});
    @free = split(/\s+/, $freebayes{$key});
    
    foreach $a (@gtk) {
      if( $a ~~ @free ) {
        $same = "true";
        #print "$a\n";
      }else{
        $same = "false";
        last;
      }
    }
    if($same eq "true") {
      foreach $a (@free) {
        if( $a ~~ @gtk ) {
          $same = "true";
        }else{
          $same = "false";
          last;
        }
      }
    
    }
    
    #print "$key: $same\n";
    if($same eq "true") {
      $identical ++;
    }
  
  }

}

print "$total_gatk $total_freebayes $overlap $identical\n";

sub gatk_hashing {

  my ($vcf, %data) = @_;


  open(my $in, '<:encoding(UTF-8)', $vcf)
  or die "Could not open file '$vcf' $!";
 
  while (my $line = <$in>) {
    chomp $line;
    #print "$line\n";
    if(index($line , '#') == -1) {
     @temp = split(/\s+/, $line);
     $new_key = "$temp[0].$temp[1]";
     my @alt = split(/,/, $temp[4]);
     @locus = split(/:/, $temp[9]);
   
     if(index($locus[0], "/") != -1){
       @hap = split(/\//, $locus[0]);
     #print "$hap[0], $hap[1]\n";
     }else{
       @hap = split(/\|/, $locus[0]);
     }
     
     
     my @snps = ();
     push(@snps , $temp[3]);
     foreach $s (@alt) {
       push(@snps, $s);
     }
 
      my @locus_hap = ();
     foreach $s (@hap) {
       push(@locus_hap, $snps[$s]);
     }
     
     @uniq_hap = uniq @locus_hap;
     
     #print "got into $temp[0] at $temp[1] $#uniq_hap\n";
     
     if($#uniq_hap == 0 && $uniq_hap[0] eq $temp[3]) {
     
       #print "got in here\n";
     
     }else{
       for($i = 0; $i < $#uniq_hap + 1; $i ++) {
         $gatk{$new_key} = "$gatk{$new_key}$uniq_hap[$i] ";
         #print "$vcf: $uniq_hap[$i]\n";
       }
       #print "$vcf: $temp[0] $temp[1] $data{$temp[0]}{$temp[1]}\n";
     
     }
     
   }
   #print "$vcf: $temp[0] $temp[1] $data{$temp[0]}{$temp[1]}\n";
  }
  #print "$vcf: $temp[0] $temp[1] $data{$temp[0]}{$temp[1]}\n";
 
}

sub freebayes_hashing {

  my ($vcf, %data) = @_;


  open(my $in, '<:encoding(UTF-8)', $vcf)
  or die "Could not open file '$vcf' $!";
 
  while (my $line = <$in>) {
    chomp $line;
    #print "$line\n";
    if(index($line , '#') == -1) {
     @temp = split(/\s+/, $line);
     $new_key = "$temp[0].$temp[1]";
     my @alt = split(/,/, $temp[4]);
     @locus = split(/:/, $temp[9]);
   
     if(index($locus[0], "/") != -1){
       @hap = split(/\//, $locus[0]);
     #print "$hap[0], $hap[1]\n";
     }else{
       @hap = split(/\|/, $locus[0]);
     }
     
     
     my @snps = ();
     push(@snps , $temp[3]);
     foreach $s (@alt) {
       push(@snps, $s);
     }
 
      my @locus_hap = ();
     foreach $s (@hap) {
       push(@locus_hap, $snps[$s]);
     }
     
     @uniq_hap = uniq @locus_hap;
     
     #print "got into $temp[0] at $temp[1] $#uniq_hap\n";
     
     if($#uniq_hap == 0 && $uniq_hap[0] eq $temp[3]) {
     
       #print "got in here\n";
     
     }else{
       for($i = 0; $i < $#uniq_hap + 1; $i ++) {
         $freebayes{$new_key} = "$freebayes{$new_key}$uniq_hap[$i] ";
         #print "$vcf: $uniq_hap[$i]\n";
       }
       #print "$vcf: $temp[0] $temp[1] $data{$temp[0]}{$temp[1]}\n";
     
     }
     
   }
   #print "$vcf: $temp[0] $temp[1] $data{$temp[0]}{$temp[1]}\n";
  }
  #print "$vcf: $temp[0] $temp[1] $data{$temp[0]}{$temp[1]}\n";

}