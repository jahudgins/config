executable="$1"
enable="$2"
key="HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\\$executable"

if [[ $enable == "on" ]]
then
	echo Turning on auto debug for $executable
	reg add "$key" //v "Debugger" //t REG_SZ //d "vsjitdebugger.exe" //f
else
	echo Turning off auto debug for $executable
	reg delete "$key" //v "Debugger" //f
fi
