#!/usr/bin/perl
#getting SNPs from gene list and snpeff annotation
use List::MoreUtils qw(uniq);


($gene, $name) = @ARGV;

@gene_list = `cat $gene`;
@region = ();
%annot = ();
#getting sample index from header

@cli_list = `cat "/scale_wlg_nobackup/filesets/nobackup/ga02470/RNA/hisat2/gatk/hookeri.txt"`;
@acan_list = `cat "/scale_wlg_nobackup/filesets/nobackup/ga02470/RNA/hisat2/gatk/geisovii.txt"`;
@sample_list = `cat "/scale_wlg_nobackup/filesets/nobackup/ga02470/RNA/hisat2/gatk/$name.txt"`;


$sample_temp = `grep "CHROM" "/scale_wlg_nobackup/filesets/nobackup/ga02470/RNA/hisat2/gatk/annot_RNA.vcf"`;
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
      #print "acan: $a\n";
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


#getting annotations from snpeff vcf file
@vcf = `grep "#" -v "/scale_wlg_nobackup/filesets/nobackup/ga02470/RNA/hisat2/gatk/annot_RNA.vcf"`;

foreach $a (@vcf) {
  $a =~ s/\R//g;
  @temp = split(/\s+/, $a);
  
  $annot{$temp[0]}{$temp[1]} = $a;
  
}


foreach $a (@gene_list) {
   $a =~ s/\R//g;
   $bed = `grep -w "$a" "/scale_wlg_nobackup/filesets/nobackup/ga02470/Kate/gene.bed"`;
   $bed =~ s/\R//g;
   
   if($bed eq "") {
     print "somthing is wrong at getting gene region\n";
   }else{
     #print "$bed\n";
     @temp = split(/\s+/, $bed);
     @tar_region = `awk '{if("$temp[0]" == \$1 && \$2 >= $temp[1] && \$2 <= $temp[2]) print \$1, \$2}' /scale_wlg_nobackup/filesets/nobackup/ga02470/RNA/hisat2/gatk/AD/HEB_2/$name.txt`;
     
     foreach $b (@tar_region) {
       $b =~ s/\R//g;
       @annot_tar = ();
       print "$b\t";
       
       @temp2 = split(/\s+/, $b);
       @temp3 = split(/\s+/,$annot{$temp2[0]}{$temp2[1]});
       
       my @alt = split(/,/, $temp3[4]);
       my @cli_allele = ();
       my @acan_allele = ();
       my @tar_allele = ();
       my @annot_temp = split(/=/, $temp3[7]);      
       #print "annotation: $annot_temp[-1]\n";
       my @annot = split(/,/, $annot_temp[-1]);
       
       push(@annot_tar, "synonymous_variant");
       foreach $c (@annot) {
         @temp4 = split(/\|/, $c);
         #print "$temp4[1]  ";
         push(@annot_tar, $temp4[1]);
       }
       #print "\n";
    
    
       foreach $c (@cli_sample) {
         @locus = split(/:/, $temp3[$c]);
     
         if(index($locus[0], "/") != -1){
           @hap = split(/\//, $locus[0]);
         #print "$hap[0], $hap[1]\n";
         }else{
           @hap = split(/\|/, $locus[0]);
         }
     
        
         foreach $d (@hap) {
           if($d ne ".") {
             push(@cli_allele, $d);
           }
         }
      }
   
      foreach $c (@acan_sample) {
        #print "acan: $c\n";
        @locus = split(/:/, $temp3[$c]);
      
        if(index($locus[0], "/") != -1){
          @hap = split(/\//, $locus[0]);
        #print "$hap[0], $hap[1]\n";
        }else{
          @hap = split(/\|/, $locus[0]);
        }  
      
 
        foreach $d (@hap) {
       
          if($d ne ".") {
            push(@acan_allele, $d);
          }
        }
      }
    
    
    
      my @unique_cli = uniq @cli_allele;
      my @unique_acan = uniq @acan_allele;
      #print " cli: ";
      foreach $c (@unique_cli) {
        #print " $c";
      }
      #print " acan: ";
      foreach $c (@unique_acan) {
        #print " $c";
      }
      
      foreach $c (@tar_sample) {
        @locus = split(/:/, $temp3[$c]);
     
       if(index($locus[0], "/") != -1){
         @hap = split(/\//, $locus[0]);
         #print "$hap[0], $hap[1]\n";
       }else{
         @hap = split(/\|/, $locus[0]);
       }
       foreach $c (@hap) {
         if($c ne ".") {
           push(@tar_allele, $c);
         } 
       }
      }
      my @unique_tar = uniq @tar_allele;
      
      @cli_annot = ();
      @acan_annot = ();
      
      #print " sample: ";
        foreach $c (@unique_tar) {
          #print " $c";
          
          foreach $d (@unique_cli) {
            if($d eq $c) {
              push(@cli_annot, $annot_tar[$d]);
              }else{
              push(@acan_annot, $annot_tar[$d]);
            }
          }
     
        }
      
        if($#cli_annot == -1) {
          print "\tno_allele"
         }else{
           print "\t$cli_annot[0]";
           for($u = 1;$u < $#cli_annot; $u ++) {
             print ",$cli_annot[$u]";
           }
         }
         
         if($#acan_annot == -1) {
           print "\tno_allele";
         }else{
           print "\t$acan_annot[0]";
           for($u = 1;$u < $#acan_annot; $u ++) {
             print ",$acan_annot[$u]";
           }
         }
        
        
      print "\t$annot_tar[$unique_cli[0]]";
      for($u = 1; $u < $unique_cli +1; $u ++) {
        print ",$annot_tar[$unique_cli[$u]]";
      }
    
           
     
      
      print "\t$annot_tar[$unique_acan[0]]";
      for($u = 1; $u < $unique_acan +1; $u ++) {
        print ",$annot_tar[$unique_acan[$u]]";
      }
    
      print "\t$a\n";     
    }

     
   }

}