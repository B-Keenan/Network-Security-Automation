when RULE_INIT {
	set static::debug 1
}
when HTTP_REQUEST {
	if {[HTTP::method] eq "POST"}{
		if {[HTTP::path] eq "/CB/MWServlet" || [HTTP::path] eq "/SB/MWServlet" }{
			if {[HTTP::header "Content-Length"] ne "" && [HTTP::header "Content-Length"] <= 1048576}{
				set content_length [HTTP::header "Content-Length"]
			} else {
				set content_length 1048576
			}
			if { $content_length > 0} {
				if {$static::debug}{ log local0. "Collecting payload: $content_length" }
				HTTP::collect $content_length
			}
		}
	}
}
when HTTP_REQUEST_DATA {
	set spl [split [HTTP::payload] "&"]
	if {$static::debug}{ log local0. "Payload items: $spl" }
	if { [lindex $spl 0] eq "serviceID=getPINPositions" }{
		reject
	}
}