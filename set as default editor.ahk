set_as_default_editor(){
	pgm=RegWrite,REG_SZ,HKCU,SOFTWARE\Classes\AutoHotkeyScript\Shell\Edit\Command,,"%A_AhkPath%" "%A_ScriptFullPath%" "```%1"
	dynarun(pgm)
	RegRead,output,REG_SZ,HKCU,SOFTWARE\Classes\AutoHotkeyScript\Shell\Edit\Command
	if InStr(output,"ahk studio")
		m("AHK Studio is now your default editor for .ahk file")
	else
		m("Something went wrong :( Please restart Studio and try again.")
}