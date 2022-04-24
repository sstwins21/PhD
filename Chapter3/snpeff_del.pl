#!/usr/bin/perl
#getting identifying the deleterious mutation and its heterozygosity 
use List::MoreUtils qw(uniq);
use List::Util qw(first);


($vcf, $type) = @ARGV;


if($type eq "gatk") {
  $annot_index = 15;

}elsif($type eq "freebayes") {
  $annot_index = 43;

}else{
  print "Something wrong\n";
}

%gene = ();



open(my $in, '<:encoding(UTF-8)', $vcf)
or die "Could not open file '$vcf' $!";
 
while (my $line = <$in>) {
  chomp $line;

  @temp = split(/\s+/, $line);
  @annot_temp = split(/=/, $temp[7]); 
  #print "$#annot_temp\n";
  @annot = split(/,/, $annot_temp[$annot_index]);
  
  @info = split(/\:/, $temp[9]);
  if(index($info[0], "/") != -1) {
    @hap = split(/\//, $info[0]); 
  }else{
    @hap = split(/\|/, $info[0]);
  }
       #my @hap =  split(/\//, $info[0]);
  my @uniq = uniq @hap;
  
  
  @annot_tar = ();
  push(@annot_tar, "synonymous_variant");
  foreach $c (@annot) {
    @temp4 = split(/\|/, $c);
    #print "$temp4[3]  ";
    push(@annot_tar, $temp4[1]);
  }
  
  if(index($temp4[3], "-") == -1 ) {
    if(!exists($gene{$temp4[3]})) {
      $gene{$temp4[3]} = "annotated";
    }
    #print "$temp4[3]\n";
    #print "$temp[7]\n\n";
    @annot_locus = ();
    foreach $a(@uniq) {
      if($annot_tar[$a] eq "start_lost" || $annot_tar[$a] eq "stop_gained" || $annot_tar[$a] eq "stop_lost" || $annot_tar[$a] eq "exon_loss_variant") {
      push(@annot_locus, $annot_tar[$a]);
      }
    }
    if($#annot_locus > -1) {
      #print "got in \n";
      if($#uniq > $#annot_locus) {
        
        if($gene{$temp4[3]} ne "hom") {
          $gene{$temp4[3]} = "het";
        }
      
      }elsif($#uniq == $#annot_locus) {
        #print "got in \n";
        $gene{$temp4[3]} = "hom";
      
      }
      
    }
    
  }
}

($het, $hom ) = (0,0);
$size = keys %gene;
foreach my $key (keys %gene) {

  if($gene{$key} eq "het") {
    $het ++;
  }elsif($gene{$key} eq "hom") {
    $hom ++;
  }
}

$final_het = $het/$size;
$final_hom = $hom/$size;

print "het: $final_het\nhom: $final_hom\n";