#!/usr/bin/perl
#getting nucleotide diversity/ heterozygosity for triploid samples 
#perl "/scale_wlg_nobackup/filesets/nobackup/ga02470/prevent_from_delete/script/dip_het_window.pl" test.vcf test.fasta A 1 1

use List::MoreUtils qw(uniq);


($vcf, $fasta, $chr, $size, $slide) = @ARGV;
$start = 1;
$length = `cat $fasta.fai | grep -w '$chr' | awk '{print \$2}'`;

while ($length > $start) {

  $end_bp = $start + $size - 1;

  #print "argument used bcftools view -r $chr:$start-$end_bp $vcf | grep '#' -v\n";
  #my @sample = `cat $vcf | grep "#" -v`;
  my @sample = `bcftools view -H -r $chr:$start-$end_bp $vcf`;
  my @refer = `samtools faidx $fasta $chr:$start-$end_bp | grep ">" -v`;

  
  $Ns = 0;
  my $temp_size = 0; 
  my $temp_nogap = 0;
  for($i = 0; $i < $#refer + 1; $i ++) {
    $Ns += $refere[$i] =~ tr/N//;  
  } 
  

  $diff_count = 0;
  my $pi1 = 0;

  #getting haplotypes from each locus
  foreach $a (@sample) {
    
    my @snps = ();
    my @locus = ();
    $a =~ s/\R//g;
    @temp = split(/\s+/, $a);
    $gap_allele = "false";
    
    my @locus_hap = split(/\:/, $temp[9]);  
  
    if(index($locus_hap[0], "/") != -1) {
      @hap = split(/\//, $locus_hap[0]); 
    }else{
      @hap = split(/\|/, $locus_hap[0]);
    }
    
    my @alt = split(/,/, $temp[4]);
    push(@snps, $temp[3]);
    foreach $s (@alt) {
      push(@snps, $s);
    }
    my @snp_hap = ();
    foreach $s (@hap) {
      push(@snp_hap, $snps[$s]);
      if($snps[$s]=~ tr/N// > 0) {
          $gap_allele = "true";
      } 
    }
    
    #when locus is homozygous
    if($snp_hap[0] eq $snp_hap[1] && $snp_hap[1] eq $snp_hap[2]) {
       #print "$chr\t$start\t 0\n";
    
    #when locus hetertozygous
    }else{
      #only calculate nucleotide diversity when the alleles have the same length and contains no gap
      if(length($snp_hap[0]) eq length($snp_hap[1]) && $gap_allele eq "false") {
        #if haplotypes do not contain gaps, reference genome might have gaps and need to deduct that from the gaps from the window size
        $temp_nogap += $temp[3] =~ tr/N//; 
        my @temp1 = split (//, $snp_hap[0]);
        my @temp2 = split (//, $snp_hap[1]);
  
        
        for(my $l = 0;$l < $#temp1 + 1 ; $l ++) {
          #getting count for pi value
          if($temp1[$l] ne $temp2[$l]) {
            $pi1 ++;
          } 
        
        }
      }
    } 
    
    #getting the pi for each window 

  }
  $result_pi = $pi1/($size - $Ns + $temp_nogap);
   
  #if somthiong went wrong in gap calculation 
  if($size < ($Ns + $temp_nogap)) {
    print "$chr $start: somthing is wrong $size $Ns $temp_nogaps\n";
    last;
  }
  
    #printing out pi for each window  
  print "$chr\t$start\t$result_pi\n";
  $start = $start + $slide;
}