Tab_To_Previous_Comma(){
	sc:=csc(),start:=sc.2128(sc.2166(sc.2008)),cpos:=sc.2008
	sc.2190(start),sc.2192(sc.2008),pos:=1
	found:=[]
	found.Insert(start-1)
	while,pos>0,pos:=sc.2197(1,","){
		if pos<0
			Break
		if sc.2010(pos)!=3
			found.Insert(pos)
		pos++
		sc.2190(pos),sc.2192(cpos)
	}
	if found.MaxIndex()>1
		sc.2160(found[found.MaxIndex()],found[found.MaxIndex()-1]+1)
}