brace(){
	brace:
	ControlGetFocus,Focus,A
	sc:=csc(),cp:=sc.2008,line:=sc.2166(cp),et:=xml.ea(settings.ff("//autoadd/key/@trigger",A_ThisHotkey)),ea:=xml.ea(settings.ff("//autoadd/key/@add",A_ThisHotkey)),hotkey:=SubStr(A_ThisHotkey,0)
	if !InStr(Focus,"Scintilla"){
		Send,{%hotkey%}
		return
	}
	if(A_ThisHotkey=Chr(34)){
		if(sc.2010(sc.2008)=13)
			return sc.2003(sc.2008,Chr(34)),sc.2025(sc.2008+1)
	}
	hotkey:=SubStr(A_ThisHotkey,0),add:=ea.add
	if(sc.2102&&v.options.Disable_Auto_Insert_Complete=0){
		word:=sc.getword()
		if(xml.ea(cexml.ssn("//*[@upper='" upper(word) "']")).type~="Method|Function")
			sc.2101
		else{
			sc.2104(),cp:=sc.2008
			if(Chr(sc.2007(sc.2008-1))=hotkey)
				return
		}
	}else
		sc.2101()
	if(sc.2007(sc.2008)=Asc(ea.add)&&v.options.Auto_Advance&&sc.2007(sc.2008)!=0)
		return sc.2025(sc.2008+1)
	if(ea.trigger!=ea.add)
		return sc.2003(sc.2008,ea.add),sc.2025(sc.2008+1)
	if(sc.2008!=sc.2009){
		forward:=[],rev:=[],sc.2078
		loop,% sc.2570
			start:=sc.2585(A_Index-1),end:=sc.2587(A_Index-1),forward[start]:={start:start,end:End}
		for a,b in forward
			rev.Insert(b)
		for a in rev
			info:=rev[rev.MaxIndex()-(A_Index-1)],sc.2190(info.start),sc.2192(info.End),sc.2003(info.end,et.add),sc.2003(info.start,Hotkey),sc.2160(info.start+1,info.end+1)
		for a,b in rev{
			if A_Index=1
				sc.2160(b.start+1,b.end+1)
			else
				sc.2573(b.end+(A_Index*2)-1,b.start+(A_Index*2)-1)
		}
		sc.2079
		return
	}if(hotkey="{"&&sc.2128(line)=cp&&cp=sc.2136(line)&&v.options.full_auto)
		sc.2003(cp,"{`n`n}"),fix_indent(),sc.2025(sc.2136(line+1))
	else
		sc.2003(cp,hotkey et.add),sc.2025(cp+1)
	width:=sc.2276(32,"a"),text1:="Last Entered Character: " hotkey " Code:" Asc(hotkey),SB_SetText(text1,2),SB_SetParts(v.lastwidth,v.lastwidth1:=(width*StrLen(text1 1)),40),replace()
	return
}