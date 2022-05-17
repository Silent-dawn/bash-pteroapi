#!/bin/bash
# shellcheck enable=require-variable-braces
# shellcheck disable=SC2034,2002,2004,2154,SC1073
## DO NOT REMOVE THESE!
## This is to prevent shellcheck from complaining about false positive issues like unused variables.

## Crash On Fail
set -e pipefail

## Define 4-bit Color Table
Tpurple="\e[35;40m"
TBpurple="\e[95;40m"
Tgreen="\e[32;40m"
TBgreen="\e[92;40m"
White="\e[0;40m"
TBred="\e[91;40m"
Tred="\e[31;40m"
TByellow="\e[93;40m"
Tyellow="\e[33;40m"
Tcyan="\e[36;40m"
TBcyan="\e[96;40m"
## Define 8-bit (256_color) Table
blue="\e[38;5;20m"
Bblue="\e[38;5;21m"
Red="\e[38;5;160m"
Bred="\e[38;5;196m"
Purple="\e[38;5;91m"
Bpurple="\e[38;5;129m"
Magenta="\e[38;5;165m"
Bmagenta="\e[38;5;177m"
Pink="\e[38;5;201m"
Bpink="\e[38;5;213m"
Yellow="\e[38;5;226m"
Byellow="\e[38;5;228m"
Orange="\e[38;5;215m"
Borange="\e[38;5;220m"
Green="\e[38;5;40m"
Bgreen="\e[38;5;47m"
Teal="\e[38;5;43m"
Bteal="\e[38;5;122m"
Cyan="\e[38;5;51m"
Bcyan="\e[38;5;123m"
Grey="\e[38;5;248m"
#shellcheck disable=SC1117
SuccessSymbol="${Bgreen}✔${White}"
ErrorSymbol="${Bred}❗${White}"
WarningSymbol="${Byellow}⚠${White}"
KilledSymbol="${Bred}‼${White}"
OptionSymbol="${Bpurple}--${White}"
HelpNoteSymbol="✨${White}"
CircleSymbol="${Cyan}💠${White}"
## Setup Ptero Vars
HostName="Nightowl Servers"
HostDomain="nightowlservers.net"
ClientToken="MyClientAPI_Key"
AppToken="MyApplicationAPIKey"
PanelHost="panel.${HostDomain}"
TargetUUID="${P_SERVER_UUID::8}"

