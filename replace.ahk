replace(){
	sc:=csc(),cp:=sc.2008,word:=sc.textrange(start:=sc.2266(cp-1,1),end:=sc.2267(cp-1,1)),rep:=settings.ssn("//replacements/*[@replace='" word "']").text
	if(sc.2007(sc.2008)=125&&sc.2007(sc.2008-1)=123&&A_ThisHotkey="+Enter"&&v.options.Full_Auto)
		sc.2003(sc.2008,"`n`n"),fix_indent(""),sc.2025(sc.2128(sc.2166(sc.2008)+1))
	if !rep
		return
	pos:=1,list:=[]
	while,pos:=RegExMatch(rep,"U)\$.+\b",found,pos)
		List.Insert(found),pos++
	for a,b in List{
		value:=InputBox(csc().sc,"Value for " b,"Insert value: "  b "`n" rep)
		if ErrorLevel
			return
		StringReplace,rep,rep,%b%,%value%,All
	}
	if rep
		sc.2190(start),sc.2192(end),sc.2194(StrLen(rep),rep)
	if(A_ThisHotkey="+Enter")
		sc.2160(start+StrLen(rep),start+StrLen(rep))
	v.word:=rep?rep:word
	SetTimer,automenu,80
}



if(flan){
	neat :)
}






