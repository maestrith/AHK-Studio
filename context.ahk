context(return=""){
	static lasttip
	sc:=csc()
	if sc.2102
		return
	cp:=sc.2008,kw:=v.kw,add:=0,pos:=cp-1,start:=sc.2128(sc.2166(cp))
	if (start>=pos+1)
		return
	content:=sc.textrange(start,pos+1),RegExMatch(content,"(#?\w+)",word)
	cb:=RegExReplace(content,"U)"  Chr(34) "(.*)" Chr(34))
	cb:=InStr(cb,Chr(34))?SubStr(cb,1,InStr(cb,Chr(34))):cb,cou:=[],cbb:=cb,ccc:=0
	for a,b in StrSplit(cb){
		if (b="(")
			ccc++
		else if (b=")")
			ccc--
	}
	cbb:=SubStr(cbb,1,InStr(cbb,"(",0,1,ccc)),RegExMatch(cbb,"(\w+)\($",command)
	found:=kw[command1]?kw[command1]:kw[word1]
	if return
		return found
	if !(found){
		RegExMatch(cbb,"U)\s*(\w*)\." command1 "\($",found)
		class:=ssn(cexml.ssn("//main[@file='" current(2).file "']/descendant::*[@type='Object'][@upper='" upper(found1) "']"),"@class").text
		args:=ssn(cexml.ssn("//main[@file='" current(2).file "']/descendant::*[@type='Class' and @upper='" upper(class) "']/descendant::*[@type='Method' or @type='Property'][@upper='" upper(command1) "']"),"@args").text
		if(args){
			info:=found1 "." command1 "(" args ")"
			goto,conbottom
		}
	}
	if !(found){
		StringUpper,search,command1
		ea:=xml.ea(cexml.ssn("//main[@file='" current(2).file "']/descendant::file/info[@type='Function' and @upper='" search "']"))
		if cmd:=ea.text{
			info:=syn:=cmd "(" ea.args ")",found:=cmd
			goto,conbottom
		}
		return
	}
	if syn:=commands.ssn("//Commands/*[text()='" found "']/@syntax").text
		info:=found " " syn
	else
	{
		root:=commands.sn("//Context/" found "/syntax")
		while,r:=root.item(A_Index-1)
			if cc:=RegExMatch(cb,"i)\b(" RegExReplace(r.text," ","|") ")\b",ff){
			info:=ssn(r,"@syntax").text
			break
		}
		if !cc
			return
		info:=SubStr(cb,1,cc+StrLen(ff)-1) " " info
	}
	conbottom:
	RegExReplace(info,",","",count)
	if !count
		return sc.2207(0),sc.2200(start,info),sc.2204(0,StrLen(info))
	newstr:=RegExReplace(SubStr(cb,InStr(cb,found)+StrLen(found)),"U)\((.*)\)"),newstr:=Trim(newstr,"("),RegExReplace(newstr,",","",count)
	ss:=InStr(info,",",0,1,count),ee:=InStr(info,",",0,1,count+1),ss:=count=0&&InStr(info,"(")?InStr(info,"("):ss
	;info:=Chr(1) "2 of 3" Chr(2) " testing " then use the notify to get the clicks
	if(lasttip!=info)
		sc.2201(),sc.2200(start,info)
	if !sc.2202
		sc.2200(start,info),sc.2207(0xFF0000)
	if (ss&&ee)
		sc.2204(ss,ee)
	else if (ss&&ee=0)
		sc.2204(ss,StrLen(info))
	else if (ss=0&&ee)
		sc.2204(ss,ee)
	else
		sc.2207(0x0000FF),sc.2204(0,StrLen(info))
	lasttip:=info
	return
	context:
	SetTimer,context,Off
	context()
	return
}