proc pdb_combine {out} {

global cycle
global chain_list

set  mlist ""

for {set j 0} {$j < $cycle} {incr j} {

set chain_name [lindex ${chain_list} $j]

mol load psf pdb/${chain_name}.psf
mol addfile  pdb/${chain_name}.pdb
set aa [atomselect top all]
lappend mlist [$aa molid]
$aa delete
}
#################################################################
set mol [::TopoTools::mergemols $mlist]
animate write pdb ${out}.pdb $mol
animate write psf ${out}.psf $mol

unset j
unset mlist
mol delete all
unset mol
}

#################################################################

global file
pdb_combine $file
