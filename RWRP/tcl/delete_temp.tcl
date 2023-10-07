for {set j 0} {$j < $cycle} {incr j} {

set chain_name [lindex ${chain_list} $j]

for {set i 1} {$i <= 500} {incr i} {


#if {$i>[expr ${total_num}-$j*500]} {
#continue
#}

file delete -force ../pdb/${chain_name}_${i}_temp.pdb

}
unset i
unset chain_name
}
unset j
