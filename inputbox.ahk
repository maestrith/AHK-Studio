InputBox(parent,title,prompt,default=""){
	WinGetPos,x,y,,,ahk_id%parent%
	RegExReplace(prompt,"\n","",count),count:=count+2,sc:=csc(),height:=(sc.2279(0)*count)+(v.caption*3)+23+34
	InputBox,var,%title%,%prompt%,,,%height%,%x%,%y%,,,%default%
	if ErrorLevel
		Exit
	return var
}