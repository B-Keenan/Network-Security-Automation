###################################
# maintenancePage
###################################
# Description: Display a maintenance page when all pool members are offline using ifile's.
# Rule Author: Ben Keenan
# Rule Version: 1.0
# Last Modified: 31/05/2022

when HTTP_REQUEST {
    if { [active_members [LB::server pool]] eq 0 }{
        switch -glob [string tolower [HTTP::uri]] {
            "*/logo.png" { HTTP::respond 200 -version 1.1 content [ifile get logo] noserver Connection close }
            "*/master.css" { HTTP::respond 200 -version 1.1. content [ifile get master] noserver Connection close }
            "*/modalbox.js" { HTTP::respond 200 -version 1.1 content [ifile get modalbox] noserver Connection close }
            default { HTTP::respond 200 -version 1.1 content [ifile get maintenancePage] noserver Connection close }
        }
    }
}