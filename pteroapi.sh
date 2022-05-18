#!/bin/bash
# shellcheck enable=require-variable-braces
# shellcheck disable=SC2034,2002,2004,2154,SC1073
## DO NOT REMOVE THESE!
## This is to prevent shellcheck from complaining about false positive issues like unused variables.

## Crash On Fail
set -e pipefail

## Setup Ptero Vars
HostName="Nightowl Servers"
HostDomain="nightowlservers.net"
ClientToken='MyClientAPIKey'
AppToken='MyApplicationAPIKey'
PanelHost="panel.${HostDomain}"
TargetUUID="${P_SERVER_UUID::8}"

CurlOp() { ## This Is The Curl Worker Function
    ## Declare Local Working Variables
    local Token && local TargetURL && local OperationType && local Payload
    ## Sanitize Inputs
    #[[  -z "${*}" ]] && echo "Arguements Needed For Curl API Functionality" >&2 && return 1
    case "${1:-NULL}" in
        ""|"null"|"NULL") ## Null Value
            echo "Target URL Cannot Be Null" >&2
            return 1
        ;;
        "h"|"H"|"HELP"|"help")
            echo -e "\
            Expected Arguments: \n
                1) TargetURL \n
                2) ApiToken \n
                3) Request Type \n
                4) Payload, If Needed
            "
            return 0
        ;;
        *) ## Not Null Value
            TargetURL="${1}"
            case "${2:-NULL}" in
                ""|"NULL"|"null") ## Null Value
                    echo "Authentification Token Required" >&2
                    return 1
                ;;
                *) ## Not Null Value
                    ## Sanitize API Key
                    case "${#2}" in
                        "48") ## Valid
                            Token="${2}"
                            case "${3:-NULL}" in
                                ""|"NULL"|"null")
                                    echo "Operation Type Required" >&2
                                    return 1
                                ;;
                                "POST"|"post"|"put"|"PUT"|"PATCH"|"patch")
                                    OperationType="${3^^}"
                                    ## Check For Json Payload
                                    case "${4:-NULL}" in
                                        ""|"NULL"|"null") ## Payload Is Null, Don't Include It With Operation
                                            curl -Ss --url "${TargetURL}" \
                                                -H "Accept: Application/vnd.pterodactyl.v1+json" \
                                                -H "Content-Type: application/json" \
                                                -H "Authorization: Bearer ${Token}" \
                                                -X "${OperationType}"
                                        ;;
                                        *) ## Payload Not Null, Include With Operation
                                            Payload="${4}"
                                            curl -Ss --url "${TargetURL}" \
                                            -H "Accept: Application/vnd.pterodactyl.v1+json" \
                                            -H "Content-Type: application/json" \
                                            -H "Authorization: Bearer ${Token}" \
                                            -X "${OperationType}" -d "${Payload}"
                                        ;;
                                    esac
                                ;;
                                "GET"|"get"|"delete"|"DELETE")
                                    OperationType="${3^^}"
                                    curl -Ss --url "${TargetURL}" \
                                        -H "Accept: Application/vnd.pterodactyl.v1+json" \
                                        -H "Content-Type: application/json" \
                                        -H "Authorization: Bearer ${Token}" \
                                        -X "${OperationType}"
                                ;;
                            esac
                        ;;
                        *) ## Invalid
                            echo "Invalid Or Malformed API Key Provided" >&2
                            return 1
                        ;;
                    esac
                ;;
            esac
        ;;
    esac
} ## End Of Function

