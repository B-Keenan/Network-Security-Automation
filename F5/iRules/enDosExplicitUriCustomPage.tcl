when HTTP_REQUEST priority 250 {
    if { [HTTP::host] eq "app.example.com" &&
         [HTTP::path] eq "/wrd/run/http_listener.json" } {
        DOSL7::enable
    }
    else {
        DOSL7::disable
    }
}

when IN_DOSL7_ATTACK {
    log local0. "Blocking access to [HTTP::host][HTTP::path] from [IP::client_addr]"
    HTTP::respond 429 content {
        <html>
         <head>
            <title>Apology Page</title>
         </head>
         <body>
            We are sorry, but the site you are looking for is temporarily out of service<br>
            If you feel you have reached this page in error, please try again.
         </body>
      </html>
   }
}