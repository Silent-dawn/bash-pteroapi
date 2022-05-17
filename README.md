# bash-pteroapi

---

A wrapper for interfacing with the Pterodactyl Api in Bash

**This is not a ready to deploy tool, you'll need to edit it to your needs.**
**This is also not up to date with all API endpoints, when more updates come out I'll map the remaining ones.**

---
## Client API
---

ClientAPI | Pterodactyl Api Wrapper Help Menu:

    Syntax: ClientAPI <Command> <Command Arguements>

Valid Options:

    [ H ] - Help
    [ S ]  - Service Info
    [ GRI ] - Get Resource Info
    [ CMD ] - Send Command To Container
    [ PWR ] - Set Power State
    [ GDB ] - Get Databases
    [ CDB ] - Create Database
    [ RDBP ] - Rotate Database Password
    [ DDB ] - Delete Targeted Database
    [ GA ] - Get Allocation
    [ CA ] - Create Allocation
    [ DA ] - Delete Allocation
    [ AO ] - Allocation Operation  
    [ GSCH ] - Get Schedules Information
    [ CSCH ] - Create Schedule
    [ GSCHD ] - Get Schedule Details
    [ USCH ] - Update Schedule
    [ DSCH ] - Delete Schedule
    [ CTSK ] - Create Task
    [ UTSK ] - Update Task
    [ DTSK ] - Delete Task
    [ GBCK ] - Get Backups
    [ CBCK ] - Create Backup
    [ GBCKD ] - Get Backup Details
    [ GBCKL ] - Get Backup Download Link
    [ DBCK ] - Delete Backup
    [ LS ] - List Startup Variables
    [ ES ] - Edit Startup Variable
    [ RS ] - Reinstall Server
    [ RENS ] - Rename Server

---
## Application API
---

ApplicationAPI | Pterodactyl App API Help Menu:

    Syntax: ApplicationAPI <Command> <Command Argument(s)>

Valid Options:

    [ H ] - Help
    [ RC ] - Rolecall: List Users
    [ BGC ] - Background Check: Retrieve User Details
    [ PPC ] - Passport Check: Retrieve User Details Using External ID
    [ NL ] - Node List: List Nodes
    [ NCK ] - Node Check: Retrieve Node Details
    [ NAL ] - Node Allocations: Retrieve Node Allocations
    [ TO ] - Travel Options: List Locations
    [ DT ] - Destination Details: Retrieve Location Details
    [ SL ] - Server List: List Servers
    [ SCK ] - Server Check: Retrieve Server Details
    [ SFCK ] - Server Foreign Check: Retrieve Server Details Using External ID
    [ SRVP ] - Server Patch: Patch Server Details
    [ SRVPB ] - Server Patch Build: Patch Server Build
    [ SRVPS ] - Server Patch Start: Patch Server Startup
    [ SBL ] - Server Database List: List Server Databases
    [ SBLCK ] - Server Database Check: Check Server Database
    [ SDBCRT ] - Server Database Create: Create Server Database
    [ SDBPWD ] - Server Database Password Rotate: Rotate Server Database Password
    [ SDBDL ] - Server Database Delete: Delete Server Database
    [ RESRV ] - Reinstall Server: Reinstall Server


---
## FAQ
---

### What Does This Do?
    > This is a bash wrapper to help facilitate connecting with the Pterodactyl API.
    > You can use it to manage servers on the API, or as a basis to impliment more complex logic.

### Can I Use This In My Project?
    > Yes, go nuts

### How Do I Use This?

    > You would import it into the shell session using *source*
    > This is meant to be used a library
    ```shell
        source "/path/to/pteroapi.sh"
        ClientAPI H
    ```

### What Can You Do With This Tool?
    > You can make all kinds of cool stuff based on the API.
    > For example, here's me adding and removing 50 ports from an ARK server.
![Ark Demo](../main/README/demo_wrapper.gif)
