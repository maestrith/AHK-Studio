csc(set=0){
	static current
	if(get.hwnd)
		return s.ctrl[get.hwnd]
	if(set.hwnd)
		return current:=s.ctrl[set.hwnd]
	if(set=1){
		GuiThreadInfoSize:=48
		NumPut(VarSetCapacity(GuiThreadInfo,GuiThreadInfoSize),GuiThreadInfo,0)
		DllCall("GetGUIThreadInfo",uint,0,str,GuiThreadInfo)
		hwnd:=NumGet(GuiThreadInfo,12)
		if(hwnd=v.debug.sc){
			for a,b in s.ctrl
			{
				current:=b
				break
			}
		}else if s.ctrl[hwnd]
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