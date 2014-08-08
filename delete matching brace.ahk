delete_matching_brace(){
	sc:=csc(),value:=[]
	for a,b in [v.braceend,v.bracestart]
		value[b]:=1
	if (v.braceend&&v.bracestart)
		sc.2078()sc.2645(value.MaxIndex(),1),sc.2645(value.MinIndex(),1),sc.2079()
}