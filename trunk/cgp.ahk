cgp(Control){
	SysGet,Border,7
	SysGet,Caption,4
	pos:=[]
	ControlGetPos,x,y,w,h,,ahk_id%control%
	return pos:={x:x-border,y:y-Border-Caption,w:w,h:h}
}