ClientAPI() {
    ###############################################
    ##        ClientAPI API Wrapper Tool         ##
    ###############################################
    ## Setup the Client Token
    local Client_Token && Client_Token="${ClientToken}" && readonly Client_Token
    # Construct Curl Statement Info
    SVID="${TargetUUID}" && URL="https://${PanelHost}/api/client/servers/${SVID}"
    # Actually Do Something
    case $1 in 
        "HELP"|"help"|"h"|"H")
            echo -e "\n
            ClientAPI | Pterodactyl Api Wrapper Help Menu:\n
            ${CIRCLE_SYMBOL} Syntax: ${Bteal}Legatus${White} <${Magenta}Command${White}> <${Green}Command Arguements${White}>\n
            Valid Options:\n
                ${Cyan}${OptionSymbol} [ ${Magenta}H${White} ] - ${Green}Help${White}\n
                    EXAMPLE: ClientAPI H\n
                ${Cyan}${OptionSymbol} [ ${Magenta}S${White} ]  - ${Green}Service Info${White}\n
                    EXAMPLE: ClientAPI S\n
                ${Cyan}${OptionSymbol} [ ${Magenta}GRI${White} ] - ${Green}Get Resource Info${White}\n
                    EXAMPLE: ClientAPI GRI\n
                ${Cyan}${OptionSymbol} [ ${Magenta}CMD${White} ] - ${Green}Send Command To Container${White}\n
                    EXAMPLE: ClientAPI CMD <COMMAND>\n
                ${Cyan}${OptionSymbol} [ ${Magenta}PWR${White} ] - ${Green}Set Power State${White}\n
                    EXAMPLE: ClientAPI PWR <POWER_STATE>\n
                ${Cyan}${OptionSymbol} [ ${Magenta}GDB${White} ] - ${Green}Get Databases${White}\n
                    EXAMPLE: ClientAPI GDB\n
                ${Cyan}${OptionSymbol} [ ${Magenta}CDB${White} ] - ${Green}Create Database${White} ${HelpNoteSymbol}\n
                    EXAMPLE: ClientAPI CDB <PARAMETERS>\n
                ${Cyan}${OptionSymbol} [ ${Magenta}RDBP${White} ] - ${Green}Rotate Database Password${White}\n
                    EXAMPLE: ClientAPI RDBP\n
                ${Cyan}${OptionSymbol} [ ${Magenta}DDB${White} ] - ${Green}Delete Targeted Database${White}\n
                    EXAMPLE: ClientAPI DDB <TARGET_DATABASE>\n
                ${Cyan}${OptionSymbol} [ ${Magenta}GA${White} ] - ${Green}Get Allocation${White}\n
                    EXAMPLE: ClientAPI GA\n
                ${Cyan}${OptionSymbol} [ ${Magenta}CA${White} ] - ${Green}Create Allocation${White}\n
                    EXAMPLE: ClientAPI CA\n
                ${Cyan}${OptionSymbol} [ ${Magenta}DA${White} ] - ${Green}Delete Allocation${White}\n
                    EXAMPLE: ClientAPI DA <ALLOCATION_ID>\n
                ${Cyan}${OptionSymbol} [ ${Magenta}AO${White} ] - ${Green}Allocation Operation${White} ${HelpNoteSymbol} ${HelpNoteSymbol}${HelpNoteSymbol}\n
                    EXAMPLE: ClientAPI AO <ALLOCATION_ID> <PARAMETERS>\n
                ${Cyan}${OptionSymbol} [ ${Magenta}GSCH${White} ] - ${Green}Get Schedules Information${White}\n
                    EXAMPLE: ClientAPI GSCH\n
                ${Cyan}${OptionSymbol} [ ${Magenta}CSCH${White} ] - ${Green}Create Schedule${White}\n
                    EXAMPLE: ClientAPI CSCH <PARAMETERS>\n
                ${Cyan}${OptionSymbol} [ ${Magenta}GSCHD${White} ] - ${Green}Get Schedule Details${White}\n
                    EXAMPLE: ClientAPI GSCHD\n
                ${Cyan}${OptionSymbol} [ ${Magenta}USCH${White} ] - ${Green}Update Schedule${White}\n
                    EXAMPLE: ClientAPI USCH <SCHEDULE_ID> <PARAMETERS>\n
                ${Cyan}${OptionSymbol} [ ${Magenta}DSCH${White} ] - ${Green}Delete Schedule${White}\n
                    EXAMPLE: ClientAPI DSCH <SCHEDULE_ID>\n
                ${Cyan}${OptionSymbol} [ ${Magenta}CTSK${White} ] - ${Green}Create Task${White}\n
                    EXAMPLE: ClientAPI CTSK <SCHEDULE_ID> <PARAMETERS>\n
                ${Cyan}${OptionSymbol} [ ${Magenta}UTSK${White} ] - ${Green}Update Task${White}\n
                    EXAMPLE: ClientAPI UTSK <SCHEDULE_ID> <TASK_ID> <PARAMETERS>\n
                ${Cyan}${OptionSymbol} [ ${Magenta}DTSK${White} ] - ${Green}Delete Task${White}\n
                    EXAMPLE: ClientAPI DTSK <SCHEDULE_ID> <TASK_ID>\n
                ${Cyan}${OptionSymbol} [ ${Magenta}GBCK${White} ] - ${Green}Get Backups${White}\n
                    EXAMPLE: ClientAPI GBCK\n
                ${Cyan}${OptionSymbol} [ ${Magenta}CBCK${White} ] - ${Green}Create Backup${White}\n
                    EXAMPLE: ClientAPI CBCK\n
                ${Cyan}${OptionSymbol} [ ${Magenta}GBCKD${White} ] - ${Green}Get Backup Details${White}\n
                    EXAMPLE: ClientAPI GBCKD <BACKUP_ID>\n
                ${Cyan}${OptionSymbol} [ ${Magenta}GBCKL${White} ] - ${Green}Get Backup Download Link${White}\n
                    EXAMPLE: ClientAPI GBCKL <BACKUP_ID>\n
                ${Cyan}${OptionSymbol} [ ${Magenta}DBCK${White} ] - ${Green}Delete Backup${White}\n
                    EXAMPLE: ClientAPI DBCK <BACKUP_ID>\n
                ${Cyan}${OptionSymbol} [ ${Magenta}LS${White} ] - ${Green}List Startup Variables${White}\n
                    EXAMPLE: ClientAPI LS\n
                ${Cyan}${OptionSymbol} [ ${Magenta}ES${White} ] - ${Green}Edit Startup Variable${White} ${HelpNoteSymbol}\n
                    EXAMPLE: ClientAPI ES <TARGET_VARIABLE> <PARAMETERS>\n
                ${Cyan}${OptionSymbol} [ ${Magenta}RS${White} ] - ${Green}Reinstall Server${White}\n
                    EXAMPLE: ClientAPI RS\n
                ${Cyan}${OptionSymbol} [ ${Magenta}RENS${White} ] - ${Green}Rename Server${White}\n
                    EXAMPLE: ClientAPI RENS <PARAMETERS>\n
            Valid API Options:\n
                ${Cyan}${OptionSymbol} [ ${Magenta}/allocations${White} ] - ${Green}Automatically Assign A New Allocation${White}\n
                ${Cyan}${OptionSymbol} [ ${Magenta}/allocations/{allocation}${White} ] - ${Green}Set Allocation Note. Json key:value Pair${White}\n
                ${Cyan}${OptionSymbol} [ ${Magenta}/allocations/{allocation}/primary${White} ] - ${Green}Set Primary Allocation${White}\n
            ${HelpNoteSymbol}  - Note:\n
                Input MUST be a valid JSON Key|Value pair!\n
            ${HelpNoteSymbol}${HelpNoteSymbol}  - Note:\n
                This is a post operation. You need to use valid API post operations\n
            "
        ;;
        "SERVICEINFO"|"serviceinfo"|"s"|"S")
            curl -Ss --url "${URL}" \
            -H "Accept: Application/vnd.pterodactyl.v1+json" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer ${Client_Token}" \
            -X "GET"
        ;;
        "GETRESOURCEINFO"|"getresourceinfo"|"gri"|"GRI")
            curl -Ss --url "${URL}/resources" \
            -H "Accept: Application/vnd.pterodactyl.v1+json" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer ${Client_Token}" \
            -X "GET"
        ;;
        "SENDCOMMAND"|"sendcommand"|"cmd"|"CMD")
            curl -Ss --url "${URL}/command" \
            -H "Accept: Application/vnd.pterodactyl.v1+json" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer ${Client_Token}" \
            -X "POST" -d "${2}" ## ${2} Must Be A JSON KEY|VALUE Pair!
        ;;
        "POWERSTATE"|"powerstate"|"pwr"|"PWR")
            curl -Ss --url "${URL}/power" \
            -H "Accept: Application/vnd.pterodactyl.v1+json" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer ${Client_Token}" \
            -X "POST" -d "${2}" ## ${2} Must Be A JSON KEY|VALUE Pair!
        ;;
        "GETDATABASES"|"getdatabases"|"gdb"|"GDB")
            curl -Ss --url "${URL}/databases" \
            -H "Accept: Application/vnd.pterodactyl.v1+json" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer ${Client_Token}" \
            -X "GET"
        ;;
        "CREATEDATABASE"|"createdatabase"|"cdb"|"CDB")
            curl -Ss --url "${URL}/databases" \
            -H "Accept: Application/vnd.pterodactyl.v1+json" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer ${CLIT}" \
            -X "POST" -d "${2}" ## ${2} Must Be A JSON KEY|VALUE Pair!

        ;;
        "ROTATEDATABASEPASSWORD"|"rotatedatabasepassword"|"rdbp"|"RDBP")
            curl -Ss --url "${URL}/databases/${3}/rotate-password" \
            -H "Accept: Application/vnd.pterodactyl.v1+json" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer ${Client_Token}" \
            -X "POST"

        ;;
        "DELETEDATABASE"|"deleteatabase"|"ddb"|"DDB")
            curl -Ss --url "${URL}/databases/${2}" \
            -H "Accept: Application/vnd.pterodactyl.v1+json" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer ${Client_Token}" \
            -X "DELETE"
        ;;
        "GETALLOC"|"getalloc"|"ga"|"GA")
            curl -Ss --url "${URL}/network/allocations" \
            -H "Accept: Application/vnd.pterodactyl.v1+json" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer ${Client_Token}" \
            -X "GET"
        ;;
        "CREATEALLOC"|"createalloc"|"ca"|"CA")
            curl -Ss --url "${URL}/network/allocations" \
            -H "Accept: Application/vnd.pterodactyl.v1+json" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer ${Client_Token}" \
            -X "POST"
        ;;
        "ALLOCOP"|"allocop"|"ao"|"AO")
            curl -Ss --url "${URL}/network/allocations/${2}" \
            -H "Accept: Application/vnd.pterodactyl.v1+json" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer ${Client_Token}" \
            -X "POST" -d "${3}" ## ${3} Must Be A JSON KEY|VALUE Pair!
        ;;
        "GETSCHEDULES"|"getschedules"|"gsch"|"GSCH")
            curl -Ss --url "${URL}/schedules" \
            -H "Accept: Application/vnd.pterodactyl.v1+json" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer ${Client_Token}" \
            -X "GET"
        ;;
        "CREATESCHEDULE"|"createschedule"|"csch"|"CSCH")
            curl -Ss --url "${URL}/schedules" \
            -H "Accept: Application/vnd.pterodactyl.v1+json" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer ${Client_Token}" \
            -X "POST"
        ;;
        "GETSCHEDULEDETAILS"|"getscheduledetails"|"gschd"|"GSCHD")
            curl -Ss --url "${URL}/schedules/${2}" \
            -H "Accept: Application/vnd.pterodactyl.v1+json" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer ${Client_Token}" \
            -X "GET"
        ;;
        "UPDATESCHEDULE"|"updateschedule"|"usch"|"USCH")
            curl -Ss --url "${URL}/schedules/${2}" \
            -H "Accept: Application/vnd.pterodactyl.v1+json" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer ${Client_Token}" \
            -X "POST" -d "${3}" ## ${3} Must Be A JSON KEY|VALUE Body!
        ;;
        "DELETESCHEDULE"|"deleteschedule"|"dsch"|"DSCH")
            curl -Ss --url "${URL}/schedules/${2}" \
            -H "Accept: Application/vnd.pterodactyl.v1+json" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer ${Client_Token}" \
            -X "DELETE"
        ;;
        "CREATETASK"|"createtask"|"ctsk"|"CTSK")
            curl -Ss --url "${URL}/schedules/${2}/tasks" \
            -H "Accept: Application/vnd.pterodactyl.v1+json" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer ${Client_Token}" \
            -X "POST"
        ;;
        "UPDATETASK"|"updatetask"|"utsk"|"UTSK")
            curl -Ss --url "${URL}/schedules/${2}/tasks/${3}" \
            -H "Accept: Application/vnd.pterodactyl.v1+json" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer ${Client_Token}" \
            -X "POST" -d "${4}" ## ${4} MUST BE A VALID JSON KEY|VALUE BODY!
        ;;
        "DELETETASK"|"deletetask"|"dtsk"|"DTSK")
            curl -Ss --url "${URL}/schedules/${2}/tasks/${3}" \
            -H "Accept: Application/vnd.pterodactyl.v1+json" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer ${Client_Token}" \
            -X "DELETE"
        ;;
        "GETBACKUPS"|"getbackups"|"gbck"|"GBCK")
            curl -Ss --url "${URL}/backups" \
            -H "Accept: Application/vnd.pterodactyl.v1+json" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer ${Client_Token}" \
            -X "GET"
        ;;
        "CREATEBACKUP"|"createbackup"|"cbck"|"CBCK")
            curl -Ss --url "${URL}/backups" \
            -H "Accept: Application/vnd.pterodactyl.v1+json" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer ${Client_Token}" \
            -X "POST"
        ;;
        "GETBACKUPDETAILS"|"getbackupdetails"|"gbckd"|"GBCKD")
            curl -Ss --url "${URL}/backups/${2}" \
            -H "Accept: Application/vnd.pterodactyl.v1+json" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer ${Client_Token}" \
            -X "GET"
        ;;
        "GETBACKUPLINK"|"getbackuplink"|"gbckl"|"GBCKL")
            curl -Ss --url "${URL}/backups/${2}/download" \
            -H "Accept: Application/vnd.pterodactyl.v1+json" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer ${Client_Token}" \
            -X "GET"
        ;;
        "DELETEBACKUP"|"deletebackup"|"dbck"|"DBCK")
            curl -Ss --url "${URL}/backups/${2}" \
            -H "Accept: Application/vnd.pterodactyl.v1+json" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer ${Client_Token}" \
            -X "DELETE"
        ;;
        "LISTSTART"|"liststart"|"ls"|"LS")
            curl -Ss --url "${URL}/startup" \
            -H "Accept: Application/vnd.pterodactyl.v1+json" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer ${Client_Token}" \
            -X "GET"
        ;;
        "EDITSTART"|"editstart"|"es"|"ES")
            curl -Ss --url "${URL}/startup/variable" \
            -H "Accept: Application/vnd.pterodactyl.v1+json" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer ${Client_Token}" \
            -X "PUT" -d "${2}" ## ${2} Must Be A JSON KEY|VALUE Pair!
        ;;
        "REINSTALLSERVER"|"reinstallserver"|"rs"|"RS")
            curl -Ss --url "${URL}/settings/reinstall" \
            -H "Accept: Application/vnd.pterodactyl.v1+json" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer ${Client_Token}" \
            -X "POST"
        ;;
        "RENAMESERVER"|"renameserver"|"rens"|"RENS")
            curl -Ss --url "${URL}/settings/rename" \
            -H "Accept: Application/vnd.pterodactyl.v1+json" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer ${Client_Token}" \
            -X "POST" -d "${2}" ## ${2} Must Be A JSON KEY|VALUE Pair!
        ;;
        *) echo -e "[${Bred}ERROR${White}] ${Yellow}Invalid Arguement${White}";; ## Obviously you didn't listen and put something stupid.
    esac
} ## End Of Function

