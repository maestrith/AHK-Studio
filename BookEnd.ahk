BookEnd(add,hotkey){
	sc:=csc(),forward:=[],rev:=[],sc.2078
	loop,% sc.2570
		start:=sc.2585(A_Index-1),end:=sc.2587(A_Index-1),forward[start]:={start:start,end:End}
	for a,b in forward
		rev.Insert(b)
	for a in rev
		info:=rev[rev.MaxIndex()-(A_Index-1)],sc.2190(info.start),sc.2192(info.End),sc.2003(info.end,add),sc.2003(info.start,Hotkey),sc.2160(info.start+1,info.end+1)
	for a,b in rev{
		if A_Index=1
			sc.2160(b.start+1,b.end+1)
		else
			sc.2573(b.end+(A_Index*2)-1,b.start+(A_Index*2)-1)
	}
	sc.2079
}