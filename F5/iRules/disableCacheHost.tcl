when HTTP_REQUEST {   
    switch [HTTP::host] {
        "www.example.com" { CACHE::disable }
    }
}