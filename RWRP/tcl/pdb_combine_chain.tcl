proc pdb_combine_chain {mol_name total_num} {

global chain_list
global cycle



for {set j 0} {$j < $cycle} {incr j} {

set chain_name [lindex ${chain_list} $j]
set  mlist ""

for {set i 1} {$i <= 500} {incr i} {

if {$i<=[expr ${total_num}-$j*500]} {

mol load psf ${mol_name}.psf
mol addfile pdb/${chain_name}_${i}_temp.pdb
set aa [atomselect top all]
$aa set segid ${chain_name}${i}
lappend mlist [$aa molid]
$aa delete

}

}
unset i
############################################################
set mol [::TopoTools::mergemols $mlist]
animate write pdb pdb/${chain_name}.pdb $mol
animate write psf pdb/${chain_name}.psf $mol

unset mlist
mol delete all
############################################################
}
unset j
}

#################################################################
global cycle
global mol_name
global total_num
global chain_list

pdb_combine_chain $mol_name $total_num

for {set j 0} {$j < $cycle} {incr j} {

set chain_name [lindex ${chain_list} $j]

for {set i 1} {$i <= 500} {incr i} {

if {$i<=[expr ${total_num}-$j*500]} {
file delete -force pdb/${chain_name}_${i}_temp.pdb
}

}
unset i
unset chain_name
}
unset j


