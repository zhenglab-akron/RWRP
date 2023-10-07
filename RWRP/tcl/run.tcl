# Global Variables
source ../tcl/global_val.tcl
global namd_address
global network
global chain_num
global degree
global start
global file

# load library for adding monomers into a box 
source ../tcl/rand_position.tcl
source ../tcl/pdb_combine_chain.tcl
source ../tcl/pdb_combine_all.tcl
source ../tcl/center_coor.tcl

# if construting double network hydrogel
if {$network == "n2"} {
	source ../tcl/pdb_combine_network.tcl
}

# relax systems
exec $namd_address +p8 md.conf > mini_out.dat #

# create temprary psf and pdb files
file copy -force -- ../out/total.psf ../out/total_temp.psf
file copy -force -- ../out/total.pdb ../out/total_temp.pdb

# load library for reation
source ../tcl/search_nearby.tcl
source ../tcl/go_patch.tcl
source ../tcl/polymerization.tcl
source ../tcl/rand_first.tcl

for {set i $start} {$i < $degree} {incr i} {

	if {$i == 1} {
		# random pick up the first monomer to initiate the reaction
		rand_first ${chain_num}   
		# minimization and a short MD simulation to relax the system
		exec $namd_address +p8 md.conf > mini_out.dat

		# value 0: not create image; value 1: create image
		# if 1: create a directory name as "movie_traj"
		if {0} {
		mol load psf ../out/total.psf
		mol addfile ../out/mimized.dcd step 2 waitfor all

		set all [atomselect top all]
		animate write psf ../movie_traj/${network}_0.psf sel $all
		animate write dcd ../movie_traj/${network}_0.dcd beg 5 end -1 sel $all
		$all writepdb ../movie_traj/${network}_0.pdb
		$all delete
		mol delete all
		}

	}
	#####################################################
	#            Four steps for each reation            #
	#####################################################
	# step 1: find the nearest monomer
	# step 2: apply patch method to link the target monomer
	# step 3: update psf and pdb
	# step 4: minimization and a short MD simulation
	search_nearby $i aa
	patch_react $i
	polymerization $i
	exec $namd_address +p8 ../conf/md.conf > ../out/mini_out.dat

	# value 0: not create image; value 1: create image
	# if 1: create a directory name as "movie_traj"
	if {0} {
		mol load psf total.psf
		mol addfile ../out/mimized.dcd step 2 waitfor all

		set all [atomselect top all]
		animate write psf ../movie_traj/${network}_${i}.psf sel $all
		animate write dcd ../movie_traj/${network}_${i}.dcd beg 5 end -1 sel $all
		$all writepdb ../movie_traj/${network}_${i}.pdb
		$all delete
		mol delete all
		}
}
