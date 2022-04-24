#!/usr/bin/perl
#algining all the fasta files using MUSCLE
#perl /scale_wlg_nobackup/filesets/nobackup/ga02470/prevent_from_delete/script/muscle_align.pl /scale_wlg_nobackup/filesets/nobackup/ga02470/prevent_from_delete/script/test/output/


my ($dir, $out) = @ARGV;

@folders = `ls $dir`;

foreach $a (@folders) {
  $a =~ s/\R//g;
  @blocks = `ls $dir$a/`;
  print "processing gene $a\n";
  foreach $b (@blocks) {
    $b =~ s/\R//g;
    print "at block: $b\n";
    #`cat $dir$a/$b/*_$a.*.fasta > $dir$a/$b/all_$a.$b.fasta`;
    `rm $dir$a/$b/all*.fasta`;
    @aln  = `ls $dir$a/$b/*.fasta`;
    `> $dir$a/$b/all_$a.$b.fasta`;
    foreach $c (@aln) {
      $c =~ s/\R//g;
      @data = `cat $c`;
      $num = 1;
      foreach $d (@data) {
        $d =~ s/\R//g;
        if(index($d, ">") > -1 ) {
          @temp = split(/\_/, $d);
          `echo "$temp[0].$num" >> $dir$a/$b/all_$a.$b.fasta`;
          $num ++;
      
        }else{
          `echo "$d" >> $dir$a/$b/all_$a.$b.fasta`;
        }
      }
    
    }
    #`cat $dir$a/$b/*.fasta > $dir$a/$b/all_$a.$b.fasta`;
    $check = `ls $dir$a/$b/all*.fasta`;
    $check =~ s/\R//g;
    
    if($check ne "$dir$a/$b/all_$a.$b.fasta") {
      #`cat $dir$a/$b/*.fasta > $dir$a/$b/all_$a.$b.fasta`;
      }
    `sed -i 's/*/N/g' $dir$a/$b/all_$a.$b.fasta`;
    `muscle -in $dir$a/$b/all_$a.$b.fasta -out $out/all_$a.$b.aln`;
    #`rm $dir$a/$b/all_$a.$b.fasta`;
  
  }
}
  