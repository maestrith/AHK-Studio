setpos(tv){
	static
	Sleep,0
	sc:=csc()
	GuiControl,-Redraw,% sc.sc
	node:=files.ssn("//*[@tv='" tv "']"),file:=ssn(node,"@file").text,parent:=ssn(node,"../@file").text
	ubp(csc(),file)
	posinfo:=positions.ssn("//main[@file='" parent "']/file[@file='" file "']"),doc:=ssn(node,"@sc").text,ea:=xml.ea(posinfo),fold:=ea.fold,breakpoint:=ea.breakpoint
	Loop,Parse,fold,`,
		sc.2231(A_LoopField)
	Loop,Parse,breakpoint,`,
		sc.2043(A_LoopField,0)
	if ea.start&&ea.end
		sc.2613(ea.scroll),sc.2160(ea.start,ea.end)
	bm:=bookmarks.sn("//file[@file='" file "']/mark")
	while,bb:=bm.item[A_Index-1]
		sc.2043(ssn(bb,"@line").text,4)
	GuiControl,+Redraw,% sc.sc
}