toggle_comment_line(){
	sc:=csc(),sc.2078
	pi:=posinfo(),sl:=sc.2166(pi.start),el:=sc.2166(pi.end),end:=pi.end,single:=sl=el?1:0
	replace:=settings.ssn("//comment").text,replace:=replace?replace:";"
	replace:=RegExReplace(replace,"%a_space%"," ")
	while,(sl<=el){
		letter:=sc.textrange(min:=sc.2128(sl),min+StrLen(replace))
		if (min>end&&!single)
			break
		if (letter=replace)
			sc.2190(min),sc.2192(min+StrLen(replace)),sc.2194(0,""),end--
		else
			sc.2190(min),sc.2192(min),sc.2194(StrLen(replace),replace),end++
		sl++
	}
	sc.2079
}