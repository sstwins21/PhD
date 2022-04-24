#!/usr/bin/perl
#making input file for getting regression using the number of synonymous mutation and degree of expression
#input sample and gene list: inermis_1 mito 

($sample, $gene) = @ARGV;

%count = ();


@expression = `cat "/scale_wlg_nobackup/filesets/nobackup/ga02470/RNA/hisat2/gatk/AD/HEB_2/cor/david/R/$sample.exp.txt"`;
@hook = `awk '{if(\$5 != \$6 && \$8 == "hookeri") print \$7}' /scale_wlg_nobackup/filesets/nobackup/ga02470/RNA/hisat2/gatk/AD/HEB_2/new/david/$gene/add_$sample.txt | sort | uniq -c| awk '{print \$2, \$1}'`;
#@hook = `awk '{if(\$5 != \$6) print \$7}' /scale_wlg_nobackup/filesets/nobackup/ga02470/RNA/hisat2/gatk/AD/HEB_2/cor/david/$gene/add_$sample.txt | sort | uniq -c| awk '{print \$2, \$1}'`;
#@hook = `awk '{if(\$5 != \$6 && \$8 == "geisovii") print \$7}' /scale_wlg_nobackup/filesets/nobackup/ga02470/RNA/hisat2/gatk/AD/HEB_2/cor/david/$gene/add_$sample.txt | sort | uniq -c| awk '{print \$2, \$1}'`;



foreach $a (@hook) {
  $a =~ s/\R//g;
  @temp = split(/\s+/, $a);
  #print "$temp[0] $temp[1] $temp[3]\n";
  #print "$a $#temp\n";
  $count{$temp[0]} = $temp[1];

}




foreach $a (@expression) {
  $a =~ s/\R//g;
  @temp = split(/\s+/, $a);
  print "$a\t";

  
  if(exists($count{$temp[0]})) {  
    #print "got in \n";
    print "$count{$temp[0]}\n";
  }else{
    print "0\n";
  }

}