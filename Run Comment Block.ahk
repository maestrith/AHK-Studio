Run_Comment_Block(){
	sc:=csc(),tab:=sc.2121,line:=sc.2166(sc.2008),sc.2045(2),sc.2045(3)
	if (sc.2127(line)>0){
		up:=down:=line
		ss:=sc.2127(line)-tab
		while,sc.2127(--line)!=ss
			up:=line
		while,sc.2127(++line)!=ss
			down:=line
	}
	dynarun(sc.textrange(sc.2128(up),sc.2136(down)))
}