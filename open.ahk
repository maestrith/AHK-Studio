open(filelist="",show=""){
	static root,top
	for a,b in [19,14,3,11]{
		if(hwnd(b)){
			WinGetTitle,title,% hwnd([b])
			return m("Please close the " title " window before proceeding")
		}
	}
	if(!filelist){
		openfile:=current(2).file
		SplitPath,openfile,,dir
		FileSelectFile,filename,,%dir%,,*.ahk
		if(ErrorLevel)
			return
		if(ff:=files.ssn("//main[@file='" filename "']")){
			Gui,1:Default
			tv(xml.ea(ff.firstchild).tv)
			return
		}
		if(!FileExist(filename))
			return m("File does not exist. Create a new file with File/New")
		fff:=FileOpen(filename,"RW"),file1:=file:=fff.read(fff.length)
		gosub,addfile
		Gui,1:TreeView,SysTreeView321
		filelist:=files.sn("//main[@file='" filename "']/descendant::file"),TV(files.ea("//main[@file='" filename "']/file").tv)
		while,filename:=filelist.item[A_Index-1]
			code_explorer.scan(filename)
		code_explorer.Refresh_Code_Explorer(),PERefresh()
	}else{
		WinSetTitle,% hwnd([1]),,AHK Studio - Scanning files....
		for a,b in StrSplit(filelist,"`n"){
			if(InStr(b,"'"))
				return m("Filenames and folders can not contain the ' character (Chr(39))")
			if(files.ssn("//main[@file='" b "']"))
				continue
			fff:=FileOpen(b,"RW"),file1:=file:=fff.read(fff.length),filename:=b
			gosub,addfile
			v.filescan.Insert(b)
		}
		if(Show)
			SetTimer,scanfiles,10
		return files.ssn("//main[@file='" StrSplit(filelist,"`n").1 "']/file/@tv").text,PERefresh()
		scanfiles:
		if(!v.filescan.1){
			SetTimer,scanfiles,Off
			WinSetTitle,% hwnd([1]),,% "AHK Studio - " current(3).file
			code_explorer.Refresh_Code_Explorer()
			return
		}
		filename:=v.filescan.1,filelist:=files.sn("//main[@file='" filename "']/descendant::file")
		while,fn:=filelist.item[A_Index-1]
			code_explorer.scan(fn)
		v.filescan.Remove(1)
		return
	}
	return root
	addfile:
	Gui,1:Default
	SplitPath,filename,fn,dir,,nne
	FileGetTime,time,%filename%
	GuiControl,1:+g,SysTreeView321
	GuiControl,1:-Redraw,SysTreeView321
	top:=files.add({path:"main",att:{file:filename},dup:1}),next:=files.under(top,"file",{file:filename,tv:feadd(fn,0,"icon2 First sort"),github:fn,time:time})
	Extract([filename],next,filename),ff:=files.sn("//file")
	if(!settings.ssn("//open/file[text()='" filename "']"))
		settings.add({path:"open/file",text:filename,dup:1})
	Gui,1:Default
	next:=files.ssn("//main[@file='" filename "']/file[@file='" filename "']")
	if(note:=notesxml.ssn("//note[@file='" filename "']")){
		files.under(next.ParentNode,"file",{note:1,file:A_ScriptDir "\notes\" nne ".txt",filename:nne ".txt",tv:(tv:=TV_Add(nne ".txt",xml.ea(next).tv,TVIcons({get:A_ScriptDir "\notes\" nne ".txt"})))})
		FileRead,text,Notes\%nne%.txt
		update({file:A_ScriptDir "\notes\" nne ".txt",text:RegExReplace(text,"\R","`n")})
	}
	GuiControl,1:+Redraw,SysTreeView321
	GuiControl,1:+gtv,SysTreeView321
	TV_Modify(TV_GetChild(0),"Select Focus Vis")
	return
}