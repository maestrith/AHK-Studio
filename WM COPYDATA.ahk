WM_COPYDATA(wParam,lParam){
	if wParam != 25565
		return false
	file:=StrGet(NumGet(lparam+8))
	if (file){
		open(file)
		v.tv:=files.ssn("//main[@file='" file "']/file/@tv").text
		WinActivate,% hwnd([1])
		WinWaitActive,% hwnd([1])
		tv(v.tv)
	}
	return true
}