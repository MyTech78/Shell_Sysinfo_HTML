Description:
    
    Shell script to generate a system information HTML report. 

Usage: sysinfo_html [OPTION][PATH]

    -o  Save the file to [PATH] and attempt to open the file.
        if no [PATH] is specified the file will be created in the temp directory.
    
    -s  Save the file to [PATH] 
        if no [PATH] is specified the file will be created in the temp directory.

    -v  Version and shell script revision history. 

Examples:

    sh sysinfo_html -s
    sh sysinfo_html -s /home/username/Documents
    sh sysinfo_html -o
    sh sysinfo_html -o /home/usernsme/Documents
    sh sysinfo_html -v
