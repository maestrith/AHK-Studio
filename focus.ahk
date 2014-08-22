Focus(a*){
	if (a.1&&a.2=0&&v.options.Check_For_Edited_Files_On_Focus){
		up:=update("get").1
		for a,b in up{
			FileGetTime,time,%a%
			main:=files.ssn("//file[@file='" a "']")
			info:=files.ea(main)
			if (time!=info.time){
				tv(info.tv),sc:=csc()
				MsgBox,52,File changed.,Do you want to reload the file to show these changes (any previously made changes in Studio will be lost)?
				IfMsgBox,Yes
				{
					FileRead,text,%a%
					sc.2181(0,[text])
				}Else
				update({sc:sc.2357})
				main.SetAttribute("time",time)
			}
		}
		Return 1
	}
}