Show_Classes(){
	sc:=csc(),class:=cexml.sn("//main[@file='" current(2).file "']/descendant::*[@type='Class']/@text"),cpos:=sc.2008
	while,cc:=class.item[A_Index-1]
		if(SubStr(cc.text,1,2)!="__")
			cl.=cc.text " "
	word:=sc.textrange(sc.2266(cpos,1),cpos)
	sc.2117(4,Trim(cl))
}