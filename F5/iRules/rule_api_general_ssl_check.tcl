when RULE_INIT {
    # Log debug messages to /var/log/ltm? 1=yes, 0=no
    set static::debug 1
}

when  ACCESS_PER_REQUEST_AGENT_EVENT {
    if { [ACCESS::perflow get perflow.irule_agent_id] eq "Check_Cert" } {
        # Check if client provided a cert
        if {[SSL::cert count] == 0} {
            if {$static::debug} { log local0. "The user IP address [IP::remote_addr]" }
            if {$static::debug} { log local0. "The user not have certificate" }
            ACCESS::session data set "session.custom.ssl.status" "false"
        }
        if {[SSL::cert 0] eq ""} {
            # Reset the connection
            if {$static::debug} { log local0. "The user IP address [IP::remote_addr]" }
            if {$static::debug} { log local0. "Connection rejected" }
            ACCESS::session data set "session.custom.ssl.status" "false"
        } else {
            set subject_dn [X509::subject [SSL::cert 0]]
            set cert_date [X509::not_valid_after [SSL::cert 0]]
			if {$static::debug} {
            log local0. "the certificate and date is $subject_dn : $cert_date"
            log local0. "The initial Cert is :   !!!! $subject_dn"
            log local0. "The user hash is [X509::hash [SSL::cert 0]]"
			}
            if { $subject_dn contains "OU=" || $subject_dn contains "O=" || $subject_dn contains "C=GB" }{
                set subject_dn [findstr "$subject_dn" "CN" 0 ","]
                if {$static::debug} { log local0. "The extract Certs is  !!!!!! $subject_dn" }

            }
            if {$static::debug} { log local0. "Client Certificate Received: $subject_dn" }
            #Check if the client certificate contains CN from the list
            if { [class $subject_dn contains my_dg ] || $subject_dn eq "CN=ocdclient" } {
                #Accept the client cert if found
                if {$static::debug} { log local0. "Client Certificate Accepted: $subject_dn" }
                ACCESS::session data set "session.custom.ssl.subject_dn" $subject_dn
                ACCESS::session data set "session.custom.ssl.status" "true"
            } else {
                if {$static::debug} { log local0. "No Matching Client Certificate Was Found Using: $subject_dn" }
                ACCESS::session data set "session.custom.ssl.status" "false"
                ACCESS::session data set "session.custom.ssl.subject_dn" ""
            }
        }
    }
}