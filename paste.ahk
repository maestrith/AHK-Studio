paste_func(){
	menupaste:
	SetTimer,paste,-1
	return
	paste:
	Send,^v
	ControlGetFocus,Focus,A
	if(!InStr(focus,"scintilla"))
		return
	if v.options.full_auto
		SetTimer,fix_paste,On
	return
}