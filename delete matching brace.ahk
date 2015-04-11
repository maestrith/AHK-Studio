delete_matching_brace(){
	sc:=csc(),value:=[]
	for a,b in [v.braceend,v.bracestart]
		value[b]:=1
	if(v.braceend&&v.bracestart){
		sc.2078()
		if(RegExReplace(sc.getline(sc.2166(value.MaxIndex())),"(\n|\t| )")="}")
			line:=sc.2166(value.MaxIndex())-1,end:=sc.2136(line),sc.2645(end,sc.2136(line+1)-end)
		else
			sc.2645(value.MaxIndex(),1)
		sc.2645(value.MinIndex(),1),sc.2079()
	}
}