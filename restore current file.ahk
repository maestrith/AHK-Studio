restore_current_file(){
	file:=ssn(current(),"@file").text
	SplitPath,file,filename,dir
	restore:=setup(16)
	Gui,+Resize
	Gui,Add,ListView,x0 y0 w350 h480 altsubmit grestore,Backup
	Gui,Add,Edit,x+10 w550 h480 -Wrap
	Gui,Add,Button,x0 grestorefile Default,Restore selected file
	SplashTextOn,,50,Collecting backup files,Please wait...
	loop,% dir "\backup\" filename,1,1
	{
		StringSplit,new,A_LoopFileDir,\
		last:=new0,d:=new%last%
		lv_add("",d)
	}
	LV_Modify(1,"select Focus")
	SplashTextOff
	Gui,Show,,Restore
	Restore:
	file:=ssn(current(),"@file").text
	SplitPath,file,filename,dir
	LV_GetText(bdir,LV_GetNext())
	FileRead,contents,% dir "\backup\" bdir "\" filename
	ControlSetText,Edit1,%contents%
	return
	restorefile:
	file:=ssn(current(),"@file").text
	SplitPath,file,filename,dir
	LV_GetText(bdir,LV_GetNext())
	;FileRead,contents,% dir "\backup\" bdir "\" filename
	oldfile:=dir "\backup\" bdir "\" filename
	fff:=FileOpen(oldfile,"RW","utf-8")
	contents1:=fff.read(fff.length)
	length:=VarSetCapacity(text,strput(contents,"utf-8"))
	StrPut(contents1,&text,length,"utf-8")
	csc().2181(0,&text)
	16GuiClose:
	16GuiEscape:
	hwnd({rem:16})
	return
}