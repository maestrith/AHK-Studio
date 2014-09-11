paste(){
	paste:
	ControlGetFocus,Focus,A
	if !InStr(Focus,"Scintilla"){
		ControlSend,%focus%,^v
		return
	}
	csc().2179
	if v.options.full_auto
		SetTimer,fix_paste,On
	return
}