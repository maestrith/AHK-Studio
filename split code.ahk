split_code(){
	static newwin
	files.Transform()
	static list:=[],outdir
	save(),code:=update({get:current(3).file}),list:=[],pos:=1,code_explorer.scan(current(1)),each:=sn(info:=cexml.ssn("//main[@file='" current(2).file "']/file[@file='" current(3).file "']"),"descendant::info[@type='Class']|descendant::info[@type='Function']")
	while,ee:=each.item[A_Index-1],ea:=xml.ea(ee){
		if ea.end
			List["Class " ea.text]:={pos:ea.pos,len:ea.end-ea.pos,code:SubStr(code,ea.pos,ea.end-ea.pos)}
		else{
			search:=SubStr(code,_:=ea.opos?ea.opos:1),add:=start:=braces:=0
			for a,b in StrSplit(search,"`n"){
				line:=b,add+=StrPut(line,"utf-8"),line:=Trim(RegExReplace(line,"(\s+" Chr(59) ".*)"))
				if(SubStr(line,0,1)="{")
					braces++,start:=1
				if(SubStr(line,1,1)="}"){
					while,((found:=SubStr(line,A_Index,1))~="(}|\s)"){
						if(found~="\s")
							Continue
						braces--
					}
				}
				if(start&&braces=0)
					break
			}
			List[ea.Text]:={pos:ea.opos,len:add,code:SubStr(code,_:=ea.opos?ea.opos:1,add)}
		}
	}
	mainfile:=current(2).file
	SplitPath,mainfile,,maindir
	newwin:=new WindowTracker(67)
	newwin.add(["ListView,w250 h300 gsplithere AltSubmit,Function/Class,h","Edit,x+10 w300 h300 -Wrap,,wh","Edit,xm w300 voutdir," maindir "\,yw","Button,gsplit Default,Split Selected Functions/Classes,y"])
	hotkeys([67],{"^a":"SelectAllSplit"})
	for a,b in list
		LV_Add("",a)
	LV_Modify(1,"Select Vis Focus")
	newwin.show("Split Code")
	return
	SelectAllSplit:
	Gui,67:Default
	Gui,67:ListView,SysListView321
	LV_Modify(0,"Select")
	return
	splithere:
	if !LV_GetNext()
		return
	if(A_GuiEvent="I"){
		LV_GetText(func,A_EventInfo)
		ControlSetText,Edit1,% RegExReplace(List[func].code,"\n","`r`n"),% hwnd([67])
		csc().2160(List[func].pos+List[Func].len-1,List[Func].pos-1)
	}
	return
	split:
	info:=newwin[]
	outdir:=info.outdir
	GuiControl,67:+g,SysListView321
	outdir:=Trim(outdir,"\")
	if !FileExist(outdir)
		FileCreateDir,%outdir%
	cfile:=current(3).file,dd:=current(2).file,under:=files.ssn("//main[@file='" current(2).file "']/file[@file='" current(2).file "']"),editfile:=current(3).file
	Gui,67:Default
	while,LV_GetNext(){
		contents:=update({get:editfile})
		LV_GetText(func,LV_GetNext())
		code:=List[func].code,func:=RegExReplace(func,"_"," "),newfile:=outdir "\" func,newfn:=func
		if FileExist(newfile ".ahk")
			while,FileExist(newfile ".ahk")
				newfile:=outdir "\" func A_Index,newindex:=A_Index
		newfile.=".ahk"
		topfile:=update({get:current(2).file})
		update({file:current(2).file,text:topfile "`n" Chr(35) "Include " Trim(RegExReplace(RelativePath(current(2).file,newfile),"i)^lib\\([^\\]+)\.ahk$","<$1>"),"\")})
		FileAppend,% Trim(code,"`n"),%newfile%,UTF-8
		Gui,1:Default
		Gui,1:TreeView,SysTreeView321
		newtv:=TV_Add(Trim(RegExReplace(RelativePath(current(2).file,newfile),"i)^lib\\([^\\]+)\.ahk$","<$1>"),"\"),ssn(under,"@tv").text,"Sort"),CurrentNode:=files.under(under,"file",{encoding:"UTF-8",file:newfile,filename:func newindex ".ahk",include:Chr(35) "Include " Trim(RegExReplace(RelativePath(current(2).file,newfile),"i)^lib\\([^\\]+)\.ahk$","<$1>"),"\"),skip:"",tv:newtv}),update({file:newfile,text:Trim(code,"`n")}),contents:=update({get:editfile})
		StringReplace,contents,contents,%code%,,All
		update({file:editfile,text:contents}),Code_Explorer.Scan(CurrentNode)
		Gui,67:Default
		LV_Modify(LV_GetNext(),"-select")
	}
	Code_Explorer.Scan(files.ssn("//main[@file='" current(2).file "']/file[@file='" current(3).file "']"))
	GuiControl,67:+gsplithere,SysListView321
	Gui,1:Default
	TV_Modify(ssn(under,"@tv").text,"Expand")
	if(current(2).file!=current(3).file)
		files.ssn("//main[@file='" current(2).file "']/descendant::file[@file='" current(2).file "']").removeattribute("sc")
	csc().2181(0,contents)
	67GuiEscape:
	67GuiClose:
	hwnd({rem:67})
	return
}