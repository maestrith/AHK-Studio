SetStatus(text,part=""){
	static widths:=[],width
	if(IsObject(text))
		return sc:=csc(),ea:=xml.ea(text),sc.2056(99,ea.font),sc.2055(99,ea.size),width:=sc.2276(99,"a")+1
 	if(part=1)
		widths.3:=0
	widths[part]:=width*StrLen(text 1),SB_SetParts(widths.1,widths.2,widths.3),SB_SetText(text,part)
}