#SingleInstance,Off
DetectHiddenWindows,On
CoordMode,ToolTip,Screen
#NoEnv
#MaxHotkeysPerInterval,5000
#HotkeyInterval,1
SetWorkingDir,%A_ScriptDir%
file=%1%
SetBatchLines,-1
;download complete
ComObjError(0)
CoordMode,ToolTip,Screen
if(!FileExist("lib"))
	FileCreateDir,Lib
global v:=[],settings:=New XML("settings","lib\Settings.XML"),files:=New XML("files"),menus,commands:=New XML("commands","lib\commands.XML"),positions:=New XML("positions","lib\positions.XML"),vversion,access_token,vault:=New XML("vault","lib\Vault.XML"),preset,Scintilla,bookmarks,cexml:=New XML("Code_Explorer"),notesxml,language:=New XML("language","lib\en-us.XML"),vversion:=New XML("version","lib\version.XML"),Custom_Commands:=New XML("custom","lib\Custom Commands.XML")
v.pluginversion:=1,menus:=New XML("menus","lib\menus.XML"),FileCheck(file)
if(FileExist("AHKStudio.ico"))
	Menu,Tray,Icon,AHKStudio.ico
New Omni_Search_Class(),v.filelist:=[],v.Options:=[],var(),Keywords(),Gui(),v.match:={"{":"}","[":"]","<":">","(":")",Chr(34):Chr(34),"'":"'","%":"%"},v.filescan:=[]
ObjRegisterActive(PluginClass),preset:=New XML("preset","lib\preset.XML")
SetWorkingDir,%A_ScriptDir%
ea:=settings.ea("//Options")
for a,b in ea
	v.Options[a]:=b
