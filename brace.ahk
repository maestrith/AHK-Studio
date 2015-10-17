brace(){
	brace:
	ControlGetFocus,Focus,A
	sc:=csc(),cp:=sc.2008,line:=sc.2166(cp),et:=xml.ea(settings.ff("//autoadd/key/@trigger",A_ThisHotkey)),ea:=xml.ea(settings.ff("//autoadd/key/@add",A_ThisHotkey)),hotkey:=SubStr(A_ThisHotkey,0)
	if !InStr(Focus,"Scintilla"){
		Send,{%hotkey%}
		return
	}
	if(A_ThisHotkey=Chr(34))
		if(sc.2010(sc.2008)=13)
			return sc.2003(sc.2008,Chr(34)),sc.2025(sc.2008+1)
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
	if(sc.2008!=sc.2009)
		return bookend(et.add,hotkey)
	if(hotkey="{"&&sc.2128(line)=cp&&cp=sc.2136(line)&&v.options.full_auto)
		sc.2003(cp,"{`n`n}"),fix_indent(),sc.2025(sc.2136(line+1))
	else if(hotkey="{"&&sc.2128(line)=cp&&cp!=sc.2136(line)&&v.options.full_auto)
		sc.2078(),backup:=Clipboard,sc.2419(cp,sc.2136(line)),sc.2645(cp,sc.2136(line)-cp),sc.2003(cp,"{`n" clipboard "`n}"),fix_indent(),Clipboard:=backup,sc.2079()
	else
		sc.2003(cp,hotkey et.add),sc.2025(cp+1)
	SetStatus("Last Entered Character: " hotkey " Code:" Asc(hotkey),2),replace()
	return
	match:
	sc:=csc()
	ControlGetFocus,Focus,A
	if(sc.2008!=sc.2009&&InStr(focus,"Scintilla"))
		bookend(v.match[A_ThisHotkey],A_ThisHotkey)
	else
		Send,{%A_ThisHotkey%}
	SetStatus("Last Entered Character: " A_ThisHotkey " Code:" Asc(A_ThisHotkey),2)
	return
}