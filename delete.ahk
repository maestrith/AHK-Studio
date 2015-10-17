delete(){
	delete:
	ControlGetFocus,Focus,% hwnd([1])
	if(Focus="SysTreeView321"){
		if(current(2).file=current(3).file)
			Close()
		else
			Remove_Segment()
	}
	return
}