delete(){
	delete:
	ControlGetFocus,Focus,% hwnd([1])
	if(Focus="SysTreeView321"){
		;node:=files.ssn("//main[@file='" current(2).file "']/descendant::file[@file='" current(3).file "']")
		if(current(2).file=current(3).file)
			Close()
		else
			Remove_Segment()
	}
	return
}