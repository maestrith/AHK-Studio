Jump_To_Next_Bookmark(){
	sc:=csc(),top:=cexml.ssn("//main[@file='" current(2).file "']"),Code_Explorer.scan(current()),cur:=sc.2008,check:=cexml.ssn("//main[@file='" current(2).file "']/descendant::file[@file='" current(3).file "']")
	if(next:=ssn(top,"descendant::file[@file='" current(3).file "']/descendant::*[@type='Bookmark' and @pos>'" cur "']"))
		ea:=xml.ea(next),line:=sc.2166(ea.pos),sc.2160(sc.2128(line),sc.2136(line))
	else if(next:=sn(check,"following::file/descendant::*[@type='Bookmark']").item[0]){
		next:=sn(check,"following::file/descendant::*[@type='Bookmark']").item[0],tv(files.ssn("//main[@file='" xml.ea(ssn(next,"ancestor::main").firstchild).file "']/descendant::file[@file='" xml.ea(next).file "']/@tv").text)
		Sleep,200
		line:=sc.2166(xml.ea(next).pos),sc.2160(sc.2128(line),sc.2136(line)),CenterSel()
	}else{
		if(next:=sn(top,"descendant::*[@type='Bookmark']").item[0]){
			tv(files.ssn("//main[@file='" xml.ea(ssn(next,"ancestor::main").firstchild).file "']/descendant::file[@file='" xml.ea(next).file "']/@tv").text)
			Sleep,200
			line:=sc.2166(xml.ea(next).pos),sc.2160(sc.2128(line),sc.2136(line)),CenterSel()
		}else
			m("Could not find any bookmarks")
	}
}
Jump_To_Previous_Bookmark(){
	sc:=csc()
	Code_Explorer.scan(current())
	top:=cexml.ssn("//main[@file='" current(2).file "']")
	cur:=sc.2009-1,max:=0
	check:=cexml.ssn("//main[@file='" current(2).file "']/descendant::file[@file='" current(3).file "']")
	if((next:=sn(top,"descendant::file[@file='" current(3).file "']/descendant::*[@type='Bookmark' and @pos<'" cur "']")).length!=0){
		while,nn:=next.item[A_Index-1],ea:=xml.ea(nn)
			if(ea.pos>max)
				max:=ea.pos,last:=nn
		line:=sc.2166(max),sc.2160(sc.2128(line),sc.2136(line))
	}else if((prev:=sn(check,"preceding::*[@type='Bookmark']")).length!=0){
		last:=prev.item[prev.length-1],tv(files.ssn("//main[@file='" current(2).file "']/descendant::file[@file='" xml.ea(last).file "']/@tv").text)
		Sleep,200
		line:=sc.2166(xml.ea(last).pos),sc.2160(sc.2128(line),sc.2136(line))
	}else if((prev:=sn(top.lastchild,"preceding::*[@type='Bookmark']")).length!=0){
		last:=prev.item[prev.length-1],tv(files.ssn("//main[@file='" current(2).file "']/descendant::file[@file='" xml.ea(last).file "']/@tv").text)
		Sleep,200
		line:=sc.2166(xml.ea(last).pos),sc.2160(sc.2128(line),sc.2136(line))
	}else
		m("Could not find any bookmarks")
}