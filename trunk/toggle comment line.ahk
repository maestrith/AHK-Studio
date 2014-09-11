toggle_comment_line(){
	sc:=csc(),sc.2078
	pi:=posinfo(),sl:=sc.2166(pi.start),el:=sc.2166(pi.end),end:=pi.end,single:=sl=el?1:0
	while,(sl<=el){
		letter:=sc.textrange(min:=sc.2128(sl),min+1)
		if (min>end&&!single)
			break
		if (letter=";")
			sc.2190(min),sc.2192(min+1),sc.2194(0,""),end--
		else
			sc.2190(min),sc.2192(min),sc.2194(1,";"),end++
		sl++
	}
	sc.2079
}