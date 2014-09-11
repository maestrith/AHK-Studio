inputbox(parent,title,prompt,default=""){
	WinGetPos,x,y,,,ahk_id%parent%
	InputBox,var,%title%,%prompt%,,,,%x%,%y%,,,%default%
	if ErrorLevel
		Exit
	return var
}