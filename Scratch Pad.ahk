Scratch_Pad(){
	static file
	if !IsObject(file){
		FileCreateDir,Projects
		file:=FileOpen("projects\Scratch Pad.ahk","rw")
	}
	setup(14)
	Gui,+Resize
	Gui,Margin,0,0
	v.scratch:=new s(14,{pos:"w500 h300"}),hotkeys([14],{Esc:"14guiclose","^v":"paste"})
	Gui,Add,Button,gsprun,Run
	Gui,Add,Button,x+10 gspdyna,Dyna Run
	Gui,Add,Button,x+10 gspkill,Kill Process
	pos:=settings.ssn("//Scratch_Pad").Text?settings.ssn("//Scratch_Pad").Text:""
	Gui,Show,%pos%,Scratch Pad
	WinWait,% hwnd([14])
	bracesetup(14),hk(14),csc({hwnd:v.scratch.sc}),v.scratch.2181(0,file.read(file.length))
	return
	14GuiClose:
	if (sc.2102||sc.2202)
		return sc.2101,sc.2201
	gosub spsave
	gosub spkill
	hwnd({rem:14})
	csc({hwnd:s.main.1.sc})
	return
	sprun:
	gosub spsave
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
	file.seek(0)
	file.write(v.scratch.gettext())
	file.length(file.position),file.seek(0)
	return
	14GuiSize:
	sc:=csc()
	ControlGetPos,,,,h,Button1,% hwnd([14])
	Loop,3
		GuiControl,move,Button%A_Index%,% "y" A_GuiHeight-h
	WinMove,% "ahk_id" v.scratch.sc,,0,0,A_GuiWidth,% A_GuiHeight-h
	WinGetPos,x,y,,,% hwnd([14])
	settings.Add({path:"Scratch_Pad",text:"x" x " y" y " w" A_GuiWidth " h" A_GuiHeight})
	return
}