ApplicationAPI() {
    ################################################################
    ##    ApplicationAPI - PTERODACTYL APPLICATION API WRAPPER    ##
    ################################################################
    ## Setup Application Token
    local App_Token && App_Token="${AppToken}" && readonly App_Token
    ## The Emperor has graced you with read perms, and only RW on servers and server databases.
    ## Do not forget this Astartes.
    SVID="${TargetUUID}" && URL="https://${PanelHost}/api/application"
    case "${1}" in
        "HELP"|"help"|"h"|"H") ## Help menu
            echo -e "\n
            ApplicationAPI | Pterodactyl App API Help Menu:\n
            ${CircleSymbol} Syntax: ${Bteal}PteroAppApi${White} <${Magenta}Command${White}> <${Green}Command Argument(s)${White}>\n
            Valid Options:\n
                ${Cyan}${OptionSymbol} [ ${Magenta}H${White} ] - ${Green}Help${White}\n
                    EXAMPLE: ApplicationAPI H\n
                ${Cyan}${OptionSymbol} [ ${Magenta}RC${White} ] - ${Green}Rolecall: List Users${White}\n
                    EXAMPLE: ApplicationAPI RC\n
                ${Cyan}${OptionSymbol} [ ${Magenta}BGC${White} ] - ${Green}Background Check: Retrieve User Details${White}\n
                    EXAMPLE: ApplicationAPI BGC <USER_ID>\n
                ${Cyan}${OptionSymbol} [ ${Magenta}PPC${White} ] - ${Green}Passport Check: Retrieve User Details Using External ID${White}\n
                    EXAMPLE: ApplicationAPI PPC <EXTERNAL_USER_ID>\n
                ${Cyan}${OptionSymbol} [ ${Magenta}NL${White} ] - ${Green}Node List: List Nodes${White}\n
                    EXAMPLE: ApplicationAPI NL\n
                ${Cyan}${OptionSymbol} [ ${Magenta}NCK${White} ] - ${Green}Node Check: Retrieve Node Details${White}\n
                    EXAMPLE: ApplicationAPI NCK <NODE_ID>\n
                ${Cyan}${OptionSymbol} [ ${Magenta}NAL${White} ] - ${Green}Node Allocations: Retrieve Node Allocations${White}\n
                    EXAMPLE: ApplicationAPI NAL <NODE_ID>\n
                ${Cyan}${OptionSymbol} [ ${Magenta}TO${White} ] - ${Green}Travel Options: List Locations${White}\n
                    EXAMPLE: ApplicationAPI TO\n
                ${Cyan}${OptionSymbol} [ ${Magenta}DT${White} ] - ${Green}Destination Details: Retrieve Location Details${White}\n
                    EXAMPLE: ApplicationAPI DT <LOCATION_ID>\n
                ${Cyan}${OptionSymbol} [ ${Magenta}SL${White} ] - ${Green}Server List: List Servers${White}\n
                    EXAMPLE: ApplicationAPI SL\n
                ${Cyan}${OptionSymbol} [ ${Magenta}SCK${White} ] - ${Green}Server Check: Retrieve Server Details${White}\n 
                    EXAMPLE: ApplicationAPI SCK <SERVER_ID>\n
                ${Cyan}${OptionSymbol} [ ${Magenta}SFCK${White} ] - ${Green}Server Foreign Check: Retrieve Server Details Using External ID${White}\n
                    EXAMPLE: ApplicationAPI SFCK <EXTERNAL_SERVER_ID>\n
                ${Cyan}${OptionSymbol} [ ${Magenta}SRVP${White} ] - ${Green}Server Patch: Patch Server Details${White} ${HelpNoteSymbol}\n
                    EXAMPLE: ApplicationAPI SRVP <SERVER_ID> <PARAMETERS>\n
                ${Cyan}${OptionSymbol} [ ${Magenta}SRVPB${White} ] - ${Green}Server Patch Build: Patch Server Build${White} ${HelpNoteSymbol}\n
                    EXAMPLE: ApplicationAPI SRVPB <SERVER_ID> <PARAMETERS>\n
                ${Cyan}${OptionSymbol} [ ${Magenta}SRVPS${White} ] - ${Green}Server Patch Start: Patch Server Startup${White} ${HelpNoteSymbol}\n
                    EXAMPLE: ApplicationAPI SRVPS <SERVER_ID> <PARAMETERS>\n
                ${Cyan}${OptionSymbol} [ ${Magenta}SBL${White} ] - ${Green}Server Database List: List Server Databases${White}\n
                    EXAMPLE: ApplicationAPI SBL\n
                ${Cyan}${OptionSymbol} [ ${Magenta}SBLCK${White} ] - ${Green}Server Database Check: Check Server Database${White}\n
                    EXAMPLE: ApplicationAPI SBLCK <SERVER_ID> <DATABASE_ID>\n
                ${Cyan}${OptionSymbol} [ ${Magenta}SDBCRT${White} ] - ${Green}Server Database Create: Create Server Database${White}\n
                    EXAMPLE: ApplicationAPI SDBCRT <SERVER_ID>\n
                ${Cyan}${OptionSymbol} [ ${Magenta}SDBPWD${White} ] - ${Green}Server Database Password Rotate: Rotate Server Database Password${White}\n
                    EXAMPLE: ApplicationAPI SDBPWD <SERVER_ID> <DATABASE_ID>\n
                ${Cyan}${OptionSymbol} [ ${Magenta}SDBDL${White} ] - ${Green}Server Database Delete: Delete Server Database${White}\n
                    EXAMPLE: ApplicationAPI SDBCL <SERVER_ID> <DATABASE_ID>\n
                ${Cyan}${OptionSymbol} [ ${Magenta}RESRV${White} ] - ${Green}Reinstall Server: Reinstall Server${White}\n
                    EXAMPLE: ApplicationAPI RESRV <SERVER_ID>\n
                \n
                ${HelpNoteSymbol}  - Note:\n
                    Input MUST be a valid JSON Key|Value pair.\n
            "
        ;;
        "ROLECALL"|"rolecall"|"RC"|"rc")
            curl -Ss --url "${URL}/users" \
            -H "Accept: Application/vnd.pterodactyl.v1+json" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer ${App_Token}" \
            -X "GET"
        ;;
        "BACKGROUNDCHECK"|"backgroundcheck"|"BGC"|"bgc")
            curl -Ss --url "${URL}/users/${2}" \
            -H "Accept: Application/vnd.pterodactyl.v1+json" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer ${App_Token}" \
            -X "GET"
        ;;
        "PASSPORTCHECK"|"passportcheck"|"ppc"|"PPC")
            curl -Ss --url "${URL}/users/external/${2}" \
            -H "Accept: Application/vnd.pterodactyl.v1+json" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer ${App_Token}" \
            -X "GET"
        ;;
        "NODELIST"|"nodelist"|"NL"|"nl")
            curl -Ss --url "${URL}/nodes" \
            -H "Accept: Application/vnd.pterodactyl.v1+json" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer ${App_Token}" \
            -X "GET"
        ;;
        "NODECHECK"|"nodecheck"|"NCK"|"nck")
            curl -Ss --url "${URL}/nodes/${2}" \
            -H "Accept: Application/vnd.pterodactyl.v1+json" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer ${App_Token}" \
            -X "GET"
        ;;
        "NODEALLOC"|"nodealloc"|"NAL"|"nal")
            curl -Ss --url "${URL}/nodes/${2}/allocations?per_page=500&page=${3}" \
            -H "Accept: Application/vnd.pterodactyl.v1+json" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer ${App_Token}" \
            -X "GET"
        ;;
        "TRAVELOPTIONS"|"traveloptions"|"TO"|"to")
            curl -Ss --url "${URL}/locations" \
            -H "Accept: Application/vnd.pterodactyl.v1+json" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer ${App_Token}" \
            -X "GET"
        ;;
        "DESTINATIONDETAILS"|"destinationdetails"|"DT"|"dt")
            curl -Ss --url "${URL}/locations/${2}" \
            -H "Accept: Application/vnd.pterodactyl.v1+json" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer ${App_Token}" \
            -X "GET"
        ;;
        "SERVERLIST"|"serverlist"|"SL"|"sl")
            curl -Ss --url "${URL}/servers" \
            -H "Accept: Application/vnd.pterodactyl.v1+json" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer ${App_Token}" \
            -X "GET"
        ;;
        "SERVERCHECK"|"servercheck"|"SCK"|"sck")
            curl -Ss --url "${URL}/servers/${2}" \
            -H "Accept: Application/vnd.pterodactyl.v1+json" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer ${App_Token}" \
            -X "GET"
        ;;
        "SERVERFOERIGNCHECK"|"serverforeigncheck"|"SFCK"|"sfck")
            curl -Ss --url "${URL}/servers/external/${2}" \
            -H "Accept: Application/vnd.pterodactyl.v1+json" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer ${App_Token}" \
            -X "GET"
        ;;
        "SERVERPATCH"|"serverpatch"|"SRVP"|"srvp")
            curl -Ss --url "${URL}/servers/${2}/details" \
            -H "Accept: Application/vnd.pterodactyl.v1+json" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer ${App_Token}" \
            -X "PATCH" -d "${3}" ## ${3} MUST BE A VALID JSON BODY!
        ;;
        "SERVERPATCHBUILD"|"serverpatchbuild"|"SRVPB"|"srvpb")
            curl -Ss --url "${URL}/servers/${2}/build" \
            -H "Accept: Application/vnd.pterodactyl.v1+json" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer ${App_Token}" \
            -X "PATCH" -d "${3}" ## ${3} MUST BE A VALID JSON BODY!
        ;;
        "SERVERPATCHSTART"|"serverpatchstart"|"SRVPS"|"srvps")
            curl -Ss --url "${URL}/servers/${2}/startup" \
            -H "Accept: Application/vnd.pterodactyl.v1+json" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer ${App_Token}" \
            -X "PATCH" -d "${3}" ## ${3} MUST BE A VALID JSON BODY!
        ;;
        "SERVERDATABASELIST"|"serverdatabaselist"|"SDBL"|"sdbl")
            curl -Ss --url "${URL}/servers/${2}/databases?include=password,host" \
            -H "Accept: Application/vnd.pterodactyl.v1+json" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer ${App_Token}" \
            -X "GET"
        ;;
        "SERVERDATABASECHECK"|"serverdatabasecheck"|"SDBCK"|"sdbck")
            curl -Ss --url "${URL}/servers/${2}/databases/${3}" \
            -H "Accept: Application/vnd.pterodactyl.v1+json" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer ${App_Token}" \
            -X "GET"
        ;;
        "SERVERDATABASECREATE"|"serverdatabasecreate"|"SDBCRT"|"sdbcrt")
            curl -Ss --url "${URL}/servers/${2}/databases" \
            -H "Accept: Application/vnd.pterodactyl.v1+json" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer ${App_Token}" \
            -X "POST"
        ;;
        "SERVERDATABASEPASSWORD"|"serverdatabasepassword"|"SDBPWD"|"sdbpwd")
            curl -Ss --url "${URL}/servers/${2}/databases/${3}/reset-password" \
            -H "Accept: Application/vnd.pterodactyl.v1+json" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer ${App_Token}" \
            -X "POST"
        ;;
        "SERVERDATABASEDELETE"|"serverdatabasedelete"|"SDBDL"|"sdbdl")
            curl -Ss --url "${URL}/servers/${2}/databases/${3}" \
            -H "Accept: Application/vnd.pterodactyl.v1+json" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer ${App_Token}" \
            -X "DELETE"
        ;;
        "REINSTALLSERVER"|"reinstallserver"|"RESRV"|"resrv")
            curl -Ss --url "${URL}/servers/${2}/reinstall" \
            -H "Accept: Application/vnd.pterodactyl.v1+json" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer ${App_Token}" \
            -X "POST"
        ;;
        *) echo -e "[${Bred}ERROR${White}] ${Yellow}Invalid Arguement${White}";; ## Obviously you didn't listen and put something stupid.
    esac
} ## End Of Function