Context(return=""){
	static lasttip
	sc:=csc(),open:=cp:=sc.2008,line:=sc.2166(cp),start:=sc.2128(line),end:=sc.2136(line),synmatch:=[],startpos:=0
	if(sc.2102)
		return
	if(cp<=start)
		return
	string:=sc.textrange(start,cp),pos:=1,fixcp:=cp,sub:=cp-start
	while,(fixcp>start){
		if(sc.2010(fixcp)="3")
			string:=RegExReplace(string,".","_",,1,sub-A_Index+2)
		fixcp--
	}co:=InStr(string,"(",,0),cc:=InStr(string,")",,0),open:=cc>co?cc+start:co+start
	Loop{
		sc.2190(open),sc.2192(start),close:=sc.2197(1,")"),sc.2190(open),sc.2192(start),open:=sc.2197(1,"(")
		if(close>open&&open>start){
			bm:=sc.2353(close),wb:=sc.2266(bm,1),string:=SubStr(string,1,wb-start) SubStr(string,close+2-start),open:=bm
			Continue
		}
		if(open<0)
			break
		word:=sc.textrange(wb:=sc.2266(open,1),sc.2267(open,1)),wordstartpos:=wb
		if(word){
			if(sc.2007(wb-1)=46)
				pre:=sc.textrange(wordstartpos:=sc.2266(wb-1,1),sc.2267(wb-1,1))
			if(inst:=cexml.ssn("//main[@file='" current(2).file "']/descendant::*[@type='Instance' and @upper='" upper(pre) "']")){
				if(args:=cexml.ssn("//main[@file='" current(2).file "']/descendant::*[@type='Class' and @upper='" upper(xml.ea(inst).class) "']/descendant-or-self::*[@upper='" upper(word) "']/@args").text)
					synmatch.push(pre "." word "(" args ")"),startpos:=startpos=0?wordstartpos:startpos
			}if(fun:=cexml.ssn("//lib/info[@upper='" upper(word) "']")){
				synmatch.push(word "(" xml.ea(fun).args ")"),startpos:=startpos=0?wordstartpos:startpos
			}if(fun:=ssn(cexml.ssn("//main[@file='" current(2).file "']/descendant::*[@type='Function'][@upper='" upper(word) "']"),"@args").text){
				synmatch.push(word "("  fun  ")"),startpos:=startpos=0?wordstartpos:startpos
			}if((ea:=scintilla.ea("//*[@code='" word "']")).syntax)
				synmatch.push(pre "." word ea.syntax "`n" ea.name),startpos:=startpos=0?wordstartpos:startpos
			if(syn:=commands.ssn("//Commands/Commands/commands[text()='" v.kw[word] "']/@syntax").text)
				synmatch.push(word syn),startpos:=startpos=0?wordstartpos:startpos
			if(startpos)
				break
	}}if(word=""||word="if"){
		RegExMatch(string,"O)^\s*\W*(\w+)",word),word:=v.kw[word.1]?v.kw[word.1]:word.1,startpos:=start,loopword:=word,loopstring:=string,build:=word
		if((main:=commands.sn("//Context/" word "/*")).length){
			if(!commands.ssn("//Context/" word "/syntax"))
				ea:=xml.ea(commands.ssn("//Context/" word "/list")),synmatch.push(ea.add word " [" ea.list "]")
			else
				while,mm:=main.item[A_Index-1],ea:=xml.ea(mm){
					if(mm.text~="i)\b" loopword "\b"&&loopword){
						list:=RegExReplace(ea.list," ","|"),loopstring:=RegExReplace(loopstring,"i)^(\W*\b" loopword "\b\W+)")
						if(RegExMatch(loopstring,"Oi)\b(" list ")\b",found))
							loopword:=found.1,build.="," loopword
						if(mm.nodename="syntax"){
							build:=word="if"?word " " ea.syntax:Trim(build,",") " " ea.syntax
							synmatch.push(build)
							Break
		}}}}else if(word){
			ww:=v.kw[word]?v.kw[word]:v.kw["#" word]
			if(syn:=commands.ssn("//Commands/Commands/commands[text()='" ww "']/@syntax").text)
				synmatch.push(ww " " syn)
		}
	}if(wordstartpos-start>0)
		string:=LTrim(SubStr(string,wordstartpos-start),",")
	if(return)
		return word
	syntax:=""
	for a,b in synmatch{
		if(syntax~="\b\Q" b "\E"=0)
			syntax.=b "`n"
	}syntax:=Trim(syntax,"`n")
	if(return)
		return word
	if(!syntax)
		return
	synbak:=RegExReplace(syntax,"(\n.*)"),RegExReplace(RegExReplace(synbak,"\(",",",,1),",","",count),syntax:=RegExReplace(syntax,Chr(96) "n","`n"),RegExReplace(RegExReplace(string,"\(",",","",1),",",,current)
	if(count=0||word="if")
		sc.2207(0xAAAAAA),sc.2200(startpos,syntax)
	else{
		ff:=RegExReplace(synbak,"\(",","),sc.2207(0xff0000),sc.2200(startpos,syntax)
		if(current+1<=count)
			sc.2204(InStr(ff,",",0,1,current),InStr(ff,",",0,1,current+1)-1)
		if(current>count){
			if(InStr(SubStr(synbak,InStr(ff,",",0,1,count)+1),"*"))
				current:=1
			else
				sc.2204(0,StrLen(ff)),sc.2207(0x0000ff)
		}if(current=count)
			end:=RegExMatch(syntax,"(\n|\]|\))"),end:=end?end-1:strlen(ff),sc.2204(InStr(ff,",",0,1,current),end)
	}
	return
	context:
	SetTimer,context,Off
	context()
	return
}