scintilla(return:=""){
	static list
	if !FileExist("lib\scintilla.xml"){
		SplashTextOn,300,100,Downloading definitions,Please wait
		URLDownloadToFile,http://files.maestrith.com/AHK-Studio/scintilla.xml,lib\scintilla.xml
		SplashTextOff
	}
	if !IsObject(scintilla){
		ll:=scintilla.sn("//commands/*")
		while,l:=ssn(ll.item[A_Index-1],"@name").text
			list.=l " "
		list:=Trim(list)
		scintilla:=new xml("scintilla","lib\scintilla.xml")
	}
	if return
		return list
}