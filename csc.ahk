csc(set=0){
	static current
	global findme
	if (get.hwnd){
		return s.ctrl[get.hwnd]
	}
	if (set.hwnd){
		return current:=s.ctrl[set.hwnd]
	}
	if (set=1){
		GuiThreadInfoSize = 48
		NumPut(VarSetCapacity(GuiThreadInfo, GuiThreadInfoSize), GuiThreadInfo, 0)
		DllCall("GetGUIThreadInfo", uint, 0, str, GuiThreadInfo)
		HWND := NumGet(GuiThreadInfo, 12)
		if s.ctrl[hwnd]
			current:=s.ctrl[hwnd]
	}
	if InStr(set,"Scintilla"){
		ControlGet,hwnd,hwnd,,%set%,% hwnd([1])
		current:=s.ctrl[hwnd]
		return current
	}
	if !current{
		ControlGet,hwnd,hwnd,,Scintilla1,% hwnd([1])
		current:=s.ctrl[hwnd]
	}
	return current
}