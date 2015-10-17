Delete_Matching_Brace(){
	sc:=csc(),value:=[]
	for a,b in [v.braceend,v.bracestart]
		value[b]:=1
	max:=value.MaxIndex(),min:=value.MinIndex()
	if(v.braceend&&v.bracestart){
		sc.2078(),minline:=sc.2166(min),maxline:=sc.2166(max),sc.2645(max,1),sc.2645(min,1),max--,min--,maxtext:=sc.getline(sc.2166(max)),mintext:=sc.getline(sc.2166(min))
		for a,b in {mintext:mintext,maxtext:maxtext}
			%a%:=RegExReplace(RegExReplace(b,"(\t|\R|\s)*$"),"^(\t|\R|\s)*")
		if(maxtext="")
			sc.2645(start:=sc.2136(maxline-1),sc.2136(maxline)-start)
		if(mintext="")
			sc.2645(start:=sc.2136(minline-1),sc.2136(minline)-start)
		if(maxtext){
			sc.2190(sc.2128(maxline)),sc.2192(sc.2136(maxline)),sc.2194(StrLen(maxtext),maxtext)
			if(sc.2166(sc.2008)=maxline)
				sc.2025(sc.2136(maxline))
		}
		if(mintext){
			sc.2190(sc.2128(minline)),sc.2192(sc.2136(minline)),sc.2194(StrLen(mintext),mintext)
			if(sc.2166(sc.2008)=minline)
				sc.2025(sc.2136(minline))
		}
		if(v.options.full_auto)
			NewIndent()
		sc.2079()
	}
}