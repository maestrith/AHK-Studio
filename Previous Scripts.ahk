Previous_Scripts(filename=""){
	static files:=[],find,newwin
	if (filename){
		scripts:=settings.sn("//previous_scripts/*")
		while,scr:=scripts.item[A_Index-1]
			if (filename=scr.text)
				return
		if !settings.ssn("//previous_scripts/script[Text()='" filename "']")
			settings.Add({path:"previous_scripts/script",text:filename,dup:1})
	}Else if (filename=""){
		newwin:=new windowtracker(21)
		newwin.Add(["Edit,w400 gpss vfind,,w","ListView,w400 h300 gpreviousscript Multi,Previous Scripts,wh","Button,gpssel Default,Open,y","Button,x+10 gcleanup,Clean up files,y","Button,x+10 gdeleteps,Delete Selected,y"])
		newwin.Show("Previous Scripts"),hotkeys([21],{up:"psup",down:"psdown"})
		gosub,populateps
		scripts:=settings.sn("//previous_scripts/*")
		return
		21GuiClose:
		21GuiEscape:
		hwnd({rem:21})
		return
		previousscript:
		LV_GetText(open,LV_GetNext()),tv:=open(open,1),tv(tv)
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
		goto,populateps
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
		goto,cleanup
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
	return
	pss:
	LV_Delete(),find:=newwin[].find
	for a,b in files
		if InStr(a,find)
			LV_Add("",b)
	LV_Modify(1,"Select Vis Focus")
	return
	pssel:
	LV_GetText(file,LV_GetNext()),tv(open(file,1)),hwnd({rem:21})
	return
	psup:
	psdown:
	Gui,21:Default
	add:=A_ThisLabel="psup"?-1:1,next:=LV_GetNext()+add,next:=next>0?next:1,LV_Modify(0,"-Select"),LV_Modify(next,"Select Vis Focus")
	return
}