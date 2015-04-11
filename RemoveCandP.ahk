RemoveCandP(cc){
	paren:=0,between:=""
	for a,b in StrSplit(cc){
		if(b="(")
			paren++,open:=1
		if(paren)
			between.=b
		if(b=")")
			paren--
		if(paren=0&&open){
			StringReplace,cc,cc,%between%,% RegExReplace(between,"(\(|\)|,)","_")
			open:=0,between:=""
		}
	}
	return cc
}