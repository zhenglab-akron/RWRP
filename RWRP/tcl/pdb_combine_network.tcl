set mlist ""

mol load psf total.psf
mol addfile total.pdb
set aa [atomselect top all]
lappend mlist [$aa molid]
mol load psf total_PVA.psf
mol addfile total_PVA.pdb

for {set i 1} {$i<=6} {incr i} {
set p [atomselect top "segname P$i"]
$p set segname M$i
}

set bb [atomselect top all]
lappend mlist [$bb molid]
$bb set chain M
$aa delete
$bb delete
set mol [::TopoTools::mergemols $mlist]
animate write pdb total.pdb $mol
animate write psf total.psf $mol

unset mlist
mol delete all

