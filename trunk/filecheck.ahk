filecheck(){
	commandsdate:=20140821,menusdate:=20140909,scilexerdate:=20140801123000
	if !settings.ssn("//autoadd")
		for a,b in {60:62,123:125,34:34,39:39,91:93,40:41}
			settings.add({path:"autoadd/key",att:{trigger:a,add:b},dup:1})
	if !settings.ssn("//fonts").xml
		defaultfont()
	if (menus.ssn("//date").text!=menusdate){
		names:=menus.sn("//*/@name")
		while,nn:=names.item[A_Index-1]
			list.=nn.text "`r`n"
		list:=RegExReplace(list,"&")
		SplashTextOn,,40,Downloading Required Files,Please Wait...
		URLDownloadToFile,http://files.maestrith.com/AHK-Studio/menus.xml,lib\temp.xml
		FileRead,menu,lib\temp.xml
		temp:=new xml("temp")
		temp.xml.loadxml(menu)
		if menus.sn("//*").length=1
			menus.xml.loadxml(menu)
		else{
			menu:=temp.sn("//*")
			while,mm:=menu.item[A_Index-1]{
				parent:=mm.nodename!="menu"?mm:parent
				name:=ssn(mm,"@name").text
				check:=RegExReplace(name,"&")
				if !RegExMatch(list,"i)\b" check "\b"){
					if !menus.ssn("//" mm.nodename "[@name='" name "']"){
						top:=menus.ssn("//menu[@name='" ssn(mm.ParentNode,"@name").text "']")
						top:=top?top:menus.ssn("//" mm.parentnode.nodename)
						if top.xml
							top.appendchild(mm.clonenode(1))
					}
				}
			}
		}
		SplashTextOff
		menus.add({path:"date",text:menusdate})
		menus.save(1)
		FileDelete,lib\temp.xml
	}
	if !FileExist(A_ScriptDir "\lib")
		FileCreateDir,%A_ScriptDir%\lib
	FileGetTime,time,scilexer.dll,M
	if (scilexerdate>time)
		FileDelete,scilexer.dll
	FileInstall,scilexer.dll,scilexer.dll
	FileInstall,lib\commands.xml,lib\commands.xml
	if !(FileExist("lib\commands.xml")&&FileExist("scilexer.dll"))
		SplashTextOn,,40,Downloading Required Files,Please Wait...
	if (commands.ssn("//Date").text!=commandsdate){
		FileDelete,lib\commands.xml
		updatedate:=1
	}
	if !FileExist("lib\commands.xml")
		FileAppend,% URLDownloadToVar("http://files.maestrith.com/AHK-Studio/commands.xml"),lib\commands.xml
	if !FileExist("scilexer.dll")
		URLDownloadToFile,http://files.maestrith.com/AHK-Studio/SciLexer.dll,SciLexer.dll
	if !FileExist("AHKStudio.ico")
		urldownloadtofile,http://files.maestrith.com/AHK-Studio/AHKStudio.ico,AHKStudio.ico
	SplashTextOff
	if !settings.ssn("//options")
		settings.Add({path:"options",att:{}})
	commands:=new xml("commands","lib\commands.xml")
	if updatedate
		commands.Add({path:"Version/Date",text:commandsdate}),commands.save(1)
}