v.Options.Full_Auto:=settings.ssn("//Auto_Indent/@Full_Auto").Text
return
SetTimer,Color
GuiDropFiles:
tv:=Open(A_GuiEvent,1),openfile:=StrSplit(A_GuiEvent,"`n").1,main:=files.ssn("//main[@file='" openfile "']"),tv(tv)
return
selectfile:
tv(files.ssn("//*[@file='" v.openfile "']/@tv").Text)
return
#Include %A_ScriptDir%
About(){
	about=
(
If you wish to use this software, great.

If you wish to use this as a part of your project I require payment.

If you wish to donate to help me with my living expenses please click the donate button at the bottom

I want to thank all of the people who helped this project become a reality.

Chris Mallet - Creator of the original AutoHotkey
	All of the people who helped him.
Lexikos - For all of the amazing work on AHK 1.1
	All of the people who helped him.

Help from friends who have given me great ideas and bug reports
	Uberi,Coco,Tidbit,GeekDude,joedf,budRich,tomoe_uehara,hoppfrosch,Run1e and everyone who I have not listed I am thankful.
	
All of the editors that I have used for giving me ideas for this project

Special thanks to number1nub and Run1e for helping with the beta testing for the latest version

License for Scintilla and SciTE

Copyright 1998-2002 by Neil Hodgson <neilh@scintilla.org>

All Rights Reserved 

Permission to use, copy, modify, and distribute this software and its 
documentation for any purpose and without fee is hereby granted, 
provided that the above copyright notice appear in all copies and that 
both that copyright notice and this permission notice appear in 
supporting documentation. 

NEIL HODGSON DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS 
SOFTWARE, INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY 
AND FITNESS, IN NO EVENT SHALL NEIL HODGSON BE LIABLE FOR ANY 
SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES 
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, 
WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER 
TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE 
OR PERFORMANCE OF THIS SOFTWARE. 
)
	setup(11),hotkeys([11],{"Esc":"11GuiClose"}), Version:="1.002.20"
	Gui,Margin,0,0
	sc:=new s(11,{pos:"x0 y0 w700 h500"}),csc({hwnd:sc})
	Gui,Add,Button,gdonate,Donate
	Gui,Add,Button,x+M gsite,Website
	Gui,Show,,AHK Studio Help Version: %version%
	sc.2181(0,about),sc.2025(0),sc.2268(1)
	return
	11GuiClose:
	11GuiEscape:
	hwnd({rem:11})
	return
	site:
	Run,https://github.com/maestrith/AHK-Studio
	return
}
Activate(){
	csc().2400
}
AddBookmark(line,search){
	sc:=csc(),end:=sc.2136(line),start:=sc.2128(line),name:=(settings.ssn("//bookmark").text),name:=name?name:SubStr(StrSplit(current(2).file,"\").pop(),1,-4)
	for a,b in {"$file":SubStr(StrSplit(current(3).file,"\").pop(),1,-4),"$project":SubStr(StrSplit(current(2).file,"\").pop(),1,-4)}
		name:=RegExReplace(name,"i)\Q" a "\E",b)
	if(RegExMatch(name,"UO)\[(.*)\]",time)){
		FormatTime,currenttime,%A_Now%,% time.1
		name:=RegExReplace(name,"\Q[" time.1 "]\E",currenttime)
	}sc.2003(end," " Chr(59) search.1 "[" name "]"),sc.2160(end+4,end+4+StrPut(name,utf-8)-1)
}
AutoMenu(){
	AutoMenu:
	sc:=csc()
	if(sc.2007(sc.2008-1)~="40|123")
		return
	command:=RegExReplace(context(1).word,"#")
	if(v.word&&sc.2102=0&&v.options.Disable_Auto_Complete!=1){
		if(l:=commands.ssn("//Context/" command "/descendant-or-self::list[text()='" RegExReplace(v.word,"#") "']")){
			if(!list:=ssn(l,"@list"))
				return
			insert:=v.options.Auto_Space_After_Comma?", ":","
			if(sc.2007(sc.2008-StrLen(insert))!=44)
				sc.2003(sc.2008,insert),sc.2025(sc.2008+StrLen(insert))
			sc.2100(0,list.text,v.word:="")
		}
	}
	return
}
BookEnd(add,hotkey){
	if(!(add&&hotkey))
		return
	sc:=csc(),forward:=[],rev:=[],sc.2078,add:=add?add:v.match[hotkey]
	loop,% sc.2570
		start:=sc.2585(A_Index-1),end:=sc.2587(A_Index-1),forward[start]:={start:start,end:End}
	for a,b in forward
		rev.Insert(b)
	for a in rev
		info:=rev[rev.MaxIndex()-(A_Index-1)],sc.2190(info.start),sc.2192(info.End),sc.2003(info.end,add),sc.2003(info.start,Hotkey),sc.2160(info.start+1,info.end+1)
	for a,b in rev{
		if(A_Index=1)
			sc.2160(b.start+1,b.end+1)
		else
			sc.2573(b.end+(A_Index*2)-1,b.start+(A_Index*2)-1)
	}sc.2079
}
Brace(){
	ControlGetFocus,Focus,A
	sc:=csc(),cp:=sc.2008,line:=sc.2166(cp),hotkey:=SubStr(A_ThisHotkey,0)
	pos:=PosInfo()
	if(!InStr(Focus,"Scintilla")){
		Send,{%hotkey%}
		return
	}add:=v.brace[Hotkey]?v.brace[Hotkey]:v.bracematch[Hotkey]
	if(v.brace[Hotkey]){
		if(pos.start!=pos.end&&v.brace[Hotkey])
			return BookEnd(add,hotkey)
		if(A_ThisHotkey=Chr(34))
			if(sc.2010(sc.2008)=13)
				return sc.2003(sc.2008,Chr(34)),sc.2025(sc.2008+1)
		if(hotkey="'"&&sc.2267(sc.2008-1,1)=sc.2008)
			return sc.2003(sc.2008,"'"),sc.2025(sc.2008+1)
		if(sc.2102&&v.options.Disable_Auto_Insert_Complete!=1&&(hotkey~="\(|\{")){
			word:=sc.getword()
			if(xml.ea(cexml.ssn("//*[@upper='" upper(word) "']")).type~="Method|Function")
				sc.2101
			else{
				sc.2104(),cp:=sc.2008
				if(Chr(sc.2007(sc.2008-1))=hotkey)
					return
	}}}else
		sc.2101()
	if(sc.2007(sc.2008)=Asc(hotkey)&&v.options.Auto_Advance&&sc.2007(sc.2008)!=0)
		return sc.2025(sc.2008+1)
	if(sc.2008!=sc.2009)
		return bookend(add,hotkey)
	if(hotkey="{"&&sc.2128(line)=cp&&cp=sc.2136(line)&&v.options.full_auto)
		sc.2003(cp,"{`n`n}"),fix_indent(),sc.2025(sc.2136(line+1))
	else if(hotkey="{"&&sc.2128(line)=cp&&cp!=sc.2136(line)&&v.options.full_auto)
		sc.2078(),backup:=Clipboard,sc.2419(cp,sc.2136(line)),sc.2645(cp,sc.2136(line)-cp),sc.2003(cp,"{`n" clipboard "`n}"),fix_indent(),Clipboard:=backup,sc.2079()
	else
		sc.2003(cp,hotkey add),sc.2025(cp+1)
	SetStatus("Last Entered Character: " hotkey " Code:" Asc(hotkey),2),replace()
	return
	match:
	sc:=csc()
	ControlGetFocus,Focus,A
	if(sc.2008!=sc.2009&&InStr(focus,"Scintilla"))
		bookend(v.match[A_ThisHotkey],A_ThisHotkey)
	else
		Send,{%A_ThisHotkey%}
	SetStatus("Last Entered Character: " A_ThisHotkey " Code:" Asc(A_ThisHotkey),2)
	return
}
BraceSetup(Win:=1){
	static oldkeys:=[]
	Hotkey,IfWinActive,% hwnd([win])
	for a in oldkeys
		Hotkey,%a%,brace,Off
	v.brace:=[],autoadd:=settings.sn("//autoadd/*"),v.braceadvance:=[],oldkeys:=[]
	if(!RegExReplace(test:=settings.ssn("//autoadd/*/@trigger").text,"\d"))
		while,aa:=autoadd.item[A_Index-1],ea:=xml.ea(aa)
			aa.SetAttribute("trigger",Chr(ea.trigger)),aa.SetAttribute("add",Chr(ea.add))
	while,aa:=autoadd.item(a_index-1),ea:=xml.ea(aa){
		if(ea.trigger){
			v.brace[ea.trigger]:=ea.add,v.braceadvance[ea.add]:=Asc(ea.add),oldkeys[ea.trigger]:=1
			if(ea.trigger!=ea.add)
				oldkeys[ea.Add]:=1
	}}for a in oldkeys
		Hotkey,%a%,brace,On
	SetMatch()
}
Center(win){
	Gui,%win%:Show,Hide
	WinGetPos,x,y,w,h,% hwnd([1])
	WinGetPos,xx,yy,ww,hh,% hwnd([win])
	centerx:=(Abs(w-ww)/2),centery:=Abs(h-hh)/2
	return "x" x+centerx " y" y+centery
}
CenterSel(){
	sc:=csc(),sc.2169,a:=sc.2166(sc.2585(sc.2575)),total:=sc.2370/2-1
	if(v.options.center_caret!=1){
		sc.2403(0x04|0x08)
		Sleep,1
		sc.2169(),sc.2403(0,0)
	}
}
Check_For_Edited(){
	all:=files.sn("//file"),sc:=csc()
	while,aa:=all.item[A_Index-1],ea:=xml.ea(aa){
		FileGetTime,time,% ea.file
		if(time!=ea.time&&ea.note!=1){
			list.=ea.filename ","
			aa.SetAttribute("time",time)
			FileRead,text,% ea.file
			text:=RegExReplace(text,"\r\n|\r","`n")
			if(ea.sc=sc.2357)
				sc.2181(0,[text])
			else if(ea.sc&&ea.sc!=sc.2357)
				sc.2377(ea.sc),aa.RemoveAttribute("sc")
			update({file:ea.file,text:text})
		}
	}
	if(list)
		SetStatus("Files Updated:" Trim(list,","),3)
	return 1
}
Check_For_Update(startup:=""){
	static newwin,version
	auto:=settings.ea("//autoupdate")
	if(startup=1){
		if(v.options.Check_For_Update_On_Startup!=1)
			return
		if(auto.reset>A_Now)
			return
	}
	sub:=A_NowUTC
	sub-=A_Now,hh
	FileGetTime,time,%A_ScriptFullPath%
	time+=sub,hh
	ea:=settings.ea("//github"),token:=ea.token?"?access_token=" ea.token:"",url:="https://api.github.com/repos/maestrith/AHK-Studio/commits/master" token,http:=ComObjCreate("WinHttp.WinHttpRequest.5.1"),http.Open("GET",url)
	if(proxy:=settings.ssn("//proxy").text)
		http.setProxy(2,proxy)
	http.send()
	RegExMatch(http.ResponseText,"iUO)\x22date\x22:\x22(.*)\x22",found),date:=RegExReplace(found.1,"\D")
	if(startup="1"){
		if(reset:=http.getresponseheader("X-RateLimit-Reset")){
			seventy:=19700101000000
			for a,b in {s:reset,h:-sub}
				EnvAdd,seventy,%b%,%a%
			settings.add("autoupdate",{reset:seventy})
			if(time>date)
				return
		}else
			return
	}
	Version:="1.002.20"
	newwin:=new GUIKeep("CFU"),newwin.add("Edit,w400 h400 ReadOnly,No New Updated,wh","Button,gautoupdate,Update,y","Button,x+5 gcurrentinfo,Current Changelog,y","Button,x+5 gextrainfo,Changelog History,y"),newwin.show("AHK Studio Version: " version)
	if(time<date){
		file:=FileOpen("changelog.txt","rw"),file.seek(0),file.write(update:=RegExReplace(UrlDownloadToVar("https://raw.githubusercontent.com/maestrith/AHK-Studio/master/AHK-Studio.text"),"\R","`r`n")),file.length(file.position),file.Close()
		ControlSetText,Edit1,%update%,% newwin.ahkid
	}if(!found.1)
		ControlSetText,Edit1,% http.ResponseText,% newwin.ahkid
	return
	autoupdate:
	save(),settings.save(1),menus.save(1),studio:=URLDownloadToVar("https://raw.githubusercontent.com/maestrith/AHK-Studio/master/AHK-Studio.ahk")
	if(!InStr(studio,";download complete"))
		return m("There was an error. Please contact maestrith@gmail.com if this error continues")
	SplitPath,A_ScriptFullPath,,,ext,nne
	FileMove,%nne%.ahk,%A_ScriptDir%\%nne% - %version%.ahk,1
	File:=FileOpen(nne ".ahk","rw"),File.seek(0),File.write(studio),File.length(File.position)
	Loop,%A_ScriptDir%\*.ico
		icon:=A_LoopFileFullPath
	if(icon)
		add=/icon "%icon%"
	if(ext="exe"){
		SplashTextOn,200,50,Compiling,Please Wait...
		FileMove,%A_ScriptFullPath%,%nne% - %version%.exe,1
		SplitPath,A_AhkPath,file,dirr
		Loop,%dirr%\Ahk2Exe.exe,1,1
			file:=A_LoopFileFullPath
		RunWait,%file% /in "%A_ScriptDir%\%nne%.ahk" /out "%A_ScriptDir%\%nne%.exe" %add% /bin "%dirr%\Compiler\Unicode 32-bit.bin"
	}
	Reload
	ExitApp
	return
	currentinfo:
	file:=FileOpen("changelog.txt","rw")
	if(!file.length)
		file:=FileOpen("changelog.txt","rw"),file.seek(0),file.write(RegExReplace(UrlDownloadToVar("https://raw.githubusercontent.com/maestrith/AHK-Studio/master/AHK-Studio.text"),"\R","`r`n")),file.length(file.position)
	file.seek(0)
	ControlSetText,Edit1,% file.Read(file.length)
	file.Close()
	return
	extrainfo:
	Run,https://github.com/maestrith/AHK-Studio/wiki/Version-Update-History
	return
	cfuguiclose:
	cfuguiescape:
	newwin.Destroy()
	return
}
Class Code_Explorer{
	static explore:=[],TreeView:=[],sort:=[],function:="OUm`n)^[\s|}]*((\w|[^\x00-\x7F])+)\((.*)\)(\s+;.*)?\n?[\s]*\{",label:="UOm`n)^\s*((\w|[^\x00-\x7F])+):[\s|\R][\s+;]?",class:="Om`ni)^[\s*]?(class\s+(\w|[^\x00-\x7F])+)",Property:="Om`n)^\s*((\w|[^\x00-\x7F])+)\[(.*)?\][\s+;.*\s+]?[\s*]?{",functions:=[],variables:=[],varlist:=[]
	scan(node){
		static no:=new xml("no")
		ea:=xml.ea(node),text:="`n" update({get:ea.file}),pos:=1,parent:=ssn(node,"@file").text,next:=cexml.ssn("//file[@file='" parent "']"),fnme:=ea.file
		while,uu:=ssn(next,"*")
			uu.ParentNode.RemoveChild(uu)
		pos:=1,rem:=no.ssn("//bad"),rem.ParentNode.RemoveChild(rem),notop:=no.add("bad")
		while,RegExMatch(text,"OUm`r)\n\s*(\x2F\x2A.*\x2A\x2F)",found,pos),pos:=found.pos(1)+found.len(1)
			no.under(notop,"bad",{min:found.pos(1)-3,max:found.pos(1)+found.len(1)-3,type:"comment"},,1)
		pos:=1
		while,RegExMatch(text,Code_Explorer.class,found,pos),pos:=found.Pos(1)+found.len(1)
			if(!no.ssn("//bad[@min<'" found.pos(1) "' and @max>'" found.pos(1) "']"))
				cexml.under(next,"info",{type:"Class",opos:found.Pos(1)-1,pos:ppp:=StrPut(SubStr(text,1,found.Pos(1)),"utf-8")-3,text:RegExReplace(found.1,"i)^(class|\s)"),upper:upper(RegExReplace(found.1,"i)(class\s+)"))})
		clist:=sn(next,"descendant::info[@type='Class']")
		while,cc:=clist.item[A_Index-1],ea:=xml.ea(cc),tt:=SubStr(text,ea.opos),total:="",braces:=start:=lbraces:=0{
			for a,b in StrSplit(tt,"`n","`r`n"){
				line:=Trim(RegExReplace(b,"(\s+" Chr(59) ".*)\R?"))
				if(SubStr(line,1,1)="}"){
					while,((found1:=SubStr(line,A_Index,1))~="(}|\s)"){
						if(found1~="\s")
							Continue
						braces--
				}}if(start&&braces<=0){
					for c,d in StrSplit(line)
						if(RegExMatch(d,"[}|\s]")&&lbraces>0)
							total.=d,lbraces--
					break
				}total.=b "`n"
				if(SubStr(line,0,1)="{")
					braces++,start:=1
				lbraces:=braces
			}
			lasteapos:=ea.pos,total:=Trim(total,"`n"),cc.SetAttribute("end",np:=ea.pos+StrPut(total,"utf-8")-1)
			for a,b in {Property:Code_Explorer.property,Method:Code_Explorer.function}{
				pos:=1
				while,RegExMatch(total,b,found,pos),pos:=found.Pos(1)+found.len(1)
					if(no.ssn("//bad[@min<'" ea.pos+found.pos(1) "' and @max>'" ea.pos+found.pos(1) "']")=""&&found.1!="if")
						add:=a="property"?"[":"(",cexml.under(cc,"info",{type:a,pos:ea.pos+StrPut(SubStr(text,1,found.Pos(1)),"utf-8")-2,text:found.1,upper:upper(found.1),args:found.value(3),class:ea.text})
			}no.Add("bad/bad",{min:ea.pos,max:np,type:"Class"},,1)
		}pos:=1
		while,RegExMatch(text,Code_Explorer.Function,found,pos),pos:=found.pos(1)+found.len(1){
			if(no.ssn("//bad[@min<'" found.pos(1) "' and @max>'" found.pos(1)+1 "']")=""&&found.1!="if"){
				cexml.under(next,"info",{args:found.3,type:"Function",text:found.1,upper:upper(found.1),pos:StrPut(SubStr(text,1,found.pos(1)))-3})
				/*
					if(RegExMatch(tq:=SubStr(text,found.Pos(0)+found.len(0)),"OU)^\s*(\;.*)\n",fq)){
						RegExMatch(SubStr(tq,fq.Pos(0)+fq.len(0)),"UO)^\s*(;.*)\n",fq2)
						v.listo.=fq.0 "`n-`n" fq2.0 "`n-----`n"
					}
				*/
			}
		}for type,find in {Hotkey:"OUi`nm)^(((\w|[^\x00-\x7F]|#|!|\^|\+|~|\$|&|<|>|\*)+\s+&\s+)*(\w|[^\x00-\x7F]|#|!|\^|\+|~|\$|&|<|>|\*)+)::",Label:this.label}{ ;*\w+([ |\t]*\&[ |\t]*[#|!|^|\+|~|\$|&|<|>|*]*\w+)?
			pos:=1
			while,RegExMatch(text,find,fun,pos),pos:=fun.pos(1)+fun.len(1)
				if(!no.ssn("//bad[@min<'" fun.pos(1) "' and @max>'" fun.pos(1) "' and @type!='Class']"))
					cexml.under(next,"info",{type:type,pos:StrPut(SubStr(text,1,fun.Pos(1)),"utf-8")-3,text:fun.1,upper:upper(fun.1)})
		}pos:=1
		while,RegExMatch(text,"OUi).*(\w+)\s*:=\s*new\s*(\w+)\(",found,pos),pos:=found.Pos(2)+found.len(2){
			if(!no.ssn("//bad[@min<'" found.pos(1) "' and @max>'" found.pos(1) "' and @type!='Class']"))
				cexml.under(next,"info",{type:"Instance",upper:upper(found.1),pos:StrPut(SubStr(text,1,found.Pos(1)),"utf-8")-3,text:found.1,class:found.2})
		}if(!v.options.Disable_Variable_List){
			pos:=1,main:=ssn(node,"ancestor::main")
			while,pos:=RegExMatch(text,"Osm`n)(\w+)\s*:=",var,pos),pos:=var.Pos(1)+var.len(1)
				if(!ssn(main,"descendant::*[@type='Variable'][@text='" var.1 "'] or descendant::*[@type='Instance'][@text='" var.1 "']"))
					cexml.under(next,"info",{type:"Variable",upper:upper(var.1),pos:StrPut(SubStr(text,1,var.Pos(1)),"utf-8")-3,text:var.1})
		}pos:=1
		while,RegExMatch(text,"OUi);gui\[(.*)\].*\R(.*)\R;/gui\[.*\]",found,pos),pos:=found.Pos(1)+found.len(1){
			cexml.under(next,"info",{type:"Gui",opos:found.Pos(1)-1,pos:ppp:=StrPut(SubStr(text,1,found.Pos(1)),"utf-8")-3,text:found.1,upper:upper(found.1)})
			/*
				cexml.under(next,"info",{type:"Gui",upper:upper(found.1),pos:(start:=StrPut(SubStr(text,1,var.Pos(1)),"utf-8")-3),text:found.1,end:start+})
			*/
		}
		for a,b in {Bookmark:"\s+;#\[(.*)\]",Breakpoint:"\s+;\*\[(.*)\]"}{
			pos:=1
			while,pos:=RegExMatch(text,"OU)" b,found,pos),pos:=found.Pos(1)+found.len(1){
				nnn:=cexml.under(next,"info",{type:a,upper:upper(found.1),pos:StrPut(enter:=SubStr(text,1,found.Pos(0)),"utf-8"),text:found.1})
				if(a="Breakpoint"){
					RegExReplace(enter,"\R",,Count)
					nnn.SetAttribute("line",Count),nnn.SetAttribute("filename",fnme)
				}
			}
		}
	}remove(filename){
		this.explore.remove(ssn(filename,"@file").text),list:=sn(filename,"@file")
		while,ll:=list.item[A_Index-1]
			this.explore.Remove(ll.text)
	}populate(){
		code_explorer.Refresh_Code_Explorer()
		Gui,1:TreeView,SysTreeView321
	}Add(value,parent=0,options=""){
		Gui,1:Default
		Gui,1:TreeView,SysTreeView322
		return this.Add(value,parent,options)
	}Refresh_Code_Explorer(){
		if(v.options.Hide_Code_Explorer)
			return
		Gui,1:Default
		Gui,1:TreeView,SysTreeView322
		GuiControl,1:-Redraw,SysTreeView322
		TV_Delete()
		code_explorer.scan(current()),cet:=code_explorer.treeview:=new xml("TreeView"),bookmark:=[]
		SplashTextOff
		GuiControl,1:-Redraw,SysTreeView322
		fz:=cexml.sn("//files/main")
		while,fn:=fz.Item[A_Index-1]{
			things:=sn(fn,"descendant::info"),filename:=ssn(fn,"@file").text
			SplitPath,filename,file
			Gui,1:Default
			Gui,1:TreeView,SysTreeView322
			main:=TV_Add(file,0,"Sort")
			while,tt:=things.Item[A_Index-1],ea:=xml.ea(tt){
				if(ea.type="variable")
					continue
				fin:=ssn(tt,"ancestor::file/@file").text
				if(!top:=cet.ssn("//main[@file='" filename "'][@type='" ea.type "']"))
					if(!(ea.type~="(Method|Property)"))
						top:=cet.Add("main",{file:filename,type:ea.type,tv:TV_Add(ea.type,main,"Vis Sort")},"",1)
				if(ea.type~="(Method|Property)")
					cet.under(last,"info",{text:ea.text,pos:ea.pos,file:fin,tv:TV_Add(ea.text,ssn(last,"@tv").text,"Sort")})
				else
					last:=cet.under(top,"info",{text:ea.text,pos:ea.pos,file:fin,type:ea.type,tv:TV_Add(ea.text,ssn(top,"@tv").text,"Sort")})
			}
		}
		GuiControl,1:+Redraw,SysTreeView322
		Gui,1:TreeView,SysTreeView321
		return
	}cej(){
		static last
		cej:
		if(A_GuiEvent="Normal"&&A_GuiEvent!="RightClick"){
			list:=""
			Default("TreeView","SysTreeView322")
			if(found:=code_explorer.TreeView.ssn("//*[@tv='" TV_GetSelection() "']")){
				ea:=xml.ea(found)
				if(ea.pos="")
					return
				parent:=ssn(found,"ancestor::main/@file").text,
				SetPos({file:ea.file,start:ea.pos,end:ea.pos+StrLen(ea.text)})
				ControlFocus,SysTreeView322,% hwnd([1])
			}
			return
		}
		return
}}
;gui[flan]
Gui,Add,Button,,testing
Gui,Add,Edit,,Ok
Gui,Show
;/gui[flan]
Class FTP{
	__New(name){
		ea:=settings.ea("//ftp/server[@name='" name "']"),this.error:=0
		if(!(ea.username!=""&&ea.password!=""&&ea.address!=""))
			return m("Please setup your ftp information")
		SplashTextOn,200,100,Logging In,Please Wait...
		port:=ea.port?ea.port:21,this.library:=DllCall("LoadLibrary","str","wininet.dll","Ptr"),this.Internet:=DllCall("wininet\InternetOpen","str",A_ScriptName,"UInt",AccessType,"str",Proxy,"str",ProxyBypass,"UInt",0,"Ptr")
		if(!this.internet)
			this.cleanup(A_LastError)
		this.connect:=DllCall("wininet\InternetConnect","PTR",this.internet,"str",ea.address,"uint",Port,"str",ea.Username,"str",ea.Password,"uint",1,"uint",flags,"uint",0,"Ptr")
		if(!this.connect){
			this.cleanup(A_LastError)
			SplashTextOff
		}VarSetCapacity(ret,40)
	}
	CreateFile(name){
		list:=[]
		SplitPath,name,filename,dir,,namenoext
		IfNotExist,temp
			FileCreateDir,temp
		FileDelete,% "temp\" filename
		file:=FileOpen("temp\" filename,2),file.write(publish(1)),file.seek(0),List[filename]:=file
		FileDelete,% "temp\" namenoext ".text"
		file:=FileOpen("temp\" namenoext ".text",2),upinfo:="",info:=vversion.sn("//info[@file='" name "']/versions/version")
		while,in:=info.item[A_Index-1]
			upinfo.=ssn(in,"@number").text "`r`n" in.text "`r`n"
		upinfo:=text(upinfo),file.write(upinfo),file.seek(0),List[namenoext ".text"]:=file
		return list
	}
	Put(file,dir,compile,existing:=""){
		SplashTextOff
		updir:="/" Trim(RegExReplace(dir,"\\","/"),"/"),this.cd("/" Trim(RegExReplace(dir,"\\","/"),"/"))
		if(!(this.internet!=0&&this.connection!=0))
			return 0
		SplitPath,file,name,dir,,namenoext
		if(existing)
			list:=[],list[name]:=FileOpen(file,"rw")
		else
			list:=this.createfile(file)
		BufferSize:=4096
		if(compile)
			compile(),list[namenoext ".exe"]:=FileOpen(dir "\" namenoext ".exe","r")
		info:=sn(node,"versions/version")
		while,in:=info.item[A_Index-1]
			upver.=in.text "`r`n"
		for a,b in list{
			if(upver){
				ff:=!InStr(a,".exe")?A_ScriptDir "\temp\" a:dir "\" namenoext ".exe"
				SplitPath,a,fname
				SplashTextOn,300,50,Uploading file %a%,Please Wait...
				ii:=DllCall("wininet\FtpPutFile",UPtr,this.connect,UPtr,&ff,UPtr,&fname,UInt,2,UInt,0,"cdecl")
				SplashTextOff
			}else{
				this.file:=DllCall("wininet\FtpOpenFile",UPtr,this.connect,UPtr,&a,UInt,0x40000000,UInt,0x2,UPtr,0,"cdecl")
				Progress,0,uploading,%a%,Uploading,Tahoma
				if(!this.file)
					this.cleanup(A_LastError)
				length:=b.length,totalsize:=0,size:=1,b.seek(0)
				while,size{
					size:=b.rawread(buffer,BufferSize),totalsize+=size
					Progress,% (totalsize*100)/length
					DllCall("wininet\InternetWriteFile","PTR",this.File,"PTR",&Buffer,"UInt",size,"UIntP",out,"cdecl")
					Sleep,30
				}close:=DllCall("wininet\InternetCloseHandle","UInt",this.file)
				Sleep,100
				b.close()
			}
		}
		t(),list:=""
		Progress,Off
	}
	__Delete(){
		this.cleanup
	}
	Cleanup(error*){
		if(error.1)
			m(error.1)
		SplashTextOff
		if(error.1){
			SplashTextOff
			this.error:=1,m(this.GetLastError(error.1))
		}
		for a,b in [this.file,this.connect,this.internet]
			DllCall("wininet\InternetCloseHandle","UInt",this.internet)
		DllCall("FreeLibrary","UInt",this.library)
		return 0
	}
	CD(dir){
		if(!DllCall("wininet\FtpSetCurrentDirectory",UInt,this.connect,UPtr,&dir,"cdecl"))
			Loop,Parse,dir,/
				this.CreateDir(A_LoopField),this.SetDir(A_LoopField)
	}
	SetDir(dir){
		DllCall("wininet\FtpSetCurrentDirectory",UInt,this.connect,UPtr,&dir,"cdecl")
	}
	CreateDir(dir){
		DllCall("wininet\FtpCreateDirectory",UPtr,this.connect,UPtr,&dir,"cdecl")
	}
	GetDir(){
		cap:=VarSetCapacity(dir,128),DllCall("wininet\FtpGetCurrentDirectory",UInt,this.connect,UInt,&dir,UInt,&cap,"cdecl")
		return Trim(StrGet(&dir,128,"cp0"),"/")
	}
	GetLastError(error){ ;http://msdn.microsoft.com/en-us/library/ms679351
		size:=VarSetCapacity(buffer,1024)
		if(error = 12003){
			VarSetCapacity(ErrorMsg,4),DllCall("wininet\InternetGetLastResponseInfo","UIntP",&ErrorMsg,"PTR",&buffer,"UIntP",&size)
			return StrGet(&buffer,size)
		}
		DllCall("FormatMessage","UInt",0x00000800,"PTR",this.library,"UInt",error,"UInt",0,"Str",buffer,"UInt",size,"PTR",0)
		return buffer
	}
}
Text(text){
	return RegExReplace(text,"\x7f","`r`n")
}
Class Icon_Browser{
	static start:="",window:=[],keep:=[],newwin,caller
	__New(id,barid,desc:="",ofile:="Shell32.dll",oicon:=0,return:=0,ahwnd:=""){
		win:=85,this.barid:=toolbar.list[barid].ahkid,newwin:=new GUIKeep(win),newwin.Add("Text,,Editing icon for: " info.desc,"ListView,w500 h300 hwndlv gselect vselect AltSubmit Icon -Multi,Small,wh","Button,xm gloadfile,Load File (Icon/DLL/Image),y","Button,x+10 gloaddefault,Load Default Icons,y","Button,x+10 gibc,Cancel,y"),newwin.Show("Select Icon"),this.file:=(ic:=settings.ssn("//icons/@last").text)?ic:"shell32.dll",this.file:=InStr(this.file,".ahk")?A_AhkPath:this.file,this.win:=win,icon_browser.keep:=this,this.newwin:=newwin,this.listview:=newwin.ctrl.select,this.id:=id,this.tb:=toolbar.list[barid],this.ofile:=ofile,this.oicon:=oicon,this.return:=return,this.populate(),this.ahwnd:=ahwnd
		return
		85GuiEscape:
		85GuiClose:
		this:=icon_browser.keep,hwnd({rem:85})
		if(hh:=this.ahwnd)
			WinActivate,% "ahk_id" hh
		if(this.return)
			this.return.call(this.exitgui:=1)
		return
		ibc:
		this:=icon_browser.keep,this.number:=this.oicon,this.file:=this.ofile
		SetTimer,Select1,-1
		Sleep,300
		goto,85GuiEscape
		return
		loaddefault:
		this:=icon_browser.keep,this.file:="shell32.dll",this.start:=0,this.populate(),settings.add("icons",{"last":this.file})
		return
	}select(num:=""){
		select:
		if(A_GuiEvent!="I")
			return
		Gui,85:Default
		this:=icon_browser.keep,number:=LV_GetNext()
		if(!number)
			return
		Select1:
		number:=number?number:this.number,number:=num="image"?0:number
		if(this.return)
			return this.return.call(this.file,this.number:=number)
		NumPut(VarSetCapacity(button,32),button,0),NumPut(0x1|0x20,button,4),NumPut(this.id,button,8)
		num:=this.tb.iconlist[this.file,number]!=""?this.tb.iconlist[this.file,number]:IL_Add(this.tb.imagelist,this.file,number)-1,this.tb.iconlist[this.file,number]:=num,NumPut(num,button,12)
		SendMessage,0x400+64,% this.id,&button,,% this.tb.ahkid
		btn:=settings.ssn("//toolbar/bar[@id='" this.tb.id "']/button[@id='" this.id "']"),btn.setattribute("icon",number-1),btn.setattribute("file",this.file),number:=""
		if(this.close)
			hwnd({rem:85})
		if(this.focus)
			WinActivate,% this.focus
		return
	}load(filename:=""){
		loadfile:
		this:=icon_browser.keep
		if(!filename){
			FileSelectFile,filename,,,,*.exe;*.dll;*.png;*.jpg;*.gif;*.bmp;*.icl;*.ico
			if(ErrorLevel)
				return
		}
		this.file:=filename
		if filename contains .gif,.jpg,.png,.bmp
			return this.select("image")
		this.populate(),settings.add("icons",{"last":filename}),filename:=""
		return
	}exit(){
		for win in icon_browser.window
			Gui,%win%:Destroy
	}populate(){
		GuiControl,85:-Redraw,SysListView321
		il:=IL_Create(50,10,1),LV_SetImageList(il)
		while,icon:=IL_Add(il,this.file,A_Index)
			LV_Add("Icon" icon)
		SendMessage,0x1000+53,0,(47<<16)|(47&0xffff),,% "ahk_id" this.listview
		GuiControl,85:+Redraw,SysListView321
	}
}
Class Omni_Search_Class{
	static prefix:={"@":"Menu","^":"File",":":"Label","(":"Function","{":"Class","[":"Method","&":"Hotkey","+":"Function","#":"Bookmark",".":"Property","%":"Variable","<":"Instance","*":"Breakpoint"}
	static iprefix:={Menu:"@",File:"^",Label:":",Function:"(",Class:"{",Method:"[",Hotkey:"&",Bookmark:"#",Property:".",Variable:"%",Instance:"<",Breakpoint:"*"}
	__New(){
		this.menus()
		return this
	}
	Menus(){
		rem:=cexml.ssn("//menu"),rem.ParentNode.RemoveChild(rem),this.menulist:=[],list:=menus.sn("//menu"),top:=cexml.Add("menu")
		while,mm:=list.item[A_Index-1],ea:=xml.ea(mm){
			clean:=ea.clean,hotkey:=convert_hotkey(ea.hotkey)
			StringReplace,clean,clean,_,%A_Space%,All
			launch:=IsFunc(ea.clean)?"func":IsLabel(ea.clean)?"label":""
			if(launch=""&&ea.plugin="")
				Continue
			cexml.under(top,"item",{launch:launch?launch:ea.plugin,text:clean,type:"Menu",sort:clean,additional1:hotkey,order:"text,type,additional1"})
		}
	}
}
Class PluginClass{
	__New(){
		return this
	}file(){
		return A_ScriptFullPath
	}path(){
		return A_ScriptDir
	}SetTimer(timer,period:=-10){
		if(!IsFunc(timer)&&!IsLabel(timer))
			return
		period:=period>0?-period:period
		SetTimer,%timer%,%period%
	}debugwindow(){
		v.debug:=new s(1,{pos:"w200 h200"}),Resize("rebar")
	}AutoClose(script){
		if(!this.Close[script])
			this.Close[script]:=1
	}Color(con){
		v.con:=con
		SetTimer,Color,-1
		Sleep,10
		v.con:=""
	}Focus(){
		ControlFocus,Scintilla1,% hwnd([1])
		GuiControl,+Redraw,Scintilla1
		Gui,1:Default
		Gui,1:TreeView,SysTreeView321
		setpos(TV_GetSelection()),csc(1)
	}update(filename,text){
		update({file:filename,text:text})
	}Show(){
		sc:=csc()
		WinActivate,% hwnd([1])
		GuiControl,+Redraw,% sc.sc
		setpos(sc.2357),sc.2400
	}Style(){
		return ea:=settings.ea(settings.ssn("//fonts/font[@style='5']")),ea.color:=RGB(ea.color),ea.Background:=RGB(ea.Background)
	}TrayTip(info){
		TrayTip,AHK Studio,%info%,2
	}csc(obj,hwnd){
		csc({plugin:obj,hwnd:hwnd})
	}MoveStudio(){
		Version:="1.002.20"
		SplitPath,A_ScriptFullPath,,,,name
		FileMove,%A_ScriptFullPath%,%name%-%version%.ahk,1
	}version(){
		Version:="1.002.20"
		return version
	}EnableSC(x:=0){
		sc:=csc()
		if(x){
			GuiControl,1:+Redraw,% sc.sc
			GuiControl,1:+gnotify,% sc.sc
		}else{
			;GuiControl,1:-Redraw,% sc.sc
			GuiControl,1:+g,% sc.sc
	}}Publish(info:=0){
		return,Publish(info)
	}Hotkey(win:=1,key:="",label:="",on:=1){
		if(!(win,key,label))
			return m("Unable to set hotkey")
		Hotkey,IfWinActive,% hwnd([win])
		Hotkey,%key%,%label%,% _:=on?"On":"Off"
	}save(){
		save()
	}sc(){
		return csc()
	}hwnd(win:=1){
		return hwnd(win)
	}get(name){
		return _:=%name%
	}tv(tv){
		return tv(tv)
	}Current(x:=""){
		return current(x)
	}m(info*){
		m(info*)
	}allctrl(code,lp,wp){
		for a,b in s.ctrl
			b[code](lp,wp)
	}DynaRun(script){
		return DynaRun(script)
	}activate(){
		WinActivate,% hwnd([1])
	}call(info*){
		;this can cause major errors
		if(IsFunc(info.1)&&info.1~="i)(Fix_Indent|newindent)"=0){
			func:=info.1,info.Remove(1)
			return %func%(info*)
		}
		SetTimer,% info.1,-100
	}Plugin(action,hwnd){
		SetTimer,%action%,-10
	}open(info){
		tv:=open(info),tv(tv)
		WinActivate,% hwnd([1])
	}GuiControl(info*){
		GuiControl,% info.1,% info.2,% info.3
	}ssn(node,path){
		return node.SelectSingleNode(path)
	}__Call(x*){
		m(x)
	}__Delete(){
		;m("ok")
	}StudioPath(){
		return A_ScriptFullPath
	}files(){
		return update("get").1
	}SetText(contents){
		length:=VarSetCapacity(text,strput(contents,"utf-8")),StrPut(contents,&text,length,"utf-8"),csc().2181(0,&text)
	}ReplaceSelected(text){
		csc().2170(0,&text:=encode(text))
	}calltip(text){
		sc:=csc(),sc.2200(sc.2128(sc.2166(sc.2008)),text)
	}InsertText(text){
		sc:=csc(),sc.2003(sc.2008,&text:=encode(text))
	}
}
class rebar{
	static hw:=[],keep:=[]
	__New(win=1,hwnd="",special=""){
		static id:=0
		id:=hwnd.id?hwnd.id:++id,this.id:=id,code:=0x10000000|0x40000000|0x200|0x400|0x8000|0x2000|0x40
		Gui,%win%:Add,custom,ClassReBarWindow32 hwndrhwnd w500 h400 +%code% Background0 grebar
		this.hwnd:=rhwnd,this.count:=count,this.keep[rhwnd]:=this,this.ahkid:="ahk_id" rhwnd,v.rebarahkid:=this.ahkid,this.parent:=hwnd
		Loop,2
			SendMessage,0x400+19,0,0xff0000,,% this.ahkid
		rebar.hw.insert(this)
	}
	hide(id){
		if(!this.ahkid)
			this:=rebar.hw.1
		SendMessage,0x400+16,id,0,,% this.ahkid ;RB_IDTOINDEX
		SendMessage,0x400+35,%errorlevel%,0,,% this.ahkid ;RB_SHOWBAND
	}
	show(id){
		if(!this.ahkid)
			this:=rebar.hw.1
		SendMessage,0x400+16,id,0,,% this.ahkid ;RB_IDTOINDEX
		SendMessage,0x400+35,%errorlevel%,1,,% this.ahkid ;RB_SHOWBAND
	}
	delete(id){
		if(!this.ahkid)
			this:=rebar.hw.1
		SendMessage,0x400+16,%id%,0,,% this.ahkid
		SendMessage,0x400+2,%ErrorLevel%,0,,% this.ahkid
	}
	add(gui,style="",mask=132){
		static id:=10000,struct:={hwnd:32,height:40,width:44,id:52,max:60,int:64,ideal:68}
		mask|=0x20|0x100|0x2|0x10|0x200|0x40|0x08|0x1|0x4|0x80
		style|=0x4|0x200|0x80
		if(gui.max)
			style|=0x40
		VarSetCapacity(BAND,80,0)
		if(gui.label)
			VarSetCapacity(BText,StrLen(gui.label)*2),StrPut(gui.label,&BText,"utf-8")
		win:=gui.win?gui.win:1
		NumPut(225525,band,12)
		if(hwnd:=toolbar.list[gui.id].hwnd)
			gui.hwnd:=hwnd
		if(hh:=toolbar.list[gui.id].barinfo().height)
			gui.height:=hh
		if(gui.nodename){
			att:=sn(gui,"@*")
			while,aa:=att.item[A_Index-1]{
				if(struct[aa.nodename])
					NumPut(aa.text,band,struct[aa.nodename])
			}
			if(hwnd:=toolbar.list[ssn(gui,"@id").text].hwnd)
				NumPut(hwnd,band,32)
			if(hh:=toolbar.list[ssn(gui,"@id").text].barinfo().height)
				NumPut(hh,band,40)
			NumPut(400,band,44),NumPut(400,band,68)
		}else
			for a,b in gui{
				if(struct[a])
					NumPut(b,band,struct[a])
			}
		for a,b in {0:80,4:mask,8:style,20:&BText}
			if(b)
				NumPut(b,band,a)
		SendMessage,0x400+1,-1,&BAND,,% "ahk_id" this.hwnd
	}
	getpos(hwnd){
		ControlGetPos,x,y,w,h,,ahk_id%hwnd%
		return {x:x,y:y,w:w,h:h}
	}
	save(){
		lasttop:=0
		for a,b in rebar.hw{
			vis:=settings.sn("//rebar/band/@vis"),top:=settings.ssn("//rebar")
			while,vv:=vis.item[A_Index-1]
				vv.text:=0
			newline:=sn(top,"newline")
			while,new:=newline.item[A_Index-1]
				new.parentnode.removechild(new)
			SendMessage,0x400+12,0,0,,% b.ahkid ;RB_GETBANDCOUNT
			Loop,%ErrorLevel%{
				NumPut(VarSetCapacity(band,80),&band,0),NumPut(0x141,&band,4) ;get the width and id of the band
				SendMessage,0x400+28,% A_Index-1,&band,,% b.ahkid ;RB_GETBANDINFOW
				id:=NumGet(&band,52),VarSetCapacity(rect,16)
				SendMessage,0x400+9,% A_Index-1,&rect,,% b.ahkid ;RB_GETRECT
				y:=NumGet(rect,4),width:=NumGet(rect,8)-NumGet(rect,0)
				if(y>lasttop)
					settings.under(top,"newline",{vis:1})
				lasttop:=y,next:=settings.ssn("//rebar/band[@id='" id "']"),next.SetAttribute("width",width),next.setattribute("vis",NumGet(&band,8)&0x8?0:1),next.parentnode.appendchild(next)
			}
		}
	}
	notify(){
		rebar:
		code:=NumGet(A_EventInfo,8,"int"),this:=rebar.keep[NumGet(A_EventInfo)]
		if(code=-841)
			m("Chevron Pushed")
		if(code=-831&&NumGet(A_EventInfo)=this.hwnd){
			Resize("rebar")
			GuiControl,1:+Redraw,SysTreeView321
		}
		if(code=-841){
			NumPut(VarSetCapacity(band,80),band,0),NumPut(0x10,band,4),bd:=NumGet(A_EventInfo+12)
			SendMessage,0x400+28,%bd%,&band,,% this.ahkid
			childwindowhwnd:=NumGet(band,32)
		}
		return
	}
}
class s{
	static ctrl:=[],main:=[],temp:=[]
	__New(window,info){
		static int,count:=1
		if(!init)
			DllCall("LoadLibrary","str","scilexer.dll"),init:=1
		win:=window?window:1,pos:=info.pos?info.pos:"x0 y0"
		if(info.hide)
			pos.=" Hide"
		notify:=info.label?info.label:"notify"
		Gui,%win%:Add,custom,classScintilla hwndsc w500 h400 %pos% +1387331584 g%notify%
		this.sc:=sc,s.ctrl[sc]:=this
		for a,b in {fn:2184,ptr:2185}
			this[a]:=DllCall("SendMessageA",UInt,sc,int,b,int,0,int,0)
		v.focus:=sc,this.2660(1)
		for a,b in [[2563,1],[2565,1],[2614,1],[2124,1],[2402,0x1|0x4,120]]
			this[b.1](b.2,b.3?b.3:0)
		if(info.main)
			s.main.push(this)
		if(info.temp)
			s.temp.push(this)
		this.2246(2,1),this.2052(32,0),this.2051(32,0xaaaaaa),this.2050,this.2052(33,0x222222),this.2069(0xAAAAAA),this.2601(0xaa88aa),this.2563(1),this.2614(1),this.2565(1),this.2660(1),this.2036(width:=settings.ssn("//tab").text?settings.ssn("//tab").text:5),this.2124(1),this.2260(1),this.2122(5),this.2056(38,"Consolas"),this.2516(1),color(this)
		this.2359(0x1|0x2|0x10|0x400),this.2663(4),this.2277(0)
		return this
	}
	clear(){
		for a,b in s.temp
			DllCall("DestroyWindow",uptr,b.sc)
		s.temp:=[]
	}
	delete(x*){
		this:=x.1
		if(s.main.MaxIndex()=1)
			return m("Can not delete the last control")
		for a,b in s.main
			if(b.sc=this.sc)
				s.main.Remove(a),DllCall("DestroyWindow",uptr,b.sc),Resize("rebar")
		csc("Scintilla1").2400,Resize()
	}
	__Get(x*){
		return DllCall(this.fn,"Ptr",this.ptr,"UInt",x.1,int,0,int,0,"Cdecl")
	}
	__Call(code,lparam=0,wparam=0,extra=""){
		if(code="enable"){
			if(lparam){
				GuiControl,1:+Redraw,% this.sc
				GuiControl,1:+gnotify,% this.sc
			}else{
				GuiControl,1:-Redraw,% this.sc
				GuiControl,1:+g,% this.sc
			}
		}
		if(code="getword"){
			sc:=csc(),cpos:=lparam?lparam:sc.2008
			return sc.textrange(sc.2266(cpos,1),sc.2267(cpos,1))
		}
		if(code="getseltext"){
			VarSetCapacity(text,this.2161),length:=this.2161(0,&text)
			return StrGet(&text,length,"UTF-8")
		}
		if(code="textrange"){
			cap:=VarSetCapacity(text,abs(lparam-wparam)),VarSetCapacity(textrange,12,0),NumPut(lparam,textrange,0),NumPut(wparam,textrange,4),NumPut(&text,textrange,8)
			this.2162(0,&textrange)
			return strget(&text,cap,"UTF-8")
		}
		if(code="getline"){
			length:=this.2350(lparam),cap:=VarSetCapacity(text,length,0),this.2153(lparam,&text)
			return StrGet(&text,length,"UTF-8")
		}
		if(code="gettext"){
			cap:=VarSetCapacity(text,vv:=this.2182),this.2182(vv,&text),t:=strget(&text,vv,"UTF-8")
			return t
		}
		if(code="getuni"){
			cap:=VarSetCapacity(text,vv:=this.2182),this.2182(vv,&text),t:=StrGet(&text,vv,"UTF-8")
			return t
		}
		wp:=(wparam+0)!=""?"Int":"AStr",lp:=(lparam+0)!=""?"Int":"AStr"
		if(wparam.1)
			wp:="AStr",wparam:=wparam.1
		wparam:=wparam=""?0:wparam,lparam:=lparam=""?0:lparam
		if(wparam=""||lparam="")
			return
		info:=DllCall(this.fn,"Ptr",this.ptr,"UInt",code,lp,lparam,wp,wparam,"Cdecl")
		return info
	}
	show(){
		m("here")
		GuiControl,+Show,% this.sc
	}
}
class toolbar{
	static keep:=[],order:=[],list:=[],imagelist:="",toolbar1,toolbar2,toolbar3,fun
	__New(win,parent,id,mask=""){
		static count:=0
		static
		count++
		;mask:=mask?mask:0x0040|0x10|0x0008|0x800|0x0004|0x20
		mask:=mask?mask:0x100|0x0040|0x10|0x0008|0x800|0x0004|0x20
		Gui,%win%:Default
		Gui,%win%:Add,Custom,ClassToolbarWindow32 hwndhwnd +%mask% gtoolbar vtoolbar%count%
		this.iconlist:=[],this.hwnd:=hwnd,this.count:=count,this.buttons:=[],this.returnbutton:=[],this.keep[hwnd]:=this,this.ahkid:="ahk_id" hwnd,this.parent:=parent,this.order[count]:=this,this.imagelist:=IL_Create(20,1,settings.ssn("//options/@Small_Icons").text?0:1),this.SetImageList(),this.list[id]:=this,this.id:=id,this.setmaxtextrows()
		return this
	}
	setstate(button,state){
		SendMessage,0x400+17,button,0<<16|state&0xffff,,% this.ahkid
	}
	SetImageList(){
		SendMessage,0x400+48,0,% this.imagelist,,% "ahk_id " this.hwnd
	}
	il(icon="",file=""){
		if(icon!=""){
			if(this.iconlist[file,icon]!="")
				return this.iconlist[file,icon]
			if file contains .gif,.jpg,.png,.bmp
				index:=IL_Add(this.imagelist,file)-1
			else
				index:=IL_Add(this.imagelist,file,icon+1)-1
			this.iconlist[file,icon+1]:=index
			return index
		}
	}
	add(info){
		new:=[]
		if(info.text){
			VarSetCapacity(STR,StrLen(info.text)*2)
			StrPut(info.text,&STR,strlen(info.text)*2)
			SendMessage,0x400+77,0,&STR,,% "ahk_id " this.Hwnd
			Index:=ErrorLevel
		}
		iimage:=this.il(info.icon,info.file),this.buttons[info.id]:={icon:iimage,state:info.state,text:info.text,index:index,func:info.func,iimage:info.icon,file:info.file,id:info.id,runfile:info.runfile},this.returnbutton.Insert(this.buttons[info.id])
	}
	addbutton(id){
		VarSetCapacity(button,20,0)
		info:=this.buttons[id]
		if(!info.id){
			NumPut(1,button,9)
			SendMessage,1044,1,&button,,% "ahk_id" this.hwnd
			return
		}
		if(IsFunc(info.func)=0&&IsLabel(info.func)=0&&FileExist(menus.ssn("//*[@clean='" info.func "']/@plugin").text)="")
			return
		NumPut(info.icon,Button,0,"int"),NumPut(info.id,Button,4,"int"),NumPut(info.state,button,8,"char"),NumPut(info.style,button,9,"char"),NumPut(info.Index,button,8+(A_PtrSize*2),"ptr")
		SendMessage,1044,1,&button,,% "ahk_id" this.hwnd ;TB_ADDBUTTONSW
	}
	SetMaxTextRows(MaxRows=0){
		SendMessage,0x043C,MaxRows, 0,, % "ahk_id " this.Hwnd
		return (ErrorLevel="FAIL")?False:True
	}
	Customize(){
		SendMessage,0x041B, 0, 0,, % "ahk_id " this.Hwnd
		return (ErrorLevel="FAIL")?False:True
	}
	barinfo(){
		VarSetCapacity(size,8),VarSetCapacity(rect,16)
		WinGetPos,,,w,,% "ahk_id" this.hwnd
		SendMessage,0x400+29,0,&rect,,% "ahk_id" this.hwnd
		height:=NumGet(rect,12)
		SendMessage,0x400+99,0,&size,,% "ahk_id" this.hwnd ;TB_GETIDEALSIZE
		ideal:=NumGet(&size)
		return info:={ideal:ideal,id:this.id,height:height,hwnd:this.hwnd,width:ideal+20}
	}
	ideal(){
		VarSetCapacity(size,8)
		SendMessage,0x400+99,0,&size,,% "ahk_id" this.hwnd ;TB_GETIDEALSIZE
		parent:=DllCall("GetParent","uptr",this.hwnd),parent:="ahk_id" parent
		NumPut(VarSetCapacity(band,80),&band,0),NumPut(0x200|0x40,band,4)
		SendMessage,0x400+16,% this.id,0,,% parent
		bandnum:=ErrorLevel
		SendMessage,0x400+28,%bandnum%,&band,,% parent ;getbandinfo
		NumPut(0x200|0x40,band,4),NumPut(NumGet(&size),&band,68),NumPut(NumGet(&size)+20,&band,44)
		SendMessage,0x400+11,%bandnum%,&band,,% parent ;setbandinfow
	}
	delete(button){
		rem:=settings.ssn("//toolbar/bar[@id='" this.id "']/button[@id='" button.id "']"),rem.ParentNode.RemoveChild(rem)
		SendMessage,0x400+25,% button.id,0,,% this.ahkid
		SendMessage,0x400+22,%ErrorLevel%,0,,% this.ahkid
		this.buttons[button.id]:=""
	}
	notification(){
		toolbar:
		code:=NumGet(A_EventInfo+8,0,"Int"),Hwnd:=NumGet(A_EventInfo),this:=toolbar.keep[hwnd]
		if(code=-12)
			return 1
		if(Hwnd!=this.Hwnd)
			return 0
		if(code=-713){
			Sleep,5
			return 1
		}
		if code not in -5,-708,-720,-723,-706,-707,-20
		{
			Sleep,10
			return 0
		}
		if(code=-5){ ;right click
			if(GetKeyState("Ctrl","P")&&this.id!=10002)
				this.delete(this.buttons[NumGet(A_EventInfo+12)])
			else
				this.customize()
		}
		if(code=-20){ ;left click
			button:=this.buttons[NumGet(A_EventInfo+12)]
			if(GetKeyState("Alt","P")&&GetKeyState("Ctrl","P")){
				removeid:=this.id
				if(removeid=10000||removeid=10001)
					return m("Can not remove original toolbars only ones you create")
				if(removeid=10002)
					return m("Can not delete the Debug Toolbar")
				if(removeid=11000)
					return m("Quick Find must stay")
				MsgBox,308,Remove This Toolbar,This Can NOT be undone.  Are you sure?
				IfMsgBox,Yes
				{
					rebar.hw.1.hide(removeid)
					for a,b in [settings.ssn("//rebar/band[@id='" removeid "']"),settings.ssn("//toolbar/bar[@id='" removeid "']")]
						if(b.xml)
							b.ParentNode.RemoveChild(b)
				}
				return
			}
			if(GetKeyState("Ctrl","P")&&button)
				new icon_browser(NumGet(A_EventInfo+12),this.id,button.file,button.iimage)
			else if(!button.runfile){
				func:=button.func
				if(IsFunc(func))
					%func%()
				else if(IsLabel(func))
					SetTimer,%func%,-10
				else if(FileExist((plugin:=menus.ssn("//*[@clean='" func "']/@plugin").text))){
					info:=menus.ea("//*[@clean='" func "']")
					Run,% Chr(34) info.plugin Chr(34) " " Chr(34) info.option Chr(34)
				}
				return 1
			}
			else if(button.runfile)
				return runfile(button.runfile)
			return 0
		} 
		if(code=-708) ;toolbar change
			this.ideal()
		if(code=-720){
			if(info:=this.returnbutton[NumGet(A_EventInfo+12)+1]){
				for a,b in [[info.icon,0,"int"],[info.id,4,"int"],[info.state,8,"char"],[info.style,9,"char"],[info.index,16,"int"]]
					NumPut(b.1,A_EventInfo+16,b.2,b.3)
				PostMessage,1,,,,% "ahk_id" this.parent
			}
		}
		if(code=-723) ;TBN_INITCUSTOMIZE
			PostMessage,1,,,,% "ahk_id" this.parent
		if(code=-706) ;TBN_QUERYINSERT
			PostMessage,1,,,,% "ahk_id" this.parent
		if(code=-707) ;TBN_QUERYDELETE
			PostMessage,1,,,,% "ahk_id" this.parent
		return 1
	}
	save(){
		VarSetCapacity(button)
		vis:=settings.sn("//toolbar/*/*/@vis")
		while,vv:=vis.item[A_Index-1]
			vv.text:=0
		sep:=settings.sn("//toolbar/*/separator")
		while,vv:=sep.item[A_Index-1]
			vv.parentnode.removechild(vv)
		for Control,this in this.order{
			top:=settings.ssn("//toolbar")
			SendMessage,0x400+24,0,0,,% this.ahkid ;TB_BUTTONCOUNT
			Loop,%ErrorLevel%{
				VarSetCapacity(button,80)
				SendMessage,0x400+23,% A_Index-1,&button,,% this.ahkid ;TB_GETBUTTON
				if(NumGet(&button,4)=0){
					bar:=ssn(top,"bar[@id='" this.id "']"),new:=settings.under(bar,"separator",{vis:1},1)
					continue
				}
				id:=NumGet(&button,4),next:=ssn(top,"bar[@id='" this.id "']/button[@id='" id "']"),next.setattribute("vis",1),next.parentnode.appendchild(next)
			}
		}
	}
}
Class XML{
	keep:=[]
	__New(param*){
		if(!FileExist(A_ScriptDir "\lib"))
			FileCreateDir,%A_ScriptDir%\lib
		root:=param.1,file:=param.2
		file:=file?file:root ".xml"
		temp:=ComObjCreate("MSXML2.DOMDocument"),temp.setProperty("SelectionLanguage","XPath")
		this.xml:=temp
		if(FileExist(file)){
			FileRead,info,%file%
			if(info=""){
				this.xml:=this.CreateElement(temp,root)
				FileDelete,%file%
			}else
				temp.loadxml(info),this.xml:=temp
		}else
			this.xml:=this.CreateElement(temp,root)
		this.file:=file
		xml.keep[root]:=this
	}
	CreateElement(doc,root){
		return doc.AppendChild(this.xml.CreateElement(root)).parentnode
	}
	search(node,find,return=""){
		found:=this.xml.SelectNodes(node "[contains(.,'" RegExReplace(find,"&","')][contains(.,'") "')]")
		while,ff:=found.item(a_index-1)
			if(ff.text=find){
				if(return)
					return ff.SelectSingleNode("../" return)
				return ff.SelectSingleNode("..")
			}
	}
	lang(info){
		info:=info=""?"XPath":"XSLPattern"
		this.xml.temp.setProperty("SelectionLanguage",info)
	}
	add(path,att:="",text:="",dup:=0,list:=""){
		p:="/",dup1:=this.ssn("//" path)?1:0,next:=this.ssn("//" path),last:=SubStr(path,InStr(path,"/",0,0)+1)
		if(!next.xml){
			next:=this.ssn("//*")
			Loop,Parse,path,/
				last:=A_LoopField,p.="/" last,next:=this.ssn(p)?this.ssn(p):next.appendchild(this.xml.CreateElement(last))
		}
		if(dup&&dup1)
			next:=next.parentnode.appendchild(this.xml.CreateElement(last))
		for a,b in att
			next.SetAttribute(a,b)
		for a,b in StrSplit(list,",")
			next.SetAttribute(b,att[b])
		if(text!="")
			next.text:=text
		return next
	}
	find(info*){
		doc:=info.1.NodeName?info.1:this.xml
		if(info.1.NodeName)
			node:=info.2,find:=info.3
		else
			node:=info.1,find:=info.2
		if(InStr(find,"'"))
			return doc.SelectSingleNode(node "[.=concat('" RegExReplace(find,"'","'," Chr(34) "'" Chr(34) ",'") "')]/..")
		else
			return doc.SelectSingleNode(node "[.='" find "']/..")
	}
	under(under,node:="",att:="",text:="",list:=""){
		if(node="")
			node:=under.node,att:=under.att,list:=under.list,under:=under.under
		new:=under.appendchild(this.xml.createelement(node))
		for a,b in att
			new.SetAttribute(a,b)
		for a,b in StrSplit(list,",")
			new.SetAttribute(b,att[b])
		if(text)
			new.text:=text
		return new
	}
	ssn(path){
		return this.xml.SelectSingleNode(path)
	}
	sn(path){
		return this.xml.SelectNodes(path)
	}
	__Get(x=""){
		return this.xml.xml
	}
	Get(path,Default){
		return value:=this.ssn(path).text!=""?this.ssn(path).text:Default
	}
	transform(){
		static
		if(!IsObject(xsl)){
			xsl:=ComObjCreate("MSXML2.DOMDocument")
			style=<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">`n<xsl:output method="xml" indent="yes" encoding="UTF-8"/>`n<xsl:template match="@*|node()">`n<xsl:copy>`n<xsl:apply-templates select="@*|node()"/>`n<xsl:for-each select="@*">`n<xsl:text></xsl:text>`n</xsl:for-each>`n</xsl:copy>`n</xsl:template>`n</xsl:stylesheet>
			xsl.loadXML(style),style:=null
		}
		this.xml.transformNodeToObject(xsl,this.xml)
	}
	save(x*){
		if(x.1=1)
			this.Transform()
		filename:=this.file?this.file:x.1.1,encoding:=ffff.pos=3?"UTF-8":ffff.pos=2?"UTF-16":"CP0" ;,enc:=RegExMatch(this[],"[^\x00-\x7F]")?"utf-16":"utf-8"
		;if(encoding!=enc)
		;	FileDelete,%filename%
		if(this.xml.SelectSingleNode("*").xml="")
			return m("Errors happened. Reverting to old version of the XML")
		ff:=FileOpen(filename,0,encoding),text:=ff.Read(ff.length),ff.Close()
		if(!this[])
			return m("Error saving the " this.file " xml.  Please get in touch with maestrith if this happens often")
		if(text!=this[])
			file:=FileOpen(filename,"rw",encoding),file.seek(0),file.write(this[]),file.length(file.position)
	}
	ea(path){
		list:=[]
		if(nodes:=path.nodename)
			nodes:=path.SelectNodes("@*")
		else if(path.text)
			nodes:=this.sn("//*[text()='" path.text "']/@*")
		else if(!IsObject(path))
			nodes:=this.sn(path "/@*")
		else
			for a,b in path
				nodes:=this.sn("//*[@" a "='" b "']/@*")
		while,n:=nodes.item(A_Index-1)
			list[n.nodename]:=n.text
		return list
	}
}
ssn(node,path){
	return node.SelectSingleNode(path)
}
sn(node,path){
	return node.SelectNodes(path)
}
Clean(clean,tab=""){
	if(tab)
		return RegExReplace(clean,"[^\w ]")
	clean:=RegExReplace(RegExReplace(clean,"&")," ","_")
	if(InStr(clean,"`t"))
		clean:=SubStr(clean,1,InStr(clean,"`t")-1)
	return clean
}
Clear_Line_Status(){
	sc:=csc()
	for a,b in s.main
		Loop,% b.2154
			b.2532(A_Index-1,33)
}
Close(x:=1,all:="",Redraw:=1){
	Save()
	Gui,1:Default
	Gui,1:TreeView,SysTreeView321
	GuiControl,1:-Redraw,SysTreeView321
	cfile:=(file:=ssn(x,"@file").text)?file:current(2).file
	all:=all?"/@file":"[@file='" cfile "']/@file",close:=files.sn("//main" all),up:=update("get")
	while,file:=close.item[A_Index-1],file:=file.text{
		rem:=cexml.ssn("//main[@file='" file "']"),rem.ParentNode.RemoveChild(rem),all:=files.sn("//main[@file='" file "']/descendant::file"),Previous_Scripts(file),rem:=settings.ssn("//open/file[text()='" file "']"),rem.ParentNode.RemoveChild(rem)
		while,aa:=all.item[A_Index-1],ea:=xml.ea(aa){
			if(A_Index>1)
				TV_Delete(ea.tv)
			up.1.Delete(ea.file),up.2.Delete(ea.file)
		}
		main:=all.item[0]
		TV_Delete(ssn(main,"@tv").text)
	}
	while,file:=close.item[A_Index-1],file:=file.text
		rem:=files.ssn("//main[@file='" file "']"),rem.ParentNode.RemoveChild(rem)
	if(Redraw)
		GuiControl,1:+Redraw,SysTreeView321
	if(!files.sn("//main").length)
		New(1)
	if(InStr(cfile,"untitled.ahk")){
		SplitPath,cfile,,dir
		FileRead,text,%cfile%
		if(Trim(text)="")
			FileRemoveDir,%dir%,1
	}
}
Close_All(){
	Close(1,1),New(1)
}
Color(con:=""){
	con:=con?con:v.con
	if(!con.sc)
		return v.con:=""
	static options:={show_eol:2356,Show_Caret_Line:2096}
	list:={Font:2056,Size:2055,Color:2051,Background:2052,Bold:2053,Italic:2054,Underline:2059},nodes:=settings.sn("//fonts/font")
	while,n:=nodes.item(A_Index-1){
		ea:=settings.ea(n)
		if(ea.code=2082){
			con.2082(7,ea.color)
			Continue
		}
		if(ea.style=33)
			for a,b in [2290,2291]
				con[b](1,ea.Background)
		ea.style:=ea.style=5?32:ea.style
		for a,b in ea{
			if(list[a]&&ea.style!="")
				con[list[a]](ea.style,b)
			if(ea.code&&ea.value)
				con[ea.code](ea.value)
			else if(ea.code&&ea.bool!=1)
				con[ea.code](ea.color,0)
			else if(ea.code&&ea.bool)
				con[ea.code](ea.bool,ea.color)
			if(ea.style=32)
				con.2050(),con.2052(30,0x0000ff),con.2052(31,0x00ff00),con.2052(48,0xff00ff)
		}
	}
	for a,b in [[2040,25,13],[2040,26,15],[2040,27,11],[2040,28,10],[2040,29,9],[2040,30,12],[2040,31,14],[2242,0,20],[2242,1,13],[2134,1],[2260,1],[2246,1,1],[2246,2,1],[2115,1],[2029,2],[2031,2],[2244,3,0xFE000000],[2080,7,6],[2240,3,0],[2242,3,15],[2244,3,0xFE000000],[2246,1,1],[2246,3,1],[2244,2,3],[2040,0,0],[2041,0,0],[2042,0,0xff],[2115,1],[2056,38,"Tahoma"],[2077,0,"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ#_1234567890"],[2041,1,0],[4006,0,"ahk"],[2042,1,0xff0000],[2040,2,22],[2042,2,0x444444],[2040,3,22],[2042,3,0x666666],[2040,4,31],[2042,4,0xff0000],[2037,65001],[2132,v.options.Hide_Indentation_Guides=1?0:1],[2040,1,0],[2042,1,0x0000ff]]
		con[b.1](b.2,b.3)
	if(!v.options.Disable_Word_Wrap_Indicators)
		con.2460(4)
	con.2472(2),con.2036(width:=settings.ssn("//tab").text?settings.ssn("//tab").text:5),con.2080(3,6),con.2082(3,0xFFFFFF)
	if(!settings.ssn("//fonts/font[@code='2082']"))
		con.2082(7,0xff00ff)
	if(!(settings.ssn("//fonts/font[@style='34']")))
		con.2498(1,7)
	con.2212(),con.2371,indic:=settings.sn("//fonts/indicator")
	while,in:=indic.item[A_Index-1],ea:=xml.ea(in)
		for a,b in ea
			if(ea.Background!="")
				con.2082(ea.indic,ea.Background)
	con.2080(2,8),con.2082(2,0xff00ff),con.2636(1)
	if(zoom:=settings.ssn("//gui/@zoom").text)
		con.2373(zoom)
	for a,b in options
		if(v.options[a])
			con[b](b)
	kwind:={Personal:0,indent:1,Directives:2,Commands:3,builtin:4,keywords:5,functions:6,flow:7,KeyNames:8}
	for a,b in v.color
		con.4005(kwind[a],RegExReplace(b,"#"))
	if(node:=settings.ssn("//fonts/fold")){
		ea:=xml.ea(node)
		Loop,7
			con.2041(24+A_Index,ea.color!=""?ea.color:"0"),con.2042(24+A_Index,ea.background!=""?ea.Background:"0xaaaaaa")
	}marginwidth()
}
Command_Help(){
	static stuff,hwnd,ifurl:={between:"commands/IfBetween.htm",in:"commands/IfIn.htm",contains:"commands/IfIn.htm",is:"commands/IfIs.htm"}
	sc:=csc(),info:=context(1),line:=sc.getline(sc.2166(sc.2008)),found1:=info.word
	RegRead,outdir,HKEY_LOCAL_MACHINE,SOFTWARE\AutoHotkey,InstallDir
	if(!outdir)
		SplitPath,A_AhkPath,,outdir
	if(!found1)
		RegExMatch(line,"[\s+]?(\w+)",found)
	if(InStr(commands.ssn("//Commands/Commands").text,found1)){
		url:="mk:@MSITStore:" outdir "/AutoHotkey.chm::/docs/"
		if(found1~="(FileExist|GetKeyState|InStr|SubStr|StrLen|StrSplit|WinActive|WinExist|Asc|Chr|GetKeyName|IsByRef|IsFunc|IsLabel|IsObject|NumGet|NumPut|StrGet|StrPut|RegisterCallback|Trim|Abs|Ceil|Exp|Floor|Log|Ln|Mod|Round|Sqrt|Sin|ASin|ACos|ATan)"){
			url.="Functions.htm#" found1
		}else if(found1~="i)^if"){
			if(found1~="i)\bIfEqual|IfNotEqual|IfLess|IfLessOrEqual|IfGreater|IfGreaterOrEqual\b")
				url.="commands/IfEqual.htm"
			else
				url.=ifurl[info.last]?ifurl[info.last]:"commands/IfExpression.htm"
		}Else{
			url.="commands/" found1:=RegExReplace(found1,"#","_") ".htm"
			if(InStr(stuff.document.body.innerhtml,"//ieframe.dll/dnserrordiagoff.htm#")){
				url.="Functions.htm#" found1
				if(found1="object")
					url.="Objects.htm#Usage_Associative_Arrays"
				Else if(found1="_ltrim")
					url.="Scripts.htm#LTrim"
				Else
					url.="Functions.htm#" found1
			}
		}
		if(WinExist("AutoHotkey Help ahk_class HH Parent")=0){
			Run,% outdir "\AutoHotkey.chm"
			WinWaitActive,AutoHotkey Help,,3
			Sleep,300
		}
		if(!help:=GetWebBrowser())
			return m("Please open the help file.")
		help.navigate(url)
		WinActivate,AutoHotkey Help ahk_class HH Parent
	}
	return
}
Compile_AHK_Studio(){
	if(StrSplit(A_ScriptFullPath,".").2="exe")
		return m("AHK Studio is already compiled.")
	SplitPath,A_ScriptFullPath,,,ext,nne
	SplitPath,A_AhkPath,file,dirr
	if(FileExist(A_ScriptDir "\" nne ".exe"))
		FileDelete,%A_ScriptDir%\%nne%.exe
	Loop,%A_ScriptDir%\*.ico
		icon:=A_LoopFileFullPath
	if(icon)
		add=/icon "%icon%"
	Loop,%dirr%\Ahk2Exe.exe,1,1
		file:=A_LoopFileFullPath
	SplashTextOn,200,50,Compiling,Please Wait...
	RunWait,%file% /in "%A_ScriptDir%\%nne%.ahk" /out "%A_ScriptDir%\%nne%.exe" %add% /bin "%dirr%\Compiler\Unicode 32-bit.bin"
	if(FileExist(A_ScriptDir "\" nne ".exe")){
		Run,%A_ScriptDir%\%nne%.exe
		FileMove,%A_ScriptFullPath%,%A_ScriptFullPath%.bak,1
		FileDelete,%A_ScriptFullPath%.bak
	}
	ExitApp
}
Download_AHK_Studio_Source(){
	if(StrSplit(A_ScriptFullPath,".").2="ahk")
		return m("The file is already on your system as " A_ScriptFullPath)
	file:=FileOpen(A_ScriptDir "\AHK-Studio.ahk","rw","UTF-8"),file.write(URLDownloadToVar("https://raw.githubusercontent.com/maestrith/AHK-Studio/master/AHK-Studio.ahk")),file.length(file.position),file.Close()
}
Compile(main=""){
	main:=ssn(current(1),"@file").Text,v.compiling:=1
	SplitPath,main,,dir,,name
	SplitPath,A_AhkPath,file,dirr
	Loop,%dirr%\Compile_AHK.exe,1,1
		compile:=A_LoopFileFullPath
	if(FileExist(compile)){
		run:=Current(2).file
		Run,%compile% "%run%"
		return
	}
	Loop,%dirr%\Ahk2Exe.exe,1,1
		file:=A_LoopFileFullPath
	if(!FileExist("temp"))
		FileCreateDir,temp
	FileDelete,temp\temp.upload
	FileAppend,% publish(1),temp\temp.upload
	SplashTextOn,200,100,Compiling,Please wait.
	Loop,%dir%\*.ico
		icon:=A_LoopFileFullPath
	if(icon)
		add=/icon "%icon%"
	RunWait,%file% /in "%A_ScriptDir%\temp\temp.upload" /out "%dir%\%name%.exe" %add%
	if(FileExist("upx.exe")){
		SplashTextOn,,50,Compressing EXE,Please wait...
		RunWait,upx.exe -9 "%dir%\%name%.exe",,Hide
	}
	FileDelete,temp\temp.upload
	SplashTextOff
	v.compiling:=0
}
CompileFont(XMLObject,rgb:=1){
	ea:=xml.ea(XMLObject),style:=[],name:=ea.name,styletext:="norm"
	for a,b in {bold:"",color:"c",italic:"",size:"s",strikeout:"",underline:""}{
		if(a="color")
			styletext.=" c" _:=rgb?rgb(ea[a]):ea[a]
		else if(ea[a])
			styletext.=" " _:=b?b ea[a]:a
	}
	return styletext
}
Connect(){
	
}
Context(return=""){
	static lasttip
	sc:=csc(),open:=cp:=sc.2008,line:=sc.2166(cp),start:=sc.2128(line),end:=sc.2136(line),synmatch:=[],startpos:=0
	if(sc.2102)
		return
	if(cp<=start)
		return
	found:=[]
	string:=sc.textrange(start,cp),pos:=1,sub:=cp-start,open:=sc.2008,commas:=0
	Loop{
		sc.2190(open),sc.2192(start),close:=sc.2197(1,")"),sc.2190(open),sc.2192(start),comma:=sc.2197(1,","),sc.2190(open),sc.2192(start),open:=sc.2197(1,"(")
		for a,b in {open:open,close:close,comma:comma}
			if(sc.2010(b)=3)
				%a%:=0
		if(comma>close&&comma>open){
			if(sc.2010(comma)~="\b97|4\b")
				commas++
			open:=comma
			Continue
		}
		if(close>open&&open>start){
			bm:=sc.2353(close),wb:=sc.2266(bm,1),string:=SubStr(string,1,wb-start) SubStr(string,close+2-start),open:=sc.2266(bm,1)
			Continue
		}
		if(open<start)
			break
		word:=sc.textrange(wb:=sc.2266(open,1),sc.2267(open,1)),wordstartpos:=wb
		if(word){
			if(sc.2007(wb-1)=46)
				pre:=sc.textrange(wordstartpos:=sc.2266(wb-1,1),sc.2267(wb-1,1))
			if(inst:=cexml.ssn("//main[@file='" current(2).file "']/descendant::*[@type='Instance' and @upper='" upper(pre) "']")){
				if(args:=cexml.ssn("//main[@file='" current(2).file "']/descendant::*[@type='Class' and @upper='" upper(xml.ea(inst).class) "']/descendant-or-self::*[@upper='" upper(word) "']/@args").text)
					synmatch.push(pre "." word "(" args ")"),startpos:=startpos=0?wordstartpos:startpos
			}if(fun:=cexml.ssn("//lib/descendant::info[@upper='" upper(word) "']")){
				synmatch.push(word "(" xml.ea(fun).args ")"),startpos:=startpos=0?wordstartpos:startpos,commas++
			}if(fun:=ssn(cexml.ssn("//main[@file='" current(2).file "']/descendant::*[@type='Function'][@upper='" upper(word) "']"),"@args").text){
				synmatch.push(word "("  fun  ")"),startpos:=startpos=0?wordstartpos:startpos,commas++
			}if((ea:=scintilla.ea("//scintilla/commands/item[@code='" word "']")).syntax)
				synmatch.push(pre "." word ea.syntax "`n" ea.name),startpos:=startpos=0?wordstartpos:startpos,commas++
			if(syn:=commands.ssn("//Commands/Commands/commands[text()='" v.kw[word] "']/@syntax").text)
				synmatch.push(word syn),startpos:=startpos=0?wordstartpos:startpos,commas+=SubStr(syn,1,1)="("?1:0
			if(startpos)
				break
		}
	}if(word=""||word="if"){
		RegExMatch(string,"O)^\s*\W*(\w+)",word),word:=v.kw[word.1]?v.kw[word.1]:word.1,startpos:=start,loopword:=word,loopstring:=string,build:=word
		if((list:=v.context[word])&&word!="if"){
			for a,b in StrSplit(string,","){
				if(RegExMatch(b,"Oi)\b(" list ")\b",found))
					RegExMatch(list,"Oi)\b(" found.1 ")\b",found),last:=found.1,build.=a_index=1?",":b ","
				else
					Break
			}
			if(top:=commands.ssn("//Context/" word)){
				list:=sn(top,"list"),find:="",build:=word ","
				while,ll:=list.item[A_Index-1],ea:=xml.ea(ll)
					find.=ea.list " "
				start:=sc.2128(line:=sc.2166(sc.2008)),end:=sc.2136(line)
				for a,b in StrSplit(Trim(find)," "){
					sc.2686(start,end),pos:=sc.2197(StrLen(b),b)
					if((sc.2010(pos)~="3")=0&&pos>0)
						last:=b,build.=b ","
				}
				if(syntax:=ssn(top,"syntax[contains(text(),'" last "')]/@syntax").text)
					synmatch.push(Trim(build,",") " " syntax)
			}
		}else if(word="if"){
			start:=sc.2128(line:=sc.2166(sc.2008)),end:=sc.2136(line)
			for a,b in ["contains","in","between","is"]{
				sc.2686(start,end),pos:=sc.2197(StrLen(b),b)
				if((sc.2010(pos)~="3")=0&&pos>0){
					last:=b
					break
			}}synmatch.push("if " commands.ssn("//Context/if/descendant-or-self::syntax[text()='" (last?last:"if") "']/@syntax").text)
		}else
			if(syntax:=commands.ssn("//Commands/commands[text()='#" word "' or text()='" word "']/@syntax").text)
				synmatch.push(word " " syntax)
	}if(wordstartpos-start>0)
		string:=LTrim(SubStr(string,wordstartpos-start),",")
	if(return)
		return {word:word,last:last}
	syntax:=""
	for a,b in synmatch{
		if(syntax~="\b\Q" b "\E"=0)
			syntax.=b "`n"
	}syntax:=Trim(syntax,"`n")
	if(!syntax)
		return
	synbak:=RegExReplace(syntax,"(\n.*)")
	RegExReplace(synbak:=RegExReplace(synbak,  "\(",",",,1),",","",count)
	syntax:=RegExReplace(syntax ,Chr(96) "n","`n")
	if(count=0||word="if")
		sc.2207(0xAAAAAA),sc.2200(startpos,syntax)
	else{
		ff:=RegExReplace(synbak,"\(",","),sc.2207(0xff0000),sc.2200(startpos,syntax)
		if(commas+1<=count)
			sc.2204(InStr(ff,",",0,1,commas),InStr(ff,",",0,1,commas+1)-1)
		if(commas>count){
			if(InStr(SubStr(synbak,InStr(ff,",",0,1,count)+1),"*"))
				commas:=1
			else
				sc.2204(0,StrLen(ff)),sc.2207(0x0000ff)
		}if(commas=count)
			end:=RegExMatch(syntax,"(\n|\]|\))"),end:=end?end-1:strlen(ff),sc.2204(InStr(ff,",",0,1,commas),end)
	}
	return
}
ContextMenu(){
	GuiContextMenu:
	ControlGetFocus,Focus,% hwnd([1])
	MouseGetPos,,,,ctl
	MouseGetPos,,,,control,2
	if(control=v.debug.sc){
		Menu,rcm,Add,Close,SciDebug
		Menu,rcm,Show
		Menu,rcm,Delete
		return
		SciDebug:
		if(A_ThisMenuItem="Close")
			stop()
		return
	}else if(InStr(ctl,"Scintilla")){
		for a,b in ["Undo","Redo","Copy","Cut","Paste","Select All","Close","Delete","","Open Folder","Bookmark Search","Class Search","Function Search","Hotkey Search","Instance Search","Menu Search","Method Search","Property Search","Search Label"]
			Menu,rcm,Add,%b%,SciRCM
		Menu,rcm,Show
		Menu,rcm,DeleteAll
		return
		SciRCM:
		item:=clean(A_ThisMenuItem)
		if(IsFunc(item))
			%item%()
		if(IsLabel(item))
			SetTimer,%item%,-1
		return
	}else if(ctl="Static1"||ctl="Edit1"){
		Menu,qfm,Add,% "Move to " (v.options.top_find?"Bottom":"Top"),Top_Find
		Menu,qfm,Show
		Menu,qfm,Delete
	}else if(Focus="SysTreeView322"){
		GuiControl,+g,SysTreeView322
		code_explorer.Refresh_Code_Explorer()
		GuiControl,+gcej,SysTreeView322
	}else if(Focus="SysTreeView321"){
		static info
		TV_GetText(text,A_EventInfo),info:=A_EventInfo
		main:=files.ssn("//*[@tv='" A_EventInfo "']/ancestor::main")
		type:=files.ssn("//*[@tv='" A_EventInfo "']")
		Menu,rcm,Add,%text%,deadend
		Menu,rcm,Disable,%text%
		Menu,rcm,Add
		if(type.nodename="folder"){
			for a,b in {Disable_Folders_In_Project_Explorer:"Disable Folders In Project Explorer",Folder_Icon:"Folder Icon"}
				Menu,rcm,Add,%b%,%a%
		}else
			for a,b in StrSplit("New Project,Close Project,Open,Rename,Remove Segment,Notes,,Copy File Path,Copy Folder Path,Open Folder,Width,Hide/Show Icons,File Icon",",")
				Menu,rcm,Add,%b%,rcm
		Menu,rcm,show
		Menu,rcm,DeleteAll
		Menu,rcm,Delete
		return
		Folder_Icon:
		TVIcons(2)
		return
		rcm:
		MouseGetPos,,,win
		if(win=v.debug.sc)
			return m("here")
		if(A_ThisMenuItem="close project")
			return Close(main)
		if(A_ThisMenuItem="Open")
			Open()
		else if(A_ThisMenuItem="Hide/Show Icons")
			top:=settings.add("icons/pe"),top.SetAttribute("show",_:=xml.ea(top).show?0:1),TVIcons()
		else if(A_ThisMenuItem~="Copy (File|Folder) Path"){
			pFile:=current(3).file
			SplitPath,pFile,,pFolder
			Clipboard:=InStr(A_ThisMenuItem,"Folder")?pFolder:pFile
		}else if(A_ThisMenuItem="Remove Segment")
			Remove_Segment()
		else if(A_ThisMenuItem="width")
			widths()
		else if(A_ThisMenuItem="Rename")
			Rename_Current_Segment(files.ssn("//*[@tv='" info "']")),info:=""
		else if(A_ThisMenuItem="File Icon")
			TVIcons(1)
		else if(A_ThisMenuItem="New Project")
			new()
		else if(A_ThisMenuItem="Open Folder")
			open_folder()
		else if(IsLabel(A_ThisMenuItem)||IsFunc(A_ThisMenuItem))
			SetTimer,%A_ThisMenuItem%,-10
		else
			m("Coming Soon....maybe")
		return
	}
	return
}
Convert_Hotkey(key){
	StringUpper,key,key
	for a,b in [{Shift:"+"},{Win:"#"},{Ctrl:"^"},{Alt:"!"}]
		for c,d in b
			key:=RegExReplace(key,"\" d,c "+")
	return key
}
Copy(){
	copy:
	ControlGetFocus,focus,% hwnd([1])
	if(!InStr(Focus,"scintilla")){
		SendMessage,0x301,0,0,%Focus%,% hwnd([1])
		return
	}
	sc:=csc()
	if(!sc.getseltext())
		sc.2455()
	else
		Clipboard:=sc.getseltext()
	Clipboard:=RegExReplace(Clipboard,"\n","`r`n")
	if(hwnd(30)){
		WinActivate,% hwnd([30])
		Sleep,50
		ControlGetFocus,focus,% hwnd([30])
		if(InStr(focus,"Edit"))
			ControlSetText,%focus%,%Clipboard%,% hwnd([30])
	}
	return
}
csc(set:=0){
	static current
	if(set.plugin)
		return current:=set.plugin
	if(set.hwnd)
		current:=s.ctrl[set.hwnd]
	if(set=1||!current.sc||InStr(set,"Scintilla")){
		ControlGet,hwnd,hwnd,,Scintilla1,% hwnd([1])
		current:=s.ctrl[hwnd]
		if(!current.sc)
			current:=s.main.1,current.2400()
	}
	return current
}
Current(parent=""){
	sc:=csc(),node:=files.ssn("//*[@sc='" sc.2357 "']")
	if(parent=1)
		return ssn(node,"ancestor-or-self::main")
	if(parent=2)
		return xml.ea(ssn(node,"ancestor-or-self::main"))
	if(parent=3)
		return xml.ea(node)
	return node
}
Custom_Version(){
	change:=settings.ssn("//auto_version").text?settings.ssn("//auto_version").text:"Version:=" Chr(34) "$v" Chr(34)
	cc:=InputBox(csc().sc,"Custom auto_version","Enter your custom" Chr(59) "auto_version in the form of Version:=$v",change)
	if(cc)
		settings.add("auto_version").text:=cc
}
Cut(){
	ControlGetFocus,Focus,% hwnd([1])
	SendMessage,0x300,0,0,%Focus%,% hwnd([1])
}
Debug_Settings(){
	static values:=["max_depth","max_children"],newwin
	newwin:=new GUIKeep("Debug_Settings"),ea:=settings.ea("//features")
	for a,b in values
		newwin.add("Text,xm y+3 Section," b ":"),newwin.Add("Edit,x+M ys-3 w100 v" b "," (ea[b]?ea[b]:0))
	newwin.Add("Button,xm gSave_Debug_Settings,Save Settings"),newwin.Show("Debug Settings")
	return
	Debug_SettingsGuiEscape:
	Save_Debug_Settings:
	Debug_SettingsGuiClose:
	top:=settings.add("features"),info:=newwin[]
	for a,b in values
		top.SetAttribute(b,info[b])
	newwin.Destroy()
	return
}
Default_Project_Folder(){
	FileSelectFolder,directory,,3,% "Current Default Folder: " settings.ssn("//directory").text
	if(ErrorLevel)
		return
	settings.add("directory","",directory)
}
Default(type:="TreeView",control:="SysTreeView321"){
	Gui,1:Default
	Gui,1:%type%,%control%
}
defaultfont(){
	temp:=new xml("temp")
	info=<fonts><author>joedf</author><name>PlasticCodeWrap</name><font background="0x1D160B" bold="0" color="0xF8F8F2" font="Consolas" size="10" style="5" italic="0" strikeout="0" underline="0"></font><font background="0x36342E" style="33" color="0xECEEEE"></font><font style="13" color="0x2929EF" background="0x1D160B" bold="0"></font><font style="3" color="0x39E455" bold="0"></font><font style="1" color="0xE09A1E" font="Consolas" italic="1" bold="0"></font><font style="2" color="0x833AFF" font="Consolas" italic="0" bold="0"></font><font style="4" color="0x00AAFF"></font><font style="15" background="0x272112" color="0x0080FF"></font><font style="18" color="0x00AAFF"></font><font style="19" background="0x272112" color="0x9A93EB" font="Consolas" italic="0"></font><font style="22" color="0x54B4FF"></font><font style="21" color="0x0080FF" italic="1"></font><font style="11" color="0xE09A1E" bold="0" font="Consolas" italic="1" size="10" strikeout="0" underline="0"></font><font style="17" color="0x00AAFF" italic="1"></font><font bool="1" code="2068" color="0x3D2E16"></font><font code="2069" color="0xFF8080"></font><font code="2098" color="0x583F11"></font><font style="20" color="0x0000FF" italic="1" background="0x272112"></font><font style="23" color="0x00AAFF" italic="1"></font><font style="24" color="0xFF00FF" background="0x272112"></font><font style="9" color="0x4B9AFB"></font><font style="8" color="0x00AAFF"></font><font style="10" color="0x2929EF"></font></fonts>
	top:=settings.ssn("//settings"),temp.xml.loadxml(info),temp.transform(2),tt:=temp.ssn("//*"),top.appendchild(tt)
}
Delete_Matching_Brace(){
	sc:=csc(),value:=[]
	for a,b in [v.braceend,v.bracestart]
		value[b]:=1
	max:=value.MaxIndex(),min:=value.MinIndex()
	if(v.braceend&&v.bracestart){
		sc.2078(),minline:=sc.2166(min),maxline:=sc.2166(max),sc.2645(max,1),sc.2645(min,1),max--,min--,maxtext:=sc.getline(sc.2166(max)),mintext:=sc.getline(sc.2166(min))
		for a,b in {mintext:mintext,maxtext:maxtext}
			%a%:=RegExReplace(RegExReplace(b,"(\t|\R|\s)*$"),"^(\t|\R|\s)*")
		if(maxtext="")
			sc.2645(start:=sc.2136(maxline-1),sc.2136(maxline)-start)
		if(mintext="")
			sc.2645(start:=sc.2136(minline-1),sc.2136(minline)-start)
		if(maxtext){
			sc.2190(sc.2128(maxline)),sc.2192(sc.2136(maxline)),sc.2194(StrLen(maxtext),maxtext)
			if(sc.2166(sc.2008)=maxline)
				sc.2025(sc.2136(maxline))
		}
		if(mintext){
			sc.2190(sc.2128(minline)),sc.2192(sc.2136(minline)),sc.2194(StrLen(mintext),mintext)
			if(sc.2166(sc.2008)=minline)
				sc.2025(sc.2136(minline))
		}
		if(v.options.full_auto)
			NewIndent()
		sc.2079()
	}
}
Delete_Project(x:=0){
	project:=current(2).file
	if(x=0)
		MsgBox,292,Are you sure?,This process can not be undone!`nDelete %project% and all its backups
	IfMsgBox,No
		return
	Close(0)
	if(v.options.Hide_Code_Explorer!=1)
		Code_Explorer.Refresh_Code_Explorer()
	SplitPath,project,,dir
	FileRecycle,%dir%
}
Display(type){
	code_explorer.scan(current()),all:=cexml.sn("//main[@file='" current(2).file "']/descendant::info[@type='" type "']/@text")
	sc:=csc(),word:=sc.getword(),sc.2634(1)
	while,aa:=all.item[A_Index-1]
		if(aa.text~="i)^" word)
			list.=aa.text " "
	Sort,list,list,D%A_Space%
	if(list="")
		return
	sc.2117(5,Trim(list))
	if(!InStr(Trim(List)," "))
		sc.2104
}
Display_Functions(){
	Display("Function")
}
Display_Classes(){
	Display("Class")
}
Donate(){
	donate:
	Run,http://www.maestrith.com/donations/
	return
}
Download_Plugins(){
	static plug
	if(!FileExist("plugins"))
		FileCreateDir,Plugins
	;DllCall("InetCpl.cpl\ClearMyTracksByProcess",uint,8)
	SplashTextOn,,,Downloading Plugin List,Please Wait...
	Run,RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 8
	plug:=new xml("plugins"),plug.xml.loadxml(UrlDownloadToVar("https://raw.githubusercontent.com/maestrith/AHK-Studio-Plugins/master/Index.xml"))
	SplashTextOff
	if(!plug[])
		return m("There was an error downloading the plugin list.  Please try again later")
	newwin:=new GUIKeep(35)
	Gui,35:Margin,0,0
	newwin.add("ListView,w500 h300 Checked,Name|Author|Description|Installed,wh","Button,gdpdl,&Download Checked,y","Button,x+0 gdpsa,Select &All,y","Button,x+0 gdprem,Remove Checked,y"),newwin.show("Download Plugins")
	goto,dppop
	return
	dprem:
	Gui,35:Default
	Gui,35:ListView,SysListView321
	while,next:=LV_GetNext(0,"C"){
		if(next=lastnext)
			Break
		LV_Modify(next,"Col4 -check","No"),LV_GetText(plugin,next)
		FileDelete,Plugins\%plugin%.ahk
		lastnext:=next
	}
	MenuWipe(),Menu("main")
	goto,dppop
	return
	dpsa:
	Loop,% LV_GetCount()
		LV_Modify(A_Index,"Check")
	return
	dpdl:
	pluglist:=""
	while,num:=LV_GetNext(0,"C"){
		LV_GetText(name,num),pos:=1,text:=URLDownloadToVar("https://raw.githubusercontent.com/maestrith/AHK-Studio-Plugins/master/" name ".ahk"),list:=""
		date:=plug.ssn("//*[@name='" name "']/@date").text,pos:=1
		while,pos:=RegExMatch(text,"Oim)^\s*\;menu\s*(.*)\R",found,pos)
			item:=StrSplit(found.1,","),item.1:=Trim(item.1,"`r|`r`n|`n"),list.=item.1 "`n",pos:=found.Pos(1)+1
		pluglist.=list=""?"Error in " name "`n":list
		if(list){
			if(FileExist("Plugins\" name ".ahk"))
				FileDelete,Plugins\%name%.ahk
			FileAppend,%text%,Plugins\%name%.ahk
			FileSetTime,%date%,Plugins\%name%.ahk,M
		}
		LV_Modify(num,"-Check")
	}
	Refresh_Plugins()
	m("Installation Report:",pluglist)
	goto,dppop
	return
	35GuiEscape:
	35GuiClose:
	hwnd({rem:35})
	return
	dppop:
	Gui,35:Default
	LV_Delete(),pgn:=plug.sn("//plugin")
	while,pp:=pgn.item[A_Index-1],ea:=xml.ea(pp){
		installed:="No"
		if(FileExist("plugins\" ea.name ".ahk")){
			FileGetTime,time,% "plugins\" ea.name ".ahk"
			checked:=ea.date!=time?"check":"",installed:="Yes"
		}else
			checked:=""
		LV_Add(checked,ea.name,ea.author,ea.description,installed)
	}
	Loop,3
		LV_ModifyCol(A_Index,"AutoHDR")
	return
}
Duplicate_Line(){
	csc().2469
}
Duplicates(){
	sc:=csc(),sc.2500(3),sc.2505(0,sc.2006),dup:=[],pos:=posinfo()
	v.lastsearch:=search:=sc.textrange(pos.start,pos.end),v.selectedduplicates:=""
	if(StrLen(search)<3)
		return
	sc.2190(0),sc.2500(3),sc.2192(sc.2006)
	while,(found:=sc.2197(StrLen(search),[search]))>=0{
		dup.Insert(found),found++
		sc.2190(found),sc.2192(sc.2006)
	}
	if(dup.MaxIndex()>1){
		v.duplicateselect:=1
		for a,b in dup{
			sc.2190(b),sc.2192(sc.2006)
			sc.2504(b,StrLen(search)),found++
		}
		v.selectedduplicates:=dup
	}
}
DynaRun(Script,debug=0){
	static exec
	exec.terminate()
	Name:="AHK Studio Test",Pipe:=[],cr:= Chr(34) Chr(96)"n" Chr(34)
	if(!InStr(script,"m(x*){"))
		script.="`n" "m(x*){`nfor a,b in x`nlist.=b " cr "`nMsgBox,,AHK Studio,% list`n}"
	if(!InStr(script,"t(x*){"))
		script.="`n" "t(x*){`nfor a,b in x`nlist.=b " cr "`nToolTip,% list`n}"
	Loop, 2
		Pipe[A_Index]:=DllCall("CreateNamedPipe","Str","\\.\pipe\" name,"UInt",2,"UInt",0,"UInt",255,"UInt",0,"UInt",0,"UPtr",0,"UPtr",0,"UPtr")
	Call:=Chr(34) A_AhkPath Chr(34) " /ErrorStdOut /CP65001 " Chr(34) "\\.\pipe\" Name Chr(34),Shell:=ComObjCreate("WScript.Shell"),Exec:=Shell.Exec(Call)
	for a,b in Pipe
		DllCall("ConnectNamedPipe","UPtr",b,"UPtr",0)
	FileOpen(Pipe.2,"h","UTF-8").Write(Script)
	for a,b in Pipe
		DllCall("CloseHandle","UPtr",b)
	return exec
}
Edit_Replacements(){
	static
	newwin:=new GUIKeep(7),sn:=settings.sn("//replacements/*"),newwin.Add("ListView,w500 h400 ger AltSubmit,Value|Replacement,wh","Text,,Value:,y","Edit,w500 vvalue,,wy","Text,xm,Replacement:,y","Edit,w500 r6 vreplacement gedrep,,wy","Button,xm geradd Default,Add,y","Button,x+10 gerremove,Remove Selected,y")
	while,val:=sn.item(A_Index-1)
		LV_Add("",ssn(val,"@replace").text,val.text)
	newwin.Show("Edit Replacements",1),LV_Modify(1,"Select Focus Vis AutoHDR")
	Loop,2
		LV_ModifyCol(A_Index,"AutoHDR")
	return
	edrep:
	info:=[]
	for a,b in {replacement:1,value:2}{
		ControlGetText,value,Edit%b%,% hwnd([7])
		info[a]:=value
	}
	if(item:=settings.ssn("//replacements/replacement[@replace='" info.replacement "']"))
		item.text:=info.value,LV_Modify(LV_GetNext(),"Col2",info.value)
	return
	eradd:
	rep:=newwin[]
	if(!(rep.replacement&&rep.value))
		return m("both values are required")
	if(!settings.ssn("//replacements/*[@replace='" rep.value "']"))
		settings.Add("replacements/replacement",{replace:rep.value},rep.replacement,1),LV_Add("",rep.value,rep.replacement)
	Loop,2
		ControlSetText,Edit%A_Index%
	ControlFocus,Edit1
	return
	er:
	LV_GetText(rep,LV_GetNext()),LV_GetText(rep1,LV_GetNext(),2)
	for a,b in {Edit1:rep,Edit2:rep1}
		ControlSetText,%a%,% RegExReplace(b,"(\r|\r\n|\n)","`r`n"),% hwnd([7])
	return
	erremove:
	Gui,7:Default
	while,LV_GetNext(),LV_GetText(value,LV_GetNext())
		rem:=settings.ssn("//replacements/*[@replace='" value "']"),LV_Delete(LV_GetNext()),rem.ParentNode.RemoveChild(rem)
	return
	7GuiClose:
	7GuiEscape:
	hwnd({rem:7})
	return
}
Encode(tt){
	length:=VarSetCapacity(text,strput(tt,"utf-8")),StrPut(tt,&text,length,"utf-8")
	return text
}
Escape(){
	sc:=csc()
	ControlGetFocus,Focus,% hwnd([1])
	if(!InStr(Focus,"scintilla")){
		selections:=[],main:=sc.2575,sel:=sc.2570()
		Loop,% sc.2570()
			selections.push([sc.2577(A_Index-1),sc.2579(A_Index-1)])
		sc.2400(),sc.2571()
		Sleep,0
		for a,b in selections{
			if(A_Index=1)
				sc.2160(b.2,b.1)
			else
				sc.2573(b.1,b.2)
		}
		sc.2574(main),CenterSel()
	}
}
ExecScript(Script, Wait:=false){
	shell:=ComObjCreate("WScript.Shell"),exec:=shell.Exec("AutoHotkey.exe /ErrorStdOut *"),exec.StdIn.Write(script),exec.StdIn.Close()
	if(Wait)
		return exec.StdOut.ReadAll()
	return exec
}
Dyna_Run(){
	ExecScript(publish(1))
}
Exit(x:="",reload:=0){
	Send,{Alt Up}
	last:=current(3).file,rem:=settings.ssn("//last"),rem.ParentNode.RemoveChild(rem),notesxml.save(1),savegui(),vault.save(1)
	for a,b in s.main{
		file:=files.ssn("//*[@sc='" b.2357 "']/@file").text
		if(file!="Virtual Scratch Pad.ahk")
			settings.add("last/file",,file,,1)
	}
	if(files.sn("//main[@untitled]").length)
		UnSaved()
	if((node:=settings.ssn("//last/file")).text="untitled.ahk")
		node.text:=files.ssn("//main/@file").text
	toolbar.save(),positions.save(1),rebar.save(),menus.save(1),getpos(),settings.add({path:"gui",att:{zoom:csc().2374}}),settings.save(1),bookmarks.save(1)
	for a in pluginclass.close
		If(WinExist("ahk_id" a))
			WinClose,ahk_id%a%
	if(debug.socket){
		debug.send("stop")
		sleep,500
		debug.disconnect()
	}
	if(save(v.options.disable_autosave?1:0)="cancel")
		return
	if(Reload)
		return
	if(x=""||InStr(A_ThisLabel,"Gui"))
		ExitApp
}
Export(){
	indir:=settings.ssn("//export/file[@file='" ssn(current(1),"@file").text "']"),warn:=settings.ssn("//options/@Warn_Overwrite_On_Export").text?"S16":""
	FileSelectFile,filename,%warn%,% indir.text,Export Compiled AHK,*.ahk
	SplitPath,filename,,outdir
	filename:=InStr(filename,".ahk")?filename:filename ".ahk"
	FileDelete,%filename%
	file:=FileOpen(filename,"rw","utf-8"),file.seek(0),file.write(publish(1)),file.length(file.length)
	if(!indir)
		indir:=settings.Add("export/file",{file:ssn(current(1),"@file").text},,1)
	if(outdir)
		indir.text:=filename
}
Extract(fileobj,top,rootfile,count){
	static ResDir:=ComObjCreate("Scripting.FileSystemObject")
	SplitPath,A_AhkPath,,ahkdir
	ahkdir.="\lib",nextfile:=[],showicon:=settings.ssn("//icons/pe/@show").text
	SplitPath,rootfile,rootfn,rootfolder
	if(!main:=cexml.ssn("//files/main[@file='" rootfile "']"))
		main:=cexml.Add("files/main",{file:rootfile},"",1),cexml.under(main,"file",{type:"File",parent:rootfile,file:rootfile,name:rootfn,folder:rootfolder,order:"name,type,folder"})
	for a,filename in fileobj{
		SplitPath,filename,fn,dir
		maindir:=dir,fff:=FileOpen(filename,"R"),encoding:=fff.encoding,text:=file:=fff.read(fff.length),fff.Close(),dir:=Trim(dir,"\"),text:=RegExReplace(text,"\R","`n"),update({file:filename,text:text,load:1}),update:=files.ssn("//main[@file='" rootfile "']/descendant::file[@file='" filename "']")
		for a,b in {filename:fn,encoding:encoding}
			update.SetAttribute(a,b)
		for a,b in StrSplit(text,"`n"){
			if(InStr(b,"*i"))
				StringReplace,b,b,*i ,,All
			if(RegExMatch(b,"iOm`n)^\s*\x23Include\s*,?\s*(.*)",found)){
				ff:=RegExReplace(found.1,"\R")
				SplitPath,ff,incfn,,ext
				if(InStr(found.1,":"))
					incfile:=ResDir.GetAbsolutePathName(found.1)
				else if(InStr(found.1,".."))
					incfile:=ResDir.GetAbsolutePathName(dir "\" found.1)
				if(!incfile)
					incfile:=ResDir.GetAbsolutePathName(rootfolder "\" found.1)
				if(ext=""&&InStr(found.1,"<")=0){
					dir:=InStr(found.1,"%A_ScriptDir%")?RegExReplace(found.1,"i)\x25A_ScriptDir\x25",maindir):found.1,dir:=Trim(dir,"\")
					incfile:=ext:=""
					Continue
				}else if(FileExist(incfile)&&ext){
					if(!ssn(top,"descendant::file[@file='" incfile "']"))
						spfile:=incfile,nextfile.Push(incfile)
				}else if(InStr(found.1,"<")||InStr(found.1,"%")){
					if(InStr(found.1,"<")){
						if(look:=RegExReplace(found.1,"(<|>)"))
							look.=".ahk"
					}else
						look:=found.1
					if(!FileExist(look))
						if(SubStr(look,-3)!=".ahk")
							if(FileExist(look ".ahk"))
								look.=".ahk"
					for c,d in {"ahkdir":ahkdir,"%A_ScriptDir%":maindir,"%A_MyDocuments%":A_MyDocuments "\AutoHotkey\Lib","lib":maindir "\lib","%A_AppData%":A_AppData,"%A_AppDataCommon%":A_AppDataCommon}{
						if(InStr(look,c))
							look:=RegExReplace(look,"i)" c "\\")
						if(FileExist(d "\" look)&&!ssn(top,"descendant::file[@file='" d "\" look "']")){
							nextfile.Push(d "\" look)
							if(!ssn(top,"descendant::file[@file='" d "\" look "']"))
								spfile:=d "\" look
							break
						}
					}
				}else if(FileExist(incfile:=ResDir.GetAbsolutePathName(dir "\" found.1)))
					if(!ssn(top,"descendant::file[@file='" incfile "']"))
						spfile:=incfile,nextfile.Push(incfile)
				if(spfile){
					SplitPath,spfile,fnme,folder
					SplitPath,folder,last
					last:=last?last:"lib",next:=top
					if(folder!=rootfolder&&v.options.Disable_Folders_In_Project_Explorer!=1){
						if(v.options.Full_Tree){
							relative:=StrSplit(RelativePath(rootfile,spfile),"\")
							for a,b in relative
								if(a=relative.MaxIndex())
									Continue
							else if(!foldernode:=ssn(next,"folder[@name='" b "']"))
								next:=files.under(next,"folder",{name:b,tv:FEAdd(b,ssn(next,"@tv").text,"Icon1 First Sort")})
							else
								next:=foldernode
						}else{
							if(!ssn(top,"folder[@name='" last "']"))
								slash:=v.options.Remove_Directory_Slash?"":"\",next:=files.under(top,"folder",{name:last,tv:FEAdd(slash last,ssn(top,"@tv").text,"Icon1 First Sort")})
							else
								next:=ssn(top,"folder[@name='" last "']")
						}
					}
					FileGetTime,time,%spfile%
					if(count>1)
						files.under(tvxml:=ssn(top,"descendant::file[@file='" filename "']"),"file",{time:time,file:spfile,include:Trim(found.0,"`n"),tv:FEAdd(fnme,ssn(tvxml,"@tv").text,"Icon2 First Sort"),github:(folder!=rootfolder)?last "\" fnme:fnme})
					else
						files.under(next,"file",{time:time,file:spfile,include:Trim(found.0,"`n"),tv:FEAdd(fnme,ssn(next,"@tv").text,"Icon2 First Sort"),github:(folder!=rootfolder)?last "\" fnme:fnme})
					cexml.under(main,"file",{type:"File",parent:rootfile,file:spfile,name:fnme,folder:folder,order:"name,type,folder"})
					spfile:=""
				}incfile:=ext:=""
			}
		}
	}
	if(nextfile.1)
		extract(nextfile,top,rootfile,++count)
}
FEAdd(value,parent,options){
	Gui,1:Default
	Gui,1:TreeView,SysTreeView321
	if(v.options.hide_file_extensions){
		SplitPath,value,,,ext,name
		value:=ext="ahk"?name:value
	}
	return TV_Add(value,parent,options)
}
FileCheck(file){
	static dates:={commands:{date:20151222093855,loc:"lib\commands.xml",url:"lib/commands.xml",type:1},menus:{date:20160106203739,loc:"lib\menus.xml",url:"lib/menus.xml",type:2},scilexer:{date:20160106132203,loc:"SciLexer.dll",url:"SciLexer.dll",type:1},icon:{date:20150914131604,loc:"AHKStudio.ico",url:"AHKStudio.ico",type:1},Studio:{date:20151021125614,loc:A_MyDocuments "\Autohotkey\Lib\Studio.ahk",url:"lib/Studio.ahk",type:1}},url:="https://raw.githubusercontent.com/maestrith/AHK-Studio/master/"
	if(!FileExist(A_MyDocuments "\Autohotkey")){
		FileCreateDir,% A_MyDocuments "\Autohotkey"
		FileCreateDir,% A_MyDocuments "\Autohotkey\Lib"
	}if(FileExist("lib\Studio.ahk"))
		FileMove,lib\Studio.ahk,%A_MyDocuments%\Autohotkey\Lib\Studio.ahk,1
	if(!file&&x:=ComObjActive("AHK-Studio")){
		x.activate()
		ExitApp
	}
	if(file){
		if(file){
			if(!settings.ssn("//open/file[text()='" file "']"))
				settings.add("open/file",{select:1},file,1)
		}if(x:=ComObjActive("AHK-Studio")){
			x.open(file),x.scanfiles(),x.Show()
			ExitApp
	}}if(A_PtrSize=8&&A_IsCompiled=""){
		SplitPath,A_AhkPath,,dir
		if(!FileExist(correct:=dir "\AutoHotkeyU32.exe")){
			m("Requires AutoHotkey 1.1 to run")
			ExitApp
		}
		Run,"%correct%" "%A_ScriptName%",%A_ScriptDir%
		ExitApp
		return
	}
	for a,b in dates{
		FileGetTime,time,% b.loc,M
		loc:=b.loc
		SplitPath,loc,,locdir
		if(FileExist(locdir)=""&&InStr(locdir,".")!=0)
			FileCreateDir,%locdir%
		if(b.type=2){
			if(menus.ssn("//date").text!=b.date){
				SplashTextOn,300,100,Downloading Menus XML,Please Wait...
				temp:=new xml("temp"),temp.xml.loadxml(URLDownloadToVar(url b.url)),menus:=new xml("menus","lib\menus.xml"),newitems:=[]
				if(menus.sn("//*").length=1)
					menus.xml.loadxml(temp[])
				else{
					menu:=temp.sn("//*")
					while,mm:=menu.item[A_Index-1],ea:=xml.ea(mm){
						if(mm.haschildnodes())
							Continue
						if(!ea.clean)
							Continue
						if(!menus.ssn("//*[@clean='" ea.clean "']")){
							pea:=xml.ea(mm.ParentNode)
							if(!parent:=menus.ssn("//*[@clean='" pea.clean "']"))
								if(!parent:=menus.ssn("//*[@clean='New_Menu_Items']"))
									parent:=menus.under(menus.ssn("//main"),"menu",{clean:"New_Menu_Items",name:"Ne&w Menu Items"})
							menus.under(parent,"menu",ea)
					}}options:=temp.sn("//*[@option='1']")
					while,oo:=options.item[A_Index-1],ea:=xml.ea(oo)
						menus.ssn("//*[@clean='" ea.clean "']").SetAttribute("option",1)
				}menus.add("date",,b.date),menus.save(1),options:=temp.sn("//*[@clean='Options']/*")
				while,oo:=options.item[A_Index-1],ea:=xml.ea(oo)
					menus.ssn("//*[@clean='" ea.clean "']").SetAttribute("option",1)
		}}else if((time<b.date)&&b.type=1){
			SplashTextOn,200,100,% "Downloading " b.loc,Please Wait....
			UrlDownloadToFile,% url b.url,% b.loc
			FileSetTime,% b.date,% b.loc,M
		}else if(!time){
			SplashTextOn,200,100,% "Downloading " b.loc,Please Wait....
			UrlDownloadToFile,% url b.url,% b.loc
			FileSetTime,% b.date,% b.loc,M
	}}
	if(!FileExist("plugins\settings.ahk")){
		SplashTextOn,300,50,Downloading Settings.ahk,Please Wait...
		FileCreateDir,Plugins
		URLDownloadToFile,https://raw.githubusercontent.com/maestrith/AHK-Studio-Plugins/master/Settings.ahk,plugins\Settings.ahk
		Refresh_Plugins()
	}
	SplashTextOff
	if(!settings.ssn("//fonts"))
		DefaultFont()
	RegRead,value,HKCU,Software\Classes\AHK-Studio
	(!value)?RegisterID("{DBD5A90A-A85C-11E4-B0C7-43449580656B}","AHK-Studio"):""
	if(!settings.ssn("//autoadd")){
		top:=settings.add("autoadd")
		for a,b in {"{":"}","[":"]","<":">","'":"'","(":")",Chr(34):Chr(34)}
			settings.under(top,"key",{trigger:a,add:b})
		settings.add("Auto_Indent",{Full_Auto:1}),settings.add("options",{Auto_Advance:1})
}}
Find_Replace(){
	static
	infopos:=positions.ssn("//*[@file='" current(3).file "']"),last:=ssn(infopos,"@findreplace").text,ea:=settings.ea("//findreplace"),newwin:=new GUIKeep(30),value:=[]
	for a,b in ea
		value[a]:=b?"Checked":""
	newwin.Add("Text,,Find","Edit,w200 vfind","Text,,Replace","Edit,w200 vreplace","Checkbox,vregex " value.regex ",Regex","Checkbox,vcs " value.cs ",Case Sensitive","Checkbox,vgreed " value.greed ",Greed","Checkbox,vml " value.ml ",Multi-Line","Checkbox,xm vsegment " value.segment ",Current Segment Only","Checkbox,xm vcurrentsel hwndcs gcurrentsel " value.currentsel ",In Current Selection","Button,gfrfind Default,&Find","Button,x+5 gfrreplace,&Replace","Button,x+5 gfrall,Replace &All")
	newwin.Show("Find & Replace"),sc:=csc(),order:=[],order[sc.2585(0)]:=1,order[sc.2587(0)]:=1,last:=(order.MinIndex()!=order.MaxIndex())?sc.textrange(order.MinIndex(),order.MaxIndex()):last,hotkeys([30],{"!e":"frregex"})
	if(ea.regex&&order.MinIndex()!=order.MaxIndex())
		for a,b in StrSplit("\.*?+[{|()^$")
			if(!InStr(last,"\" b))
				StringReplace,last,last,%b%,\%b%,All
	if(!value.currentsel)
		ControlSetText,Edit1,%last%,% hwnd([30])
	else
		gosub,checksel
	ControlSend,Edit1,^a,% hwnd([30])
	Gui,1:-Disabled
	return
	checksel:
	sc:=csc()
	if(sc.2008=sc.2009)
		GuiControl,30:,In Current Selection,0
	else
		gosub,currentsel
	return
	frregex:
	Send,{!e,up}
	ControlGet,check,Checked,,Button1,% hwnd([30])
	check:=!check
	GuiControl,30:,Button1,%check%
	return
	30GuiClose:
	30GuiEscape:
	info:=newwin[],fr:=settings.Add("findreplace")
	for a,b in {regex:info.regex,cs:info.cs,greed:info.greed,ml:info.ml,segment:info.segment,currentsel:info.currentsel}
		fr.SetAttribute(a,b)
	fr:=positions.ssn("//*[@file='" current(3).file "']"),fr.SetAttribute("findreplace",info.find),hwnd({rem:30})
	if(start!=""&&end!="")
		sc.2160(start,end),start:=end:="",sc.2500(2),sc.2505(0,sc.2006)
	return
	currentsel:
	ControlGet,check,Checked,,In Current Selection,% hwnd([30])
	sc:=csc(),sc.2500(2),sc.2505(0,sc.2006)
	if(!check){
		if(start!=""&&end!="")
			sc.2500(2),sc.2505(0,sc.2006),sc.2160(start,end)
		return
	}start:=sc.2008>sc.2009?sc.2009:sc.2008,end:=sc.2008<sc.2009?sc.2009:sc.2008,sc.2504(start,end-start),sc.2025(start)
	if(start=end){
		GuiControl,30:,In Current Selection,0
		return m("Select Some Text First")
	}
	return
	frfind:
	info:=newwin[],startsearch:=0,sc:=csc(),stop:=current(3).file,looped:=0,current:=current(1),pos:=sc.2008,pre:="O",find:="",find:=info.regex?info.find:"\Q" RegExReplace(info.find, "\\E", "\E\\E\Q") "\E",pre.=info.greed?"":"U",pre.=info.cs?"":"i",pre.=info.ml?"":"m`n",find:=pre ")" find ""
	if(info.currentsel){
		end:=sc.2509(2,start),text:=SubStr(sc.getuni(),start+1,end-start+1),greater:=sc.2008>sc.2009?sc.2008:sc.2009,pos:=greater>start?greater-start:1
		if(RegExMatch(text,find,found,pos)){
			fp:=found.Pos(1)!=""?found.Pos(1):found.Pos(0),fl:=found.len(1)!=""?found.len(1):found.len(0)
			sc.2160(start+fp-1,start+fp-1+fl)
		}else{
			pos:=1
			if(RegExMatch(text,find,found,pos)){
				fp:=found.Pos(1)!=""?found.Pos(1):found.Pos(0),fl:=found.len(1)!=""?found.len(1):found.len(0)
				sc.2160(start+fp-1,start+fp-1+fl)
		}}
		return
	}
	frrestart:
	if(!info.find)
		return m("Enter search text")
	if(RegExMatch(text:=sc.getuni(),find,found,sc.2008+1))
		return sc.2160(start:=StrPut(SubStr(text,1,found.Pos(0)),"utf-8")-2,start+StrPut(found.0,"utf-8")-1)
	list:=info.segment?sn(current(1),"descendant::file[@file='" current(3).file "']"):sn(current(1),"descendant::file")
	while,current:=list.Item[A_Index-1],ea:=xml.ea(current){
		if(ea.file!=stop&&startsearch=0)
			continue
		startsearch:=1
		text:=update({get:ea.file})
		if(pos:=RegExMatch(text,find,found,pos)){
			tv(files.ssn("//file[@file='" ea.file "']/@tv").text)
			Sleep,300
			np:=StrPut(SubStr(text,1,pos-1),"utf-8")-1,sc.2160(np,np+StrPut(found.0,"utf-8")-1)
			return
		}
		if(ea.file=stop&&looped=1)
			return m("No Matches Found")
		pos:=1
	}current:=current(1).firstchild,looped:=1
	goto,frrestart
	return
	FRReplace:
	sc:=csc(),info:=newwin[],sc.2170(0,[RegExReplace(sc.getseltext(),"\Q" info.find "\E",NewLines(info.replace))])
	goto,frfind
	return
	frall:
	info:=newwin[],sc:=csc(),stop:=current(3).file,looped:=0,current:=current(),pos:=sc.2008,pre:="O",find:="",find:=info.regex?info.find:"\Q" RegExReplace(info.find, "\\E", "\E\\E\Q") "\E",pre.=info.greed?"":"U",pre.=info.cs?"":"i",pre.=info.ml?"":"m`n",find:=pre ")" find ""
	if(info.currentsel)
		return pos:=1,end:=sc.2509(2,start),text:=SubStr(sc.getuni(),start+1,end-start),text:=RegExReplace(text,find,info.replace),sc.2190(start),sc.2192(end),sc.2194(StrPut(text,"utf-8")-1,[text]),sc.2500(2),sc.2505(0,sc.2006),sc.2504(start,len:=StrPut(text,"utf-8")-1),end:=start+len
	if(info.segment)
		goto,frseg
	list:=sn(current(1),"descendant::file"),All:=update("get").1,info:=newwin[],replace:=NewLines(info.replace)
	while,ll:=list.Item[A_Index-1]{
		text:=All[ssn(ll,"@file").text]
		if(RegExMatch(text,find,found)){
			rep:=RegExReplace(text,find,replace),ea:=xml.ea(ll)
			if(ea.sc){
				tv(ea.tv)
				Sleep,300
				sc.2181(0,[rep])
			}else
				update({file:ea.file,text:rep})
	}}
	return
	frseg:
	GetPos(),info:=newwin[],sc:=csc(),pre:="O",find:="",find:=info.regex?info.find:"\Q" RegExReplace(info.find, "\\E", "\E\\E\Q") "\E",pre.=info.greed?"":"U",pre.=info.cs?"":"i",pre.=info.ml?"":"m`n",find:=pre ")" find ""
	replace:=NewLines(info.replace)
	sc.2181(0,[RegExReplace(sc.gettext(),find,replace)]),setpos(ssn(current(),"@tv").text)
	return
}
Find(){
	static
	sc:=csc(),order:=[],file:=current(2).file,infopos:=positions.ssn("//*[@file='" file "']"),last:=ssn(infopos,"@search").text,search:=last?last:"Type in your query here",ea:=settings.ea("//search/find"),newwin:=new GUIKeep(5),value:=[],order[sc.2585(0)]:=1,order[sc.2587(0)]:=1,last:=(order.MinIndex()!=order.MaxIndex())?sc.textrange(order.MinIndex(),order.MaxIndex()):last
	for a,b in ea
		value[a]:=b?"Checked":""
	newwin.Add("Edit,gfindcheck w400 vfind r1,,w","TreeView,w400 h200 gstate,,wh","Checkbox,vregex gfindfocus " value.regex ",&Regex Search,y","Checkbox,vgr x+10 gfindfocus " value.gr ",&Greed,y","Checkbox,xm vcs gfindfocus " value.cs ",&Case Sensitive,y","Checkbox,vsort gfsort " value.sort ",Sort by &Segment,y","Checkbox,vallfiles gfindfocus " value.allfiles ",Search in &All Files,y","Checkbox,vacdc gfindfocus " value.acdc ",Auto Close on &Double Click gfindfocus,y","Button,gsearch Default,   Search   ,y","Button,gcomment,Toggle Comment,y"),newwin.Show("Search"),hotkeys([5],{"^Backspace":"findback"})
	if(value.regex&&order.MinIndex()!=order.MaxIndex())
		for a,b in StrSplit("\.*?+[{|()^$")
			StringReplace,last,last,%b%,\%b%,All
	ControlSetText,Edit1,%last%,% hwnd([5])
	ControlSend,Edit1,^a,% hwnd([5])
	Gui,1:-Disabled
	return
	OnClipboardChange:
	if(hwnd(5)||hwnd(30)){
		win:=hwnd(5)?hwnd([5]):hwnd([30])
		ControlSetText,Edit1,%Clipboard%,%win%
	}
	return
	findback:
	GuiControl,5:-Redraw,Edit1
	ControlSend,Edit1,^+{Left}{Backspace},% hwnd([5])
	GuiControl,5:+Redraw,Edit1
	return
	findcheck:
	ControlGetText,Button,Button7,% hwnd([5])
	if(Button!="search")
		ControlSetText,Button7,Search,% hwnd([5])
	return
	search:
	ControlGetText,Button,Button7,% hwnd([5])
	if(InStr(button,"search")){
		ea:=newwin[],count:=0
		if(!find:=ea.find)
			return
		infopos.setattribute("search",find),foundinfo:=[]
		Gui,5:Default
		GuiControl,5:+g,SysTreeView321
		GuiControl,5:-Redraw,SysTreeView321
		list:=ea.allfiles?files.sn("//file/@file"):sn(current(1),"descendant::file/@file"),contents:=update("get").1,TV_Delete()
		pre:="m`nO",pre.=ea.cs?"":"i",pre.=ea.greed?"":"U",parent:=0,ff:=ea.regex?find:"\Q" find "\E"
		while,l:=list.item(A_Index-1){
			out:=contents[l.text],found:=1,r:=0,fn:=l.text
			SplitPath,fn,file
			while,found:=RegExMatch(out,pre ")(^.*" ff ".*$)",pof,found){
				parentfile:=files.ssn("//*[@file='" fn "']/ancestor::main/@file").text
				if(ea.sort&&lastl!=fn)
					parent:=TV_Add(RelativePath(parentfile,fn))
				np:=found=1?0:StrPut(SubStr(out,1,found),"utf-8")-1-(StrPut(SubStr(pof.1,1,1),"utf-8")-1)
				fpos:=1
				while,fpos:=RegExMatch(pof.1,pre ")[^.*]?(" ff ")",loof,fpos){
					add:=loof.Pos(1)-1,foundinfo[TV_Add(loof.1 " : " Trim(pof.1,"`t"),parent)]:={start:np+add,end:np+add+StrPut(loof.1,"Utf-8")-1,file:l.text}
					fpos+=StrLen(loof.1)
				}
				found:=pof.Pos(1)+pof.len(1)-1
				lastl:=fn,count++
			}
		}
		WinSetTitle,% hwnd([5]),,Find : %count%
		if(TV_GetCount())
			ControlFocus,SysTreeView321
		GuiControl,5:+Redraw,SysTreeView321
		SetTimer,findlabel,-200
		GuiControl,5:+gstate,SysTreeView321
	}else if(Button="jump"){
		Gui,1:+Disabled
		ea:=foundinfo[TV_GetSelection()],SetPos(ea),xpos:=sc.2164(0,ea.start),ypos:=sc.2165(0,ea.start)
		Sleep,200
		WinGetPos,xx,yy,ww,hh,% newwin.ahkid
		WinGetPos,px,py,,,% "ahk_id" sc.sc
		WinGet,trans,Transparent,% newwin.ahkid
		cxpos:=px+xpos,cypos:=py+ypos
		if(cxpos>xx&&cxpos<xx+ww&&cypos>yy&&cypos<yy+hh)
			WinSet,Transparent,50,% newwin.ahkid
		else if(trans=50)
			WinSet,Transparent,255,% newwin.ahk
		SetTimer,CenterSel,-10
	}else{
		sel:=TV_GetSelection(),TV_Modify(sel,ec:=TV_Get(sel,"E")?"-Expand":"Expand")
		SetTimer,findlabel,-200
	}
	return
	state:
	if(A_GuiEvent="DoubleClick"){
		info:=newwin[]
		ea:=foundinfo[TV_GetSelection()]
		Sleep,200
		SetPos({start:ea.start,end:ea.end,file:ea.file})
		if(info.acdc)
			goto,5GuiClose
	}if(A_GuiEvent!="Normal")
		return
	sel:=TV_GetSelection()
	Gui,5:TreeView,SysTreeView321
	if(refreshing)
		return
	ControlGetFocus,focus,% hwnd([5])
	SetTimer,findlabel,-200
	if(v.options.auto_close_find){
		hwnd({rem:5})
	}else
		WinActivate,% hwnd([5])
	return
	findlabel:
	Gui,5:Default
	sel:=TV_GetSelection()
	if(!TV_GetCount())
		Buttontext:="Search"
	else if(TV_GetChild(sel))
		Buttontext:=TV_Get(sel,"E")?"Contract":"Expand"
	else if(TV_GetCount()&&TV_GetChild(sel)=0)
		Buttontext:="Jump"
	ControlSetText,Button7,%Buttontext%,% hwnd([5])
	return
	fsort:
	ControlSetText,Button7,Search,% hwnd([5])
	goto,search
	return
	5GuiEscape:
	5GuiClose:
	Gui,5:Submit,NoHide
	ea:=newwin[],settings.add("search/find",{acdc:ea.acdc,regex:ea.regex,cs:ea.cs,sort:ea.sort,gr:ea.gr,allfiles:ea.allfiles}),foundinfo:="",positions.ssn("//*[@file='" file "']/@search").text:=ea.find,hwnd({rem:5})
	return
	comment:
	sc:=csc()
	toggle_comment_line()
	return
	FindFocus:
	ControlFocus,Edit1,% hwnd([5])
	return
}
fix_indent(sc=""){
	return newindent()
	skip:=1
	move_selected:
	return
	fix_paste:
	settimer,%A_ThisLabel%,Off
	if(v.options.full_auto)
		newindent()
	return
	fullauto:
	settimer,%A_ThisLabel%,Off
	return
	next:=0,cpos:=0,indent:=0,add:=0
	lock:=[],track:=[]
	if(!WinExist("ahk_id" sc.sc))
		sc:=csc()
	filename:=files.ssn("//*[@sc='" sc.2357 "']/@file").text
	SplitPath,filename,,,ext
	if(ext="xml")
		return
	if(ext!="ahk"&&v.scratch.sc!=sc.sc&&skip!=1&&v.options.Disable_auto_indent_for_non_ahk_files!=1)
		return
	skip:=""
}
NewIndent(indentwidth:=""){
	Critical
	sc:=csc(),codetext:=sc.getuni(),indentation:=sc.2121,line:=sc.2166(sc.2008),posinline:=sc.2008-sc.2128(line),selpos:=posinfo(),sc.2078,lock:=[],block:=[],aa:=ab:=braces:=0,code:=StrSplit(codetext,"`n"),aaobj:=[],specialbrace:=0
	filename:=current(3).file
	SplitPath,filename,,,ext
	if(ext="xml")
		return
	sc.Enable(),skipcompile:=0
	for a,text in code{
		text:=Trim(text,"`t ")
		if(text~="i)\Q* * * Compile_AHK\E"){
			skipcompile:=skipcompile?0:1
			Continue
		}
		if(skipcompile)
			Continue
		if(SubStr(text,1,1)=";")
			Continue
		firsttwo:=SubStr(text,1,2)
		if(firsttwo=";{"||firsttwo=";}"){
			if(RegExReplace(text,"\{","",count))
				specialbrace+=count
			if(RegExReplace(text,"\}","",count))
				specialbrace-=count
			Continue
		}
		if(InStr(text,Chr(59)))
			text:=RegExReplace(text,"\s+" Chr(59) ".*"),comment:=1
		first:=SubStr(text,1,1),last:=SubStr(text,0,1),ss:=(text~="i)^\s*(&&|\bOR\b|\bAND\b|\.|\,|\|\||:|\?)\s*"),indentcheck:=RegExMatch(text,"iA)}*\s*\b(" v.indentregex ")\b",string)
		if(InStr(string,"try"))
			if(RegExReplace(text,"i)(\{|try|\s)"))
				indentcheck:=0
		if(first="("&&InStr(text,")")=0)
			skip:=1
		if(Skip){
			if(First=")")
				Skip:=0
			Continue
		}if(firsttwo="*/")
			block:=[],aa:=0
		block.MinIndex()?(current:=block,cur:=1):(current:=lock,cur:=0),braces:=current[current.MaxIndex()].braces+1?current[current.MaxIndex()].braces:0,aa:=aaobj[cur]+0?aaobj[cur]:0
		if(first="}"){
			while,((found:=SubStr(text,A_Index,1))~="(}|\s)"){
				if(found~="\s")
					Continue
				if(cur&&current.MaxIndex()<=1)
					Break
				special:=current.pop().ind,braces--
			}
		}if(first="{"&&aa)
			aa--
		tind:=current[current.MaxIndex()].ind+1?current[current.MaxIndex()].ind:0,tind+=aa?aa*indentation:0,tind:=tind+1?tind:0,tind:=special?special-indentation:tind,tind:=current[current.MaxIndex()].ind+1?current[current.MaxIndex()].ind:0,tind+=aa?aa*indentation:0,tind:=tind+1?tind:0,tind:=special?special-indentation:tind,tind+=Abs(specialbrace*indentation)
		if(!(ss&&v.options.Manual_Continuation_Line)&&sc.2127(a-1)!=tind)
			sc.2126(a-1,tind)
		if(firsttwo="/*"){
			if(block.1.ind="")
				block.Insert({ind:(lock.1.ind!=""?lock[lock.MaxIndex()].ind+indentation:indentation),aa:aa,braces:lock.1.ind+1?Lock[lock.MaxIndex()].braces+1:1})
			current:=block,aa:=0
		}if(last="{")
			braces++,aa:=ss&&last="{"?aa-1:aa,!current.MinIndex()?current.Insert({ind:(aa+braces)*indentation,aa:aa,braces:braces}):current.Insert({ind:(aa+current[current.MaxIndex()].aa+braces)*indentation,aa:aa+current[current.MaxIndex()].aa,braces:braces}),aa:=0
		if((aa||ss||indentcheck)&&(indentcheck&&last!="{"))
			aa++
		if(aa>0&&!(ss||indentcheck))
			aa:=0
		aaobj[cur]:=aa,special:=0,comment:=0
	}update({sc:sc.2357})
	if(indentwidth)
		return sc.2079(),sc.Enable(1)
	WinGetTitle,title,% hwnd([1])
	if(braces&&InStr(title,"Segment Open!   -   ")=0)
		WinSetTitle,% hwnd([1]),,% "Segment Open!   -   AHK Studio - " current(3).file
	else if(braces=0&&InStr(title,"Segment Open!   -   "))
		WinSetTitle,% hwnd([1]),,% "AHK Studio - " current(3).file
	if(selpos.start=selpos.end){
		newpos:=sc.2128(line)+posinline,newpos:=newpos>sc.2128(line)?newpos:sc.2128(line),sc.2025(newpos)
		if(sc.2129(sc.2008))
			Send,{Left}{Right}
	}else
		sc.2160(sc.2167(startline),sc.2136(endline))
	line:=sc.2166(sc.2008)
	if(sc.2008=sc.2128(line)&&v.options.Manual_Continuation_Line){
		ss:=(sc.getline(line-1)~="i)^\s*(&&|OR|AND|\.|\,|\|\||:|\?)")
		if(ss)
			sc.2126(line,sc.2127(line-1)),sc.2025(sc.2128(line))
	}
	sc.Enable(1),sc.2079
}
Fix_Next(){
	sc:=csc(),line:=sc.2166(sc.2008),indent:=sc.2127(line-1),sc.2126(line,indent),sc.2025(sc.2128(line))
	GuiControl,1:+Redraw,% sc.sc
}
Full_Backup(remove:=0){
	save(),sc:=csc()
	SplashTextOn,300,100,Backing up...,Please wait, This may take some time if it has been a while since your last full backup.
	cur:=current(2).file
	SplitPath,cur,,dir
	if(remove){
		loop,%dir%\backup\*.*,2
			FileRemoveDir,%A_LoopFileFullPath%,1
	}
	backup:=dir "\backup\Full Backup" A_Now
	FileCreateDir,%backup%
	if(v.options.Full_Backup_All_Files){
		loop,%dir%\*.*,0,1
		{
			if(InStr(a_loopfilename,".exe")||InStr(A_LoopFileName,".dll")||InStr(A_LoopFileDir,dir "\backup"))
				Continue
			file:=Trim(RegExReplace(A_LoopFileFullPath,"i)\Q" dir "\E"),"\")
			SplitPath,file,filename,ddir
			if(!FileExist(backup "\" ddir))
				FileCreateDir,% backup "\" ddir
			ndir:=ddir?backup "\" ddir:backup
			FileCopy,%A_LoopFileFullPath%,%ndir%\%filename%
		}
	}else{
		allfiles:=sn(current(1),"descendant::file/@file")
		while,af:=allfiles.item[A_Index-1]{
			file:=Trim(RegExReplace(af.text,"i)\Q" dir "\E"),"\")
			SplitPath,file,filename,ddir
			if(!FileExist(backup "\" ddir))
				FileCreateDir,% backup "\" ddir
			ndir:=ddir?backup "\" ddir:backup
			FileCopy,% af.text,%ndir%\%filename%
		}
	}
	loop,%dir%\backup\*.*,2
		if(!InStr(A_LoopFileFullPath,"Full Backup"))
			FileRemoveDir,%A_LoopFileFullPath%,1
	SplashTextOff
}
GetWebBrowser(){
	SendMessage,DllCall("RegisterWindowMessage","str","WM_HTML_GETOBJECT"),0,0,Internet Explorer_Server1,AutoHotkey Help
	if(ErrorLevel=FAIL)
		return
	lResult:=ErrorLevel,VarSetCapacity(GUID,16,0),CLSID:=DllCall("ole32\CLSIDFromString","wstr","{332C4425-26CB-11D0-B483-00C04FD90119}","ptr",&GUID)>=0?&GUID:"",DllCall("oleacc\ObjectFromLresult", "ptr", lResult,"ptr",CLSID,"ptr",0,"ptr*",pdoc),pweb:=ComObjQuery(pdoc,id:="{0002DF05-0000-0000-C000-000000000046}",id),ObjRelease(pdoc)
	return ComObject(9,pweb,1)
}
GetInclude(){
	GetInclude:
	main:=current(2).file,sc:=csc()
	SplitPath,main,,dir
	FileSelectFile,filename,,%dir%,Select a file to include,*.ahk
	if(ErrorLevel||filename="")
		return
	newfile:=filename~="\.ahk$"?filename:filename ".ahk"
	Relative:=RelativePath(ssn(current(),"@file").text,newfile)
	sc.2003(sc.2008," " Relative)
	Gui,1:Default
	Gui,1:TreeView,SysTreeView321
	Refresh_Project_Explorer(newfile)
	return
}
GetPos(){
	static count
	count++
	if(!current(1).xml)
		return
	sc:=csc(),current:=current(2).file,code_explorer.scan(current()),cf:=current(3).file
	if(!top:=positions.ssn("//main[@file='" current "']"))
		top:=positions.add("main",{file:current},,1)
	if(!fix:=ssn(top,"descendant::file[@file='" cf "']"))
		fix:=settings.under(top,"file",{file:cf})
	for a,b in {start:sc.2008,end:sc.2009,scroll:sc.2152,file:ssn(current(),"@file").text}
		fix.SetAttribute(a,b)
	fold:=0,ff:=0,fix.removeattribute("fold")
	while,sc.2618(fold)>=0,fold:=sc.2618(fold)
		list.=fold ",",fold++
	if(list)
		fix.SetAttribute("fold",Trim(list,","))
}
Go_To_Line(){
	sc:=csc()
	value:=InputBox(sc.sc,"Go To Line","Enter the Line Number you want to go to max = " sc.2154,sc.2166(sc.2008)+1)
	if(RegExMatch(value,"\D")||value="")
		return m("Please enter a line number")
	sc.2025(sc.2128(value-1))
}
Google_Search_Selected(){
	sc:=csc(),text:=sc.getseltext()
	if(!text)
		return m("Please select some text to search for")
	Run,https://www.google.com/search?q=%text%
}
Goto(){
	goto:
	sc:=csc(),sc.2003(sc.2008,","),sc.2025(sc.2008+1),labels:="",list:=cexml.sn("//file[@file='" current(3).file "']descendant::info[@type='Label']")
	while,ll:=list.item[A_Index-1]
		labels.=cexml.ea(ll).text " "
	Sort,labels,D%A_Space%
	sc.2100(0,Trim(labels))
	return
}
Gui(){
	static
	static controls:=["Static1","Edit1","Button1","Button2","Button3","Button4"]
	Gui,+hwndhwnd +Resize +OwnDialogs
	hwnd(1,hwnd),rb:=new rebar(1,hwnd),v.rb:=rb,pos:=settings.ssn("//gui/position[@window='1']")
	OnMessage(6,"Activate")
	v.opening:=1
	Gui,Margin,0,0
	Gui,Add,TreeView,xm hwndce c0xff00ff w150 AltSubmit
	Gui,Add,TreeView,hwndpe c0xff00ff w150 gcej AltSubmit
	sc:=new s(1,{pos:"w200 h200",main:1}),TV_Add("Right Click to refresh"),v.ce:=ce
	Gui,Add,Text,xm+3 c0xAAAAAA,Quick Find
	Gui,Add,Edit,x+2 w200 c0xAAAAAA gqf
	ea:=settings.ea("//Quick_Find_Settings")
	for a,b in ["Regex","Case Sensitive","Greed","Multi Line"]{
		checked:=ea[clean(b)]?"Checked":"",v.options[clean(b)]:=ea[clean(b)]
		Gui,Add,Checkbox,x+3 c0xAAAAAA gqfs %Checked%,%b%
	}
	Hotkey,IfWinActive,% hwnd([1])
	enter:=[]
	for a,b in ["~","+"]
		Enter[b "Enter"]:="checkqf",Enter[b "NumpadEnter"]:="checkqf"
	Enter["~Escape"]:="Escape",Enter["^a"]:="SelectAll",Enter["^v"]:="menupaste"
	for a,b in StrSplit("WheelLeft,WheelRight",",")
		Enter[b]:="scrollwheel"
	;start
	bar:=[],band:=[]
	if(rem:=settings.ssn("//rebar/band[@id='11000']"))
		rem.ParentNode.RemoveChild(rem)
	bar.10000:=[[4,"shell32.dll","Open","Open",10000,4],[8,"shell32.dll","Save","Save",10001,4],[137,"shell32.dll","Run","Run",10003,4],[249,"shell32.dll","Check_For_Update","Check For Update",10004,4],[100,"shell32.dll","New_Scintilla_Window","New Scintilla Window",10005,4],[271,"shell32.dll","Remove_Scintilla_Window","Remove Scintilla Window",10006,4]],bar.10001:=[[110,"shell32.dll","open_folder","Open Folder",10000,4],[135,"shell32.dll","google_search_selected","Google Search Selected",10001,4]],bar.10002:=[[18,"shell32.dll","Connect","Connect",10000,4],[22,"shell32.dll","Debug_Current_Script","Debug Current Script",10001,4],[21,"shell32.dll","ListVars","List Variables",10002,4],[137,"shell32.dll","Run_Program","Run Program",10003,4],[27,"shell32.dll","stop","Stop",10004,4]]
	if(!toolbarobj:=settings.ssn("//toolbar")){
		temp:=new xml("temp"),top:=temp.ssn("//*"),tbo:=temp.under(top,"toolbar")
		for a,b in bar{
			btop:=temp.under(tbo,"bar",{id:a})
			for c,d in b{
				att:=[]
				for e,f in ["icon","file","func","text","id","state"]
					att[f]:=d[A_Index]
				att["vis"]:=1
				temp.under(btop,"button",att)
			}
		}
		temp.transform(),top:=temp.ssn("//toolbar"),main:=settings.ssn("//*"),main.AppendChild(top)
		toolbarobj:=settings.ssn("//toolbar")
	}
	;redo this
	ControlGetPos,,,,h,,ahk_id%edit%
	band.10000:={id:10000,vis:1,width:263},band.10001:={id:10001,vis:1,width:150},band.10002:={id:10002,vis:0,width:200}
	if(!settings.ssn("//rebar"))
		for a,b in band
			if(!settings.ssn("//rebar/band[@id='" a "']"))
				settings.Add("rebar/band",{id:a,width:b.width,vis:b.vis},,1)
	toolbars:=settings.sn("//toolbar/bar"),bands:=settings.sn("//rebar/descendant::*")
	while,bb:=toolbars.item[A_Index-1]{
		buttons:=sn(bb,"*"),tb:=new toolbar(1,hwnd,ssn(bb,"@id").text)
		while,button:=buttons.item[A_Index-1]
			tb.add(xml.ea(button))
	}
	visible:=settings.sn("//toolbar/*/*[@vis='1']")
	while,vis:=Visible.item[A_Index-1]
		tb:=toolbar.list[ssn(vis.parentnode,"@id").text],tb.addbutton(ssn(vis,"@id").text)
	while,bb:=bands.item[A_Index-1],ea:=xml.ea(bb){
		if(bb.nodename="newline"){
			newline:=1
			continue
		}
		if(ea.id=11000)
			ea:=band[ea.id]
		if(!ea.width)
			ea.width:=toolbar.list[ea.id].barinfo().ideal+20
		rb.add(ea,newline),newline:=0
	}
	hide:=settings.sn("//rebar/descendant::*[@vis='0']")
	while,hh:=hide.item[A_Index-1],ea:=xml.ea(hh)
		rb.hide(ea.id)
	;/redo this
	;/end
	Gui,Add,StatusBar,hwndstatus
	ControlGetPos,,,,h,,ahk_id%status%
	v.status:=h,Menu("main"),max:=ssn(pos,"@max").text?"Maximize":"",pos:=pos.text?pos.text:"w750 h500"
	Gui,Show,%pos% Hide,AHK Studio
	WinSetTitle,% hwnd([1]),,AHK Studio - Indexing Lib Files
	Index_Lib_Files(),OnMessage(5,"Resize"),open:=settings.sn("//open/file"),Options()
	Gui,1:Show,%pos% %max% Hide,AHK Studio
	Margin_Left(1),csc().2400,BraceSetup(1),Resize("rebar")
	RefreshThemes(),debug.off()
	Gui,Show,%max%
	SetTimer,rsize,-0
	while,oo:=open.item[A_Index-1]{
		if(!FileExist(oo.text)){
			rem:=settings.sn("//file[text()='" oo.text "']")
			while,rr:=rem.item[A_Index-1]
				rr.ParentNode.RemoveChild(rr)
		}else
			openfilelist.=oo.text "`n"
	}
	hk(1),hotkeys([1],enter),(openfilelist)?Open(trim(openfilelist,"`n")):New(1)
	if(last.length>1){
		while,file:=last.item[A_Index-1]{
			if(A_Index=1)
				Continue
			New_Scintilla_Window(file.text)
		}
		csc({hwnd:s.main.1.sc}).2400
	}
	WinSet,Redraw,,% hwnd([1])
	v.opening:=0,TrayMenu()
	GuiControl,1:+gtv,SysTreeView321
	if(select:=settings.ssn("//open/file[@select='1']"))
		tv(files.ssn("//file[@file='" select.text "']/@tv").text,1)
	else if(select:=settings.ssn("//last/file").text)
		tv(files.ssn("//file[@file='" select "']/@tv").text,1)
	else
		tv(files.ssn("//file[@tv!='']/@tv").text,1)
	while,ss:=settings.ssn("//open/file[@select='1']")
		ss.RemoveAttribute("select")
	csc(1),Refresh(),Check_For_Update(1)
	WinSet,Redraw,,% hwnd([1])
	return
	GuiClose:
	exit()
	return
	deadend:
	return
}
Class GuiKeep{
	static keep:=[]
	__New(win,info*){
		this.osver:=SubStr(A_OSVersion,1,3),OnMessage(5,"Resize"),this.win:=win,setup(win),this.con:=[],this.ctrl:=[],this.resize:=0
		border:=StrSplit(A_OSVersion,".").1=10?0:DllCall("GetSystemMetrics",int,32)
		for a,b in {border:border,caption:DllCall("GetSystemMetrics",int,4)}
			this[a]:=b
		if(settings.ssn("//options/@Add_Margins_To_Windows").text!=1)
			Gui,% this.win ":Margin",0,0
		if(info.1)
			this.add(info*)
	}
	add(info*){
		win:=this.win,this.ahkid:=hwnd([this.win]),this.hwnd:=hwnd(this.win)
		for a,b in info{
			opt:=StrSplit(b,","),RegExMatch(opt.2,"iO)\bv(\w+)",found)
			if(found.1)
				this.var[found.1]:=1
			if(opt.1="s")
				split:=StrSplit(opt.3,"-"),hwnd:=new s(win,{pos:opt.2,label:split.1}),this.sc:=hwnd,var:=split.2,%var%:=hwnd,hwnd:=hwnd.sc
			else
				hwnd:=this.addctrl(opt)
			if(found.1)
				this.ctrl[found.1]:=hwnd
			if(opt.4){
				ControlGetPos,x,y,w,h,,ahk_id%hwnd%
				for a,b in {x:x,y:y,w:w,h:h}
					this.con[hwnd,a]:=b-(a="x"?(this.osver="10."?3:this.border*2):a="y"?(this.caption-(this.osver="10."?-3:this.Border)):a="h"?this.border:0)
				this.con[hwnd,"pos"]:=opt.4,this.Resize:=1
			}
		}
		if(this.resize)
			Gui,%win%:+Resize
		this.resize:=0
	}
	addctrl(opt:=""){
		static
		if(!opt){
			var:=[]
			Gui,% this.win ":Submit",Nohide
			for a,b in this.var
				var[a]:=%a%
			return var
		}
		Gui,% this.win ":Add",% opt.1,% opt.2 " hwndhwnd",% opt.3
		return hwnd
	}
	save(win){
		if(win)
			SaveGUI(win)
	}
	show(name:="",nopos:=0){
		Gui,% this.win ":Show",Hide AutoSize
		Gui,% this.win ":+MinSize"
		pos:=winpos(this.win),w:=pos.w,h:=pos.h,flip:={x:"w",y:"h"},GuiKeep.keep[this.win]:=this
		for control,b in this.con{
			obj:=this.gui[control]:=[]
			for c,d in StrSplit(b.pos)
				(d~="w|h")?(obj[d]:=b[d]-%d%):(d~="x|y")?(val:=flip[d],obj[d]:=b[d]-%val%)
		}
		pos:=settings.ssn("//gui/position[@window='" this.win "']").text,pos:=pos?pos:center(this.win),showpos:=nopos?"AutoSize":pos
		Gui,% this.win ":Show",%showpos%,%name%
		if(!this.Resize)
			Gui,% this.win ":Show",AutoSize
		v.activate:=this.win
		SetTimer,activate,-200
		return
		activate:
		WinActivate,% hwnd([v.activate])
		return
	}
	__Get(){
		return this.addctrl()
	}
	Destroy(){
		hwnd({rem:this.win})
	}
	current(win){
		return GuiKeep.keep[win]
	}
}
Highlight_to_Matching_Brace(){
	sc:=csc()
	if((start:=sc.2353(sc.2008-1))>0)
		return sc.2160(start,sc.2008)
	Else if((start:=sc.2353(sc.2008))>0)
		sc.2160(start+1,sc.2008)
}
History(file=""){
	static history:=new XML("history")
	GetPos()
	for a,b in ["forward","back"]
		if(!%b%:=history.ssn("//" b))
			%b%:=history.add(b)
	if(file.back){
		if(sn(back,"*").length=1)
			return
		forward.AppendChild(back.LastChild()),last:=back.LastChild(),ea:=xml.ea(last)
		tv(files.ssn("//main[@file='" ea.parent "']/descendant::file[@file='" ea.file "']/@tv").text,1,1)
	}else if(file.forward){
		if(!sn(forward,"*").length)
			return
		last:=forward.LastChild(),ea:=xml.ea(last),tv(files.ssn("//main[@file='" ea.parent "']/descendant::file[@file='" ea.file "']/@tv").text,1,1),back.AppendChild(last)
	}else{
		forward.ParentNode.RemoveChild(Forward),ea:=xml.ea(back.LastChild())
		if(ea.file!=file)
			history.under(back,"file",{parent:Current(2).file,file:file})
	}
	return
	Back:
	Forward:
	att:=[],att[A_ThisLabel]:=1,History(att)
	return
}
hk(win){
	hk:=menus.sn("//*[@hotkey!='']|//*[@clean!='omni_search']")
	list:=[]
	while,(ea:=xml.ea(hk.item[A_Index-1])).clean{
		if(!ea.Hotkey)
			Continue
		if(win!=1)
			if(RegExMatch(ea.clean,"i)\b(Run|Run_As_Ansii|Run_As_U32|Run_As_U64|save|Debug_Current_Script)\b"))
				Continue
		List[ea.hotkey]:=ea.clean
	}
	hotkeys([win],list)
}
hltline(){
	if(!settings.ssn("//options/@Highlight_Current_Area").text)
		return
	sc:=csc(),tab:=sc.2121,line:=sc.2166(sc.2008),sc.2045(2),sc.2045(3)
	if(sc.2127(line)>0){
		up:=down:=line,ss:=sc.2127(line)-tab
		while,sc.2127(--line)!=ss
			up:=line
		while,sc.2127(++line)!=ss
			down:=line
		if(up=down){
			up--
			sc.2043(up,2),sc.2043(down,3)
		}Else{
			down+=2,up-=1
			if(down-up>0)
				Loop,% down-up
				{
					if(up=sc.2166(sc.2008))
						sc.2043(up,3)
					Else
						sc.2043(up,2)
					up++
				}
		}
	}
	return
}
Hotkeys(win,item,track:=0){
	static last:=[],current
	if(track)
		while,off:=last.pop(){
			Hotkey,IfWinActive,% hwnd([off.win])
			Hotkey,% off.key,Off
			v.hotkeyobj.Delete(off.key)
		}
	for key,label in item{
		label:=clean(label)
		if(IsFunc(label))
			launch:="function"
		if(IsLabel(label))
			launch:=label
		if(launch=""&&key)
			launch:="pluginlaunch"
		for a,b in win{
			if(!hwnd(b))
				Break
			Hotkey,IfWinActive,% hwnd([b])
			Hotkey,%key%,%launch%,On
			if(track)
				last.push({win:b,key:key})
		}launch:=""
		v.hotkeyobj[key]:=label
	}
	Hotkey,IfWinActive
	return
	hotkey:
	ControlFocus,Edit1,% hwnd([1])
	return
	function:
	func:=v.hotkeyobj[A_ThisHotkey]
	if(InStr(A_ThisHotkey,"!")&&func~="i)run|test_plugin")
		for a,b in StrSplit(A_ThisHotkey)
			DllCall("keybd_event",int,GetKeyVK(key:=b="!"?"Alt":b),int,0,int,2,int,0)
	if(IsFunc(func))
		%Func%()
	else
		func:=RegExReplace(A_ThisHotkey,"\W"),%func%()
	return
	pluginlaunch:
	if(InStr(A_ThisHotkey,"!"))
		for a,b in StrSplit(A_ThisHotkey)
			DllCall("keybd_event",int,GetKeyVK(key:=b="!"?"Alt":b),int,0,int,2,int,0)
	current:=A_ThisHotkey
	func:=v.pluginobj[current]
	if(IsFunc(func))
		return %func%()
	ea:=menus.ea("//*[@hotkey='" current "']")
	if(ea.plugin){
		if(!FileExist(ea.plugin))
			MissingPlugin(ea.plugin,ea.clean)
		else
			Run,% Chr(34) ea.plugin Chr(34) " " Chr(34) ea.option Chr(34)
	}else if(IsLabel(ea.clean)||IsFunc(ea.clean))
		SetTimer,% ea.clean,-10
	return
}
hwnd(win,hwnd=""){
	static window:=[]
	if(win="get")
		return window
	if(win.rem){
		GUIKeep.save(win.rem)
		Gui,1:-Disabled
		if(!window[win.rem])
			Gui,% win.rem ":Destroy"
		Else
			DllCall("DestroyWindow",uptr,window[win.rem])
		window[win.rem]:=""
		WinActivate,% hwnd([1])
	}
	if(IsObject(win))
		return "ahk_id" window[win.1]
	if(!hwnd)
		return window[win]
	window[win]:=hwnd
}
Index_Current_File(){
	code_explorer.scan(current()),code_explorer.Refresh_Code_Explorer()
}
Index_Lib_Files(){
	SplitPath,A_AhkPath,,ahkdir
	ahkdir.="\lib\",temp:=new xml("lib"),allfiles:=[],rem:=cexml.ssn("//lib"),rem.ParentNode.RemoveChild(rem)
	for a,b in [A_MyDocuments "\AutoHotkey\Lib\",ahkdir]{
		pos:=1,rem:=no.ssn("//bad"),rem.ParentNode.RemoveChild(rem),notop:=no.add("bad")
		Loop,%b%*.ahk{
			next:=temp.add("main",{file:A_LoopFileFullPath},,1),file:=FileOpen(A_LoopFileFullPath,0,"UTF-8"),text:=file.Read(file.length),file.close(),pos:=1,text:="`n" RegExReplace(text,"\R","`n"),fff:=allfiles[A_LoopFileFullPath]:=[],fff.text:=text
			while,RegExMatch(text,"OUm`r)\n\s*(\x2F\x2A.*\x2A\x2F)",found,pos),pos:=found.pos(1)+found.len(1)
				no.under(notop,"bad",{min:found.pos(1)-1,max:found.pos(1)+found.len(1)-1,type:"comment"})
			pos:=1
			while,RegExMatch(text,Code_Explorer.class,found,pos),pos:=found.Pos(1)+found.len(1)
				if(!no.ssn("//bad[@min<" found.pos(1) " and @max>" found.pos(1) "]"))
					temp.under(next,"info",{type:"Class",opos:found.Pos(1),pos:ppp:=StrPut(SubStr(text,1,found.Pos(1)),"utf-8")-3,text:RegExReplace(found.1,"i)^(class|\s)"),upper:upper(RegExReplace(found.1,"i)(class|\s)"))})
	}}clist:=temp.sn("//*[@type='Class']")
	while,cc:=clist.item[A_Index-1],ea:=xml.ea(cc){
		text:=allfiles[ssn(cc.ParentNode,"@file").text].text,text:=RegExReplace(text,"\R","`n"),tt:=SubStr(text,ea.opos-1),total:="",braces:=0,start:=0
		for a,b in StrSplit(tt,"`n"){
			line:=Trim(RegExReplace(b,"(\s+" Chr(59) ".*)")),total.=b "`n"
			if(SubStr(line,0,1)="{")
				braces++,start:=1
			if(SubStr(line,1,1)="}"){
				while,((found1:=SubStr(line,A_Index,1))~="(}|\s)"){
					if(found1~="\s")
						Continue
					braces--
			}}if(start&&braces=0)
			break
		}
		total:=Trim(total,"`n"),cc.SetAttribute("end",np:=ea.pos+StrPut(total,"utf-8")-1)
		for a,b in {Property:Code_Explorer.property,Method:Code_Explorer.function}{
			pos:=1
			while,RegExMatch(total,b,found,pos),pos:=found.Pos(1)+found.len(1)
				if(no.ssn("//bad[@min<'" ea.pos+found.pos(1) "' and @max>'" ea.pos+found.pos(1) "']")=""&&found.1!="if")
					add:=a="property"?"[":"(",temp.under(cc,"info",{type:a,pos:ea.pos+StrPut(SubStr(text,1,found.Pos(1)),"utf-8")-2,text:found.1,upper:upper(found.1),args:found.value(3),class:ea.text})
	}}main:=temp.sn("//main")
	while,mm:=main.item[A_Index-1],ea:=xml.ea(mm),text:=allfiles[ea.file].text,pos:=1
		while,RegExMatch(text,Code_Explorer.function,found,pos),pos:=found.Pos(1)+found.len(1)
			if(!ssn(mm,"*[@opos<'" found.pos(1) "' and @end>'" found.pos(1) "']")&&found.1!="if")
				temp.under(mm,"info",{args:found.3,type:"Function",text:found.1,upper:upper(found.1),pos:strput(substr(text,1,found.pos(1)))-3})
	all:=temp.sn("//info[@type='Function' or @type='Class']/@text"),sort:=[]
	while,aa:=all.item[A_Index-1]
		sort[aa.text]:=1
	for a in sort
		v.keywords[SubStr(a,1,1)].=a " "
	cexml.ssn("//*").AppendChild(temp.ssn("//lib"))
}
InputBox(parent,title,prompt,default=""){
	WinGetPos,x,y,,,ahk_id%parent%
	sc:=csc(),RegExReplace(prompt,"\n","",count),count:=count+2,sc:=csc(),height:=(sc.2279(0)*count)+(v.caption*3)+23+34,y:=((cpos:=sc.2165(0,sc.2008))<height)?y+cpos+sc.2279(sc.2166(sc.2008))+5:y
	InputBox,var,%title%,%prompt%,,,%height%,%x%,%y%,,,%default%
	if(ErrorLevel)
		Exit
	return var
}
Insert_Code_Vault_Text(){
	list:=vault.sn("//code"),vaultlist:="",sc:=csc()
	while,ll:=list.item[A_Index-1]
		vaultlist.=ssn(ll,"@name").text "-"
	vaultlist:=Trim(vaultlist,"-")
	Sort,vaultlist,D-
	sc.2117(2,Trim(RegExReplace(vaultlist,"-"," ")))
}
Jump_to_Segment(){
	if(!hwnd(20))
		return omni_search("^")
	return	
}
Jump_To_First_Available(){
	sc:=csc(),line:=sc.getline(sc.2166(sc.2008))
	if(RegExMatch(line,"Oim`n)^\s*#include\s*(.*)\s*;$",found)){
		Jump_To_Include()
	}else{
		word:=Upper(sc.getword()),dup:=[]
		if(!(list:=cexml.sn("//main[@file='" current(2).file "']/descendant::*[@upper='" word "']")).length)
			list:=cexml.sn("//main[@file='" current(2).file "']/descendant::*[@upper='" SubStr(word,2) "']")
		if((v.firstlist:=list).length=1)
			cexmlsel(v.firstlist.item[0])
		else{
			while,ll:=v.firstlist.item[A_Index-1],ea:=xml.ea(ll)
				if(!dup[ea.type])
					total.=ea.type " ",dup[ea.type]:=1
			if(total:=Trim(total))
				sc.2660(0),sc.2117(6,total),sc.2660(1)
}}}Jump_To(type){
	sc:=csc(),line:=sc.getline(sc.2166(sc.2008)),word:=Upper(sc.getword())
	if(node:=cexml.ssn("//main[@file='" current(2).file "']/descendant::*[@type='" type "' and @upper='" word "']"))
		cexmlsel(node)
}Jump_To_Function(){
	Jump_To("Function")
}Jump_To_Include(){
	sc:=csc(),line:=sc.getline(sc.2166(sc.2008))
	if(RegExMatch(line,"Oim`n)^\s*#include\s*(.*)\s*;$",found))
		if(node:=cexml.ssn("//main[@file='" current(2).file "']/descendant::file[@name='" Trim(found.1,"`t, ") "']"))
			tv(files.ssn("//main[@file='" current(2).file "']/descendant::file[@file='" ssn(node,"@file").text "']/@tv").text)
}Jump_To_Label(){
	Jump_To("Label")
}Jump_To_Method(){
	Jump_To("Method")
}Jump_To_Class(){
	Jump_To("Class")
}cexmlsel(node){
	if(!IsObject(node))
		return
	sc:=csc(),main:=xml.ea(ssn(node,"ancestor::main")),file:=xml.ea(ssn(node,"ancestor::file")),ea:=xml.ea(node),tv(files.ssn("//main[@file='" main.file "']/descendant::file[@file='" file.file "']/@tv").text)
	Sleep,200
	sc.2160(ea.pos,ea.pos+StrLen(ea.text))
}
Keywords(){
	commands:=new xml("commands","lib\commands.xml"),list:=settings.sn("//commands/*"),top:=commands.ssn("//Commands/Commands")
	cmd:=Custom_Commands.sn("//Commands/commands"),col:=Custom_Commands.sn("//Color/*"),con:=Custom_Commands.sn("//Context/*")
	while,new:=cmd.item[A_Index-1].clonenode(1){
		if(old:=commands.ssn("//Commands/commands[text()='" new.text "']"))
			commands.ssn("//Commands/Commands").replaceChild(new,old)
		else
			commands.ssn("//Commands/Commands").AppendChild(new)
	}
	while,new:=col.item[A_Index-1].clonenode(1){
		if(replace:=commands.ssn("//Color/" new.nodename))
			commands.ssn("//Color").replaceChild(new,replace)
		else
			commands.ssn("//Color").AppendChild(new)
	}
	while,new:=con.item[A_Index-1].clonenode(1){
		if(Replace:=commands.ssn("//Context/" new.nodename))
			commands.ssn("//Context").replaceChild(new,Replace)
		else
			commands.ssn("//Context").AppendChild(new)
	}
	v.keywords:=[],v.kw:=[],v.custom:=[],colors:=commands.sn("//Color/*")
	while,color:=colors.item[A_Index-1]{
		text:=color.text,all.=text " "
		stringlower,text,text
		v.color[color.nodename]:=text
	}personal:=settings.ssn("//Variables").text,all.=personal
	StringLower,per,personal
	v.color.Personal:=Trim(per),v.indentregex:=RegExReplace(v.color.indent," ","|"),command:=commands.ssn("//Commands/Commands").text,extra:=Custom_Commands.sn("//Context/*")
	while,ee:=extra.item[A_Index-1]
		command.=" " ee.nodename
	Sort,command,UD%A_Space%
	Sleep,4
	Loop,Parse,command,%A_Space%,%A_Space%
		v.kw[A_LoopField]:=A_LoopField,all.=" " A_LoopField
	Sort,All,UD%A_Space%
	list:=settings.ssn("//custom_case_settings").text
	for a,b in StrSplit(list," ")
		all:=RegExReplace(all,"i)\b" b "\b",b)
	Loop,Parse,all,%a_space%
		v.keywords[SubStr(A_LoopField,1,1)].=A_LoopField " "
	v.all:=all,v.context:=[],list:=commands.sn("//Context/*")
	while,ll:=list.item[A_Index-1]{
		cl:=RegExReplace(ll.text," ","|")
		Sort,cl,UD|
		v.context[ll.NodeName]:=cl
	}
	return
}
lastfiles(){
	rem:=settings.ssn("//last"),rem.ParentNode.RemoveChild(rem)
	for a,b in s.main{
		file:=files.ssn("//*[@sc='" b.2357 "']/@file").text
		if(file)
			settings.add("last/file",,file,1)
	}
}
LButton(){
	if(!GetKeyState("LButton","P"))
		MouseClick,Left,,,,,U
	if(WinActive(hwnd([20]))){
		MouseGetPos,,,win
		if(win!=hwnd(20))
			hwnd({rem:20})
	}
}
ListVars(){
	List_Variables:
	if(v.dbgsock=""&&x=0)
		return m("Currently no file being debugged"),debug.off()
	v.ddd.send("context_get -c 1")
	return
}
LV_Select(win,add){
	Gui,%win%:Default
	next:=LV_GetNext()+Add
	LV_Modify(next>0&&next<=LV_GetCount()?next:LV_GetNext(),"Select Vis Focus")
}
Margin_Left(set:=0){
	sc:=csc()
	if(set){
		sc.2155(0,Round(settings.ssn("//marginleft").text))
		return
	}
	margin:=sc.2156(),number:=InputBox(sc.sc,"Left Margin","Enter a new value for the left margin",margin!=""?margin:6)
	if(number="")
		return
	settings.add("marginleft","",number),Margin_Left(1)
}
MarginWidth(sc=""){
	sc:=sc?sc:sc:=csc(),sc.2242(0,sc.2276(32,"a" sc.2154))
}
Menu(menuname:="main"){
	v.available:=[],menu:=menus.sn("//" menuname "/descendant::*"),topmenu:=menus.sn("//" menuname "/*"),v.hotkeyobj:=[],track:=[],exist:=[],Exist[menuname]:=1
	Menu,%menuname%,UseErrorLevel,On
	while,mm:=topmenu.item[A_Index-1],ea:=xml.ea(mm)
		if(mm.haschildnodes())
			Menu,% ea.name,DeleteAll
	Menu,%menuname%,DeleteAll
	while,aa:=menu.item[A_Index-1],ea:=xml.ea(aa),pea:=xml.ea(aa.ParentNode){
		parent:=pea.name?pea.name:menuname
		if(ea.hide)
			Continue
		if(!aa.haschildnodes()){
			if(aa.nodename="separator"){
				Menu,%parent%,Add
				Continue
			}
			if((!IsFunc(ea.clean)&&!IsLabel(ea.clean))&&!ea.plugin){
				aa.SetAttribute("no",1),fixlist.=ea.clean "`n"
				Continue
			}if(ea.no)
				aa.RemoveAttribute("no")
			exist[parent]:=1
		}v.available[ea.clean]:=1
		(aa.haschildnodes())?(track.push({name:ea.name,parent:parent,clean:ea.clean}),route:="deadend"):(route:="MenuRoute")
		if(ea.hotkey)
			v.hotkeyobj[ea.hotkey]:=ea.clean
		hotkey:=ea.hotkey?"`t" convert_hotkey(ea.hotkey):""
		Menu,%parent%,Add,% ea.name hotkey,menuroute
		if(value:=settings.ssn("//*/@" ea.clean).text){
			v.options[ea.clean]:=value
			Menu,%parent%,ToggleCheck,% ea.name hotkey
		}if(ea.icon!=""&&ea.filename)
			Menu,%Parent%,Icon,% ea.name hotkey,% ea.filename,% ea.icon
	}
	for a,b in track{
		if(!Exist[b.name])
			Menu,% b.parent,Delete,% b.name
		Menu,% b.parent,Add,% b.name,% ":" b.name
	}
	hotkeys([1],v.hotkeyobj,1)
	Gui,1:Menu,%menuname%
	return menuname
	MenuRoute:
	item:=clean(A_ThisMenuItem),ea:=menus.ea("//*[@clean='" item "']"),plugin:=ea.plugin,option:=ea.option
	if(plugin){
		if(!FileExist(plugin))
			MissingPlugin(plugin,item)
		else{
			SplitPath,plugin,,dir
			Run,"%plugin%" %option%,%dir%
		}
		return
	}
	if(IsFunc(item))
		%item%()
	else
		SetTimer,%item%,-1
	return
	show:
	WinActivate,% hwnd([1])
	return
}
MenuWipe(x:=0){
	all:=menus.sn("//*")
	while,aa:=all.item[A_Index-1],ea:=xml.ea(aa){
		parent:=ssn(aa.ParentNode,"@name").text,hotkey:=ssn(aa,"@hotkey").text,hotkey:=hotkey?"`t" convert_hotkey(hotkey):"",current:=ssn(aa,"@name").text
		Menu,%parent%,Delete,% current hotkey
	}
 	while,aa:=all.item[A_Index-1],ea:=xml.ea(aa)
		if(aa.haschildnodes())
			Menu,main,Delete,% ea.name
	if(x)
		Gui,1:Menu
	Sleep,100
}
MissingPlugin(file,menuname){
	SplitPath,file,filename,dir
	if(dir="plugins"&&!FileExist(file)){
		if(m("This requires a plugin that has not been downloaded yet, Download it now?","btn:yn")="yes"){
			UrlDownloadToFile,https://raw.githubusercontent.com/maestrith/AHK-Studio-Plugins/master/%filename%,%file%
			option:=menus.ssn("//*[@clean='" RegExReplace(menuname," ","_") "']/@option").text
			Refresh_Plugins()
			Run,%file% "%option%"
		}else
			return m("Unable to run this option.")
	}
}
Move_Selected_Lines_Down(){
	GuiControl,1:-Redraw,% csc().sc
	csc().2621
	if(v.options.full_auto)
		newindent(1)
	GuiControl,1:+Redraw,% csc().sc
}
Move_Selected_Lines_Up(){
	sc:=csc()
	;GuiControl,1:-Redraw,% sc.sc
	csc().2620
	if(v.options.full_auto)
		newindent(1)
	GuiControl,1:+Redraw,% sc.sc
}
Move_Selected_Word_Left(){
	sc:=csc(),pos:=PosInfo()
	if(pos.start!=pos.end){
		wordstart:=sc.2266(pos.start,1),indent:=sc.2128(pos.line)
		if(wordstart!=pos.start)
			text:=sc.getseltext(),sc.2645(pos.start,pos.end-pos.start),sc.2003(wordstart,[text]),sc.2160(wordstart,wordstart+(pos.end-pos.start))
		if(wordstart<=indent)
			return
		if(RegExMatch(Chr(sc.2007(pos.start-1)),"\s|\W"))
			text:=sc.getseltext(),sc.2645(pos.start,pos.end-pos.start),sc.2003(pos.start-1,[text]),sc.2160(pos.start-1,pos.start-1+(pos.end-pos.start))
}}
Move_Selected_Word_Right(){
	sc:=csc(),pos:=PosInfo()
	if(pos.start!=pos.end){
		wordend:=sc.2267(pos.end,1)
		if(wordend!=pos.end)
			sc.2003(wordend,[sc.getseltext()]),sc.2160(wordend,wordend+(pos.end-pos.start)),sc.2645(pos.start,pos.end-pos.start)
		else if(pos.end=sc.2136(pos.line))
			sc.2003(pos.start," "),sc.2160(pos.start+1,pos.start+1+(pos.end-pos.start))
		else if(RegExMatch(Chr(sc.2007(pos.end)),"\s|\W"))
			sc.2003(pos.end+1,[sc.getseltext()]),sc.2160(pos.end+1,pos.end+1+(pos.end-pos.start)),sc.2645(pos.start,pos.end-pos.start)
}}
t(x*){
	for a,b in x
		list.=b "`n"
	Tooltip,% list
}
m(x*){
	static list:={btn:{oc:1,ari:2,ync:3,yn:4,rc:5,ctc:6},ico:{"x":16,"?":32,"!":48,"i":64}}
	list.title:="AHK Studio",list.def:=0,list.time:=0,value:=0
	for a,b in x
		obj:=StrSplit(b,":"),(vv:=List[obj.1,obj.2])?(value+=vv):(list[obj.1]!="")?(List[obj.1]:=obj.2):txt.=b "`n"
	MsgBox,% (value+262144+(list.def?(list.def-1)*256:0)),% list.title,%txt%,% list.time
	for a,b in {OK:value?"OK":"",Yes:"YES",No:"NO",Cancel:"CANCEL",Retry:"RETRY"}
		IfMsgBox,%a%
			return b
}
New_Caret(add){
	sc:=csc(),cpos:=sc.2008,line:=sc.2166(cpos),column:=sc.2129(cpos),new:=sc.2456(line+add,column)
	Loop,% sc.2570
		if(sc.2166(sc.2577(A_Index-1))=line+add)
			return sc.2574(A_Index-1)
	sc.2573(new,new)
}
New_Caret_Above(){
	New_Caret(-1)
}
New_Caret_Below(){
	New_Caret(1)
}
New_File_Template(){
	newwin:=new GUIKeep(28),newwin.add("Edit,w500 r30,,wh","Button,gnftdefault,Default Template,y"),newwin.show("New File Template")
	if(template:=settings.ssn("//template").text)
		ControlSetText,Edit1,%template%,% hwnd([28])
	else
		goto,nftdefault
	return
	28GuiEscape:
	28GuiClose:
	ControlGetText,edit,Edit1,% hwnd([28])
	settings.Add("template",,edit),hwnd({rem:28})
	return
	nftdefault:
	FileRead,template,c:\windows\shellnew\template.ahk
	ControlSetText,Edit1,%template%,% hwnd([28])
	return
}
New_Scintilla_Window(file=""){
	sc:=csc(),GetPos(),doc:=current(3).sc,sc:=new s(1,{main:1,hide:1}),csc({hwnd:sc.sc})
	if(doc)
		sc.2358(0,doc),SetPos(doc)
	sc.2400(),sc.show(),Resize("rebar")
}
New_Segment(new:="",text:="",adjusted:=""){
	if(current(2).untitled)
		return m("You can not add Segments to untitled documents.  Please save this project before attempting to add Segments to it.")
	cur:=adjusted?adjusted:current(2).file,sc:=csc(),parent:=mainfile:=current(2).file
	SplitPath,cur,,dir
	maindir:=dir
	if(!new){
		FileSelectFile,new,s,%dir%,Create a new Segment,*.ahk
		if(ErrorLevel)
			return
		new:=new~="\.ahk$"?new:new ".ahk"
		if(FileExist(new))
			return m("File Already Exists.","Please create a new file")
		SplitPath,new,filename,dir,,func
	}
	if(node:=ssn(current(1),"descendant::file[@file='" new "']"))
		return tv(ssn(node,"@tv").Text)
	SplitPath,new,file,newdir,,function
	Gui,1:Default
	Relative:=RegExReplace(relativepath(cur,new),"i)^lib\\([^\\]+)\.ahk$","<$1>")
	if(v.options.Includes_In_Place=1)
		sc.2003(sc.2008,"#Include " relative)
	else{
		if(files.ssn("//*[@sc='" sc.2357 "']/@file").text=current(2).file)
			sc.2003(sc.2006,"`n#Include " Relative)
		else
			maintext:=Update({get:current(2).file}),update({file:current(2).file,text:maintext "`n#Include " Relative})
	}
	func:=clean(func)
	SplitPath,newdir,last
	FileAppend,% m("Create Function Named " clean(function) "?","btn:yn")="yes"?clean(function) "(){`r`n`r`n}":"",%new%,UTF-8
	Refresh_Current_Project(new)
	Sleep,300
	sc.2025(StrLen(function)+1),NewIndent()
}
New(filename:="",text:=""){
	ts:=settings.ssn("//template").text,file:=FileOpen("c:\windows\shellnew\template.ahk",0),td:=file.Read(file.length),file.close(),template:=ts?ts:td
	if(v.options.New_File_Dialog){
		FileSelectFile,filename,S16,,Enter a filename for a new project,*.ahk
		if(!filename)
			return
		filename:=SubStr(filename,-3)=".ahk"?filename:filename ".ahk"
		if(FileExist(filename))
			return tv(Open(filename))
	}else
		filename:=(list:=files.sn("//main[@untitled]").length)?"Untitled" list ".ahk":"Untitled.ahk"
	update({file:filename,text:template})
	top:=files.ssn("//*")
	main:=files.under(top,"main",{file:filename,untitled:1})
	files.under(main,"file",{tv:tv:=TV_Add(filename),file:filename,filename:filename,github:filename,untitled:1})
	top:=cexml.add("main",{file:filename},,1)
	scan:=cexml.under(top,"file",{file:filename,type:"File",name:filename,text:filename,dir:"Virtual",order:"name,type,dir"})
	tv(tv)
	update("updated").Delete(filename)
}
NewLines(text){
	for a,b in {"``n":"`n","``r":"`n","``t":"`t","\r":"`n","\t":"`t","\n":"`n"}
		StringReplace,text,text,%a%,%b%,All
	return text
}
Next_File(){
	Default("TreeView","SysTreeView321"),TV_Modify(TV_GetNext(TV_GetSelection(),"F"),"Select Vis Focus")
}
Next_Found(){
	sc:=csc(),sc.2606,sc.2169,CenterSel()
}
Notes(NoActivate:=0){
	static lastfile
	last:=current(3).file,parent:=current(2).file
	if(last=""&&parent="")
		return m("Please create or open a file before making notes")
	if(!FileExist("notes"))
		FileCreateDir,Notes
	SplitPath,parent,filename,,,nne
	if(!note:=notesxml.ssn("//note[@file='" current(2).file "']"))
		note:=notesxml.under(notesxml.ssn("//notes"),"note",{file:current(2).file})
	if(note.text){
		FileAppend,% note.text,Notes\%nne%.txt
		note.text:=""
	}main:=main:=files.ssn("//main[@file='" parent "']/descendant::*[@note='1']"),ea:=xml.ea(main)
	if(!main)
		main:=files.ssn("//file[@file='" parent "']"),mm:=xml.ea(main),files.under(main,"file",{note:1,file:A_ScriptDir "\notes\" nne ".txt",filename:filename,tv:(tv:=TV_Add(nne ".txt",mm.tv))}),text:=FileOpen(A_ScriptDir "\notes\" nne ".txt","r"),update({file:A_ScriptDir "\notes\" nne ".txt",text:RegExReplace(text.Read(text.length),"\R","`n"),load:1}),tv(tv,1)
	else if(current(3).file=A_ScriptDir "\notes\" nne ".txt")
		tv(files.ssn("//file[@file='" lastfile "']/@tv").text)
	else
		tv(ea.tv)
	lastfile:=last
}
Notify(csc:=""){
	notify:
	static last,lastline,lastpos:=[],focus:=[],dwellfold:="",spam
	if(csc=0)
		return lastpos:=[]
	fn:=[],info:=A_EventInfo,code:=NumGet(info+(A_PtrSize*2))
	if(NumGet(info+0)=v.debug.sc&&v.debug.sc)
		return
	if(info=256||info=512||info=768)
		return
	sc:=csc()
	if(code=2028){
		if(v.options.Check_For_Edited_Files_On_Focus=1)
			Check_For_Edited()
		MouseGetPos,,,win
		if(win=hwnd(1))
			SetTimer,LButton,-20
		csc({hwnd:NumGet(info+0)})
		return
	}if(!s.ctrl[NumGet(info+0)])
		return csc(1)
	if code not in 2001,2005,2002,2004,2006,2007,2008,2010,2014,2018,2019,2021,2022,2027,2011
		return 0
	;0:"Obj",2:"Code",4:"ch",6:"modType",7:"text",8:"length",9:"linesadded",10:"msg",11:"wparam",12:"lparam",13:"line",14:"fold",17:"listType",22:"updated"
	for a,b in {0:"Obj",2:"Code",3:"position",4:"ch",5:"mod",6:"modType",7:"text",8:"length",9:"linesadded",10:"msg",11:"wparam",12:"lparam",13:"line",14:"fold",15:"prevfold",17:"listType",22:"updated"}
		fn[b]:=NumGet(Info+(A_PtrSize*a))
	if(code=2006){
		if((match:=sc.2353(pos:=fn.position))>0){
			if(pos>match)
				match++
			else
				pos++
			sc.2160(pos,match)
		}else if((match:=sc.2353(pos:=fn.position-1))>0){
			if(pos>match)
				match++
			else
				pos++
			sc.2160(pos,match)
		}
		/*
			t("lol tidbit")
		*/
	}
	if(code="2008"){
		if(sc.2423=3&&sc.2570>1){
			list:=[]
			Loop,% sc.2570
				list.push({caret:sc.2577(A_Index-1),anchor:sc.2579(A_Index-1)})
			for a,b in list{
				if(A_Index=1)
					sc.2160(b.anchor,b.caret)
				else
					sc.2573(b.caret,b.anchor)
			}
		}
	}
	/*
		if(fn.ch=32){
		;this is also where you would check for new words
			t(word)
		}
	*/
	if(fn.code=2002){
		ea:=files.ea("//*[@sc='" sc.2357 "']"),file:=ea.file,updated:=update("get").2,updated.Delete(ea.file)
		SplitPath,file,,,,nne
		TV_Modify(ea.tv,"",v.options.Hide_File_Extensions?nne:ea.filename)
	}if(fn.code=2010){
		margin:=NumGet(Info+(A_PtrSize*16)),line:=sc.2166(fn.position)
		if(margin=3)
			sc.2231(line)
		if(margin=1){
			shift:=GetKeyState("Shift","P"),ShiftBP:=v.options.Shift_Breakpoint,text:=Trim(sc.getline(line)),search:=(shift&&ShiftBP||!shift&&!ShiftBP)?["*","UO)(\s*;\*\[.*\])"]:["#","UO)(\s*;#\[.*\])"]
			if(RegExMatch(text,search.2))
				start:=sc.2128(line),pos:=RegExMatch(text,search.2,found),sc.2190(start+pos-1),sc.2192(start+pos-1+found.len(1)),sc.2194(0,""),code_explorer.scan(current())
			else
				AddBookmark(line,search)
		}
	}if(fn.code=2022){
		if v.options.Autocomplete_Enter_Newline
			SetTimer,sendenter,100
		Else{
			v.word:=StrGet(fn.text,"utf-8") ;this is also where you would check for new words
			if(v.word="#Include"&&v.options.Disable_Include_Dialog!=1)
				SetTimer,getinclude,-200
			else if(v.word~="i)(goto|gosub)")
				SetTimer,goto,-100
			else if(v.word="settimer")
				SetTimer,showlabels,-80
			else if(syntax:=commands.ssn("//Commands/commands[text()='" v.word "']/@syntax").text){
				if(SubStr(syntax,1,1)="(")
					SetTimer,AutoParen,-40
				else
					SetTimer,automenu,-100
				return
				AutoParen:
				if(sc.2007(sc.2008-1)!=40&&sc.2007(sc.2008)!=40)
					sc.2003(sc.2008,"()"),sc.2025(sc.2008+1)
				if(sc.2007(sc.2008)=40)
					sc.2025(sc.2008+1)
				return
			}else
				SetTimer,automenu,-100
		}
	}if(code=2007)
		uppos()
	if(fn.code=2001){
		if(fn.ch=46)
			if(fn.ch=46)
				Show_Class_Methods(sc.textrange(sc.2266(sc.2008-1,1),sc.2267(sc.2008-1,1)))
		if(fn.ch=10&&v.options.full_auto){
			GuiControl,1:-Redraw,% sc.sc
			if(sc.2007(sc.2008)=125&&sc.2007(sc.2008-2)=123)
				sc.2003(sc.2008,"`n")
			SetTimer,newindent,-10
			return
		}
		if(fn.ch=10&&v.options.full_auto!=1){
			SetTimer,fix_next,-50
			return
		}cpos:=sc.2008,start:=sc.2266(cpos,1),end:=sc.2267(cpos,1),word:=sc.textrange(start,sc.2008)
		if((StrLen(word)>1&&sc.2102=0&&v.options.Disable_Auto_Complete!=1)){
			if((sc.2202&&v.options.Disable_Auto_Complete_While_Tips_Are_Visible=1)||(sc.2010(cpos)~="\b(13|1|11|3)\b"=1&&v.options.Disable_Auto_Complete_In_Quotes=1)){
			}else{
				word:=RegExReplace(word,"^\d*"),list:=Trim(v.keywords[SubStr(word,1,1)]),code_explorer.varlist[current(2).file]
				if(list&&instr(list,word))
					sc.2100(StrLen(word),list)
			}
		}style:=sc.2010(sc.2008-2)
		settimer,context,-150
		c:=fn.ch
		if(c~="44|32")
			replace()
		if(fn.ch=44&&v.options.Auto_Space_After_Comma)
			sc.2003(sc.2008," "),sc.2025(sc.2008+1)
	}if(fn.code=2008){
		if(fn.modtype&0x02){
			del:=SubStr(StrGet(fn.text,"utf-8"),1,1)
			if(delete:=v.match[del]){
				if(Chr(sc.2007(sc.2008))=delete){
					SetTimer,deleteit,-0
					return
					deleteit:
					sc.2645(sc.2008,1)
					return
		}}}
		if((fn.modtype&0x01)||(fn.modtype&0x02))
			update({sc:sc.2357})
		/*
			if(fn.modtype&0x02)
				update({sc:sc.2357})
		*/
		if(fn.linesadded)
			MarginWidth(sc)
		return
	}if(fn.code=2001)
		ch:=fn.ch?fn.ch:sc.2007(sc.2008),uppos(),SetStatus("Last Entered Character: " Chr(ch) " Code:" ch,2)
	if(fn.code=2014){
		if(fn.listtype=1){
			if(!IsObject(scintilla))
				scintilla:=new xml("scintilla","lib\scintilla.xml")
			command:=StrGet(fn.text,"utf-8"),info:=scintilla.ssn("//commands/item[@name='" command "']"),ea:=xml.ea(info),start:=sc.2266(sc.2008,1),end:=sc.2267(sc.2008,1),syn:=ea.syntax?ea.code "()":ea.code,sc.2160(start,end),sc.2170(0,[syn])
			if(ea.syntax)
				sc.2025(sc.2008-1),sc.2200(start,ea.code ea.syntax)
		}Else if(fn.listType=2){
			vv:=StrGet(fn.text,"utf-8"),start:=sc.2266(sc.2008,1),end:=sc.2267(sc.2008,1),sc.2645(start,end-start),sc.2003(sc.2008,vault.ssn("//*[@name='" vv "']").text)
			if(v.options.full_auto)
				SetTimer,fullauto,-1
		}else if(fn.listType=3)
			text:=StrGet(fn.text,"utf-8") "()",start:=sc.2266(sc.2008,1),end:=sc.2267(sc.2008,1),sc.2645(start,end-start),sc.2003(sc.2008,text),sc.2025(sc.2008+StrLen(text)-1)
		else if(fn.listtype=4)
			text:=StrGet(fn.text,"utf-8"),start:=sc.2266(sc.2008,1),end:=sc.2267(sc.2008,1),sc.2645(start,end-start),sc.2003(sc.2008,text "."),sc.2025(sc.2008+StrLen(text ".")),Show_Class_Methods(text)
		else if(fn.listtype=5){
			text:=StrGet(fn.text,"utf-8"),start:=sc.2266(sc.2008,1),end:=sc.2267(sc.2008,1),add:=sc.2007(end)=40?"":"()",sc.2645(start,end-start),sc.2003(sc.2008,text add),sc.2025(sc.2008+StrLen(text "."))
			SetTimer,context,-10
		}else if(fn.listtype=6){
			text:=StrGet(fn.text,"utf-8"),list:=v.firstlist
			while,ll:=list.item[A_Index-1],ea:=xml.ea(ll){
				if(ea.type=text){
					cexmlsel(ll)
					/*
						pea:=xml.ea(ssn(ll,"ancestor::file"))
						tv(files.ssn("//main[@file='" ssn(ll,"ancestor::main/@file").text "']/descendant::file[@file='" pea.file "']/@tv").text)
						Sleep,200
						sc.2160(ea.pos,ea.pos+StrLen(ea.text))
					*/
					break
	}}}}
	return
	sendenter:
	SetTimer,sendenter,Off
	Send,{Enter}
	if(v.options.full_auto)
		SetTimer,fullauto,10
	return
	Disable:
	for a,b in s.ctrl
		GuiControl,1:-Redraw,% b.sc
	return
	Enable:
	for a,b in s.ctrl
		GuiControl,1:+Redraw,% b.sc
	return
}
ObjRegisterActive(Object,CLSID:="{DBD5A90A-A85C-11E4-B0C7-43449580656B}",Flags:=0){ ;http://ahkscript.org/boards/viewtopic.php?f=6&t=6148
	static cookieJar:={}
	if(!CLSID){
		if(cookie:=cookieJar.Remove(Object))!=""
			DllCall("oleaut32\RevokeActiveObject","uint",cookie,"ptr",0)
		return
	}
	if(cookieJar[Object])
		throw Exception("Object is already registered",-1)
	VarSetCapacity(_clsid,16,0)
	if(hr:=DllCall("ole32\CLSIDFromString","wstr",CLSID,"ptr",&_clsid))<0
		return
	hr:=DllCall("oleaut32\RegisterActiveObject","ptr",&Object,"ptr",&_clsid,"uint",Flags,"uint*",cookie,"uint")
	if(hr<0)
		return
	cookieJar[Object]:=cookie
}
Omni_Search(start=""){
	static newwin,select:=[],obj:=[],pre
	if(hwnd(20))
		return
	code_explorer.scan(current())
	WinGetPos,x,y,w,h,% hwnd([1])
	width:=w-50
	newwin:=new GUIKeep(20)
	Gui,20:Margin,0,0
	width:=w-50,newwin.Add("Edit,goss w" width " vsearch," start,"ListView,w" width " r15 -hdr -Multi gosgo,Menu Command|Additional|1|2|Rating|index")
	Gui,20:-Caption
	hotkeys([20],{up:"omnikey",down:"omnikey",PgUp:"omnikey",PgDn:"omnikey","^Backspace":"deleteback",Enter:"osgo","~LButton":"LButton"})
	Gui,20:Show,% Center(20) " AutoSize",Omni-Search
	ControlSend,Edit1,^{End},% hwnd([20])
	bm:=bookmarks.sn("//mark")
	if(top:=cexml.ssn("//bookmarks"))
		top.ParentNode.RemoveChild(top)
	top:=cexml.Add("bookmarks")
	while,bb:=bm.item[A_Index-1],ea:=bo
		okmarks.ea(bb)
	if(!cexml.ssn("//bookmark/*[@file='" ssn(bb.ParentNode,"@file").text "']"))
		cexml.under(top,"bookmark",{type:"bookmark",text:ea.name,line:ea.line,file:ssn(bb.ParentNode,"@file").text,order:"text,type,file",root:ssn(bb,"ancestor::main/@file").text})
	oss:
	break:=1
	SetTimer,omnisearch,-10
	return
	omnisearch:
	Gui,20:Default
	GuiControl,20:-Redraw,SysListView321
	osearch:=search:=newwin[].search,Select:=[],LV_Delete(),sort:=[],stext:=[],fsearch:=search="^"?1:0
	for a,b in StrSplit("@^({[&+#%<")
		osearch:=RegExReplace(osearch,"\Q" b "\E")
	if(InStr(search,"?")){
		LV_Delete()
		for a,b in omni_search_class.prefix{
			info:=a="+"?"Add Function Call":b
			LV_Add("",a,info)
		}
		GuiControl,20:+Redraw,SysListView321
		Loop,4
			LV_ModifyCol(A_Index,"AutoHDR")
		return
	}if(RegExMatch(search,"\W")){
		pos:=1,replist:=[],find1:="",index:=1
		while,RegExMatch(search,"O)(\W)",found,pos),pos:=found.Pos(1)+found.len(1){
			if(found.1=" ")
				Continue
			if(pre:=omni_search_class.prefix[found.1]){
				replist.push(found.1)
				if(found.1="+"){
					find:="//main[@file='" current(2).file "']/descendant::*[@type='Class' or @type='Function'"
					break
				}else if(pre)
					add:="@type='" pre "'"
				find1.=index>1?" or " add:add
			}index++
		}
		for a,b in replist
			search:=RegExReplace(search,"\Q" b "\E")
		find:=find1?"//*[" find1 "]":"//*"
	}else
		find:="//*"
	for a,b in searchobj:=StrSplit(search)
		stext[b]:=stext[b]=""?1:stext[b]+1
	list:=cexml.sn(find),break:=0,currentparent:=current(2).file
	while,ll:=list.Item[A_Index-1],b:=xml.ea(ll){
		if(break){
			break:=0
			break
		}
		order:=ll.nodename="file"?"name,type,folder":b.type="menu"?"text,type,additional1":"text,type,file,args",info:=StrSplit(order,","),text:=b[info.1],rating:=0,b.parent:=ssn(ll,"ancestor-or-self::main/@file").text
		if(!b.file)
			if(!b.file:=ssn(ll,"ancestor-or-self::file/@file").text)
				b.file:=ssn(ll,"ancestor-or-self::main/@file").text
		if(fsearch){
			if(b.file=ssn(ll,"ancestor::main/@file").text)
				rating+=50
			if(currentparent=b.file)
				rating+=100
		}else{
			if(search){
				for c,d in stext{
					RegExReplace(text,"i)" c,"",count)
					if(Count<d)
						Continue,2
				}spos:=1
				for c,d in searchobj
					if(pos:=RegExMatch(text,"iO)(\b" d ")",found,spos),spos:=found.Pos(1)+found.len(1))
						rating+=100/pos
				if(pos:=InStr(text,osearch))
					rating+=400/pos
				if(currentparent=ssn(ll,"ancestor::main/@file").text)
					rating+=100
			}
		}
		two:=info.2="type"&&v.options.Show_Type_Prefix?omni_search_class.iprefix[b[info.2]] "  " b[info.2]:b[info.2]
		item:=LV_Add("",b[info.1],two,b[info.3],b[info.4],rating,LV_GetCount()+1)
		Select[item]:=b
	}
	Loop,4
		LV_ModifyCol(A_Index,"Auto")
	for a,b in [5,6]
		LV_ModifyCol(b,0)
	LV_ModifyCol(5,"Logical SortDesc")
	LV_Modify(1,"Select Vis Focus")
	GuiControl,20:+Redraw,SysListView321
	return
	20GuiEscape:
	20GuiClose:
	hwnd({rem:20})
	return
	osgo:
	Gui,20:Default
	LV_GetText(num,LV_GetNext(),6),item:=Select[num],search:=newwin[].search,pre:=SubStr(search,1,1)
	if(InStr(search,"?")){
		LV_GetText(pre,LV_GetNext())
		ControlSetText,Edit1,%pre%,% newwin.id
		ControlSend,Edit1,^{End},% newwin.id
		return
	}else if(type:=item.launch){
		text:=clean(item.text)
		if(type="label")
			SetTimer,%text%,-1
		else if(type="func"){
			v.runfunc:=text
			SetTimer,runfunc,-100
		}else{
			if(!FileExist(type))
				MissingPlugin(type,item.sort)
			else{
				option:=menus.ssn("//*[@clean='" RegExReplace(item.sort," ","_") "']/@option").text
				Run,%type% "%option%"
			}
		}
		hwnd({rem:20})
	}else if(pre="+"){
		hwnd({rem:20}),args:=item.args,sc:=csc(),args:=RegExReplace(args,"U)=?" chr(34) "(.*)" chr(34)),build:=item.text "("
		for a,b in StrSplit(args,",")
			comma:=a_index>1?",":"",value:=InputBox(sc.sc,"Add Function Call","Insert a value for : " b " :`n" item.text "(" item.args ")`n" build ")",""),value:=value?value:Chr(34) Chr(34),build.=comma value
		build.=")"
		sc.2003(sc.2008,build)
	}else if(item.type="file"){
		hwnd({rem:20}),tv(files.ssn("//main[@file='" item.parent "']/descendant::file[@file='" item.file "']/@tv").text)
	}else if(item.type~="i)(breakpoint|label|instance|method|function|hotkey|class|property|variable|bookmark)"){
		hwnd({rem:20}),TV(files.ssn("//*[@file='" item.file "']/@tv").text)
		Sleep,200
		item.text:=item.type="class"?"class " item.text:item.text
		(item.type~="i)bookmark|breakpoint")?(sc:=csc(),line:=sc.2166(item.pos),sc.2160(sc.2128(line),sc.2136(line)),hwnd({rem:20}),CenterSel()):(csc().2160(item.pos,item.pos+StrPut(item.text,"Utf-8")-1),v.sc.2169,getpos(),v.sc.2400)
	}
	return
	omnikey:
	ControlSend,SysListView321,{%A_ThisHotkey%},% newwin.id
	return
	deleteback:
	GuiControl,20:-Redraw,Edit1
	Send,+^{Left}{Backspace}
	GuiControl,20:+Redraw,Edit1
	return
}
One_Backup(){
	current:=current(2).file
	SplitPath,current,,dir
	RunWait,% comspec " /C RD /S /Q " Chr(34) dir "\backup" Chr(34),,Hide
	Full_Backup()
}
Open_Folder(){
	sc:=csc()
	file:=current(3).file
	SplitPath,file,,dir
	if(!dir){
		file:=current(2).file
		SplitPath,file,,dir
	}
	Run,%dir%
}
Open(filelist="",show="",Redraw:=1){
	static root,top
	for a,b in [19,14,3,11]{
		if(hwnd(b)){
			WinGetTitle,title,% hwnd([b])
			return m("Please close the " title " window before proceeding")
		}
	}
	if(!filelist){
		openfile:=current(2).file
		SplitPath,openfile,,dir
		Gui,1:+OwnDialogs
		FileSelectFile,filename,,%dir%,,*.ahk
		if(ErrorLevel)
			return
		if(ff:=files.ssn("//main[@file='" filename "']")){
			Gui,1:Default
			tv(xml.ea(ff.firstchild).tv)
			return
		}
		if(!FileExist(filename))
			return m("File does not exist. Create a new file with File/New")
		fff:=FileOpen(filename,"RW","utf-8"),file1:=file:=fff.read(fff.length)
		gosub,addfile
		Gui,1:TreeView,SysTreeView321
		filelist:=files.sn("//main[@file='" filename "']/descendant::file"),TV(files.ea("//main[@file='" filename "']/file").tv)
		while,filename:=filelist.item[A_Index-1]
			code_explorer.scan(filename)
		code_explorer.Refresh_Code_Explorer(),PERefresh()
	}else{
		v.filescan:=[]
		WinSetTitle,% hwnd([1]),,AHK Studio - Scanning files....
		for a,b in StrSplit(filelist,"`n"){
			if(InStr(b,"'"))
				return m("Filenames and folders can not contain the ' character (Chr(39))")
			if(files.ssn("//main[@file='" b "']"))
				continue
			fff:=FileOpen(b,"RW","utf-8"),file1:=file:=fff.read(fff.length),filename:=b
			gosub,addfile
			v.filescan.Insert(b)
		}
		SetTimer,scanfiles,-1000
		return files.ssn("//main[@file='" StrSplit(filelist,"`n").1 "']/file/@tv").text,PERefresh()
		scanfiles:
		allfiles:=files.sn("//file")
		while,aa:=allfiles.item[A_Index-1]
			Code_Explorer.scan(aa)
		WinSetTitle,% hwnd([1]),,% "AHK Studio - " current(3).file
		if(v.options.Hide_Code_Explorer!=1)
			code_explorer.refresh_code_explorer()
		return
	}
	return root
	addfile:
	Gui,1:Default
	SplitPath,filename,fn,dir,,nne
	FileGetTime,time,%filename%
	GuiControl,1:+g,SysTreeView321
	GuiControl,1:-Redraw,SysTreeView321
	top:=files.add("main",{file:filename},,1),next:=files.under(top,"file",{file:filename,tv:feadd(fn,0,"icon2 First sort"),github:fn,time:time})
	Extract([filename],next,filename,1),ff:=files.sn("//file")
	if(!settings.ssn("//open/file[text()='" filename "']"))
		settings.add("open/file",,filename,1)
	Gui,1:Default
	next:=files.ssn("//main[@file='" filename "']/file[@file='" filename "']")
	if(note:=notesxml.ssn("//note[@file='" filename "']")){
		files.under(next.ParentNode,"file",{note:1,file:A_ScriptDir "\notes\" nne ".txt",filename:nne ".txt",tv:(tv:=TV_Add(nne ".txt",xml.ea(next).tv,TVIcons({get:A_ScriptDir "\notes\" nne ".txt"})))})
		FileRead,text,Notes\%nne%.txt
		update({file:A_ScriptDir "\notes\" nne ".txt",text:RegExReplace(text,"\R","`n")})
	}
	if(Redraw)
		GuiControl,1:+Redraw,SysTreeView321
	if(!v.opening)
		GuiControl,1:+gtv,SysTreeView321
	return
}
Options(x:=0){
	static list:={Virtual_Space:[2596,3],End_Document_At_Last_Line:2277,show_eol:2356,Show_Caret_Line:2096,show_whitespace:2021,word_wrap:2268,Hide_Indentation_Guides:2132,center_caret:[2403,15,75]}
	static main:="Center_Caret,Disable_Auto_Complete,Disable_Auto_Complete_While_Tips_Are_Visible,Disable_Autosave,Disable_Backup,Disable_Line_Status,Disable_Variable_List,Disable_Word_Wrap_Indicators,Force_Utf8,Hide_Code_Explorer,Hide_File_Extensions,Hide_Indentation_Guides,Hide_Project_Explorer,Remove_Directory_Slash,Show_Caret_Line,Show_EOL,Show_Type_Prefix,Show_WhiteSpace,Virtual_Space,Warn_Overwrite_On_Export,Word_Wrap,Run_As_Admin"
	static next:="Auto_Space_After_Comma,Autocomplete_Enter_Newline,Disable_Auto_Delete,Disable_Auto_Insert_Complete,Disable_Folders_In_Project_Explorer,Disable_Include_Dialog,Enable_Close_On_Save,Full_Tree,Highlight_Current_Area,Manual_Continuation_Line,Small_Icons,Top_Find"
	static bit:="Auto_Advance,Auto_Close_Find,Auto_Set_Area_On_Quick_Find,Build_Comment,Check_For_Edited_Files_On_Focus,Disable_Auto_Indent_For_Non_Ahk_Files,Full_Backup_All_Files"
	if(x)
		return {main:main,next:next,bit:bit}
	optionslist:=settings.sn("//Quick_Find_Settings/@*|//options/@*")
	while,ll:=optionslist.item[A_Index-1]
		v.options[ll.nodename]:=ll.text
	Center_Caret:
	Disable_Auto_Complete:
	Disable_Auto_Complete_While_Tips_Are_Visible:
	Disable_Autosave:
	Disable_Backup:
	Disable_Line_Status:
	Disable_Variable_List:
	Disable_Word_Wrap_Indicators:
	Force_Utf8:
	Hide_Code_Explorer:
	Hide_File_Extensions:
	Hide_Indentation_Guides:
	Hide_Project_Explorer:
	Remove_Directory_Slash:
	Show_Caret_Line:
	Show_EOL:
	Show_Type_Prefix:
	Show_WhiteSpace:
	Virtual_Space:
	Warn_Overwrite_On_Export:
	Word_Wrap:
	Run_As_Admin:
	End_Document_At_Last_Line:
	sc:=csc(),onoff:=settings.ssn("//options/@" A_ThisLabel).text?0:1,att:=[],att[A_ThisLabel]:=onoff,settings.add("options",att),togglemenu(A_ThisLabel),v.options[A_ThisLabel]:=onoff,sc[list[A_ThisLabel]](onoff),option:=settings.ssn("//options"),ea:=settings.ea(option)
	for c,d in s.main{
		for a,b in ea{
			if(!IsObject(List[a])){
				if(a="Hide_Indentation_Guides")
					b:=b?0:1
				d[list[a]](b)
				if(a="Disable_Word_Wrap_Indicators")
					d.2460(b?0:4)
			}Else if IsObject(List[a])&&b
				d[list[a].1](List[a].2,List[a].3)
			else if IsObject(List[a])&&onoff=0
				d[list[a].1](0)
		}
	}
	if(A_ThisLabel="Hide_Code_Explorer"||A_ThisLabel="Hide_Project_Explorer")
		Resize("Rebar")
	if(A_ThisLabel="Hide_Indentation_Guides")
		onoff:=onoff?0:1,sc[list[A_ThisLabel]](onoff)
	if(A_ThisLabel="Disable_Word_Wrap_Indicators")
		onoff:=onoff?0:3,sc[list[A_ThisLabel]](onoff)
	if(A_ThisLabel="Hide_File_Extensions"||A_ThisLabel=""){
		fl:=files.sn("//file")
		Gui,1:Default
		Gui,1:TreeView,SysTreeView321
		GuiControl,1:-Redraw,SysTreeView321
		while,ff:=fl.item[A_Index-1],ea:=xml.ea(ff){
			name:=ea.file
			SplitPath,name,filename,,,nne
			name:=v.options.Hide_File_Extensions?nne:filename,ff.SetAttribute("filename",name),TV_Modify(ea.tv,"",name)
		}
		GuiControl,1:+Redraw,SysTreeView321
	}if(A_ThisLabel="Remove_Directory_Slash")
		Refresh_Project_Explorer()
	if(A_ThisLabel="margin_left")
		csc().2155(0,6)
	return
	onoff:=settings.ssn("//options/@" A_ThisLabel).text?0:1,att:=[],att[A_ThisLabel]:=onoff,settings.add("options",att)
	return
	Auto_Space_After_Comma:
	Autocomplete_Enter_Newline:
	Disable_Auto_Delete:
	Disable_Auto_Insert_Complete:
	Disable_Folders_In_Project_Explorer:
	Disable_Include_Dialog:
	Enable_Close_On_Save:
	Full_Tree:
	Highlight_Current_Area:
	Manual_Continuation_Line:
	Small_Icons:
	Top_Find:
	Auto_Project_Explorer_Width:
	onoff:=settings.ssn("//options/@ " A_ThisLabel).text?0:1,att:=[],att[A_ThisLabel]:=onoff,settings.add("options",att),togglemenu(A_ThisLabel)
	if(A_ThisLabel="small_icons")
		return m("Requires that you restart Studio to take effect.")
	if(A_ThisLabel="Highlight_Current_Area"){
		if(onoff)
			hltline()
		Else
			sc:=csc(),sc.2045(2),sc.2045(3)
	}v.options[A_ThisLabel]:=onoff
	if(A_ThisLabel="top_find")
		Resize("Rebar"),RefreshThemes()
	if(A_ThisLabel~="i)Disable_Folders_In_Project_Explorer|Full_Tree")
		Refresh_Project_Explorer()
	if(A_ThisLabel="Auto_Project_Explorer_Width")
		tv(0,1)
	return
	;set bit only
	Auto_Advance:
	Auto_Close_Find:
	Auto_Set_Area_On_Quick_Find:
	Build_Comment:
	Check_For_Edited_Files_On_Focus:
	Disable_Auto_Indent_For_Non_Ahk_Files:
	Full_Backup_All_Files:
	Add_Margins_To_Windows:
	Disable_Auto_Complete_In_Quotes:
	Virtual_Scratch_Pad:
	Includes_In_Place:
	Shift_Breakpoint:
	Check_For_Update_On_Startup:
	New_File_Dialog:
	onoff:=settings.ssn("//options/@ " A_ThisLabel).text?0:1
	att:=[],att[A_ThisLabel]:=onoff,v.options[A_ThisLabel]:=onoff
	settings.add("options",att)
	togglemenu(A_ThisLabel)
	return
	Full_Auto:
	onoff:=settings.ssn("//Auto_Indent/@ " A_ThisLabel).text?0:1,att:=[],att[A_ThisLabel]:=onoff,settings.add("Auto_Indent",att),togglemenu(A_ThisLabel),v.options[A_ThisLabel]:=onoff
	return
}
Paste_Func(){
	menupaste:
	SetTimer,paste,-1
	return
	paste:
	ControlGetFocus,Focus,% hwnd([1])
	if(InStr(focus,"scintilla")){
		sc:=csc(),sc.2179
		if(v.options.full_auto)
			NewIndent()
		if(v.pastefold)
			SetTimer,foldpaste,-20
		return
	}else
		SendMessage,0x302,0,0,%focus%,% hwnd([1])
	if(v.options.full_auto)
		SetTimer,NewIndent,-1
	uppos(),MarginWidth()
	return
	foldpaste:
	v.pastefold:=0
	line:=sc.2166(sc.2008)
	sc.2231(sc.2225(line-1))
	return
}
PERefresh(){
	Gui,1:Default
	GuiControl,+Redraw,SysTreeView321
}
Personal_Variable_List(){
	static
	newwin:=new GUIKeep(6),newwin.Add("ListView,w200 h400,Variables,wh","Edit,w200 vvariable,,yw","Button,gaddvar Default,Add,y","Button,x+10 gvdelete,Delete Selected,y")
	newwin.Show("Variables",1),vars:=settings.sn("//Variables/*")
	ControlFocus,Edit1,% hwnd([6])
	while,vv:=vars.item(A_Index-1)
		LV_Add("",vv.text)
	ControlFocus,Edit1,% hwnd([6])
	return
	vdelete:
	while,LV_GetNext(){
		LV_GetText(string,LV_GetNext()),rem:=settings.ssn("//Variable[text()='" string "']")
		rem.parentnode.removechild(rem),LV_Delete(LV_GetNext())
	}
	return
	addvar:
	if(!variable:=newwin[].variable)
		return
	if(!settings.ssn("//Variables/Variable[text()='" variable "']"))
		settings.add("Variables/Variable",,variable,1),LV_Add("",variable)
	settings.Transform()
	ControlSetText,Edit1,,% hwnd([6])
	return
	6GuiClose:
	6GuiEscape:
	keywords(),hwnd({rem:6}),refreshthemes()
	return
}
Plug(refresh:=0){
	if(!FileExist("plugins"))
		FileCreateDir,Plugins
	plHks:=[]
	if(refresh){
		while,pl:=menus.sn("//menu[@clean='Plugin']/menu[@hotkey!='']").item[A_Index-1],ea:=xml.ea(pl)
			plHks[ea.name]:=ea.hotkey
		rem:=menus.ssn("//menu[@clean='Plugin']"),rem.ParentNode.RemoveChild(rem)
	}all:=menus.sn("//*[@clean]")
	while,aa:=all.item[A_Index-1],ea:=menus.ea(aa)
		if((dup:=menus.sn("//*[@clean='" ea.clean "']")).length>1)
			while,dd:=dup.item[A_Index-1]
				if(A_Index>1)
					dd.ParentNode.RemoveChild(dd)
	pin:=menus.sn("//*[@clean='Plugin']/descendant::menu")
	while,pp:=pin.item[A_Index-1],ea:=xml.ea(pp)
		if(!FileExist(ea.plugin))
			pp.ParentNode.RemoveChild(pp)
	if(!menus.sn("//*[@clean='Plugin']/descendant::menu").length)
		rem:=menus.ssn("//*[@clean='Plugin']"),rem.ParentNode.RemoveChild(rem)
	Loop,plugins\*.ahk
	{
		if(!plugin:=menus.ssn("//menu[@clean='Plugin']"))
			plugin:=menus.Add("menu",{clean:"Plugin",name:"P&lugin"},,1)
		FileRead,plg,%A_LoopFileFullPath%
		pos:=1
		while,pos:=RegExMatch(plg,"Oim)\;menu\s+(.*)\R",found,pos){
			item:=StrSplit(found.1,","),item.1:=Trim(item.1,"`r|`r`n|`n")
			if(!ii:=menus.ssn("//*[@clean='" clean(Trim(item.1)) "']"))
				menus.under(plugin,"menu",{name:Trim(item.1),clean:clean(item.1),plugin:A_LoopFileFullPath,option:item.2,hotkey:plHks[item.1]})
			else
				ii.SetAttribute("plugin",A_LoopFileFullPath),ii.SetAttribute("option",item.2)
			pos:=found.Pos(1)+1
		}
	}
	if(refresh)
		SetTimer,refreshmenu,-300
	return
	refreshmenu:
	Menu("main"),MenuWipe(),omni_search_class.Menus()
	Gui,1:Menu,% Menu("main")
	return
}
PosInfo(){
	sc:=csc(),current:=sc.2008,line:=sc.2166(current),ind:=sc.2128(line),lineend:=sc.2136(line)
	return {current:current,line:line,ind:ind,lineend:lineend,start:sc.2143,end:sc.2145}
}
Previous_File(){
	Default("TreeView","SysTreeView321"),prev:=0,tv:=TV_GetSelection()
	while,tv!=prev:=TV_GetNext(prev,"F")
		newtv:=prev
	TV_Modify(newtv,"Select Vis Focus")
}
Previous_Found(){
	sc:=csc(),current:=sc.2575,total:=sc.2570-1,(current=0)?sc.2574(total):sc.2574(--current),CenterSel()
}
Previous_Scripts(filename=""){
	static files:=[],find,newwin
	if(filename){
		if(!settings.ssn("//previous_scripts/script[text()='" filename "']"))
			settings.Add("previous_scripts/script","",filename,1)
	}Else if(filename=""){
		newwin:=new GuiKeep(21,"Edit,w400 gpss vfind,,w","ListView,w400 h300 gpreviousscript Multi,Previous Scripts,wh","Button,gpssel Default,Open,y","Button,x+10 gcleanup,Clean up files,y","Button,x+10 gdeleteps,Delete Selected,y"),newwin.Show("Previous Scripts"),hotkeys([21],{up:"pskey",down:"pskey",PgUp:"pskey",PgDn:"pskey"})
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
			if(!FileExist(scr.text))
				scr.ParentNode.RemoveChild(scr)
			Else if(dup[scr.text])
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
		while,scr:=scripts.item[A_Index-1]
			if(filelist[scr.text])
				scr.ParentNode.RemoveChild(scr)
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
		LV_ModifyCol(1,"AutoHDR"),LV_Modify(1,"Select")
		return
	}
	return
	pss:
	LV_Delete(),find:=newwin[].find
	for a,b in files
		if(InStr(a,find))
			LV_Add("",b)
	LV_Modify(1,"Select Vis Focus")
	return
	pssel:
	LV_GetText(file,LV_GetNext()),tv:=open(file,1),tv(tv),hwnd({rem:21})
	return
	pskey:
	ControlSend,SysListView321,{%A_ThisHotkey%},% newwin.id
	return
}
ProjectFolder(){
	return settings.ssn("//directory").text?settings.ssn("//directory").text:A_ScriptDir "\Projects"
}
Publish(return=""){
	sc:=csc(),text:=update("get").1,save(),mainfile:=ssn(current(1),"@file").text,publish:=update({get:mainfile}),includes:=sn(current(1),"descendant::*/@include/..")
	number:=vversion.ssn("//info[@file='" current(2).file "']/descendant::version/@number").text
	while,ii:=includes.item[A_Index-1]
		if(InStr(publish,ssn(ii,"@include").text))
			StringReplace,publish,publish,% ssn(ii,"@include").text,% update({get:ssn(ii,"@file").text}),All
	rem:=sn(current(1),"descendant::remove")
	while,rr:=rem.Item[A_Index-1]
		publish:=RegExReplace(publish,"m)^\Q" ssn(rr,"@inc").text "\E$")
	change:=settings.ssn("//auto_version").text?settings.ssn("//auto_version").text:"Version:=" Chr(34) "$v" Chr(34)
	if(InStr(publish,Chr(59) "auto_version"))
		publish:=RegExReplace(publish,Chr(59) "auto_version",RegExReplace(change,"\Q$v\E",number))
	publish:=RegExReplace(publish,"U)^\s*(;{.*\R|;}.*\R)","`n")
	StringReplace,publish,publish,`n,`r`n,All
	if(!publish)
		return sc.getuni()
	if(return)
		return publish
	Clipboard:=v.options.Full_Auto?PublishIndent(publish):publish
	TrayTip,AHK Studio,Code coppied to your clipboard
}
PublishIndent(Code,Indent:="`t",Newline:="`r`n"){
	indentregex:=v.indentregex,Lock:=[],Block:=[],ParentIndent:=Braces:=0,ParentIndentObj:=[]
	for each,Line in StrSplit(Code,"`n","`r"){
		Text:=Trim(RegExReplace(Line,"\s;.*")),First:=SubStr(Text,1,1),Last:=SubStr(Text,0,1),FirstTwo:=SubStr(Text,1,2),IsExpCont:=(Text~="i)^\s*(&&|OR|AND|\.|\,|\|\||:|\?)"),IndentCheck:=(Text~="iA)}?\s*\b(" IndentRegEx ")\b")
		if(First=="("&&!InStr(line,")"))
			Skip:=True
		if(Skip){
			if(First==")")
				Skip:=False
			Out.="`r`n" line
			continue
		}
		if(FirstTwo=="*/")
			Block:=[],ParentIndent:=0
		if(Block.MinIndex())
			Current:=Block,Cur:=1
		else
			Current:=Lock,Cur:=0
		Braces:=Round(Current[Current.MaxIndex()].Braces),ParentIndent:=Round(ParentIndentObj[Cur])
		if(First=="}"){
			while,((Found:=SubStr(Text,A_Index,1))~="}|\s"){
				if(Found~="\s")
					continue
				if(Cur&&Current.MaxIndex()<=1)
					break
				Special:=Current.Pop().Ind,Braces--
		}}if(First=="{"&&ParentIndent)
			ParentIndent--
		Out.=Newline
		Loop,% Special?Special-1:Round(Current[Current.MaxIndex()].Ind)+Round(ParentIndent)
			Out .= Indent
		Out.=Trim(Line)
		if(FirstTwo=="/*"){
			if(!Block.MinIndex())
				Block.Push({ParentIndent:ParentIndent,Ind:Round(Lock[Lock.MaxIndex()].Ind)+1,Braces:Round(Lock[Lock.MaxIndex()].Braces)+1})
			Current:=Block,ParentIndent:=0
		}if(Last=="{")
			Braces++,ParentIndent:=(IsExpCont&&Last=="{")?ParentIndent-1:ParentIndent,Current.Push({Braces:Braces,Ind:ParentIndent+Round(Current[Current.MaxIndex()].ParentIndent)+Braces,ParentIndent:ParentIndent+Round(Current[Current.MaxIndex()].ParentIndent)}),ParentIndent:=0
		if((ParentIndent||IsExpCont||IndentCheck)&&(IndentCheck&&Last!="{"))
			ParentIndent++
		if(ParentIndent>0&&!(IsExpCont||IndentCheck))
			ParentIndent:=0
		ParentIndentObj[Cur]:=ParentIndent,Special:=0
	}
	if(Braces)
		throw Exception("Segment Open! You have " braces " open braces")
	return SubStr(Out,StrLen(Newline)+1)
}
QF(){
	static quickfind:=[],find,lastfind,minmax,break,select
	qf:
	sc:=csc(),startpos:=sc.2008,break:=1
	ControlGetText,find,Edit1,% hwnd([1])
	if(find=lastfind&&sc.2570>1){
		if(GetKeyState("Shift","P"))
			return current:=sc.2575,sc.2574((current=0)?sc.2570-1:current-1),CenterSel()
		return sc.2606(),CenterSel()
	}
	pre:="O",find1:="",find1:=v.options.regex?find:"\Q" RegExReplace(find, "\\E", "\E\\E\Q") "\E",pre.=v.options.greed?"":"U",pre.=v.options.case_sensitive?"":"i",pre.=v.options.multi_line?"m`n":"",find1:=pre ")" find1 ""
	if(find=""||find="."||find=".*"||find="\")
		return sc.2571
	opos:=select.opos,select:=[],select.opos:=opos?opos:sc.2008,select.items:=[],text:=sc.getuni()
	if(sc.2508(0,start:=quickfind[sc.2357]+1)!=""){
		end:=sc.2509(0,start)
		if(end)
			text:=SubStr(text,1,end)
	}
	sc.Enable(),pos:=start?start:1,pos:=pos=0?1:pos,mainsel:="",index:=1,break:=0
	if(!IsObject(minmax))
		minmax:=[],minmax.1:={min:0,max:sc.2006},delete:=1
	for a,b in MinMax{
		search:=sc.textrange(b.min,b.max,1),pos:=1,start:=b.min-1
		while,RegExMatch(search,find1,found,pos){
			if(break){
				break:=0
				Break,2
			}
			if(found.Count()){
				if(!found.len(A_Index))
					Break
				Loop,% found.Count()
					ns:=StrPut(SubStr(search,1,found.Pos(A_Index)),"utf-8")-1,select.items.push({start:start+ns,end:start+ns+StrPut(found[A_Index])-1}),pos:=found.Pos(A_Index)+found.len(A_Index)
			}else{
				if(found.len=0)
					Break
				ns:=StrPut(SubStr(search,1,found.Pos(0)),"utf-8")-1,select.items.InsertAt(1,{start:start+ns,end:start+ns+StrPut(found[0])-1}),pos:=found.Pos(0)+found.len(0)
			}
			if(lastpos=pos)
				Break
			lastpos:=pos
		}
	}
	lastfind:=find
	if(select.items.MaxIndex()=1)
		obj:=select.items.1,sc.2160(obj.start,obj.end)
	else{
		num:=-1
		while,obj:=select.items.pop(){
			if(break)
				break
			sc[A_Index=1?2160:2573](obj.start,obj.end),num:=(obj.end>select.opos&&num<0)?A_Index-1:num
		}
		if(num>=0)
			sc.2574(num)
	}select:=[],sc.Enable(1),CenterSel(),Notify("setpos")
	return
	next:
	sc:=csc(),sc.2606(),sc.2169()
	return
	Clear_Selection:
	sc:=csc(),sc.2500(2),sc.2505(0,sc.2006),quickfind.remove(sc.2357),minmax:=""
	return
	Set_Selection:
	sc:=csc(),sc.2505(0,sc.2006),sc.2500(2)
	if(sc.2008=sc.2009)
		goto,Clear_Selection
	if(!IsObject(MinMax)),pos:=posinfo()
		minmax:=[]
	Loop,% sc.2570
		o:=[],o[sc.2577(A_Index-1)]:=1,o[sc.2579(A_Index-1)]:=1,minmax.Insert({min:o.MinIndex(),max:o.MaxIndex()})
	for a,b in minmax
		sc.2504(b.min,b.max-b.min)
	return
	Quick_Find:
	if(v.options.Auto_Set_Area_On_Quick_Find)
		gosub,Set_Selection
	ControlFocus,Edit1,% hwnd([1])
	ControlSend,Edit1,^A,% hwnd([1])
	lastfind:=""
	return
	Case_Sensitive:
	Regex:
	Multi_Line:
	Greed:
	onoff:=settings.ssn("//Quick_Find_Settings/@ " A_ThisLabel).text?0:1,att:=[],att[A_ThisLabel]:=onoff,settings.add("Quick_Find_Settings",att)
	GuiControl,1:,% RegExReplace(A_ThisLabel,"_"," "),%onoff%
	ToggleMenu(A_ThisLabel),v.options[A_ThisLabel]:=onoff,lastfind:=""
	ControlGetText,text,Edit1,% hwnd([1])
	if(text)
		goto,qf
	return
	checkqf:
	sc:=csc()
	if(sc.2008=sc.2136(line:=sc.2166(sc.2008))&&sc.2230(line)=0)
		end:=sc.2136(sc.2224(line,sc.2223(line))),sc.2025(end)
	ControlGetFocus,Focus,% hwnd([1])
	if(Focus="Edit1")
		goto,qf
	else if(A_ThisHotkey="+Enter"||A_ThisHotkey="enter")
		replace(),MarginWidth()
	else
		marginwidth()
	if(v.options.full_auto)
		SetTimer,full,-10
	return
	full:
	sc:=csc()
	SetTimer,gofull,-1
	return
	gofull:
	fix_indent()
	GuiControl,1:+Redraw,% sc.sc
	return
}
QFS(){
	ControlGet,value,Checked,,%A_GuiControl%,% hwnd([1])
	settings.ssn("//Quick_Find_Settings").SetAttribute(clean(A_GuiControl),value),v.options[clean(A_GuiControl)]:=value,qf()
}
Redo(){
	csc().2011
}
Refresh_Current_Project(file:=""){
	GuiControl,1:+g,SysTreeView321
	GuiControl,1:-Redraw,SysTreeView321
	current:=current(2).file,file:=file?file:current(3).file,Close(1,,0),open(current,0,0)
	GuiControl,1:+gtv,SysTreeView321
	tv(files.ssn("//main[@file='" current "']/descendant::file[@file='" file "']/@tv").text)
	GuiControl,1:+Redraw,SysTreeView321
}
Refresh_Plugins(){
	Plug(1)
}
Refresh_Project_Explorer(openfile:=""){
	static parent,file
	if(files.sn("//main[@untitled]").length)
		UnSaved()
	Gui,1:Default
	GuiControl,1:-Redraw,SysTreeView321
	parent:=current(2).file,file:=current(3).file,Save(),files:=new xml("files"),open:=settings.sn("//open/*"),cexml:=new xml("code_explorer"),Index_Lib_Files(),omni_search_class.menus()
	while,oo:=open.item[A_Index-1]{
		if(!FileExist(oo.text)){
			rem:=settings.sn("//file[text()='" oo.text "']")
			while,rr:=rem.item[A_Index-1]
				rr.ParentNode.RemoveChild(rr)
		}else
			openfilelist.=oo.text "`n"
	}
	Gui,1:Default
	Gui,1:TreeView,SysTreeView321
	TV_Delete(),Open(Trim(openfilelist,"`n"))
	for a,b in [openfile,file]
		if(tv:=files.ssn("//main[@file='" parent "']/descendant::file[@file='" b "']/@tv").text)
			break
	tv(tv?tv:TV_GetChild(0),1),Index_Lib_Files()
}
Refresh_Project_Treeview(select:="",parent:=""){
	Gui,1:Default
	Gui,1:TreeView,SysTreeView321
	all:=files.sn("//files/descendant::*")
	TV_Delete()
	while,aa:=all.item[A_Index-1],ea:=xml.ea(aa){
		if(aa.nodename="main")
			Continue
		aa.SetAttribute("tv",TV_Add(aa.nodename="folder"?ea.name:ea.filename,ssn(aa.ParentNode,"@tv").text,aa.nodename="folder"?"icon1":"icon2"))
	}
	if(select)
		tv(files.ssn("//main[@file='" parent "']/descendant::file[@file='" select "']/@tv").text)
}
Refresh(){
	for a,b in s.Ctrl{
		if(settings.ssn("//fonts/font[@style='34']"))
			b.2498(0,8)
		color(b)
	}
}
RefreshThemes(){
	static bcolor,fcolor
	if(node:=settings.ssn("//fonts/custom[@gui='1' and @control='msctls_statusbar321']"))
		SetStatus(node)
	else
		SetStatus(settings.ssn("//fonts/font[@style='5']"))
	ea:=settings.ea("//fonts/font[@style='5']"),default:=ea.clone(),cea:=settings.ea("//fonts/find"),tf:=v.options.top_find,bcolor:=(cea.tb!=""&&tf)?cea.tb:(cea.bb!=""&&!tf)?cea.bb:ea.Background,fcolor:=(cea.tf!=""&&tf)?cea.tf:(cea.bf!=""&&!tf)?cea.bf:ea.Color
	for win,b in hwnd("get"){
		if(win>99)
			return
		WinGet,controllist,ControlList,% "ahk_id" b
		Gui,%win%:Default
		Gui,Color,% RGB(bcolor),% RGB(cea.qfb!=""?cea.qfb:bcolor)
		for a,b in StrSplit(ControlList,"`n"){
			if((b~="i)Static1|Button|Edit1")&&win=1)
				GuiControl,% "1:+background" RGB(bcolor) " c" RGB(fcolor),%b%
			else{
				if(node:=settings.ssn("//fonts/custom[@gui='" win "' and @control='" b "']"))
					text:=CompileFont(node),ea:=xml.ea(node)
				else
					text:=CompileFont(node:=settings.ssn("//fonts/font[@style='5']")),ea:=xml.ea(node)
				Gui,%win%:font,%text%,% ea.font
				GuiControl,% "+background" RGB(ea.Background!=""?ea.Background:default.Background) " c" rgb(ea.color),%b%
				GuiControl,% "font",%b%
			}
		}
		WinSet,Redraw,,% hwnd([win])
	}
	if(settings.ssn("//fonts/font[@style='34']"))
		2498(0,8)
	if(number:=settings.ssn("//fonts/font[@code='2188']/@value").text)
		for a,b in s.ctrl
			b.2188(number)
	Refresh()
	return
}
RegisterID(CLSID,APPID){
	RegWrite,REG_SZ,HKCU,Software\Classes\%APPID%,,%APPID%
	RegWrite,REG_SZ,HKCU,Software\Classes\%APPID%\CLSID,,%CLSID%
	RegWrite,REG_SZ,HKCU,Software\Classes\CLSID\%CLSID%,,%APPID%
}
;(!value)?RegisterID("{DBD5A90A-A85C-11E4-B0C7-43449580656B}","AHK-Studio"):""
RelativePath(main,new){
	SplitPath,main,,mdir
	SplitPath,new,filename,ndir
	for a,b in {"%A_AppData%":A_AppData,"%A_AppDataCommon%":A_AppDataCommon}
		if(InStr(new,b))
			return RegExReplace(new,"\Q" b "\E",a)
	smain:=StrSplit(mdir,"\"),snew:=StrSplit(ndir,"\")
	if(smain.1!=snew.1)
		return new
	for a,b in smain{
		if(b!=snew[a]){
			Loop,% smain.MaxIndex()-(a-1)
				pre.="..\"
			for c,d in snew{
				if(c>=a)
					build.=d "\"
			}
			return pre build filename
		}remove.=b "\"
	}
	StringReplace,Relative,new,%remove%
	return Relative
}
Remove_Current_Selection(){
	sc:=csc(),main:=sc.2575,sc.2671(main),sc.2606,sc.2169
}
Remove_Scintilla_Window(){
	getpos(),sc:=csc(),s.delete(sc),SetPos(current(3).sc)
}
Remove_Segment(){
	current:=current(),mainnode:=current(1),curfile:=current(3).file
	if(current(3).file=current(2).file)
		return m("Can not remove the main Project")
	if(m("Are you sure?","btn:yn","def:2")="no")
		return
	all:=files.sn("//main[@file='" current(2).file "']/descendant::file"),contents:=update("get").1,inc:=current(3).include
	while,aa:=all.item[A_Index-1],ea:=xml.ea(aa){
		text:=contents[ea.file]
		if(f:=InStr(text,inc)){
			if(m("Permanently delete this file?","btn:yn","def:2")="Yes")
				FileDelete,% current(3).file
			update({file:ea.file,text:RegExReplace(text,"\R?\Q" inc "\E\R?","`n")}),Refresh_Current_Project(ea.file)
			Break
		}
	}
}
Rename_Current_Segment(current:=""){
	if(!current.xml)
		current:=current()
	ea:=xml.ea(current)
	FileSelectFile,Rename,S16,% ea.file,Rename Current Segment,*.ahk
	if(ErrorLevel)
		return
	SplitPath,rename,,,ext
	if(!ext)
		rename.=".ahk"
	mainfile:=ssn(current,"ancestor::main/@file").text,relative:=RelativePath(mainfile,rename)
	SplitPath,mainfile,,dir
	FileMove,% ea.file,%dir%\%relative%,1	;#[FIXED: Renamed files were being placed in the Studio working directory]
	text:=update({get:mainfile}),text:=RegExReplace(text,"\Q" ea.include "\E","#Include " relative),update({file:mainfile,text:text}),current(1).firstchild.removeattribute("sc")
	SplashTextOn,,100,Indexing Files,Please Wait....
	Refresh_Project_Explorer(rename)
	SplashTextOff
}
Replace_Selected(){
	sc:=csc(),OnMessage(6,""),replace:=InputBox(sc.sc,"Replace Selected","Input text to replace what is selected"),clip:=Clipboard
	if(ErrorLevel)
		return
	for a,b in StrSplit("``r,``n,``r``n,\r,\n,\r\n",",")
		replace:=RegExReplace(replace,"i)\Q" b "\E","`n")
	Clipboard:=replace,sc.2614(1),sc.2179,Clipboard:=clip,OnMessage(6,"Activate")
}
Replace(){
	sc:=csc(),cp:=sc.2008,word:=sc.textrange(start:=sc.2266(cp-1,1),end:=sc.2267(cp-1,1)),rep:=settings.ssn("//replacements/*[@replace='" word "']").text
	if(sc.2007(cp)=125&&sc.2007(cp-1)=123&&A_ThisHotkey="+Enter"){
		line:=sc.2166(cp),ll:=sc.getline(line+1),sc.2078,cind:=sc.2127(line),indent:=sc.2121,nl:=sc.2136(line+1)
		if(ll){
			if(ll~="i)^\s*\belse\b"){
				sc.2003(sc.2128(line+1),"}"),sc.2645(cp,1),sc.2003(cp,"`n"),sc.2126(line+1,cind+indent),sc.2025(sc.2128(line+1))
				return sc.2079
			}if(sc.getline(line+2)~="i)^\s*\belse\b"){
				sc.2003(sc.2128(line+2),"}"),sc.2645(cp,1),sc.2126(line+1,cind+indent)
				return sc.2079
			}else
			{
				sc.2003(nl,"`n}"),ind:=sc.2127(line),sc.2126(line+1,ind+indent),sc.2126(line+2,ind),sc.2645(cp,1)
			}
		}else
			sc.2003(cp,"`n`n"),Fix_Indent(),sc.2025(sc.2128(sc.2166(cp)+1))
		return sc.2079
	}
	if(sc.2007(cp)=125&&sc.2007(cp-1)=123&&(A_ThisHotkey="+Enter"||A_ThisHotkey="Enter")&&v.options.Full_Auto)
		sc.2003(cp,"`n`n"),Fix_Indent(),sc.2025(sc.2128(sc.2166(cp)+1))
	if(!rep)
		return
	pos:=1,list:=[],foundList:=[],origRepLen:=StrLen(rep)
	while,pos:=RegExMatch(rep,"U)(\$\||\$.+\b)",found,pos){
		if(!ObjHasKey(foundList,found))
			foundList[found]:=pos,List.Insert(found)
		pos++
	}
	for a,b in List{
		value:=""
		if(b!="$|"){
			value:=InputBox(csc().sc,"Value for " b,"Insert value for: "  b "`n`n" rep)
			if(ErrorLevel)
				return
			StringReplace,rep,rep,%b%,%value%,All
		}
	}
	if(rep)
		pos:=InStr(rep,"$|"),rep:=RegExReplace(rep,"\$\|"),sc.2190(start),sc.2192(end),sc.2194(StrLen(rep),rep),_:=pos?sc.2025(start+pos-1):""
	else if(A_ThisHotkey="+Enter")
		sc.2160(start+StrLen(rep),start+StrLen(rep))
	if(v.options.Auto_Space_After_Comma)
		sc.2003(sc.2008," "),sc.2025(sc.2008+1)
	v.word:=rep?rep:word
	SetTimer,automenu,-80
}
Reset_Zoom(){
	csc().2373(0),settings.ssn("//gui/zoom").text:=0
}
Resize(info*){
	static
	static width,height,flip:={x:"w",y:"h"}
	if(info.2>>16&&A_Gui=1)
		height:=info.2>>16?info.2>>16:height,width:=info.2&0xffff?info.2&0xffff:width
	if(i:=GuiKeep.current(A_Gui)){
		wid:=info.2&0xffff,hei:=info.2>>16
		if(wid=""||hei="")
			return
		for a,b in i.gui
			for c,d in b{
				if(c~="y|h")
					GuiControl,MoveDraw,%a%,% c hei+d-(c="y"?i.border:0)
				else
					GuiControl,MoveDraw,%a%,% c wid+d
			}
		return
	}
	if(info.1="get"){
		WinGetPos,x,y,,,% hwnd([1])
		return size:="x" x " y" y " w" width " h" height
	}
	if(A_Gui=1||info.1="rebar"){
		if(info.1="rebar")
			wp:=winpos(),width:=wp.w,height:=wp.h
		height:=info.2>>16?info.2>>16:height,width:=info.2&0xffff?info.2&0xffff:width
		SendMessage,0x400+27,0,0,,% "ahk_id" rebar.hw.1.hwnd
		rheight:=ErrorLevel
		SetTimer,rsize,-100
	}
	return
	rsize:
	WinGet,cl,ControlListHWND,% hwnd([1])
	ControlMove,,,,%width%,,% "ahk_id" rebar.hw.1.hwnd
	ControlGetPos,,y,,h,,% "ahk_id" rebar.hw.1.hwnd
	ControlGetPos,,,,eh,Edit1,% hwnd([1])
	;Gui,1:Color,% v.options.top_find?"E1E6F6":"F1EDED",White	;#[ADDED: Quick Find colors customized based on top/bottom]
	hh:=height-v.status-rheight-v.menu-(v.dbgsock>0?200:0)
	v.options.Top_Find?(fy:=y+h,top:=y+h+eh,td:=hh+top):(fy:=hh+y+h,hh:=hh,top:=y+h,td:=hh+top+eh)
	for a,b in s.main
		GuiControl,-Redraw,% b.sc
	start:=project:=v.options.Hide_Project_Explorer?0:settings.get("//gui/@projectwidth",200),code:=v.options.Hide_Code_Explorer?0:settings.get("//gui/@codewidth",200)
	ControlMove,SysTreeView321,,%top%,%project%,%hh%,% hwnd([1])
	ControlMove,SysTreeView322,width-code+v.Border,top,%code%,%hh%,% hwnd([1])
	div:=s.main.MaxIndex(),left:=width-project-code
	for a,b in s.main{
		ControlMove,,start+v.Border,top,% A_Index=div?(Floor(left/div)+(left-Floor(left/div)*div)):Floor(left/div),%hh%,% "ahk_id" b.sc
		start+=Floor(left/div)
	}
	ControlMove,Static1,,% fy+4,,,% hwnd([1])
	ControlMove,Edit1,,%fy%,% width-330,,% hwnd([1])
	Loop,4{
		if(A_Index=1){
			ControlGetPos,x,,w,,Edit1,% hwnd([1])
			start:=x+w+2
		}else{
			ControlGetPos,,,w,,% "Button" A_Index-1,% hwnd([1])
			start+=w+2
		}
		ControlMove,Button%A_Index%,%start%,% fy+4,,,% hwnd([1])
	}
	if(v.debug.sc)
		ControlMove,,% v.border,%td%,%width%,% _:=v.dbgsock>0?200:0,% "ahk_id" v.debug.sc
	for a,b in s.main
		GuiControl,+Redraw,% b.sc
	WinSet,Redraw,,% hwnd([1])
	return
}
RGB(c){
	setformat,IntegerFast,H
	c:=(c&255)<<16|c&65280|c>>16 ""
	SetFormat,integerfast,D
	return c
}
Run_Program(){
	if(!v.dbgsock)
		return m("Currently no file being debugged"),debug.off()
	v.ddd.send("run")
}
Run(){
	if(v.options.Virtual_Scratch_Pad&&InStr(current(2).file,"Scratch Pad.ahk"))
		return DynaRun(csc().getuni())
	if(current(2).untitled)
		return DynaRun(csc().getuni())
	sc:=csc(),getpos(),save(),file:=ssn(current(1),"@file").text
	SplitPath,file,,dir,ext
	if(!current(1).xml)
		return
	if(file=A_ScriptFullPath)
		exit(1)
	main:=ssn(current(1),"@file").text
	if(FileExist(A_ScriptDir "\AutoHotkey.exe"))
		run:=Chr(34) A_ScriptDir "\AutoHotkey.exe" Chr(34) " " Chr(34) file Chr(34)
	else
		run:=FileExist(dir "\AutoHotkey.exe")?Chr(34) dir "\AutoHotkey.exe" Chr(34) " " Chr(34) file Chr(34):Chr(34) file Chr(34)
	admin:=v.options.run_as_admin?"*RunAs ":""
	Run,%admin%%run%,%dir%,,pid
	if(!IsObject(v.runpid))
		v.runpid:=[]
	v.runpid[pid]:=1
	if(file=A_ScriptFullPath)
		ExitApp
}
Run_As_U32(){
	Run_As("AutoHotkeyU32")
}
Run_As_U64(){
	Run_As("AutoHotkeyU64")
}
Run_As_Ansii(){
	Run_As("AutoHotkeyA32")
}
Run_As(exe){
	file:=current(2).file
	SplitPath,A_AhkPath,,dir
	SplitPath,file,,fdir
	Run,%dir%\%exe% "%file%",%fdir%,,pid
	if(!IsObject(v.runpid))
		v.runpid:=[]
	v.runpid[pid]:=1
}
runfile(file){
	SplitPath,file,,dir
	run,%file%,%dir%
	return 1
}
RunFunc(){
	func:=v.runfunc,%func%()
}
Save_As(){
	Send,{Alt Up}
	current:=current(1),currentfile:=current(2).file
	SplitPath,currentfile,,dir
	FileSelectFile,newfile,S,%dir%,Save File As...,*.ahk
	if(ErrorLevel||newfile="")
		return
	newfile:=SubStr(newfile,-3)=".ahk"?newfile:newfile ".ahk"
	if(FileExist(newfile))
		return m("File exists... Please choose another")
	filelist:=sn(current(1),"descendant::*")
	SplitPath,newfile,newfn,newdir
	while,fl:=filelist.item[A_Index-1],ea:=xml.ea(fl)
		if(newfn=ea.filename)
			return m("File conflicts with an include.  Please choose another filename")
	SplashTextOn,200,100,Creating New File(s)
	while,fl:=filelist.item[A_Index-1],ea:=xml.ea(fl){
		filename:=ea.file
		SplitPath,filename,file
		if(A_Index=1)
			FileAppend,% update({get:filename}),%newdir%\%newfn%,% ea.encoding
		else if !FileExist(newdir "\" file)
			FileAppend,% update({get:filename}),%newdir%\%file%
	}
	SplashTextOff
	Close(),Open(newfile),tv(files.ssn("//file[@file='" newfile "']/@tv").text)
}
Save(option=""){
	sc:=csc(),getpos(),update({sc:sc.2357}),info:=update("get"),now:=A_Now
	if(option=1){
		for a,b in info.2{
			MsgBox,35,Save File?,File contents have been updated for %a%.`nWould you like to save the updates?
			IfMsgBox,No
				info.2.Remove(a)
			IfMsgBox,Cancel
				return "cancel"
		}
	}savedfiles:=[],saveas:=[]
	for filename in info.2{
		if(v.options.Virtual_Scratch_Pad&&filename="Virtual Scratch Pad.ahk")
			Continue
		if(files.ea("//main[@file='" filename "']").untitled=1){
			if(current(2).file=filename)
				saveas.push(filename)
			Continue
		}
		text:=info.1[filename],main:=ssn(current(1),"@file").text,savedfiles.push(1)
		if(settings.ssn("//options/@Enable_Close_On_Save").text)
			for process in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process"){
				prog:=Trim(StrSplit(process.CommandLine,Chr(34)).4,Chr(34))
				if(InStr(process.commandline,"autohotkey")&&prog!=A_ScriptFullPath&&prog)
					if(prog=main)
						Process,Close,% process.processid
			}
		SplitPath,filename,file,dir
		setstatus("Saving " file,3)
		if(!v.options.disable_backup){
			if(!FileExist(dir "\backup"))
				FileCreateDir,% dir "\backup"
			if(!FileExist(dir "\backup\" now))
				FileCreateDir,% dir "\backup\" now
			FileMove,%filename%,% dir "\backup\" now "\" file,1
			if(ErrorLevel)
				m("There was an issue saving " filename,"Please close any error messages and try again")
		}else
			FileDelete,%filename%
		StringReplace,text,text,`n,`r`n,All
		encoding:=files.ssn("//file[@file='" filename "']/@encoding").text,encoding:=encoding?encoding:"UTF-8"
		/*
			if(encoding!="UTF-16"&&RegExMatch(text,"[^\x00-\x7F]"))
				encoding:="UTF-16"
		*/
		if(v.options.Force_UTF8)
			encoding:="UTF-8"
		file:=fileopen(filename,"rw"),file.seek(0),file.write(text),file.length(file.position),file.close()
		Gui,1:TreeView,% hwnd("fe")
		multi:=files.sn("//file[@file='" filename "']")
		while,mm:=multi.item[A_Index-1]{
			ea:=files.ea(mm)
			SplitPath,% ea.filename,,,,nne
			TV_Modify(ea.tv,"",v.options.Hide_File_Extensions?nne:ea.filename)
		}
		FileGetTime,time,%filename%
		ff:=files.sn("//*[@file='" filename "']")
		while,fff:=ff.item[A_Index-1]
			fff.SetAttribute("time",time)
		if(!IsObject(v.savelinestat))
			v.savelinestat:=[]
		v.savelinestat[filename]:=1
	}
	plural:=savedfiles.MaxIndex()=1?"":"s",setstatus(Round(savedfiles.MaxIndex()) " File" plural " Saved",3)
	Loop,% sc.2154{
		if(sc.2533(A_Index-1)=30)
			sc.2532(A_Index-1,31)
	}savegui(),vversion.save(1),lastfiles(),update("clearupdated"),PERefresh()
	if(saveas.MinIndex()){
		v.saveas:=saveas
		SetTimer,saveuntitled,-1
	}
	return
	saveuntitled:
	for a,b in v.saveas{
		tv(files.ssn("//*[@file='" b "']/@tv").text)
		Sleep,300
		Save_As()
	}
	return
}
SaveGUI(win:=1){
	WinGet,max,MinMax,% hwnd([win])
	info:=winpos(win)
	if(!top:=settings.ssn("//gui/position[@window='" win "']"))
		top:=settings.Add("gui/position",{window:win},,1)
	text:=max?top.text:info.text,top.text:=text,top.SetAttribute("max",max)
}
Scratch_Pad(){
	static
	if(v.options.Virtual_Scratch_Pad){
		Gui,1:Default
		Gui,1:TreeView,SysTreeView321
		if(!tv)
			top:=files.ssn("//*"),main:=files.under(top,"main",{file:"Virtual Scratch Pad.ahk"}),files.under(main,"file",{tv:tv:=TV_Add("Virtual Scratch Pad"),file:"Virtual Scratch Pad.ahk",virtual:1}),tv(tv)
		else if(TV_GetSelection()!=tv)
			tv(tv)
		else
			History({back:1})
		return
	}
	newpath:=A_ScriptDir "\projects\Scratch Pad\Scratch Pad.ahk"
	file:=current(3).file
	if(file=newpath){
		if(main&&current)
			tv(files.ssn("//main[@file='" main "']/descendant::file[@file='" current "']/@tv").text)
		else
			tv(files.ssn("//main/file/@tv").text)
	}else{
		main:=current(2).file,current:=current(3).file
		if(!FileExist(newpath)){
			ts:=settings.ssn("//template").text,file:=FileOpen("c:\windows\shellnew\template.ahk",0),td:=file.Read(file.length),file.close(),template:=ts?ts:td,index:=0,new(newpath,template)
		}else if(!files.ssn("//main/file[@file='" newpath "']/@tv").text)
			open(newpath),tv(files.ssn("//main/file[@file='" newpath "']/@tv").text)
		else
			tv(files.ssn("//main/file[@file='" newpath "']/@tv").text)
	}
}
ScrollWheel(){
	scrollwheel:
	if(A_ThisHotkey="WheelLeft")
		csc().2168(-5)
	else
		csc().2168(5)
	return
}
Search_Label(){
	omni_search(":")
}
Menu_Search(){
	Omni_Search("@")
}
Add_Function_Call(){
	Omni_Search("+")
}
Function_Search(){
	Omni_Search("(")
}
Bookmark_Search(){
	Omni_Search("#")
}
Variable_Search(){
	Omni_Search("%")
}
Hotkey_Search(){
	Omni_Search("&")
}
Property_Search(){
	Omni_Search(".")
}
Instance_Search(){
	Omni_Search("<")
}
Method_Search(){
	Omni_Search("[")
}
Class_Search(){
	Omni_Search("{")
}
Create_Segment_From_Selection(){
	pos:=posinfo(),sc:=csc()
	if(pos.start=pos.end)
		return m("Please select some text to create a new segment from")
	else{
		text:=sc.getseltext(),RegExMatch(text,"^(\w+)",segment),filename:=ssn(current(1),"@file").text
		SplitPath,filename,,dir
		FileSelectFile,newsegment,,%dir%\%segment1%
		newsegment:=InStr(newsegment,".ahk")?newsegment:newsegment ".ahk"
		if(ErrorLevel)
			return
		if(FileExist(newsegment))
			return m("Segment name already exists. Please choose another")
		text:=sc.getseltext(),pos:=posinfo()
		if(v.options.Includes_In_Place=1)
			sc.2003(pos.end,"#Include " relative:=RelativePath(current(3).file,newsegment))
		else
			Relative:=RegExReplace(RelativePath(current(2).file,newsegment),"i)^lib\\([^\\]+)\.ahk$","<$1>"),maintext:=Update({get:current(2).file}),update({file:current(2).file,text:maintext "`n#Include " Relative})
		sc.2645(pos.start,pos.end-pos.start),file:=FileOpen(newsegment,1,"UTF-8"),file.seek(0),file.write(text),file.length(file.position),file.Close(),update({file:newsegment,text:text}),Refresh_Current_Project()
		GuiControl,1:+Redraw,SysTreeView321
}}
Select_All(){
	Send,^a
}
Select_Current_Word(){
	sc:=csc(),sc.2160(sc.2266(sc.2008),sc.2267(sc.2008))
}
Select_Next_Duplicate(){
	sc:=csc(),xx:=sc.2577(sc.2575())
	for a,b in v.selectedduplicates
		if(xx<b){
			sc.2573(b+StrLen(v.lastsearch),b),sc.2169()
			break
}}
SelectAll(){
	SelectAll:
	ControlGetFocus,Focus,A
	if(!InStr(Focus,"Scintilla")){
		Send,^A
		return
	}
	sc:=csc(),count:=Abs(sc.2008-sc.2009)
	if(!sc.2230(line:=sc.2166(sc.2008)))
		return level:=sc.2223(line),last:=sc.2224(line,level),start:=sc.2167(line),end:=sc.2136(last),sc.2160(start,end),v.pastefold:=1
	if(v.selectedduplicates){
		for a,b in v.selectedduplicates
			if(A_Index=1)
				sc.2160(b+count,b)
		else
			sc.2573(b,b+count)
	}
	Else
		sc.2013
	return
}
set_as_default_editor(){
	RegRead,current,HKCU,SOFTWARE\Classes\AutoHotkeyScript\Shell\Edit\Command
	SplitPath,A_ScriptFullPath,,,ext
	if(ext="exe")
		New_Editor="%A_ScriptFullPath%" "```%1"
	else if(ext="ahk")
		New_Editor="%A_AhkPath%" "%A_ScriptFullPath%" "```%1"
	if(current=RegExReplace(New_Editor,Chr(96)))
		New_Editor="%A_WinDir%\Notepad.exe" "```%1"
	pgm=RegWrite,REG_SZ,HKCU,SOFTWARE\Classes\AutoHotkeyScript\Shell\Edit\Command,,%New_Editor%
	DynaRun(pgm)
	Sleep,250
	RegRead,output,HKCU,SOFTWARE\Classes\AutoHotkeyScript\Shell\Edit\Command
	if(InStr(output,A_ScriptName))
		m("AHK Studio is now your default editor for .ahk file")
	else if InStr(output,"notepad.exe")
		m("Notepad.exe is now your default editor")
	else
		m("Something went wrong :( Please restart Studio and try again.")
}
Set(){
	color(csc())
}
SetMatch(){
	for a,b in {"{":"}","[":"]","<":">","(":")",Chr(34):Chr(34),"'":"'","%":"%"}
		if(!settings.find("//autoadd/key/@trigger",a))
			key:=[],key[a]:="match",hotkeys([1],key)
}
SetPos(oea:=""){
	static
	if(IsObject(oea)){
		sc:=csc(),current:=files.ssn("//*[@file='" oea.file "']/ancestor::main/@file").text
		if(!top:=positions.ssn("//main[@file='" current "']"))
			top:=positions.add("main",{file:current},,1)
		if(!fix:=ssn(top,"descendant::file[@file='" oea.file "']"))
			fix:=settings.under(top,"file",{file:oea.file})
		fix.RemoveAttribute("scroll"),nea:=files.ea("//*[@sc='" sc.2357 "']"),cea:=files.ea("//*[@file='" oea.file "']")
		SetTimer,Disable,-1
		Sleep,2
		if(oea.file!=nea.file)
			tv(cea.tv,2,1)
		(oea.line!="")?(end:=sc.2136(oea.line),start:=sc.2128(oea.line)):(end:=oea.end,start:=oea.start)
		fix.SetAttribute("start",oea.start),fix.SetAttribute("end",oea.end),sc.2160(start,end)
		SetTimer,CenterSel,-80
		SetTimer,Enable,-150
		return
	}
	delay:=(WinActive("A")=hwnd(1))?1:300
	if(delay=1)
		goto,spnext
	SetTimer,spnext,-%delay%
	return
	spnext:
	sc:=csc(),sc.2397(0),node:=files.ssn("//*[@sc='" sc.2357 "']"),file:=ssn(node,"@file").text,parent:=ssn(node,"ancestor::main/@file").text,posinfo:=positions.ssn("//main[@file='" parent "']/file[@file='" file "']"),doc:=ssn(node,"@sc").text,ea:=xml.ea(posinfo),fold:=ea.fold,breakpoint:=ea.breakpoint
	SetTimer,fold,-1
	return
	fold:
	if(ea.file){
		Loop,Parse,fold,`,
			sc.2231(A_LoopField)
		if(ea.start&&ea.end)
			sc.2160(ea.start,ea.end)
		if(ea.scroll!="")
			SetTimer,setscrollpos,-1
		return
		setscrollpos:
		if(ea.scroll!="")
			sc.2613(ea.scroll),sc.2400()
		return
	}
	return
}
SetStatus(text,part=""){
	static widths:=[],width
	if(IsObject(text))
		return sc:=csc(),ea:=xml.ea(text),sc.2056(99,ea.font),sc.2055(99,ea.size),width:=sc.2276(99,"a")+1
 	if(part=1)
		widths.3:=0
	widths[part]:=width*StrLen(text 1),SB_SetParts(widths.1,widths.2,widths.3),SB_SetText(text,part)
}
Setup(window,nodisable=""){
	ea:=settings.ea(settings.ssn("//fonts/font[@style='5']")),size:=10
	Background:=ea.Background,font:=ea.font,color:=RGB(ea.color),Background:=Background?Background:0
	Gui,%window%:Destroy
	Gui,%window%:Default
	Gui,+hwndhwnd -DPIScale
	if(nodisable!=1){
		Gui,+Owner1 -0x20000
		Gui,1:+Disabled
	}else
		Gui,+Owner1
	WinGet,ExStyle,ExStyle,% hwnd([1])
	if(ExStyle&0x8)
		Gui,%window%:+AlwaysOnTop
	Gui,color,% RGB(Background),% RGB(Background)
	Gui,Font,% "s" size " c" color " bold",%font%
	Gui,%window%:Default
	v.window[window]:=1,hwnd(window,hwnd)
	return hwnd
}
Show_Class_Methods(object){
	static list
	sc:=csc()
	if(object="this")
		Code_Explorer.scan(Current()),list:=cexml.sn("//main[@file='" current(2).file "']/descendant::file[@file='" current(3).file "']/descendant::*[@type='Class' and @pos<'" sc.2008 "' and @end>'" sc.2008 "']/*[@type='Method']")
	else if(parent:=cexml.ssn("//main[@file='" current(2).file "']/descendant::*[@type='Class' and @upper='" upper(object) "']"))
		list:=sn(parent,"*[@type='Method']")
	else if(ea:=xml.ea(parent:=cexml.ssn("//main[@file='" current(2).file "']/descendant::*[@type='Instance' and @upper='" upper(object) "']")))
		list:=cexml.sn("//main[@file='" Current(2).file "']/descendant::*[@type='Class' and @upper='" Upper(ea.class) "']/descendant::*[@type='Method']")
	while,ll:=list.item[A_Index-1],ea:=xml.ea(ll)
		total.=ea.text " "
	if(total:=Trim(total))
		sc.2117(3,total)
}
Show_Scintilla_Code_In_Line(){
	Scintilla(),sc:=csc()
	text:=sc.textrange(sc.2128(sc.2166(sc.2008)),sc.2136(sc.2166(sc.2008))),pos:=1
	while,pos:=RegExMatch(text,"(\d\d\d\d)",found,pos){
		codes:=scintilla.sn("//*[@code='" found1 "']"),list.="Code : " found1 " = "
		while,c:=codes.item(A_Index-1)
			list.=A_Index>1?" - " ssn(c,"@name").text:ssn(c,"@name").text
		pos+=5,list.="`n"
	}
	if(list)
		m(Trim(list,"`n"))
}
Show(){
	GuiControl,+Show,% this.sc
}
ShowLabels(x:=0){
	code_explorer.scan(current()),all:=cexml.sn("//main[@file='" current(2).file "']/descendant::info[@type='Function' or @type='Label']/@text")
	sc:=csc(),sc.2634(1),dup:=[]
	if(x!="nocomma")
		sc.2003(sc.2008,","),sc.2025(sc.2008+1)
	while,aa:=all.item[A_Index-1]
		if(!dup[aa.text])
			list.=aa.text " ",dup[aa.Text]:=1
	Sort,list,list,D%A_Space%
	sc.2100(0,Trim(list))
}
Step_Into(){
	v.ddd.send("step_into")
}
Step_Out(){
	v.ddd.send("step_out")
}
Step_Over(){
	v.ddd.send("step_over")
}
stop(x:=0){
	Stop_Debugger:
	if(v.dbgsock=""&&x=0)
		return m("Currently no file being debugged"),debug.off()
	v.ddd.send("stop")
	sleep,200
	v.ddd.debug.disconnect(),v.ddd.debug.off()
	csc("Scintilla1")
	return
}
Tab_Width(){
	static
	setup(23),width:=settings.ssn("//tab").text?settings.ssn("//tab").text:5
	Gui,Add,Text,,Enter a number for the tab width
	Gui,Add,Edit,w100 vtabwidth gtabwidth,%width%
	Gui,Show,,Tab Width
	return
	23GuiEscape:
	23GuiClose:
	hwnd({rem:23})
	return
	tabwidth:
	Gui,Submit,Nohide
	tabwidth:=tabwidth?tabwidth:5,csc().2036(tabwidth),settings.Add("tab").text:=tabwidth
	return
}
Test_Plugin(){
	Save(),Exit(1,1)
	Run,%A_ScriptFullPath%
	ExitApp
	return
}
Testing(x:=0){
	m("Testing","ico:?")
}
Testing1(){
	m("neat :)")
}
Toggle_Comment_Line(){
	sc:=csc(),sc.2078
	pi:=posinfo(),sl:=sc.2166(pi.start),el:=sc.2166(pi.end),end:=pi.end,single:=sl=el?1:0
	replace:=settings.ssn("//comment").text,replace:=replace?replace:";"
	replace:=RegExReplace(replace,"%a_space%"," ")
	if(v.options.Build_Comment!=1){
		while,(sl<=el){
			letter:=sc.textrange(min:=sc.2128(sl),min+StrLen(replace))
			if(min>end&&!single)
				break
			if(letter=replace)
				sc.2190(min),sc.2192(min+StrLen(replace)),sc.2194(0,""),end--
			else
				sc.2190(min),sc.2192(min),sc.2194(StrLen(replace),replace),end++
			sl++
		}
	}else{
		sc:=csc(),order:=[],pi:=posinfo(),order[sc.2166(sc.2008)]:=1,order[sc.2166(sc.2009)]:=1,min:=order.MinIndex(),max:=order.MaxIndex()
		Loop,% max-min+1{
			if(!RegExMatch(sc.getline(min+(A_Index-1)),"^\s*;")){
				Loop,% max-min+1{
					indentpos:=sc.2128(min+(A_Index-1))
					sc.2003(indentpos,";"),added:=1,pi.end+=1
				}
				pi.start+=1
			}
		}
		if(!added){
			Loop,% max-min+1{
				if(RegExMatch(sc.getline(min+(A_Index-1)),"^\s*;")){
					indentpos:=sc.2128(min+(A_Index-1))
					sc.2645(indentpos,1),pi.end-=1
					if(A_Index=1)
						pi.start-=1
				}
			}
		}
		sc.2160(pi.start,pi.end)
	}
	sc.2079
}
togglemenu(Label){
	if(!Label)
		return
	top:=menus.ssn("//*[@clean='" label "']"),ea:=xml.ea(top)
	Menu,% ssn(top.ParentNode,"@name").text,ToggleCheck,% ea.name
}
Toggle_Multiple_Line_Comment(){
	sc:=csc(),pos:=posinfo()
	GuiControl,1:-Redraw,% csc().sc
	if(sc.2010(sc.2008)!=11&&sc.2010(sc.2009)!=11)
		sc.2078(),start:=sc.2128(sline:=sc.2166(pos.start)),end:=sc.2136(sc.2166(pos.end)),sc.2003(end,"`n*/"),sc.2003(start,"/*`n"),sc.2079,edit:=1
	else{
		top:=sc.2225(sc.2166(sc.2008)),bottom:=sc.2224(top,-1)
		if(Trim(Trim(sc.getline(top)),"`n")="/*"){
			sc.2078
			for a,b in [bottom,top]{
				start:=sc.2167(b),length:=(sc.2136(b)+1)-start
				start:=sc.2136(b)=sc.2006?start-1:start
				sc.2645(start,length)
			}
			sc.2079
		}
	}if(v.options.full_auto){
		fix_indent()
		if(sline)
			sc.2025(sc.2128(sline+1))
		Sleep,100
	}if(edit&&v.options.Disable_Line_Status!=1){
		line:=sc.2225(sc.2166(pos.start)+1),end:=sc.2224(line,-1)
		Loop,% end+1-line
		{
			style:=sc.2533(line+(A_Index-1))
			if(style~="(0|31|33)")
				sc.2242(4,1),sc.2240(4,5),sc.2532(line+(A_Index-1),30)
		}
	}
	GuiControl,1:+Redraw,% csc().sc
}
TrayMenu(){
	Menu,Tray,NoStandard
	Menu,Tray,Add,Show AHK Studio,show
	Menu,Tray,Default,Show AHK Studio
	Menu,Tray,Standard
}
tv(tv:=0,open:="",history:=0){
	static fn,noredraw,tvbak,lastwidth
	Gui,1:Default
	Gui,1:TreeView,SysTreeView321
	tvbak:=tv
	TV_Modify(tv,"Select Vis Focus")
	if(open=""&&history=0)
		return
	tv:
	if((A_GuiEvent="S"||open||history)){
		SetTimer,matchfile,Off
		if(!v.startup&&!history)
			GetPos(),count:=0
		ei:=open?tvbak:a_eventinfo,sc:=csc(),file:=files.ssn("//*[@tv='" ei "']"),fn:=ssn(file,"@file").text
		sc.Enable()
		if(file.nodename!="file")
			return
		if(!ssn(file,"@tv").text)
			return
		if(!doc:=ssn(file,"@sc")){
			tvtop:
			Sleep,10
			doc:=sc.2375
			if(!doc)
				doc:=sc.2376(0,doc)
			if(!(doc)){
				count++
				if(count=3)
					return
				goto,tvtop
			}
			/*
				;this is also where you would check for new words
				;main scan
			*/
			sc.2358(0,doc),tt:=update({get:fn}),sc.2037(65001),txt:=Encode(tt),set(),sc.2181(0,&txt),sc.2175(),dup:=files.sn("//file[@file='" fn "']")
			while,dd:=dup.item[A_Index-1]
				dd.SetAttribute("sc",doc)
		}else
			sc.2358(0,doc.text),marginwidth(sc),current(1).SetAttribute("last",fn)
		Sleep,150
		SetPos(ei),uppos(),MarginWidth(sc)
		GuiControl,1:+Redraw,% sc.sc
		if(history!=1)
			History(fn)
		if(open=2)
			history:=0
		WinSetTitle,% hwnd([1]),,AHK Studio - %fn%
		sc.4004("fold",[1])
		Sleep,150
		SetTimer,matchfile,-100
		if(v.savelinestat[fn]){
			sc:=csc()
			Loop,% sc.2154
				if(sc.2533(A_Index-1)=30)
					sc.2532(A_Index-1,31)
		}v.savelinestat.delete(fn),sc.Enable(1),MarginWidth() ;#[TV Figure out how to wait until the code is up and ready]
	}if((A_GuiEvent="+"||A_GuiEvent="-"||open)&&v.options.Auto_Project_Explorer_Width)
		SetTimer,auto-adjust,-100
	return
	matchfile:
	Gui,1:Default
	Gui,1:TreeView,SysTreeView321
	sc:=csc()
	doc:=sc.2357(),tv:=files.ssn("//*[@tv='" TV_GetSelection() "']"),ea:=xml.ea(tv)
	if(doc!=ea.sc)
		tv(TV_GetSelection(),1)
	return
	auto-adjust:
	obj:=[],VarSetCapacity(rect,16),VarSetCapacity(sbinf,28),NumPut(28,sbinf,0),NumPut(0x1|0x2|0x4|0x10,sbinf,4),tv:=0,DllCall("GetScrollInfo",ptr,v.ce,Int,1,ptr,&sbInf),info:=NumGet(sbinf,16),Default("TreeView","SysTreeView321")
	while,tv:=TV_GetNext(tv,"F"){
		NumPut(tv,rect,0)
		SendMessage,0x1100+4,1,&rect,SysTreeView321,% hwnd([1])
		obj[NumGet(rect,8)+(info?25:5)]:=1
	}
	if(lastwidth!=obj.MaxIndex())
		settings.ssn("//gui").SetAttribute("projectwidth",obj.MaxIndex()),Resize("rebar")
	lastwidth:=obj.MaxIndex()
	return
}
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
Undo(){
	csc().2176
}
UnSaved(){
	un:=files.sn("//main[@untitled]")
	while,uu:=un.item[A_Index-1],ea:=xml.ea(uu.FirstChild){
		tv(ea.tv)
		Sleep,300
		MsgBox,36,Save this project?,There is unsaved information, Save it?`nAll Unsaved Data Will Be Lost!
		IfMsgBox,Yes
		{
			FileSelectFile,newfile,S16,,Save Untitled File,*.ahk
			if(ErrorLevel||newfile="")
				Continue
			file:=FileOpen(newfile,"RW","UTF-8"),file.seek(0),file.write(RegExReplace(csc().getuni(),"\R","`r`n")),file.length(file.position),file.close()
			if(!settings.ssn("//open/file[text()='" newfile "']")&&newfile)
				settings.add("open/file",,newfile)
			settings.add("last/file",,newfile)
		}
	}
	v.unsaved:=1
}
Update(info){
	static update:=[],updated:=[]
	if(info="updated")
		return updated
	if(info.edited)
		return updated[info.edited]:=1
	if(info="clearupdated")
		return updated:=[]
	if(info="get")
		return [update,updated]
	if(info.file){
		update[info.file]:=info.text
		if(!info.load)
			updated[info.file]:=1
		return
	}if(info.get)
		return update[info.get]
	if(info.sc){
		sc:=csc(),fn:=files.ssn("//*[@sc='" info.sc "']"),ea:=xml.ea(fn),item:=ea.file?ea.file:ea.note
		if(ea.virtual)
			return
		if(!item)
			return
		if(update[item]=sc.getuni())
			return
		if(updated[item]=""){
			SplitPath,% ea.filename,,,,nne
			TV_Modify(ea.tv,"","*" (v.options.Hide_File_Extensions?nne:ea.filename))
		}if(v.options.disable_line_status!=1){
			pos:=posinfo(),line:=sc.2166(pos.start),end:=sc.2166(pos.end)
			if(line!=end){
				Loop,% end-line
				{
					style:=sc.2533(line+(A_Index-1))
					if(style~="(0|31|33|48)")
						sc.2242(4,1),sc.2240(4,5),sc.2532(line+(A_Index-1),30)
				}
			}Else{
				style:=sc.2533(line)
				if(style~="(0|31|33|48)")
					sc.2242(4,1),sc.2240(4,5),sc.2532(line,30)
			}
			if(sc.2570>1){
				Loop,% sc.2570
				{
					line:=sc.2166(sc.2577(A_Index-1)),style:=sc.2533(line)
					if(style~="(0|31|33|48)")
						sc.2242(4,1),sc.2240(4,5),sc.2532(line,30)
				}
			}
		}
		updated[item]:=1,update[item]:=sc.getuni()
		return
	}
	return
}
Upper(info){
	StringUpper,info,info
	return info
}
uppos(){
	sc:=csc()
	line:=sc.2166(sc.2008)
	if(v.track.line)
		if(v.track.line!=line||v.track.file!=current(2).file)
			v.track:=[]
	if(lastline!=line)
		hltline()
	lastline:=line
	if(Abs(sc.2008-sc.2009)>2)
		duplicates()
	Else if v.duplicateselect
		sc.2500(3),sc.2505(0,sc.2006),v.duplicateselect:="",v.selectedduplicates:=""
	if(sc.2353(sc.2008-1)>0)
		sc.2351(v.bracestart:=sc.2008-1,v.braceend:=sc.2353(sc.2008-1)),v.highlight:=1
	else if(sc.2353(sc.2008)>0)
		sc.2351(v.bracestart:=sc.2008,v.braceend:=sc.2353(sc.2008)),v.highlight:=1
	else if v.highlight
		v.bracestart:=v.braceend:="",sc.2351(-1,-1),v.highlight:=0
	text:="Line:" sc.2166(sc.2008)+1 " Column:" sc.2129(sc.2008) " Length:" sc.2006 " Position:" sc.2008,total:=0
	if(sc.2008!=sc.2009){
		text.=" Selected Count:" Abs(sc.2008-sc.2009)
		if(sc.2570>1){
			Loop,% sc.2570
				total+=Abs(sc.2579(A_Index-1)-sc.2577(A_Index-1))
			text.=" Total Selected:" total
	}}
	SetStatus(text,1)
}
URLDownloadToVar(url){
	http:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
	if(proxy:=settings.ssn("//proxy").text)
		http.setProxy(2,proxy)
	http.Open("GET",url,1),http.Send(),http.WaitForResponse
	return http.ResponseText
}
var(){
	for a,b in {border:33,caption:4,menu:15}{
		SysGet,%a%,%b%
		v[a]:=%a%
	}
}
Widths(){
	static projectwidth,codewidth
	setup(24)
	WinGetPos,,,width,,% hwnd([1])
	Gui,Add,Text,,Project Explorer
	Gui,Add,Slider,% "Range0-" width " w" width-100 " gprojectwidth vprojectwidth AltSubmit",% project:=settings.get("//gui/@projectwidth",200)
	check:=v.options.Hide_Project_Explorer?"Checked":""
	Gui,Add,Checkbox,ghpe %check%,Hide
	Gui,Add,Text,,Code Explorer
	Gui,Add,Slider,% "Range0-" width " w" width-100 " gcodewidth vcodewidth AltSubmit",% code:=settings.get("//gui/@codewidth",200)
	check:=v.options.Hide_Code_Explorer?"Checked":""
	Gui,Add,Checkbox,ghce %check%,Hide
	Gui,Show,% Center(24),GUI Widths
	return
	projectwidth:
	codewidth:
	Gui,24:Submit,NoHide
	value:=A_ThisLabel="projectwidth"?projectwidth:A_ThisLabel="codewidth"?codewidth:""
	attribute:=settings.Add("gui")
	attribute.SetAttribute(A_ThisLabel,value),Resize("rebar")
	return
	24GuiClose:
	24GuiEscape:
	hwnd({rem:24})
	return
	hce:
	return Label("Hide_Code_Explorer")
	hpe:
	return Label("Hide_Project_Explorer")
}
Label(Label){
	SetTimer,%Label%,-10
}
WinPos(hwnd:=1){
	VarSetCapacity(rect,16),DllCall("GetClientRect",ptr,hwnd(hwnd),ptr,&rect)
	WinGetPos,x,y,,,% hwnd([hwnd])
	w:=NumGet(rect,8),h:=NumGet(rect,12),text:=(x!=""&&y!=""&&w!=""&&h!="")?"x" x " y" y " w" w " h" h:""
	return {x:x,y:y,w:w,h:h,text:text}
}
Words_In_Document(){
	doc:=update({get:ssn(current(),"@file").text}),sc:=csc(),word:=sc.getword(),words:=RegExReplace(RegExReplace(doc,"[\W|\d]"," "),"\s+","|")
	Sort,words,D|U
	for a,b in StrSplit(words,"|")
		if(StrLen(b)>2)
			list.=b " "
	if(word)
		StringReplace,list,list,%word%%A_Space%,,All
	sc.2100(StrLen(word),Trim(list))
}
;plugin
Quick_Scintilla_Code_Lookup(){
	sc:=csc(),word:=upper(sc.textrange(start:=sc.2266(sc.2008,1),end:=sc.2267(sc.2008,1))),Scintilla()
	ea:=scintilla.ea("//commands/item[@name='" word "']")
	if(ea.code){
		syn:=ea.syntax?ea.code "()":ea.code,sc.2160(start,end),sc.2170(0,[syn])
		if(ea.syntax)
			sc.2025(sc.2008-1),Context()
		return
	}
	slist:=scintilla.sn("//commands/item[contains(@name,'" word "')]"),ll:="",count:=0
	while,sl:=slist.item[A_Index-1]
		ll.=ssn(sl,"@name").text " ",count++
	if(count=0)
		return
	sc.2117(1,Trim(ll)),sc.2160(start,end)
}
Scintilla_Code_Lookup(){
	static slist,cs,newwin
	Scintilla(),slist:=scintilla.sn("//commands/item")
	newwin:=new GUIKeep(8)
	newwin.Add("Edit,Uppercase w500 gcodesort vcs,,w","ListView,w720 h500 -Multi,Name|Code|Syntax,wh","Radio,xm Checked gcodesort,&Commands,y","Radio,x+5 gcodesort,C&onstants,y","Radio,x+5 gcodesort,&Notifications,y","Button,xm ginsert Default,Insert code into script,y","Button,gdocsite,Goto Scintilla Document Site,y")
	while,sl:=slist.item(A_Index-1)
		LV_Add("",ssn(sl,"@name").text,ssn(sl,"@code").text,ssn(sl,"@syntax").text)
	newwin.Show("Scintilla Code Lookup")
	Loop,3
		LV_ModifyCol(A_Index,"AutoHDR")
	hotkeys([8],{up:"page",down:"page",PgDn:"page",PgUp:"page"})
	return
	page:
	ControlSend,SysListView321,{%A_ThisHotkey%},% newwin.id
	return
	docsite:
	Run,http://www.scintilla.org/ScintillaDoc.html
	return
	codesort:
	cs:=newwin[].cs
	Gui,8:Default
	GuiControl,1:-Redraw,SysListView321
	LV_Delete()
	for a,b in {1:"commands",2:"constants",3:"notifications"}{
		ControlGet,check,Checked,,Button%a%,% hwnd([8])
		value:=b
		if(Check)
			break
	}
	slist:=scintilla.sn("//" value "/*[contains(@name,'" cs "')]")
	while,(sl:=xml.ea(slist.item(A_Index-1))).name
		LV_Add("",sl.name,sl.code,sl.syntax)
	LV_Modify(1,"Select Vis Focus")
	Loop,3
		LV_ModifyCol(A_Index,"AutoHDR")
	GuiControl,1:+Redraw,SysListView321
	return
	insert:
	LV_GetText(code,LV_GetNext(),2),hwnd({rem:8}),sc:=csc(),sc.2003(sc.2008,[code]),npos:=sc.2008+StrLen(code),sc.2025(npos)
	return
	lookupud:
	Gui,8:Default
	count:=A_ThisHotkey="up"?-1:+1,pos:=LV_GetNext()+count<1?1:LV_GetNext()+count,LV_Modify(pos,"Select Focus Vis")
	return
	8GuiClose:
	8GuiEscape:
	hwnd({rem:8})
	return
}
Scintilla(){
	static list
	if(!FileExist("lib\scintilla.xml")){
		SplashTextOn,300,100,Downloading definitions,Please wait
		URLDownloadToFile,https://raw.githubusercontent.com/maestrith/AHK-Studio/master/lib/scintilla.xml,lib\scintilla.xml
		Sleep,500
		SplashTextOff
	}
	if(!IsObject(scintilla)){
		scintilla:=new xml("scintilla","lib\scintilla.xml")
	}
}
;/plugin
Online_Help(){
	Run,https://github.com/maestrith/AHK-Studio/wiki
}
Kill_Process(){
	static newwin,pid
	if(!v.runpid.MinIndex())
		return m("No Running Processes")
	newwin:=new GUIKeep("Kill_Process"),newwin.add("ListView,w200 h200,Processes|Name,wh","Button,gkillit Default,Kill Process")
	WinGet,list,list,ahk_class AutoHotkeyGUI
	obj:=[]
	Loop,%list%{
		WinGetTitle,name,% "ahk_id" list%A_Index%
		WinGet,pid,pid,% "ahk_id" list%A_Index%
		obj[pid]:={name:name,hwnd:list%A_Index%}
		total:=name "`n"
	}
	for a in v.runpid
		LV_Add("",a,obj[a].name)
	newwin.show("Kill Process")
	Loop,2
		LV_Modify(A_Index,"AutoHDR")
	return
	killit:
	if(!LV_GetNext())
		return m("Select an item to kill first")
	LV_GetText(pid,LV_GetNext())
	WinGet,id,id,ahk_pid%a%
	Process,Close,%pid%
	SetTimer,checkkill,200
	count:=0
	return
	checkkill:
	Process,Exist,%pid%
	Exist:=ErrorLevel
	if(count>20){
		m("Could not close this process.")
		SetTimer,checkkill,Off
	}
	if(!Exist){
		Gui,Kill_Process:Default
		Gui,ListView,SysListView321
		LV_Delete(LV_GetNext())
		SetTimer,checkkill,Off
	}count++
	return
	Kill_Processguiescape:
	Kill_Processguiclose:
	newwin.Destroy()
	return
}
Forum(){
	Run,https://autohotkey.com/boards/viewtopic.php?f=6&t=300&hilit=ahk+studio
}