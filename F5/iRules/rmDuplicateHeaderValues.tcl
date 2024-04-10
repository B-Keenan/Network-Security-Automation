when HTTP_REQUEST {

	set hdr "X-Forwarded-For"

	if { [HTTP::header exists $hdr] } {
		set hdrVal [HTTP::header value $hdr]
		#log local0. "Original header value: $hdrVal"
		set newHdr {}
		foreach i $hdrVal {
			if { [lsearch $newHdr $i] == -1 } {
			    lappend newHdr $i
			}
		}
		HTTP::header replace $hdr $newHdr
		#log local0. "Updated header: [HTTP::header value $hdr]"
	}
}