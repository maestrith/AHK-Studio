set_as_default_editor(){
	pgm=
(
RegWrite,REG_SZ,HKEY_LOCAL_MACHINE,SOFTWARE\Classes\AutoHotkeyScript\Shell\Edit\Command,,"%A_AhkPath%" "%A_ScriptFullPath%" "```%1"
)
	m("The program must be run as administrator to use this feature.")
	dynarun(pgm)
}