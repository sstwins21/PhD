#!/usr/bin/perl
#getting consensus file from phased vcf inlcuding unphased region as ambibuous
#perl "/scale_wlg_nobackup/filesets/nobackup/ga02470/prevent_from_delete/script/trpvcf2cons.pl" fasta vcf scaff

use Bio::SeqIO;


my ($fasta, $vcf, $scaff, $name) = @ARGV;

#@vcf = `bcftools view $vcf $scaff | grep "#" -v`;
@vcf = `cat $vcf | grep "#" -v`;
#print "bcftools view $vcf $scaff\n";
#print "first locus $vcf[0]\n";
@region = split(/\:/, $scaff);
@border = split(/\-/,$region[1]);
#stroing start position as previous position
$prev = $border[0];
$ref  = Bio::SeqIO->new(-file => $fasta , -format => 'Fasta');
my $seq = $ref->next_seq();

my ($hap1, $hap2, $hap3) = "";
foreach $a (@vcf) {
 
  $a=~ s/\R//g;
  @temp = split(/\s+/, $a);
  
  #if previous pos is at earlier than current locus pos
  if($prev < $temp[1]) {
    #print "prev: $prev $temp[1] -1\n";
    $hap1 = join "",$hap1,$seq->subseq($prev,$temp[1] -1);
    $hap2 = join "",$hap2,$seq->subseq($prev,$temp[1] -1);
    $hap3 = join "",$hap3,$seq->subseq($prev,$temp[1] -1);
    #print "",$seq->subseq($prev,$temp[1]-1), "\n";
  }
  $prev = length($temp[3]) + $temp[1];
  my @snps = ();
  push(@snps, $temp[3]);
  #print "$temp[3] $temp[4]\n";
  if(index($temp[4], ",") != -1){
    my @alt = ();
    @alt = split(/\,/, $temp[4]);
    foreach $b (@alt) {
      push(@snps, $b);
    }
  }else{
    push(@snps, $temp[4]);
  }
      
  my @locus = split(/\:/, $temp[9]);  
  #print "locus: $locus[0]\n";
  if(index($locus[0], "/") != -1) {
    @hap = split(/\//, $locus[0]); 
    #print "got into unphased $temp[1] $hap[0] $hap[1] $hap[2]\n";
  }else{
    @hap = split(/\|/, $locus[0]);
    #print "got into phased $temp[1] $hap[0] $hap[1] $hap[2]\n"; 
  }   
  
  #@hap = split(/\//, $locus[0]);  
  #if the locus is phased or homozyous
  if(index($a, "/") == -1 || ($snps[$hap[0]] eq $snps[$hap[1]] && $snps[$hap[0]] eq $snps[$hap[2]] && $snps[$hap[1]] eq $snps[$hap[2]])){
    #print "het $snps[0] $snps[1] $snps[$hap[0]] $snps[$hap[1]] $snps[$hap[2]] hap: $hap[0]\n";

    $hap1 = join "",$hap1,$snps[$hap[0]];
    $hap2 = join "",$hap2,$snps[$hap[1]];
    $hap3 = join "",$hap3,$snps[$hap[2]];
    #print "got in: $hap[0] $hap[1] $hap[2] $snps[$hap[0]] $snps[$hap[1]] $snps[$hap[2]] \n";
  
  }else{
    #if the locus is not phased and heterozygous
    my @temp1 = @arr=split (//, $snps[$hap[0]]);
    my @temp2 = @arr=split (//, $snps[$hap[1]]);
    my @temp3 = @arr=split (//, $snps[$hap[2]]);
    #print "locus length $#temp1\n";
    

    for($i = 0; $i < $#temp1 + 1; $i ++) {
    #print "bases $temp1[$i]$temp2[$i]$temp3[$i]\n";
    $hap1 = join "",$hap1,ambiguous("$temp1[$i]$temp2[$i]$temp3[$i]");
    $hap2 = join "",$hap2,ambiguous("$temp1[$i]$temp2[$i]$temp3[$i]");
    $hap3 = join "",$hap3,ambiguous("$temp1[$i]$temp2[$i]$temp3[$i]"); 
    }


  }
}

if($prev - 1< $border[1]) {
  $hap1 = join "",$hap1,$seq->subseq($prev,$border[1]);
  $hap2 = join "",$hap2,$seq->subseq($prev,$border[1]);
  $hap3 = join "",$hap3,$seq->subseq($prev,$border[1]);
  #print "prev is $prev to $border[1]\n";
  #print "",$seq->subseq($prev,$border[1]), "\n";
}

print ">$name\n$hap1\n";


sub ambiguous {
   
  if(index($_[0], "A") != -1) {
  
    if(index($_[0], "T") != -1) {
      
      if(index($_[0], "G") != -1) {
        return "D";
      }elsif(index($_[0], "C") != -1){
        return "H";
      }
      return "W";
      
    }elsif(index($_[0], "G") != -1) {
      if(index($_[0], "C") != -1) {
        return "V";
      }
      return "R";
    }elsif(index($_[0], "C") != -1) {
      return "M";
    }
    return "A";
  }elsif(index($_[0], "T") != -1) {
      
      if(index($_[0], "G") != -1) {
        if(index($_[0], "C") != -1) {
          return "B";
        }
        return "K";
        
      }elsif(index($_[0], "C") != -1) {
        return "Y";
      }
    return "T";
  }elsif(index($_[0], "G") != -1 ) {
    if(index($_[0], "C") != -1) {
      return "S";
    }
    return "G";
  }elsif(index($_[0], "C") != -1 ) {
    return "C";
  }
  return "*";
}
