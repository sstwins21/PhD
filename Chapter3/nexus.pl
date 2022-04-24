#!/usr/bin/perl
#running RAxML on alignment files

$dir = $ARGV[0];

@files = `ls $dir/RAxML_bestTree.*`;

print "#nexus\n\nBEGIN TREES;\n\n";
=pod
for($i = 0; $i < 5; $i ++) {
  $files[$i] =~ s/\R//g;
  $tree = `cat $files[$i]`;
  $tree  =~ s/\R//g;
  print "TREE gt$i = $tree\n";
  $index ++;

}
=cut

$index = 0;
foreach $a (@files) {
  $a =~ s/\R//g;
  $tree = `cat $a`;
  $tree  =~ s/\R//g;
  print "TREE gt$index = $tree\n";
  $index ++;

}

print "\nEND;\n\n";

print "BEGIN PHYLONET;\n\n";
#print "InferNetwork_MP_Allopp (all) 1 -pl 5 -h {axp, axg, ax500} -a <axx:axx.1,axx.2,axx.3; axp:axp.1,axp.2,axp.3;axg:axg.1,axg.2,axg.3;axw2:axw2.1,axw2.2;axx500:axx500.1,axx500.2;arg100:arg100.1,arg100.2;cli525:cli525.1,cli525.2;cli753:cli753.1,cli753.2;cli948:cli948.1,cli948.2;pki14:pki14.1,pki14.2;pss:pss.1,pss.2;tp:tp.1,tp.2> ;";

#print "InferNetwork_MP(all) 1 -a <axx:axx.1,axx.2,axx.3; axp:axp.1,axp.2,axp.3;axg:axg.1,axg.2,axg.3;axw2:axw2.1,axw2.2;axx500:axx500.1,axx500.2;arg100:arg100.1;cli525:cli525.1;cli753:cli753.1;cli948:cli948.1;pki14:pki14.1;pss:pss.1;tp:tp.1>;";

#print "InferNetwork_MP_Allopp (all) 1 -pl 5 -h {axg, axx500, axp} -a < axx:axx.1,axx.2,axx.3; axp:axp.1,axp.2,axp.3; axg:axg.1,axg.2,axg.3; axw2:axw2.1,axw2.2; axx500:axx500.1,axx500.2; arg100:arg100.1,arg100.2; cli525:cli525.1,cli525.2; cli753:cli753.1,cli753.2; cli948:cli948.1,cli948.2; pki14:pki14.1,pki14.2; pss:pss.1,pss.2; tp:tp.1,tp.2> ;";

print "InferNetwork_MP (all) 1 -pl 5 -h {axg, axx500, axp, axx} -a < axx:axx.1,axx.2,axx.3; axp:axp.1,axp.2,axp.3; axg:axg.1,axg.2,axg.3; axw2:axw2.1,axw2.2; axx500:axx500.1,axx500.2; arg100:arg100.1,arg100.2; cli525:cli525.1,cli525.2; cli753:cli753.1,cli753.2; cli948:cli948.1,cli948.2; pki14:pki14.1,pki14.2; pss:pss.1,pss.2; tp:tp.1,tp.2> ;";

#print "InferNetwork_MP (all) 1 -pl 5 -h {axg, axx500, axp, axx, axw2} -a < axx:axx.1,axx.2,axx.3; axp:axp.1,axp.2,axp.3; axg:axg.1,axg.2,axg.3; axw2:axw2.1,axw2.2; axx500:axx500.1,axx500.2; arg100:arg100.1,arg100.2; cli525:cli525.1,cli525.2; cli753:cli753.1,cli753.2; cli948:cli948.1,cli948.2; pki14:pki14.1,pki14.2; pss:pss.1,pss.2; tp:tp.1,tp.2> ;";

#print "InferNetwork_MP (all) 1 -pl 5 -a < axx:axx.1,axx.2,axx.3; axp:axp.1,axp.2,axp.3; axg:axg.1,axg.2,axg.3; axw2:axw2.1,axw2.2; axx500:axx500.1,axx500.2; arg100:arg100.1,arg100.2; cli525:cli525.1,cli525.2; cli753:cli753.1,cli753.2; cli948:cli948.1,cli948.2; pki14:pki14.1,pki14.2; pss:pss.1,pss.2; tp:tp.1,tp.2> ;";


print  "\n\nEND;";
