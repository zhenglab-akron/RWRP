global chain_num
global first_atom
set lb -30
set hb 30

mol load psf total.psf
mol addfile total.pdb


for {set i 1} {$i <=$chain_num} {incr i} {

set selseg [atomselect top "segname P${i}"]

set x1 [lindex [lindex [measure minmax $selseg] 0] 0]
set x2 [lindex [lindex [measure minmax $selseg] 1] 0]
set y1 [lindex [lindex [measure minmax $selseg] 0] 1]
set y2 [lindex [lindex [measure minmax $selseg] 1] 1]
set z1 [lindex [lindex [measure minmax $selseg] 0] 2]
set z2 [lindex [lindex [measure minmax $selseg] 1] 2]

if {$x1 < $lb} {
$selseg moveby [list [expr $lb - $x1] 0 0]
}

if {$x2 > $hb} {
$selseg moveby [list [expr $hb - $x2] 0 0]
}

if {$y1 < $lb} {
$selseg moveby [list 0 [expr $lb - $y1] 0]
}

if {$y2 > $hb} {
$selseg moveby [list 0 [expr $hb - $y2] 0]
}

if {$z1 < $lb} {
$selseg moveby [list 0 0 [expr $lb - $z1]]
}

if {$z2 > $hb} {
$selseg moveby [list 0 0 [expr $hb - $z2]]
}

}
unset lb
unset hb
unset x1
unset x2
unset y1
unset y2
unset z1
unset z2
$selseg delete

set all [atomselect top all]
$all writepdb total.pdb
mol delete all

