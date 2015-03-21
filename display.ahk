display(store){
	static recieve:=new xml("recieve"),total
	start:=1
	if !store
		return
	if !WinExist(hwnd([99])){
		setup(99,1)
		Gui,Add,Edit,w400 h600
		Gui,99:Show,x0 NA,Debug
		Gui,1:Default
		debug.On()
	}
	recieve.xml.loadxml(store)
	if info:=recieve.ssn("//stream[@type='stderr']"){
		info:=debug.decode(info.text),total.=info "`n"
		GuiControl,99:,Edit1,%total%
		ControlSend,Edit1,^{End},% hwnd([99])
		in:=striperror(info,v.debugfilename)
		if (in.file&&in.line){
			sc:=csc(),tv(files.ssn("//*[@file='" in.file "']/@tv").text)
			sleep,400
			debug.Send("stop"),v.debugse:={start:sc.2128(in.line),end:sc.2136(in.line)}
			SetTimer,selectdebug,10
		}
		return
		selectdebug:
		SetTimer,Selectdebug,Off
		sc:=csc(),sc.2160(v.debugse.start,v.debugse.end),debug.disconnect()
		return
	}
	if init:=recieve.ssn("//init"){
		v.afterbug:=[],ad:=["stdout -c 2","stderr -c 2"],ea:=settings.ea("//features")
		for a,b in ["max_depth","max_children"]
			value:=ea[b]?ea[b]:4,ad.Insert("feature_set -n " b " -v " value)
		break:=positions.sn("//main[@file='" v.debugfilename "']/*/@breakpoint/..")
		while,bb:=Break.item[A_Index-1]{
			file:=ssn(bb,"@file").text,lines:=ssn(bb,"@breakpoint").Text
			for a,b in StrSplit(lines,",")
				ad.Insert("breakpoint_set -t line -n " ++b " -f" file)
		}
		if v.connect
			ad.Insert("run"),v.connect:=0
		for a,b in ad
			v.afterbug.Insert(b)
		SetTimer,afterbug,200
		debug.On()
	}
	if recieve.ssn("//property"){
		if property:=recieve.sn("//property"){
			if property.length>1000
				ToolTip,Compiling List Please Wait...,350,150
			varbrowser(),list:=[],variablelist:=[],value:=[],object:=recieve.sn("//response/property")
			Gui,97:Default
			GuiControl,97:-Redraw,SysTreeView321
			TV_Delete()
			while,oo:=object.item[A_Index-1]{
				ea:=xml.ea(oo),value:=debug.decode(oo.text),list[ea.fullname]:=TV_Add(ea.fullname a:=ea.type="object"?"":" = " value)
				if (ea.type!="object")
					variablelist[list[ea.fullname]]:={value:value,variable:ea.fullname}
				descendant:=sn(oo,"descendant::*")
				while,des:=descendant.item[A_Index-1]{
					ea:=xml.ea(des),value:=debug.decode(des.text),list[ea.fullname]:=TV_Add(ea.fullname a:=ea.type="object"?"":" = " value,list[prev:=SubStr(ea.fullname,1,InStr(ea.fullname,".",0,0)-1)],"Sort")
					if (ea.type!="object")
						variablelist[list[ea.fullname]]:={value:value,variable:ea.fullname}
				}
			}
			v.variablelist:=variablelist,debug.Send("run")
			GuiControl,97:+Redraw,SysTreeView321
			return t()
		}
	}else if info:=recieve.ssn("//stream"){
		disp:=debug.decode(info.text),stream:=1
	}else if command:=recieve.ssn("//response"){
		if recieve.sn("//response").length>1
			m("more info")
		ea:=recieve.ea(command)
		if (ea.status="stopped"&&ea.command="run"&&ea.reason="ok")
			debug.Off()
		disp:="Command:"
		for a,b in ea
			if (a&&b)
				disp.="`r`n" a " = " Chr(34) b Chr(34)
		info:=disp
	}
	disp:=disp?disp:store
	if (disp){
		total.=disp "`n"
		GuiControl,99:,Edit1,%total%
		ControlSend,Edit1,^{End},% hwnd([99])
	}
	if (stream){
		stream:=0
		return disp
	}
	return
	disp:=recieve[],store:=disp?disp:store
	return sock
	99GuiEscape:
	99GuiClose:
	debug.send("detach")
	SetTimer,closeconn,400
	return
	closeconn:
	SetTimer,closeconn,Off
	debug.disconnect(),hwnd({rem:99})
	return
	afterbug:
	debug.Send(v.afterbug.1),v.afterbug.Remove(1)
	if !v.afterbug.1
		SetTimer,afterbug,Off
	return
}