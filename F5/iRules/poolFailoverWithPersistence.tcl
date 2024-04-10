when LB_SELECTED {
	if { [LB::status pool /Common/simple_pool_1 member 10.68.97.54 0 down] } {
        if { [persist lookup source_addr [IP::client_addr]] eq "/Common/simple_pool_2 194.24.0.154 0" } {
            persist delete source_addr [IP::client_addr]
            pool /Common/simple_pool_2 member 194.24.0.153 0
            persist add source_addr [IP::client_addr]
            #log local0. "Persist record updated: [persist lookup source_addr [IP::client_addr]]"
        }
    }
}