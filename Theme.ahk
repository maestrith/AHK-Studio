Theme(info=""){
	if info
		goto,returnedinfo
	;class-ify
	setup(3,1),hotkeys([3],{Esc:"3GuiClose"}),v.themelist:=[]
	Gui,3:Default
	Gui,+hwndhwnd Owner1
	Gui,Add,TreeView,w200 h500 gthemetv AltSubmit
	theme:=v.theme:=new s(3,{pos:"x+10 w500 h500"}),hotkeys([3],{Delete:"themedelete"})
	Gui,Add,Button,Hidden x0 y0 gthemetv Default,go
	Loop,80
		theme.2409(A_Index,1)
	Gui,Show,% Center(3),Theme Editor
	theme.2246(0,1),theme.2400,theme.2563(0)
	v.themelist:=[]
	color:=TV_Add("Color")
	for a,b in ["Background","Default Background Color","Default Font Style","Caret","Caret Line Background","End Of Line Color","Reset To Default","Indent Guide","Multiple Selection Foreground","Multiple Selection Background"
		,"Main Selection Foreground","Main Selection Background","Brace Match Color","Edited Marker","Saved Marker","Compare Color"]
	v.themelist[TV_Add(b,color,"Sort")]:=b
	options:=TV_Add("Theme Options")
	for a,b in ["Edit Theme Name","Edit Author","Download Themes","Export Theme","Import Theme","Save Theme","Display Style Number At Caret"]
		v.themelist[TV_Add(b,options,"Sort")]:=b
	v.themelist[TV_Add("Color Input Method")]:="Color Input Method"
	tlist:=preset.sn("//fonts/name")
	tl:=TV_Add("Themes")
	v.themetv:=tl
	while,tt:=tlist.item[A_Index-1]
		v.themelist[TV_Add(tt.text,tl)]:="themes list"
	TV_Add("More Coming Soon...")
	for a,b in [color,options,themes,tl]
		TV_Modify(b,"Expand")
	TV_Modify(color,"Vis")
	csc({hwnd:v.theme.sc})
	csc().2181(0,themetext())
	fix_indent()
	return event:=""
	themetv:
	event:=v.themelist[TV_GetSelection()]
	if (v.themetv=A_EventInfo)
		return
	if (A_GuiEvent!="normal"&&A_GuiEvent!="K")
		return
	if (event="Display Style Number At Caret"){
		return m("Style=" csc().2010(csc().2008))
	}if (event="Brace Match Color"){
		color:=settings.ssn("//fonts/font[@code='2082']/@color").text
		color:=dlg_color(color,hwnd(3))
		if ErrorLevel
			return
		if !clr:=settings.ssn("//fonts/font[@code='2082']")
			settings.Add({path:"fonts/font",att:{code:2082,color:color},dup:1})
		else
			clr.SetAttribute("color",color)
		refreshthemes()
	}
	if (event="Themes List"){
		TV_GetText(theme,TV_GetSelection())
		overwrite:=preset.ssn("//name[text()='" theme "']..")
		clone:=overwrite.clonenode(1)
		rem:=settings.ssn("//fonts"),rem.ParentNode.RemoveChild(rem)
		settings.ssn("*").appendchild(clone)
		csc().2181(0,themetext())
		refreshthemes()
	}if (event="Compare Color"){
		style:=48
		color:=settings.ssn("//fonts/font[@style='" style "']")
		clr:=dlg_color(color.text,hwnd(1))
		if !settings.ssn("//fonts/font[@style='" style "']")
			settings.Add({path:"fonts/font",att:{style:style,background:clr},dup:1})
		Else
			color.SetAttribute("background",clr)
		refreshthemes()
	}if (event="Edited Marker"||event="Saved Marker"){
		style:=event="Edited Marker"?30:31,color:=settings.ssn("//fonts/font[@style='" style "']")
		clr:=dlg_color(color.text,hwnd(1))
		if !settings.ssn("//fonts/font[@style='" style "']")
			settings.Add({path:"fonts/font",att:{style:style,background:clr},dup:1})
		Else
			color.SetAttribute("background",clr)
		refreshthemes()
	}if (event="export theme"){
		FileCreateDir,Themes
		name:=settings.ssn("//fonts/name").text
		temp:=new xml("fonts","Themes\" name ".xml")
		font:=settings.ssn("//fonts")
		clone:=font.clonenode(1)
		temp.xml.loadxml(clone.xml)
		temp.save(1)
		m("Theme saved to " A_ScriptDir "\Themes\" name ".xml")
	}if (event="import theme"){
		FileSelectFile,theme,,,,*.xml
		if ErrorLevel
			return
		temp:=ComObjCreate("MSXML2.DOMDocument"),temp.setProperty("SelectionLanguage","XPath")
		temp.load(theme)
		if !(ssn(temp,"//name").xml&&ssn(temp,"//author").xml&&ssn(temp,"//fonts").xml)
			return m("Theme not compatible")
		top:=ssn(temp,"*")
		rem:=settings.ssn("//fonts")
		rem.ParentNode.RemoveChild(rem)
		tt:=settings.ssn("*")
		tt.appendchild(top)
		event:="Save Theme"
	}if (event="Edit Author"){
		author:=settings.ssn("//fonts/author")
		newauthor:=InputBox(csc().sc,"New Author","Enter your name",author.text)
		if ErrorLevel
			return event:=""
		author.text:=newauthor
		csc().2181(0,themetext())
	}if (event="Edit Theme Name"){
		themename:=settings.ssn("//fonts/name")
		newtheme:=InputBox(csc().sc,"New Theme Name","Enter the new theme name",themename.Text)
		if ErrorLevel
			return event:=""
		themename.text:=newtheme
		csc().2181(0,themetext())
	}if (event="Color Input Method"){
		method:=settings.ssn("//colorinput").text?0:1
		settings.add({path:"colorinput",text:method})
		mode:={0:"Gui",1:"Hex"}
		m("Your current color input mode is now set to " mode[method])
	}if (v.themelist[TV_GetParent(A_EventInfo)]="Download Themes"){
		temp:=new xml("temp"),TV_GetText(filename,A_EventInfo)
		info:=URLDownloadToVar("http://files.maestrith.com/AHK-Studio/themes/" filename)
		temp.xml.loadxml(SubStr(info,InStr(info,"<")))
		rem:=settings.ssn("//fonts"),rem.ParentNode.RemoveChild(rem)
		settings.ssn("*").appendchild(temp.ssn("*"))
		csc().2181(0,themetext()),event:="save theme"
		refreshthemes()
	}if (event="save theme"){
		FileCreateDir,Themes
		font:=settings.ssn("//fonts")
		clone:=font.clonenode(1)
		name:=settings.ssn("//fonts/name").text
		rem:=preset.ssn("//fonts/name[text()='" name "']..")
		if rem
			rem.ParentNode.removechild(rem)
		Else
			v.themelist[TV_Add(name,v.themetv,"Sort")]:="themes list"
		top:=preset.ssn("*")
		top.appendchild(clone)
		preset.save(1)
		tlist:=preset.sn("//preset/*")
		noadd:=0
	}if (event="Download Themes"){
		parent:=TV_GetSelection()
		if child:=TV_GetChild(parent){
			list:=[]
			list[child]:=1
			while,child:=TV_GetNext(child)
				list[child]:=1
			for a,b in List
				TV_Delete(a)
		}
		SplashTextOn,200,50,Downloading Themes,Please Wait...
		wb:=ComObjCreate("HTMLfile")
		wb.write(URLDownloadToVar("http://files.maestrith.com/AHK-Studio/themes/"))
		while,aa:=wb.links.item[A_Index-1].innerhtml
			if InStr(aa,".xml")
				TV_Add(aa,parent)
		SplashTextOff,wb:=""
		TV_Modify(parent,"Expand")
	}if InStr(event,"Main Selection"){
		code:=InStr(event,"foreground")?2067:2068
		main:=settings.ssn("//fonts/font[@code='" code "']")
		color:=dlg_color(ssn(main,"@color").text,(hwnd(3)))
		if !ErrorLevel
			main.setattribute("color",color)
		refreshthemes()
	}if InStr(event,"Multiple Selection"){
		code:=InStr(event,"fore")?2600:2601
		if !multi:=settings.ssn("//fonts/font[@code='" code "']")
			multi:=settings.Add({path:"fonts/font",att:{code:code},dup:1})
		color:=dlg_color(ssn(multi,"@color").text,(hwnd(3)))
		if !ErrorLevel
			multi.setattribute("color",color)
		refreshthemes()
	}if (event="Indent Guide"){
		guide:=settings.ssn("//fonts/font[@style='37']")
		color:=dlg_color(ssn(guide,"@color").text,hwnd(3))
		if !ErrorLevel
			guide.setattribute("color",color)
		refreshthemes()
	}if (event="End Of Line Color"){
		eol:=settings.ssn("//fonts/font[@style='0']")
		color:=dlg_color(ssn(eol,"@color").text,hwnd(3))
		if !ErrorLevel
			eol.setattribute("color",color)
		refreshthemes()
	}if (event="Default Font Style"){
		rem:=settings.sn("//fonts/font[@style!='5' and @font]")
		while,rr:=rem.item[A_Index-1]
			rr.removeattribute("font")
		refreshthemes()
	}if (event="Caret Line Background"){
		cb:=settings.ssn("//fonts/font[@code='" 2098 "']")
		color:=dlg_color(ssn(cb,"@color").text,hwnd(3))
		if !ErrorLevel
			cb.setattribute("color",color)
		refreshthemes()
	}if (event="caret"){
		caret:=settings.ssn("//fonts/font[@code='2069']")
		color:=dlg_color(ssn(caret,"@color").text,hwnd(3))
		if !ErrorLevel
			caret.setattribute("color",color)
		refreshthemes()
	}if (event="Default Background Color"||event="Background"){
		if InStr(event,"Default"){
			rem:=settings.sn("//fonts/font[@style!='5' and @style!=33 and @background]")
			while,rr:=rem.item[A_Index-1]
				rr.removeattribute("background")
		}
		if !style:=settings.ssn("//fonts/font[@style='5']")
			style:=settings.add({path:"fonts/font",att:{style:5}})
		default:=settings.ea("//fonts/font[@style='5']")
		color:=dlg_color(default.Background,hwnd(3))
		if ErrorLevel
			return event:=""
		style.setattribute("background",color)
		refreshthemes()
	}if (event="reset to default"){
		rem:=settings.ssn("//fonts")
		rem.parentnode.removechild(rem)
		defaultfont()
		refreshthemes()		
	}
	event:=""
	return
	3GuiEscape:
	3GuiClose:
	hwnd({rem:3}),csc("Scintilla1"),csc().2400
	return
	returnedinfo:
	if (info.style){
		styleclick:
		SetTimer,%A_ThisLabel%,Off
		st:=v.style.style,mod:=v.style.mod
		if !style:=settings.ssn("//fonts/font[@style='" st "']")
			style:=settings.add({path:"fonts/font",att:{style:st},dup:1})
		color:=dlg_color(ssn(style,"@color").text,hwnd(3))
		if ErrorLevel
			return
		style.setattribute("color",color)
		Loop,2
			settings.Transform()
		refreshthemes()
		return
	}
	if (info.editfont){
		editfont:
		SetTimer,%A_ThisLabel%,Off
		if !style:=settings.ssn("//fonts/font[@style='" v.style.style "']")
			style:=settings.add({path:"fonts/font",att:{style:v.style.style},dup:1})
		font:=settings.ea("//fonts/font[@style='" v.style.style "']")
		compare:=default:=settings.ea("//fonts/font[@style='5']")
		for a,b in font
			default[a]:=b
		dlg_font(Default,1,hwnd(3))
		for a,b in compare{
			if a not in style,Background
				if (default[a]!=b)
					style.setattribute(a,Default[a])
		}
		refreshthemes()
		return
	}
	if (info.editback){
		editback:
		SetTimer,%A_ThisLabel%,Off
		if !style:=settings.ssn("//fonts/font[@style='" v.style.style "']")
			style:=settings.add({path:"fonts/font",att:{style:v.style.style},dup:1})
		default:=settings.ea("//fonts/font[@style='5']")
		font:=settings.ea("//fonts/font[@style='" v.style.style "']")
		color:=font.Background?font.Background:default.Background
		color:=dlg_color(color,hwnd(3))
		if ErrorLevel
			return
		style.setattribute("background",color)
		refreshthemes()
		return
	}
	if (info.margin!=""){
		style:=settings.ssn("//fonts/font[@style='33']")
		if (info.mod=0){
			color:=ssn(style,"@color").text
			color:=dlg_color(color,hwnd(3))
			if ErrorLevel
				return
			style.setattribute("color",color)
			refreshthemes()
		}
		if (info.mod=4){
			color:=ssn(style,"@background").text
			color:=dlg_color(color,hwnd(3))
			if ErrorLevel
				return
			style.setattribute("background",color)
			refreshthemes()
		}
	}
	return
	themedelete:
	Gui,3:Default
	if (v.themelist[TV_GetSelection()]="themes list"){
		TV_GetText(theme,TV_GetSelection())
		rem:=preset.ssn("//name[text()='" theme "']..")
		rem.ParentNode.RemoveChild(rem)
		TV_Delete(TV_GetSelection())
	}
	return
}