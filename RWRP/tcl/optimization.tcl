##################################################################                        optimization of the system             #
#################################################################

proc optimization {num_cycle} {

global namd_address

for {set m 1} {$m <=${num_cycle}} {incr m} {
mol load psf total.psf
mol addfile mimized.dcd waitfor all
set all [atomselect top all]
set coor [measure center $all]

$all moveby "[expr (-1)*[lindex $coor 0]] [expr (-1)*[lindex $coor 1]] [expr (-1)*[lindex $coor 2]]"

$all writepdb total.pdb
unset coor
mol delete all

exec $namd_address +p8 ../conf/md1.conf > mini_out.dat
}
unset m
$all delete
}

#################################################################
