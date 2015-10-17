History(file=""){
	static back:=[],forward:=[]
	if(file.back||file.forward){
		if(back.2&&file.back)
			forward.push(hh:=back.pop()),hh:=back[back.MaxIndex()]
		else if(file.forward&&forward.1)
			back.push(hh:=forward.pop())
		if(hh.parent){
			Gui,1:Default
			tv:=files.ssn("//main[@file='" hh.parent "']/descendant::file[@file='" hh.file "']"),ea:=xml.ea(tv)
			GuiControl,1:+g,SysTreeView321
			getpos(),TV_Modify(ea.tv,"Select Vis Focus"),_:=ea.sc?csc().2358(0,ea.sc):tv(ea.tv,1,1)
			WinSetTitle,% hwnd([1]),,% "AHK Studio - " hh.file
			setpos(ea.tv)
			GuiControl,1:+gtv,SysTreeView321
		}
	}else
		forward:=[],back.push({parent:current(2).file,file:current(3).file})
}