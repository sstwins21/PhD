#!/usr/bin/perl
#counting the length of gaps
#perl /scale_wlg_nobackup/filesets/nobackup/ga02470/prevent_from_delete/script/countN.pl overlap.bed 
$overlap = $ARGV[0];
@temp = split(/\//, $overlap);
$path = "";
for($i = 0; $i < $#temp; $i ++) {
  $path = "$path$temp[$i]/";

}

#print "path: $path\n";


open INFILE, $overlap;
my $count = 0;
my $all = 0;
while (my $line = <INFILE>) {
  $line =~ s/\R//g;
 @temp = split(/\s+/, $line);
  @seq = `samtools faidx "/scale_wlg_nobackup/filesets/nobackup/ga02470/freebayes/gapclosed.fasta.masked" $temp[0]:$temp[1]-$temp[2]`;
  my $count = 0;
  my $all = 0;
  for($i = 1; $i < $#seq + 1; $i ++) {
    $count = $count + $seq[$i] =~ tr/N//;
    $all = $all + length($seq[i]);
  }
  
   $result = $all - $count;
   #my $prop = gettingPort($overlap, "$temp[0]:$temp[1]-$temp[2]");
  print "$temp[0]:$temp[1]-$temp[2] $all $count $result\n";
  
  
  #$count = $count + $line =~ tr/N//;
  #$all = $all + length($line);
}

#print "$all-$count\n";
close INFILE;

sub gettingPort {
  
  ($over, $region) = @_;
  @temp2 = split "over",  $over;
  $folder = join "",$temp2[0],"phased_";

  my @vcf = `ls $path/phased_*.vcf`;


  #print "$over $temp[0]\n";
  my $final = 0;
  foreach $a (@vcf) {
    $a =~ s/\R//g;
    #print "$a\n";
    my @loci = ();
    `bgzip -c $a > $a.gz`;
    `tabix -f $a.gz`;
    @loci = `bcftools view -H $a.gz $region`;
    #print "bcftools view $a.gz $region\n";
    my $count = 0;
    my $unphased = 0;
 
    foreach $locus (@loci) {
      $locus =~ s/\R//g;
      #print "locus: $locus\n";
      my @temp3 = split(/\s+/, $locus);
      if(index($temp3[0], "#") == -1){
        #print "got in\n";
        $count ++;
        @locus = split(/:/, $temp3[9]);
        if(index($locus[0], "/") != -1){
          @hap = split(/\//, $locus[0]);
          if($hap[0] == $hap[1] && $hap[0] == $hap[2] && $hap[1] == $hap[2]) {
          #print "$line\n";
          }else{
            $unphased ++;
          }
        }
      }
    }
    #print "$a $region: $unphased/$count * 100\n";
    if($count == 0) {
     $final = 100;
    }else{
      $final = $final + ($unphased/$count * 100);
    #print "$final\n" 
    }
  }
   # my $out = $unphased/$count * 100;

  $total_sample = $#vcf + 1;
  return 100 - ($final/$total_sample);
  

}