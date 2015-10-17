TVIcons(x:=""){
	static il,track:=[]
	if(x=1||x=2){
		obj:={1:"File Icon",2:"Folder Icon"}
		return new icon_browser({close:1,return:obj[x],desc:obj[x],func:"TVIcons"})
	}else if(x.file){
		root:=settings.ssn("//icons/pe")
		if(x.return="File Icon")
			obj:={filefile:x.file,file:x.number}
		else if(x.return="Folder Icon")
			obj:={folderfile:x.file,folder:x.number}
		for a,b in obj
			root.setattribute(a,b)
		seticons:=1
	}else if(x.get){
		if(!index:=track[x.get]){
			index:=IL_Add(il,x.get,1),track[x.get]:=index
			if(!index)
				return "icon2"
		}
		return "Icon" index
	}if(settings.ssn("//icons/pe/@show").text||seticons)
		ea:=settings.ea("//icons/pe"),il:=IL_Create(3,1,0),IL_Add(il,ea.folderfile?ea.folderfile:"shell32.dll",ea.folder?ea.folder:4),IL_Add(il,ea.filefile?ea.filefile:"shell32.dll",ea.file?ea.file:2)
	else
		IL_Destroy(il)
	tv_setimagelist(il)
}