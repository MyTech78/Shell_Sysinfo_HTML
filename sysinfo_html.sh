#!/bin/bash

# sysinfo_html - this is a System Information HTML report, generated via bash script 


#################### Declarations ####################

CURRENTVERSION="0.1"
FILE_NAME="/sysinfo_html.html"
HOST=$(hostname)
TITLE="System Information for $HOST"
RIGHT_NOW=$(date +"%x %r %Z")
TIME_STAMP="Updated on $RIGHT_NOW by $USER"


#################### Functions ####################

# Description of how to use this shell script
usage()
{
cat <<EOF
sysinfohtml
Description:
    
    Shell script to generate a system information HTML report 

Usage: sysinfo_html [OPTION][PATH]

    -o  Save the file to [PATH] and attempt to open the file.
        if no [PATH] is specified the file will be created in the temp directory.
    
    -s  Save the file to [PATH]. 
        if no [PATH] is specified the file will be created in the temp directory.

    -v  Version and shell script revision history. 

Examples:

    sh sysinfo_html -s
    sh sysinfo_html -s /home/usernsme/Documents
    sh sysinfo_html -o
    sh sysinfo_html -o /home/usernsme/Documents
    sh sysinfo_html -v


EOF
}

# File version revision history
# to be updated every time there is a version change
revision()
{
cat <<EOF

REVISION HISTORY
------------------------------------------------------------------

Date:           19/04/2021
Version:        0.1
Author:         Filipe soares
Github repo:    https://github.com/MyTech78/sysinfo_html_shell
Description:    First draft, creating a shell script to 
                generate a system information HTML report  

------------------------------------------------------------------
EOF
}

# Check if supported browsers are installed
browser_id()
{
    if command -v firefox >/dev/null; then
        browserID="firefox"
    elif command -v google >/dev/null; then
        browserID="google"
    else 
        echo 
        echo "Error: No supported browser found to open report automatically" 
        echo "but the file can still be found in your argument [PATH]"
        echo "if no [PATH] argument was specified the file will be in the temp directory"
        echo "usualy this is located in /tmp$FILE_NAME"
        echo
        exit 1   
    fi
}


# Open HTML report file
Openfile()
{
    #FILE_PATH="$TEMP_PATH$FILE_NAME"
    $browserID $FILE_PATH&
}


# Gather system information for report
system_info()
{
    echo "<h3>System release info</h3>"
    echo "<pre>"
    hostnamectl
    #lsb_release -a
    #echo "<a>kernel-release: $(uname -r)</a>"
    #echo "<a>Architecture:   $(uname -i)</a>"
    echo "</pre>"
}


# Gather CPU information for the report 
CPU_info()
{
    echo "<h3>CPU info</h3>"
    echo "<pre>"
    lscpu
    echo "</pre>"
}


# Gather Memory information for the report 
MEM_info()
{
    echo "<h3>Memory info Mb</h3>"
    echo "<pre>"
    free -m
    echo "</pre>"
}


# Gather system uptime for the report 
show_uptime()
{
    echo "<h3>System uptime</h3>"
    echo "<pre>"
    uptime -s
    uptime -p
    echo "</pre>"
}


# Gather driver space information for the report 
drive_space()
{
    echo "<h3>Filesystem space</h3>"
    echo "<pre>"
    df -BM -P
    echo "</pre>"
}



# Gather home space information for the report 
home_space()
{
    echo "<h3>Home directory space by user</h3>"
    echo "<pre>"
    echo "Bytes Directory"
    du -s -BM /home/* | sort -nr
    echo "</pre>"
}

# Gather Network information for the report
network_info()
{
    echo "<h3>Network info</h3>"
    echo "<pre>"
    echo "<a>Hostname:       $(hostname)</a>"
    echo "<a>IP Addresses:   $(hostname -I)</a>"
    echo "<a>MAC Addresses:  $(ifconfig -a | grep ether | awk '{print $2}')</a>"
    echo "</pre>"
}

createfile()
{
    # Set the file path  
    FILE_PATH="$TEMP_PATH$FILE_NAME"
    
    # Create the file
    echo "<html>" >$FILE_PATH
    echo "<head>" >>$FILE_PATH
    echo "<title>$TITLE</title>" >>$FILE_PATH
    echo "</head>" >>$FILE_PATH
    echo "<body>" >>$FILE_PATH
    echo "<h1>$TITLE</h1>" >>$FILE_PATH
    echo "<p><small>$TIME_STAMP</small></p>" >>$FILE_PATH
    echo "<p>$(system_info)</p>" >>$FILE_PATH
    echo "<p>$(show_uptime)</p>" >>$FILE_PATH
    echo "<p>$(network_info)</p>" >>$FILE_PATH
    echo "<p>$(CPU_info)</p>" >>$FILE_PATH
    echo "<p>$(MEM_info)</p>" >>$FILE_PATH
    echo "<p>$(drive_space)</p>" >>$FILE_PATH
    echo "<p>$(home_space)</p>" >>$FILE_PATH
    echo "</body>" >>$FILE_PATH
    echo "</html>" >>$FILE_PATH

    sleep 1s

    if [ -f $FILE_PATH ]; then
        echo "file created in $FILE_PATH"
    else
        echo "oh no! it looks like you do not have access to this directory"
        echo "but don't worry, just try sudo sh sysinfo_html instaed"
        echo "alternatively just try a different [PATH]"
    fi
}

#################### Main Script ####################


# check argument behavior
# check the number of arguments
if [ $# = 0 ]; then
    # how to use description
    usage
# check the number of arguments
elif [ $# = 1 ]; then
    # check arguments value for silent behavior 
    if [ $1 = "-s" ]; then
        # set the TEMP_PATH variable to temp directory
        TEMP_PATH="/tmp"
        # atempt to create file
        createfile
        # exit script
        exit 0
    # check arguments value for open file behavior  
    elif [ $1 = "-o" ]; then
        # set the TEMP_PATH variable to temp directory
        TEMP_PATH="/tmp"
        # atempt to create file
        createfile
        # message to console
        echo "attempting to open file..."
        # run supported browser check
        browser_id
        # atempt to open html file 
        Openfile
        # exist script
        exit 0
    # check arguments value for open file behavior  
    elif [ $1 = "-v" ]; then
        # message revision control to console
        revision
        # message script version to console 
        echo "Current Version: "$CURRENTVERSION
    # if no maching arguments then     
    else
        # message to console
        echo "invalid argument"
        # how to use description
        usage
        # exit script
        exit 1
    # end of if statment    
    fi
# check the number of arguments    
elif [ $# = 2 ]; then
    # check arguments value for silent behavior 
    if [ $1 = "-s" ]; then
        # set the TEMP_PATH variable from 2nd argument value 
        TEMP_PATH=$2
        # atempt to create file
        createfile 2> /dev/null
        # exit script
        exit 0
    # check arguments value for open file behavior     
    elif [ $1 = "-o" ]; then
        # set the TEMP_PATH variable from 2nd argument value 
        TEMP_PATH=$2
        # atempt to create file
        createfile
        # message to console
        echo "attempting to open file..."
        # run supported browser check
        browser_id
        # atempt to open html file 
        Openfile
        # exit script
        exit 0
    # if no maching arguments then     
    else
        # message to console
        echo "invalid argument"
        # how to use description
        usage
        # exit script
        exit 1
    # end of if statment     
    fi    
# if no maching arguments then 
else 
    echo "Too many arguments"
    # how to use description
    usage
    # exit script
    exit 1
# end of if statment    
fi
