#!/usr/bin/perl
#making unphased heterozygous regions from the vcf file
#perl "/scale_wlg_nobackup/filesets/nobackup/ga02470/prevent_from_delete/script/mask_unphased_dip.pl" vcf


$vcf = $ARGV[0];



open INFILE, $vcf;
while (my $line = <INFILE>) {
  $line =~ s/\R//g;
  my @temp = split(/\s+/, $line);
  if(index($temp[0], "#") == -1){
    #print "got in\n";
  
    @locus = split(/:/, $temp[9]);
    if(index($locus[0], "/") != -1){
      @hap = split(/\//, $locus[0]);
      if($hap[0] == $hap[1]) {
        print "$line\n";
      }else{
        #when unphased region is heterozygous
        my @snps = ();
        push(@snps, $temp[3]);
        if(index($temp[4], ",") != -1){
          my @alt = ();
          @alt = split(/\,/, $temp[4]);
          foreach $a (@alt) {
            push(@snps, $a);
          }
        }else{
          push(@snps, $temp[4]);
        }
      
        #stored all the SNPs found in a locus in @snps array
        $length_diff = "false";
        $len = length($snps[$hap[0]]);
        #length comparison between SNPs
        for($i = 1; $i < $#hap + 1; $i ++) {
          #$temp_len = length($snps[$hap[$i]]);
          #print "comparing $len and $temp_len\n";        
          if( $len != length($snps[$hap[$i]])) {
            $length_diff = "true";
            if( $len < length($snps[$hap[$i]])) {
              $len = length($snps[$hap[$i]]);
            } 
          }
        }
      
        if($length_diff eq "false") {
          print "$line\n";
          #print "length is the same as $snps[$hap[0]] $snps[$hap[1]] $snps[$hap[2]]\n";
         
        }else{      
          for($i = 0; $i < 9; $i ++) {
            if($i == 4) {
              for($n = 0; $n < $len; $n ++) {
                print"N";
              }
              print "\t"
            }else{
              print "$temp[$i]\t";
            }
          }
          print "1/1\n";
        }
      }
  
    }else{ 
      print "$line\n";
    }
  }else{
    print "$line\n";
  }
}