save(){
	getpos(),info:=update("get"),now:=A_Now,sc:=csc(),currentdoc:=sc.2357
	GuiControl,-Redraw,% sc.sc
	for filename in info.2{
		text:=info.1[filename],main:=ssn(current(1),"@file").text
		if settings.ssn("//options/@Enable_Close_On_Save").text
		for process in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process"){
			prog:=Trim(StrSplit(process.CommandLine,Chr(34)).4,Chr(34))
			if (InStr(process.commandline,"autohotkey")&&prog!=A_ScriptFullPath&&prog)
				if (prog=main)
					Process,Close,% process.processid
		}
		SplitPath,filename,file,dir
		if !FileExist(dir "\backup")
			FileCreateDir,% dir "\backup"
		if !FileExist(dir "\backup\" now)
			FileCreateDir,% dir "\backup\" now
		FileMove,%filename%,% dir "\backup\" now "\" file,1
		StringReplace,text,text,`n,`r`n,All
		FileAppend,%text%,%filename%,utf-8
		Gui,1:TreeView,% hwnd("fe")
		ea:=xml.ea(files.ssn("//file[@file='" filename "']"))
		TV_Modify(ea.tv,"",ea.filename)
		if !ea.sc
			Continue
		sc.2358(0,ea.sc)
		Sleep,100
		Loop,% sc.2154{
			if sc.2533(A_Index-1)=30
				sc.2532(A_Index-1,31)
		}
	}
	GuiControl,+Redraw,% sc.sc
	sc.2358(0,currentdoc)
	cd:=files.ssn("//file[@sc='" currentdoc "']")
	posinfo:=positions.ssn("//main[@file='" ssn(cd.ParentNode,"@file").text "']/file[@file='" ssn(cd,"@file").text "']")
	ea:=xml.ea(posinfo),fold:=ea.fold,breakpoint:=ea.breakpoint
	Loop,Parse,fold,`,
		sc.2231(A_LoopField)
	Loop,Parse,breakpoint,`,
		sc.2043(A_LoopField,0)
	if ea.start&&ea.end
		sc.2613(ea.scroll),sc.2160(ea.start,ea.end)
	savegui(),positions.save(1),vversion.save(1)
	lastfiles()
	update("clearupdated")
}