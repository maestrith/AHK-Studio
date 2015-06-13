delete_matching_brace(){
	sc:=csc(),value:=[]
	for a,b in [v.braceend,v.bracestart]
		value[b]:=1
	if(v.braceend&&v.bracestart){
		sc.2078()
		text:=Trim(sc.getline(sc.2166(value.MaxIndex())))
		if(sc.2007(value.MinIndex())=125){
			if(RegExReplace(sc.getline(sc.2166(value.MaxIndex())),"(\n|\t| )")="}")
				line:=sc.2166(value.MaxIndex())-1,end:=sc.2136(line),sc.2645(end,sc.2136(line+1)-end)
			else
				RegExMatch(text,"(\}\s*)",found),sc.2645(value.MaxIndex(),StrLen(Trim(found1,"`n")))
		}else
			sc.2645(value.MaxIndex(),1)
		if(sc.2007(value.MinIndex())=123){
			search:=sc.textrange(sc.2128(sc.2166(value.MinIndex())),value.MinIndex()+1)
			RegExMatch(search,"U).*(\s*{)$",found)
			sc.2645(value.MinIndex()-(StrLen(found1)-1),StrLen(found1))
		}else
			sc.2645(value.MinIndex(),1)
		sc.2079()
	}
}