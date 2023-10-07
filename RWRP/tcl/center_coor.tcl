global file

mol load psf ${file}.psf
mol addfile ${file}.pdb

set all [atomselect top all]
set coor [measure center $all]

$all moveby "[expr (-1)*[lindex $coor 0]] [expr (-1)*[lindex $coor 1]] [expr (-1)*[lindex $coor 2]]"

$all writepdb ${file}.pdb
mol delete all
$all delete
unset coor