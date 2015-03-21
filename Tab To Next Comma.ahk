Tab_To_Next_Comma(){
	sc:=csc(),end:=sc.2136(sc.2166(sc.2008))
	if (sc.2008=end)
		return
	sc.2190(sc.2008),sc.2192(sc.2136(end)),pos:=sc.2197(1,",")
	if (sc.2010(pos)!=3&&pos>0){
		sc.2190(pos+1),sc.2192(end),pos1:=sc.2197(1,",")
		pos1:=sc.2010(pos1)!=3?pos1:-1
		if (pos&&pos1)
			sc.2160(pos+1,pos1)
		if (pos&&pos1<0)
			sc.2160(pos+1,end)
	}
}