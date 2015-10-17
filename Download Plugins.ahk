Download_Plugins(){
	static plug,offset
	offset:=A_NowUTC
	offset-=A_Now,h
	if(!FileExist("plugins"))
		FileCreateDir,Plugins
	SplashTextOn,,,Downloading Plugin List,Please Wait...
	plug:=new xml("plugins"),plug.xml.loadxml(UrlDownloadToVar("https://raw.githubusercontent.com/maestrith/AHK-Studio-Plugins/master/Index.xml"))
	SplashTextOff
	if(!plug[])
		return m("There was an error downloading the plugin list.  Please try again later")
	newwin:=new GUIKeep(35)
	Gui,35:Margin,0,0
	newwin.add("ListView,w500 h300 Checked,Name|Author|Description,wh","Button,gdpdl,&Download Checked,y","Button,x+0 gdpsa,Select &All,y"),newwin.show("Download Plugins")
	goto,dppop
	return
	dpsa:
	Loop,% LV_GetCount()
		LV_Modify(A_Index,"Check")
	return
	dpdl:
	pluglist:=""
	while,num:=LV_GetNext(1,"C"){
		LV_GetText(name,num),pos:=1,text:=URLDownloadToVar("https://raw.githubusercontent.com/maestrith/AHK-Studio-Plugins/master/" name ".ahk"),list:=""
		date:=plug.ssn("//*[@name='" name "']/@date").text
		while,pos:=RegExMatch(text,"Oim)\;menu\s*(.*)\R",found,pos)
			item:=StrSplit(found.1,","),item.1:=Trim(item.1,"`r|`r`n|`n"),list.=item.1 "`n",pos:=found.Pos(1)+1
		pluglist.=list=""?"Error in " name "`n":list
		if(list){
			if(FileExist("Plugins\" name ".ahk"))
				FileDelete,Plugins\%name%.ahk
			FileAppend,%text%,Plugins\%name%.ahk
			date-=offset,h
			FileSetTime,%date%,Plugins\%name%.ahk,M
		}
		LV_Modify(num,"-Check")
	}
	Refresh_Plugins()
	m("Installation Report:",pluglist)
	return
	35GuiEscape:
	35GuiClose:
	hwnd({rem:35})
	return
	dppop:
	Gui,35:Default
	LV_Delete(),pgn:=plug.sn("//plugin")
	while,pp:=pgn.item[A_Index-1],ea:=xml.ea(pp){
		if(ea.version>0)
			Continue
		if(FileExist("plugins\" ea.name ".ahk")){
			FileGetTime,time,% "plugins\" ea.name ".ahk"
			time+=offset,h
			if(ea.date>time)
				checked:="check"
		}else
			checked:=""
		LV_Add(checked,ea.name,ea.author,ea.description)
	}
	Loop,3
		LV_ModifyCol(A_Index,"AutoHDR")
	return
}