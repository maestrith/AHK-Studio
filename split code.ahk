split_code(){
	static list:=[]
	;class-ify
	code:=update({get:ssn(current(),"@file").text}),list:=[]
	pos:=1
	Loop
	{
		fpos:=[]
		for type,find in {class:"^([\s+]?class[\s+](\w*))(\s+)?{",functions:"^[\s*]?((\w|[^\x00-\x7F])+)\((.*)?\)[\s+;.*\s+]?[\s*]?{"}{
			if pp:=RegExMatch(code,"OUim`n)" find,fun,pos)
				fpos[pp]:={type:type,fun:fun,pos:pp}
		}
		if !fpos.minindex()
			break
		findit:=SubStr(code,fpos[fpos.minindex()].pos)
		left:="",count:=0,foundone:=0
		for a,b in StrSplit(findit,"`n"){
			orig:=b
			left.=orig "`n"
			b:=RegExReplace(b,"i)(\s+" Chr(59) ".*)")
			b:=RegExReplace(b,"U)(" Chr(34) ".*" Chr(34) ")","_")
			RegExReplace(b,"{","",open)
			count+=open
			if open
				foundone:=1
			RegExReplace(b,"}","",close)
			count-=close
			if (count=0&&foundone)
				break
		}
		type:=fpos[fpos.MinIndex()].type
		treeview:=fpos[fpos.MinIndex()].fun.value(1)
		if (lastfun!=TreeView){
			List[treeview]:={pos:fpos.MinIndex(),len:fpos.MinIndex()+StrLen(Trim(left,"`n")),code:left}
		}
		pos:=pos+StrLen(left)
		lastfun:=TreeView
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
	csc().2160(List[func].len,List[func].pos-1)
	return
	split:
	cfile:=ssn(current(),"@file").text
	dd:=ssn(current(1),"@file").text
	SplitPath,dd,,outdir
	editfile:=ssn(current(),"@file").text
	while,LV_GetNext(){
		contents:=update({get:editfile})
		LV_GetText(func,LV_GetNext())
		code:=List[func].code
		func:=RegExReplace(func,"_"," ")
		newfile:=outdir "\" func
		if FileExist(newfile ".ahk"){
			while,FileExist(newfile ".ahk")
				newfile:=outdir "\" func A_Index
		}
		newfile.=".ahk"
		new_segment(newfile,Trim(code,"`n"))
		contents:=update({get:editfile})
		StringReplace,contents,contents,%code%,,All
		update({file:editfile,text:contents})
		Gui,66:Default
		LV_Modify(LV_GetNext(),"-select")
	}
	files.ssn("//main[@file='" dd "']").removeattribute("sc")
	files.ssn("//main[@file='" dd "']/file[@file='" cfile "']").removeattribute("sc")
	66GuiEscape:
	66GuiClose:
	hwnd({rem:66})
	return
}