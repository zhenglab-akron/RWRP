
proc patch_react {react_id} {

resetpsf

global top_address
global chain_num
global patch_name

package require psfgen

topology $top_address
mol load pdb poly_temp_${react_id}.pdb

for {set j 1} {$j <= $chain_num} {incr j} {

segment P$j {pdb poly_temp_${react_id}_$j.pdb}

for {set i 1} {$i <=$react_id} {incr i} {
set k [expr $i+1]
patch $patch_name P$j:${i} P$j:${k}
} 
coordpdb poly_temp_${react_id}_$j.pdb P$j
regenerate angles dihedrals
guesscoord
unset k
unset i
}
unset j

writepsf poly_temp_${react_id}_autopsf.psf
writepdb poly_temp_${react_id}_autopsf.pdb

for {set m 1} {$m <= $chain_num} {incr m} {

file delete -force poly_temp_${react_id}_$m.pdb 
file delete -force poly_temp_${react_id}_$m.psf
}
unset m
#file copy -force -- total.psf total_temp.psf
#file copy -force -- total.pdb total_temp.pdb
mol delete all
}
