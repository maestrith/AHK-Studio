WinPos(hwnd:=1){
	VarSetCapacity(rect,16),DllCall("GetClientRect",ptr,hwnd(hwnd),ptr,&rect)
	WinGetPos,x,y,,,% hwnd([hwnd])
	w:=NumGet(rect,8),h:=NumGet(rect,12),text:=(x!=""&&y!=""&&w!=""&&h!="")?"x" x " y" y " w" w " h" h:""
	return {x:x,y:y,w:w,h:h,text:text}
}