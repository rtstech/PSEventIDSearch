##--Script will search defined logs or all logs depending on the user selection for a particular Event ID on a local or remote computer, and save the sesult on a csv file--## 

##--Date variable to get 24 hours event logs--##
$Date = (Get-Date).AddDays(-1)

##--Funtion to provide selection to the user--##

function Get-LogName
{
	$Input_Log= Read-Host "Choose a log name to search: 1 = Application, 2 = System, 3 = Security (Run as administrator), 4 = Not sure (This will search all events therefore can take long time to finish - Run as administrator)
    "
    
	Switch ($Input_Log)
	{
		1 {$Log_Selected="Application"}
		2 {$Log_Selected="System"}
		3 {$Log_Selected="Security"}
        4 {$Log_Selected="Not Sure"}
		}
    return $Log_Selected

    }

##--Capture the selection--##
$LogName = Get-LogName

write-host ""

##--Inform user the option selected--##
Read-host "You have selected $LogName, Press Enter to Continue"

##--Ask user the Event ID to search--##
$Input_EventID = Read-Host -Prompt "Input the Event ID you want to search"

write-host ""

##--Ask user the computer to search above Event ID--##
$Input_Computer = Read-Host -Prompt "Please enter the name or IP address of the computer, to search locally enter 'Localhost'"

write-host ""

##--Ask user where to save the csv file--##
$Output_Location = Read-Host -Prompt "Please enter the file name location you want to save the csv file"

write-host ""

##--If user selected option 4--## 
if ($LogName -eq "Not Sure")
    {

    Read-Host "You may receive unauthorised operation error if not running as administrator. Press Enter to Continue"
    
    ##--Command which will search all Logs--##
    Get-WinEvent -ListLog * | foreach { get-winevent @{logname=$_.logname; starttime=$Date } -ea 0 } | where id -eq $Input_EventID
    
    }
##--For any other selection --##   
else 
    {
    
    ##--Get the variables and perform the search and output the result to a csv file--##
    Get-EventLog -ComputerName $Input_Computer -LogName $LogName -After $Date | Where-Object {$_.EventID -eq $Input_EventID} | export-csv $Output_Location
        
    }
