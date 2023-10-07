proc rand_position {chain_name id} {

global mol_name
global xpbc
global ypbc
global zpbc

# load monomers for polymerization
mol load psf ${mol_name}.psf
mol addfile  ${mol_name}.pdb

# set segname and chain name
set all [atomselect top all]
$all set chain ${chain_name}
$all set segname ${chain_name}${id}

# rotate the added molecules in different direction
set rot_x [expr rand()*360]
set rot_y [expr rand()*360]
set rot_z [expr rand()*360]

# randomly rotate molecule in different direction
$all move [trans center {0 0 0} x $rot_x]
$all move [trans center {0 0 0} y $rot_y]
$all move [trans center {0 0 0} z $rot_z]

# randomly distribute monomer in the pbc box
set movex [expr rand()*($xpbc-10)]
set movey [expr rand()*($ypbc-10)]
set movez [expr rand()*($zpbc-10)]
$all moveby "$movex $movey $movez"

# creat pdb files for each monomer
$all writepdb pdb/${chain_name}_${id}_temp.pdb

$all delete
unset rot_x
unset rot_y
unset rot_z
unset movex
unset movey
unset movez
mol delete all
} 

global total_num
global chain_list
global cycle


# do iteration for creating coordinates of monomers
for {set j 0} {$j < $cycle} {incr j} {

set chain_name [lindex $chain_list $j]

for {set i 1} {$i<=500} {incr i} {

if {$i<=[expr ${total_num}-$j*500]} {

rand_position $chain_name $i
}

}
unset i
unset chain_name
}
unset j
