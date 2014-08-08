run_as_ansii(){
	run_as("\AutoHotkeyA32.exe")
}
run_as_u64(){
	run_as("\AutoHotkeyU64.exe")
}
run_as_u32(){
	run_as("\AutoHotkeyU32.exe")
}
run_as(ahk){
	if !current(1).xml
		return
	save()
	SplitPath,A_AhkPath,,dir
	ahk:=dir ahk
	if FileExist(ahk)
		Run,% ahk " " Chr(34) ssn(current(1),"@file").text Chr(34)
	Else
		m("Can not find " ahk)	
}