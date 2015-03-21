Focus(a*){
	if (a.1&&a.2=0&&v.options.Check_For_Edited_Files_On_Focus){
		up:=update("get").1
		for file,b in up{
			FileGetTime,time,%file%
			main:=files.ssn("//file[@file='" file "']")
			info:=files.ea(main)
			if (time!=info.time){
				tv(info.tv),sc:=csc()
				MsgBox,52,File changed.,Do you want to reload the file to show these changes (any previously made changes in Studio will be lost)?
				IfMsgBox,Yes
				{
					FileRead,text,%file%
					sc.2181(0,[text])
				}Else
					update({sc:sc.2357})
				main.SetAttribute("time",time)
			}
		}
		return 1
	}
	if (a.1=2)
		SetTimer,click,-1
	/*
		Gui,1:Default
		Gui,1:TreeView,SysTreeView321
		sc:=csc()
		
		
		GuiControl,1:+Redraw,Scintilla1
		GuiControl,1:-Redraw,Scintilla1
		if a.1
			setpos(TV_GetSelection())
		else
			getpos()
	*/
	return
	click:
	MouseClick,Left,,,,,U
	return
}