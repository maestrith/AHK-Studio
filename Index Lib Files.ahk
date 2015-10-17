Index_Lib_Files(){
	SplitPath,A_AhkPath,,ahkdir
	ahkdir.="\lib\"
	function:=Code_Explorer.function,lib:=new xml("lib"),top:=lib.ssn("//*")
	if(rem:=cexml.ssn("//lib"))
		rem.ParentNode.RemoveChild(rem)
	for a,b in [A_ScriptDir "\Lib\",A_MyDocuments "\AutoHotkey\Lib\",ahkdir]{
		Loop,%b%\*.ahk{
			file:=FileOpen(A_LoopFileLongPath,"R","utf-8"),text:=file.Read(file.length),file.Close()
			pos:=1
			while,RegExMatch(text,function,found,pos){
				pos:=found.Pos(1)+found.len(1)
				if(found.1="if")
					Continue
				ppos:=found.Pos(1)-1,pos1:=ppos?StrPut(SubStr(code,1,ppos),"utf-8")-1:0
				lib.under(top,"info",{type:"Function",file:A_LoopFileLongPath,opos:found.Pos(1),pos:pos1,text:found.1,upper:upper(found.1),args:found.value(3),class:found.1,root:parentfile,order:"text,type,file,args"})
			}
		}
	}
	words:=v.keywords,alltext:=sn(top,"//@text"),all:=v.all,v.keywords:=[]
	Loop,Parse,all,%a_space%
		v.keywords[SubStr(A_LoopField,1,1)].=A_LoopField " "
	while,aa:=alltext.item[A_Index-1].text{
		if(aa~="^__"||v.keywords[SubStr(aa,1,1)]~="i)\b" aa "\b")
			Continue
		v.keywords[SubStr(aa,1,1)].=aa " "
	}
	main:=cexml.ssn("//*")
	main.AppendChild(top)
}