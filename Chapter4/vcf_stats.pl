#!/usr/bin/perl
#getting stats for vcf file
use List::MoreUtils qw(uniq);
use List::Util qw(first);


@sample = ();
@present = ();
@het = ();

$temp = `bcftools view -h $ARGV[0] | grep "CHROM"`;
$temp =~ s/\R//g;


  @temp2 = split(/\s+/, $temp);
for($i = 9; $i < $#temp2 + 1; $i ++) {
  
  push(@sample, $temp2[$i]);
  push(@present, 0);
  push(@het, 0);


}

@data = `bcftools view -H $ARGV[0]`;

foreach $a (@data) {

  $a =~ s/\R//g;
  @temp = split(/\s+/, $a);
  
  for($i = 9; $i < $#temp + 1; $i ++) {
    
    my @info = split(/\:/, $temp[$i]);
    
    if(index($info[0] , "/") > -1) {
      @hap =  split(/\//, $info[0]);
      #print "gotin 1: $hap[0] $hap[1]\n"
    
    }else{
      @hap =  split(/\|/, $info[0]);
      #print "gotin 2: $hap[0] $hap[1]\n"
    }
    if($hap[0] eq ".") {
       
    }else{
      $present[$i-9] = $present[$i-9] + 1;
      my @uniq = uniq @hap;
      if($#uniq > 0) {
        $het[$i-9] = $het[$i-9] + 1;
      }  
      
    }
  
  }


}

print "sampleID\tRawReads\tmap_rate\tHet\tprop_present\n";
for($i = 0; $i < $#sample + 1; $i ++) {
  
  @map = `cat /scale_wlg_nobackup/filesets/nobackup/ga02470/RNA/hisat2/slurm/$sample[$i].err`;
  $map[6] =~ s/\R//g;
  @temp = split(/\s+/, $map[6]);
  $total_reads = $temp[0];
  $map[20] =~ s/\R//g;
  @temp = split(/\s+/, $map[20]);
  $rate = $temp[0];
  
  $result_het = $het[$i]/$present[$i];
  $result = $present[$i]/($#data + 1);
  print "$sample[$i]\t$total_reads\t$rate\t$result_het\t$result\n";

}