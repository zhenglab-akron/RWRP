proc polymerization {react_id} {

set mlist ""

mol load psf poly_temp_${react_id}_autopsf.psf
mol addfile poly_temp_${react_id}_autopsf.pdb

set aa [atomselect top all]
lappend mlist [$aa molid]

mol load psf free_temp_${react_id}.psf
mol addfile free_temp_${react_id}.pdb

set bb [atomselect top all]
lappend mlist [$bb molid]

set mol [::TopoTools::mergemols $mlist]
animate write pdb total.pdb $mol
animate write psf total.psf $mol

unset mlist
unset mol
$aa delete
$bb delete
mol delete all
file delete -force poly_temp_${react_id}_autopsf.psf
file delete -force poly_temp_${react_id}_autopsf.pdb
file delete -force poly_temp_${react_id}.psf
file delete -force poly_temp_${react_id}.pdb
file delete -force free_temp_${react_id}.psf
file delete -force free_temp_${react_id}.pdb
file delete -force total_temp_${react_id}.psf
file delete -force total_temp_${react_id}.pdb

}
