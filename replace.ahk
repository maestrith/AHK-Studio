replace(){
	sc:=csc(),cp:=sc.2008,word:=sc.textrange(start:=sc.2266(cp-1,1),end:=sc.2267(cp-1,1)),rep:=settings.ssn("//replacements/*[@replace='" word "']").text
	if !rep
		return
	pos:=1,list:=[]
	while,pos:=RegExMatch(rep,"U)\$.+\b",found,pos)
		List.Insert(found),pos++
	for a,b in List{
		InputBox,value,Value for %b%,Insert value %b%`n%rep%
		if ErrorLevel
			return
		StringReplace,rep,rep,%b%,%value%,All
	}
	if rep
		sc.2190(start),sc.2192(end),sc.2194(StrLen(rep),rep)
	v.word:=rep?rep:word
	SetTimer,automenu,80
}