proc search_nearby {react_id outfile} {

# obtain the global variables from global_var.tcl
global initial_cutoff
global file
global total_num
global chain_num
global first_atom
global second_atom
global factor

# import trajectories
set out [open ${outfile}.dat w]
mol load psf ${file}.psf
mol addfile mimized.dcd waitfor all 

# save a temp file
set all [atomselect top all]
animate write psf total_temp.psf sel $all
$all writepdb total_temp.pdb 
$all delete

##################################################################            do loop to find the neighbor list of each chain    #
#################################################################

set r2_ref P0  

for {set j 1} {$j<=$chain_num} {incr j} {

#select the first reactive atom of chain j
set r1 [atomselect top "segname P$j and resid $react_id and name ${first_atom}"] 

# get the coordinates of first atom of chain j
set r1_coor [measure center $r1] 
set r1_x [lindex ${r1_coor} 0]
set r1_y [lindex ${r1_coor} 1]
set r1_z [lindex ${r1_coor} 2]

# find the neighbor list of the reactive atom of chain j

set nearby [atomselect top "(name ${second_atom} and within $initial_cutoff of (segname P$j and resid $react_id and name ${first_atom})) and not (chain P) and not (segname $r2_ref)"]

set seg [$nearby get segname]

#################################################################
# incr the cutoff of length if no neighbor list and get segid   #
#################################################################

while {$seg == ""} {

incr initial_cutoff

set nearby [atomselect top "(name ${second_atom} and within $initial_cutoff of (segname P$j and resid $react_id and name ${first_atom})) and not (chain P) and not (segname $r2_ref)"]

set seg [$nearby get segname]
}

$nearby delete
puts "$seg"
#################################################################


#################################################################
#          find the reactive atom of the second molecule        #
#################################################################
set dis_list ""

for {set i 0} {$i <[llength $seg]} {incr i} {

set r2 [atomselect top "segname [lindex $seg $i] and name $second_atom"]
set r2_coor [measure center $r2]
set dis_temp [vecdist $r1_coor $r2_coor]
lappend dis_list $dis_temp

unset r2_coor
unset dis_temp
$r2 delete

}
puts $out "$j $dis_list"
unset i

#################################################################


#################################################################
#             find the minimum value of the distance            #
#################################################################

set min [tcl::mathfunc::min {*}$dis_list]
set m [lsearch $dis_list $min]
puts "$m"

#################################################################


#################################################################
#             set segname of polymerized molecules              #
#################################################################
   
set r2_seg [lindex $seg $m]
puts "$r2_seg"

# move second reactive molecule close to first reactive atom

set r2 [atomselect top "segname ${r2_seg} and name ${second_atom}"]
set r2_coor [measure center $r2]
set dis_temp [vecdist $r1_coor $r2_coor]
set r2_mono [atomselect top "segname ${r2_seg}"]

if {${dis_temp}>12} {

set r2_x [lindex ${r2_coor} 0]
set r2_y [lindex ${r2_coor} 1]
set r2_z [lindex ${r2_coor} 2]

# correct distance by a factor

set movex [expr (-1)*(${r2_x}-${r1_x}) + $factor]
set movey [expr (-1)*(${r2_y}-${r1_y}) + $factor]
set movez [expr (-1)*(${r2_z}-${r1_z}) + $factor]

${r2_mono} moveby "$movex $movey $movez"

unset r2_x
unset r2_y
unset r2_z
}

$r2_mono set chain P
$r2_mono set segname P$j
$r2_mono set resid [expr $react_id +1]

unset dis_temp
unset r2_coor
$r2 delete

#################################################################

#################################################################
#                        return to r2_ref                       #
#################################################################
lappend r2_ref $r2_seg

#################################################################
unset r2_seg
unset r1_coor
unset dis_list
unset r1_x
unset r1_y
unset r1_z
$r2_mono delete
$r1 delete

################################################################
set poly [atomselect top "segname P$j"]
animate write psf poly_temp_${react_id}_$j.psf sel $poly
$poly writepdb poly_temp_${react_id}_$j.pdb
################################################################
}

set poly_aa [atomselect top "chain P"]
animate write psf poly_temp_${react_id}.psf sel $poly_aa
$poly_aa writepdb poly_temp_${react_id}.pdb

set free [atomselect top "all and not chain P"]
animate write psf free_temp_${react_id}.psf sel $free
$free writepdb free_temp_${react_id}.pdb

set all [atomselect top all]
animate write psf ${file}_temp_${react_id}.psf sel $all
$all writepdb ${file}_temp_${react_id}.pdb

$free delete
$all delete
$poly delete
$poly_aa delete
unset r2_ref
unset j
close $out 
mol delete all
#################################################################

}



