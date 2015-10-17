restore_current_file(){
	static
	newwin:=new windowtracker(16),newwin.Add(["ListView,w350 h480 altsubmit grestore,Backup,h","Edit,x+10 w550 h480 -Wrap,,wh","Edit,xm w550,MM-dd-yyyy HH:mm:ss,wy","Button,x+10 grcfr,Refresh Folder List,xy","Button,xm grestorefile Default,Restore selected file,y"])
	if date:=settings.ssn("//restoredate").text
		ControlSetText,Edit2,%date%,% hwnd([16])
	gosub,poprcf
	newwin.Show("Restore")
	return
	Restore:
	file:=ssn(current(),"@file").text
	SplitPath,file,filename,dir
	LV_GetText(bdir,LV_GetNext())
	FileRead,contents,% filelist[bdir]
	ControlSetText,Edit1,%contents%
	return
	restorefile:
	file:=ssn(current(),"@file").text
	SplitPath,file,filename,dir
	LV_GetText(bdir,LV_GetNext()),oldfile:=filelist[bdir],fff:=FileOpen(oldfile,"RW","utf-8")
	contents:=fff.read(fff.length),contents:=RegExReplace(contents,"\R","`n"),length:=VarSetCapacity(text,strput(contents,"utf-8")),StrPut(contents,&text,length,"utf-8"),csc().2181(0,&text)
	16GuiClose:
	16GuiEscape:
	hwnd({rem:16})
	return
	rcfr:
	poprcf:
	ControlGetText,format,Edit2,% hwnd([16])
	if (A_ThisLabel="rcfr")
		settings.Add({path:"restoredate",text:format})
	SplashTextOn,,50,Collecting backup files,Please wait...
	LV_Delete(),filelist:=[],file:=ssn(current(),"@file").text,backup:=[],full:=[]
	SplitPath,file,filename,dir
	loop,% dir "\backup\" filename,1,1
	{
		ff:=StrSplit(A_LoopFileDir,"\"),fn:=ff[ff.MaxIndex()],RegExMatch(fn,"O)(\d+)",date),pre:=RegExReplace(fn,date.1)
		FormatTime,folder,% date.1,%format%
		dt:=pre?pre " " folder:folder,filelist[dt]:=A_LoopFileFullPath
		if(InStr(dt,"Full Backup"))
			full.push(dt)
		else
			backup.push(dt)
	}
	for a,b in {backup:backup.MaxIndex(),full:full.MaxIndex()}
		Loop,%b%
			LV_Add("",%a%[b-(A_Index-1)])
	LV_Modify(1,"select Focus")
	SplashTextOff
	return
}