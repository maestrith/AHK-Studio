RButton(){
	RButton:
	MouseGetPos,,,,Control
	if(InStr(Control,"Scintilla")){
		Menu,scrcm,Add,Cut,Cut
		Menu,scrcm,Add,Copy,Copy
		Menu,scrcm,Add,Paste,Paste
		ControlGet,hwnd,hwnd,,%Control%,% hwnd([1])
		if(v.debug.sc&&hwnd=v.debug.sc)
			Menu,scrcm,Add,Close Debug Window,cdw
		Menu,scrcm,Show
		Menu,scrcm,Delete
	}
	return
	cdw:
	stop(1)
	s.delete(v.debug),refresh()
	return
}