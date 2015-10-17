CompileFont(XMLObject,rgb:=1){
	ea:=xml.ea(XMLObject),style:=[],name:=ea.name,styletext:="norm"
	for a,b in {bold:"",color:"c",italic:"",size:"s",strikeout:"",underline:""}{
		if(a="color")
			styletext.=" c" _:=rgb?rgb(ea[a]):ea[a]
		else if(ea[a])
			styletext.=" " _:=b?b ea[a]:a
	}
	return styletext
}