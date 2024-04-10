# Close invalid POST requests that are open for too long.
# Helps to prevent exceeding any connection limit, tmm memory exhaustion, ASM parameter long_request_buffer_size from filling causing valid POST requests to be blocked, and more.
when HTTP_REQUEST {

    # Only check POSTs.
    if { [HTTP::method] eq "POST" } {
    
        # Collect the length.
        set length [HTTP::header Content-Length]
        log local0. "POST Content-Length $length"

        # Calcuate a fair timeout for the client to send the data in ms.
        set timeout 10000
        log local0. "Configured timeout: $timeout"
    }

    if { [info exists length] } {
        
        # If the POST request exceeded the timeout, send a tcp reset back to the client.
        set id [after $timeout {
            reject
            log local0. "Timeout exceeded for [IP::client_addr]."
        }]
    }
}