#!/usr/bin/perl
#getting phaseblock length distribution from the results
#perl /scale_wlg_nobackup/filesets/nobackup/ga02470/prevent_from_delete/script/ovelap_bed.pl dir



$dir = $ARGV[0];
push(@trip, ("axx", "axg", "axp"));
push(@dip, ("arg100", "tp", "pss", "cli525", "cli753", "cli948", "pki14", "axw2", "axx500"));
#push(@hookeri,("cli753", "cli525")
#push(@dip_import, ("arg100", "tp", "pss", "cli948", "pki14", "axw2", "axx500"));

@folders = `ls $dir`;

######################method starts################################
$count = 0;
$geneblock_count = 0;
$unphase_port = 0;
$total_length = 0;
$gene_num = 0;
$gene_count = "false";
foreach $a (@folders) {
  $a =~ s/\R//g;
  #print "$a\n";
  @tsv = `ls $dir$a/*.tsv`;
  #print "$tsv[0]\n";
 

  $gene = "gene$a.fasta";
  foreach $t (@trip) {
  
    `cat $dir$a/phased_$t.tsv |grep "#" -v | awk '{if(\$6 > 15) print \$2,\$4,\$5}' OFS='\t' > $dir$a/phased_$t.bed`;
    `sed -i 's/ /\t/g' $dir$a/phased_$t.bed`;
  }
  
  foreach $d (@dip) {
    `cat $dir$a/phased_$d.tsv |grep "#" -v | awk '{print \$2,\$4,\$5}' OFS='\t' > $dir$a/phased_$d.bed`;
    `cat $dir$a/phased_$d.tsv |grep "#" -v | awk '{if(\$6 > 15) print \$2,\$4,\$5}' OFS='\t' > $dir$a/filter_$d.bed`;
    `sed -i 's/ /\t/g' $dir$a/phased_$d.bed`;
  }
  
  `bedtools intersect -a $dir$a/phased_axx.bed -b $dir$a/phased_axp.bed | bedtools intersect -a - -b $dir$a/phased_axg.bed | sort |  uniq -c | awk '{print \$2,\$3,\$4}' | sed 's/ /\t/g' > $dir$a/trips.bed`;
  `bedtools intersect -a $dir$a/filter_arg100.bed -b $dir$a/filter_tp.bed $dir$a/filter_pss.bed $dir$a/filter_cli525.bed $dir$a/filter_cli753.bed $dir$a/filter_cli948.bed $dir$a/filter_pki14.bed $dir$a/filter_axw2.bed $dir$a/filter_axx500.bed |sort -k1,1 -k2,2 | bedtools merge -i - |sed  's/ /\t/g' > $dir$a/dips.bed`;

  
  `bedtools intersect -a $dir$a/trips.bed -b $dir$a/dips.bed > $dir$a/overlap.bed`;
  

  
  
  #`sed --regexp-extended -i s'/\:[0-9]+\-[0-9]+//' $dir$a/overlap.bed`;
  `sed -i 's/ /\t/g' $dir$a/overlap.bed`;
  `sed --regexp-extended s'/\:[0-9]+\-[0-9]+//' $dir$a/$gene > $dir$a/renamed_gene.fasta`;
  #@blocks = `perl /scale_wlg_nobackup/filesets/nobackup/ga02470/prevent_from_delete/script/countN.pl $dir$a/overlap.bed $dir$a/renamed_gene.fasta`;
    
    
}