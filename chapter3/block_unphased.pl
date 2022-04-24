#!/usr/bin/perl
#calculating phased statistics for each phase blocks for evaluation
#perl "/scale_wlg_nobackup/filesets/nobackup/ga02470/prevent_from_delete/script/unphased_prop.pl" /scale_wlg_nobackup/filesets/nobackup/ga02470/prevent_from_delete/script/test/whatshap/

my $dir = $ARGV[0];

@folders = `ls $dir`;
my ($totalN, $totalAmb, $totalPha) = 0;


foreach $a (@folders) {
  $a =~ s/\R//g;
  #getting the phased blocks from each gene
  @overlap = `perl /scale_wlg_nobackup/filesets/nobackup/ga02470/prevent_from_delete/script/countN.pl $dir$a/overlap.bed $dir$a/renamed_gene.fasta`;

  my $index = 0;
  #@overlap = `cat $dir/$a/overlap.bed`;
  foreach $b (@overlap) {
    $b =~ s/\R//g;
    my @temp = split(/\s+/, $b);
  
    if($temp[3] > 300) {
      #print "$temp[3]\n";
      #print "$b\n";
      my @vcf = ();
      my ($blockN, $blockAmb, $blockPha) = 0;
      push(@vcf, "$dir/$a/masked_axg.vcf.gz");
      push(@vcf, "$dir/$a/masked_axx.vcf.gz");
      push(@vcf, "$dir/$a/masked_axp.vcf.gz");
    
      foreach $v (@vcf) {
       my @loci = ();
       my ($N, $Amb, $Pha) = 0;
       @loci = `bcftools view $v $temp[0] | grep "#" -v `;
     
       foreach $l (@loci) {
         $l =~ s/\R//g;
         my @temp1 = split(/\s+/, $l);
       
         #getting SNPs information 
         my @snps = ();
         push(@snps, $temp1[3]);
         if(index($temp1[4], ",") != -1){
           my @alt = ();
           @alt = split(/\,/, $temp1[4]);
           foreach $b (@alt) {
             push(@snps, $b);
           }
         }else{
           push(@snps, $temp1[4]);
         }
      
        #getting haplotype for each locus
        my @locus = split(/\:/, $temp1[9]);  
          #print "locus: $locus[0]\n";
        if(index($locus[0], "/") != -1) {
          @hap = split(/\//, $locus[0]); 

        }else{
          @hap = split(/\|/, $locus[0]);

        }
      
      
        if(index("$snps[$hap[0]]$snps[$hap[1]]$snps[$hap[2]]", "N") != -1) {
        
          $N ++;
        } elsif(index($locus[0], "|") != -1 || ($snps[$hap[0]] eq $snps[$hap[1]] && $snps[$hap[0]] eq $snps[$hap[2]] && $snps[$hap[1]] eq $snps[$hap[2]])) {
        #print "$hap[0]$hap[1]$hap[2] $snps[$hap[0]]$snps[$hap[1]]$snps[$hap[2]]\n";
        
          $Pha ++;
        
        }else {
          $Amb ++;
        }
      
         
       
       }
       $blockN = $blockN + ($N/($N+$Amb+$Pha));
       $blockAmb = $blockAmb + ($Amb/($N+$Amb+$Pha));
       $blockPha = $blockPha +  ($Pha/($N+$Amb+$Pha));
      }
      $blockN = ($blockN/3) * 100;
      $blockAmb = ($blockAmb/3) * 100;
      $blockPha = ($blockPha/3) * 100;
      print "$a.$index,$blockN,$blockAmb,$blockPha,$temp[3]\n";
      $index ++;
    }
  }
  
}




