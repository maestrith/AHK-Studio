Jump_To_Next_Bookmark(){
	sc:=csc(),line:=sc.2166(sc.2008)
	find:=bookmarks.sn("//file[@file='" current(3).file "']/mark/@line"),found:=[]
	while,ff:=find.item[A_Index-1]
		found[ff.text]:=1
	for a in found
		if (line<a)
			return sc.2024(a)
	if pos:=found.MinIndex()
		sc.2024(pos)
}
Jump_To_Previous_Bookmark(){
	sc:=csc(),line:=sc.2166(sc.2008)
	find:=bookmarks.sn("//file[@file='" current(3).file "']/mark/@line")
	while,ff:=find.item[A_Index-1]
		found.=ff.text ","
	found:=Trim(found,",")
	Sort,found,URD`,
	for a,b in StrSplit(found,",")
		if (line>b)
			return sc.2024(b)
	if pos:=StrSplit(found,",").1
		sc.2024(pos)
}