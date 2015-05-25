split_code(){
	files.Transform()
	static list:=[],outdir
	save(),code:=update({get:current(3).file}),list:=[],pos:=1,code_explorer.scan(current(1)),each:=sn(info:=cexml.ssn("//main[@file='" current(2).file "']/file[@file='" current(3).file "']"),"descendant::info[@type='Class']|descendant::info[@type='Function']")
	while,ee:=each.item[A_Index-1],ea:=xml.ea(ee){
		if ea.end
			List["Class " ea.text]:={pos:ea.pos,len:ea.end-ea.pos,code:SubStr(code,ea.pos,ea.end-ea.pos)}
		else{
			search:=SubStr(code,_:=ea.pos?ea.pos:1),add:=start:=braces:=0
			for a,b in StrSplit(search,"`n"){
				line:=b,add+=StrPut(line,"utf-8"),line:=Trim(RegExReplace(line,"(\s+" Chr(59) ".*)"))
				if(SubStr(line,0,1)="{")
					braces++,start:=1
				if(SubStr(line,1,1)="}")
					braces--
				if(start&&braces=0)
					break
			}
			List[ea.Text]:={pos:ea.pos,len:add,code:SubStr(code,_:=ea.pos?ea.pos:1,add)}
		}
	}
	setup(66)
	Hotkey,IfWinActive,% hwnd([66])
	Hotkey,^a,SelectAllSplit,On
	Gui,Add,ListView,w300 h500 gsplithere AltSubmit,Function/Class
	Gui,Add,Edit,x+10 w400 h500 -Wrap
	mainfile:=current(2).file
	SplitPath,mainfile,,maindir
	Gui,Add,Edit,xm w400 voutdir,%maindir%\
	Gui,Add,Button,gsplit Default,Split Selected Functions/Classes
	Gui,Default
	for a,b in list
		LV_Add("",a)
	LV_Modify(1,"Select Vis Focus")
	Gui,Show,,Split it
	return
	SelectAllSplit:
	Gui,66:Default
	Gui,66:ListView,SysListView321
	LV_Modify(0,"Select")
	return
	splithere:
	if !LV_GetNext()
		return
	LV_GetText(func,LV_GetNext())
	ControlSetText,Edit1,% RegExReplace(List[func].code,"\n","`r`n"),% hwnd([66])
	csc().2160(List[func].pos+List[Func].len-1,List[Func].pos)
	return
	split:
	Gui,Submit,Nohide
	GuiControl,66:+g,SysListView321
	outdir:=Trim(outdir,"\")
	if !FileExist(outdir)
		FileCreateDir,%outdir%
	cfile:=current(3).file,dd:=current(2).file
	under:=files.ssn("//main[@file='" current(2).file "']/file[@file='" current(2).file "']")
	editfile:=current(3).file
	Gui,66:Default
	while,LV_GetNext(){
		contents:=update({get:editfile})
		LV_GetText(func,LV_GetNext())
		code:=List[func].code
		func:=RegExReplace(func,"_"," ")
		newfile:=outdir "\" func,newfn:=func
		if FileExist(newfile ".ahk")
			while,FileExist(newfile ".ahk")
				newfile:=outdir "\" func A_Index,newindex:=A_Index
		newfile.=".ahk"
		topfile:=update({get:current(2).file})
		update({file:current(2).file,text:topfile "`n" Chr(35) "Include " Trim(RelativePath(current(2).file,newfile),"\")})
		FileAppend,% Trim(code,"`n"),%newfile%,UTF-8
		Gui,1:Default
		Gui,1:TreeView,SysTreeView321
		newtv:=TV_Add(Trim(RelativePath(current(2).file,newfile),"\"),ssn(under,"@tv").text,"Sort")
		CurrentNode:=files.under(under,"file",{encoding:"UTF-8",file:newfile,filename:func newindex ".ahk",include:Chr(35) "Include " Trim(RelativePath(current(2).file,newfile),"\"),skip:"",tv:newtv})
		update({file:newfile,text:Trim(code,"`n")})
		contents:=update({get:editfile})
		StringReplace,contents,contents,%code%,,All
		update({file:editfile,text:contents})
		Code_Explorer.Scan(CurrentNode)
		Gui,66:Default
		LV_Modify(LV_GetNext(),"-select")
	}
	Code_Explorer.Scan(files.ssn("//main[@file='" current(2).file "']/file[@file='" current(3).file "']"))
	GuiControl,66:+gsplithere,SysListView321
	Gui,1:Default
	TV_Modify(ssn(under,"@tv").text,"Expand")
	if(current(2).file!=current(3).file)
		files.ssn("//main[@file='" current(2).file "']/descendant::file[@file='" current(2).file "']").removeattribute("sc")
	csc().2181(0,contents)
	66GuiEscape:
	66GuiClose:
	hwnd({rem:66})
	return
}