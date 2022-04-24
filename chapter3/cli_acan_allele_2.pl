#!/usr/bin/perl
#counting allele freq of Clitarchus and Acanthoxyla in triplod sample
#perl "/scale_wlg_nobackup/filesets/nobackup/ga02470/prevent_from_delete/script/cli_acan_allele.pl" 

use List::MoreUtils qw(uniq);

 
my ($in_list, $out_list, $scaff) = @ARGV;
#my ($in_list, $target_vcf) = @ARGV;
my %data;
@cli_list = `cat $in_list`;

#getting alleles from Clitarchus
foreach $sample (@cli_list) {
  @loci = `bcftools view -i 'F_MISSING<0.1' -H -r $scaff $sample`;
  #@loci = `cat $sample`;
  %data = hashing(\@loci, \%data);
}

#@par = `cat $vcf`;
@target = `bcftools view -i 'F_MISSING<0.1' -H -r $scaff $out_list`;
compare(\@target, \%data);

#%data = hashing(\@par, \%data);





#comparing given loci with data hash to see if it present or not. printing out $pos $cli_freq $acan_freq
sub compare {
  my ($sub_vcf, $data) = @_;
  
  foreach $a (@$sub_vcf) {
    $a =~ s/\R//g;
    $het = "false";
    @temp = split(/\s+/, $a);
    #print "got into $temp[0] at $temp[1]\n";
    my @alt = split(/,/, $temp[4]);
    @locus = split(/:/, $temp[9]);
  
    if(index($locus[0], "/") != -1){
      @hap = split(/\//, $locus[0]);
    #print "$hap[0], $hap[1]\n";
    }else{
      @hap = split(/\|/, $locus[0]);
    }
    my @info = split(/\:/, $temp[8]);
    
    for(my $x = 0; $x < $#info + 1; $x ++) {
      if($info[$x] eq "AD") {
        @hap_AD = split(/\,/, $locus[$x]);
      }elsif($info[$x] eq "DP") {
        if($locus[$x] == 0) {
          $locus[$x] = 1;
        }
        $DP = $locus[$x];
        #print "$DP\n";
      }
    }
    
    
    my @snps = ();
    push(@snps , $temp[3]);
    foreach $s (@alt) {
      push(@snps, $s);
    }
    my @locus_hap = ();
    my ($cli_freq, $acan_freq) = (0,0);
    my @unique_hap = uniq @hap;
    #print "$#unique_hap\n";
    if($#unique_hap > 0){
    
     foreach $s (@unique_hap) {
       #print "$temp[0] at $temp[1] given SNP is $snps[$s]\n";
       #if(index($snps[$s], "A") != -1 || index($snps[$s], "T") != -1 || index($snps[$s], "G") != -1 || index($snps[$s], "C") != -1) {
       if($snps[$s] ne ".") {
         if(exists $data{$temp[0]}{$temp[1]}) {
           my $cli_present = "false";
      
           @cli_allele = split(/\,/, $data{$temp[0]}{$temp[1]});
   
             
           
           foreach $c (@cli_allele) {
             if($c eq $snps[$s]) {
               $cli_present = "true";
               last;
             }
           }
           
       
           if($cli_present eq "true") {
             #print "cli is present: $snps[$s]\n";
             $cli_freq = $cli_freq + ($hap_AD[$s]/$DP);
           
           }else{
             $acan_freq = $acan_freq + ($hap_AD[$s]/$DP);
             #print "acan is present: $snps[$s]\n";
           }
           
           #print "$temp[0] $temp[1] @cli_allele\n";
           
         }else{
           if($s == 0) {
             $cli_freq = $cli_freq + ($hap_AD[$s]/$DP);
           }else{
             $acan_freq = $acan_freq + ($hap_AD[$s]/$DP);
           }
         }
       }else{
         ($cli_freq, $acan_freq) = (0,0);
         last;
       }  #push(@locus_hap, $snps[$s]);
     }
     print "$temp[0]\t$temp[1]\t$cli_freq\t$acan_freq\n";
    }
  }
    

  
  

}






#stroring allele into hash for database use
sub hashing {

my ($sub_vcf, $data) = @_;


  foreach $a (@$sub_vcf) {
    $a =~ s/\R//g;
    @temp = split(/\s+/, $a);
  
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
  
  #print "$temp[0] at $temp[1] $snps[$hap[0]] $snps[$hap[1]] $snps[$hap[2]]\n";
  #print "$temp[0] at $temp[1] $locus_hap[0] $locus_hap[1] $locus_hap[2]\n";
  
    if(exists $data{$temp[0]}{$temp[1]}) {
      my @unique_snps = uniq @locus_hap;
      for(my $i = 0; $i < $#unique_snps + 1; $i ++) {
        if(index($unique_snps[$i], "A") != -1 || index($unique_snps[$i], "T") != -1 || index($unique_snps[$i], "G") != -1 || index($unique_snps[$i], "C") != -1) {
          my @temp_alt = split(/,/, $data{$temp[0]}{$temp[1]});
          for(my $in = 0; $in < $#temp_alt + 1; $in ++){
            if($temp_alt[$in] eq $unique_snps[$i]) {
              last;
            }elsif($in == $#unique_snps) {
              $data{$temp[0]}{$temp[1]} = "$data{$temp[0]}{$temp[1]},$unique_snps[$i]";
            }
          }
        }
      }
      
      
    }else{
      my @unique_snps = uniq @locus_hap;

      for(my $i = 0; $i < $#unique_snps + 1; $i ++) {
        if(index($unique_snps[$i], "A") != -1 || index($unique_snps[$i], "T") != -1 || index($unique_snps[$i], "G") != -1 || index($unique_snps[$i], "C") != -1) {
          if(exists $data{$temp[0]}{$temp[1]}) {
            $data{$temp[0]}{$temp[1]} = "$data{$temp[0]}{$temp[1]},$unique_snps[$i]";
          }else{
            $data{$temp[0]}{$temp[1]} = "$unique_snps[$i]";
          }
        }
      }
    }
    #print "hasing $data{$temp[0]}{$temp[1]}\n";
  }

  return %data;
}


