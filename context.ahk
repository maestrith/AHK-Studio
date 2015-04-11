context(return=""){
	static lasttip
	sc:=csc()
	if sc.2102
		return
	cp:=sc.2008,kw:=v.kw,add:=0,pos:=cp-1,start:=sc.2128(line:=sc.2166(cp))
	if (start>=pos+1)
		return
	cc:=content:=sc.textrange(start,pos+1),RegExMatch(content,"(#?\w+)",word),pos:=1
	if(InStr(cc,Chr(34))){
		while,RegExMatch(cc,"OU)((" Chr(34) ".*" Chr(34) ")|" Chr(34) ".*$)",found){
			rep:=""
			Loop,% found.len(1)
				rep.="_"
			StringReplace,cc,cc,% found.1,%rep%,All
		}
	}
	if(InStr(cc,"(")){
		pos:=1
		RegExReplace(cc,"\(","",opc),RegExReplace(cc,"\)","",clc)
		if(opc!=clc){
			list:=[],total:="",ct:=0,max:=[],count:=0
			for a,b in StrSplit(cc){
				count++
				if(b="("){
					ct++
					list.Insert({text:total,paren:b})
					total:=""
					Continue
				}
				if(b=")"){
					ct--
					list.Insert({text:total,paren:b})
					total:=""
					Continue
				}
				if(max[ct]=""&&b~="\w")
					max[ct]:=count
				lastct:=ct
				if(list.1&&ct=0){
					list:=[],max:=[],count:=0
					Continue
				}
				total.=b
			}
			trimpos:=max[lastct-1]
			if total
				list.Insert({text:total})
			stuff:="",rep:=[],lastpos:=[],max:=0,total:=""
			for a,b in list{
				if(b.paren=")")
					rep.Insert({text:b.text,pos:list[a].pos})
				total.=b.text b.paren
			}
			for a,b in rep
				StringReplace,total,total,% text:=b.text,% RegExReplace(text,",","_")
			total:=SubStr(total,trimpos),RegExMatch(total,"OU).*(\w*)\.?(\w*)\(",command),pre:=command.1,total:=SubStr(total,command.Pos(1)),command:=command.2,string:=total
		}
	}else
		command:=word
	if(return)
		return command:=command?command:word
	if(command){
		if(class:=ssn(cexml.ssn("//main[@file='" current(2).file "']/descendant::*[@type='Object'][@upper='" upper(pre) "']"),"@class").text){
			args:=ssn(cexml.ssn("//main[@file='" current(2).file "']/descendant::*[@type='Class' and @upper='" upper(class) "']/descendant::*[@type='Method' or @type='Property'][@upper='" upper(command) "']"),"@args").text
			if(args){
				syntax:=pre "." command "(" args ")"
				goto,conbottom
			}
		}if(fun:=ssn(cexml.ssn("//main[@file='" current(2).file "']/descendant::*[@type='Function'][@upper='" upper(command) "']"),"@args").text){
			syntax:=command "("  fun  ")"
			Goto,conbottom
		}
	}
	if((ea:=scintilla.ea("//*[@code='" command "']")).syntax){
		syntax:=pre "." command ea.syntax "`n" ea.name
		Goto,conbottom
	}else if(command:=kw[command]){
		if(main:=commands.ssn("//Context/" command)){
			root:=commands.sn("//Context/" found "/syntax")
			while,r:=root.item(A_Index-1){
				if cp:=RegExMatch(cc,"i)\b(" RegExReplace(r.text," ","|") ")\b",ff){
					info:=ssn(r,"@syntax").text
					break
				}
			}
			if !cc
				return
			syntax:=SubStr(cc,1,cp+StrLen(ff)-1) " " info,string:=cc,start:=""
			Goto,conbottom
		}
		syn:=commands.ssn("//Commands/Commands/commands[text()='" command "']/@syntax").text,RegExMatch(syn,"O).*?(\W)",sym),syn:=sym.1~="(,|\[|\()"?syn:"," syn,syntax:=command syn
		if !String
			string:=SubStr(cc,InStr(cc,command,0,0,1))
		Goto,conbottom
	}else if(kw[word]){
		if !syntax:=commands.ssn("//Commands/Commands/commands[text()='" kw[word] "']/@syntax").text{
			if(main:=commands.ssn("//Context/" kw[word])){
				root:=commands.sn("//Context/" found "/syntax")
				while,r:=root.item(A_Index-1){
					if cp:=RegExMatch(cc,"i)\b(" RegExReplace(r.text," ","|") ")\b",ff){
						info:=ssn(r,"@syntax").text
						break
					}
				}
				if !cc
					return
				syntax:=SubStr(cc,1,cp+StrLen(ff)-1) " " info,string:=cc,start:=""
				string:=removecandp(cc)
				Goto,conbottom
			}
			return
		}
		syntax:=kw[word] syntax,string:=removecandp(cc)
		Goto,conbottom
	}
	return
	conbottom:
	RegExReplace(RegExReplace(syntax,"\(",","),",","",count),syntax:=RegExReplace(syntax,Chr(96) "n","`n"),RegExReplace(RegExReplace(string,"\(",",","",1),",","",current)
	if !count
		return sc.2207(0xff0000),syn:=start?start syntax:syntax,sc.2200(startpos:=sc.2128(sc.2166(sc.2008)),syn),RegExMatch(syn,"O)^.*?(\w).*(\w).*?$",pos),sc.2204(pos.Pos(1)-1,pos.Pos(2))
	else{
		ff:=RegExReplace(syntax,"\(",","),sc.2207(0xff0000),sc.2200(startpos:=sc.2128(sc.2166(sc.2008)),syntax)
		if(current+1<=count)
			sc.2204(InStr(ff,",",0,1,current),InStr(ff,",",0,1,current+1)-1)
		if(current=count)
			end:=RegExMatch(syntax,"(\n|\]|\))"),end:=end?end-1:strlen(ff),sc.2204(InStr(ff,",",0,1,current),end)
		if(current>count)
			sc.2204(0,StrLen(ff)),sc.2207(0x0000ff)
	}
	return
	context:
	SetTimer,context,Off
	context()
	return
}