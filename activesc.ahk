activesc(){
	WinGetPos,x,y,w,h,% "ahk_id" csc().sc
	return {x:x,y:y,w:w,h:h}
}