ClientAPI() {
    ###############################################
    ##        ClientAPI API Wrapper Tool         ##
    ###############################################
    ## Setup the Client Token, Target Server, And TargetURL
    local Client_Token && Client_Token="${ClientToken}" && readonly Client_Token
    local TargetServer && TargetServer="${TargetUUID}"
    local UrlTarget && UrlTarget="https://${PanelHost}/api/client/servers/${TargetServer}"
    local APIOpertaion
    ## Sanitize Inputs
    #[[  -z "${*}" ]] && echo "Arguements Needed For Client API Functionality | ClientAPI H For More Information" >&2 && return 1
    case "${1:-NULL}" in 
        ""|"NULL"|"null")
            echo "Desired API Operation Required. ClientAPI H For More Information" >&2 
            return 1
        ;;
        *)
            APIOpertaion="${1}"
            ## Use Nested Case For Speed Filter Of Operation
            case "${APIOpertaion}" in 
                "HELP"|"help"|"h"|"H")
                    echo -e "\n
                    ClientAPI | Pterodactyl Api Wrapper Help Menu:\n
                        Syntax: ClientAPI <Command> <Command Arguements>\n
                    Valid Options:\n
                        [ H ] - Help\n
                           EXAMPLE: ClientAPI H\n
                        [ S ]  - Service Info\n
                           EXAMPLE: ClientAPI S\n
                        [ GRI ] - Get Resource Info\n
                           EXAMPLE: ClientAPI GRI\n
                        [ CMD ] - Send Command To Container\n
                           EXAMPLE: ClientAPI CMD <COMMAND>\n
                        [ PWR ] - Set Power State\n
                           EXAMPLE: ClientAPI PWR <POWER_STATE>\n
                        [ GDB ] - Get Databases\n
                           EXAMPLE: ClientAPI GDB\n
                        [ CDB ] - Create Database *\n
                           EXAMPLE: ClientAPI CDB <PARAMETERS>\n
                        [ RDBP ] - Rotate Database Password\n
                           EXAMPLE: ClientAPI RDBP\n
                        [ DDB ] - Delete Targeted Database\n
                           EXAMPLE: ClientAPI DDB <TARGET_DATABASE>\n
                        [ GA ] - Get Allocation\n
                           EXAMPLE: ClientAPI GA\n
                        [ CA ] - Create Allocation\n
                           EXAMPLE: ClientAPI CA\n
                        [ DA ] - Delete Allocation\n
                           EXAMPLE: ClientAPI DA <ALLOCATION_ID>\n
                        [ AO ] - Allocation Operation  \n
                           EXAMPLE: ClientAPI AO <ALLOCATION_ID> <PARAMETERS> * **\n
                        [ GSCH ] - Get Schedules Information\n
                           EXAMPLE: ClientAPI GSCH\n
                        [ CSCH ] - Create Schedule\n
                           EXAMPLE: ClientAPI CSCH <PARAMETERS>\n
                        [ GSCHD ] - Get Schedule Details\n
                           EXAMPLE: ClientAPI GSCHD\n
                        [ USCH ] - Update Schedule\n
                           EXAMPLE: ClientAPI USCH <SCHEDULE_ID> <PARAMETERS>\n
                        [ DSCH ] - Delete Schedule\n
                           EXAMPLE: ClientAPI DSCH <SCHEDULE_ID>\n
                        [ CTSK ] - Create Task\n
                           EXAMPLE: ClientAPI CTSK <SCHEDULE_ID> <PARAMETERS>\n
                        [ UTSK ] - Update Task\n
                           EXAMPLE: ClientAPI UTSK <SCHEDULE_ID> <TASK_ID> <PARAMETERS>\n
                        [ DTSK ] - Delete Task\n
                           EXAMPLE: ClientAPI DTSK <SCHEDULE_ID> <TASK_ID>\n
                        [ GBCK ] - Get Backups\n
                           EXAMPLE: ClientAPI GBCK\n
                        [ CBCK ] - Create Backup\n
                           EXAMPLE: ClientAPI CBCK\n
                        [ GBCKD ] - Get Backup Details\n
                           EXAMPLE: ClientAPI GBCKD <BACKUP_ID>\n
                        [ GBCKL ] - Get Backup Download Link\n
                           EXAMPLE: ClientAPI GBCKL <BACKUP_ID>\n
                        [ DBCK ] - Delete Backup\n
                           EXAMPLE: ClientAPI DBCK <BACKUP_ID>\n
                        [ LS ] - List Startup Variables\n
                           EXAMPLE: ClientAPI LS\n
                        [ ES ] - Edit Startup Variable *\n
                           EXAMPLE: ClientAPI ES <TARGET_VARIABLE> <PARAMETERS>\n
                        [ RS ] - Reinstall Server\n
                           EXAMPLE: ClientAPI RS\n
                        [ RENS ] - Rename Server\n
                           EXAMPLE: ClientAPI RENS <PARAMETERS>\n
                    Valid API Options:\n
                         [ /allocations ] - Automatically Assign A New Allocation\n
                         [ /allocations/{allocation} ] - Set Allocation Note. Json key:value Pair\n
                         [ /allocations/{allocation}/primary ] - Set Primary Allocation\n
                      * - Note:\n
                        Input MUST be a valid JSON Key|Value pair!\n
                      ** - Note:\n
                        This is a post operation. You need to use valid API post operations\n
                    "
                ;;
                "SERVICEINFO"|"serviceinfo"|"s"|"S")
                    CurlOp "${UrlTarget}" "${Client_Token}" "GET"
                ;;
                "GETRESOURCEINFO"|"getresourceinfo"|"gri"|"GRI")
                    CurlOp "${UrlTarget}/resources" "${Client_Token}" "GET"
                ;;
                "SENDCOMMAND"|"sendcommand"|"cmd"|"CMD")
                    case "${2:-NULL}" in 
                        ""|"NULL"|"null")
                            echo "Command Payload Required. ClientAPI H For More Information" >&2 
                            return 1
                        ;;
                        *)
                            CurlOp "${UrlTarget}/command" "${Client_Token}" "POST" "${2}" ## ${2} Must Be A JSON KEY|VALUE Pair!
                        ;;
                    esac
                ;;
                "POWERSTATE"|"powerstate"|"pwr"|"PWR")
                    case "${2:-NULL}" in 
                        ""|"NULL"|"null")
                            echo "Power State Payload Required. ClientAPI H For More Information" >&2 
                            return 1
                        ;;
                        *)
                            CurlOp "${UrlTarget}/power" "${Client_Token}" "POST" "${2}" ## ${2} Must Be A JSON KEY|VALUE Pair!
                        ;;
                    esac
                ;;
                "GETDATABASES"|"getdatabases"|"gdb"|"GDB")
                    CurlOp "${UrlTarget}/databases" "${Client_Token}" "GET" 
                ;;
                "CREATEDATABASE"|"createdatabase"|"cdb"|"CDB")
                    case "${2:-NULL}" in 
                        ""|"NULL"|"null")
                            echo "Database Creation Payload Required. ClientAPI H For More Information" >&2 
                            return 1
                        ;;
                        *)
                            CurlOp "${UrlTarget}/databases" "${Client_Token}" "POST" "${2}" ## ${2} Must Be A JSON KEY|VALUE Pair!
                        ;;
                    esac
                ;;
                "ROTATEDATABASEPASSWORD"|"rotatedatabasepassword"|"rdbp"|"RDBP")
                    case "${2:-NULL}" in 
                        ""|"NULL"|"null")
                            echo "Target Database Required. ClientAPI H For More Information" >&2 
                            return 1
                        ;;
                        *)
                            CurlOp "${UrlTarget}/databases/${2}/rotate-password" "${Client_Token}" "POST"
                        ;;
                    esac
                ;;
                "DELETEDATABASE"|"deleteatabase"|"ddb"|"DDB")
                    case "${2:-NULL}" in 
                        ""|"NULL"|"null")
                            echo "Target Database Required. ClientAPI H For More Information" >&2 
                            return 1
                        ;;
                        *)
                            CurlOp "${UrlTarget}/databases/${2}" "${Client_Token}" "DELETE"
                        ;;
                    esac
                ;;
                "GETALLOC"|"getalloc"|"ga"|"GA")
                    CurlOp "${UrlTarget}/network/allocations" "${Client_Token}" "GET"
                ;;
                "CREATEALLOC"|"createalloc"|"ca"|"CA")
                    CurlOp "${UrlTarget}/network/allocations" "${Client_Token}" "POST"
                ;;
                "ALLOCOP"|"allocop"|"ao"|"AO")
                    case "${2:-NULL}" in 
                        ""|"NULL"|"null")
                            echo "Target Allocation Required. ClientAPI H For More Information" >&2 
                            return 1
                        ;;
                        *)
                            case "${3:-NULL}" in 
                                ""|"NULL"|"null")
                                    echo "Allocation Operation Payload Required. ClientAPI H For More Information" >&2 
                                    return 1
                                ;;
                                *)
                                    CurlOp "${UrlTarget}/network/allocations/${2}" "${Client_Token}" "POST" "${3}" ## ${3} Must Be A JSON KEY|VALUE Pair!
                                ;;
                            
                            esac
                        ;;
                    esac
                ;;
                "GETSCHEDULES"|"getschedules"|"gsch"|"GSCH")
                    CurlOp "${UrlTarget}/schedules" "${Client_Token}" "GET"
                ;;
                "CREATESCHEDULE"|"createschedule"|"csch"|"CSCH")
                    CurlOp "${UrlTarget}/schedules" "${Client_Token}" "POST"
                ;;
                "GETSCHEDULEDETAILS"|"getscheduledetails"|"gschd"|"GSCHD")
                    CurlOp "${UrlTarget}/schedules/${2}" "${Client_Token}" "GET"
                ;;
                "UPDATESCHEDULE"|"updateschedule"|"usch"|"USCH")
                    case "${2:-NULL}" in 
                        ""|"NULL"|"null")
                            echo "Target Schedule Required. ClientAPI H For More Information" >&2 
                            return 1
                        ;;
                        *)
                            case "${3:-NULL}" in 
                                ""|"NULL"|"null")
                                    echo "Schedule Update Operation Payload Required. ClientAPI H For More Information" >&2 
                                    return 1
                                ;;
                                *)
                                    CurlOp "${UrlTarget}/schedules/${2}" "${Client_Token}" "POST" "${3}" ## ${3} Must Be A JSON KEY|VALUE Pair!
                                ;;
                            
                            esac
                        ;;
                    esac
                ;;
                "DELETESCHEDULE"|"deleteschedule"|"dsch"|"DSCH")
                    CurlOp "${UrlTarget}/schedules/${2}" "${Client_Token}" "DELETE"
                ;;
                "CREATETASK"|"createtask"|"ctsk"|"CTSK")
                    CurlOp "${UrlTarget}/schedules/${2}/tasks" "${Client_Token}" "POST"
                ;;
                "UPDATETASK"|"updatetask"|"utsk"|"UTSK")
                    case "${2:-NULL}" in 
                        ""|"NULL"|"null")
                            echo "Target Schedule Required. ClientAPI H For More Information" >&2 
                            return 1
                        ;;
                        *)
                            case "${3:-NULL}" in 
                                ""|"NULL"|"null")
                                    echo "Target Task Required. ClientAPI H For More Information" >&2 
                                    return 1
                                ;;
                                *)
                                    case "${4:-NULL}" in
                                        ""|"NULL"|"null")
                                            echo "Task Update Payload Required. ClientAPI H For More Information" >&2 
                                            return 1
                                        ;;
                                        *)
                                            CurlOp "${UrlTarget}/schedules/${2}/tasks/${3}" "${Client_Token}" "POST" "${4}" ## ${4} MUST BE A VALID JSON KEY|VALUE BODY!
                                        ;;
                                    esac
                                    CurlOp "${UrlTarget}/schedules/${2}" "${Client_Token}" "POST" "${3}" ## ${3} Must Be A JSON KEY|VALUE Pair!
                                ;;
                            esac
                        ;;
                    esac
                ;;
                "DELETETASK"|"deletetask"|"dtsk"|"DTSK")
                    case "${2:-NULL}" in 
                        ""|"NULL"|"null")
                            echo "Target Schedule Required. ClientAPI H For More Information" >&2 
                            return 1
                        ;;
                        *)
                            case "${3:-NULL}" in 
                                ""|"NULL"|"null")
                                    echo "Target Task To Delete Required. ClientAPI H For More Information" >&2 
                                    return 1
                                ;;
                                *)
                                    CurlOp "${UrlTarget}/schedules/${2}/tasks/${3}" "${Client_Token}" "DELETE"
                                ;;
                            
                            esac
                        ;;
                    esac
                ;;
                "GETBACKUPS"|"getbackups"|"gbck"|"GBCK")
                    CurlOp "${UrlTarget}/backups" "${Client_Token}" "GET"
                ;;
                "CREATEBACKUP"|"createbackup"|"cbck"|"CBCK")
                    CurlOp "${UrlTarget}/backups" "${Client_Token}" "POST"
                ;;
                "GETBACKUPDETAILS"|"getbackupdetails"|"gbckd"|"GBCKD")
                    CurlOp "${UrlTarget}/backups/${2}" "${Client_Token}" "GET"
                ;;
                "GETBACKUPLINK"|"getbackuplink"|"gbckl"|"GBCKL")
                    CurlOp "${UrlTarget}/backups/${2}/download" "${Client_Token}" "GET" 
                ;;
                "DELETEBACKUP"|"deletebackup"|"dbck"|"DBCK")
                    CurlOp "${UrlTarget}/backups/${2}" "${Client_Token}" "DELETE"
                ;;
                "LISTSTART"|"liststart"|"ls"|"LS")
                    CurlOp "${UrlTarget}/startup/" "${Client_Token}" "GET"
                ;;
                "EDITSTART"|"editstart"|"es"|"ES")
                    case "${2:-NULL}" in 
                        ""|"NULL"|"null")
                            echo "Startup Payload Required. ClientAPI H For More Information" >&2 
                            return 1
                        ;;
                        *)
                            CurlOp "${UrlTarget}/startup/variable" "${Client_Token}" "PUT" "${2}" ## ${2} MUST BE A VALID JSON KEY|VALUE BODY!
                        ;;
                    esac
                ;;
                "REINSTALLSERVER"|"reinstallserver"|"rs"|"RS")
                    CurlOp "${UrlTarget}/settings/reinstall" "${Client_Token}" "POST"
                ;;
                "RENAMESERVER"|"renameserver"|"rens"|"RENS")
                    case "${2:-NULL}" in 
                        ""|"NULL"|"null")
                            echo "Server Rename Payload Required. ClientAPI H For More Information" >&2 
                            return 1
                        ;;
                        *)
                            CurlOp "${UrlTarget}/settings/rename" "${Client_Token}" "POST" "${2}" ## ${2} MUST BE A VALID JSON KEY|VALUE BODY!
                        ;;
                    esac
                ;;
                *) echo -e "[ERROR] Invalid Arguement" >&2 ;; ## Obviously you didn't listen and put something stupid.
            esac
        ;;
    esac
} ## End Of Function

