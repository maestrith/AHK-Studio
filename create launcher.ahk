create_launcher(){
	FileDelete,AHK Studio Launcher.exe
	FileDelete,AHK Studio Launcher.ahk
	script=Run,%A_ScriptFullPath%
	FileAppend,%script%,AHK Studio Launcher.ahk
	SplitPath,A_AhkPath,file,dirr
	Loop,%dirr%\Ahk2Exe.exe,1,1
		file:=A_LoopFileFullPath
	RunWait,%file% /in "AHK Studio Launcher.ahk" /icon "%A_ScriptDir%\AHKStudio.ico"
	FileDelete,AHK Studio Launcher.ahk
}