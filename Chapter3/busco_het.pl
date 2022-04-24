#!/usr/bin/perl
#busco het 



use List::MoreUtils qw(uniq);

$sample_temp = `bcftools view -h $ARGV[0] | grep "CHROM"`;
#$sample_temp = `grep "CHROM" $ARGV[0]`;
$sample_temp =~ s/\R//g;
#print "$sample_temp\n";
@temp  = split(/\s+/, $sample_temp);

print "Gene";
$sample_num = 0;
for($i = 9; $i < $#temp + 1; $i ++) {
  $sample_num ++;
  print "\t$temp[$i]"
}

print "\n";


@gene = `cat "/scale_wlg_nobackup/filesets/nobackup/ga02470/freebayes/busco/run_insecta_odb10/BUSCO_complete.bed"`;

foreach $a (@gene) {
  $a =~ s/\R//g;
  @temp = split(/\s+/, $a);
  $length = $temp[2] - $temp[1]; 
  $scaff = "$temp[0]:$temp[1]-$temp[2]";
  $gene_ID = $temp[3];
  
  @region = `bcftools view -H $ARGV[0] $scaff`;
  @het = ();
  for($i = 0; $i < $sample_num; $i ++) {
    #print "pushing $i sample\n";
    push(@het , 0);
  
  }
  
  foreach $b (@region) {
    #print "$b";
    $b =~ s/\R//g;
    @temp = split(/\s+/, $b);
    
    for($i = 9; $i < $#temp + 1; $i ++) {
      my @locus_hap = split(/\:/, $temp[$i]);  
  
      if(index($locus_hap[0], "/") != -1) {
        @hap = split(/\//, $locus_hap[0]); 
      }else{
        @hap = split(/\|/, $locus_hap[0]);
      }
      
      
      my @uniq_hap = uniq @hap;
      
      if($#uniq_hap > 0) {
        $het[$i-9] ++;
      
      }
    
    }
    
  
  }
  #print "$#temp $#het\n";
  print "$gene_ID";
  foreach $b (@het) {
  $result = $b/$length; 
  print "\t$result";
  }
  
  #print "\t$het[12]\n";
  print "\n";

}

