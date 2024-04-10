when HTTP_REQUEST {

    if { [HTTP::header exists "Referer"] } {
        set repOrigin [HTTP::header value "Referer"]
    }
}


when HTTP_RESPONSE {

    if { [HTTP::header value "Access-Control-Allow-Origin"] eq "*" } {
        HTTP::header replace "Access-Control-Allow-Origin" "$repOrigin"
        HTTP::header replace "Vary" "Origin"
    }
}