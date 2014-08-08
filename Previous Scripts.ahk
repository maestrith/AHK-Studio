Previous_Scripts(filename=""){
	static files:=[],find
	if (filename){
		scripts:=settings.sn("//previous_scripts/*")
		while,scr:=scripts.item[A_Index-1]
			if (filename=scr.text)
				return
		if !settings.ssn("//previous_scripts/script[Text()='" filename "']")
			settings.Add({path:"previous_scripts/script",text:filename,dup:1})
	}Else if (filename=""){
		setup(21)
		Gui,Add,Edit,w400 gpss vfind
		Gui,Add,ListView,w400 h300 gpreviousscript Multi,Past Scripts
		scripts:=settings.sn("//previous_scripts/*")
		Gui,Add,Button,gpssel Default,Open
		Gui,Add,Button,x+10 gcleanup,Clean up files
 		Gui,Add,Button,x+10 gdeleteps,Delete Selected
		gosub,populateps
		Gui,Show,,Previous Scripts
		Return
		21GuiClose:
		21GuiEscape:
		hwnd({rem:21})
		return
		previousscript:
		LV_GetText(open,LV_GetNext()),tv:=open(open),tv(tv)
		return
		cleanup:
		dup:=[]
		scripts:=settings.sn("//previous_scripts/*")
		while,scr:=scripts.item[A_Index-1]{
			if !FileExist(scr.text)
				scr.ParentNode.RemoveChild(scr)
			Else if dup[scr.text]
				scr.ParentNode.RemoveChild(scr)
			dup[scr.text]:=1
		}
		goto populateps
		return
		deleteps:
		filelist:=[]
		while,next:=LV_GetNext()
			LV_GetText(file,next),filelist[file]:=1,LV_Modify(next,"-Select")
		scripts:=settings.sn("//previous_scripts/*")
		while,scr:=scripts.item[A_Index-1]{
			if filelist[scr.text]
				scr.ParentNode.RemoveChild(scr)
		}
		goto cleanup
		return
		populateps:
		scripts:=settings.sn("//previous_scripts/*")
		LV_Delete()
		while,scr:=scripts.item[A_Index-1]{
			info:=scr.text
			SplitPath,info,filename
			LV_Add("",info),Files[filename]:=info
		}
		LV_Modify(1,"Select")
		return
	}
	Return
	pss:
	Gui,21:Submit,Nohide
	LV_Delete()
	for a,b in files
		if InStr(a,find)
			LV_Add("",b)
	LV_Modify(1,"Select Vis Focus")
	return
	pssel:
	LV_GetText(file,LV_GetNext()),tv(open(file)),hwnd({rem:21})
	return
}