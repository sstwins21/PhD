#!/usr/bin/perl
#counting allele freq of Clitarchus and Acanthoxyla in triplod sample
#perl "/scale_wlg_nobackup/filesets/nobackup/ga02470/prevent_from_delete/script/cli_acan_allele.pl" 

use List::MoreUtils qw(uniq);

 

#my ($vcf, $vcf2, $target_vcf) = @ARGV;
my %data;
my %ances;
my ($in_list, $out_list) = @ARGV;
@cli_list = `cat $in_list`;
@sample_list = `cat $out_list`;


$sample_temp = `bcftools view -h "/scale_wlg_nobackup/filesets/nobackup/ga02470/RNA/hisat2/gatk/non_miss.vcf" | grep "CHROM"`;
#$sample_temp = `grep "CHROM" "/scale_wlg_nobackup/filesets/nobackup/ga02470/prevent_from_delete/script/RNA/test/test.vcf"`;
$sample_temp =~ s/\R//g;
#print "$sample_temp\n";
@temp  = split(/\s+/, $sample_temp);

for($i = 9; $i < $#temp + 1; $i ++) {
  foreach $a (@cli_list) {
    $a =~ s/\R//g;
    #print "cli: $a\n";
    if($a eq $temp[$i]) {
      #print "cli: $a\n";
      push(@cli_sample, $i);
      last; 
    }
  }
  
  foreach $a (@sample_list) {
    $a =~ s/\R//g;
    if($a eq $temp[$i]) {
      #print "tar: $a\n";
      push(@tar_sample, $i);
      last; 
    }
  }
}

#compare(\@cli_sample, \@tar_sample);
compare();





#comparing given loci with data hash to see if it present or not. printing out $pos $cli_freq $acan_freq
sub compare {

  #my ($cli_sample, $tar_sample) = @_;
  
  
  @vcf = `bcftools view -H "/scale_wlg_nobackup/filesets/nobackup/ga02470/RNA/hisat2/gatk/non_miss.vcf"`;
  #@vcf = `grep "#" -v "/scale_wlg_nobackup/filesets/nobackup/ga02470/prevent_from_delete/script/RNA/test/test.vcf"`;
  #print "got in: $cli_sample[0], $tar_sample[0]\n";
  foreach $a (@vcf) {
   
    $a =~ s/\R//g;
    @temp = split(/\s+/, $a);
    #print "got into $temp[0] at $temp[1]\n";
    my @alt = split(/,/, $temp[4]);
    my @cli_allele = ();
    my @tar_allele = ();
    
    
   foreach $b (@cli_sample) {
     @locus = split(/:/, $temp[$b]);
     
     if(index($locus[0], "/") != -1){
       @hap = split(/\//, $locus[0]);
       #print "$hap[0], $hap[1]\n";
     }else{
       @hap = split(/\|/, $locus[0]);
     }
     

     foreach $c (@hap) {
       if($c ne ".") {
         push(@cli_allele, $c);
       }
     }
   }
   
   my @unique_cli = uniq @cli_allele;
   
   #print "$#unique_cli\n";
   
   
   foreach $b (@tar_sample) {
     $needPrint = "false";
     ($cli_freq, $tar_freq) = (0,0);
     @locus = split(/:/, $temp[$b]);
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
         $DP = $locus[$x];
       }
     }
     
     foreach $c (@hap) {
       if($c ne ".") {
         push(@tar_allele, $c);
       } 
     }
     my @unique_tar = uniq @tar_allele;
     
     if($#unique_tar > 0 && $DP > 0) {
       $needPrint = "true";
        
       foreach $c (@unique_tar) {
         $found = "false";
         $final_AD = $hap_AD[$c]/$DP;
         foreach $d (@unique_cli) {
           
           if($c eq $d) {
             
             $cli_freq = $cli_freq + $final_AD;
             #print "cli_AD: $hap_AD[$d]\n";
             $found = "true";
             last
           
           }
         
         }
         if($found eq "false") {
           #print "tar_AD: $hap_AD[$d]\n";
           $tar_freq = $tar_freq + $final_AD;
         }
       }  
     }
     
     
     if($needPrint eq "true") {
       print "$cli_freq\t$tar_freq\n";
     }
   }
  }
}


