copy(){
	copy:
	sc:=csc()
	if(!sc.getseltext())
		sc.2455
	else
		Clipboard:=RegExReplace(csc().getseltext(),"\n","`r`n")
	if(hwnd(30)){
		WinActivate,% hwnd([30])
		Sleep,50
		ControlGetFocus,focus,% hwnd([30])
		if InStr(focus,"Edit")
			ControlSetText,%focus%,%Clipboard%,% hwnd([30])
	}
	return
}