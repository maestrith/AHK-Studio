split_code(){
	static list:=[]
	code:=update({get:current(3).file}),list:=[],pos:=1,code_explorer.scan(current(1)),each:=sn(info:=cexml.ssn("//main[@file='" current(2).file "']/file[@file='" current(3).file "']"),"descendant::info[@type='Class']|descendant::info[@type='Function']")
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
	Gui,Add,ListView,w300 h500 gsplithere AltSubmit,Function/Class
	Gui,Add,Edit,x+10 w400 h500 -Wrap
	Gui,Add,Button,gsplit Default,Split Selected Functions/Classes
	Gui,Default
	for a,b in list
		LV_Add("",a)
	LV_Modify(1,"Select Vis Focus")
	Gui,Show,,Split it
	return
	splithere:
	if !LV_GetNext()
		return
	LV_GetText(func,LV_GetNext())
	ControlSetText,Edit1,% RegExReplace(List[func].code,"\n","`r`n"),% hwnd([66])
	csc().2160(List[func].pos+List[Func].len-1,List[Func].pos)
	return
	split:
	cfile:=current(3).file,dd:=current(2).file
	SplitPath,dd,,outdir
	editfile:=current(3).file
	Gui,66:Default
	while,LV_GetNext(){
		contents:=update({get:editfile}),LV_GetText(func,LV_GetNext()),code:=List[func].code,func:=RegExReplace(func,"_"," "),newfile:=outdir "\" func
		if FileExist(newfile ".ahk")
			while,FileExist(newfile ".ahk")
				newfile:=outdir "\" func A_Index
		newfile.=".ahk",new_segment(newfile,Trim(code,"`n")),contents:=update({get:editfile})
		StringReplace,contents,contents,%code%,,All
		update({file:editfile,text:contents})
		Gui,66:Default
		LV_Modify(LV_GetNext(),"-select")
	}
	Gui,1:Default
	files.ssn("//main[@file='" dd "']/descendant::file[@file='" cfile "']").removeattribute("sc")
	66GuiEscape:
	66GuiClose:
	hwnd({rem:66})
	return
}