ApplicationAPI() {
    ################################################################
    ##    ApplicationAPI - PTERODACTYL APPLICATION API WRAPPER    ##
    ################################################################
    ## Setup the Application Token, Target Server, And TargetURL
    local App_Token && App_Token="${ClientToken}" && readonly App_Token
    local UrlTarget && UrlTarget="https://${PanelHost}/api/application"
    ## The Emperor has graced you with read perms, and only RW on servers and server databases.
    ## Do not forget this Astartes.
    ## Setup the Application Token, Target Server, And TargetURL
    local App_Token && App_Token="${ClientToken}" && readonly App_Token
    local UrlTarget && UrlTarget="https://${PanelHost}/api/application"
    local APIOpertaion
    case "${1:-NULL}" in
        ""|"NULL"|"null")
            echo "Desired API Operation Required. ClientAPI H For More Information" >&2 
            return 1
        ;;
        *)
            APIOpertaion="${1}"
            case "${1}" in
                "HELP"|"help"|"h"|"H") ## Help menu
                    echo -e "\n
                    ApplicationAPI | Pterodactyl App API Help Menu:\n
                        Syntax: ApplicationAPI <Command> <Command Argument(s)>\n
                    Valid Options:\n
                        [ H ] - Help\n
                           EXAMPLE: ApplicationAPI H\n
                        [ RC ] - Rolecall: List Users\n
                           EXAMPLE: ApplicationAPI RC\n
                        [ BGC ] - Background Check: Retrieve User Details\n
                           EXAMPLE: ApplicationAPI BGC <USER_ID>\n
                        [ PPC ] - Passport Check: Retrieve User Details Using External ID\n
                           EXAMPLE: ApplicationAPI PPC <EXTERNAL_USER_ID>\n
                        [ NL ] - Node List: List Nodes\n
                           EXAMPLE: ApplicationAPI NL\n
                        [ NCK ] - Node Check: Retrieve Node Details\n
                           EXAMPLE: ApplicationAPI NCK <NODE_ID>\n
                        [ NAL ] - Node Allocations: Retrieve Node Allocations\n
                           EXAMPLE: ApplicationAPI NAL <NODE_ID> <PAGE_NUMBER>\n
                        [ TO ] - Travel Options: List Locations\n
                           EXAMPLE: ApplicationAPI TO\n
                        [ DT ] - Destination Details: Retrieve Location Details\n
                           EXAMPLE: ApplicationAPI DT <LOCATION_ID>\n
                        [ SL ] - Server List: List Servers\n
                           EXAMPLE: ApplicationAPI SL\n
                        [ SCK ] - Server Check: Retrieve Server Details\n 
                           EXAMPLE: ApplicationAPI SCK <SERVER_ID>\n
                        [ SFCK ] - Server Foreign Check: Retrieve Server Details Using External ID\n
                           EXAMPLE: ApplicationAPI SFCK <EXTERNAL_SERVER_ID>\n
                        [ SRVP ] - Server Patch: Patch Server Details *\n
                           EXAMPLE: ApplicationAPI SRVP <SERVER_ID> <PARAMETERS>\n
                        [ SRVPB ] - Server Patch Build: Patch Server Build *\n
                           EXAMPLE: ApplicationAPI SRVPB <SERVER_ID> <PARAMETERS>\n
                        [ SRVPS ] - Server Patch Start: Patch Server Startup *\n
                           EXAMPLE: ApplicationAPI SRVPS <SERVER_ID> <PARAMETERS>\n
                        [ SBL ] - Server Database List: List Server Databases\n
                           EXAMPLE: ApplicationAPI SBL\n
                        [ SBLCK ] - Server Database Check: Check Server Database\n
                           EXAMPLE: ApplicationAPI SBLCK <SERVER_ID> <DATABASE_ID>\n
                        [ SDBCRT ] - Server Database Create: Create Server Database\n
                           EXAMPLE: ApplicationAPI SDBCRT <SERVER_ID>\n
                        [ SDBPWD ] - Server Database Password Rotate: Rotate Server Database Password\n
                           EXAMPLE: ApplicationAPI SDBPWD <SERVER_ID> <DATABASE_ID>\n
                        [ SDBDL ] - Server Database Delete: Delete Server Database\n
                           EXAMPLE: ApplicationAPI SDBCL <SERVER_ID> <DATABASE_ID>\n
                        [ RESRV ] - Reinstall Server: Reinstall Server\n
                           EXAMPLE: ApplicationAPI RESRV <SERVER_ID>\n
                        \n
                        * - Note:\n
                            Input MUST be a valid JSON Key|Value pair.\n
                    "
                ;;
                "ROLECALL"|"rolecall"|"RC"|"rc"|"LISTSERVERS"|"listservers")
                    CurlOp "${UrlTarget}/users" "${App_Token}" "GET"
                ;;
                "BACKGROUNDCHECK"|"backgroundcheck"|"BGC"|"bgc")
                    CurlOp "${UrlTarget}/users/${2}" "${App_Token}" "GET"
                ;;
                "PASSPORTCHECK"|"passportcheck"|"ppc"|"PPC")
                    case "${2:-NULL}" in 
                        ""|"NULL"|"null")
                            echo "Target External User ID Required. ApplicationAPI H For More Information" >&2 
                            return 1
                        ;;
                        *)
                            CurlOp "${UrlTarget}/users/external/${2}" "${App_Token}" "GET"
                        ;;
                    esac
                ;;
                "NODELIST"|"nodelist"|"NL"|"nl")
                    CurlOp "${UrlTarget}/nodes" "${App_Token}" "GET"
                ;;
                "NODECHECK"|"nodecheck"|"NCK"|"nck")
                    case "${2:-NULL}" in 
                        ""|"NULL"|"null")
                            echo "Target Node ID Required. ApplicationAPI H For More Information" >&2 
                            return 1
                        ;;
                        *)
                            CurlOp "${UrlTarget}/nodes/${2}" "${App_Token}" "GET"
                        ;;
                    esac
                ;;
                "NODEALLOC"|"nodealloc"|"NAL"|"nal")
                    case "${2:-NULL}" in 
                        ""|"NULL"|"null")
                            echo "Target Node ID Required. ApplicationAPI H For More Information" >&2 
                            return 1
                        ;;
                        *)
                            case "${3:-NULL}" in 
                                ""|"NULL"|"null")
                                    echo "Target Node Allocation Page Required. ApplicationAPI H For More Information" >&2 
                                    return 1
                                ;;
                                *)
                                    CurlOp "${UrlTarget}/nodes/${2}/allocations?per_page=500&page=${3}" "${App_Token}" "GET"
                                ;;
                            
                            esac
                        ;;
                    esac
                ;;
                "TRAVELOPTIONS"|"traveloptions"|"TO"|"to")
                    CurlOp "${UrlTarget}/locations" "${App_Token}" "GET"
                ;;
                "DESTINATIONDETAILS"|"destinationdetails"|"DT"|"dt")
                    case "${2:-NULL}" in 
                        ""|"NULL"|"null")
                            echo "Location ID Required. ApplicationAPI H For More Information" >&2 
                            return 1
                        ;;
                        *)
                            CurlOp "${UrlTarget}/locations/${2}" "${App_Token}" "GET"
                        ;;
                    esac
                ;;
                "SERVERLIST"|"serverlist"|"SL"|"sl")
                    CurlOp "${UrlTarget}/servers" "${App_Token}" "GET"
                ;;
                "SERVERCHECK"|"servercheck"|"SCK"|"sck")
                    case "${2:-NULL}" in 
                        ""|"NULL"|"null")
                            echo "Target Server ID Required. ApplicationAPI H For More Information" >&2 
                            return 1
                        ;;
                        *)
                            CurlOp "${UrlTarget}/servers/${2}" "${App_Token}" "GET"
                        ;;
                    esac
                ;;
                "SERVERFOERIGNCHECK"|"serverforeigncheck"|"SFCK"|"sfck")
                    case "${2:-NULL}" in 
                        ""|"NULL"|"null")
                            echo "Target External Server ID Required. ApplicationAPI H For More Information" >&2 
                            return 1
                        ;;
                        *)
                            CurlOp "${UrlTarget}/servers/external/${2}" "${App_Token}" "GET"
                        ;;
                    esac
                ;;
                "SERVERPATCH"|"serverpatch"|"SRVP"|"srvp")
                    case "${2:-NULL}" in 
                        ""|"NULL"|"null")
                            echo "Target Server ID Required. ApplicationAPI H For More Information" >&2 
                            return 1
                        ;;
                        *)
                            case "${3:-NULL}" in 
                                ""|"NULL"|"null")
                                    echo "Server Patch Payload Required. ApplicationAPI H For More Information" >&2 
                                    return 1
                                ;;
                                *)
                                    CurlOp "${UrlTarget}/servers/${2}/details" "${App_Token}" "PATCH" "${3}" ## ${3} MUST BE A VALID JSON BODY
                                ;;
                            
                            esac
                        ;;
                    esac
                ;;
                "SERVERPATCHBUILD"|"serverpatchbuild"|"SRVPB"|"srvpb")
                    case "${2:-NULL}" in 
                        ""|"NULL"|"null")
                            echo "Target Server ID Required. ApplicationAPI H For More Information" >&2 
                            return 1
                        ;;
                        *)
                            case "${3:-NULL}" in 
                                ""|"NULL"|"null")
                                    echo "Server Build Payload Required. ApplicationAPI H For More Information" >&2 
                                    return 1
                                ;;
                                *)
                                    CurlOp "${UrlTarget}/servers/${2}/build" "${App_Token}" "PATCH" "${3}" ## ${3} MUST BE A VALID JSON BODY
                                ;;
                            
                            esac
                        ;;
                    esac
                ;;
                "SERVERPATCHSTART"|"serverpatchstart"|"SRVPS"|"srvps")
                    case "${2:-NULL}" in 
                        ""|"NULL"|"null")
                            echo "Target Server ID Required. ApplicationAPI H For More Information" >&2 
                            return 1
                        ;;
                        *)
                            case "${3:-NULL}" in 
                                ""|"NULL"|"null")
                                    echo "Server Start Patch Payload Required. ApplicationAPI H For More Information" >&2 
                                    return 1
                                ;;
                                *)
                                    CurlOp "${UrlTarget}/servers/${2}/startup" "${App_Token}" "PATCH" "${3}" ## ${3} MUST BE A VALID JSON BODY
                                ;;
                            
                            esac
                        ;;
                    esac
                ;;
                "SERVERDATABASELIST"|"serverdatabaselist"|"SDBL"|"sdbl")
                    case "${2:-NULL}" in 
                        ""|"NULL"|"null")
                            echo "Target External Server ID Required. ApplicationAPI H For More Information" >&2 
                            return 1
                        ;;
                        *)
                            CurlOp "${UrlTarget}/servers/${2}/databases?include=password,host" "${App_Token}" "GET"
                        ;;
                    esac
                ;;
                "SERVERDATABASECHECK"|"serverdatabasecheck"|"SDBCK"|"sdbck")
                    case "${2:-NULL}" in 
                        ""|"NULL"|"null")
                            echo "Target Server ID Required. ApplicationAPI H For More Information" >&2 
                            return 1
                        ;;
                        *)
                            case "${3:-NULL}" in 
                                ""|"NULL"|"null")
                                    echo "Target Database ID Required. ApplicationAPI H For More Information" >&2 
                                    return 1
                                ;;
                                *)
                                    CurlOp "${UrlTarget}/servers/${2}/databases/${3}" "${App_Token}" "GET"
                                ;;
                            
                            esac
                        ;;
                    esac
                ;;
                "SERVERDATABASECREATE"|"serverdatabasecreate"|"SDBCRT"|"sdbcrt")
                    case "${2:-NULL}" in 
                        ""|"NULL"|"null")
                            echo "Target Server ID Required. ApplicationAPI H For More Information" >&2 
                            return 1
                        ;;
                        *)
                            CurlOp "${UrlTarget}/servers/${2}/databases" "${App_Token}" "POST"
                        ;;
                    esac
                ;;
                "SERVERDATABASEPASSWORD"|"serverdatabasepassword"|"SDBPWD"|"sdbpwd")
                    case "${2:-NULL}" in 
                        ""|"NULL"|"null")
                            echo "Target Server ID Required. ApplicationAPI H For More Information" >&2 
                            return 1
                        ;;
                        *)
                            case "${3:-NULL}" in 
                                ""|"NULL"|"null")
                                    echo "Target Database ID Required. ApplicationAPI H For More Information" >&2 
                                    return 1
                                ;;
                                *)
                                    CurlOp "${UrlTarget}/servers/${2}/databases/${3}/reset-password" "${App_Token}" "POST"
                                ;;
                            
                            esac
                        ;;
                    esac
                ;;
                "SERVERDATABASEDELETE"|"serverdatabasedelete"|"SDBDL"|"sdbdl")
                    case "${2:-NULL}" in 
                        ""|"NULL"|"null")
                            echo "Target Server ID Required. ApplicationAPI H For More Information" >&2 
                            return 1
                        ;;
                        *)
                            case "${3:-NULL}" in 
                                ""|"NULL"|"null")
                                    echo "Target Database ID Required. ApplicationAPI H For More Information" >&2 
                                    return 1
                                ;;
                                *)
                                    CurlOp "${UrlTarget}/servers/${2}/databases/${3}" "${App_Token}" "DELETE"
                                ;;
                            
                            esac
                        ;;
                    esac
                ;;
                "REINSTALLSERVER"|"reinstallserver"|"RESRV"|"resrv")
                    case "${2:-NULL}" in 
                        ""|"NULL"|"null")
                            echo "Target Server ID Required. ApplicationAPI H For More Information" >&2 
                            return 1
                        ;;
                        *)
                            CurlOp "${UrlTarget}/servers/${2}/reinstall" "${App_Token}" "POST"
                        ;;
                    esac
                ;;
                *) echo -e "[ERROR] Invalid Arguement" >&2 ;; ## Obviously you didn't listen and put something stupid.
            esac
        ;;     
    esac
} ## End Of Function