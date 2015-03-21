multisel(){
	multisel:
	sc:=csc()
	ControlGetFocus,con,% hwnd([1])
	if !InStr(con,"scintilla"){
		ControlFocus,,% "ahk_id" sc.sc
		return
	}
	if (sc.2102=0&&sc.2570>1){
		main:=sc.2575
		caret:=sc.2577(main)
		anchor:=sc.2579(main)
		sc.2160(caret,anchor)
	}Else{
		ControlSend,,{Escape},% "ahk_id" sc.sc
	}
	return
}