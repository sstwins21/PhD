open (my $fh, "<" . $ARGV[0]);

sub  trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };

while (<$fh>) {
  chomp;
  my ($landmark, $src, $type, $start, $end, $dot, $strand, $phase, $annotations) = split /\t/;
  if ($type eq 'mRNA') {
    $annotations =~ /ID=(.+?)(;|\z)/;
    my $id = $1;
    my $data = `grep $id "/scale_wlg_nobackup/filesets/nobackup/ga02470/freebayes/annotation/evaluation/egg/egg_result_test.emapper.annotations"`;
    $data =~ s/,/%2C/g;
    $data =~ s/;/%3B/g;
    $data =~ s/=/%3B/g;
    chomp($data);
     my ($query_name, $seed_ortholog, $evalue, $score, $eggnog_ogs,
        $max_annot_lvl, $cog_category, $free_text_description, $predicted_protein_name,
        $go_terms, $ec_number, $kegg_ko, $kegg_pathway, $kegg_module, $kegg_reaction,
        $kegg_rclass, $brite, $kegg_tc, $vazy, $bigg_rxn, $pfams) = split(/\t/, $data);
        
    unless($predicted_protein_name =~ /^\s*$/) {
      $annotations .= ";Alias=" . $predicted_protein_name;
    }

    unless($go_terms =~ /^\s*$/) {
      $annotations .= ";GO=" . $go_terms;
    }

    unless($ec_number =~ /^\s*$/) {
      $annotations .= ";EC=" . $ec_number;
    }

    unless($free_text_description =~ /^\s*$/) {
      $annotations .= ";Description=" . $free_text_description;
      $annotations .= ";eggNOG_Annotation=" . $free_text_description;
      $annotations .= ";Note=" . $free_text_description;
    }

    # Now identify belonging to an orthogroup
#    my $og_data = `grep $id ../1_OrthoFinder/Orthogroups/Orthogroups.tsv | cut -f 1`;
#    chomp($og_data);

#    unless($og_data =~ /^\s*$/) {
#      $annotations .= ";OrthoGroup=" . $og_data;
#    }

    print join("\t", $landmark, $src, $type, $start, $end, $dot, $strand, $phase, $annotations);
    print "\n";
  } else {
    print $_ . "\n";
  }
}