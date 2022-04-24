#!/usr/bin/perl
#counting allele freq of Clitarchus and Acanthoxyla in triplod sample


use List::MoreUtils qw(uniq);

 

#my ($vcf, $vcf2, $target_vcf) = @ARGV;
my %data;
my %ances;
my ($in_list, $in2_list, $out_list) = @ARGV;
@cli_list = `cat $in_list`;
@acan_list = `cat $in2_list`;
@sample_list = `cat $out_list`;


$sample_temp = `bcftools view -h "/scale_wlg_nobackup/filesets/nobackup/ga02470/RNA/28s/gatk/filtered_RNA.vcf.gz" | grep "CHROM"`;
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
  
   foreach $a (@acan_list) {
    $a =~ s/\R//g;
    if($a eq $temp[$i]) {
      #print "tar: $a\n";
      push(@acan_sample, $i);
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
  
  
  @vcf = `bcftools view -H "/scale_wlg_nobackup/filesets/nobackup/ga02470/RNA/28s/gatk/filtered_RNA.vcf.gz"`;
  #@vcf = `grep "#" -v "/scale_wlg_nobackup/filesets/nobackup/ga02470/prevent_from_delete/script/RNA/test/test.vcf"`;
  #print "got in: $cli_sample[0], $tar_sample[0]\n";
  foreach $a (@vcf) {
    ($cli_freq, $tar_freq, $acan_freq, $common) = (0,0,0,0);
    $a =~ s/\R//g;
    @temp = split(/\s+/, $a);
    #print "got into $temp[0] at $temp[1]\n";
    my @alt = split(/,/, $temp[4]);
    my @cli_allele = ();
    my @acan_allele = ();
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
   
   foreach $b (@acan_sample) {
     @locus = split(/:/, $temp[$b]);
     
     if(index($locus[0], "/") != -1){
       @hap = split(/\//, $locus[0]);
       #print "$hap[0], $hap[1]\n";
     }else{
       @hap = split(/\|/, $locus[0]);
     }
     

     foreach $c (@hap) {
       if($c ne ".") {
         push(@acan_allele, $c);
       }
     }
   }
   
   
   
   my @unique_cli = uniq @cli_allele;
   my @unique_acan = uniq @acan_allele;
   
   #print "$#unique_cli\n";
   
   
   foreach $b (@tar_sample) {
     $needPrint = "false";
     #($cli_freq, $tar_freq, $acan_freq, $common) = (0,0,0,0);
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
     
   
     
       
      foreach $c (@unique_tar) {
        $cli_found = "false";
        $acan_found = "false";
        $final_AD = $hap_AD[$c];
        foreach $d (@unique_cli) {
          
          if($c eq $d) {
            
            #$cli_freq = $cli_freq + $final_AD;
            #print "cli_AD: $hap_AD[$d]\n";
            $cli_found = "true";
            last
          
          }
        
        }
        
        foreach $d (@unique_acan) {
          
          if($c eq $d) {
            
            #$cli_freq = $cli_freq + $final_AD;
            #print "cli_AD: $hap_AD[$d]\n";
            $acan_found = "true";
            last
          
          }
        
        }
        
        
        if($acan_found eq "true" && $cli_found eq "true") {
          #print "tar_AD: $hap_AD[$d]\n";
          $common = $common + $final_AD;
        }elsif($acan_found eq "true") {
          $acan_freq = $acan_freq + $final_AD;
        }elsif($cli_found eq "true") {
          $cli_freq = $cli_freq + $final_AD;
        }else{
        
          $tar_freq = $tar_freq + $final_AD;
        
        }
      }  
   }
     if($common == 0 && ($#unique_acan > -1 || $tar_freq > 0 ) && $#unique_cli > -1) {
       $final_acan = $acan_freq + $tar_freq;
       $final_dp = $final_acan + $cli_freq;
     #print "$#unique_acan $#unique_cli\n";
       print "$temp[0]\t$temp[1]\t$common\t$cli_freq\t$final_acan\t$final_dp\n";
     }else{
       #print "$common\n";
     
     }
  }
}


