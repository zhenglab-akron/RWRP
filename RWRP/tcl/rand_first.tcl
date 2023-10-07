proc rand_first {chain_num} {

global first_atom
global file
global total_num
mol load psf ${file}.psf
mol addfile mimized.dcd waitfor all

set randid_ref ""

for {set i 1} {$i<=$chain_num} {incr i} {

if {$total_num >= 500} {

set randid [expr int(rand()*499)+1]

while {[lsearch ${randid_ref} $randid] >= 0} {

set randid [expr int(rand()*499)+1]
}
}

if {$total_num < 500} {

set randid [expr int(rand()*($total_num-1))+1]

while {[lsearch ${randid_ref} $randid] >= 0} {

set randid [expr int(rand()*($total_num-1))+1]
}
}

set r1_mono [atomselect top "segname O${randid}"]
set r1 [atomselect top "segname O${randid} and name ${first_atom}"]

set seg_id [$r1 get segname]
lappend randid_ref $randid

$r1_mono set segname P$i
$r1_mono set resid 1
}

set all [atomselect top all]
$all writepdb ${file}.pdb
animate write psf ${file}.psf sel $all

unset seg_id
unset randid_ref
mol delete all
$all delete
$r1_mono delete
$r1 delete
}