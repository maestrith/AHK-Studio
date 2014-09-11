center(hwnd){
	Gui,%hwnd%:Show,Hide
	WinGetPos,x,y,w,h,% hwnd([1])
	WinGetPos,xx,yy,ww,hh,% hwnd([hwnd])
	centerx:=(Abs(w-ww)/2),centery:=Abs(h-hh)/2
	return "x" x+centerx " y" y+centery
}