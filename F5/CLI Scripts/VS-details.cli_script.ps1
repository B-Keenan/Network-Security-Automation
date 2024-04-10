proc script::run {} {
    set partitions "/Common"
	puts "Virtual Server,Destination,Profiles,Rules,Pool-Name,Pool-Members"
	
    # Iterate over each partition and don't terminate if object doesn't exist
    foreach p $partitions {
        if { [catch { set changeTo [tmsh::cd $p] }] } {
            continue
        }

        foreach vs [tmsh::get_config ltm virtual all-properties] {
            set poolObj [tmsh::get_field_value $vs "pool"]
            set profiles [tmsh::get_field_value $vs "profiles"]
            set remprof [regsub -all {\n} [regsub -all " context" [join $profiles "\n"] "context"] " "]
            set profileList [regsub -all "profiles " $remprof ""]
            if { !($poolObj == "none") } {
                # Store pool object to collect members in next foreach loop
                set pool [tmsh::get_config ltm pool $poolObj all-properties]
            } else {
				# Print vs's with no pool object then repeat loop
                puts "[tmsh::get_name $vs],[tmsh::get_field_value $vs "destination"],$profileList,[tmsh::get_field_value $vs "rules"],$poolObj"
                continue
            }
            foreach node $pool {
                set poolMembers {}
                set member [tmsh::get_field_value $node "members"]
                foreach i $member {
                    # Find each member in the pool object then print the list contents
                    set n [lindex $i 1]
                    append poolMembers $n " "
                    }
                puts "[tmsh::get_name $vs],[tmsh::get_field_value $vs "destination"],$profileList,[tmsh::get_field_value $vs "rules"],$poolObj,$poolMembers"
                }
            }
        }
    }