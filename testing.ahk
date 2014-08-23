testing(){
	ControlGetText,text,Edit1,% hwnd([1])
	sc:=csc()
	sc.2366
	sc.2367(0x00200000,text)
	m(text)
	;m("testing")
}