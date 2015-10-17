setpos(tv){
	static
	delay:=(WinActive("A")=hwnd(1))?1:300
	if(delay=1)
		goto,spnext
	SetTimer,spnext,-%delay%
	GuiControl,1:+Redraw,% sc.sc
	return
	spnext:
	sc:=csc(),node:=files.ssn("//*[@sc='" sc.2357 "']"),file:=ssn(node,"@file").text,parent:=ssn(node,"ancestor::main/@file").text,posinfo:=positions.ssn("//main[@file='" parent "']/file[@file='" file "']"),doc:=ssn(node,"@sc").text,ea:=xml.ea(posinfo),fold:=ea.fold,breakpoint:=ea.breakpoint
	if(ea.file){
		Loop,Parse,fold,`,
			sc.2231(A_LoopField)
		Loop,Parse,breakpoint,`,
			sc.2043(A_LoopField,0)
		if(ea.start&&ea.end)
			sc.2160(ea.start,ea.end)
		if(ea.scroll!="")
			SetTimer,setscrollpos,-1
		return
		setscrollpos:
		sc.2613(ea.scroll),sc.2400()
		return
	}
	return
}