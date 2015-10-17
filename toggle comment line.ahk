toggle_comment_line(){
	sc:=csc(),sc.2078
	pi:=posinfo(),sl:=sc.2166(pi.start),el:=sc.2166(pi.end),end:=pi.end,single:=sl=el?1:0
	replace:=settings.ssn("//comment").text,replace:=replace?replace:";"
	replace:=RegExReplace(replace,"%a_space%"," ")
	if(v.options.Build_Comment!=1){
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
	}else{
		sc:=csc(),order:=[],pi:=posinfo(),order[sc.2166(sc.2008)]:=1,order[sc.2166(sc.2009)]:=1,min:=order.MinIndex(),max:=order.MaxIndex()
		Loop,% max-min+1{
			if(!RegExMatch(sc.getline(min+(A_Index-1)),"^\s*;")){
				Loop,% max-min+1{
					indentpos:=sc.2128(min+(A_Index-1))
					sc.2003(indentpos,";"),added:=1,pi.end+=1
				}
				pi.start+=1
			}
		}
		if(!added){
			Loop,% max-min+1{
				if(RegExMatch(sc.getline(min+(A_Index-1)),"^\s*;")){
					indentpos:=sc.2128(min+(A_Index-1))
					sc.2645(indentpos,1),pi.end-=1
					if(A_Index=1)
						pi.start-=1
				}
			}
		}
		sc.2160(pi.start,pi.end)
	}
	sc.2079
}