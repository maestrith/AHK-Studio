keywords(){
	commands:=new xml("commands","lib\commands.xml"),list:=settings.sn("//commands/*"),top:=commands.ssn("//Commands/Commands")
	while,ll:=list.item[A_Index-1]
		top.AppendChild(ll.clonenode(1))
	v.keywords:=[],v.kw:=[],v.custom:=[],v.kk:=[],var:=[],colors:=commands.sn("//Color/*")
	while,color:=colors.item[A_Index-1]{
		text:=color.text,all.=text " "
		stringlower,text,text
		v.color[color.nodename]:=text
	}
	personal:=settings.ssn("//Variables").text,all.=personal
	StringLower,per,personal
	v.color.Personal:=Trim(per),v.indentregex:=RegExReplace(v.color.indent," ","|"),command:=commands.ssn("//Commands/Commands").text
	Sleep,4
	Loop,Parse,command,%A_Space%,%A_Space%
		v.kw[A_LoopField]:=A_LoopField,all.=" " A_LoopField
	Sort,All,UD%A_Space%
	list:=settings.ssn("//custom_case_settings").text
	for a,b in StrSplit(list," ")
		all:=RegExReplace(all,"i)\b" b "\b",b)
	Loop,Parse,all,%a_space%
		v.keywords[SubStr(A_LoopField,1,1)].=A_LoopField " "
	return
}