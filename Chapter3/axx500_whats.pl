#!/usr/bin/perl
#running sample to whatshap in parallel
#commandL perl "/scale_wlg_nobackup/filesets/nobackup/ga02470/prevent_from_delete/script/whatshap_slurm_trip.pl" "/scale_wlg_nobackup/filesets/nobackup/ga02470/freebayes/lowCov/freebayes_3/whatshap/busco/all/list.tsv" "/scale_wlg_nobackup/filesets/nobackup/ga02470/freebayes/lowCov/freebayes_3/whatshap/busco/all/slurm/" /scale_wlg_nobackup/filesets/nobackup/ga02470/freebayes/lowCov/freebayes_3/whatshap/busco/all/both_indel/


$wrkdir = $ARGV[0];

@genes = `cat "/scale_wlg_nobackup/filesets/nobackup/ga02470/freebayes/freebayes/filtered/q20/100_busco.bed"`;

for($i = 0; $i < $#genes + 1; $i ++) {
  #`mkdir $wrkdir/$i/`;
  
  $genes[$i] =~ s/\R//g;
  my @temp = split(/\s+/, $genes[$i]);
  my $name = join "","gene", $i; 
  my $output = join "", $wrkdir, "/slurm/dip_", $name, ".sl";
  my $dir = join "", $wrkdir,$i, "\/";
  my $scaff = join "", $temp[0], "\:", $temp[1],"-", $temp[2];
  $mini = "mini_";

 
  print "preparing gene$i\n";
  #`samtools faidx /scale_wlg_nobackup/filesets/nobackup/ga02470/freebayes/gapclosed.fasta.masked $scaff \> $dir$name.fasta`;
  #`samtools faidx $dir$name.fasta`;
  


  `bcftools view "/scale_wlg_nobackup/filesets/nobackup/ga02470/freebayes/freebayes_2/q20/axx500.vcf.gz" -r $scaff > $dir/axx500.vcf`;
  `bcftools view "/scale_wlg_nobackup/filesets/nobackup/ga02470/freebayes/freebayes_2/q20/axw2.vcf.gz" -r $scaff > $dir/axw2.vcf`;
  `bcftools view "/scale_wlg_nobackup/filesets/nobackup/ga02470/freebayes/freebayes_2/q20/cli753.vcf.gz" -r $scaff > $dir/cli753.vcf`;


  unless(open FILE, '>'.$output) {
	  # Die with error message 
	  # if we can't open it.
  	die "nUnable to create $result/n";
  }

  print FILE "#!/bin/bash -e\n";
  print FILE "#SBATCH -J raw_dip$name\n";
  print FILE "#SBATCH -A ga02470\n";
  print FILE "#SBATCH --ntasks=1\n";
  print FILE "#SBATCH --cpus-per-task=1\n";
  print FILE "#SBATCH --mem=10G\n";
  print FILE "#SBATCH --time=48:00:00\n";
  print FILE "#SBATCH --hint=nomultithread\n";
  print FILE "#SBATCH -o $output.txt\n";
  print FILE "#SBATCH -e $output.err\n";
  print FILE "#SBATCH --mail-type=FAIL\n";
  print FILE "#SBATCH --mail-user=scho249\@aucklanduni.ac.nz\n";
  print FILE "#SBATCH --chdir=$dir\n\n";
  
  
  print FILE "/scale_wlg_nobackup/filesets/nobackup/ga02470/prevent_from_delete/software/condaEnv/whatshap/bin/whatshap phase -o phased_axx500.vcf --reference /scale_wlg_nobackup/filesets/nobackup/ga02470/freebayes/gapclosed.fasta.masked axx500.vcf /scale_wlg_nobackup/filesets/nobackup/ga02470/freebayes/map/dupRem_axx500.bam --indels\n";

  print FILE "/scale_wlg_nobackup/filesets/nobackup/ga02470/prevent_from_delete/software/condaEnv/whatshap/bin/whatshap stats --block-list=phased_axx500.tsv --gtf=phased_axx500.gtf phased_axx500.vcf\n";
  
    print FILE "/scale_wlg_nobackup/filesets/nobackup/ga02470/prevent_from_delete/software/condaEnv/whatshap/bin/whatshap phase -o phased_axw2.vcf --reference /scale_wlg_nobackup/filesets/nobackup/ga02470/freebayes/gapclosed.fasta.masked axw2.vcf /scale_wlg_nobackup/filesets/nobackup/ga02470/freebayes/map/dupRem_axw2.bam --indels\n";

  print FILE "/scale_wlg_nobackup/filesets/nobackup/ga02470/prevent_from_delete/software/condaEnv/whatshap/bin/whatshap stats --block-list=phased_axw2.tsv --gtf=phased_axw2.gtf phased_axw2.vcf\n";
  
  print FILE "/scale_wlg_nobackup/filesets/nobackup/ga02470/prevent_from_delete/software/condaEnv/whatshap/bin/whatshap phase -o phased_cli753.vcf --reference /scale_wlg_nobackup/filesets/nobackup/ga02470/freebayes/gapclosed.fasta.masked cli753.vcf /scale_wlg_nobackup/filesets/nobackup/ga02470/freebayes/map/dupRem_cli753.bam --indels\n";

  print FILE "/scale_wlg_nobackup/filesets/nobackup/ga02470/prevent_from_delete/software/condaEnv/whatshap/bin/whatshap stats --block-list=phased_cli753.tsv --gtf=phased_cli753.gtf phased_cli753.vcf\n";

}

