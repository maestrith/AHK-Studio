Remove_Spaces_From_Selected(){
	sc:=csc(),pos:=posinfo()
	replace:=sc.textrange(pos.start,pos.end)
	replace:=RegExReplace(replace,"[ \t]")
	sc.2170(0,replace)
}
RemoveSpacesFromAroundCommas(){
	sc:=csc()
	replace:=sc.getseltext()
	if !replace
		return m("Please select some text")
	replace:=RegExReplace(replace,",\s*",",")
	replace:=RegExReplace(replace,"\s*,",",")
	sc.2170(0,replace)
}