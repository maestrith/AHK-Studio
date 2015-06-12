testing(){
	/*
		top:=commands.add2("MultiTip")
		next:=commands.under(top,"If")
		Loop,3
			commands.under(next,"If",{tip:A_Index},"This is tip " A_Index)
		commands.Transform(1)
		m(commands.ssn("//MultiTip").xml),commands.save(1)
		sc:=csc()
		GuiControl,1:-Redraw,% sc.sc
		sleep,1000
		sc.2126(4,20)
		GuiControl,1:+Redraw,% sc.sc
	*/
	/*
		;clean out positions
		file:=positions.sn("//*/@file")
		while,ff:=file.Item[A_Index-1]
			if !FileExist(ff.text)
				ff.ParentNode.RemoveChild(ff)
	*/
}
