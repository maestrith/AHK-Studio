OtherInstance(){
	WinGet,Wins,List,%A_ScriptFullPath% ahk_class AutoHotkey
	Loop, %Wins%
		if (Wins%A_Index% != A_ScriptHwnd)
			return Wins%A_Index%
	return 0
}