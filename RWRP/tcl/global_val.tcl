###############################################################
#           Address of namd.exe in your Computer              #
###############################################################

set namd_address ../namd/NAMD_2.13_Win64-multicore-CUDA/namd2.exe


###############################################################
#                Monomer Name and Concentration               #
#                  Concentration in M (mol/L)                 #    
#       Expected Polymerization Degree from Experiments       #                                   
###############################################################

set network       n2
set conc          2.47   
set total_num     1000
set chain_num     10    
set initial_cutoff 12    
set file         total   
set start         1      
set degree        75  
set factor        4    
set chain_list {O A B C D E}
# cycle = int(total_num/500)
set cycle         2 

###############################################################
#                   Simulation Box Size in A                  #   
###############################################################

set xpbc  60
set ypbc  60
set zpbc  60

#################################################################
#                     Simulation contition                      #
#################################################################

set temp        298
set ion_cons    0.15
set mini_step   1000
set md_run_set  1000

###############################################################
#                 MD_file_Preparison and MD_RUN               #      
###############################################################
set top_address ../par/top_new.rtf
set par_address ../par/par_new.prm

###############################################################
#                      Patch Information                      #       
###############################################################
set mol_name      HEAA   
set patch_name    PEAA   
set first_atom    C13    
set second_atom   C16    

