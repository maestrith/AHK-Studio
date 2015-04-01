automenu(){
	automenu:
	SetTimer,automenu,Off
	sc:=csc()
	if sc.2007(sc.2008-1)=40
		return
	command:=RegExReplace(context(1),"#")
	if(v.word){
		if (l:=commands.ssn("//Context/" command "/*[text()='" RegExReplace(v.word,"#") "']")){
			if !list:=ssn(l,"@list")
				return
			if l.ParentNode.nodename!=command
				return
			if (sc.2007(sc.2008-1)!=44){
				insert:=v.options.Auto_Space_After_Comma?", ":","
				sc.2003(sc.2008,insert),sc.2025(sc.2008+StrLen(insert))
			}
			sc.2100(0,list.text,v.word:="")
		}
	}
	return
}