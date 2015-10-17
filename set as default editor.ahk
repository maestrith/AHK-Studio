set_as_default_editor(){
	RegRead,current,HKCU,SOFTWARE\Classes\AutoHotkeyScript\Shell\Edit\Command
	New_Editor="%A_AhkPath%" "%A_ScriptFullPath%" "```%1"
	if(current=RegExReplace(New_Editor,Chr(96)))
		New_Editor="%A_WinDir%\Notepad.exe" "```%1"
	pgm=RegWrite,REG_SZ,HKCU,SOFTWARE\Classes\AutoHotkeyScript\Shell\Edit\Command,,%New_Editor%
	dynarun(pgm)
	Sleep,250
	RegRead,output,HKCU,SOFTWARE\Classes\AutoHotkeyScript\Shell\Edit\Command
	if InStr(output,"ahk studio")
		m("AHK Studio is now your default editor for .ahk file")
	else if InStr(output,"notepad.exe")
		m("Notepad.exe is now your default editor")
	else
		m("Something went wrong :( Please restart Studio and try again.")
}