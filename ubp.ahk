ubp(sc,file){
	Pos:=0,bml:=[],sort:=[],sc:=csc()
	ll:=bookmarks.sn("//file[@file='" file "']/mark")
	if (files.ssn("//*[@sc!='" sc.2357 "']/@file").text!=file)
		return
	while,node:=ll.item[A_Index-1]{
		ea:=bookmarks.ea(node)
		sort[ea.line]:=node
	}
	for a,b in sort
		bml.Insert(b)
	while,(pos:=sc.2047(pos,16))>=0{
		cur:=bml[A_Index]
		cur.setattribute("line",pos)
		pos++
	}
}