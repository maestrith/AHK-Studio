Focus(a*){
	if(a.1&&a.2=0&&v.options.Check_For_Edited_Files_On_Focus){
		all:=files.sn("//file"),sc:=csc()
		while,aa:=all.item[A_Index-1],ea:=xml.ea(aa){
			FileGetTime,time,% ea.file
			if(time!=ea.time){
				list.=ea.filename ","
				aa.SetAttribute("time",time)
				FileRead,text,% ea.file
				text:=RegExReplace(text,"\r\n|\r","`n")
				if(ea.sc=sc.2357)
					sc.2181(0,[text])
				else if(ea.sc&&ea.sc!=sc.2357)
					sc.2377(ea.sc),aa.RemoveAttribute("sc")
				update({file:ea.file,text:text})
			}
		}
		if(list)
			SetStatus("Files Updated:" Trim(list,","),3)
		return 1
	}
	return
}