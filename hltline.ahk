hltline(){
	if !settings.ssn("//options/@Highlight_Current_Area").text
		return
	sc:=csc()
	GuiControl,-Redraw,% sc.sc
	sc:=csc(),tab:=sc.2121
	line:=sc.2166(sc.2008)
	sc.2045(2),sc.2045(3)
	if (sc.2127(line)>0){
		up:=down:=line
		ss:=sc.2127(line)-tab
		while,sc.2127(--line)!=ss
			up:=line
		while,sc.2127(++line)!=ss
			down:=line
		if (up=down){
			up--
			sc.2043(up,2)
			sc.2043(down,3)
		}
		Else{
			down+=2,up-=1
			if (down-up>0)
				Loop,% down-up
				{
					if (up=sc.2166(sc.2008))
						sc.2043(up,3)
					Else
						sc.2043(up,2)
					up++
				}
		}
	}
	GuiControl,+Redraw,% sc.sc
}