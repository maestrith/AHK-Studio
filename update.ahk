update(info){
	static update:=[],updated:=[]
	if (info="updated")
		return updated
	if (info.edited)
		return updated[info.edited]:=1
	if (info="clearupdated")
		return updated:=[]
	if (info="get")
		return [update,updated]
	if (info.file){
		update[info.file]:=info.text
		if !info.load
			updated[info.file]:=1
		return 
	}
	if (info.get)
		return update[info.get]
	if (info.sc){
		fn:=files.ssn("//*[@sc='" info.sc "']")
		ea:=xml.ea(fn),fn:=ssn(fn,"@file").text
		if !fn
			return
		if (updated[info.file]=""){
			Gui,1:TreeView,% hwnd("fe")
			TV_Modify(ea.tv,"",ea.filename "*")
			sc:=csc()
		}
		pos:=posinfo(),line:=sc.2166(pos.start),end:=sc.2166(pos.end)
		if (line!=end){
			Loop,% end-line
			{
				style:=sc.2533(line+(A_Index-1))
				if style in 0,31,33,48
					sc.2242(4,1),sc.2240(4,5),sc.2532(line+(A_Index-1),30)
			}
		}Else{
			style:=sc.2533(line)
			if style in 0,31,33,48
				sc.2242(4,1),sc.2240(4,5),sc.2532(line,30)
		}
		if (sc.2570>1){
			Loop,% sc.2570
			{
				line:=sc.2166(sc.2577(A_Index-1)),style:=sc.2533(line)
				if style in 0,31,33,48
					sc.2242(4,1),sc.2240(4,5),sc.2532(line,30)
			}
			
		}
		updated[fn]:=1
		update[fn]:=csc().getuni()
		return
	}
	return
}