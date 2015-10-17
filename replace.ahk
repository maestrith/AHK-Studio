replace(){
	sc:=csc(),cp:=sc.2008,word:=sc.textrange(start:=sc.2266(cp-1,1),end:=sc.2267(cp-1,1)),rep:=settings.ssn("//replacements/*[@replace='" word "']").text
	if(sc.2007(cp)=125&&sc.2007(cp-1)=123&&A_ThisHotkey="+Enter"){
		line:=sc.2166(cp),ll:=sc.getline(line+1),sc.2078,cind:=sc.2127(line),indent:=sc.2121,nl:=sc.2136(line+1)
		if(ll){
			if(ll~="i)^\s*\belse\b"){
				sc.2003(sc.2128(line+1),"}"),sc.2645(cp,1),sc.2003(cp,"`n"),sc.2126(line+1,cind+indent),sc.2025(sc.2128(line+1))
				return sc.2079
			}if(sc.getline(line+2)~="i)^\s*\belse\b"){
				sc.2003(sc.2128(line+2),"}"),sc.2645(cp,1),sc.2126(line+1,cind+indent)
				return sc.2079
			}else
			{
				sc.2003(nl,"`n}"),ind:=sc.2127(line),sc.2126(line+1,ind+indent),sc.2126(line+2,ind),sc.2645(cp,1)
			}
		}else
			sc.2003(cp,"`n`n"),fix_indent(),sc.2025(sc.2128(sc.2166(cp)+1))
		return sc.2079
	}
	if(sc.2007(cp)=125&&sc.2007(cp-1)=123&&(A_ThisHotkey="+Enter"||A_ThisHotkey="Enter")&&v.options.Full_Auto)
		sc.2003(cp,"`n`n"),fix_indent(),sc.2025(sc.2128(sc.2166(cp)+1))
	if !rep
		return
	pos:=1,list:=[],foundList:=[],origRepLen:=StrLen(rep)
	while,pos:=RegExMatch(rep,"U)(\$\||\$.+\b)",found,pos){
		if(!ObjHasKey(foundList,found))
			foundList[found]:=pos,List.Insert(found)
		pos++
	}
	for a,b in List{
		value:=""
		if(b!="$|"){
			value:=InputBox(csc().sc,"Value for " b,"Insert value for: "  b "`n`n" rep)
			if ErrorLevel
				return
			StringReplace,rep,rep,%b%,%value%,All
		}
	}
	if(rep)
		pos:=InStr(rep,"$|"),rep:=RegExReplace(rep,"\$\|"),sc.2190(start),sc.2192(end),sc.2194(StrLen(rep),rep),_:=pos?sc.2025(start+pos-1):""
	else if(A_ThisHotkey="+Enter")
		sc.2160(start+StrLen(rep),start+StrLen(rep))
	if v.options.Auto_Space_After_Comma
		sc.2003(sc.2008," "),sc.2025(sc.2008+1)
	v.word:=rep?rep:word
	SetTimer,automenu,-80
}