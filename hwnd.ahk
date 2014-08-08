hwnd(win,hwnd=""){
	static window:=[],remove
	if win=get
		return window
	if (win.rem){
		Gui,1:-Disabled
		Gui,1:Default
		if !window[win.rem]
			Gui,% win.rem ":Destroy"
		Else
			DllCall("DestroyWindow",uptr,window[win.rem])
		window.remove(win.rem)
	}
	if IsObject(win)
		return "ahk_id" window[win.1]
	if !hwnd
		return window[win]
	window[win]:=hwnd
	return
}