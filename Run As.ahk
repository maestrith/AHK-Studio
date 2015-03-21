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
	save(),main:=ssn(current(1),"@file").text
	SplitPath,main,,currentdir
	SplitPath,A_AhkPath,,dir
	ahk:=dir ahk
	if FileExist(ahk)
		Run,% ahk " " Chr(34) ssn(current(1),"@file").text Chr(34),%currentdir%
	Else
		m("Can not find " ahk)
}
run_as_V2(){
	if !FileExist("v2\autohotkey.exe"){
		FileCreateDir,v2
		return m("A folder named v2 has been created in the main AHK Studio folder","Put AutoHotkey.exe (version 2) in it.","Try again")
	}save()
	file:=Chr(34) ssn(current(1),"@file").text Chr(34)
	ahk="%A_ScriptDir%\v2\AutoHotkey.exe"
	Run,%ahk% %file%
}