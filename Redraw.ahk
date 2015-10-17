Redraw(){
	if(A_Gui=1)
		WinSet,Redraw,,% hwnd([1])
	else
		Resize("getpos")
}