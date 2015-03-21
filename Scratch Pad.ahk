Scratch_Pad(){
	static file,buttoncount
	;class-ify
	FileCreateDir,Projects
	file:=FileOpen("projects\Scratch Pad.ahk",3),setup(14)
	Gui,+Resize
	Gui,Margin,0,0
	att:=[]
	;att["+Esc"]:="14guiclose",att["^v"]:="paste"
	v.scratch:=new s(14,{pos:"w500 h300"}),hotkeys([14],{"+Esc":"14guiclose","^v":"paste"})
	/*
		if info:=menus.ssn("//*[@clean='Geekdude_Uploader']")
			ea:=xml.ea(info),att[ea.hotkey]:="plugin",hotkeys([14],att)
	*/
	Gui,Add,Button,gsprun,&Run
	Gui,Add,Button,x+5 gspdyna,&Dyna Run
	Gui,Add,Button,x+5 gspkill,&Kill Process
	Gui,Add,Button,x+5 g14GuiClose,C&lose
	Gui,Add,Button,x+5 gspcreate,Cr&eate Project From Code
	buttoncount:=5
	pos:=settings.ssn("//Scratch_Pad").Text?settings.ssn("//Scratch_Pad").Text:""
	Gui,Show,%pos%,Scratch Pad
	WinWait,% hwnd([14])
	bracesetup(14),hk(14),csc({hwnd:v.scratch.sc}),tt:=RegExReplace(file.Read(file.length),"\r\n","`n")
	length:=VarSetCapacity(text,strput(tt,"utf-8")),StrPut(tt,&text,length,"utf-8"),sc:=csc(),sc.2037(65001),sc.2181(0,&text)
	return
	/*
		plugin:
		ea:=menus.ea("//*[@hotkey='" A_ThisHotkey "']")
		Run,% "plugins\" ea.plugin
		return
	*/
	postscratchpad:
	ea:=xml.ea(menus.ssn("//*[@clean='Geekdude_Uploader']"))
	Run,% Chr(34) "plugins\" ea.plugin Chr(34)
	return
	spcreate:
	text:=csc().gettext(),default:=ProjectFolder()
	InputBox,newfile,Create New File,Input the name of the new file (.ahk will be added) and a new folder will be created`nFile will be created in %default%`nTo change this directory goto Edit/Default Project Folder
	if(ErrorLevel||newfile="")
		return
	newfile:=SubStr(newfile,-3)=".ahk"?newfile:newfile ".ahk"
	SplitPath,newfile,,,,nf
	newfile:=default "\" nf "\" newfile
	if FileExist(newfile)
		return m("File exists. Please enter another")
	Gosub,14GuiClose
	new(newfile,text)
	v.openfile:=newfile
	SetTimer,selectfile,-200
	return
	14GuiClose:
	if (sc.2102||sc.2202)
		return sc.2101,sc.2201
	gosub,spsave
	gosub,spkill
	WinGetPos,x,y,w,h,% hwnd([14])
	settings.Add({path:"Scratch_Pad",text:"x" x " y" y " w" w-(v.Border*2) " h" h-(v.Border*2+v.Caption)})
	hwnd({rem:14}),csc(1)
	return
	sprun:
	gosub,spsave
	Run,projects\Scratch Pad.ahk,,,pid
	v.scratchpid:=pid
	return
	spdyna:
	v.scratchpid:=dynarun(v.scratch.getText())
	return
	spkill:
	if (v.scratchpid){
		while,WinExist("ahk_pid" v.scratchpid){
			WinClose,% "ahk_pid" v.scratchpid " ahk_class AutoHotkey",, 2
			Sleep,500
			if WinExist("ahk_pid" v.scratchpid)
				MsgBox,51,Unable to close the previous script,Try again?
			IfMsgBox,no
				break
			IfMsgBox,Cancel
				break
		}
	}
	ControlGet,hwnd,hwnd,,Scintilla1,% hwnd([1])
	sc:=csc({hwnd:hwnd+0})
	return
	spsave:
	file:=""
	FileDelete,Projects\Scratch Pad.ahk
	FileAppend,% v.scratch.gettext(),Projects\Scratch Pad.ahk,UTF-16
	file:=FileOpen("Projects\Scratch Pad.ahk",3,"UTF-8")
	;file.seek(0)
	file.write(RegExReplace(v.scratch.gettext(),"\n","`r`n"))
	file.length(file.position),file:=""
	;m(ErrorLevel,v.scratch.gettext())
	return
	14GuiSize:
	sc:=csc()
	ControlGetPos,,,,h,Button1,% hwnd([14])
	Loop,%buttoncount%
		GuiControl,move,Button%A_Index%,% "y" A_GuiHeight-h
	WinMove,% "ahk_id" v.scratch.sc,,0,0,A_GuiWidth,% A_GuiHeight-h
	return
}