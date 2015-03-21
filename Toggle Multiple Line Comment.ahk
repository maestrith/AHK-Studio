Toggle_Multiple_Line_Comment(){
	sc:=csc(),pos:=posinfo()
	GuiControl,-Redraw,% csc().sc
	if(sc.2010(sc.2008)!=11&&sc.2010(sc.2009)!=11)
		sc.2078(),start:=sc.2128(sline:=sc.2166(pos.start)),end:=sc.2136(sc.2166(pos.end)),sc.2003(end,"`n*/"),sc.2003(start,"/*`n"),sc.2079,edit:=1
	else{
		top:=sc.2225(sc.2166(sc.2008)),bottom:=sc.2224(top,-1)
		if (Trim(Trim(sc.getline(top)),"`n")="/*"){
			sc.2078
			for a,b in [bottom,top]{
				start:=sc.2167(b),length:=(sc.2136(b)+1)-start
				start:=sc.2136(b)=sc.2006?start-1:start
				sc.2645(start,length)
			}
			sc.2079
		}
	}if(v.options.full_auto){
		fix_indent()
		if(sline)
			sc.2025(sc.2128(sline+1))
		Sleep,100
	}if(edit){
		line:=sc.2225(sc.2166(pos.start)+1),end:=sc.2224(line,-1)
		Loop,% end+1-line
		{
			style:=sc.2533(line+(A_Index-1))
			if style in 0,31,33
				sc.2242(4,1),sc.2240(4,5),sc.2532(line+(A_Index-1),30)
		}
	}
	GuiControl,+Redraw,% csc().sc
}