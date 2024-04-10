when ACCESS_POLICY_COMPLETED {
    # When landing URI agent's are used with different auth methods
    if { [ACCESS::session data get "session.server.landinguri"] eq "/oauth" } {
        ACCESS::respond 302 "Location" "/login.php" "Connection" "Close"
    }
}
when SERVER_CONNECTED {
    # Offload ssl for specific server on an APM ssl bridging VS
    if { [IP::remote_addr] eq "10.255.33.186" } {
        SSL::disable
    }
}