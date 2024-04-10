when CLIENT_ACCEPTED {

	set y [expr int(rand()*8)]
	switch -glob $y {
		1 {
			set ip_addr 24.103.[expr int(rand()*100)].[expr int(rand()*100)]
		}
		2 {
			set ip_addr 131.80.[expr int(rand()*100)].[expr int(rand()*40)]
		}
		3 {
			set ip_addr 159.113.[expr int(rand()*100)].[expr int(rand()*70)]
		}
		4 {
			set ip_addr 204.84.[expr int(rand()*100)].[expr int(rand()*150)]
		}
		5 {
			set ip_addr 142.9.[expr int(rand()*100)].[expr int(rand()*30)]
		}
		default {
			set ip_addr [expr int(rand()*100)].[expr int(rand()*255)].[expr int(rand()*255)].[expr int(rand()*254)]
		}
	}
}

when HTTP_REQUEST {
    HTTP::header insert X-Forwarded-For $ip_addr
}
