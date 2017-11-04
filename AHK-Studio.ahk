#SingleInstance,Off
#MaxHotkeysPerInterval,2000
#NoEnv
SetBatchLines,-1
SetWorkingDir,%A_ScriptDir%
SetControlDelay,-1
SetWinDelay,-1
DetectHiddenWindows,On
CoordMode,ToolTip,Screen
Tick:=A_TickCount
global v:=[],MainWin,Settings:=new XML("settings","lib\Settings.xml"),files:=new XML("files"),Positions:=new XML("positions","lib\Positions.xml"),cexml:=new XML("cexml","Lib\FileCache.xml"),History:=new XML("HistoryXML"),vversion,commands,menus,scintilla,TVC:=new EasyView(),RCMXML:=new XML("RCM","lib\RCM.xml"),TNotes,debugwin,Selection:=new SelectionClass(),Menus,Vault:=new XML("vault","lib\Vault.xml")
new ScanFile()
vversion:=new XML("versions",(FileExist("lib\Github.xml")?"lib\Github.xml":"lib\Versions.xml")),History("Startup")
if(!settings[]){
	Run,lib\Settings.xml
	m("Oh boy...check the settings file to see what's up.")
}v.LineEdited:=[],v.LinesEdited:=[],v.RunObject
ComObjError(0),FileCheck(%True%),new Keywords(),Options("startup"),menus:=new XML("menus","Lib\Menus.xml"),new Omni_Search_Class(),Gui(),DefaultRCM(),CheckLayout()
/*
	Hotkey,End,EndThing,On
	RegExMatch()
	GuiContextMenu()
*/
return
/*
	EndThing:
	sc:=csc()
	if(sc.2102)
		sc.2101()
	Send,{%A_ThisHotkey%}
*/
return
/*
	More things
 	Add in #Include brings up a list of items in your library
	Debugging Joe Glines{
		have the option to have the Variable browser dockable to the side of debug window.
	}
	Darth_diggler{
		Right Click and Edit from Explorer not selecting the proper file when opening new files
		Downloading plugins does not work in compiled version.
		Also ability to add launching applications from the toolbar
	}
	Run1e{
		studio bugs:
		the x-32000 y-32000 thing when maximizing the window the wrong way
		highlighting a word underlines the other ones, but it dissapears after a bit and the select duplicates hotkey doesn't work
		I think theres a massive memory leak somewhere.. studio slows down to a halt after a while
	}
	CUSTOM COMMANDS{
		needs fixed, when changing things from auto-indent to another area it didn't save
	}
	SysGet,Count,MonitorCount
	Loop,%count%
	{
		SysGet,Mon,Monitor,%A_Index%
		Monitors.="Monitor " A_Index "`n`nLeft: " MonLeft " Top: " MonTop " Right: " MonRight " Bottom: " MonBottom "`n`n"
	}
	MsgBox,% Clipboard:=Monitors "`n`nPlease send this to maestrith"
	see if the caption area is within the visible area and if not move it.
	when you close make sure that the coordinates are within the same screen that the window is on.
	if not
		move the coords to the top left or center of that screen and update.
	have it check to see if the window (any part) is in the visible area
	also check to see if the last GUI position is somewhere on that monitor
	if it isn't
		update the positions.
	Monitor 1
	Left: 0 Top: 0 Right: 1920 Bottom: 1200
	Monitor 2
	Left: 1920 Top: -454 Right: 3000 Bottom: 1466
	Ok, I found it. For some reason, with the previous update,
	auto complete was disabled in all its various incarnations (you have a lot of auto-complete options lol) and
	I found the tooltip-from-documentation thingy I was talking about.
	You designated it context sensitive help.
	So, those weren't bugs per se, they were just disabled. Didn't expect that since I never had to enable them before
	FileCheck(){
		DefaultOptions make sure to have them checked for and if they are not in your menus.xml, when you add them in, have them
		pre-selected
	}
	FileSelectFile
	MISC NOT WORKING:
	Undo:
	When you undo something with more than 1 class it doesn't undo properly
	Joe_Glines{
		Check Edited Files On Focus:
		have it so that it asks first to replace the text rather than automatically
		More languages (programming)
	}
	Misc Ideas:
	more languages (spoken)
	When you edit/add a line with an include:{
		have it scan that line (add a thing in the Scan_Line() for it)
	}
*/
#Include %A_ScriptDir%
#IfWinActive
#IfWinActive,AHK Studio
#Include *i HotStrings.ahk
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
	Setup(11),Hotkeys(11,{"Esc":"11Close"}), Version:="1.005.09"
	Gui,Margin,0,0
	sc:=new s(11,{pos:"x0 y0 w700 h500"}),csc({hwnd:sc})
	Gui,Add,Button,gdonate,Donate
	Gui,Add,Button,x+M gsite,Website
	Gui,Show,w700 h550,AHK Studio Help Version: %version%
	sc.2181(0,about),sc.2025(0),sc.2268(1)
	return
	11Close:
	11GuiClose:
	11GuiEscape:
	hwnd({rem:11})
	return
	site:
	Run,https://github.com/maestrith/AHK-Studio
	return
}
Testing(){
	/*
		sc:=csc()
		RegExMatch(Clipboard,"O)start=\x22(\d+)\x22",Start)
		RegExMatch(Clipboard,"O)end=\x22(\d+)\x22",End)
		return sc.2160(Start.1,End.1)
		return m((Lang:=GetLanguage(sc)),sc.2010(sc.2008),Keywords.GetXML(Lang)[])
	*/
	m(v.Words[csc().2357])
	if(A_UserName!="maestrith")
		return m("Testing")
	/*
		return m(TVC.Controls.1.hwnd) ;the hwnd for Project Explorer
	*/
	return m("I'm sleepy.")
}
/*
	put this in there and use it for A_TickCount stuffs.
*/
Class TimerClass{ ;Thanks Run1e
	static Timers:=[]
	Init(){
		DllCall("QueryPerformanceFrequency", "Int64P", F)
		this.Freq := F
	}
	Current(){
		DllCall("QueryPerformanceCounter","Int64P",Timer)
		return Timer
	}
	Start(ID){
		this.Timers[ID]:=this.Current()
	}
	Stop(ID){
		return ((this.Current()-this.Timers[ID])/this.Freq),this.Timers.Delete(ID)
	}
}
Activate(a,b,c,d){
	if(A_Gui=1){
		if(a&&v.Options.Check_For_Edited_Files_On_Focus=1)
			Check_For_Edited()
		csc().2400
	}
	return 0
}
Add_Selected_To_Personal_Variables(){
	sc:=csc()
	if(!text:=sc.GetSelText())
		return m("Please select some text first")
	Words:=RegExReplace(RegExReplace(text,"x)([^\w])"," "),"(\b\d+\b|\b(\w{1,2})\b)","")
	Sort,Words,UD%A_Space%
	if(!top:=Settings.SSN("//Variables"))
		top:=Settings.Add("Variables")
	for a,b in StrSplit(Words," "){
		if(!b:=Trim(b))
			Continue
		if(!Settings.SSN("//Variables/Variable[text()='" b "']"))
			Settings.Under(top,"Variable",,b)
	}new Keywords()
	/*
		Keywords()
	*/
}
AddBookmark(line,search){
	sc:=csc(),end:=sc.2136(line),start:=sc.2128(line),name:=(Settings.SSN("//bookmark").text),name:=name?name:SubStr(StrSplit(Current(2).file,"\").pop(),1,-4)
	for a,b in {"$file":SubStr(StrSplit(Current(3).file,"\").pop(),1,-4),"$project":SubStr(StrSplit(Current(2).file,"\").pop(),1,-4)}
		name:=RegExReplace(name,"i)\Q" a "\E",b)
	if(RegExMatch(name,"UO)\[(.*)\]",time)){
		FormatTime,currenttime,%A_Now%,% time.1
		name:=RegExReplace(name,"\Q[" time.1 "]\E",currenttime)
	}sc.2003(end," " Chr(59) search.1 "[" name "]"),sc.2160(end+4,end+4+StrPut(name,utf-8)-1)
	return name
}
AddInclude(Filename:="",text:="",pos:="",Show:=1){
	static new
	file:=FileOpen(filename,"RW","UTF-8"),file.write(text),file.length(file.position),rel:=RelativePath(Current(2).file,filename),sc:=csc(),current:=Current(4)
	SplitPath,filename,fn,dir,ext,nne,drive
	FileGetTime,time,%filename%
	if(v.Options.Includes_In_Place){
		line:=sc.2166(sc.2008)
		if(Trim(RegExReplace(sc.GetLine(line),"\R"))){
			sc.2003(sc.2136(line),"`n#Include " rel)
			if(v.Options.Full_Auto_Indentation)
				NewIndent()
		}else
			sc.2003(sc.2008,"#Include " rel)
	}else{
		if(SSN(current,"@file").text=Current(3).file)
			sc.2003(sc.2006,"`n#Include " rel)
		else
			Update({file:Current(2).file,text:Update({get:Current(2).file}) "`n#Include " rel}),current.RemoveAttribute("sc")
	}
	;#[Needs to check to see if it is in a folder first]
	Relative:=StrSplit(rel,"\"),Parent:=Current(1),TV:=SSN(Parent,"descendant::*/@tv").text
	/*
		m(SSN(Parent,"descendant::"))
		ExitApp
	*/
	if(Relative.MaxIndex()>1){
		for a,b in Relative{
			if(a=Relative.MaxIndex())
				Break
			build.=b "\"
			if(!Node:=files.Find(Parent,"folder/@path",build))
				Node:=files.Under(Parent,"folder",{path:build,tv:(TV:=TVC.Add(1,b,TV,"Sort"))})
			else
				TV:=SSN(Node,"@tv").text
	}}else
		TV:=SSN(current,"@tv").text
	new:=files.Under(current,"file",{id:GetID(),encoding:"UTF-8",file:filename,include:"#Include " rel,inside:SSN(current,"@file").text,dir:dir,filename:fn,github:fn,nne:nne,time:time,encoding:"UTF-8",scan:1,ext:Ext,tv:TVC.Add(1,fn,TV,"Sort")})
	add:=Current(7).AppendChild(new.CloneNode(1))
	add.SetAttribute("type","File")
	Update({file:filename,text:text,encoding:"UTF-8",node:current})
	ScanFiles()
	Code_Explorer.Scan(new)
	Default("SysTreeView321")
	if(Show)
		tv(SSN(new,"@tv").text,pos)
}
AddMissing(){
	all:=SN(Current(5),"descendant::*[not(@cetv)]")
	while(aa:=all.item[A_Index-1]),ea:=XML.EA(aa){
		if(!header:=SSN(aa.ParentNode,"@cetv").text)
			header:=Header(ea.type)
		aa.SetAttribute("cetv",TVC.Add(2,ea.text,header,(ea.type~="Method|Property"=0?"Sort":"")))
	}
}
AddNewLines(text,current){
	return
	Omni:=GetOmni(SSN(Current,"@ext").text)
	for a,b in GetAllTopClasses(text,,,Omni){
		if((nodes:=SN(current,"descendant::*[@type='Class' and @text='" b.name "']")).length)
			Code_Explorer.RemoveTV(nodes)
		Class(b.text,current)
		for c,d in Omni{
			if(c~="Class|Function|Property")
				Continue
			pos:=1
			while(RegExMatch(b.text,d,found,pos),pos:=found.Pos(1)+found.Len(1)){
				if(!found.len(1))
					Break
				cexml.Under(current,"info",{type:c,text:found.1,upper:Upper(found.1),cetv:TVC.Add(2,found.1,Header(c),"Sort")})
			}
		}	
		StringReplace,text,text,% b.text
	}
	for a,b in Omni{
		if(a="Class")
			Continue
		pos:=1
		while(RegExMatch(text,b,found,pos),pos:=found.Pos(1)+found.Len(1)){
			if(!found.len(1))
				Break
			Default("SysTreeView322")
			new:=cexml.Under(current,"info",{type:a,text:found.1,upper:Upper(found.1),cetv:TVC.Add(2,found.1,Header(a),"Sort")})
			if(a="Function")
				new.SetAttribute("args",found.3)
			if(a="Instance")
				new.SetAttribute("class",found.2)
		}
	}
}
Auto_Insert(){
	static main
	new SettingsWindow("Auto Insert"),main:=SettingsWindow.win.xml
	if(!Settings.SSN("//autoadd"))
		Settings.Add("//autoadd")
	Gosub,AIPopulate
	return
	AIPopulate:
	all:=Settings.SN("//autoadd/*"),ea:=main.EA("//*[@label='change']"),SettingsDefault("AIListview"),LV_Delete()
	while(aa:=all.item[A_Index-1]),ea:=XML.EA(aa)
		LV_Add("",ea.trigger,ea.add)
	Loop,2
		LV_ModifyCol(A_Index,"AutoHDR")
	;LV_Modify(1,"Select Vis Focus")
	return
	Change:
	if(A_GuiEvent!="I")
		return
	if(!next:=LV_GetNext())
		return
	LV_GetText(enter,next),LV_GetText(insert,next,2)
	for a,b in {EnteredKey:enter,AddedKey:insert}
		ControlSetText,,%b%,% "ahk_id" SettingsDefault(a,1).hwnd
	return
	AddKey:
	value:=SettingsWindow.win[],enter:=value.enter,add:=value.add
	if(!(enter&&add))
		return m("Both values need to be filled in")
	if(ff:=Settings.Find("//autoadd/key/@trigger",enter))
		ff.SetAttribute("add",add)
	else if(!Settings.SSN("//autoadd/key[@trigger='" enter "']"))
		Settings.Under(Settings.SSN("//autoadd"),"key",{add:add,trigger:enter})
	Gosub,AIPopulate
	for a,b in ["EnteredKey","AddedKey"]{
		ea:=SettingsDefault(b,1)
		if(A_Index=1)
			ControlFocus,,% "ahk_id" ea.hwnd 
		GuiControl,Settings:,% ea.hwnd
	}BraceSetup()
	return
	RemKey:
	SettingsDefault("AIListview")
	while,LV_GetNext()
		LV_GetText(trigger,LV_GetNext()),rem:=Settings.Find("//autoadd/key/@trigger",trigger),rem.ParentNode.RemoveChild(rem),LV_Delete(LV_GetNext())
	return BraceSetup()
}
SettingsDefault(id,return:=0){
	main:=SettingsWindow.win.xml,node:=main.SSN("//*[@id='" id "']"),win:=main.SSN("//window/@name").text,ea:=XML.EA(node)
	if(ea.type){
		Gui,%win%:Default
		Gui,% win ":" ea.type,% ea.hwnd
	}
	return (return?XML.EA(node):node)
}
AutoClass(){
	sc:=csc(),line:=sc.2166(sc.2008),text:=sc.TextRange(sc.2128(line),sc.2008)
	if(RegExMatch(text,"i)\bnew\b\s+" v.word)){
		if(sc.2007(sc.2008)!=40)
			sc.2003(sc.2008,"()"),sc.2025(sc.2008+1),Context()
		return
	}if(sc.2007(sc.2008)!=46)
		InsertAll(".",1)
	Show_Class_Methods(v.word)
}
AutoMenu(){
	AutoMenu:
	sc:=csc()
	if(sc.2007(sc.2008-1)~="40|123")
		return
	command:=RegExReplace(Context(1).word,"#")
	if(v.word&&sc.2102=0&&v.Options.Auto_Complete){
		if(l:=commands.SSN("//Context/" command "/descendant-or-self::list[text()='" RegExReplace(v.word,"#") "']")){
			if(!list:=SSN(l,"@list"))
				return
			Insert:=v.Options.Auto_Space_After_Comma?", ":","
			if(sc.2007(sc.2008-StrLen(Insert))!=44)
				sc.2003(sc.2008,Insert),sc.2025(sc.2008+StrLen(Insert))
			sc.2100(0,list.text,v.word:="")
	}}return
}
Backspace(sub:=1){
	ControlGetFocus,focus,A
	send:=sub?"Backspace":"Delete",sc:=csc(),Start:=sc.2166(sc.2008)
	if(!v.LineEdited[Start])
		SetScan(Start)
	if(!InStr(focus,"Scintilla")){
		Send,{%A_ThisHotkey%}
		return
	}if(!v.Options.Smart_Delete){
		Send,{%send%}
		LineStatus.DelayAdd(sc.2166(sc.2008),1)
		Update({sc:sc.2357})
		if(!Current(3).Edited)
			return Edited(),UpPos()
		return UpPos()
	}if(sc.2570=1){
		cpos:=(opos:=sc.2585(0))-sub,chr:=Chr(sc.2007(cpos))
		if(chr~="\(|\)|\[|\]|\x22|<|>|'|\{|\}"=0){
			Send,{%send%}
			return Edited(),UpPos(),Update({sc:sc.2357})
	}}if(sc.2102)
		sc.2101
	if(sc.2102){
		if(sub)
			Send,{Backspace}
		else
			sc.2101
		return UpPos()
	}sc.2078
	Loop,% sc.2570{
		index:=A_Index-1,cpos:=sc.2585(index)-sub,chr:=Chr(cc:=sc.2007(cpos)),style:=sc.2010(cpos),pos:=sc.2585(index),line:=sc.2166(cpos)
		if((start:=sc.2585(index))!=(end:=sc.2587(index))){
			sc.2645(start,end-start)
			Continue
		}if(BraceMatch:=v.BraceDelete[chr]){
			if(chr="{"){
				if((match:=sc.2353(cpos))>=0)
					sc.2645(match,1),sc.2645(cpos,1),sc.2584(index,cpos),sc.2586(index,match-1)
			}else{
				if(chr="%"){
					if(Chr(sc.2007(cpos-1))="%")
						sc.2645(cpos-1,2)
					else
						sc.2645(cpos,1)
				}else
					(Chr(sc.2007(cpos+1))=BraceMatch)?sc.2645(cpos,2):GoToPos(index,cpos+(sub?0:1))
		}}else if(BraceMatch:=v.DeleteBrace[chr]){
			if(bracematch=Chr(sc.2007(cpos-1)))
				sc.2645(cpos-1,2)
			else if(chr~="(\}|\)|\>|\])")
				if((sc.2353(cpos)<0))
					sc.2645(cpos,1)
			else
				GoToPos(index,cpos)
		}else{
			if(cc<0){
				if(send="Delete")
					sc.2645(cpos,2)
				if(send="Backspace")
					sc.2645(cpos-1,2)
			}else
				sc.2645(cpos,1)
	}}sc.2079
}
BookEnd(add,hotkey){
	if(!(add&&hotkey))
		return
	sc:=csc(),sc.2078,add:=add?add:v.match[hotkey]
	loop,% sc.2570
		start:=sc.2585(A_Index-1),end:=sc.2587(A_Index-1),sc.2686(end,end),sc.2194(1,add),sc.2686(start,start),sc.2194(1,hotkey),sc.2584(A_Index-1,start+1),sc.2586(A_Index-1,end+1)
	sc.2079
}
BraceHighlight(){
	sc:=csc()
	if(sc.2353(sc.2008-1)>0)
		sc.2351(v.bracestart:=sc.2008-1,v.braceend:=sc.2353(sc.2008-1)),v.highlight:=1
	else if(sc.2353(sc.2008)>0)
		sc.2351(v.bracestart:=sc.2008,v.braceend:=sc.2353(sc.2008)),v.highlight:=1
	else if v.highlight
		v.bracestart:=v.braceend:="",sc.2351(-1,-1),v.highlight:=0
}
BraceSetup(Win:=1){
	static setup:={"<":">",(Chr(34)):Chr(34),"'":"'","(":")","%":"%","{":"}","[":"]","<^>{":"}","<^>[":"]"},keep:=[]
	v.AutoAdd:=[],v.BraceMatch:=[],v.MatchBrace:=[],v.BraceDelete:=[],v.DeleteBrace:=[],list:=Settings.SSN("//autoadd/@altgr").text?{"<^>[":"]","<^>{":"}"}:{"{":"}","[":"]"}
	/*
		make this list editable at some point.
	*/
	Hotkey,IfWinActive,% hwnd([win])
	for a,b in setup
		Try{
			Hotkey,%a%,Brace,On
			Hotkey,%b%,Brace,On
			v.BraceMatch[a]:=b,v.MatchBrace[b]:=a,v.BraceDelete[SubStr(a,0)]:=b,v.DeleteBrace[b]:=SubStr(a,0)
		}
	all:=Settings.SN("//autoadd/*")
	while(aa:=all.item[A_Index-1]),ea:=XML.EA(aa){
		Try
			Hotkey,% ea.trigger,Brace,On
		v.AutoAdd[SubStr(ea.trigger,0)]:=ea.add
	}if(!(nodes:=Settings.SN("//autodelete/*")).length){
		node:=Settings.Add("autodelete")
		for a,b in setup
			Settings.Under(node,"key",{open:a,close:b})
		nodes:=Settings.SN("//autodelete/*")
	}
	return
	Brace:
	ControlGetFocus,focus,A
	/*
		t(Current(3).file,Current(3).ext,A_ThisFunc,A_ThisLabel,"time:1")
	*/
	
	if(!InStr(focus,"Scintilla")){
		Send,{%A_ThisHotkey%}
		return
	}sc:=csc(),Hotkey:=SubStr(A_ThisHotkey,0),line:=sc.2166(sc.2008),Language:=GetLanguage(sc)
	if(sc.2102)
		sc.2101
	if(sc.2008!=sc.2009)
		return BookEnd(v.BraceMatch[Hotkey],Hotkey)
	if(!v.AutoAdd[Hotkey]){
		Loop,% sc.2570{
			cpos:=sc.2585(A_Index-1)
			if(Chr(sc.2007(cpos))=Hotkey)
				GoToPos(A_Index-1,cpos+1)
			else
				sc.2686(cpos,cpos),sc.2194(1,Hotkey),GoToPos(A_Index-1,cpos+1)
		}
		
		if(A_ThisHotkey=">"&&Language="xml"){
			Sleep,100
			Match:=sc.2353(cpos)
			Line:=sc.2166(sc.2008)
			MatchLine:=sc.2166(Match)
			if(MatchLine=Line){
				if((Start:=sc.2266(Match+1,1))!=(End:=sc.2267(Match+1,1)))
					if(Word:=sc.TextRange(sc.2266(Match+1,1),sc.2267(Match+1,1)))
						sc.2003(sc.2008,"</" Word ">")
			}
		}
		
		
		
		return
	}
	if(hotkey="}"&&v.Options.Full_Auto_Indentation){
		parent:=FoldParent(),end:=sc.2224(parent,-1)
		if(Trim(sc.GetLine(line),"`t `n")="}"){
			sc.2003(sc.2008,"}")
			keep:={parent:parent,end:end}
			SetTimer,BSFix,-1
			return
			BSFix:
			FixLines(keep.parent,keep.end-(keep.parent-1),0),sc.Enable(1)
			return
	}}
	if(Hotkey=Chr(34)){
		sc.2078
		loop,% sc.2570{
			cpos:=sc.2585(A_Index-1)
			if(sc.2007(cpos)=34)
				sc.2584(A_Index-1,cpos+1),sc.2586(A_Index-1,cpos+1)
			else
				bad:=sc.2010(cpos)=13,sc.2686(cpos,cpos),sc.2194(bad?1:2,(bad?Chr(34):Chr(34) Chr(34))),sc.2584(A_Index-1,cpos+1),sc.2586(A_Index-1,cpos+1)
		}return sc.2079
	}else if(Hotkey="'"){
		sc.2078
		loop,% sc.2570{
			cpos:=sc.2585(A_Index-1)
			if(sc.2007(cpos)=39)
				sc.2584(A_Index-1,cpos+1),sc.2586(A_Index-1,cpos+1)
			else
				one:=sc.2267(cpos-1,1)=cpos,sc.2686(cpos,cpos),sc.2194(one?1:2,(one?"'":"''")),sc.2584(A_Index-1,cpos+1),sc.2586(A_Index-1,cpos+1)
		}return sc.2079
	}if(sc.2102&&v.Options.Disable_Auto_Insert_Complete!=1&&(Hotkey~="\(|\{")){
		word:=sc.GetWord()
		VarSetCapacity(text,sc.2610),sc.2610(0,&text),word:=StrGet(&text,"UTF-8") Hotkey v.BraceMatch[Hotkey]
		loop,% sc.2570
			pos:=sc.2585(A_Index-1),start:=sc.2266(pos,1),end:=sc.2267(pos,1),sc.2686(start,end),sc.2194((len:=StrPut(word,"UTF-8")-1),[word]),GoToPos(A_Index-1,start+len-1),sc.2101()
		return
	}
	if(A_ThisHotkey=">"&&Language="xml")
		m("WOOT!")
	Loop,% sc.2570{
		index:=A_Index-1,cpos:=sc.2585(index),line:=sc.2166(cpos)
		if(Chr(sc.2007(cpos))=Hotkey&&!v.Options.Disable_Auto_Advance){
			sc.2584(index,cpos+1),sc.2586(index,cpos+1)
			Continue
		}
		if(Hotkey="{"&&v.AutoAdd[Hotkey]){
			sc.2078(),ind:=sc.2127(line),tab:=Settings.Get("//tab",5)
			if(sc.2128(line)=sc.2136(line)){
				prev:=sc.GetLine(line-1)
				if(RegExMatch(prev,"iA)(}|\s)*#?\b(" Keywords.IndentRegex[Current(3).ext] ")\b"))
					if(SubStr(RegExReplace(prev,"\s+" Chr(59) ".*"),0,1)!="{")
						if(sc.2127(line)>sc.2127(line-1))
							sc.2126(line,sc.2127(line)-tab),GoToPos(index,(cpos:=sc.2128(line)))
				if(v.Options.Inline_Brace)
					sc.2686(cpos,cpos),sc.2194(4,"{`t`n}"),ind:=sc.2127(line),sc.2126(line+1,ind),sc.2584(index,sc.2136(line)),sc.2586(index,sc.2136(line)),sc.2399
				else
					sc.2686(cpos,cpos),sc.2194(4,"{`n`n}"),ind:=sc.2127(line),sc.2126(line+1,ind+tab),sc.2126(line+2,ind),sc.2584(index,sc.2128(line+1)),sc.2586(index,sc.2128(line+1)),sc.2399
			}else if(sc.2128(line)=cpos)
				end:=sc.2136(line),sc.2686(end,end),sc.2194(2,"`n}"),sc.2686(cpos,cpos),sc.2194(2,"{`n"),ind:=sc.2127(line),sc.2126(line+1,ind+tab),sc.2126(line+2,ind),sc.2584(index,sc.2128(line+1)),sc.2586(index,sc.2128(line+1)),sc.2399
			else
				sc.2686(cpos,cpos),sc.2194(2,hotkey v.AutoAdd[Hotkey]),sc.2584(index,cpos+1),sc.2586(index,cpos+1)
			sc.2079
		}else if(v.AutoAdd[Hotkey])
			sc.2686(cpos,cpos),sc.2194(2,hotkey v.AutoAdd[Hotkey]),sc.2584(index,cpos+1),sc.2586(index,cpos+1)
		else
			sc.2686(cpos,cpos),sc.2194(1,hotkey),sc.2584(index,cpos+1),sc.2586(index,cpos+1)
	}
	return SetStatus("Last Entered Character: " hotkey " Code:" Asc(hotkey),2)
	return
	if(Hotkey="}"){
		FixBrace:
		sc.2078
		sc:=csc(),line:=sc.2166(sc.2008)
		Sleep,100
		match:=sc.2166(pos:=sc.2353(sc.2008-1))
		if(line!=match&&pos>=0){
			text:=sc.GetLine(line)
			if(info:=RegExReplace(Trim(text),"(\}|\s|\R)"))
				return sc.2079()
			if(v.Options.Full_Auto_Indentation)
				NewIndent()
			else
				sc.2126(line,sc.2127(match))
		}
		return sc.2079(),sc.Enable(1)
	}
}
Center(win){
	Gui,%win%:Show,Hide
	WinGetPos,x,y,w,h,% hwnd([1])
	WinGetPos,xx,yy,ww,hh,% hwnd([win])
	centerx:=(Abs(w-ww)/2),centery:=Abs(h-hh)/2
	return "x" x+centerx " y" y+centery
}
CenterSel(){
	sc:=csc(),sc.2169
	if(v.Options.Center_Caret!=1){
		sc.2402(0x04|0x8,0),sc.2403(0x04|0x8,0)
		Sleep,1
		sc.2169(),sc.2402(0x08,0),sc.2403(0x08,0)
	}
}
Check_For_Edited(){
	static ea,sc
	all:=files.SN("//file"),sc:=csc()
	while(aa:=all.item[A_Index-1],ea:=XML.EA(aa)){
		FileGetTime,time,% ea.file
		if(time!=ea.time&&ea.note!=1){
			list.=ea.filename ",",aa.SetAttribute("time",time)
			fff:=FileOpen(ea.file,"R",(v.Options["Force_UTF-8"]?"UTF-8":"")),encoding:=fff.encoding,text:=fff.Read(fff.length),fff.Close(),dir:=Trim(dir,"\")
			/*
				FileRead,text,% ea.file
			*/
			sc.Enable(0)
			text:=RegExReplace(text,"\r\n|\r","`n")
			Encode(text,tt,encoding)
			if(ea.sc=sc.2357){
				Node:=GetPos(),sc.2181(0,&tt)
				ea:=XML.EA(Node)
				for a,b in StrSplit(fold,",")
					sc.2231(b)
				if(ea.start&&ea.end)
					sc.2160(ea.start,ea.end),sc.2399
				if(ea.scroll!="")
					SetTimer,setscrollpos2,-1
			}else if(ea.sc&&ea.sc!=sc.2357)
				sc.2377(ea.sc),aa.RemoveAttribute("sc")
			Update({file:ea.file,text:text}),SetPos()
			sc.Enable(1)
		}
	}if(list)
		SetStatus("Files Updated:" Trim(list,","),3)
	return 1
	setscrollpos2:
	if(ea.scroll!="")
		sc.2613(ea.scroll),sc.2400()
	MarginWidth()
	return
}
Check_For_Update(startup:=""){
	static newwin
	;static DownloadURL:="https://raw.githubusercontent.com/maestrith/AHK-Studio/master/AHK-Studio.ahk",VersionTextURL:="https://raw.githubusercontent.com/maestrith/AHK-Studio/master/AHK-Studio.text"
	static DownloadURL:="https://raw.githubusercontent.com/maestrith/AHK-Studio/Beta/AHK-Studio.ahk"
		 ,VersionTextURL:="https://raw.githubusercontent.com/maestrith/AHK-Studio/Beta/AHK-Studio.text"
		 ,url:="https://api.github.com/repos/maestrith/AHK-Studio/commits/Beta"
	Run,RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 8
	auto:=Settings.EA("//autoupdate"),sub:=A_NowUTC
	if(startup=1){
		if(v.Options.Auto_Check_For_Update_On_Startup!=1)
			return
		if(auto.reset>A_Now)
			return
	} ;I can edit it and it will remember
	sub-=A_Now,hh
	FileGetTime,time,%A_ScriptFullPath%
	time+=sub,hh
	ea:=Settings.EA("//github"),token:=ea.token?"?access_token=" ea.token:"",http:=ComObjCreate("WinHttp.WinHttpRequest.5.1"),http.Open("GET",url token)
	if(proxy:=Settings.SSN("//proxy").text)
		http.setProxy(2,proxy)
	http.Send(),RegExMatch(http.ResponseText,"iUO)\x22date\x22:\x22(.*)\x22",found),date:=RegExReplace(found.1,"\D")
	if(startup="1"){
		if(reset:=http.GetResponseHeader("X-RateLimit-Reset")){
			seventy:=19700101000000
			for a,b in {s:reset,h:-sub}
				EnvAdd,seventy,%b%,%a%
			Settings.Add("autoupdate",{reset:seventy})
			if(time>date)
				return
		}else
			return
	}
	Version:="1.005.09"
	newwin:=new GUIKeep("CFU"),newwin.Add("Edit,w400 h400 ReadOnly,No New Updates,wh","Button,gautoupdate,&Update,y","Button,x+5 gcurrentinfo,&Current Changelog,y","Button,x+5 gextrainfo,Changelog &History,y"),newwin.show("AHK Studio Version: " version)
	if(time<date){
		file:=FileOpen("changelog.txt","rw"),file.seek(0),file.Write(update:=RegExReplace(URLDownloadToVar(VersionTextURL),"\R","`r`n")),file.length(file.position),file.Close()
		ControlSetText,Edit1,%update%,% newwin.ahkid
	}if(!found.1)
		ControlSetText,Edit1,% http.ResponseText,% newwin.ahkid
	return
	autoupdate:
	Save(),Settings.Save(1),menus.Save(1),studio:=URLDownloadToVar(DownloadURL)
	if(!InStr(studio,";download complete"))
		return m("There was an error. Please contact maestrith@gmail.com if this error continues")
	SplitPath,A_ScriptFullPath,,,ext,nne
	if(!FileExist("Older Versions"))
		FileCreateDir,Older Versions
	FileMove,%nne%.ahk,%A_ScriptDir%\Older Versions\%nne% - %version%.ahk,1
	File:=FileOpen(nne ".ahk","rw"),File.Seek(0),File.Write(studio),File.Length(File.Position)
	Loop,%A_ScriptDir%\*.ico
		icon:=A_LoopFileFullPath
	if(icon)
		add=/icon "%icon%"
	if(ext="exe"){
		SplashTextOn,200,50,Compiling,Please Wait...
		FileMove,%A_ScriptFullPath%,%nne% - %version%.exe,1
		SplitPath,A_AhkPath,file,dirr
		Loop,%dirr%\Ahk2Exe.exe,1,1
			file:=A_LoopFileLongPath
		RunWait,%file% /in "%A_ScriptDir%\%nne%.ahk" /out "%A_ScriptDir%\%nne%.exe" %add% /bin "%dirr%\Compiler\Unicode 32-bit.bin"
	}
	Reload
	ExitApp
	return
	currentinfo:
	file:=FileOpen("changelog.txt","rw")
	if(!file.length)
		file:=FileOpen("changelog.txt","rw"),file.seek(0),file.write(RegExReplace(URLDownloadToVar(VersionTextURL),"\R","`r`n")),file.length(file.position)
	file.seek(0),text:=file.Read(file.length),file.Close()
	ControlSetText,Edit1,%text%
	return
	extrainfo:
	Run,https://github.com/maestrith/AHK-Studio/wiki/Version-Update-History
	return
	cfuguiclose:
	cfuguiescape:
	newwin.Destroy()
	return
}
CheckLayout(){
	static LastLayout
	Layout:=DllCall("GetKeyboardLayout",int,0)
	if(Layout!=LastLayout&&LastLayout!=""){
		LastLayout:=Layout
		return 1
	}LastLayout:=Layout
	return 0
}
class Code_Explorer{
	static explore:=[]
	Add(type,found,node:=""){
		return
		if(type="Class")
			cexml.Under(Current(5),"info",{type:type,text:found.2,upper:Upper(found.2),cetv:TVC.Add(2,found.2,Header(type),"Sort")})
		else{
			new:=cexml.Under((node?node:Current(5)),"info",{type:type,text:found.1,upper:Upper(found.1),cetv:TVC.Add(2,found.1,Header(type),"Sort")})
			Default("SysTreeView322"),TV_GetText(text,Header(type))
			if(type~="Function|Method")
				new.SetAttribute("args",found.3)
			if(type="Instance")
				new.SetAttribute("class",found.2)
			if(type="Breakpoint")
				new.SetAttribute("filename",Current(6).file)
		}
	}AutoCList(node:=0){
		static list:=[]
		if(node=1){
			all:=cexml.SN("//main")
			while(aa:=all.item[A_Index-1]),mea:=XML.EA(aa){
				obj:=list[mea.file]:=[],CF:=SN(aa,"descendant::*[@type='Class' or @type='Function' or @type='Instance']")
				while(cc:=CF.item[A_Index-1]),ea:=XML.EA(cc){
					if(mea.file="libraries")
						v.keywords[SubStr(ea.text,1,1)].=" " ea.text
					obj.list.=ea.text " "
				}obj.list:=Trim(obj.list)
			}return
		}if(node){
			parent:=SSN(node,"ancestor-or-self::main/@file").text
			if(!obj:=IsObject(list[parent]))
				obj:=list[parent]:=[]
			obj.list:=[],all:=SN(node.ParentNode,"descendant::*[@type='Class' or @type='Function']")
			while(aa:=all.item[A_Index-1]),ea:=XML.EA(aa)
				obj.list.=ea.text " "
			obj.list:=Trim(obj.list)
			return
		}else{
			return list[Current(2).file].list
	}}CEGO(){
		static last
		CEGO:
		if((Node:=cexml.SSN("//*[@cetv='" A_EventInfo "']"))&&(A_GuiEvent="S"||A_GuiEvent="Normal")){
			
			return m(Node.xml)
			SelectText(Node,1),CenterSel()
		}
		return
	}InComment(found,start:=0){
		return v.CommentArea.SSN("//*[@min<" found.pos(0)+start " and @max>" found.pos(0)+start "]")?1:0
	}Populate(){
		Code_Explorer.Refresh_Code_Explorer()
	}Refresh_Code_Explorer(){
		if(v.opening)
			return
		if(!MainWin.Gui.SSN("//*[@type='Code Explorer']"))
			return
		SplashTextOff
		TVC.Disable(2),TVC.Delete(2,0),fz:=cexml.SN("//main"),rem:=cexml.SN("//*[@cetv]")
		while(rr:=rem.item[A_Index-1])
			rr.RemoveAttribute("cetv")
		rem:=cexml.SN("//header")
		while(rr:=rem.item[A_Index-1])
			rr.ParentNode.RemoveChild(rr)
		while(fn:=fz.Item[A_Index-1]){
			Exempt:=Keywords.CodeExplorerExempt[Settings.SSN("//Extensions/Extension[text()='" Format("{:L}",SSN(fn,"file/@ext").text) "']/@language").text]
			things:=SN(fn,"descendant::info"),filename:=SSN(fn,"@file").text
			SplitPath,filename,file
			TVC.Default(2),fn.SetAttribute("cetv",(main:=TVC.Add(2,file,0,"Sort")))
			while,tt:=things.Item[A_Index-1],ea:=XML.EA(tt){
				if(!top:=SSN(fn,"descendant::header[@type='" ea.type "']"))
					if(ea.type~="(" Exempt ")"=0)
						top:=cexml.Under(fn,"header",{type:ea.type,cetv:TVC.Add(2,ea.type,SSN(fn,"@cetv").text,"Sort" (SSN(tt,"ancestor::main[@file='Libraries']")?"":" Vis"))})
				if(ea.type~="(" Exempt ")")
					tt.SetAttribute("cetv",TVC.Add(2,ea.text,((tv:=SSN(tt.ParentNode,"@cetv").text)?tv:SSN(top,"@cetv").text),"Sort"))
				else
					last:=tt,tt.SetAttribute("cetv",TVC.Add(2,ea.text,((tv:=SSN(tt.ParentNode,"@cetv").text)?tv:SSN(top,"@cetv").text),(ea.type="Class"?"Sort":"Sort")))
		}}TVC.Enable(2)
		return
	}Remove(filename){
		this.explore.remove(SSN(filename,"@file").text),list:=SN(filename,"@file")
		while,ll:=list.item[A_Index-1]
			this.explore.Remove(ll.text)
	}RemoveItem(current,type,text){
		rem:=SSN(current,"descendant::*[@type='" type "' and @text='" text "']")
		if(tv:=SSN(rem,"@cetv").text)
			TVC.Delete(2,tv)
		rem.ParentNode.RemoveChild(rem)
	}RemoveTV(nodes){
		type:=SSN(nodes.item[0],"@type").text
		while(nn:=nodes.item[A_Index-1]),ea:=XML.EA(nn){
			if(ea.cetv)
				TVC.Delete(2,ea.cetv)
			nn.ParentNode.RemoveChild(nn)
		}if(!SSN((Parent:=Current(7)),"descendant::info[@type='" type "']")){
			node:=SSN(Parent,"descendant::header[@type='" type "']")
			if(tv:=SSN(node,"@cetv").text)
				TVC.Delete(2,tv)
			node.ParentNode.RemoveChild(node)
		}
	}
	/*
		Scan(node){
			static First:=0
			return ScanFile.Scan(Node)
			ea:=XML.EA(node),Omni:=GetOmni(ea.Ext)
			if(!First){
				current:=cexml.SSN("//file[@id='" ea.id "']"),text:=Update({get:ea.file}),node:=current
				all:=cexml.SN("//main")
				while(aa:=all.item[A_Index-1],ea:=XML.EA(aa)){
					List.=ea.File "`n"
				}
				m(Current.xml,"","",List)
				First:=1
			}
			return
			if(SSN(node,"//*").NodeName="files"){
				if(!ea.ID)
					return
				current:=cexml.SSN("//file[@id='" ea.id "']"),text:=Update({get:ea.file}),node:=current
			}
			this.ScanComments(text),this.ScanClass(text,node),this.ScanFM(text,node),no:=v.CommentArea
			for type,find in {Hotkey:Omni.Hotkey,Label:Omni.Label}{
				pos:=1
				while,RegExMatch(text,find,fun,pos),pos:=fun.pos(1)+fun.len(1){
					if(!fun.len(1))
						Break
					if(!no.SSN("//bad[@min<'" fun.pos(1) "' and @max>'" fun.pos(1) "' and @type!='Class']"))
						cexml.under(node,"info",{type:type,pos:StrPut(SubStr(text,1,fun.Pos(1)),"utf-8")-3,text:fun.1,upper:Upper(fun.1)})
			}}pos:=1
			while,RegExMatch(text,Omni.Instance,found,pos),pos:=found.Pos(2)+found.len(2){
				if(!found.len(1))
					break
				if(!no.SSN("//bad[@min<'" found.pos(1) "' and @max>'" found.pos(1) "' and @type!='Class']"))
					cexml.Under(node,"info",{type:"Instance",upper:Upper(found.1),pos:StrPut(SubStr(text,1,found.Pos(1)),"utf-8")-3,text:found.1,class:found.2})
			}pos:=1
			while,RegExMatch(text,"OUi);gui\[(.*)\].*\R(.*)\R;/gui\[.*\]",found,pos),pos:=found.Pos(1)+found.len(1)
				cexml.Under(node,"info",{type:"Gui",opos:found.Pos(1)-1,pos:ppp:=StrPut(SubStr(text,1,found.Pos(1)),"utf-8")-3,start:found.Pos(2)-1,end:found.Pos(2)+found.len(2),text:found.1,upper:Upper(found.1)})
			for a,b in {Bookmark:"\s+;#\[(.*)\]",Breakpoint:"\s+;\*\[(.*)\]"}{
				pos:=1
				while,pos:=RegExMatch(text,"OU)" b,found,pos),pos:=found.Pos(1)+found.len(1){
					nnn:=cexml.Under(node,"info",{type:a,upper:Upper(found.1),pos:StrPut(enter:=SubStr(text,1,found.Pos(0)),"utf-8"),text:found.1})
					if(a="Breakpoint"){
						RegExReplace(enter,"\R",,Count)
						nnn.SetAttribute("line",Count),nnn.SetAttribute("filename",ea.file)
		}}}}
		ScanClass(FileText,parent){
			Omni:=GetOmni(SSN(Parent,"@ext").text)
			if(!v.startup)
				this.ScanComments(FileText)
			classes:=GetAllTopClasses(FileText,,,Omni),SubClass:=[],move:=[]
			for a,b in classes{
				pos:=1,start:=InStr(FileText,b.text)-1
				while(RegExMatch(b.text,Omni.Class,found,pos)),pos:=found.pos(1)+found.len(1){
					InComment:=this.InComment(found,start)
					if(InComment)
						Continue
					if(!found.len(1))
						break
					if(A_Index=1)
						main:=cexml.Under(parent,"info",{start:start+found.pos(1)-1,end:start+found.pos(1)+StrLen(b.text)-1,type:"Class",text:found.2,upper:Upper(found.2)})
					else
						ScanText:=SubStr(b.text,found.pos(1)),CText:=GetClassText(ScanText,found.2,,Omni),new:=cexml.Under(main,"info",{start:start+found.pos(1)-1,end:start+found.pos(1)+StrLen(CText)-1,type:"Class",text:found.2,upper:Upper(found.2)})
				}
			}
			all:=SN(parent,"descendant::*")
			while(aa:=all.item[A_Index-1]),ea:=XML.EA(aa){
				inside:=SN(parent,"descendant::*[@start<" ea.start " and @end>" ea.end "]"),last:=[]
				while(ii:=inside.item[A_Index-1]),ea:=XML.EA(ii)
					last[ea.start]:=ii
				if(last.MaxIndex())
					move.push([last[last.MaxIndex()],aa])
			}for a,b in move
				b[1]["AppendChild"](b.2)
		}
		ScanComments(FileText){
			static no:=new xml("no")
			v.CommentArea:=no,no:=v.CommentArea,classes:=[],rem:=no.SSN("//bad"),rem.ParentNode.RemoveChild(rem),notop:=no.Add("bad"),pos:=1
			while(RegExMatch("`n" FileText,"OU)(\n\s*\x2F\x2A.*\s*\x2A\x2F)",found,pos),pos:=found.pos(1)+found.len(1)){
				if(!found.len(1))
					Break
				if(!found.len(1)&&!found.len(2))
					Break
				if(found.pos(1)){
					pos:=found.pos(1)+found.len(1),no.under(notop,"bad",{min:found.pos(1)-3,max:found.pos(1)+found.len(1)-3,type:"comment"})
				}
			}pos:=1
			while(RegExMatch(FileText,"OU)\R(\s*;.*)(\R|$)",found,pos),pos:=found.pos(1)+found.len(1)){
				if(!found.len(1))
					Break
				no.under(notop,"bad",{min:found.pos(1)-3,max:found.pos(1)+found.len(1)-3,type:"comment",semi:1})
			}
		}
		ScanFM(FileText,parent){
			Omni:=GetOmni(SSN(parent,"@ext").text)
			if(SSN(parent,"@type").text="class"){
				top:=Current(5),start:=SSN(parent,"@start").text
				for a,b in {Method:Omni.Function,Property:Omni.Property}{
					pos:=1
					while(RegExMatch(FileText,b,found,pos)),pos:=found.pos(1)+found.len(1){
						if(!found.len(1))
							Break
						if(found.1~="i)if|while|RegExMatch|RegExReplace")
							Continue
						if(this.InComment(found))
							Continue
						max:=[],all:=SN(top,"descendant::*[@type='Class' and @start<" start+found.pos(1) " and @end>" start+found.pos(1) "]")
						while(aa:=all.item[A_Index-1]),ea:=XML.EA(aa)
							max[ea.start]:=aa
						node:=max[max.MaxIndex()]
						TVC.Default(2),cexml.Under(node,"info",{class:SSN(node,"@text").text,text:found.1,upper:Upper(found.1),type:a,cetv:TVC.Add(2,found.1,SSN(node,"@cetv").text,"Sort")})
			}}}else{
				for a,b in {Function:Omni.Function,Property:Omni.Property}{
					pos:=1
					while(RegExMatch(FileText,b,found,pos)),pos:=found.pos(1)+found.len(1){
						last:=[]
						if(!found.len(1))
							break
						if(found.1~="i)\b(" Keywords.IndentRegex[Current(3).ext] ")\b")
							Continue
						if(this.InComment(found))
							Continue
						list:=SN(parent,"descendant::*[@start<" found.pos(1) " and @end>" found.pos(1) "]")
						while(ll:=list.item[A_Index-1]),ea:=XML.EA(ll){
							last[ea.start]:=ll
						}if((under:=last[last.MaxIndex()]).xml){
							cexml.Under(under,"info",{args:found.3,id:SSN(parent,"ancestor-or-self::file/@id").text,class:SSN(under,"@text").text,type:(a="Function"?"Method":a),text:found.1,upper:Upper(found.1)})
						}else
							cexml.Under(parent,"info",{type:a,text:found.1,id:SSN(parent,"ancestor-or-self::file/@id").text,args:found.3,upper:Upper(found.1)})
		}}}}
	*/
}
class debug{
	static socket
	__New(){
		if(this.socket){
			debug.Send("stop")
			Sleep,500
			this.Disconnect()
		}debug.xml:=new XML("debug"),sock:=-1
		if(!v.debug.sc)
			MainWin.DebugWindow()
		DllCall("LoadLibrary","str","ws2_32","ptr"),VarSetCapacity(wsadata,394+A_PtrSize),DllCall("ws2_32\WSAStartup","ushort",0,"ptr",&wsadata),DllCall("ws2_32\WSAStartup","ushort",NumGet(wsadata,2,"ushort"),"ptr",&wsadata),OnMessage(0x9987,debug.sock),socket:=sock,next:=debug.AddrInfo(),sockaddrlen:=NumGet(next+0,16,"uint"),sockaddr:=NumGet(next+0,16+(2*A_PtrSize),"ptr"),socket:=DllCall("ws2_32\socket","int",NumGet(next+0,4,"int"),"int",1,"int",6,"ptr")
		if(DllCall("ws2_32\bind","ptr",socket,"ptr",sockaddr,"uint",sockaddrlen,"int")!=0)
			return m(DllCall("ws2_32\WSAGetLastError"))
		DllCall("ws2_32\freeaddrinfo","ptr",next),DllCall("ws2_32\WSAAsyncSelect","ptr",socket,"ptr",A_ScriptHwnd,"uint",0x9987,"uint",0x29),ss:=DllCall("ws2_32\listen","ptr",socket,"int",32),debug.socket:=socket,debug.filename:=Current(2).file,debug.id:=Current(2).id,debug.Hotkeys(1),debug.Breakpoints:=[]
	}
	Hotkeys(State){
		state:=state?"On":"Off"
		if(v.Options.Global_Debug_Hotkeys){
			Hotkey,IfWinActive
			for a,b in ["Stop_Debugger","Run_Program","Step_Into","Step_Out","Step_Over","List_Variables"]{
				if(key:=menus.SSN("//*[@clean='" b "']/@hotkey").text)
					Hotkey,%key%,HotkeyLabel,%state%
	}}}
	TopXML(){
		return debug.XML.SSN("//main")
	}
	AddrInfo(){
		VarSetCapacity(hints,8*A_PtrSize,0),DllCall("ws2_32\getaddrinfo",astr,"127.0.0.1",astr,"9000","uptr",hints,"ptr*",results)
		return results
	}
	Run(filename){
		static pid
		debug.filename:=filename
		SetTimer,runn,-1
		return
		runn:
		filename:=debug.filename
		SplitPath,filename,,dir
		if(FileExist(A_ScriptDir "\AutoHotkey.exe"))
			Run,%A_ScriptDir%\AutoHotkey.exe /debug "%filename%",%dir%,,pid
		else
			Run,"%A_AhkPath%" /debug "%filename%",%dir%,,pid
		sc:=v.debug
		while(!WinExist("ahk_pid" pid)){
			Sleep,100
			if(A_Index=5){
				return m("Debugger failed, Please close all instances of " SplitPath(debug.filename).filename " and try again")
		}}sc.2004(),sc.2003(0,"Initializing Debugger, Please Wait...`n"),csc().2264(500)
		if(v.Options.Auto_Variable_Browser)
			VarBrowser()
		SetTimer,cee,-600
		return
		cee:
		if(WinExist("ahk_pid" pid)){
			ControlGetText,text,Static1,% "ahk_pid" pid
			sc:=csc(),info:=StripError(text,debug.filename) ;IMPORTANT
			if(info.line&&info.file)
				SetPos({file:info.file,line:info.line}),v.debug.2003(v.debug.2006,"`n" text)
		}return
	}
	Decode(string){ ;original http://www.autohotkey.com/forum/viewtopic.php?p=238120#238120
		if(string="")
			return
		DllCall("Crypt32.dll\CryptStringToBinary","ptr",&string,"uint",StrLen(string),"uint",1,"ptr",0,"uint*",cp:=0,"ptr",0,"ptr",0),VarSetCapacity(bin,cp),DllCall("Crypt32.dll\CryptStringToBinary","ptr",&string,"uint",StrLen(string),"uint",1,"ptr",&bin,"uint*",cp,"ptr",0,"ptr",0)
		return StrGet(&bin,cp,"UTF-8")
	}
	Encode(text){
		IfEqual,text,,return
			cp:=0,VarSetCapacity(rawdata,StrPut(text,"UTF-8")),sz:=StrPut(text,&rawdata,"UTF-8")-1,DllCall("Crypt32.dll\CryptBinaryToString","ptr",&rawdata,"uint",sz,"uint",0x40000001,"ptr",0,"uint*",cp),VarSetCapacity(str,cp*(A_IsUnicode?2:1)),DllCall("Crypt32.dll\CryptBinaryToString","ptr",&rawdata,"uint",sz,"uint",0x40000001,"str",str,"uint*",cp)
		return str
	}
	/*
		Off(){
			global x
			for a,b in [10002,10003,10004]
				toolbar.list.10002.setstate(b,16)
			for a,b in [10000,10001]
				toolbar.list.10002.setstate(b,4)
		}
	*/
	/*
		On(){
			for a,b in [10002,10003,10004]
				toolbar.list.10002.setstate(b,4)
			for a,b in [10000,10001]
				toolbar.list.10002.setstate(b,16)
		}
	*/
	Register(){
		DllCall("ws2_32\WSAAsyncSelect","ptr",debug.socket,"ptr",A_ScriptHwnd,"uint",0x9987,"uint",0x29)
	}
	Disconnect(){
		debug.Send("stop")
		Sleep,200
		DllCall("ws2_32\WSAAsyncSelect","uint",debug.socket,"ptr",A_ScriptHwnd,"uint",0,"uint",0),DllCall("ws2_32\closesocket","uint",debug.socket,"int"),DllCall("ws2_32\WSACleanup"),debug.socket:="",debug.Off(),csc().2264(10000000)
		v.DebugHighlight:=[],DebugHighlight(),debug.Hotkeys(0),debug.Caret(0)
	}
	Accept(){
		if((sock:=DllCall("ws2_32\accept","ptr",debug.socket,"ptr",0,"int",0,"ptr"))!=-1)
			debug.socket:=sock,debug.Register()
		Else
			debug.Disconnect()
	}
	Send(message){
		mm:=message,message.=Chr(0),len:=StrPut(message,"UTF-8"),VarSetCapacity(buffer,len),ll:=StrPut(message,&buffer,"UTF-8")
		if(!debug.socket){
			t("Debugger not functioning: " debug.socket,"time:1")
			if(message="stop")
				return
			else
				exit
		}
		debug.wait:=1,sent:=DllCall("ws2_32\send","ptr",debug.socket,uptr,&buffer,"int",ll,"int",0,"cdecl")
		if(sent&&mm!="stop"){
			sendwait:
			Sleep,20
			if(debug.socket<=0)
				return t("Debugging has stopped")
			While(debug.wait){
				Sleep,10
				if(debug.socket<1)
					return
				if(A_Index>20){
					debug.wait:=0,v.ready:=1,debug.Receive(),InsertDebugMessage()
					Break
		}}}return
	}Receive(){
		static last
		;Thank you Lexikos and fincs http://ahkscript.org/download/tools/DBGP.ahk
		socket:=debug.socket
		while(DllCall("ws2_32\recv","ptr",socket,"char*",c,"int",1,"int",0)){
			if(c=0)
				break
			length.=Chr(c)
		}if(length<=0)
			return debug.wait:=0
		VarSetCapacity(packet,++length,0),recd:=0
		While(r<length){
			index:=A_Index,rr:=r,r:=DllCall("ws2_32\recv","ptr",socket,"ptr",&packet,"int",length,"int",0x2)
			if(!debug.socket)
				m("Socket Disconnected, Debugging has stopped")
			if(r<1)
				error:=DllCall("GetLastError"),t(r,socket,length,received,"An error occured",error,"Possible reasons for the error:","1.  Sending OutputDebug faster than 1ms per message","2.  Max_Depth or Max_Children value too large","time:2")
			if(r<length)
				Sleep,5
			if(A_Index>10){
				crap:=1
				break
		}}DllCall("ws2_32\recv","ptr",socket,"ptr",&packet,"int",length,"int",0),debug.wait:=0
		if(!IsObject(v.displaymsg))
			v.displaymsg:=[]
		if(info:=StrGet(&packet,length-1,"UTF-8")){
			v.displaymsg.Push(info)
			SetTimer,Display,-10
		}if(crap){
			last.=r "!=" length "`n"
			SetTimer,crap,-100
		}else
			t()
		return
		crap:
		debug.Receive()
		return
	}Focus(){
		if(!v.Options.Focus_Studio_On_Debug_Breakpoint)
			WinActivate,% hwnd([1])
	}
	Sock(info*){
		if(info.2=0x9987){
			if(info.1=1)
				debug.Receive()
			if(info.1&0xffff=8)
				debug.Accept()
			if(info.1&0xFFFF=32)
				debug.Disconnect()
		}
	}Caret(state){
		color:=state=1?Settings.Get("//theme/caret/@debug",0x0000ff):Settings.Get("//theme/caret/@color",0xFFFFFF)
		width:=state=1?3:Settings.Get("//theme/caret/@width",1)
		for a,b in s.ctrl
			b.2069(color),b.2188(width)
	}
}
Debug_Current_Script(){
	/*
		Scan_Line()
	*/
	if(debug.socket){
		sc:=v.debug,sc.2003(sc.2006,"`nKilling Current Process"),debug.Send("stop")
		Sleep,200
		if(debug.Socket){
			debug.Send("stop")
			Sleep,200
	}}new Debug()
	if(debug.VarBrowser)
		Default("SysTreeView321",98),TV_Delete()
	if(Current(2).file=A_ScriptFullPath)
		return m("Can not debug AHK Studio using AHK Studio.")
	/*
		break:=SN(Current(7),"descendant::*[@type='Breakpoint']")
		get the files that have breakpoints
		remove the breakpoints and re-scan the file/s for them
		then debug with the proper line numbers.
	*/
	Save()
	debug.Run(Current(2).file)
}
class EasyView{
	Register(Control,HWND,Label,win:=1,ID:=""){
		WinGetClass,class,ahk_id%HWND%
		obj:=this.Controls[Control]:=[],obj.Label:=Label,obj.HWND:=HWND,obj.type:=InStr(class,"TreeView")?"TreeView":"ListView",this.win:=win,this.HWND[HWND]:=ID
	}Default(Control){
		if(A_DefaultGUI!=this.win)
			Gui,% this.win ":Default"
		Gui,% this.win ":" this.Controls[Control].type,% this.Controls[Control].HWND
	}Delete(Control,Item:=0){
		this.Default(Control),(this.Controls[Control].type="TreeView")?TV_Delete(item):LV_Delete(item)
	}Add(Control,text,parentopt:=0,options:=""){
		this.Default(Control),this.Controls[Control].type="TreeView"?(value:=TV_Add(text,parentopt,options)):(IsObject(text)?(value:=LV_Add(parentopt,text*)):value:=LV_Add(parentopt,text))
		return value
	}Modify(Control,text:="",Item:="",Options:=""){
		this.Default(Control),this.Controls[Control].type="TreeView"?(text?TV_Modify(Item,Options,text):TV_Modify(Item,Options)):(LV_Modify(Item,Options,(IsObject(text)?text*:text)))
	}Disable(Control){
		this.Default(Control)
		GuiControl,% this.win ":-Redraw",% this.Controls[Control].HWND
		GuiControl,% this.win ":+g",% this.Controls[Control].HWND
	}Enable(Control){
		this.Default(Control)
		GuiControl,% this.win ":+Redraw",% this.Controls[Control].HWND
		GuiControl,% this.win ":+g" this.Controls[Control].Label,% this.Controls[Control].HWND
	}Selection(Control){
		dg:=A_DefaultGui,this.Default(Control),tv:=TV_GetSelection()
		Gui,%dg%:Default
		return tv
	}
}
Class Icon_Browser{
	static start:="",keep:=[]
	__New(obj,hwnd,win,pos:="xy",min:=300,Function:="",Reload:=""){
		this.hwnd:=hwnd,this.win:=win,this.min:=min
		if(min)
			obj.Add("Button,xs gloadfile,Load File," pos,"Button,x+M gloaddefault,Default Icons," pos,"Button,x+M gIBWidth,Width," pos)
		Icon_Browser.keep[win]:=this,this.Reload:=Reload=1?Function:Reload,this.Function:=Function,this.file:=Settings.Get("//icons/@last","Shell32.dll"),this.start:=0,this.populate()
	}Methods(){
		IBWidth:
		this:=Icon_Browser.keep[A_Gui],min:=Settings.Get("//IconBrowser/Win[@win='" this.win "']/@w",this.min)
		InputBox,out,Icon Viewer Width,% "Only Numbers with a minimum of " this.min,,,,,,,,%min%
		if(ErrorLevel)
			return
		if(out~="\D"||out<this.min)
			return m("Invalid value. Must be a NUMBER at least " min)
		if(!node:=Settings.SSN("//IconBrowser/Win[@win='" this.win "']"))
			node:=Settings.Add("IconBrowser/Win",{win:this.win},,1)
		node.SetAttribute("w",out)
		if(func:=this.reload)
			%func%()
		return
		SelectIcon:
		this:=Icon_Browser.keep[A_Gui]
		if(A_GuiEvent="I"&&ErrorLevel~="S")
			function:=this.function,%function%({file:this.file,icon:A_EventInfo})
		return
		LoadFile:
		FileSelectFile,file,,,,*.exe;*.dll;*.png;*.jpg;*.gif;*.bmp;*.icl;*.ico
		if(ErrorLevel)
			return
		this:=icon_browser.keep[A_Gui],this.file:=file,this.start:=0,this.populate(),Settings.Add("icons",{"last":this.file})
		return
		LoadDefault:
		this:=icon_browser.keep[A_Gui],this.file:="Shell32.dll",this.start:=0,this.populate(),Settings.Add("icons",{"last":this.file})
		return
	}Populate(){
		Gui,% this.win ":Default"
		Gui,% this.win ":ListView",% this.hwnd
		GuiControl,% this.win ":-Redraw",% this.hwnd
		il:=IL_Create(50,10,1),LV_SetImageList(il),LV_Delete()
		if(this.file~="(.gif|.jpg|.png|.bmp|.exe)$")
			icon:=IL_Add(il,this.file),LV_Add("Icon" icon)
		else if(this.file~=".exe"=0){
			count:=0
			while(LoadPicture(this.file,"icon" A_Index))
				count++
			Loop,%count%
				icon:=IL_Add(il,this.file,A_Index),LV_Add("Icon" icon)
		}SendMessage,0x1000+53,0,(47<<16)|(47&0xffff),,% "ahk_id" this.hwnd
		GuiControl,% this.win ":+Redraw",% this.hwnd
	}
}
Class LineStatus{
	static xml:=new XML("LineStatus"),stored:=[],state:={1:21,2:20}
	Add(line,state){
		sc:=csc()
		if(mask:=sc.2046(line)){
			sc.2044(line,21),sc.2044(line,20)
		}
		if(sc.2046(line)&2**this.state[state]=0)
			sc.2043(line,this.state[state])
		if(!node:=this.XML.SSN("//*[@id='" (id:=Current(8)) "']"))
			node:=this.XML.Add("state",{id:id},,1)
		node.SetAttribute("state",state)
	}Delete(start,end){
		add:=start+1=end?0:1,sc:=csc()
		Loop,% end+add-start
			sc.2044(end+2-A_Index,-1)
	}Clear(){
		sc:=csc(),node:=this.XML.SSN("//*[@id='" Current(8) "']").SetAttribute("state",0),next:=0
		while((next:=sc.2047(next,2**20+2**21))>=0)
			this.RemoveStatus(next)
		node.ParentNode.RemoveChild(node)
	}Save(id){
		this.XML.SSN("//*[@id='" id "']").SetAttribute("state",1)
	}tv(){
		sc:=csc(),state:=SSN(node:=this.XML.SSN("//*[@id='" Current(8) "']"),"@state").text
		if(state=1){
			next:=0
			while((next:=sc.2047(next,2**20+2**21))>=0)
				this.RemoveStatus(next),sc.2043(next,this.state[state]),next++
		}node.SetAttribute("state",1)
	}UpdateRange(){
		sc:=csc()
		for a,b in this.stored
			this.Add(a,b)
		this.stored:=[]
	}RemoveStatus(line){
		sc:=csc(),mask:=sc.2046(line)
		if(mask&2**20)
			sc.2044(line,20)
		if(mask&2**21)
			sc.2044(line,21)		
	}StoreEdited(start,end,add){
		sc:=csc()
		Loop,% (end+1)-start{
			if(mask:=sc.2046(start+(A_Index-1)))
				this.RemoveStatus(start+(A_Index-1)),this.stored[start+(A_Index-1)+add]:=(mask&2**20?2:1)
		}
	}DelayAdd(Line,Count){
		static info:=[]
		info:={Line:Line,Count:Count}
		SetTimer,LSDA,-100
		return
		LSDA:
		Loop,% info.Count
			LineStatus.Add(info.Line+(A_Index-1),2)
		return
	}
}
Class MainWindowClass{
	static keep:=[]
	__New(){
		if(FileExist(A_ScriptDir "\AHKStudio.ico"))
			Menu,Tray,Icon,AHKStudio.ico
		if(v.Options.Hide_Tray_Icon)
			Menu,Tray,NoIcon
		Gui,+Resize +LabelMainWindowClass. +hwndmain +MinSize400x200 -DPIScale
		Gui,Add,TreeView,x0 y0 w0 h0 hwndpe +0x400000
		Gui,Add,TreeView,x0 y0 w0 h0 hwndce +0x400000 AltSubmit
		Gui,Add,TreeView,hwndtn x0 y0 w0 h0 +0x400000
		Gui,Color,% RGB(ea.Background),% RGB(ea.Background)
		hwnd(1,main),this.QuickFind(),this.hwnd:=main,TVC.Register(1,pe,"tv",,"projectexplorer"),TVC.Register(2,ce,"CEGO",,"codeexplorer"),TVC.Register(3,tn,"tn",,"trackednotestv"),TV_Add("Tracked Notes Here"),TNotes:=new Tracked_Notes(),this.tnsc:=new s(1,{pos:"x0 y0 w0 h0"}),this.tn:=tn+0,this.win:=1,this.ID:="ahk_id" main,TVC.Add(2,"Right Click to Refresh")
		Gui,Color,0,0
		Gui,Menu,% Menu("main")
		this.pe:=pe+0,this.peid:="ahk_id" pe,this.ce:=ce+0,this.ceid:="ahk_id" ce
		Gui,Add,StatusBar,hwndsb,Testing
		Gui,Color,0xAAAAAA,0xAAAAAA
		ControlGetPos,,,,h,,ahk_id%sb%
		this.Gui:=new XML("gui","lib\Gui.xml"),this.main:=main,this.ID:="ahk_id" main,this.sb:=h
		OnMessage(0xA0,MainWindowClass.ChangePointer),OnMessage(0xA1,MainWindowClass.Resize),OnMessage(0x232,MainWindowClass.ExitSizeMove),OnMessage(0x0211,MainWindowClass.EnterOff),OnMessage(0x0212,MainWindowClass.EnterOn)
		OnMessage(6,"Activate")
		for a,b in {all:32646,ns:32645,ew:32644}
			this["curs" a]:=DllCall("LoadCursor",int,0,int,b,uptr)
		Gui,Margin,0,0
		for a,b in {Border:32,Caption:4,Menu:15}
			this[a]:=DllCall("GetSystemMetrics",int,b)
		if(!this.Gui.SSN("//win[@win=1]/descendant::control"))
			this.GUI.XML.LoadXML("<gui><win win=""1"" pos=""x578 y116 w1246 h839""><control h=""653"" w=""1001"" x=""0"" y=""0"" type=""Scintilla"" file=""Untitled.ahk"" hwnd=""2"" ra=""3"" last=""1""/><control h=""358"" w=""245"" x=""1001"" y=""0"" lp=""0.80337079"" type=""Project Explorer"" ba=""4"" hwnd=""3""/><control h=""295"" w=""245"" x=""1001"" y=""358"" lp=""0.80337079"" tp=""0.45045045"" type=""Code Explorer"" hwnd=""4""/></win></gui>")
		this.Top:=this.Gui.SSN("//win[@win=1]/@QuickFindTop").text
	}Add(hwnd,type){
		return this.GUI.Under(this.GUI.SSN("//win[@win='" this.win "']"),"control",{hwnd:hwnd,type:type})
	}Attach(){
		xx:=this.Gui,list:=xx.SN("//*[@win=1]/descendant::control"),win:=this.WinPos()
		while(ll:=list.item[A_Index-1]),ea:=XML.EA(ll){
			ll.RemoveAttribute("ra"),ll.RemoveAttribute("ba")
			if(node:=xx.SSN("//win[@win=1]/descendant::*[@x=" ea.x+ea.w " and @y=" ea.y " and @y+@h=" ea.y+ea.h "]"))
				ll.SetAttribute("ra",SSN(node,"@hwnd").text)
			else if(node:=xx.SSN("//win[@win=1]/descendant::*[@x=" ea.x+ea.w " and @y=" ea.y "]"))
				ll.SetAttribute("ra",SSN(node,"@hwnd").text)
			else if(node:=xx.SSN("//win[@win=1]/descendant::*[@x=" ea.x+ea.w " and @y<" ea.y " and @y+@h>=" ea.y "]"))
				ll.SetAttribute("ra",SSN(node,"@hwnd").text)
			if(node:=xx.SSN("//win[@win=1]/descendant::*[@y=" ea.y+ea.h " and @x=" ea.x " and @x+@w=" ea.x+ea.w "]"))
				ll.SetAttribute("ba",SSN(node,"@hwnd").text)
			else if(node:=xx.SSN("//win[@win=1]/descendant::*[@y=" ea.y+ea.h " and @x=" ea.x "]"))
				ll.SetAttribute("ba",SSN(node,"@hwnd").text)
			else if(node:=xx.SSN("//win[@win=1]/descendant::*[@y=" ea.y+ea.h " and @x<" ea.x " and @x+@w>=" ea.x "]"))
				ll.SetAttribute("ba",SSN(node,"@hwnd").text)
			if(ea.x)
				ll.SetAttribute("lp",Round(ea.x/win.w,6))
			else
				ll.RemoveAttribute("lp")
			if(ea.y)
				ll.SetAttribute("tp",Round(ea.y/(win.h-MainWin.sb),8))
			else
				ll.RemoveAttribute("tp")
	}}ChangePointer(a,b,c){
		if(this!=18&&a!=1)
			return
		obj:=MainWin,pos:=obj.MousePos(),x:=pos.x,y:=pos.y,tnea:=obj.Gui.EA("//win[@win='Tracked_Notes']")
		if((node:=obj.Gui.SSN("//*[@type='Tracked Notes' and (@x+4<" x " and @x+@w+-4>" x ")and(@y<" y " and @y+@h>" y ")]"))&&((tnea.x<x+4&&tnea.x>x-4)||(tnea.y<y+4&&tnea.y>y-4))){
			obj.ResizeInfo:=obj.Gui.SSN("//win[@win='Tracked_Notes']"),DllCall("SetCursor","UInt",SSN(node,"@vertical")?obj.cursns:obj.cursew)
		}else if((list:=obj.Gui.SN("//*[@win=1]/descendant::*[(@x+-4<='" x "' and @x+@w+4>='" x "')and(@y+-4<='" y "' and @y+@h+4>='" y "')]")).length>1){
			ri:=obj.ResizeInfo:=[],ri.list:=list
			while(ll:=list.item[A_Index-1],ea:=XML.EA(ll)){
				if(ea.x-4<x&&ea.x+4>x&&ea.x>0)
					ri.left:=ll
				if(ea.y-4<y&&ea.y+4>y&&ea.y>0)
					ri.top:=ll
			}
			if(ri.left||ri.top)
				DllCall("SetCursor","UInt",ri.left&&ri.top?obj.cursall:ri.top?obj.cursns:obj.cursew)
	}}Close(){
		Exit()
	}ContextMenu(a*){
		m:=this.MousePos(),this.NewCtrlPos:=m
		if(A_Gui=1)
			this:=obj:=MainWin
		if(a.1=1)
			ContextMenu()
	}DebugWindow(){
		if(type="Debug"&&this.Gui.SSN("//win[@win=1]/descendant::*[@type='Debug']"))
			return
		sc:=csc()
		if(sc.sc=MainWin.tnsc.sc)
			sc:=csc(2)
		ControlGetPos,x,y,w,h,,% "ahk_id" sc.sc
		this.NewCtrlPos:=[],this.NewCtrlPos.y:=Round((y+h)*.75),this.NewCtrlPos.ctrl:=sc.sc,this.Split("Below","Debug")
	}Delete(){
		np:=this.NewCtrlPos,hwnd:=np.ctrl,win:=np.win
		if(win!=this.hwnd)
			return
		nope:=1,xx:=this.GUI
		if(xx.SN("//win[@win='1']/descendant::control").length=1)
			return t("Can not delete the last Control","time:1")
		if(!onode:=xx.SSN("//control[@hwnd='" hwnd "']"))
			for a,b in ["toolbar"]
				if(onode:=xx.SSN("//control[@" b "='" hwnd "']"))
					break
		if(!onode.xml)
			return m("hmm.")
		oea:=XML.EA(onode),nope:=1,top:="win[@win='1']/descendant::"
		if(xx.SN("//" top "*[@type='Scintilla']").length=1&&oea.type="Scintilla")
			return t("Can not delete the last Control","time:1")
		if(xx.SSN("//" top "*[@x=" oea.x+oea.w " and @y=" oea.y "]")&&xx.SSN("//" top "*[@x=" oea.x+oea.w " and @y+@h=" oea.y+oea.h "]")){
			list:=xx.SN("//" top "*[@x=" oea.x+oea.w " and ((@y=" oea.y ")or(@y>" oea.y " and @y+@h<" oea.y+oea.h ")or(@y+@h=" oea.y+oea.h "))]")
			while(ll:=list.item[A_Index-1]),ea:=XML.EA(ll)
				ll.SetAttribute("x",oea.x),ll.SetAttribute("w",oea.w+ea.w),nope:=0,this.SetWinPos(XML.EA(ll))
		}else if(xx.SSN("//" top "*[@x+@w=" oea.x " and @y=" oea.y "]")&&xx.SSN("//" top "*[@x+@w=" oea.x " and @y+@h=" oea.y+oea.h "]")){
			list:=xx.SN("//" top "*[@x+@w=" oea.x " and ((@y=" oea.y ")or(@y>" oea.y " and @y+@h<" oea.y+oea.h ")or(@y+@h=" oea.y+oea.h "))]")
			while(ll:=list.item[A_Index-1]),ea:=XML.EA(ll)
				ll.SetAttribute("w",oea.w+ea.w),nope:=0,this.SetWinPos(XML.EA(ll))
		}else if(xx.SSN("//" top "*[@y+@h=" oea.y " and @x=" oea.x "]")&&xx.SSN("//" top "*[@y+@h=" oea.y " and @x+@w=" oea.x+oea.w "]")){
			list:=xx.SN("//" top "*[@y+@h=" oea.y " and ((@x=" oea.x ")or(@x>" oea.x " and @x+@w<" oea.x+oea.w ")or(@x+@w=" oea.x+oea.w "))]")
			while(ll:=list.item[A_Index-1]),ea:=XML.EA(ll)
				ll.SetAttribute("h",oea.h+ea.h),nope:=0,this.SetWinPos(XML.EA(ll))
		}else if(xx.SSN("//" top "*[@y=" oea.y+oea.h " and @x=" oea.x "]")&&xx.SSN("//" top "*[@y=" oea.y+oea.h " and @x+@w=" oea.x+oea.w "]")){
			list:=xx.SN("//" top "*[@y=" oea.y+oea.h " and ((@x=" oea.x ")or(@x>" oea.x " and @x+@w<" oea.x+oea.w ")or(@x+@w=" oea.x+oea.w "))]")
			while(ll:=list.item[A_Index-1]),ea:=XML.EA(ll){
				ll.SetAttribute("y",oea.y),ll.SetAttribute("h",oea.h+ea.h),nope:=0,this.SetWinPos(XML.EA(ll))
			}
		}if(!nope){
			onode.ParentNode.RemoveChild(onode)
			this.Attach(),this.Size(1)
			if(oea.type~="Project Explorer|Code Explorer"){
				this.SetWinPos(oea.hwnd,0,0,0,0,ea)
			}else if(oea.type~="Scintilla|Debug"){
				s.Hidden.push(oea.hwnd):=1,this.SetWinPos(oea.hwnd,0,0,0,0)
				if(oea.type="Debug"){
					v.debug:=""
					debug.Send("stop")
			}}else if(oea.type="Tracked Notes")
				this.SetWinPos(this.tnsc.sc,0,0,0,0,ea),this.SetWinPos(this.tn,0,0,0,0,ea),Redraw()
			else
				DllCall("DestroyWindow",uptr,oea.hwnd)
			if(oea.type="Tracked Notes")
				rem:=this.GUI.SSN("//win[@win='Tracked_Notes']"),rem.ParentNode.RemoveChild(rem)
		}else
			m("Please report this, Include a screenshot and where your mouse was at the time")
		if(oea.type!="Search")
			Redraw()
		SetTimer,FocusMain,% oea.type="Search"?-1:-300
		return
		FocusMain:
		ControlFocus,,% "ahk_id" csc(2).sc
		return
	}DropFiles(filelist,c*){
		for a,b in filelist{
			if(files.Find("//main/@file",b))
				m("File: " b " is Already open")
			Open(b),last:=b
		}tv(SSN(files.Find("//main/@file",last),"file/@tv").text)
	}EnterOff(a*){
		SetupEnter()
		return 0
	}EnterOn(a*){
		SetupEnter(1)
		return 0
	}ExitSizeMove(){
		relock:=MainWin.Gui.SN("//*[@ll or @lt]")
		while(rr:=relock.item[A_Index-1],ea:=XML.EA(rr)){
			if(ea.ll=0)
				rr.SetAttribute("ll",1)
			if(ea.lt=0)
				rr.SetAttribute("lt",1)
		}MainWin.Lock()
		WinGet,MM,MinMax,% MainWin.ID
		if(!MM)
			MainWin.Gui.SSN("//win[@win=1]").SetAttribute("pos",MainWin.WinPos().text)
	}Lock(w:="",h:=""){
		if(w||h)
			Gui,% "+MinSize" w "x" h
		else{
			Gui,-MinSize
		}
	}MousePos(){
		CoordMode,mouse,Relative
		MouseGetPos,x,y,win,Control,2
		obj:=MainWin,x:=x-obj.Border,y:=y-obj.Border-obj.Caption-obj.Menu-(v.Options.Top_Find?obj.QFHeight:0)
		if(!obj.Gui.SSN("//*[@hwnd='" Control+0 "']")&&Control=obj.tnsc.sc)
			Control:=obj.tn
		return {x:x,y:y,win:win,ctrl:Control+0}
	}QuickFind(){
		Gui,Add,Text,x3 hwndqftext,Quick Find:
		Gui,Add,Edit,x+3 w120 hwndqfedit gQFText
		ControlGetPos,,,,h,,ahk_id%qfedit%
		this.qfobj:={Regex:"Regex",Case_Sensitive:"Case Sensitive",Greed:"Greed","Multi_Line":"Multi-Line",Enter:"Require Enter For Search",Word_Border:"Word Border",Current_Area:"Current Area"}
		for a,b in this.qfobj
			this.qfobj[b]:=a
		for a,b in ["Regex","Case Sensitive","Greed","Multi-Line","Require Enter For Search","Word Border","Current Area"]{
			/*
				m((Settings.SSN("//options/@" Clean(RegExReplace(b,"-","_"))).text),b,Clean(RegExReplace(b,"-","_")),Settings.SSN("//options").xml)
			*/
			Gui,Add,Checkbox,% "x+3 c0xFFFFFF" (A_Index=1?"yp+4":"") " hwndhwnd g" this.qfobj[b] (Settings.SSN("//options/@" Clean(RegExReplace(b,"-","_"))).text?" Checked":""),%b%
			this.QFControls[this.qfobj[b]]:=hwnd
		}this.qfheight:=h,this.qfedit:=qfedit,this.qftext:=qftext
	}Rebuild(list){
		while(ll:=list.item[A_Index-1]),ea:=XML.EA(ll){
			if(ea.type="scintilla"){
				sc:=new s(1,{pos:"x" ea.x " y" ea.y " w" ea.w " h" ea.h}),hwnd:=sc.sc+0,sc.2277(v.Options.End_Document_At_Last_Line)
				if(ea.file){
					if(tv:=SSN(files.Find("//file/@file",ea.file),"@tv").text)
						tv(tv,{sc:sc.sc})
					else
						tv(files.SSN("//main/descendant::*/@tv").text,{sc:sc.sc})
				}
			}else if(ea.type="ToolBar")
				tb:=new ToolBar(1,"x" ea.x " y" ea.y " w" ea.w " h" ea.h,ea.id,ll),ll.SetAttribute("win",tb.win),hwnd:=tb.hwnd+0,ll.SetAttribute("toolbar",tb.tb)
			else if(ea.type="Project Explorer")
				hwnd:=this.pe+0
			else if(ea.type="Code Explorer")
				hwnd:=this.ce+0
			else if(ea.type="Tracked Notes"){
				hwnd:=this.tn+0
			}else if(ea.type="Debug"){
				sc:=new s(1,{pos:"x" ea.x " y" ea.y " w" ea.w " h" ea.h}),hwnd:=sc.sc+0,v.debug:=sc
				Loop,4
					sc.2242(A_Index-1,0)
				sc.2403(0x08,0)
			}else if(ea.type="Search"){
				hwnd:=SearchWin(ll)
			}else
				GUI,Add,% ea.type,% "x" ea.x " y" ea.y " w" ea.w " h" ea.h " hwndhwnd"
			if(ea.type="TreeView")
				TV_Add("testing")
			all:=this.GUI.SN("//@node()[.='" ea.hwnd "']")
			while(aa:=all.item[A_Index-1])
				aa.text:=hwnd
		}
		GUI,Show,% this.GUI.SSN("//win[@win='" this.win "']/@pos").text
		s.ctrl[this.GUI.SSN("//*[@type='Scintilla']/@hwnd").text].2400()
		if(this.GUI.SSN("//win[@win='" this.win "']/@max").text)
			WinMaximize,% MainWin.ID
	}Resize(a*){
		if(this!=18)
			return
		obj:=MainWin,m:=obj.MousePos(),ri:=obj.ResizeInfo,xx:=obj.Gui
		if(SSN(ri,"@win").text="Tracked_Notes"){
			split:=SSN(ri,"@split").text,ea:=xx.EA("//win[@win=1]/descendant::*[@type='Tracked Notes']")
			while(GetKeyState("LButton")){
				m:=obj.MousePos()
				if(m.x=lastx&&m.y=lasty)
					Continue
				lastx:=m.x,lasty:=m.y
				if(ea.vertical){
					if(ea.y<m.y-20&&ea.y+ea.h>m.y+20)
						ri.SetAttribute("split",Round((m.y-ea.y)/ea.h,4)),obj.Size(1)
				}else{
					if(ea.x<m.x-20&&ea.x+ea.w>m.x+20){
						ri.SetAttribute("split",Round((m.x-ea.x)/ea.w,4)),obj.Size(1)
			}}}obj.ResizeInfo:=""
			return
		}
		limits:=[]
		for a,b in ["left","right","top","bottom"]
			limits[b]:=[]
		/*
			change minx maxx miny and maxy to objects and do MinIndex() and MaxIndex()
		*/
		if(ri.top),ea:=XML.EA(ri.top){
			ri.top.SetAttribute("top",1)
			if(ri.list.length=2)
				ea1:=XML.EA(ri.list.item[0]),ea2:=XML.EA(ri.list.item[1])
			if(ea1.x=ea2.x&&ea1.x+ea1.w=ea2.x+ea2.w&&ea1.x!=""&&ea2.x!="")
				limits.top[ea1.y<ea2.y?ea1.y:ea2.y]:=1,limits.bottom[ea1.y+ea1.h>ea2.y+ea2.h?ea1.y+ea1.h:ea2.y+ea2.h]:=1
			else{
				minx:=ea.x,maxx:=ea.x+ea.w,x:=ox:=ea.x,y:=oy:=ea.y,w:=ea.w,limits.bottom[ea.y+ea.h]:=1
				while(node:=xx.SSN("//*[@win=1]/descendant::*[@y=" y " and @x+@w=" x "]"),lea:=XML.EA(node))
					x:=lea.x,node.SetAttribute("top",1),limits.bottom[lea.y+lea.h]:=1,minx:=lea.x<minx?lea.x:minx,maxx:=lea.x+lea.w>maxx?lea.x+lea.w:maxx
				x:=ox
				while(node:=xx.SSN("//*[@win=1]/descendant::*[@y=" y " and @x=" x+w "]"),lea:=XML.EA(node))
					x:=lea.x,w:=lea.w,node.SetAttribute("top",1),limits.bottom[lea.y+lea.h]:=1,minx:=lea.x<minx?lea.x:minx,maxx:=lea.x+lea.w>maxx?lea.x+lea.w:maxx
				above:=xx.SN("//*[@win=1]/descendant::*[@y+@h=" ea.y " and @x>=" minx " and @x+@w<=" maxx "]")
				while(aa:=above.item[A_Index-1],ea:=XML.EA(aa))
					limits.top[ea.y]:=1
		}}if(ri.left),ea:=XML.EA(ri.left){
			ri.left.SetAttribute("left",1)
			if(ri.list.length=2)
				ea1:=XML.EA(ri.list.item[0]),ea2:=XML.EA(ri.list.item[1])
			if(ea1.y=ea2.y&&ea1.y+ea1.h=ea2.y+ea2.h&&ea1.y!=""&&ea2.y!="")
				limits.left[ea1.x<ea2.x?ea1.x:ea2.x]:=1,limits.right[ea1.x+ea1.w>ea2.x+ea2.w?ea1.x+ea1.w:ea2.x+ea2.w]:=1
			else{
				x:=ea.x,oy:=y:=ea.y,oh:=h:=ea.h,miny:=ea.y,maxy:=ea.y+ea.h,limits.right[ea.x+ea.w]:=1
				while(node:=xx.SSN("//*[@win=1]/descendant::*[@x=" x " and @y+@h=" y "]"),tea:=XML.EA(node))
					y:=tea.y,node.SetAttribute("left",1),limits.right[tea.x+tea.w]:=1,miny:=tea.y<miny?tea.y:miny,maxy:=tea.y+tea.h>maxy?tea.y+tea.h:maxy
				y:=oy,h:=oh
				while(node:=xx.SSN("//*[@win=1]/descendant::*[@x=" x " and @y=" y+h "]"),tea:=XML.EA(node))
					y:=tea.y,h:=tea.h,node.SetAttribute("left",1),limits.right[tea.x+tea.w]:=1,miny:=tea.y<miny?tea.y:miny,maxy:=tea.y+tea.h>maxy?tea.y+tea.h:maxy
				lefts:=xx.SN("//*[@win=1]/descendant::*[@x+@w='" ea.x "' and @y>=" miny " and @y+@h<=" maxy "]")
				while(ll:=lefts.item[A_Index-1],ea:=XML.EA(ll))
					limits.left[ea.x]:=1
		}}limits.top:=limits.top.MaxIndex()+20,limits.bottom:=limits.bottom.MinIndex()-20,limits.left:=limits.left.MaxIndex()+20,limits.right:=limits.right.MinIndex()-20,all:=xx.SN("//*[@win=1]/descendant::*[@top or @left]")
		while(GetKeyState("LButton")){
			if(A_Gui!=1&&A_Gui~="i)^window\d+"=0)
				Break
			m:=obj.MousePos(),win:=obj.WinPos()
			if(m.x=lastx&&m.y=lasty)
				Continue
			lastx:=m.x,lasty:=m.y
			if(limits.left!=""&&limits.top!=""){
				if(!(m.y<limits.bottom&&m.y>limits.top&&m.x>limits.left&&m.x<limits.right)){
					Continue
			}}else{
				if(!limits.left&&!limits.right)
					if(!(m.y<limits.bottom&&m.y>limits.top))
						Continue
				if(!limits.top&&!limits.bottom)
					if(!(m.x>limits.left&&m.x<limits.right))
						Continue
			}while(aa:=all.item[A_Index-1],ea:=XML.EA(aa)){
				if(ea.left)
					aa.SetAttribute("x",m.x),aa.SetAttribute("lp",Round(m.x/win.w,8))
				if(ea.top)
					aa.SetAttribute("y",m.y),aa.SetAttribute("tp",Round(m.y/(win.h-obj.sb),8))
			}obj.Size(1)
		}all:=xx.SN("//*[@top or @left or @resize]")
		while(aa:=all.item[A_Index-1])
			aa.RemoveAttribute("top"),aa.RemoveAttribute("left"),aa.RemoveAttribute("resize")
		obj.ChangePointer(1,1,1)
	}SetWinPos(hwnd,x,y,w,h,ea="",flags:="",set:=0){
		y:=v.Options.Top_Find?y+=this.qfheight:y
		DllCall("SetWindowPos",int,hwnd,int,0,int,x,int,y,int,w,int,h,uint,flags),DllCall("RedrawWindow",int,hwnd,int,0,int,0,uint,0x401|0x2)
		if(set){
			node:=this.Gui.SSN("//*[@hwnd='" hwnd "']")
			for a,b in {x:x,y:y-(v.Options.Top_Find?this.qfheight:0),w:w,h:h}
				node.SetAttribute(a,b)
		}
		if(ea.type="Toolbar")
			DllCall("SetWindowPos",int,ea.toolbar,int,0,int,0,int,0,int,w,int,h,uint,0x0008|0x0004|0x0010|0x0020)
	}Show(Title,info){
		Gui,1:Show,Hide
		xx:=this.xml,all:=this.XML.SN("//win[@win=1]/descendant::control"),win:=this.WinPos()
		while(aa:=all.item[A_Index-1]),ea:=XML.EA(aa){
			if(ea.x>0&&!ea.lp)
				aa.SetAttribute("lp",Round(ea.x/win.w,6))
			if(ea.y>0&&!ea.tp)
				aa.SetAttribute("tp",Round(ea.y/win.h,6))
		}pos:=this.XML.SSN("//*[@win=1]/@pos").text,pos:=pos?pos:info.pos
		Gui,1:Show,%pos%,%title%
	}Size(a*){
		static init,lastw,lasth
		xx:=MainWin.Gui,all:=xx.SN("//win[@win=1]/descendant::control"),win:=MainWin.WinPos(),rctrl:=[],obj:=MainWin,win.h-=obj.qfheight
		while(aa:=all.item[A_Index-1]),ea:=XML.EA(aa){
			if(ea.tp&&ea.lt!=1)
				aa.SetAttribute("y",(ny:=Round(win.h*ea.tp))),ea.y:=ny,resize:=1
			if(ea.lp&&ea.ll!=1)
				aa.SetAttribute("x",(nx:=Round(win.w*ea.lp))),ea.x:=nx,resize:=1
			if(resize)
				rctrl[ea.hwnd]:=ea,resize:=0
		}
		while(aa:=all.item[A_Index-1]),ea:=XML.EA(aa){
			if(ea.ba){
				aa.SetAttribute("h",(nh:=xx.SSN("//*[@hwnd=" ea.ba "]/@y").text-ea.y)),ea.h:=nh,resize:=1
				if(nh<20)
					obj.Lock("",win.h+60),locked:=1
			}
			if(!ea.ba){
				aa.SetAttribute("h",(nh:=win.h-ea.y)),ea.h:=nh,resize:=1
				if(nh<20)
					obj.Lock("",win.h+20),locked:=1
			}
			if(ea.ra){
				aa.SetAttribute("w",(nw:=xx.SSN("//*[@hwnd=" ea.ra "]/@x").text-ea.x)),ea.w:=nw,resize:=1
				if(nw<40)
					obj.Lock(win.w+20),locked:=1
			}
			if(!ea.ra){
				aa.SetAttribute("w",(nw:=win.w-ea.x)),ea.w:=nw,resize:=1
				if(nw<20)
					obj.Lock(win.w+20),locked:=1
			}
			if(resize)
				rctrl[ea.hwnd]:=ea,resize:=0
		}for i,ea in rctrl{
			if(ea.type="Tracked Notes"){
				node:=MainWin.Gui.SSN("//*[@win='Tracked_Notes']"),tea:=XML.EA(node),w:=ea.w,h:=ea.h,x:=ea.x,y:=ea.y
				if(ea.vertical)
					(width:=nw:=w,nx:=x,height:=Round(h*tea.split),ny:=y+height,nh:=h-height,node.SetAttribute("y",y+height),(tea.x?node.RemoveAttribute("x")))
				else
					(width:=Round(w*tea.split),height:=nh:=h,ny:=y,nx:=x+width,nw:=w-width,node.SetAttribute("x",nx),(tea.y?node.RemoveAttribute("y")))
				MainWin.SetWinPos(MainWin.tn,x,y,width,height,ea,0x0004|0x0010|0x0200|0x2000|0x0400|0x4000),MainWin.SetWinPos(MainWin.tnsc.sc,nx,ny,nw,nh,ea,0x0008|0x0004|0x0010|0x0020|0x0200)
			}else
				MainWin.SetWinPos(ea.hwnd,ea.x,ea.y,ea.w,ea.h,ea,(ea.type~="Search|Project Explorer|Code Explorer|QF")?0x0004|0x0010|0x0200|0x2000|0x0400|0x4000:0x0008|0x0004|0x0010|0x0020|0x0200)
		}if(locked){
			all:=xx.SN("//*[@lt or @ll]"),locked:=0
			while(aa:=all.item[A_Index-1]),ea:=XML.EA(aa){
				if(ea.lt)
					aa.SetAttribute("lt",0)
				if(ea.ll)
					aa.SetAttribute("ll",0)
			}
		}if(!init)
			VarSetCapacity(rect,16,0),init:=1
		for c,d in [[obj.qftext,(v.Options.Top_Find?4:win.h+4)],[obj.qfedit,(v.Options.Top_Find?0:win.h)]]
			GuiControl,1:Move,% d.1,% "y" d.2
		List:=""
		for a,b in Obj.QFControls
			GuiControl,1:Move,%b%,% "y" (v.Options.Top_Find?4:win.h+4)
		if(!v.Options.Top_Find)
			NumPut(0,rect,0),NumPut(win.h,rect,4),NumPut(win.w,rect,8),NumPut(win.h+obj.qfheight,rect,12),DllCall("RedrawWindow",uptr,obj.main,uptr,&rect,int,0,uint,0x1|0x4) ;0x1|0x4|0x20|0x800|0x10
		lastw:=win.w,lasth:=win.h
		SetTimer,UpdateXML,-50
		return
		UpdateXML:
		xx:=MainWin.xml,s.ctrl[xx.SSN("//control[7]/@hwnd").text].2181(0,xx[])
		return
	}Split(direction:=0,type:="Scintilla"){
		space:=[],np:=this.NewCtrlPos,hwnd:=np.ctrl,add:=0
		win:=this.WinPos()
		if(!node:=this.GUI.SSN("//*[@hwnd='" hwnd "']"))
			if(!node:=this.GUI.SSN("//*[@hwnd='" hwnd+0 "']"))
				return m("Something went Terribly wrong.")
		ea:=XML.EA(node),npos:=this.WinPos(ea.hwnd),x-=this.Border+npos.x
		if(direction="Above")
			this.SetWinPos(hwnd,ea.x,np.y+add,ea.w,ea.h-(np.y-ea.y),ea,,1),space:={x:ea.x,y:ea.y+add,w:ea.w,h:np.y-ea.y}
		if(direction="Below")
			this.SetWinPos(hwnd,ea.x,ea.y+add,ea.w,np.y-ea.y,ea,,1),space:={x:ea.x,y:np.y+add,w:ea.w,h:ea.h-(np.y-ea.y)}
		if(direction="Left")
			this.SetWinPos(hwnd,np.x,ea.y+add,ea.w-(np.x-ea.x),ea.h,ea,,1),space:={x:ea.x,y:ea.y+add,w:np.x-ea.x,h:ea.h}
		if(direction="Right")
			this.SetWinPos(hwnd,ea.x,ea.y,np.x-ea.x,ea.h,ea,,1),space:={x:np.x,y:ea.y+add,w:ea.w-(np.x-ea.x),h:ea.h}
		if(type~="i)(Scintilla|Debug)"){
			sc:=new s(1,{pos:"x0 y0 w0 h0"}),Redraw()
			node:=this.Add(sc.sc,type),Color(sc,"",A_ThisFunc " Class Mainwin"),sc.2277(v.Options.End_Document_At_Last_Line)
			if(type="Debug"){
				Loop,4
					sc.2242(A_Index-1,0)
				v.debug:=sc,sc.2403(0x08,0)
			}
		}else if(type="Search"){
			node:=this.Add(this.NewCtrlPos.hwnd,"Search")
		}else if(type="Code Explorer"){
			node:=this.Add(this.ce,type)
		}else if(type="Project Explorer"){
			node:=this.Add(this.pe,type)
		}else if(type="Tracked Notes")
			this.Tracked_Notes(),node:=this.Add(this.tn,type)
		else if(type="Toolbar")
			node:=this.GUI.Under(this.GUI.SSN("//win[@win='" this.win "']"),"control",{hwnd:"",type:type}),tb:=new ToolBar(1,"x" space.x " y" space.y " w" space.w " h" space.h,Create_Toolbar().ID,node)
		for a,b in space
			node.SetAttribute(a,b)
		this.NewCtrlPos:="",this.mousedown:=0
		if(space.x)
			node.SetAttribute("lp",Round(space.x/win.w,6))
		if(space.y)
			node.SetAttribute("tp",Round((space.y-add)/win.h,6))
		this.ChangePointer("Update")
		this.Attach(),this.Size(1)
		WinSet,Redraw,,% MainWin.id
		if(type="Scintilla"){
			tv:=Current(3).tv
			ControlFocus,,% "ahk_id" sc.sc
			tv(tv)
		}
	}Theme(){
		RefreshThemes()
	}Tracked_Notes(){
		if(!this.GUI.SSN("//win[@win='Tracked_Notes']"))
			this.GUI.Add("win",{win:"Tracked_Notes",split:.25},,1)
	}Type(new,id:=0){
		static NewHwnd,hwnd,newtype
		np:=this.NewCtrlPos,hwnd:=np.ctrl
		if(!node:=this.GUI.SSN("//*[@hwnd='" hwnd "']")){
			hwnd+=0
			if(!node:=this.GUI.SSN("//*[@hwnd='" hwnd "']"))
				return m("Sorry, something went really wrong.")
		}win:=this.WinPos(hwnd),ea:=XML.EA(node)
		if(ea.type="Tracked Notes")
			rem:=this.GUI.SSN("//win[@win='Tracked_Notes']"),rem.ParentNode.RemoveChild(rem)
		for a,b in ["toolbar","id","Scintilla","TreeView"]
			node.RemoveAttribute(b)
		if(ea.type="Scintilla"){
			if((len:=MainWin.GUI.SN("//win[@win=1]/descendant::*[@type='Scintilla']").length)<=1&&new!="Scintilla"&&ea.type="Scintilla")
				return m("You need at least 1 Sctintilla control.","Right Click and choose Split Control to create a new space for your " new,len)
			this.Hidden.push(ea.hwnd),s.ctrl[ea.hwnd].Hidden:=1,this.SetWinPos(ea.hwnd,0,0,0,0,ea),csc(2)
		}
		if(ea.type="Toolbar")
			DllCall("DestroyWindow",uptr,hwnd)
		if(ea.type="Tracked Notes")
			this.SetWinPos(ea.hwnd,0,0,0,0,ea),Redraw(),RefreshThemes()
		if(ea.type~="Code Explorer|Project Explorer")
			this.SetWinPos(ea.hwnd,0,0,0,0,ea)
		if(new="Project Explorer")
			NewHwnd:=this.pe
		if(new="Code Explorer")
			NewHwnd:=this.ce
		if(new="Scintilla"){
			if(NewHwnd:=this.Hidden.pop()){
				SetFormat,integer,H
				NewHwnd+=0
				SetFormat,Integer,D
			}else
				sc:=new s(1,{pos:"x" ea.x " y" ea.y " w" ea.w " h" ea.h}),NewHwnd:=sc.sc,Color(sc,0,"Class Mainwin " A_ThisFunc)
			for a,b in this.Hidden
				m("remaining Scintilla Controls: " a)
		}if(new="ToolBar")
			tb:=new ToolBar(1,"x" ea.x " y" ea.y " w" ea.w " h" ea.h,id,node),NewHwnd:=tb.hwnd,node.SetAttribute("id",id),node.SetAttribute("toolbar",tb.tb),node.SetAttribute("win",tb.WindowName)
		if(new="Tracked Notes")
			this.Tracked_Notes(),ea:=XML.EA(node),NewHwnd:=this.tn
		node.SetAttribute("type",new)
		all:=this.GUI.SN("//@node()[.='" hwnd "']")
		while(aa:=all.item[A_Index-1]),ea:=XML.EA(aa)
			aa.text:=NewHwnd
		this.Size([1]),this.Updatnode:=this.GUI.SSN("//win[@win='" A_Gui "']").SetAttribute("pos",win.text),this.NewCtrlPos:="",this.Size(1),Redraw() ;,this.Fix()
		this.Attach(),this.Size(1)
		if(new~="Project Explorer|Code Explorer")
			RefreshThemes()
		;DisplayStats(A_ThisFunc)
		return
	}WinPos(hwnd:="",win:=0){
		sub:=hwnd?0:this.sb,hwnd:=hwnd?hwnd:MainWin.main,VarSetCapacity(rect,16)
		WinGetPos,x,y,,,ahk_id%hwnd%
		DllCall("GetClientRect",ptr,hwnd,ptr,&rect),w:=NumGet(rect,8,"Int"),h:=NumGet(rect,12,"Int"),text:="x" x " y" y " w" w " h" h
		return {x:x,y:y,w:w,h:h-sub,text:text,ah:h}
	}
}
Class Omni_Search_Class{
	static prefix:={"@":"Menu","^":"File",":":"Label","(":"Function","{":"Class","[":"Method","&":"Hotkey","+":"Function","#":"Bookmark",".":"Property","<":"Instance","*":"Breakpoint",">":"Gui",")":"Clipboard"} ;,"%":"Variable"
	static iprefix:={Menu:"@",File:"^",Label:":",Function:"(",Class:"{",Method:"[",Hotkey:"&",Bookmark:"#",Property:".",Variable:"%",Instance:"<",Breakpoint:"*",Gui:">",Clipboard:")"}
	__New(){
		this.Menus(Refresh)
		return this
	}Menus(){
		rem:=cexml.SSN("//menu"),rem.ParentNode.RemoveChild(rem),this.MenuList:=[],List:=menus.SN("//menu"),Top:=cexml.Add("menu")
		while,mm:=list.item[A_Index-1],ea:=XML.EA(mm){
			clean:=ea.clean,hotkey:=Convert_Hotkey(ea.hotkey)
			StringReplace,clean,clean,_,%A_Space%,All
			launch:=IsFunc(ea.clean)?"func":IsLabel(ea.clean)?"label":v.Options.HasKey(ea.clean)?"option":""
			if(launch=""&&ea.plugin=""&&!v.Options.HasKey(ea.clean))
				Continue
			cexml.Under(top,"item",{launch:launch?launch:ea.plugin,text:clean,type:"Menu",sort:clean,additional1:hotkey,order:"text,type,additional1",clean:ea.clean})
		}
}}
Class PluginClass{
	__Call(x*){
		m(x)
	}__New(){
		return this
	}Activate(){
		WinActivate(hwnd([1]))
	}AllCtrl(code,lp,wp){
		for a,b in s.ctrl
			b[code](lp,wp)
	}AutoClose(script){
		if(!this.Close[script])
			this.Close[script]:=1
	}Call(info*){
		;this can cause major errors
		if(IsFunc(info.1)&&info.1~="i)(Fix_Indent|newindent)"=0){
			func:=info.1,info.Remove(1)
			return %func%(info*)
		}SetTimer,% info.1,-100
	}CallTip(text){
		sc:=csc(),sc.2200(sc.2128(sc.2166(sc.2008)),text)
	}Color(con){
		v.con:=con
		SetTimer,Color,-1
		Sleep,10
		v.con:=""
	}csc(obj,hwnd){
		csc({plugin:obj,hwnd:hwnd})
	}Current(x:=""){
		return Current(x)
	}DebugWindow(Text,Clear:=0,LineBreak:=0,Sleep:=0){
		sc:=v.debug
		if(!v.debug.sc)
			MainWin.DebugWindow()
		if(Clear)
			sc.2004()
		if(LineBreak)
			sc.2003(sc.2006,"`n")
		if(Sleep)
			Sleep,%Sleep%
		sc.2003(sc.2006,Text)
	}DynaRun(script){
		return DynaRun(script)
	}EnableSC(x:=0){
		sc:=csc()
		if(x){
			GuiControl,1:+Redraw,% sc.sc
			GuiControl,1:+gnotify,% sc.sc
		}else{
			GuiControl,1:-Redraw,% sc.sc
			GuiControl,1:+g,% sc.sc
	}}File(){
		return A_ScriptFullPath
	}Files(){
		return Update("get").1
	}Focus(){
		ControlFocus,Scintilla1,% hwnd([1])
		GuiControl,+Redraw,Scintilla1
		Gui,1:Default
		Gui,1:TreeView,SysTreeView321
		SetPos(TV_GetSelection()),csc(1)
	}Get(name){
		return _:=%name%
	}GuiControl(info*){
		GuiControl,% info.1,% info.2,% info.3
	}Hotkey(win:=1,key:="",label:="",on:=1){
		if(!(win,key,label))
			return m("Unable to set hotkey")
		Hotkey,IfWinActive,% hwnd([win])
		Hotkey,%key%,%label%,% _:=on?"On":"Off"
	}HotStrings(Text,String,end:=""){
		sc:=csc(),cpos:=sc.2008,TextLength:=StrPut(Text,"UTF-8")-1,StringLength:=StrPut(String,"UTF-8")-1,sc.2686(cpos-TextLength,cpos),sc.2194(StringLength,[String]),sc.2025((!end?cpos+StringLength-TextLength:cpos+end))
	}hwnd(win:=1){
		return hwnd(win)
	}InsertText(text){
		Encode(text,return),sc:=csc(),sc.2003(sc.2008,&return)
		if(end=0)
			sc.2025(sc.2008+StrPut(text,"UTF-8")-1)
		else if(end)
			sc.2025(sc.2008+end)
	}m(info*){
		m(info*)
	}MoveStudio(){
		Version:="1.005.09"
		SplitPath,A_ScriptFullPath,,,,name
		FileMove,%A_ScriptFullPath%,%name%-%version%.ahk,1
	}Open(info){
		tv:=Open(info),tv(tv),WinActivate(hwnd([1]))
	}Path(){
		return A_ScriptDir
	}Plugin(action,hwnd){
		SetTimer,%action%,-10
	}Publish(info:=0){
		return,Publish(info)
	}ReplaceSelected(text){
		Encode(text,return),csc().2170(0,&return)
	}Save(){
		Save()
	}sc(){
		return csc()
	}SetText(contents){
		length:=VarSetCapacity(text,strput(contents,"utf-8")),StrPut(contents,&text,length,"utf-8"),csc().2181(0,&text)
	}SetTimer(timer,period:=-10){
		if(!IsFunc(timer)&&!IsLabel(timer))
			return
		period:=period>0?-period:period
		SetTimer,%timer%,%period%
	}Show(){
		sc:=csc()
		WinActivate(hwnd([1]))
		GuiControl,+Redraw,% sc.sc
		SetPos(sc.2357),sc.2400
	}SSN(node,path){
		return node.SelectSingleNode(path)
	}StudioPath(){
		return A_ScriptFullPath
	}Style(){
		return ea:=Settings.EA(Settings.SSN("//theme/default")),ea.color:=RGB(ea.color),ea.Background:=RGB(ea.Background)
	}TrayTip(info){
		TrayTip,AHK Studio,%info%,2
	}tv(tv){
		if(tv~="\D"=0)
			return tv(tv)
		else
			return tv(SSN(files.Find("//file/@file",tv),"@tv").text)
	}Update(filename,text){
		Update({file:filename,text:text})
	}Version(){
		Version:="1.005.09"
		return version
	}
}
class s{
	static ctrl:=[],main:=[],temp:=[],hidden:=[]
	__New(window,info){
		static int,count:=1
		if(window=1)
			if(sc:=s.hidden.pop()){
				sc:=s.ctrl[sc],sc.hidden:=0
				return sc
			}
		if(!init)
			DllCall("LoadLibrary","str",A_ScriptDir "\scilexer.dll"),init:=1
		v.im:=info.main,v.ip:=info.pos,v.iw:=info.win,notify:=info.notify,win:=window?window:1,pos:=info.pos?info.pos:"x0 y0 w0 h0"
		if(info.hide)
			pos.=" Hide"
		mask:=0x10000000|0x400000|0x40000000,notify:=notify?notify:"notify"
		Gui,%win%:Add,custom,%pos% classScintilla +%mask% hwndsc g%notify% ;g%notify% ; +1387331584
		for a,b in {fn:2184,ptr:2185}
			this[a]:=DllCall("SendMessageA",UInt,sc,int,b,int,0,int,0)
		this.parent:=sc,this.sc:=sc+0
		if(!info.notify)
			s.ctrl[sc]:=this
		for a,b in [[2563,1],[2565,1],[2614,1],[2124,1]]
			this[b.1](b.2,b.3?b.3:0)
		if(v.Options.Center_Caret)
			this.2402(0x04|0x8,0),this.2403(0x04|0x8,0)
		if(info.main)
			s.Main.Push(this)
		if(info.temp)
			s.temp.Push(this)
		this.2246(2,1),this.2052(32,0),this.2051(32,0xaaaaaa),this.2050,this.2052(33,0x222222),this.2069(0xAAAAAA),this.2601(0xaa88aa),this.2563(1),this.2614(1),this.2565(1),this.2660(1),this.2036(width:=Settings.SSN("//tab").text?Settings.SSN("//tab").text:5),this.2124(1),this.2260(1),this.2122(5),this.2056(38,"Consolas"),this.2516(1),this.2663(5),this.2277(v.Options.End_Document_At_Last_Line)
		/*
			;TURN THIS BACK ON!!!!
			if(v.Options.Center_Caret)
				this.2402(0x04|0x8,0)
			else
				this.2402(0x04|0x01,0)
		*/
		this.2359(0x1|0x2|0x800|0x400)
		this.2359(0x400|0x20|0x40|0x800|0x02|0x01)
		return this
	}__Get(x*){
		return DllCall(this.fn,"Ptr",this.ptr,"UInt",x.1,int,0,int,0,"Cdecl")
	}__Call(code,lparam=0,wparam=0,extra=""){
		if(code="Enable"){
			if(lparam){
				GuiControl,1:+Redraw,% this.sc
				GuiControl,1:+gnotify,% this.sc
			}else{
				GuiControl,1:-Redraw,% this.sc
				GuiControl,1:+g,% this.sc
		}}if(code="GetWord"){
			sc:=csc(),cpos:=lparam?lparam:sc.2008
			return sc.TextRange(sc.2266(cpos,1),sc.2267(cpos,1))
		}else if(code="GetSelText"){
			VarSetCapacity(text,this.2161),length:=this.2161(0,&text)
			return StrGet(&text,length,"UTF-8")
		}else if(code="TextRange"){
			cap:=VarSetCapacity(text,Abs(lparam-wparam)),VarSetCapacity(TextRange,12,0),NumPut(lparam,TextRange,0),NumPut(wparam,TextRange,4),NumPut(&text,TextRange,8),this.2162(0,&TextRange)
			return StrGet(&text,cap,"UTF-8")
		}else if(code="GetLine"){
			length:=this.2350(lparam),cap:=VarSetCapacity(text,length,0),this.2153(lparam,&text)
			return StrGet(&text,length,"UTF-8")
		}else if(code="GetPlain"){
			cap:=VarSetCapacity(text,vv:=this.2182),this.2182(vv,&text),t:=strget(&text,vv,lparam)
			return t
		}else if(code="GetText"){
			cap:=VarSetCapacity(text,vv:=this.2182),this.2182(vv,&text),t:=strget(&text,vv,"UTF-8")
			return t
		}else if(code="GetUni"){
			VarSetCapacity(text,vv:=this.2182),this.2182(vv,&text)
			return StrGet(&text,vv,"UTF-8")
		}wp:=(wparam+0)!=""?"Int":"AStr",lp:=(lparam+0)!=""?"Int":"AStr"
		if(wparam.1!="")
			wp:="AStr",wparam:=wparam.1
		wparam:=wparam=""?0:wparam,lparam:=lparam=""?0:lparam
		if(wparam=""||lparam="")
			return
		return DllCall(this.fn,"Ptr",this.ptr,"UInt",code,lp,lparam,wp,wparam,"Cdecl")
	}
}
Class SelectionClass{
	__New(){
		this.XML:=new XML("selection")
		return this
	}Clear(){
		rem:=this.XML.SSN("//sel"),rem.ParentNode.RemoveChild(rem),top:=this.XML.Add("sel")
		return top
	}GetMain(){
		return this.XML
	}GetSN(){
		return this.XML.SN("//select")
	}
}
Class Toolbar{
	static keep:=[],order:=[],list:=[],imagelist:="",toolbar1,toolbar2,toolbar3,fun
	__New(win,pos,id:="",node:=""){
		static count:=0
		static
		WindowName:=b:="window" count,count++,mask:=mask?mask:0x800|0x100|0x10|0x2|0x20|0x200|0x8000|0x4|0x0040|0x40000000|0x00800000|0x800000,DefaultColor:=RGB(Settings.SSN("//theme/default/@background").text)
		Gui,%b%:+parent1 -Caption -Border +0x400000 hwndhwnd -DPIScale
		Gui,%b%:Color,%DefaultColor%,%DefaultColor%
		Gui,%b%:Add,Custom,% "ClassToolbarWindow32 +" mask " gtoolbar vtoolbar" count " w20 h20 hwndtbhwnd"
		for a,b in {hwnd:hwnd+0,toolbar:tbhwnd+0,win:WindowName,id:id}
			node.SetAttribute(a,b)
		Gui,%b%:Show,%pos%
		this.name:=name,this.iconlist:=[],this.hwnd:=hwnd+0,this.tb:=tbhwnd+0,this.count:=count,this.buttons:=[],this.returnbutton:=[],this.keep["toolbar" count]:=this,this.ahkid:="ahk_id" hwnd,this.win:=b,this.imagelist:=IL_Create(20,1,Settings.SSN("//options/@Small_Icons").text?0:1),this.SetImageList(),this.list[id]:=this,this.id:=id,this.SetMaxTextRows()
		Toolbar.keep[tbhwnd]:=this,this.WindowName:=WindowName
		if(!id)
			Create_Toolbar()
		txml:=Settings.SN("//toolbar/descendant::*[@id='" id "']/*")
		;MainWin.Gui.SSN("//*/descendant::*[@id='" id "']").SetAttribute("win",WindowName)
		if(txml.length){
			while(tt:=txml.item[A_Index-1]),ea:=XML.EA(tt){
				this.Add(ea)
				if(ea.vis)
					this.AddButton(ea.id)
		}}
		return this
	}SetState(button,state){
		SendMessage,0x400+17,button,0<<16|state&0xffff,,% this.ahkid
	}SetImageList(){
		SendMessage,0x400+48,0,% this.imagelist,,% "ahk_id " this.tb
	}ChangeIcon(id,icon,file){
		SendMessage,0x400+43,%id%,% this.IL(icon,file),,% "ahk_id" this.tb
		node:=Settings.SSN("//toolbar/bar[@id='" this.id "']/descendant::button[@id='" id "']"),node.SetAttribute("icon",icon),node.SetAttribute("file",file)
	}IL(icon="",file=""){
		if(this.iconlist[file,icon]!="")
			return this.iconlist[file,icon]
		if file contains .gif,.jpg,.png,.bmp
			index:=IL_Add(this.imagelist,file)-1
		else
			index:=IL_Add(this.imagelist,file,icon+1)-1
		this.iconlist[file,icon]:=index
		return index
	}Add(info){
		if(info.text){
			VarSetCapacity(STR,StrLen(info.text)*2),StrPut(info.text,&STR,StrLen(info.text)*2)
			SendMessage,0x400+77,0,&STR,,% "ahk_id " this.tb
			Index:=ErrorLevel
		}else
			info.text:="Separator"
		iimage:=this.il(info.icon,info.file),this.buttons[info.id]:={iimage:iimage,state:info.state,index:index,func:info.func,icon:info.icon,file:info.file,id:info.id,runfile:info.runfile,text:info.text},this.returnbutton.Insert(this.buttons[info.id])
	}AddButton(id){
		VarSetCapacity(button,20,0)
		info:=this.buttons[id]
		if(!info.id){
			NumPut(1,button,9)
			SendMessage,1044,1,&button,,% "ahk_id" this.tb
			return
		}
		if(IsFunc(info.func)=0&&IsLabel(info.func)=0&&!menus.SSN("//*[@clean='" info.func "']")&&!FileExist(info.runfile)) ;&&FileExist(menus.SSN("//*[@clean='" info.func "']/@plugin").text)="")
			return
		for a,b in {0:[info.iimage,"int"],4:[info.id,"int"],8:[info.state,"char"],9:[info.style,"char"],16:[info.Index,"ptr"]}
			NumPut(b.1,button,a,b.2)
		SendMessage,1044,1,&button,,% "ahk_id" this.tb ;TB_ADDBUTTONSW
	}SetMaxTextRows(MaxRows=0){
		SendMessage,0x043C,MaxRows, 0,, % "ahk_id " this.tb
		return (ErrorLevel="FAIL")?False:True
	}Customize(){
		SendMessage,0x041B, 0, 0,, % "ahk_id " this.tb
		return (ErrorLevel="FAIL")?False:True
	}barinfo(){
		VarSetCapacity(size,8),VarSetCapacity(rect,16)
		WinGetPos,,,w,,% "ahk_id" this.tb
		SendMessage,0x400+29,0,&rect,,% "ahk_id" this.tb
		height:=NumGet(rect,12)
		SendMessage,0x400+99,0,&size,,% "ahk_id" this.tb ;TB_GETIDEALSIZE
		ideal:=NumGet(&size)
		return info:={ideal:ideal,id:this.id,height:height,hwnd:this.tb,width:ideal+20}
	}Ideal(x:=0){
		if(x){
			VarSetCapacity(size,8)
			SendMessage,0x400+99,0,&size,,% "ahk_id" this.tb ;TB_GETIDEALSIZE
			return NumGet(&size,0)
	}}Delete(button){
		rem:=Settings.SSN("//toolbar/bar[@id='" this.id "']/button[@id='" button.id "']"),rem.ParentNode.RemoveChild(rem)
		SendMessage,0x400+25,% button.id,0,,% "ahk_id" this.tb
		SendMessage,0x400+22,%ErrorLevel%,0,,% "ahk_id" this.tb
		this.buttons.Remove(button.id)
	}Notification(){
		toolbar:
		event:=A_EventInfo,code:=NumGet(A_EventInfo+8,0,"Int"),this:=toolbar.keep[A_GuiControl] ;Hwnd:=NumGet(A_EventInfo)]
		if(code=-12)
			return 1
		if(code=-713){
			Sleep,5
			return 1
		}if(code=-708){
			this.Save()
			return 1
		}
		if code not in -5,-708,-720,-723,-706,-707,-20,-704,-702
		{
			Sleep,10
			return 0
		}if(code=-20){ ;left click
			button:=this.buttons[NumGet(A_EventInfo+12)]
			if(GetKeyState("Alt","P")&&GetKeyState("Ctrl","P")){
				removeid:=this.id
				if(removeid=10000||removeid=10001)
					return m("Can not remove original toolbars only ones you create")
				if(removeid=10002)
					return m("Can not delete the Debug Toolbar")
				MsgBox,308,Remove This Toolbar,This Can NOT be undone.  Are you sure?
				IfMsgBox,Yes
				{
					rebar.hw.1.hide(removeid)
					for a,b in [Settings.SSN("//rebar/band[@id='" removeid "']"),Settings.SSN("//toolbar/bar[@id='" removeid "']")]
						if(b.xml)
							b.ParentNode.RemoveChild(b)
				}
				return
			}
			if(GetKeyState("Ctrl","P")&&button){
				Toolbar_Editor({hwnd:this.tb,id:this.id,button:NumGet(A_EventInfo+12)})
			}else if(!button.runfile){
				func:=button.func
				if(IsFunc(func)&&!GetKeyState("Shift","P"))
					%func%()
				else if(IsLabel(func))
					SetTimer,%func%,-10
				else if(FileExist((plugin:=menus.SSN("//*[@clean='" func "']/@plugin").text))){
					info:=menus.EA("//*[@clean='" func "']")
					Run,% Chr(34) info.plugin Chr(34) " " Chr(34) info.option Chr(34)
				}
				return 1
			}else if(IsFunc(button.func)||IsLabel(button.func))
				SetTimer,% button.func,-1
			else if(button.runfile)
				Run,% button.runfile
			return 0
		} 
		if(code=-708) ;toolbar change
			this.ideal()
		if(code=-720){
			if(info:=this.returnbutton[NumGet(A_EventInfo+12)+1]){
				for a,b in [[info.iimage,0,"int"],[info.id,4,"int"],[info.state,8,"char"],[info.style,9,"char"],[info.index,16,"int"]]
					NumPut(b.1,A_EventInfo+16,b.2,b.3)
				PostMessage,1,,,,% "ahk_id" this.hwnd
			}
		}
		if(code=-723) ;TBN_INITCUSTOMIZE
			PostMessage,1,,,,% "ahk_id" this.hwnd
		if(code=-706) ;TBN_QUERYINSERT
			PostMessage,1,,,,% "ahk_id" this.hwnd
		if(code=-707) ;TBN_QUERYDELETE
			PostMessage,1,,,,% "ahk_id" this.hwnd
		return 1
	}Save(){
		VarSetCapacity(button)
		if(!top:=Settings.SSN("//toolbar/bar[@id='" this.id "']"))
			top:=Settings.Add("toolbar/bar",{id:this.id},,1)
		sep:=SN(top,"descendant::separator")
		while,ss:=sep.item[A_Index-1]
			ss.ParentNode.RemoveChild(ss)
		all:=SN(top,"descendant::button")
		while,aa:=all.item[A_Index-1]
			aa.SetAttribute("vis",0)
		top:=Settings.SSN("//toolbar/bar[@id='" this.id "']")
		SendMessage,0x400+24,0,0,,% "ahk_id" this.tb ;TB_BUTTONCOUNT
		Loop,%ErrorLevel%{
			VarSetCapacity(button,80)
			SendMessage,0x400+23,% A_Index-1,&button,,% "ahk_id" this.tb ;TB_GETBUTTON
			id:=NumGet(&button,4),btn:=this.buttons[id].Clone()
			if(NumGet(&button,4)=0){
				new:=Settings.Under(top,"separator",{vis:1},1)
				Continue
			}
			if(!node:=SSN(top,"descendant::button[@id='" id "']")){
				btn.Delete("iimage"),btn.vis:=1
				Settings.Under(top,"button",btn)
			}else
				node.SetAttribute("vis",1)
			node.ParentNode.AppendChild(node)
		}
	}Remove(){
		DllCall("DestroyWindow","Ptr",this.tb),Toolbar.keep.Delete(this.tb)
	}
}
Class XML{
	keep:=[]
	__Get(x=""){
		return this.XML.xml
	}__New(param*){
		if(!FileExist(A_ScriptDir "\lib"))
			FileCreateDir,%A_ScriptDir%\lib
		root:=param.1,file:=param.2,file:=file?file:root ".xml",temp:=ComObjCreate("MSXML2.DOMDocument"),temp.SetProperty("SelectionLanguage","XPath"),this.xml:=temp,this.file:=file,XML.keep[root]:=this
		if(Param.3)
			temp.preserveWhiteSpace:=1
		if(FileExist(file)){
			ff:=FileOpen(file,"R","UTF-8"),info:=ff.Read(ff.Length),ff.Close()
			if(info=""){
				this.xml:=this.CreateElement(temp,root)
				FileDelete,%file%
			}else
				temp.LoadXML(info),this.xml:=temp
		}else
			this.xml:=this.CreateElement(temp,root)
		SplitPath,file,,dir
		if(!FileExist(dir))
			FileCreateDir,%dir%
	}Add(XPath,att:="",text:="",dup:=0){
		p:="/",add:=(next:=this.SSN("//" XPath))?1:0,last:=SubStr(XPath,InStr(XPath,"/",0,0)+1)
		if(!next.xml){
			next:=this.SSN("//*")
			for a,b in StrSplit(XPath,"/")
				p.="/" b,next:=(x:=this.SSN(p))?x:next.AppendChild(this.XML.CreateElement(b))
		}if(dup&&add)
			next:=next.ParentNode.AppendChild(this.XML.CreateElement(last))
		for a,b in att
			next.SetAttribute(a,b)
		if(text!="")
			next.text:=text
		return next
	}CreateElement(doc,root){
		return doc.AppendChild(this.XML.CreateElement(root)).ParentNode
	}EA(XPath,att:=""){
		list:=[]
		if(att)
			return XPath.NodeName?SSN(XPath,"@" att).text:this.SSN(XPath "/@" att).text
		nodes:=XPath.NodeName?XPath.SelectNodes("@*"):nodes:=this.SN(XPath "/@*")
		while(nn:=nodes.item[A_Index-1])
			list[nn.NodeName]:=nn.text
		return list
	}Find(info*){
		static last:=[]
		doc:=info.1.NodeName?info.1:this.xml
		if(info.1.NodeName)
			node:=info.2,find:=info.3,return:=info.4!=""?"SelectNodes":"SelectSingleNode",search:=info.4
		else
			node:=info.1,find:=info.2,return:=info.3!=""?"SelectNodes":"SelectSingleNode",search:=info.3
		if(InStr(info.2,"descendant"))
			last.1:=info.1,last.2:=info.2,last.3:=info.3,last.4:=info.4
		if(InStr(find,"'"))
			return doc[return](node "[.=concat('" RegExReplace(find,"'","'," Chr(34) "'" Chr(34) ",'") "')]/.." (search?"/" search:""))
		else
			return doc[return](node "[.='" find "']/.." (search?"/" search:""))
	}Get(XPath,Default){
		text:=this.SSN(XPath).text
		return text?text:Default
	}ReCreate(XPath,new){
		rem:=this.SSN(XPath),rem.ParentNode.RemoveChild(rem),new:=this.Add(new)
		return new
	}Save(x*){
		if(x.1=1)
			this.Transform()
		if(this.XML.SelectSingleNode("*").xml="")
			return m("Errors happened while trying to save " this.file ". Reverting to old version of the XML")
		FileName:=this.file?this.file:x.1.1,ff:=FileOpen(FileName,"R"),text:=ff.Read(ff.length),ff.Close()
		if(ff.encoding!="UTF-8")
			FileDelete,%FileName%
		if(!this[])
			return m("Error saving the " this.file " XML.  Please get in touch with maestrith if this happens often")
		if(!FileExist(FileName))
			FileAppend,% this[],%FileName%,UTF-8
		else if(text!=this[])
			file:=FileOpen(FileName,"W","UTF-8"),file.Write(this[]),file.Length(file.Position),file.Close()
	}SSN(XPath){
		return this.XML.SelectSingleNode(XPath)
	}SN(XPath){
		return this.XML.SelectNodes(XPath)
	}Transform(Loop:=1){
		static
		if(!IsObject(xsl))
			xsl:=ComObjCreate("MSXML2.DOMDocument"),xsl.loadXML("<xsl:stylesheet version=""1.0"" xmlns:xsl=""http://www.w3.org/1999/XSL/Transform""><xsl:output method=""xml"" indent=""yes"" encoding=""UTF-8""/><xsl:template match=""@*|node()""><xsl:copy>`n<xsl:apply-templates select=""@*|node()""/><xsl:for-each select=""@*""><xsl:text></xsl:text></xsl:for-each></xsl:copy>`n</xsl:template>`n</xsl:stylesheet>"),style:=null
		Loop,%Loop%
			this.XML.TransformNodeToObject(xsl,this.xml)
	}Under(under,node,att:="",text:="",list:=""){
		new:=under.AppendChild(this.XML.CreateElement(node)),new.text:=text
		for a,b in att
			new.SetAttribute(a,b)
		for a,b in StrSplit(list,",")
			new.SetAttribute(b,att[b])
		return new
	}
}
SSN(node,XPath){
	return node.SelectSingleNode(XPath)
}
SN(node,XPath){
	return node.SelectNodes(XPath)
}
Class(text,current:="",Remove:=0){
	return
	Omni:=GetOmni(SSN(Current,"@ext").text)
	if(Remove){
		for c,d in Omni{
			if(c~="Function|Class|Method|Property")
				Continue
			pos:=1
			while(RegExMatch(text,d,found,pos),pos:=found.Pos(1)+found.Len(1)){
				if(!found.len(1))
					Break
				Code_Explorer.RemoveTV(SN(current,"descendant::*[@type='" c "' and @text='" found.1 "']"))
		}}
		if(RegExMatch(text,Omni.Class,found))
			Code_Explorer.RemoveTV(SN(current,"descendant::*[@type='Class' and @text='" found.2 "']"))
	}else{
		for c,d in Omni{
			if(c~="Function|Class|Method|Property")
				Continue
			pos:=1
			while(RegExMatch(text,d,found,pos),pos:=found.Pos(1)+found.Len(1)){
				if(!found.len(1))
					Break
				Code_Explorer.Add(c,found)
			}
		}
		Code_Explorer.ScanComments(text),Code_Explorer.ScanClass(text,current),Code_Explorer.ScanFM(text,current),AddMissing()
	}
}
Clean(clean,tab=""){
	if(tab=2)
		return RegExReplace(clean,"_"," ")
	if(tab)
		return RegExReplace(clean,"[^\w ]")
	clean:=RegExReplace(RegExReplace(clean,"&")," ","_")
	if(InStr(clean,"`t"))
		clean:=SubStr(clean,1,InStr(clean,"`t")-1)
	return clean
}
Clear_Line_Status(){
	LineStatus.Clear()
}
Close(x:=1,all:="",Redraw:=1){
	parent:=Current(1),pea:=XML.EA(parent),nodes:=all?files.SN("//main[@file!='Libraries']"):files.SN("//main[@id='" pea.id "']")
	if(!Current(2).untitled)
		Save(3)
	Loop,2
		TVC.Disable(A_Index)
	if(x.length)
		nodes:=x
	/*
		when closing...
		Save()
		remove all TV associated with the Code_Explorer
		remove all TV associated with the Project Explorer
		remove all history elements (this needs looked into as far as back/forward go)
		
		DON'T REMOVE!
		any of the files from the Update() list
		Basically just get rid of the ability for the user to access the closed file info and remove all of it.
		Keep everything else though, file contents and such.
		WORK ON THIS!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	*/
	while(nn:=nodes.item[A_Index-1]),pea:=XML.EA(nn){
		if(!Settings.Find("//previous_scripts/script/text()",pea.file))
			Settings.Add("previous_scripts/script",,pea.file,1)
		if(pea.untitled&&Redraw)
			Save_Untitled(nn,1)
		all:=SN(nn,"descendant::*[@tv]")
		while(aa:=all.item[A_Index-1]),ea:=XML.EA(aa){
			if(A_Index=1)
				store:=ea.tv
			else if(ea.tv)
				TVC.Delete(1,ea.tv)
			RemoveHistory(ea)
		}if(store){
			TVC.Delete(1,store)
		}
		all:=cexml.SN("//*[@id='" pea.id "']")
		while(aa:=all.item[A_Index-1]),ea:=XML.EA(aa){
			if(A_Index=1)
				store:=ea.cetv
			else if(ea.cetv)
				TVC.Delete(2,ea.cetv)
		}if(store)
			TVC.Delete(2,store)
		rem:=Settings.Find("//open/file/text()",pea.file),rem.ParentNode.RemoveChild(rem)
		for a,b in [files.SSN("//main[@id='" pea.id "']"),cexml.SSN("//main[@id='" pea.id "']")]
			b.ParentNode.RemoveChild(b)
	}
	Loop,2
		TVC.Enable(A_Index)
	Default("SysTreeView321"),TV_Modify(TV_GetChild(0),"Select Vis Focus")
	if(tv:=files.SSN("//main[@file!='Libraries']/file/@tv").text)
		csc({set:1}).2400(),tv(tv)
	else
		New()
}
Close_All(){
	Close(1,1)
}
CloseSingleUntitled(){
	count:=files.SN("//main[@file!='Libraries']")
	if(count.length=1&&SSN(count.item[0],"@untitled").text){
		template:=GetTemplate(),text:=Update({get:(SSN(count.item[0],"@file").text)})
		if(template=text)
			CloseID:=SSN(count.item[0],"descendant::*/@id").text
	}
	return CloseID
}
Color(con:="",Language:="",FromFunc:=""){
	static Options:={Show_EOL:2356,Show_Caret_Line:2096},list:={Font:2056,Size:2055,Color:2051,Background:2052,Bold:2053,Italic:2054,Underline:2059},kwind:={Personal:0,indent:1,Directives:2,Commands:3,builtin:4,keywords:5,functions:6,flow:7,KeyNames:8}
	con:=con?con:v.con,con.Enable()
	if(!con.sc)
		return v.con:=""
	ConBackup:=con
	OldPath:="//fonts"
	if(Node:=Settings.SSN(OldPath "/font[@style=5]"))
		ConvertTheme()
	for a,b in (Default:=Settings.EA("//theme/default")){
		if((st:=list[a]))
			con[st](32,b)
		if(ea.code&&ea.value!="")
			con[ea.code](ea.value)
		else if(ea.code&&ea.bool!=1)
			con[ea.code](ea.color,0)
		else if(ea.code&&ea.bool)
			con[ea.code](ea.bool,ea.color)
	}con.2050(),con.2052(30,0x0000ff),con.2052(31,0x00ff00),con.2052(48,0xff00ff)
	Language:=Language?Language:(GetLanguage(con)?GetLanguage(con):"ahk"),MainXML:=Keywords.GetXML(Language),Extra:=Settings.SSN("//" Language)?Language:"ahk",nodes:=Settings.SN("//theme/*|//Languages/" Extra "/*")
	while(n:=nodes.item(A_Index-1),ea:=Settings.EA(n)){
		if(n.NodeName="indentguide"){
			con.2051(37,ea.color)
			Continue
		}else if(n.NodeName="caret"){
			for a,b in {2069:ea.Color,2098:ea.LineBack,2188:ea.Width}
				con[a](b)
			Continue
		}else if(n.NodeName~="i)(default|bracematch)")
			Continue
		for a,b in ["bold","italic","underline"]
			con[list[b]](ea.style,0)
		if(ea.code=2082){
			con.2082(7,ea.color),con.2498(1,7)
			Continue
		}if(n.NodeName="linenumbers"){
			for a,b in [2290,2291]
				con[b](1,(Background:=ea.Background?ea.Background:Default.Background))
			con.2052(33,Background),ea.style:=33
		}if(ea.style=""){
			if(n.NodeName!="keyword")
				ea.style:=MainXML.SSN("//Styles/" n.NodeName "/@style").text
			else
				ea.style:=MainXML.SSN("//Styles/descendant::*[@set='" ea.set "']/@style").text
			if(ea.style=34)
				con.2498(0,7)
			if(n.NodeName="linenumbers")
				m(ea.style,n.xml)
		}for a,b in ea
			if(list[a]&&ea.style!="")
				con[list[a]](ea.style,b)
		if(ea.code&&ea.value!=""){
			con[ea.code](ea.value)
		}else if(ea.code&&ea.bool!="")
			con[ea.code](ea.bool,ea.color)
		else if(ea.code&&ea.color&&ea.bool="")
			con[ea.code](ea.color)
	}SetWords()
	for a,b in [[2029,2],[2031,2],[2037,65001],[2040,0,0],[2040,1,0],[2040,2,22],[2040,25,13],[2040,26,15],[2040,27,17],[2040,28,16],[2040,29,9],[2040,3,22],[2040,30,12],[2040,31,14],[2040,4,31],[2041,0,0],[2041,1,0],[2042,0,0xff],[2042,1,0xff0000],[2042,4,0xff0000],[2115,1],[2130,v.Options.Hide_Horizontal_Scrollbars=1?0:1],[2132,v.Options.Hide_Indentation_Guides=1?0:1],[2134,1],[2240,3,0],[2242,0,20],[2242,1,13],[2242,3,15],[2244,2,3],[2244,3,0xFE000000],[2246,1,1],[2246,2,1],[2246,3,1],[2260,1],[2280,v.Options.Hide_Vertical_Scrollbars=1?0:1],[2611,3]]
		con[b.1](b.2,b.3)
	for a,b in [[2042,2,Settings.Get("//theme/font/@mca",0x444444)],[2042,3,Settings.Get("//theme/font/@sca",0x666666)]]
		con[b.1](b.2,b.3)
	if(v.Options.Word_Wrap_Indicators)
		con.2460(4)
	if(v.Options.Word_Wrap)
		con.2268(1)
	con.2472(2),con.2036(Settings.Get("//tab",5)),con.2082(3,0xFFFFFF)
	if(!Node:=Settings.SSN("//theme/bracematch")){
		for a,b in [0x0000FF,0xFFFFFF,0xFF0000,0x00FF00]
			if(Color!=b){
				con.2051(34,b)
				Break
			}
	}else{
		for a,b in XML.EA(Node)
			con[List[a]](34,b)
	}
	for a,b in Options
		if(v.Options[a])
			con[b](b)
	if(node:=Settings.SSN("//theme/fold")){
		ea:=XML.EA(node)
		Loop,7
			con.2041(24+A_Index,ea.color!=""?ea.color:"0"),con.2042(24+A_Index,ea.background!=""?ea.Background:"0xAAAAAA")
	}con.2680(3,6),con.2242(4,1),con.2240(4,5),con.2110(1)
	for a,b in [[2051,151,Settings.Get("//debug/continuecolor",0xFF8080)],[2051,35,0xff00ff],[2080,2,8],[2080,3,14],[2080,6,14],[2080,7,6],[2080,8,1],[2082,2,0xff00ff],[2082,6,0xC08080],[2082,8,0xff00ff],[2212,5],[2371,0],[2373,Settings.Get("//gui/@zoom",0)],[2458,2],[2516,1],[2636,1],[2680,3,6]]
		con[b.1](b.2,b.3)
	if(!v.Options.Match_Any_Word)
		con.2198(0x2)
	if(debug.socket)
		debug.Caret(1)
	Lexer:=con.4002(),con.4001(0),con.4001(Lexer)
	for a,b in {20:Settings.Get("//theme/editedmarkers/@edited",0x0000ff),21:Settings.Get("//theme/editedmarkers/@saved",0x00ff00)}
		con.2040(a,27),con.2042(a,b)
	con.4004("fold",[1]),MarginWidth(con)
	for a,b in Keywords.GetList(GetLanguage(con)){
		con.4005(a,b)
	}
	return con.Enable(1)
}
Command_Help(){
	static stuff,hwnd,ifurl:={between:"commands/IfBetween.htm",in:"commands/IfIn.htm",contains:"commands/IfIn.htm",is:"commands/IfIs.htm"}
	RegRead,outdir,HKEY_LOCAL_MACHINE,SOFTWARE\AutoHotkey,InstallDir
	if(!outdir)
		SplitPath,A_AhkPath,,outdir
	url:="mk:@MSITStore:" outdir "/AutoHotkey.chm::/docs/",CurrentWord:=sc.GetWord()
	sc:=csc(),info:=Context(1),line:=sc.GetLine((LineNo:=sc.2166(sc.2008))),found1:=info.word
	if(word:=sc.GetSelText())
		found1:=word
	if(!found1)
		RegExMatch(line,"[\s+]?(\w+)",found)
	if(RegExMatch(line,"O)^;*\s*;*#(\w*)",found))
		OpenHelpFile("mk:@MSITStore:C:\Program%20Files\AutoHotkey\AutoHotkey.chm::/docs/commands/_" found.1 ".htm")
	else if(RegExMatch(commands.SSN("//Commands/Commands").text,(CurrentWord?"\b(" found1 "|" CurrentWord ")\b":"\b(" found1 ")\b"),ff)){
		found1:=ff1
		if(RegExMatch(found1,"i)Set(Caps|Num|Scroll)LockState"))
			url.="commands/SetNumScrollCapsLockState.htm"
		else if(found1~="(FileExist|GetKeyState|InStr|SubStr|StrLen|StrSplit|WinActive|WinExist|Asc|Chr|GetKeyName|IsByRef|IsFunc|IsLabel|IsObject|NumGet|NumPut|StrGet|StrPut|RegisterCallback|Trim|Abs|Ceil|Exp|Floor|Log|Ln|Mod|Round|Sqrt|Sin|ASin|ACos|ATan)"){
			url.="Functions.htm#" found1
		}else if(found1~="i)^if"){
			if(found1~="i)\bIfEqual|IfNotEqual|IfLess|IfLessOrEqual|IfGreater|IfGreaterOrEqual\b")
				url.="commands/IfEqual.htm"
			else
				url.=ifurl[info.last]?ifurl[info.last]:"commands/IfExpression.htm"
		}else{
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
		}OpenHelpFile(url)
	}else if(RegExMatch(CurrentWord,"Oi)A_(\w*)",found))
		OpenHelpFile(url "Variables.htm#" found.1)
	else if(found1~="i)\b(loop|gui)\b")
		OpenHelpFile(url "commands/" found1 ".htm")
	else{
		if(!Settings.SSN("//HelpNag").text)
			if(m("The word: " Chr(34) found1 Chr(34) " was found and was not handled by AHK Studio.","If this is a command please let maestrith know.","btn:ync","Opening the help file","","Show again?")="No")
				Settings.Add("HelpNag",,1)
		OpenHelpFile("mk:@MSITStore:C:\Program%20Files%20(x86)\AutoHotkey\AutoHotkey.chm::/docs/AutoHotkey.htm")
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
	main:=SSN(Current(1),"@file").Text,v.compiling:=1
	SplitPath,main,,dir,,name
	RegRead,dirr,HKLM,Software\AutoHotkey,InstallDir
	if(ErrorLevel||dirr="")
		SplitPath,A_AhkPath,,dirr
	Loop,%dirr%\Compile_AHK.exe,1,1
		compile:=A_LoopFileFullPath
	if(FileExist(compile)&&v.Options.Disable_Compile_AHK!=1){
		run:=Current(2).file
		Run,%compile% "%run%"
		return
	}
	Loop,%dirr%\Ahk2Exe.exe,1,1
		file:=A_LoopFileFullPath
	if(!FileExist("temp"))
		FileCreateDir,temp
	FileDelete,temp\temp.upload
	FileAppend,% Publish(1),temp\temp.upload
	SplashTextOn,200,100,Compiling,Please wait.
	Loop,%dir%\*.ico
		icon:=A_LoopFileFullPath
	if(icon)
		add=/icon "%icon%"
	RunWait,%file% /in "%main%" /out "%dir%\%name%.exe" %add%
	if(FileExist("upx.exe")){
		SplashTextOn,,50,Compressing EXE,Please wait...
		RunWait,upx.exe -9 "%dir%\%name%.exe" ;,,Hide
	}
	FileDelete,temp\temp.upload
	SplashTextOff
	v.compiling:=0
}
CompileFont(XMLObject,RGB:=1){
	ea:=XML.EA(XMLObject),style:=[],name:=ea.name,styletext:="norm",Default:=Settings.EA("//theme/default")
	for a,b in {bold:"",color:"c",italic:"",size:"s",strikeout:"",underline:""}{
		if(a="color")
			Value:=ea.color!=""?ea.color:Default.color,styletext.=" c" (RGB?RGB(Value):Value)
		else if(ea[a])
			styletext.=" " (b?b ea[a]:a)
	}
	return styletext
}
Context(return=""){
	Static FindFirst:="O)^[\s|}]*((\w|[^\x00-\x7F])+)"
	Tick:=A_TickCount
	sc:=csc(),cp:=sc.2008,Line:=sc.2166(cp),LineIndent:=Start:=sc.2128(Line),PFL:=sc.2167(Line),OLineText:=LineText:=sc.GetLine(Line),NewString:=Trim(SubStr(LineText,1,cp-PFL) Chr(127) SubStr(LineText,cp-PFL+1)),Language:=Current(3).Lang,Delimiter:=Keywords.Delimiter[Language]
	if(v.DisableContext=Line)
		return
	else
		v.DisableContext:=""
	if(Line<(FirstVis:=sc.2152)){
		if(sc.2202)
			return sc.2201
		return
	}else if(FirstVis+sc.2370<Line){
		if(sc.2202)
			return sc.2201
		return
	}if(Delimiter.Delimiter){
		if(Regex:=Delimiter.RemoveAll){
			Pos:=LastPos:=1
			while(RegExMatch(NewString,Regex,Found))
				StringReplace,NewString,NewString,% Found.0,% (InStr(Found.0,Chr(127))?Chr(127):"")
		}if(Regex:=Delimiter.Preserve){
			Pos:=LastPos:=1,Place:={1:"Preserve"},LastCondition:="Preserve",Total:=""
			while(RegExMatch(NewString,Regex,Found,Pos)){
				for a,b in ["Open","Close","PreserveOpen","PreserveClose"]{
					Condition:=b
					if(Found[b])
						Break
				}if(Condition="Open")
					Place.Push("Open")
				else if(Condition="Close"&&Place.2)
					Place.Pop()
				else if(Condition="PreserveOpen")
					Place.Push("Preserve")
				else if(Condition="PreserveClose"&&Place.2)
					Place.Pop()
				Pos:=Found.Pos(Condition)+Found.Len(Condition),Process:=SubStr(NewString,LastPos,Pos-LastPos),Total.=LastCondition="Preserve"?Process:RegExReplace(Process,Delimiter.Delimiter,Chr(128)),LastCondition:=Place[Place.MaxIndex()]
				if(Pos=LastPos)
					Break
				LastPos:=Pos
			}Process:=SubStr(NewString,Pos)
			Total.=LastCondition="Preserve"?Process:RegExReplace(Process,Delimiter.Delimiter),NewString:=Total
	}}String:=SubStr(NewString,1,InStr(NewString,Chr(127))-1),OPos:=Pos:=StrLen(String),Remove:=[]
	while(Pos>=0){
		Chr:=SubStr(String,Pos,1)
		if(Chr=")")
			Remove.Push(Pos)
		if(Chr="("&&Remove.2)
			LastPos:=Remove.Pop()
		else if(Chr="("&&Remove.1)
			String:=SubStr(String,1,Pos-1) SubStr(String,Remove.Pop()+1),Removed:=1
		else if(Chr="("&&!Remove.1){
			BracePos:=Pos,Word:="",StartPos:=Pos
			while(Pos>1){
				Pos--,Chr:=SubStr(String,Pos,1)
				if(Chr~="(\w|\.)"=0)
					Break
				Word:=(Chr) Word
			}if(!Word&&Pos>0)
				Continue
			String:=SubStr(String,(Pos=1?1:Pos+1)),PositionInString:=Pos
			Break
		}Pos--
	}if(!Word)
		if(RegExMatch(String,FindFirst,Found))
			Word:=Found.1
	if(!Word)
		return SetStatus("Context Stopped @ " A_Now A_MSec)
	if(Return)
		return {word:word,last:last}
	Matches:=[],Split:=[]
	if((ea:=scintilla.EA("//scintilla/commands/item[@code='" StrSplit(word,".").Pop() "']")).syntax){
		Syntax:=ea.Syntax "`n" ea.Name,Matches.Push({att:Syntax,ea:ea,search:Syntax,Syntax:Word Syntax,Type:"Scintilla"}),Split["."]:=1
	}else{
		Omni:=GetOmni(Language)
		for a,b in Omni{
			if(InStr(Word,b.Delimiter)&&b.Delimiter){
				Obj:=StrSplit(Word,b.Delimiter),Max:=Obj.MaxIndex(),Pre:=SSN(Current(7),"descendant::*[@type='" a "' and @upper='" Upper(Obj[Max-1]) "']"),Parent:=SSN(Current(7),"descendant::*[@type='" b.Associate "' and @upper='" Upper(SSN(Pre,"@" Format("{:L}",b.Associate)).text) "']"),Node:=SSN(Parent,"descendant::*[@type='" b.Add "' and @upper='" Upper(Obj[Max]) "']"),Syntax:="(" (Things:=SSN(Node,"@att").text) ")"
				if(Node.NodeName)
					FoundThings:=1,Matches.Push({att:Syntax,ea:XML.EA(Node),search:Syntax,syntax:Word Syntax,type:a,file:SSN(Node,"ancestor::file/@filename").text}),Split[b.Delimiter]:=1
		}}if(!FoundThings){
			all:=SN(Current(7),"descendant::*[@upper='" Upper(Word) "']"),Index:=1,Syntax:="",List:=[],Reverse:=[]
			if(!all.Length)
				LastWord:=SubStr(Word,InStr(Word,".",0,0)+1),all:=SN(Current(7),"descendant::*[@upper='" Upper(LastWord) "']")
			while(aa:=all.item[A_Index-1],ea:=XML.EA(aa)){
				if(WordSplit:=Omni[ea.Type].WordSplit)
					if(!InStr(Word,WordSplit))
						Continue
				Matches.Push({att:ea.att,ea:ea,syntax:Word "(" ea.att ")",type:ea.type,file:SSN(aa,"ancestor::file/@filename").text})
			}RegExMatch(Word,"O)(\W)",Delim)
			if(Delim.1)
				WordObj:=StrSplit(Word,Delim.1)
			if(WW:=Keywords.Words[Language,(Delim.1?WordObj[WordObj.MaxIndex()]:Word)]){
				Parent:=Keywords.Languages[Language],all:=Parent.SN("//*[text()='" WW "' and not(ancestor-or-self::Context)]")
				while(Node:=all.item[A_Index-1],ea:=XML.EA(aa)){
					if(Syntax:=SSN(Node,"@syntax").text)
						Syntax:=RegExReplace(Syntax,"\x60n","`n"),RegExMatch(Syntax,"OA)(\(.*\))",Att)
					if((WordSplit:=SSN(Node,"ancestor-or-self::*[@wordsplit]/@wordsplit").text)&&Syntax){
						if(InStr(Word,WordSplit))
							Matches.Push({att:Att.1,ea:XML.EA(Node),syntax:(Syntax:=SSN(Node,"@replace")?Syntax:Word Syntax),type:SSN(Node,"@type").text})
					}else if(Syntax)
						Matches.Push({att:Att.1,ea:XML.EA(Node),syntax:(Syntax:=SSN(Node,"@replace")?Syntax:Word Syntax),type:SSN(Node,"@type").text})
			}}if(Top:=Keywords.Languages[Language].SSN("//Context/" WW)){
				Del:=(DD:=SSN(Top,"@delimiter").text)?DD:Delimiter.Delimiter,list:=SN(top,"list"),Build:=WW Del,Pos:=1,SearchWord:=WW
				while(RegExMatch(String,"OUi)\b(" RegExReplace(SSN(Top,"*[text()='" SearchWord "']/@list").text," ","|") ")\b",Found,Pos),Pos:=Found.Pos(1)+Found.Len(1)){
					if(Pos=LastPos)
						Break
					Build.=Found.1 Del,SearchWord:=Found.1,LastPos:=Pos
				}Pos:=LastPos:=1
				while(RegExMatch(Build,"O)(\w+)",Found,Pos),Pos:=Found.Pos(1)+Found.Len(1)){
					LastWord:=Found.1
					if(Pos=LastPos)
						Break
				}if((Node:=SSN(Top,"descendant::syntax[contains(.,'" LastWord "')]")))
					NoHighlight:=1,ea:=XML.EA(Node),Syntax:=ea.Replace?ea.Syntax:Trim(Build,Del) ea.Syntax,Matches.Push({att:Syntax,ea:ea,syntax:Syntax,NoHighlight:(InStr(Syntax,Delimiter.Delimiter)?0:1),First:Syntax})
	}}}if(Matches.1){
		MatchList:=[]
		if(Rep:=Keywords.ReplaceFirst[Language])
			if(RegExMatch(String,FindFirst Rep.First,Found))
				String:=RegExReplace(String,"A)" Found.1 RegExReplace(Rep.First,"\(\)"),Found.1 Rep.Replace,,1)
		RegExMatch(String,"OA)((\w|[^\x00-\x7F]|\.)+){0,}" Delimiter.Search,FirstAfter)
		for a,b in Matches{
			FirstChar:=SubStr(String,StrLen(Word)+1,1),FindSyntax:=RegExReplace(b.Syntax,"[^" Delimiter.Delimiter "|\w|\s|\Q" FirstChar "\E]",,,,StrLen(Word)+1)
			if(RegExMatch(FindSyntax,FindFirst Rep.First,Found))
				FindSyntax:=RegExReplace(FindSyntax,"A)" Found.1 RegExReplace(Rep.First,"\(\)"),Found.1 Rep.Replace,,1)
			if(FirstChar!=SubStr(FindSyntax,StrLen(Word)+1,1)&&FirstChar)
				Continue
			RegExReplace(b.Syntax,"\Q" Delimiter.Delimiter "\E",,Count),MatchList[Count,b.Syntax]:=b
		}Reverse:=[],Index:=0
		for a,b in MatchList
			for c,d in b
				Reverse.InsertAt(1,d),Total:=A_Index
		for a,b in Reverse{
			RegExMatch(b.Syntax,"AO)(\W|\s)+",Found),AddSpace:=InStr(Found.0,Delimiter.Delimiter)=0&&(Replace:=SubStr(b.syntax,1,1))!=Delimiter.Replace
			if(!b.Syntax)
				Continue
			Syntax:=b.Syntax,List.=Syntax (b.Type?" - " b.Type:"") (b.File?" - " b.File:"") "`n"
			if(!Index)
				First:=RegExReplace(Syntax,Delimiter.ReplaceRegex,Delimiter.Delimiter,,1),FirstEA:=b.EA,NoHighlight:=b.NoHighlight,Index++
		}if(Pos:=InStr(First,"`n"))
			First:=SubStr(First,1,Pos-1)
		if(!First)
			return sc.2201(),SetStatus("Context Stopped @ " A_Now A_MSec)
		String:=RegExReplace(String,Delimiter.ReplaceRegex,Delimiter.Delimiter,,1),String:=RegExReplace(String,"A)(\W+)")
		if(FirstEA.First){
			if(RegExMatch(First,FindFirst FirstEA.First,Found))
				First:=RegExReplace(First,"A)" Found.1 RegExReplace(FirstEA.First,"\(\)"),Found.1 FirstEA.Replace,,1)
		}if(sc.2202||!sc.2102){
			RegExReplace(String,Delimiter.Delimiter,,Comma),Comma++,sc.2207(0xFF0000),Total:=0,Info:="",Obj:=StrSplit(First,Delimiter.Delimiter)
			for a,b in Obj{
				Start:=StrLen(Info),Info.=b (a=Obj.MaxIndex()?"":Delimiter.Delimiter),End:=StrLen(Info)-1
				if(A_Index=Comma)
					Break
				if(Comma>Obj.MaxIndex())
					Error:=1
				if(InStr(b,"*")){
					Error:=0
					Break
				}
			}if(NoHighlight)
				sc.2207(0xFF0000),(Start:=0),(End:=StrPut(First,"UTF-8")-1)
			else if(Error)
				sc.2207(0x0000FF),(Start:=0),(End:=StrPut(List,"UTF-8")-1)
			else if(Start!=End)
				sc.2207(0xFF0000),Start,End:=(SubStr(First,0)~="(\]|\))"?End:End+1)
			else
				sc.2207(0xFF0000),(Start:=0),(End:=StrPut(First,"UTF-8")-1)
			NewStart:=sc.2008-Start,Sub:=Floor((End-Start)/2)
			if(BracePos){
				BracePos-=StrLen(Word)+1
				if(OPos-BracePos>Sub)
					NewStart-=Sub
				else
					NewStart-=Opos-BracePos
			}else
				NewStart:=NewStart-Sub
			if(NewStart<LineIndent)
				NewStart:=LineIndent
			sc.2200(NewStart,Trim(List,"`n")),sc.2204(Start,End)
		}return SetStatus("Context Completed @ " A_Now A_MSec)
	}else if(sc.2202)
		sc.2201()
	return SetStatus("Context Stopped @ " A_Now A_MSec)
}
ContextMenu(){
	static ONode,Kill,UnRedo:={Undo:2174,Redo:2016}
	sc:=csc(),SetupEnter()
	for a,b in ["RCM","toolbars"]
		Menu,%b%,DeleteAll
	ctrl:=MainWin.NewCtrlPos.ctrl
	MouseGetPos,,,win,ctrl,2
	parent:=DllCall("GetParent",ptr,ctrl)
	if(ctrl+0=MainWin.tnsc.sc)
		node:=MainWin.Gui.SSN("//*[@type='Tracked Notes']")
	else if(!node:=MainWin.Gui.SSN("//*[@hwnd='" ctrl+0 "']")){
		if(!node:=MainWin.Gui.SSN("//*[@toolbar='" ctrl+0 "']")){
			xx:=MainWin.Gui
			Menu,RCM,Add,% "Move to " (Settings.SSN("//options/@Top_Find").text?"Bottom":"Top"),MoveFind
			Menu,RCM,Show
			Menu,RCM,DeleteAll
			return
			MoveFind:
			Options("Top_Find")
			return
	}}ONode:=node,oea:=XML.EA(ONode)
	if(InStr(node.ParentNode.xml,"Tracked_Notes"))
		node:=RCMXML.SSN("//main[@name='Tracked Notes']"),type:="Tracked Notes"
	else
		node:=RCMXML.SSN("//main[@name='" (type:=SSN(node,"@type").text) "']")
	if(oea.type="Project Explorer"){
		current:=Current(3).file
		SplitPath,current,filename
		Menu,RCM,Add,%filename%,deadend
		Menu,RCM,Add
		Menu,RCM,Disable,%filename%
	}all:=SN(node,"descendant::*"),track:=[],count:=MainWin.Gui.SN("//win[@win=1]/descendant::control[@type='Scintilla']").length
	while(aa:=all.item[A_Index-1]),ea:=XML.EA(aa),pea:=XML.EA(parent:=aa.ParentNode){
		if(type=ea.name)
			Continue
		if(aa.NodeName="Separator"){
			Menu,RCM,Add
			Continue
		}else if(aa.ParentNode.NodeName="menu"){
			parent:=XML.EA(aa.ParentNode.ParentNode)
			track[pea.name]:=aa.ParentNode.ParentNode.NodeName="Menu"?parent.name:"RCM"
			Menu,% pea.name,Add,% ea.name,MenuEnd
			Continue
		}else{
			Menu,RCM,Add,% ea.name,MenuEnd
			if(((code:=UnRedo[ea.name])&&!sc[code])||(sc.2008=sc.2009&&ea.name~="Copy|Cut|Delete")||Clipboard=""&&ea.name="Paste"||sc.2143=0&&sc.2145=sc.2006&&ea.name="Select All"||(ea.name="Open Folder"&&Current(2).untitled||!Current(2).file))
				Menu,RCM,Disable,% ea.name
			Disabled:=""
			if(v.Options[Clean(ea.name)])
				Menu,% parent.NodeName="main"?"RCM":pea.name,Check,% ea.name
	}}for a,b in track
		Menu,%b%,Add,%a%,:%a%
	Menu,RCM,Add
	if(oea.type="Toolbar")
		Menu,RCM,Add,Edit Toolbar,EditToolbar
	for a,b in ["Above","Below","Left","Right"]{
		for c,d in ["Project Explorer","Code Explorer","Tracked Notes"]
			if(!MainWin.Gui.SSN("//win[@win=1]/descendant::*[@type='" d "']"))
				Menu,%b%,Add,%d%,RCMSplit
		Menu,%b%,Add,Toolbar,RCMSplit
		Menu,%b%,Add,Scintilla,RCMSplit
		Menu,Split,Add,%b%,:%b%
	}for a,b in ["Project Explorer","Code Explorer","Tracked Notes"]
		if(!MainWin.Gui.SSN("//win[@win=1]/descendant::*[@type='" b "']"))
			Menu,Type,Add,%b%,Type
	if(SSN(ONode,"@type").text!="Scintilla")
		Menu,Type,Add,Scintilla,Type
	list:=Settings.SN("//toolbar/bar")
	Menu,toolbars,Add,New Toolbar,NewToolbar
	Menu,toolbars,Add
	while(ll:=list.item[A_Index-1]),ea:=XML.EA(ll)
		if(!MainWin.Gui.SSN("//win[@win=1]/descendant::*[@id='" ea.id "']"))
			Menu,toolbars,Add,% ea.id,ChangeToolbar
	Menu,Type,Add,Toolbar,:toolbars
	Menu,RCM,Add,Split Control,:Split
	Menu,RCM,Add,Control Type,:Type
	Menu,RCM,Add,Remove Control,RCMRC
	Menu,RCM,Add
	Menu,RCM,Add,Edit Menu,EditRCM
	if(oea.x){
		Menu,Lock,Add,Left,LockControl
		if(oea.ll)
			Menu,Lock,Check,Left
		lock:=1
	}if(oea.y){
		Menu,Lock,Add,Top,LockControl
		if(oea.lt)
			Menu,Lock,Check,Top
		lock:=1
	}if(oea.ra){
		Menu,Lock,Add,Right,LockControl
		if(MainWin.Gui.SSN("//*[@x='" oea.x+oea.w "']/@ll"))
			Menu,Lock,Check,Right
		lock:=1
	}if(oea.ba){
		Menu,Lock,Add,Bottom,LockControl
		if(MainWin.Gui.SSN("//*[@y='" oea.y+oea.h "']/@lt"))
			Menu,Lock,Check,Bottom
		lock:=1
	}
	if(lock)
		Menu,RCM,Add,Lock Control,:Lock
	WinGet,AList,List,ahk_class AutoHotkey
	Loop,%AList%{
		ID:=AList%A_Index%
		WinGetTitle,ATitle,ahk_id%ID%
		if(Trim(SubStr(ATitle,1,InStr(ATitle,"-",0,0,1)-1))=Current(2).file){
			Menu,RCM,Add,Kill Current Script,KillCurrentScript
			Kill:=ID
		}
	}
	ControlFocus,,% "ahk_id" csc().sc
	Menu,RCM,Show
	for a,b in ["Lock","Above","Below","Left","Right","Split","Type"]
		Menu,%b%,DeleteAll
	for a,b in track
		Menu,RCM,Delete,%a%
	Menu,RCM,DeleteAll
	SetupEnter(1)
	return
	EditToolbar:
	Toolbar_Editor(ONode)
	return
	KillCurrentScript:
	PostMessage,0x111,65405,0,,ahk_id%Kill%
	return
	NewToolbar:
	MainWin.Type("Toolbar",Create_Toolbar().ID)
	return
	ChangeToolbar:
	MainWin.Type("Toolbar",A_ThisMenuItem)
	return
	Type:
	MainWin.Type(A_ThisMenuItem)
	return
	EditRCM:
	Right_Click_Menu_Editor(SSN(ONode,"@type").text)
	SetupEnter(1)
	return
	RCMSplit:
	MainWin.Split(A_ThisMenu,A_ThisMenuItem)
	return
	MenuEnd:
	clean:=Clean(A_ThisMenuItem)
	if(IsLabel(clean)||IsFunc(clean))
		SetTimer,%clean%,-1
	else if(v.Options.HasKey(clean))
		Options(clean)
	else if(A_ThisMenuItem="Close Debug Window")
		MainWin.Delete(),debug.Disconnect(),Redraw()
	else if(A_ThisMenuItem="Switch Orientation"){
		ea:=XML.EA(node:=MainWin.Gui.SSN("//win[@win=1]/descendant::*[@type='Tracked Notes']"))
		if(ea.vertical)
			node.RemoveAttribute("vertical")
		else
			node.SetAttribute("vertical",1)
		MainWin.Size(1),Redraw()
	}else if(A_ThisMenuItem="Edit Toolbar"){
		Toolbar_Editor(MainWin.Gui.SSN("//*[@hwnd='" MainWin.NewCtrlPos.ctrl "']"))
	}else if(A_ThisMenuItem="Track File"){
		TNotes.Track()
	}else if(RegExMatch(A_ThisMenuItem,"iO)Copy (.*) Path",found)){
		if(found.1="file")
			Clipboard:=Current(3).file
		if(found.1="folder")
			Clipboard:=Current(3).dir
	}else if(A_ThisMenuItem="Close Project")
		Close()
	else if(A_ThisMenuItem="Backup Notes"){
		TNotes.XML.Save(1)
		FileAppend,% TNotes.XML[],lib\Tracked Notes %A_Now%.xml
		;FileCopy,lib\Tracked Notes.xml,lib\Tracked Notes %A_Now%.xml
	}else if(A_ThisMenuItem="Remove Tracked File"){
		if(TNotes.node.NodeName="master")
			return m("Can not remove the Global Notes"),SetupEnter(1)
		node:=TNotes.node.NodeName="global"?TNotes.node.ParentNode:TNotes.node,extra:=node.NodeName="main"?"`n`nThis will also delete all of the notes for this project!":""
		if(m("This can not be undone!"," Are you sure you want to delete the notes for " SSN(node,"@file").text "?" extra,"btn:ync","ico:!")="Yes"){
			node.ParentNode.RemoveChild(node),TNotes.Populate()
		}
	}else if(A_ThisMenuItem="Contract All"){
		TNotes.sc.2662(0)
	}else if(A_ThisMenuItem="Hide/Show File Extensions")
		Options("Hide_File_Extensions")
	else if(A_ThisMenuItem="Collapse All"){
		Default("SysTreeView322",1)
		while(next:=TV_GetNext(next,"F"))
			TV_Modify(next,"-Expand")
	}else if(A_ThisMenuItem="Expand All"){
		Default("SysTreeView322",1)
		while(next:=TV_GetNext(next,"F"))
			TV_Modify(next,"Expand")
	}else if(A_ThisMenuItem="Select All")
		Send,^a
	else
		m("Coming soon:",A_ThisMenu,A_ThisMenuItem)
	ControlFocus,,% "ahk_id" csc().sc
	SetupEnter(1)
	return
	RCMRC:
	MainWin.Delete(),SetupEnter(1)
	;m("Remove the control :)")
	/*
		I need to add in a way to add toolbars.
	*/
	return
	LockControl:
	all:=A_ThisMenuItem="Left"?MainWin.Gui.SN("//*[@win=1]/descendant::*[@x='" oea.x "']"):A_ThisMenuItem="Right"?MainWin.Gui.SN("//*[@win=1]/descendant::*[@x=" oea.x+oea.w "]"):A_ThisMenuItem="top"?MainWin.Gui.SN("//*[@win=1]/descendant::*[@y=" oea.y "]"):MainWin.Gui.SN("//*[@win=1]/descendant::*[@y=" oea.y+oea.h "]")
	while(aa:=all.item[A_Index-1],ea:=XML.EA(aa)){
		if(A_ThisMenuItem~="Left|Right"){
			if(ea.ll)
				aa.RemoveAttribute("ll")
			else
				aa.SetAttribute("ll",1)
		}
		if(A_ThisMenuItem~="Top|Bottom"){
			if(ea.lt)
				aa.RemoveAttribute("lt")
			else
				aa.SetAttribute("lt",1)
		}
	}
	;m(onode.xml,A_ThisMenuItem)
	return
}
Convert_Hotkey(key){
	StringUpper,key,key
	for a,b in [{Ctrl:"^"},{Win:"#"},{Alt:"!"},{Shift:"+"}]
		for c,d in b
			if(InStr(key,d))
				build.=c "+",key:=RegExReplace(key,"\" d)
	return build key
}
Copy(){
	csc().2178(),Clipboard:=RegExReplace(Clipboard,"\R","`r`n")
}
Create_Toolbar(){
	FormatTime,date,%A_Now%,longdate
	FormatTime,time,%A_Now%,H:mm:ss
	if(!top:=Settings.SSN("//toolbar"))
		top:=Settings.Add("toolbar")
	id:=date " " time "." A_MSec,next:=Settings.Under(top,"bar",{id:id})
	for a,b in [{file:"Shell32.dll",func:"Open",text:"Open",icon:3,id:10000,state:4,vis:1},{file:"Shell32.dll",func:"Run",text:"Run",icon:76,id:11102,state:4,vis:1}]
		Settings.Under(next,"button",b)
	Sleep,1
	return {id:id,node:next}
}
csc(set:=0){
	static Current,last
	if(!set&&Current)
		return Current
	if(set.plugin)
		return Current:=set.plugin
	if(set.hwnd){
		return Current:=s.ctrl[set.hwnd]
	}if(set.set){
		if(Current.sc=MainWin.tnsc.sc){
			if(!last)
				last:=Current:=s.ctrl[MainWin.Gui.SSN("//*[@type='Scintilla']/@hwnd").text]
			else
				Current:=last
		}
		WinSetTitle(1,ea:=files.EA("//*[@sc='" Current.2357 "']"))
		return Current
	}if(set.last){
		last:=Current:=s.ctrl[MainWin.Gui.SSN("//*[@type='Scintilla']/@hwnd").text]
	}
	/*
		Focus:=DllCall("GetFocus")
		t(s.ctrl[Focus].sc,Focus,Current.sc)
	*/
	return Current
}
Current(Parent=""){
	Node:=files.SSN("//*[@tv='" TVC.Selection(1) "']"),id:=SSN(Node,"@id").text,ParentNode:=SSN(Node,"ancestor-or-self::main"),pid:=SSN(ParentNode,"@id").text
	if(Parent=1)
		return ParentNode
	else if(Parent=2)
		return XML.EA(ParentNode)
	else if(Parent=3)
		return XML.EA(Node)
	else if(Parent=4)
		return SSN(Node,"ancestor-or-self::main/file")
	else if(Parent=5)
		return cexml.SSN("//main[@id='" pid "']/descendant::file[@id='" id "']")
	else if(Parent=6)
		return cexml.EA("//main[@id='" pid "']/descendant::file[@id='" id "']")
	else if(Parent=7)
		return SSN(cexml.SSN("//main[@id='" pid "']/descendant::file[@id='" id "']"),"ancestor-or-self::main")
	else if(Parent=8)
		return id
	else if(Parent=9)
		return SSN(cexml.SSN("//main[@id='" pid "']/descendant::file[@id='" id "']"),"ancestor::main/@id").text
	return Node
}
Custom_Version(){
	change:=Settings.SSN("//auto_version").text?Settings.SSN("//auto_version").text:"Version:=" Chr(34) "$v" Chr(34),cc:=InputBox(csc().sc,"Custom auto_version","Enter your custom" Chr(59) "auto_version in the form of Version:=$v",change)
	if(cc)
		Settings.Add("auto_version").text:=cc
}
Cut(){
	;ControlGetFocus,Focus,% hwnd([1])
	;SendMessage,0x300,0,0,%Focus%,% hwnd([1])
	SendMessage,0x300,0,0,,% "ahk_id" csc().sc
	if(v.Options.Clipboard_History){
		for a,b in v.Clipboard
			if(b=Clipboard)
				return
		v.Clipboard.push(Clipboard)
}}
DebugHighlight(){
	sc:=csc(),sc.2045(2),sc.2045(3)
	for a,b in v.DebugHighlight[Current(3).file]{
		sc.2043(b,2)
		if(A_Index=1){
			if(!sc.2228(b)){
				sc.2232(b)
			}
			SelectDebugLine(b)
		}
}}
SelectDebugLine(line){
	sc:=csc()
	if(v.Options.Select_Current_Debug_Line)
		sc.2160(sc.2167(line),sc.2136(line))
	else
		first:=sc.2152,lines:=sc.2370,half:=Floor(lines/2),NewLine:=((((line)-half)>0)?(line)-half:0),sc.2613(NewLine)
}
DebugWindow(text){
	static sc,NewWin
	if(Text.Select!="")
		return sc.2025(Text.Select)
	if(!WinExist("ahk_id" sc.sc)){
		csc:=csc(),NewWin:=new GUIKeep("Debug"),NewWin.Add("s,w400 h200,,wh")
		GuiControl,Debug:+g,% NewWin.sc.1.sc
		NewWin.Show("Debug Window",,1),sc:=NewWin.sc.1,sc.2277(1),csc({hwnd:csc.sc})
	}
	text.="`n"
	sc.2003(sc.2006,text),sc.2025(sc.2006)
	return
}
Default_Project_Folder(){
	FileSelectFolder,directory,,3,% "Current Default Folder: " Settings.SSN("//directory").text
	if(ErrorLevel)
		return
	Settings.Add("directory","",directory)
}
Default(Control:="SysTreeView321",win:=1){
	type:=InStr(Control,"SysTreeView32")?"TreeView":"ListView"
	Gui,%win%:Default
	Gui,%win%:%type%,%control%
}
DefaultFont(Return:=0){
	TempXML:=new XML("TempXML"),top:=Settings.SSN("//*")
	txml=
(
<theme>
<name>Zenburn_dark_with_maestrith</name>
<author>Run1e and maestrith</author>
<caret color='16777215' multi='0x00A5FF' lineback='4473924' width='1' debug='255'/>
<default background='3158064' color='16777215' font='Consolas' size='10' style='5' underline='0'/>
<font style='0' color='12632256'/>
<find/>
<inlinecomment style='1' color='8363903' italic='1' size='10' underline='0'/>
<numbers style='2' color='8421616'/>
<punctuation style='4' color='16777215'/>
<multilinecomment style='11' color='16744576' size='10' underline='0'/>
<completequote style='3' color='8816334'/>
<incompletequote style='13' color='255' background='0'/>
<backtick style='15' color='12110995'/>
<linenumbers style='33' background='3158064' color='16777215' font='Consolas'/>
<bracematch style='34' color='255'/>
<indentguide style='37' color='4227327'/>
<editedmarkers edited='0x0000FF' saved='0x00FF00'/>
<fold background='0xFFFFFF' color='0'/>
<projectexplorer/>
<codeexplorer/>
<font style='40' color='65408'/>
<font style='41' color='16776960'/>
<font style='42' color='0' background='255'/>
<font style='55' color='4227327'/>
<font style='56' color='8421440'/>
<font style='57' color='16744576'/>
<font style='58' color='8388863'/>
<font style='59' color='12615935'/>
<font style='60' color='11184895'/>
<font style='61' color='4737279'/>
<font style='96' color='8388863'/>
<font style='97' color='8388863'/>
<font style='99' color='8388863'/>
<font style='100' color='8388863'/>
<selfore code='2067' color='0' bool='0'/>
<selback code='2068' color='32896' bool='1'/>
<additionalselback code='2601' color='8421504'/>
<keyword set='0' style='16' color='5741559'/>
<keyword set='1' style='17' color='7843024'/>
<keyword set='2' style='18' color='13617276'/>
<keyword set='3' style='19' color='16758590'/>
<keyword set='4' style='20' color='16759366'/>
<keyword set='5' style='21' color='9749720'/>
<keyword set='6' style='22' color='14732901'/>
<keyword set='7' style='23' color='8241367'/>
<keyword set='8' style='24' color='15458669'/>
</theme>
)
	/*
		umm not every language has hex
	*/
	/* 
		MAKE SURE YOU CHECK ALL OF THE @CODES TO MAKE SURE THAT THEY DON'T
		BELONG IN THE MAIN THEME BECAUSE I'D GUESS THAT THEY ALL DO!!!!!!!!!
		ALSO WHEN PACKAGING UP THEMES MAKE SURE TO INCLUDE ALL (OR A LOT)
		OF THE OTHER LANGUAGE COLOR THINGS.
	*/
	TempXML.xml.LoadXML(txml),TempXML.Transform(2),tt:=TempXML.SSN("//*")
	if(Return)
		return TempXML
	if(ahk:=Settings.SSN("//Languages/ahk"))
		ahk.ParentNode.RemoveChild(ahk)
	ahk:=Settings.Add("Languages/ahk"),all:=TempXML.SN("//font")
	while(aa:=all.item[A_Index-1],ea:=XML.EA(aa))
		if(aa.NodeName="font")
			ahk.AppendChild(aa)
	top.AppendChild(tt)
}
DefaultRCM(){
	static all:={Scintilla:"Undo,Redo,Copy,Cut,Paste,Select All,Close,Delete,Open,Open Folder,Omni Search"
		    ,"Tracked Notes":"Track File,Backup Notes,Contract All,Switch Orientation,Remove Tracked File"
		    ,"Project Explorer":"New,Close,Open,Rename Current Include,Remove Include,Copy File Path,Copy Folder Path,Open Folder,Hide/Show Icons,File Icon,Folder Icon,Hide/Show File Extensions,Refresh Project Explorer"
		    ,"Code Explorer":"Refresh Code Explorer,Collapse All"
		    ,Toolbar:"Small Icons"
		    ,Debug:"Close Debug Window"}
	for a,b in ["Scintilla","Code Explorer","Project Explorer","Tracked Notes","Toolbar","Debug"]{
		if(!main:=RCMXML.SSN("//main[@name='" b "']"))
			main:=RCMXML.Add("main",{name:b},,1)
		for c,d in StrSplit(all[b],","){
			if(!SSN(main,"menu[@name='" d "']"))
				RCMXML.Under(main,"menu",{name:d})
		}
	}
}
Delete_Line(){
	sc:=csc(),line:=sc.2166(sc.2008),pos:=sc.2128(line),diff:=sc.2008-pos,sc.2338(),start:=sc.2128(line),end:=sc.2136(line),sc.2025(diff<=end-start?start+diff:end)
}
Delete_Matching_Brace(){
	sc:=csc(),value:=[],cpos:=sc.2008
	GuiControl,1:+g,% sc.sc
	if((Match:=sc.2353(cpos-1))>=0)
		value[Match]:=1,value[cpos-1]:=1
	else if((Match:=sc.2353(cpos))>=0)
		value[Match]:=1,value[cpos]:=1
	max:=value.MaxIndex(),min:=value.MinIndex()
	if(v.braceend&&v.bracestart){
		sc.2078(),minline:=sc.2166(min),maxline:=sc.2166(max),sc.2645(max,1),sc.2645(min,1)
		if(minline!=maxline)
			if(sc.2128(maxline)=sc.2136(maxline))
				max:=sc.2136(maxline-1),sc.2645(max,sc.2128(maxline)-max),max++
		sc.2160(min,max-1),sc.2079()
	}
	GuiControl,1:+gnotify,% sc.sc
}
Delete_Project(x:=0){
	project:=Current(2).file
	if(Current(2).file=A_ScriptFullPath)
		return m("That may not be wise")
	if(x=0)
		MsgBox,292,Are you sure?,This process can not be undone!`nDelete %project% and all its backups
	IfMsgBox,No
		return
	filelist:=[],all:=SN(Current(1),"descendant-or-self::file")
	while(aa:=all.item[A_Index-1]),ea:=XML.EA(aa)
		filelist[ea.filename]:=ea
	Close(0)
	for a,b in filelist
		Loop,Files,% b.dir "\" b.filename,FR
		{
			left:=0
			FileDelete,%A_LoopFileLongPath%
			FileRemoveDir,%A_LoopFileDir%
			t("Deleting: " A_LoopFileLongPath,"Please Wait...")
		}
	t()
	return
}
Delete(){
	return Backspace(0)
}
DisplayType(type){
	all:=SN(cexml.Find("//main/@file",Current(2).file),"descendant-or-self::info[@type='" type "']/@text"),sc:=csc(),word:=sc.getword(),sc.2634(1)
	while,aa:=all.item[A_Index-1]
		if(aa.text~="i)^" word)
			list.=aa.text " "
	Sort,list,list,D%A_Space%
	if((list:=Trim(list))="")
		return 0
	sc.2117((type="Function"?5:8),list)
	if(!InStr(list," "))
		sc.2104
}
Display_Functions(){
	if(DisplayType("Function")=0)
		DisplayType("Class")
}
Display_Classes(){
	if(DisplayType("Class")=0)
		DisplayType("Function")
}
Display_Hotkeys(){
	all:=menus.SN("//*[@hotkey!='']"),newwin:=new GUIKeep("hotkeys"),newwin.Add("ListView,w400 h600,Action|Hotkey,wh")
	while(aa:=all.item[A_Index-1]),ea:=XML.EA(aa)
		LV_Add("",ea.clean,Convert_Hotkey(ea.hotkey))
	Loop,2
		LV_ModifyCol(A_Index,"AutoHDR")
	newwin.Show("Hotkeys"),LV_ModifyCol(1,"Sort")
}
Display(PopulateVarBrowser:=0){
	/*
		if a script has OutputDebug and it is just ran rather than debugged{
			make it run through here but disable the Breakpoints and auto-run it
			don't send all the BS for feature_set and such and don't show the stdout and stderr info just open the debug pannel
			
		}
	*/
	static receive:=new XML("receive"),total,width,addhotkey,lastid,StoreXML:=[],c:=[],ProcessProperties:=[],scope
	store:="",sc:=v.debug,xx:=debug.xml
	while(store:=v.displaymsg.Pop()){
		receive.XML.LoadXML(store),rea:=XML.EA(info:=receive.SSN("//*"))
		if(v.Options.Verbose_Debug_Window)
			receive.Transform(),receive.Transform(),DebugWindow(receive[]),t()
		if(info.NodeName="stream"){
			info:=debug.decode(info.text),total.=info "`n",in:=StripError(info,debug.filename)
			if(in.line&&in.file)
				sc.2003(sc.2006,info "`n"),sc.2025(sc.2006),SetPos({file:in.file,line:in.line}),PluginClass.CallTip(info),debug.Disconnect()
			else
				sc.2003(sc.2006,info "`n"),sc.2025(sc.2006)
			return
		}if(rea.command="breakpoint_set"){
			if(rea.state="enabled"&&debug.AfterDebug)
				split:=StrSplit(rea.transaction_id,"|"),debug.Breakpoints[split.1]:={line:split.2,id:rea.id},sc:=v.debug,sc.2003(sc.2006,"Breakpoint Added for file: " files.SSN("//*[@id='" split.1 "']/@filename").text " on line: " split.2 "`n"),sc.2025(sc.2006)
		}if(rea.command="breakpoint_remove"){
			sc:=v.debug,sc.2003(sc.2006,"Breakpoint Removed`n"),sc.2025(sc.2006)
		}if(info.NodeName="init"){
			v.afterbug:=[],ad:=["stdout -c 1","stderr -c 1","feature_set -n max_depth -v 0","feature_set -n max_children -v 0"],bp:=cexml.SN("//*[@id='" debug.id "']/descendant::info[@type='Breakpoint']")
			while,bb:=bp.item[A_Index-1],bpea:=XML.EA(bb)
				ad.Insert("breakpoint_set -t line -f " bpea.filename " -n" bpea.line+1 " -i " SSN(bb,"ancestor::file/@id").text "|" bpea.line)
			for a,b in ad
				v.afterbug.Insert(b)
			SetTimer,AfterDebug,-300
		}if(rea.status="stopped"){
			sc:=csc(),sc.2045(2),sc.2045(3),sc:=v.debug,sc.2003(sc.2006,"Execution Complete"),sc.2025(sc.2006),debug.Caret(0)
			SetTimer,VarBrowserStop,-1
			return
		}if(rea.status="break"){
			debug.Send("stack_get")
			SetTimer,InsertDebugMessage,-200
		}if(rea.command="stack_get"){
			sc:=csc(),stack:=receive.SN("//stack"),exist:=0,v.DebugHighlight:=[]
			while(ss:=stack.item[A_Index-1]),ea:=XML.EA(ss){
				filename:=RegExReplace(RegExReplace(URIDecode(ea.filename),"file:\/\/\/"),"\/","\")
				if(!IsObject(obj:=v.DebugHighlight[filename]))
					obj:=v.DebugHighlight[filename]:=[]
				obj.push(ea.lineno-1)
				if(FileExist(filename)&&exist=0){
					if(filename!=Current(3).file)
						tv(SSN(files.Find("//file/@file",filename),"@tv").text)
					file:=ea.filename,scope:=ea.where="Auto-execute thread"?"Global":ea.where,xx.Add("master",{scope:scope}),exist:=1,v.DebugLineNumber:=ea.lineno-1,v.CurrentScope:=scope
					if(WinExist(debugwin.id)){
						WinSetTitle,% debugwin.id,,% "Variable Browser : Current Scope = " ea.where
						scope:=receive.SN("//descendant::stack"),Default("SysListView321",98),LV_Delete()
						/*
							GuiControl,98:-Redraw,SysListView321
						*/
						while(ss:=scope.item[A_Index-1]),ea:=XML.EA(ss){
							if(A_Index=1){
								Default()
								if(Node:=files.SSN("//*[@lower='" Format("{:L}",Filename) "']")){
									if((tv:=SSN(Node,"@tv").text)&&tv!=TV_GetSelection())
										tv(tv)
								}
							}
							LV_Add("",ea.where,"|" filename "|",ea.lineno)
						}
						Loop,3
							LV_ModifyCol(A_Index,"AutoHDR")
						/*
							GuiControl,98:+Redraw,SysListView321
						*/
			}}}DebugHighlight(),debug.Send("context_names -i Context_Names"),sc:=v.debug,debug.Focus()
		}else if(rea.command="context_names"){
			context:=receive.SN("//context")
			while(cc:=context.item[A_Index-1]),ea:=XML.EA(cc){
				if(!xx.SSN("//scope[@id='" ea.id "']"))
					xx.Add("scope",ea,,1)
				Sleep,100
				debug.Send("context_get -c " ea.id " -i " (ea.id=0?xx.SSN("//master/@scope").text:(ea.fullname?ea.fullname:ea.name)))
		}}else if(rea.command="context_get"){
			all:=SN(info,"descendant-or-self::property"),pea:=XML.EA(info),xx:=debug.xml,master:=xx.SSN("//scope[@id='" pea.context "']"),scope:=xx.SSN("//master/@scope").text
			while(aa:=all.item[A_Index-1]),ea:=XML.EA(aa){
				if(pea.context!=1){ ;this needs the braces.
					if(!main:=SSN(master,"descendant::scope[@name='" pea.transaction_id "']"))
						main:=xx.Under(master,"scope",{name:pea.transaction_id,fullname:pea.transaction_id})
				}else
					main:=master
				if(!top:=SSN(main,"descendant::property[@fullname='" ea.fullname "']"))
					top:=main.AppendChild(aa.CloneNode(0)),top.SetAttribute("new",1)
				else{
					for a,b in ea
						top.SetAttribute(a,b)
					top.SetAttribute("updated",1)
				}
				if(!SSN(aa,"descendant::*")){
					if(text:=debug.Decode(aa.text))
						top.text:=text
				}
			}
			/*
				this is where the thing in the Tracked Notes needs to be done
			*/
			if((exp:=SN(main,"descendant::*[@expanded=1]")).length){
				SetTimer,ScanChildren,-20
			}else
				SetTimer,ProcessDebugXML,-100
		}else if(rea.command="property_get"){
			master:=xx.SSN("//*[@transaction='" rea.transaction_id "']"),Properties:=receive.SN("//descendant::property")
			while(pp:=Properties.item[A_Index-1]),ea:=XML.EA(pp){
				if(pp.NodeName="scope")
					Continue
				if(!top:=SSN(master,"descendant-or-self::*[@fullname='" ea.fullname "']"))
					top:=SSN(master,"descendant-or-self::*[@fullname='" SSN(pp.ParentNode,"@fullname").text "']"),top:=top.AppendChild(pp.CloneNode(0))
				else{
					tea:=XML.EA(top)
					for a,b in ea{
						if(a!="name")
							top.SetAttribute(a,b)
						top.SetAttribute("updated",1)
				}}if(!ea.children)
					top.text:=debug.Decode(pp.text)
			}
		}
	}
	return
	AfterDebug:
	while(info:=v.afterbug.pop())
		debug.Send(info)
	InsertDebugMessage(),v.ready:=1,debug.Focus(),debug.Caret(1),debug.AfterDebug:=1
	return
	GetContextInfo:
	debug.Send("stack_get")
	return
}
DisplayStats(call){
	static lastxml,lastfunc
	ControlGetPos,x,y,w,h,,% "ahk_id" MainWin.gui.SSN("//*[@type='Toolbar']/@hwnd").text
	MainWin.Gui.Transform()
	WinGet,cl,ControlList,% MainWin.ID
	(sc:=s.ctrl[MainWin.Gui.SSN("//win[@win='Tracked_Notes']/descendant::control[@type='Scintilla']/@hwnd").text]).2181(0,call "`n`n" MainWin.Gui[] "`n" lastfunc "`n`n" lastxml)
	lastxml:=MainWin.Gui[],lastfunc:=call
	MarginWidth()
	return
}
Dlg_Color(Node,Default:="",hwnd:="",Attribute:="color"){
	static
	Node:=Node.xml?Node:Settings.Add(Trim(Node,"/")),Default:=Default?Default:Settings.SSN("//default"),Color:=(((Color:=SSN(Node,"@" Attribute).text)!="")?Color:SSN(Default,"@" Attribute).text)
	if(Settings.SSN("//colorinput").text){
		Color:=InputBox(sc,"Color Code","Input Your Color Code In RGB (0xFFFFFF or FFFFFF)",RGB(Color))
		if(!InStr(Color,"0x"))
			Color:="0x" Color
		return Node.SetAttribute(Attribute,Color)
	}VarSetCapacity(Custom,16*4,0),size:=VarSetCapacity(ChooseColor,9*4,0)
	for a,b in Settings.EA("//CustomColors")
		NumPut(Round(b),Custom,(A_Index-1)*4,"UInt")
	NumPut(size,ChooseColor,0,"UInt"),NumPut(hwnd,ChooseColor,4,"UPtr"),NumPut(Color,ChooseColor,3*4,"UInt"),NumPut(3,ChooseColor,5*4,"UInt"),NumPut(&Custom,ChooseColor,4*4,"UPtr")
	ret:=DllCall("comdlg32\ChooseColorW","UPtr",&ChooseColor,"UInt")
	CustomColors:=Settings.Add("CustomColors")
	Loop,16
		CustomColors.SetAttribute("Color" A_Index,NumGet(Custom,(A_Index-1)*4,"UInt"))
	if(!ret)
		Exit
	Node.SetAttribute(Attribute,(Color:=NumGet(ChooseColor,3*4,"UInt")))
	if(!Node.xml)
		m("Bottom of Dlg_Color()",Node.xml,Color)
	return Color
}
Dlg_Font(Node,DefaultNode:="//theme/default",window="",Effects=1){
	static Remove:={bold:1,color:1,font:1,italic:1,size:1,strikeout:1,underline:1}
	Node:=Node.xml?Node:Settings.Add(Trim(Node,"/")),Default:=Settings.EA(DefaultNode),DefaultClone:=Default.Clone(),Style:=XML.EA(Node)
	for a,b in Style
		if(Remove[a])
			Default[a]:=b,Node.RemoveAttribute(a)
	Style:=Default,VarSetCapacity(LogFont,60,0),StrPut(Style.font,&LogFont+28,32,"CP0"),LogPixels:=DllCall("GetDeviceCaps","uint",DllCall("GetDC","uint",0),"uint",90),Effects:=0x041+(Effects?0x100:0)
	for a,b in font:={16:"bold",20:"italic",21:"underline",22:"strikeout"}
		if(Style[b])
			NumPut(b="bold"?700:1,LogFont,a)
	Style.size?NumPut(Floor(Style.size*LogPixels/72),LogFont,0):NumPut(16,LogFont,0),VarSetCapacity(ChooseFont,60,0),NumPut(60,ChooseFont,0),NumPut(&LogFont,ChooseFont,12),NumPut(Effects,ChooseFont,20),NumPut(Style.color,ChooseFont,24),NumPut(window,ChooseFont,4)
	if(!r:=DllCall("comdlg32\ChooseFontA","uint",&ChooseFont))
		Exit
	Color:=NumGet(ChooseFont,24),Style:={size:((Size:=NumGet(ChooseFont,16)//10)>4?Size:4),font:StrGet(&LogFont+28,"CP0"),color:color,bold:NumGet(LogFont,16)>=700?1:0}
	for a,b in font{
		if((Value:=NumGet(LogFont,a,"UChar")?1:0)&&b!="bold")
			Style[b]:=Value
		else if(b="bold"&&!Style.Bold)
			Style.Delete("bold")
	}for a,b in Style
		if(DefaultClone[a]!=b||Node.NodeName="Default")
			Node.SetAttribute(a,b)
	return Node
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
	DllCall("InetCpl.cpl\ClearMyTracksByProcess",uint,8)
	SplashTextOn,,,Downloading Plugin List,Please Wait...
	Run,RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 8
	plug:=new xml("plugins"),plug.XML.loadxml(URLDownloadToVar("https://raw.githubusercontent.com/maestrith/AHK-Studio-Plugins/master/Index.xml"))
	SplashTextOff
	if(!plug[])
		return m("There was an error downloading the plugin list.  Please try again later")
	newwin:=new GUIKeep(35)
	Gui,35:Margin,0,0
	newwin.Add("ListView,w500 h300 Checked,Name|Author|Description|Installed,wh","Button,gdpdl,&Download Checked,y","Button,x+0 gdpsa,Select &All,y","Button,x+0 gdprem,Remove Checked,y"),newwin.show("Download Plugins")
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
		LV_GetText(name,num),pos:=1,text:=RegExReplace(URLDownloadToVar("https://raw.githubusercontent.com/maestrith/AHK-Studio-Plugins/master/" name ".ahk"),"\R","`r`n"),list:=""
		date:=plug.SSN("//*[@name='" name "']/@date").text,pos:=1
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
	m("Installation Report:",RegExReplace(pluglist,"\R"," - "))
	goto,dppop
	return
	35GuiEscape:
	35GuiClose:
	hwnd({rem:35})
	return
	dppop:
	Gui,35:Default
	LV_Delete(),pgn:=plug.SN("//plugin")
	while,pp:=pgn.item[A_Index-1],ea:=XML.EA(pp){
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
	static LastSearch
	sc:=csc(),sc.2500(3),sc.2505(0,sc.2006),dup:=[],search:=sc.TextRange((start:=sc.2143),(end:=sc.2145)),v.lastsearch:=search,v.selectedduplicates:=""
	if(end-start<2)
		return
	sc.2686(0,sc.2006),sc.2500(3),sc.2198(v.Options.Match_Any_Word?0:0x2),len:=StrPut(search,"UTF-8")-1,obj:=v.duplicateselect[sc.2357]:=[],count:=0
	while(found:=sc.2197(len,[search]))>=0
		sc.2686(found+1,sc.2006),obj[found]:=len,count++
	if(count>1)
		for a,b in obj
			sc.2504(a,len)
}
DynaRun(Script,Wait:=true,name:="Untitled"){
	static exec,started,filename
	filename:=name,MainWin.Size(),exec.Terminate()
	if(!InStr(Script,"m(x*){"))
		Script.="`n" "m(x*){`nfor a,b in x`nlist.=b " cr "`nMsgBox,,AHK Studio,% list`n}"
	if(!InStr(Script,"t(x*){"))
		Script.="`n" "t(x*){`nfor a,b in x`nlist.=b " cr "`nToolTip,% list`n}"
	shell:=ComObjCreate("WScript.Shell"),exec:=shell.Exec("AutoHotkey.exe /ErrorStdOut *"),exec.StdIn.Write(Script),exec.StdIn.Close(),started:=A_Now
	SetTimer,CheckForError,120
	return
	CheckForError:
	Process,Exist,% exec.ProcessID
	if(!ErrorLevel){
		if(text:=exec.StdERR.ReadAll()){
			if(!v.debug.sc)
				MainWin.DebugWindow()
			v.debug.2003(v.debug.2006,"`nScript Exited, ExitCode: " exec.ExitCode "`n" text)
		}else
			SetStatus("Script Exited, ExitCode: " exec.ExitCode,3)
		SetTimer,CheckForError,Off
		return 1
	}
	SetStatus(filename " running. Run-Time: " A_Now-started " Seconds",3)
	return
}
Edit_Comment_Insert(){
	InputBox,comment,Enter a new comment insert,Enter your new comment insert,,,,,,,,% Settings.Get("//comment",";")
	if(ErrorLevel)
		return
	Settings.Add("comment",{"xml:space":"preserve"},comment)
}
Edit_Hotkeys(ret:=""){
	static newwin
	if(ret.NodeName)
		return ea:=XML.EA(ret),Default("SysTreeView321","Edit_Hotkeys"),TV_Modify(TV_GetSelection(),"",RegExReplace(ea.clean,"_"," ")(ea.hotkey?" - " Convert_Hotkey(ea.hotkey):""))
	newwin:=new GUIKeep("Edit_Hotkeys"),newwin.Add("ComboBox,w400 gehfind vfind,,w","TreeView,w400 h400,,wh","Button,gehgo Default,Change Hotkey,y"),all:=menus.SN("//main/descendant::*")
	while,aa:=all.item[A_Index-1],ea:=XML.EA(aa)
		if(aa.NodeName="menu")
			list.=RegExReplace(ea.clean,"_"," ") "|",aa.SetAttribute("tv",TV_Add(RegExReplace(ea.clean,"_"," ") (ea.hotkey?" - Hotkey - " Convert_Hotkey(ea.hotkey):""),SSN(aa.ParentNode,"@tv").text))
	GuiControl,Edit_Hotkeys:,ComboBox1,%list%
	newwin.show("Edit Hotkeys"),TV_Modify(TV_GetChild(0),"Select Vis Focus")
	Gui,1:+Disabled
	return
	ehfind:
	value:=newwin[].find
	if(tv:=menus.SSN("//*[@clean='" RegExReplace(value," ","_") "']/@tv").text)
		TV_Modify(tv,"Select Vis Focus")
	return
	Edit_HotkeysEscape:
	Edit_HotkeysClose:
	all:=menus.SN("//menu/@tv")
	while,aa:=all.item[A_Index-1]
		aa.RemoveAttribute("tv")
	hwnd({rem:"Edit_Hotkeys"}),Hotkeys()
	SetTimer,RefreshMenu,-1
	return
	ehgo:
	node:=menus.SSN("//*[@tv='" TV_GetSelection() "']")
	if(node.HasChildNodes())
		return m("Please select a menu item not a parent menu")
	EditHotkey(node,"Edit_Hotkeys")
	return
}
EditHotkey(node,window){
	static nw,editnode,win,Control
	MenuWipe(),editnode:=node,win:=window,nw:=new GUIKeep("Edit_Hotkey"),nw.Add("Hotkey,w240 vhotkey gEditHotkey","Edit,w240 vedit gCustomHotkey","ListView,w240 h220,Duplicate Hotkey Definitions","Button,gEHSet Default,Set Hotkey,y"),nw.show("Edit Hotkey")
	GuiControl,Edit_Hotkey:,msctls_hotkey321,% SSN(node,"@hotkey").text
	return
	EditHotkey:
	info:=nw[],hotkey:=info.hotkey,edit:=info.edit,LV_Delete()
	StringUpper,uhotkey,hotkey
	if(dup:=menus.SN("//*[(@hotkey='" hotkey "' or @hotkey='" uhotkey "')and(@clean!='" SSN(editnode,"@clean").text "')]"))
		while,dd:=dup.item[A_Index-1],ea:=XML.EA(dd)
			LV_Add("",ea.clean)
	return
	CustomHotkey:
	GuiControl,Edit_Hotkey:,msctls_hotkey321,% nw[].Edit
	return
	EHSet:
	info:=nw[],hotkey:=info.hotkey,edit:=info.edit
	if(!hotkey&&edit){
		Try
			hotkey,% edit,deadend,On
		Catch
			return m("This does not appear to be a valid hotkey")
		hotkey,%edit%,deadend,Off
	}hotkey:=hotkey?hotkey:edit
	StringUpper,uhotkey,hotkey
	if(!hotkey)
		return hwnd({rem:"Edit_Hotkey"}),editnode.RemoveAttribute("hotkey"),%win%(editnode),WinActivate(hwnd([win]))
	dup:=menus.SN("//*[(@hotkey='" hotkey "' or @hotkey='" uhotkey "')and(@clean!='" SSN(editnode,"@clean").text "')]")
	if(dup.length){
		list:=""
		while,dd:=dup.item[A_Index-1],ea:=XML.EA(dd)
			list.=ea.clean "`n"
		if(m("This hotkey already exists for:" list "Replace?","btn:ync")="yes"){
			while,dd:=dup.item[A_Index-1]
				dd.RemoveAttribute("hotkey")
		}else
			return
	}editnode.SetAttribute("hotkey",uhotkey)
	Edit_HotkeyEscape:
	Edit_HotkeyClose:
	KeyWait,Escape,U
	hwnd({rem:"Edit_Hotkey"}),Hotkeys(1),%win%(editnode),WinActivate(hwnd([win]))
	return
}
Edit_Proxy_Server(){
	node:=Settings.Add("proxy")
	InputBox,proxy,Proxy Server,Please enter your proxy server address,,,,,,,,% node.text
	if(ErrorLevel)
		return
	node.text:=proxy
}
Edit_Replacements(){
	new SettingsClass("Edit Replacements")
}
Edited(current:=""){
	static Edited
	current:=current?current:Current(),sc:=csc()
	if(MainWin.tnsc.sc=sc.sc)
		return TNotes.Write()
	if(!files.SSN("//*[@sc='" sc.2357 "']"))
		return
	if(!SSN(current,"@edited")){
		current.SetAttribute("edited",1),ea:=XML.EA(current),all:=files.SN("//*[@id='" ea.id "']"),WinSetTitle(1,ea)
		while(aa:=all.item[A_Index-1]),nea:=XML.EA(aa)
			TVC.Modify(1,(v.Options.Hide_File_Extensions?"*" nea.nne:"*" nea.filename),nea.tv)
	}list:=files.SN("//*[@edited]"),items:="",WinSetTitle()
	while(ll:=list.item[A_Index-1],ea:=XML.EA(ll))
		items.=ea.file "`n"
}
Enable(Control,label:="",win:=1){
	value:=label?"+":"-"
	Gui,%win%:Default
	GuiControl,%win%:%value%Redraw,%Control%
	GuiControl,%win%:+g%label%,%Control%
}
Encode(tt,ByRef text,encoding:="UTF-8"){
	len:=VarSetCapacity(text,(StrPut(tt,encoding)*((encoding="utf-16"||encoding="cp1200")?2:1))),StrPut(tt,&text,len,"UTF-8")
	return len-1
}
Enter(){
	static map:=new XML("map"),NotIndent:={IfEqual:1,IfNotEqual:1,IfGreater:1,IfGreaterOrEqual:1,IfLess:1,IfLessOrEqual:1,IfInString:1}
	ControlGetFocus,Focus,% hwnd([1])
	checkqf:
	sc:=csc(),fixlines:=[],ind:=Settings.Get("//tab",5),ShowOSD(GetKeyState("Shift","P")?"Shift+Enter":"Enter")
	if(InStr(focus,"scintilla")){
		if(sc.2202)
			sc.2201
		if(sc.2102)
			return sc.2104(),sc.Enable(1)
		SetTimer,Scan_Line,-100
		root:=map.SSN("//*")
		if(sc.2570=1&&GetKeyState("Shift","P")){
			if(v.Options.Full_Auto_Indentation)
				FixIndentArea()
			if(sc.2007(sc.2008)!=125&&sc.2007(sc.2008-1)!=123)
				return Replace()
		}order:=[],sc.2078,group:=0,sc.Enable(),Edited()
		Loop,% sc.2570{
			cpos:=sc.2585(A_Index-1),line:=sc.2166(cpos),end:=sc.2587(A_Index-1),LineStatus.Add(line,2)
			if(cpos!=end)
				sc.2645(cpos,end-cpos)
			if(A_Index>1&&(line+1!=last&&line-1!=last))
				group++
			start:=sc.2128(line),skip:=0
			if(cpos=sc.2136(line)||sc.2007(cpos-1)=123)
				skip:=0
			else{
				sc.2686(cpos,sc.2128(line))
				if((brace:=sc.2197(1,"{"))>=0)
					skip:=sc.2166(sc.2353(brace))!=line?0:1
				else
					skip:=1
			}new:=map.Add("line",{skip:skip,line:line,between:sc.2007(cpos)=125&&sc.2007(cpos-1)=123,group:group,pos:cpos,caret:A_Index-1},"",1),order[line]:=new,last:=line
		}rev:=[]
		for a,b in order
			rev.InsertAt(1,b)
		for a,b in rev
			root.AppendChild(b)
		all:=map.SN("descendant::*[@line]"),add:=0,state:=GetKeyState("Shift","P"),IndentRegex:=Keywords.IndentRegex[Current(3).ext]
		while(aa:=all.item[A_Index-1],ea:=XML.EA(aa)){
			if(!state){
				if(ea.between)
					InsertMultiple(ea.caret,ea.pos,"`n`n",ea.pos+1),indent:=sc.2127(ea.line),sc.2126(ea.line+1,indent+ind),sc.2126(ea.line+2,indent),GoToPos(ea.caret,sc.2128(ea.line+1))
				else{
					InsertMultiple(ea.caret,ea.pos,"`n",ea.pos+1),oindent:=indent:=sc.2127(ea.line),prevtext:=RemoveComment(sc.GetLine(ea.line-1)),text:=RemoveComment(sc.GetLine(ea.line))
					if(SubStr(text,0,1)="{"||sc.2223(ea.line)&0x2000)
						indent+=ind
					else if(RegExMatch(text,"iA)(}|\s)*#?\b(" IndentRegex ")\b",string)){
						if(NotIndent[string2])
							indent:=indent
						else
							indent+=ind
					}else if(RegExMatch(prevtext,"iA)(}|\s)*#?\b(" IndentRegex ")\b",string)&&SubStr(prevtext,0,1)!="{"){
						indent:=sc.2127(ea.line-1)
					}if(ea.skip)
						indent:=oindent
					sc.2126(ea.line+1,indent),GoToPos(ea.caret,sc.2128(ea.line+1))
			}}else if(state){
				if(ea.group!=lastgroup&&lastgroup!=""){
					sea:=map.EA("//*[@fix]")
					FixLines(sc.2166(sea.pos),sc.2166(sc.2353(sea.pos-1))-sc.2166(sea.pos))
					map.SSN("//*[@fix]").RemoveAttribute("fix")
				}if(ea.between){
					lea:=XML.EA(map.SSN("//*[@group='" ea.group "']"))
					nextline:=SSN(map.SSN("//*[@group='" ea.group "']"),"@line").text+1<=sc.2154?1:0
					sc.2645(ea.pos,1)
					end:=sc.2136(lea.line+nextline)
					if(sc.2007(end-1)=123){
						end:=sc.2353(end-1)+1
						if(sc.GetLine(sc.2166(end))~="i)(\}|\s)*(else|if)")
							end:=sc.2128(sc.2166(end)),InsertMultiple(ea.caret,end,"}",ea.pos)
						else
							end:=sc.2128(sc.2166(end)),InsertMultiple(ea.caret,end,"}",ea.pos)
					}else if(sc.GetLine(sc.2166(end)+1)~="i)(\}|\s)*(else|if)")
						end:=sc.2128(sc.2166(end)+1),InsertMultiple(ea.caret,end,"}",ea.pos)
					else
						InsertMultiple(ea.caret,end,"`n}",ea.pos)
					fix:=map.SN("//*[@group='" ea.group "']"),fix.item[fix.length-1].SetAttribute("fix",1)
			}}lastgroup:=ea.group
		}all:=map.SN("//*[@fix]")
		while(aa:=all.item[A_Index-1]),ea:=XML.EA(aa)
			FixLines(sc.2166(ea.pos),sc.2166(sc.2353(ea.pos-1))-sc.2166(ea.pos))
		sc.2079
	}else if(focus="Edit1")
		QF("Enter")
	all:=map.SN("descendant::*[@line]")
	while(aa:=all.item[A_Index-1])
		aa.ParentNode.RemoveChild(aa)
	return sc.2169,MarginWidth(sc),sc.Enable(1)
}
Escape(a*){
	sc:=csc(),ShowOSD("Escape")
	ControlGetFocus,Focus,% hwnd([1])
	if(!InStr(Focus,"scintilla")){
		hwnd:=DllCall("GetFocus")
		;m(hwnd " - " MainWin.FindEdit,"OR!",hwnd " - " MainWin.FindTV,Focus,"Won't have values just yet")
		if(hwnd=MainWin.FindCheck||hwnd=MainWin.FindTV)
			return
		selections:=[],main:=sc.2575
		Loop,% sc.2570()
			selections.Push([sc.2577(A_Index-1),sc.2579(A_Index-1)])
		sc.2400(),sc.2571()
		Sleep,0
		for a,b in selections
			(A_Index=1)?sc.2160(b.2,b.1):sc.2573(b.1,b.2)
		sc.2574(main),CenterSel()
	}v.DisableContext:=sc.2166(sc.2008),sc.2201
	if(InStr(Focus,"Scintilla"))
		Send,{Escape}
	DllCall("EndMenu"),UpPos(1)
}
ExecScript(){
	static exec,time,script
	shell:=ComObjCreate("WScript.Shell"),file:=Current(2).file
	v.RunObject[Current(2).file].exec.Terminate()
	SplitPath,file,,dir
	SetWorkingDir,%dir%
	SplitPath,A_AhkPath,,AHKDir
	exec:=shell.Exec(AHKDir "\AutoHotkey.exe /ErrorStdOut " Chr(34) Current(2).file Chr(34))
	SetWorkingDir,%A_ScriptDir%
	v.exec:=exec,v.RunObject[Current(2).file]:={exec:exec,time:A_Now}
	Sleep,100
	if(v.Exec.Status=0){
		Sleep,100
		Process,Exist,% v.exec.ProcessID
		if(!ErrorLevel)
			return
		if(WinExist("ahk_pid" v.exec.ProcessID)){
			WinGetText,text,% "ahk_pid" v.exec.ProcessID
			info:=StripError(text,Current(2).text)
			if(info.line!=""){
				v.exec.Terminate(),sc:=csc()
				if(info.file!=Current(2).file)
					tv(SSN(files.Find(Current(1),"descendant::file/@file",info.file),"@tv").text)
				sc.2160(sc.2128(info.line),sc.2136(info.line)),sc.2200(sc.2128(info.line),text)
				return
	}}}else if(text:=v.exec.StdERR.ReadAll()){
		if(InStr(text,"cannot be opened"))
			return m(text,"","If the script file is located in the same directory as the main Project try adding #Include %A_ScriptDir% to the main Project file.")
		exec.Terminate(),sc:=csc(),info:=StripError(text,"*"),tv(SSN(files.Find(Current(1),"descendant::file/@file",info.file),"@tv").text),line:=info.line
		Sleep,100
		sc.2160(sc.2128(line),sc.2136(line)),sc.2200(sc.2128(line),text)
	}
}
Exit(ExitApp:=0){
	GuiClose:
	Save(3)
	WinGet,mm,MinMax,% MainWin.ID
	node:=MainWin.Gui.SSN("//win[@win=1]"),fn:=MainWin.Gui.SN("//win[@win=1]/descendant::*[@type='Scintilla']")
	while(ff:=fn.item[A_Index-1]),ea:=XML.EA(ff){
		sc:=s.ctrl[ea.hwnd],doc:=sc.2357
		if(filename:=files.SSN("//*[@sc='" doc "']/@file").text)
			if(filename!="untitled.ahk")
				ff.SetAttribute("file",filename)
	}all:=files.SN("//open/*"),sc:=csc()
	while(aa:=all.item[A_Index-1])
		aa.ParentNode.RemoveChild(aa)
	open:=files.SN("//main"),top:=Settings.Add("open")
	if(!GNode:=Settings.SSN("//gui"))
		GNode:=Settings.Add("gui")
	GNode.SetAttribute("zoom",sc.2374)
	while(oo:=open.item[A_Index-1]),ea:=XML.EA(oo)
		if(!Settings.Find("//open/file",ea.file)&&ea.file!="Libraries"&&!ea.untitled)
			Settings.Under(top,"file",,ea.file)
	if(mm=1)
		node.SetAttribute("max",1)
	else
		node.RemoveAttribute("max")
	list:=TNotes.XML.SN("//master|//main|//global|//file"),temp:=new XML("Tracked_Notes","lib\Tracked Notes.xml")
	while(ll:=list.item[A_Index-1]),ea:=XML.EA(ll){
		if(!ll.text&&temp.SSN("//*[@id='" ea.id "']").text){
			FileCopy,lib\Tracked Notes.xml,lib\Tracked Notes%A_Now%.xml
			Break
		}
	}
	last:=MainWin.Gui.SN("//*[@last]")
	WinGet,max,MinMax,% hwnd([1])
	if(max!=1){
		pos:=MainWin.WinPos().text
		if(!InStr(pos,"-32000"))
			node.SetAttribute("pos",pos)
	}while(ll:=last.item[A_Index-1])
		ll.RemoveAttribute("last")
	RCMXML.Save(1),MainWin.Gui.SSN("//*[@hwnd='" csc().sc "']").SetAttribute("last",1),MainWin.Gui.Save(1),menus.Save(1),GetPos(),positions.Save(1),TNotes.GetPos(),TNotes.XML.Save(1),Settings.Save(1)
	if(debug.socket)
		debug.Send("stop")
	xx:=ScanFile.XML,FileList:=[],all:=Settings.SN("//open/file")
	while(aa:=all.item[A_Index-1])
		FileList[aa.text]:=1
	all:=xx.SN("//main"),FileList.Libraries:=1
	while(aa:=all.item[A_Index-1],ea:=XML.EA(aa))
		if(!FileList[ea.File]||!SSN(aa,"descendant::file"))
			aa.ParentNode.RemoveChild(aa)
	all:=xx.SN("//*[@id]")
	while(aa:=all.item[A_Index-1],ea:=XML.EA(aa))
		aa.RemoveAttribute("id")
	if(0)
		m("Disabled Saving ScanFile.xml","time:.5")
	else
		xx.Save(1)
	if(ExitApp)
		Reload
	ExitApp
	return
}
Export(){
	indir:=Settings.Find("//export/file/@file",SSN(Current(1),"@file").text),warn:=v.Options.Warn_Overwrite_On_Export?"S16":"S"
	FileSelectFile,filename,%warn%,% indir.text,Export Compiled AHK,*.ahk
	SplitPath,filename,,outdir
	filename:=InStr(filename,".ahk")?filename:filename ".ahk"
	FileDelete,%filename%
	file:=FileOpen(filename,"rw","UTF-8"),file.Seek(0),file.Write(Publish(1)),file.Length(file.length)
	if(!indir)
		indir:=Settings.Add("export/file",{file:SSN(Current(1),"@file").text},,1)
	if(outdir)
		indir.text:=filename
}
Extract(mainfile){
	static FileCount:=0 ;,ADODB:=ComObjCreate("ADODB.Stream")
	FileList:=[],file:=mainfile,pool:=[]
	if(!main:=files.Find("//main/@file",mainfile))
		main:=files.Under(files.SSN("//*"),"main",{file:mainfile,id:(inside:=id:=GetID())})
	SplitPath,mainfile,mfn,maindir,Ext,mnne
	SplitPath,A_AhkPath,,ahkdir
	pool[maindir]:=1,pool[ahkdir]:=1,out:=SplitPath(mainfile),Language:=LanguageFromFileExt(Ext)
	if(!node:=files.Find(main,"descendant::file/@file",file))
		node:=files.Under(main,"file",{file:file,dir:maindir,filename:mfn,id:id,nne:mnne,scan:1,lower:Format("{:L}",file),ext:Ext,lang:Language})
	ExtractNext:
	id:=GetID()
	if(!v.Options["Force_UTF-8"])
		q:=FileOpen(file,"R"),len:=StrPut((Text1:=q.Read()),"UTF-8")-1,enc1:=q.encoding,q.Close(),q:=FileOpen(file,"R","UTF-8"),len1:=StrPut((Text2:=q.Read()),"UTF-8")-1,enc2:=q.encoding,q.Close(),(len=len1)?(encoding:=enc1,text:=Text1):(encoding:=enc2,text:=Text2)
	else
		fff:=FileOpen(file,"R",(v.Options["Force_UTF-8"]?"UTF-8":"")),encoding:=fff.encoding,text:=fff.Read(fff.length),fff.Close(),dir:=Trim(dir,"\")
	if(nnnn:=files.Find("//*/@file",file)){
		if(SSN(nnnn,"@time"))
			id:=SSN(nnnn,"@id").text
	}
	FileGetTime,time,%file%
	SplitPath,file,filename,dir,Ext,nne
	Language:=LanguageFromFileExt(Ext),set:=files.Find(node,"descendant-or-self::file/@file",file),set.SetAttribute("time",time),set.SetAttribute("encoding",encoding),pos:=1
	if(!SSN(set,"@id"))
		set.SetAttribute("id",id)
	StringReplace,text,text,`r`n,`n,All
	if(!Update({get:file}))
		Update({file:file,text:text,load:1,encoding:encoding})
	while(RegExMatch(text,"iOm`nU)^\s*\x23Include\s*,?\s*(.*)(\s+;.*)?$",found,pos)),pos:=found.pos(1)+found.len(1){
		if(InStr(Found.2,";NoIndex"))
			Continue
		info:=found.1,info:=RegExReplace(Trim(found.1,", `t`r`n"),"i)\Q*i\E\s*"),added:=0,orig:=info
		if(FileExist(info)="D")
			pool[Trim(info,"\")]:=1
		if(InStr(info,"%")){
			if(InStr(info,"%A_LineFile%")){
				Loop,Files,% RegExReplace(info,"i)\%A_LineFile\%",file)
					FileList[A_LoopFileLongPath]:={file:A_LoopFileLongPath,include:found.0,inside:file},added:=1
			}if(InStr(info,"%A_ScriptDir%")){
				for a in pool
					if(FileExist(check:=RegExReplace(info,"i)%A_ScriptDir%",a))~="D"&&!pool[check]){
						pool[check]:=1
						Break
			}}if(InStr(info,"%A_AppData%")){
				check:=RegExReplace(info,"i)%A_AppData%",A_AppData)
				if(FileExist(check)="D"&&!pool[check])
					pool[check]:=1
			}if(InStr(info,"%A_AppDataCommon%")){
				check:=RegExReplace(info,"i)%A_AppDataCommon%",A_AppDataCommon)
				if(FileExist(check)="D"&&!pool[check])
					pool[check]:=1
			}if(FileExist(check)="A"){
				FileList[check]:={file:check,include:found.0,inside:file},added:=1
				Continue
			}info:=check
		}if(InStr(info,"<")){
			info:=RegExReplace(info,"\<|\>")
			for a in pool{
				if(FileExist(fn:=a "\lib\" info ".ahk")){
					FileList[fn]:={file:fn,include:found.0,inside:file},libfile:=1,added:=1
					break
				}
			}if(FileExist(fn:=A_MyDocuments "\AutoHotkey\lib\" info ".ahk")&&!libfile){
				FileList[fn]:={file:fn,include:found.0,inside:file},added:=1
			}libfile:=0
		}for a in pool{
			exist:=FileExist(a "\" info)
			if(exist!="D"&&exist!=""){
				FileList[a "\" info]:={file:a "\" info,include:found.0,inside:file},added:=1
				Break
		}}if(!added&&FileExist(orig))
			FileList[orig]:={file:orig,include:found.0,inside:file},added:=1
	}
	ExtractBottom:
	for fn,obj in filelist{
		if(InStr(fn,"..")){
			Loop,Files,%fn%,F
				obj.file:=A_LoopFileLongPath
		}filelist.Delete(fn),file:=obj.file:=Trim(obj.file)
		if(!files.Find(node,"descendant::file/@file",file)){
			SplitPath,file,filename,dir,Ext,nne
			Language:=LanguageFromFileExt(Ext),obj.ext:=Ext,obj.lang:=Language,new:=files.Under(files.Find(node,"descendant-or-self::file/@file",obj.inside),"file",obj)
			for a,b in {file:file,filename:filename,dir:dir,nne:nne,github:(maindir=dir?filename:"lib\" filename),scan:1,lower:Format("{:L}",filename)}
				new.SetAttribute(a,b)
			qea:=XML.EA(new)
		}Goto,ExtractNext
}}
FEAdd(value,parent:=0,options:=""){
	if(v.Options.Hide_File_Extensions){
		SplitPath,value,,,ext,name
		value:=ext="ahk"?name:value
	}Default("SysTreeView321")
	return TV_Add(value,parent,options)
}
FEUpdate(Redraw:=0){
	if(Redraw){
		all:=files.SN("//*[@tv]"),oid:=Current(8)
		while(aa:=all.item[A_Index-1]),ea:=XML.EA(aa)
			aa.RemoveAttribute("tv")
		TVC.Delete(1,0),Libraries:=""
	}master:=files.SSN("//files"),mea:=XML.EA(master)
	if(!mea.tv)
		master.SetAttribute("tv",TVC.Add(1,"Projects"))
	projects:=SSN(master,"@tv").text,all:=files.SN("descendant::*[not(@tv)]")
	while(aa:=all.item[A_Index-1]),ea:=XML.EA(aa){
		if(aa.NodeName="folder"){
			aa.ParentNode.RemoveChild(aa)
			Continue
		}if(aa.NodeName="files"){
			Continue
		}if(aa.NodeName="main"){
			main:=aa,ea:=XML.EA(main),id:=ea.id,file:=ea.file
			if(!root:=cexml.SSN("//*[@id='" ea.id "']"))
				root:=cexml.SSN("//*").AppendChild(main.CloneNode(0)),add:=1
			else
				add:=0
			Continue
		}if(aa.ParentNode.NodeName="main"){
			if(SSN(aa.ParentNode,"@file").text="Libraries"){
				if(!cexml.SSN("//main[@file='Libraries']/@tv"))
					cexml.SSN("//main[@file='Libraries']").SetAttribute("tv",Libraries:=TVC.Add(1,"Libraries",0))
				aa.SetAttribute("tv",TVC.Add(1,v.Options.Hide_File_Extensions?ea.nne:ea.filename,Libraries))
			}else if(aa.ParentNode.NodeName="main"){
				aa.SetAttribute("tv",TVC.Add(1,v.Options.Hide_File_Extensions?ea.nne:ea.filename,projects,"Vis"))
			}if(Add)
				node:=root.AppendChild(aa.CloneNode(0)),node.SetAttribute("type","File")
		}if(aa.ParentNode.NodeName="file"){
			if(v.Options.Full_Tree){
				Relative:=StrSplit(rel:=RelativePath(file,ea.file),"\")
				if(InStr(rel,"\")){
					if(!tv:=SSN(main,"descendant::folder[@path='" build "']/@tv").text){
						build:=""
						for a,b in Relative{
							build.=b "\"
							if(a<Relative.MaxIndex()){
								if(!tv:=SSN(main,"descendant::folder[@path='" build "']/@tv").text)
									files.Under(main,"folder",{path:build,tv:(tv:=TVC.Add(1,b,A_Index=1?SSN(main,"file/@tv").text:SSN(main,"descendant::folder[@path='" lastbuild "']/@tv").text))})
							}lastbuild:=build
					}}aa.SetAttribute("tv",TVC.Add(1,v.Options.Hide_File_Extensions?ea.nne:ea.filename,tv,"Sort"))
				}else
					aa.SetAttribute("tv",TVC.Add(1,v.Options.Hide_File_Extensions?ea.nne:ea.filename,SSN(aa.ParentNode,"@tv").text,"Sort"))
			}else
				aa.SetAttribute("tv",TVC.Add(1,v.Options.Hide_File_Extensions?ea.nne:ea.filename,SSN(aa.ParentNode,"@tv").text,"Sort"))
			if(add)
				new:=root.AppendChild(aa.CloneNode(0)),new.SetAttribute("type","File")
	}}if(Redraw){
		tv(files.SSN("//*[@id='" oid "']/@tv").text)
		GuiControl,1:+Redraw,SysTreeView321
	}
}
FileCheck(file:=""){
	static base:="https://raw.githubusercontent.com/maestrith/AHK-Studio/master/"
	,scidate:=20161107223002,XMLFiles:={menus:[20170814205757,"lib/menus.xml","lib\Menus.xml"],commands:[20170820110351,"lib/Commands.xml","lib\Commands.xml"]}
	,OtherFiles:={scilexer:{date:20170926222816,loc:"SciLexer.dll",url:"SciLexer.dll",type:1},icon:{date:20150914131604,loc:"AHKStudio.ico",url:"AHKStudio.ico",type:1},Studio:{date:20170906124736,loc:A_MyDocuments "\Autohotkey\Lib\Studio.ahk",url:"lib/Studio.ahk",type:1}}
	,DefaultOptions:="Manual_Continuation_Line,Full_Auto_Indentation,Focus_Studio_On_Debug_Breakpoint,Word_Wrap_Indicators,Context_Sensitive_Help,Auto_Complete,Auto_Complete_In_Quotes,Auto_Complete_While_Tips_Are_Visible"
	if(!Settings.SSN("//fonts|//theme"))
		DefaultFont(),ConvertTheme()
	if(!FileExist(A_MyDocuments "\Autohotkey\Lib")){
		FileCreateDir,% A_MyDocuments "\Autohotkey"
		FileCreateDir,% A_MyDocuments "\Autohotkey\Lib"
	}if(FileExist("lib\Studio.ahk"))
		FileMove,lib\Studio.ahk,%A_MyDocuments%\Autohotkey\Lib\Studio.ahk,1
	if(!file&&x:=ComObjActive("AHK-Studio")){
		x.Activate()
		ExitApp
	}if((A_PtrSize=8&&A_IsCompiled="")||!A_IsUnicode){
		SplitPath,A_AhkPath,,dir
		if(!FileExist(correct:=dir "\AutoHotkeyU32.exe")){
			m("Requires AutoHotkey 1.1 to run")
			ExitApp
		}
		Run,"%correct%" "%A_ScriptName%" "%file%",%A_ScriptDir%
		ExitApp
		return
	}if(file){
		v.OpenFile:=file
		if(x:=ComObjActive("{DBD5A90A-A85C-11E4-B0C7-43449580656B}")){
			x.Open(file),x.ScanFiles(),x.Show()
			ExitApp
		}
		if(file){
			if(!Settings.SSN("//open/file[text()='" file "']"))
				Settings.Add("open/file",{select:1},file,1)
		}
	}for a,b in XMLFiles{
		if(!FileExist(b.3)){
			SplashTextOn,200,100,% "Downloading " b.2,Please Wait...
			UrlDownloadToFile,% base b.2,% b.3
		}SplashTextOff
		new:=%a%:=new XML(a,b.3)
		if(!new.SSN("//date"))
			new.Add("date",,b.1),new.Save(1)
		if(new.SSN("//date").text!=b.1){
			SplashTextOn,200,100,% "Downloading " b.2,Please Wait...
			if(a="menus"){
				temp:=new XML("temp"),temp.XML.LoadXML(URLDownloadToVar(base b.2)),all:=temp.SN("//*[@clean]")
				while(aa:=all.item[A_Index-1]),ea:=XML.EA(aa){
					if(aa.HasChildNodes())
						lastea:=ea
					else if(!Menus.SSN("//*[@clean='" ea.clean "']")&&!aa.HasChildNodes()){
						list:=[],top:=Menus.SSN("//main")
						while(aa.ParentNode.NodeName="menu")
							aa:=aa.ParentNode,list.InsertAt(1,SSN(aa,"@clean").text)
						for c,d in list{
							if(!new:=SSN(top,"menu[@clean='" d "']"))
								new:=Menus.Under(top,"menu",lastea)
							top:=new
						}Menus.Under(top,"menu",ea)
						if(DefaultOptions~="\b" ea.clean "\b")
							Settings.Add("options",{(ea.clean):1})
				}}Menus.Add("date",,b.1),Menus.Save(1)
			}else{
				UrlDownloadToFile,% base b.2,% b.3
				new:=%a%:=new XML(a,b.3),new.Add("date",,b.1),new.Save(1)
			}Options("Startup")
	}}for a,b in OtherFiles{
		FileGetTime,time,% b.loc
		if(time<b.date){
			SplashTextOn,200,100,% "Downloading " b.url,"Please Wait..."
			FileMove,% b.loc,% b.loc "bak"
			URLDownloadToFile,% base b.url,% b.loc "new"
			FileDelete,% b.loc "bak"
			FileMove,% b.loc "new",% b.loc
			SplashTextOff
	}}RegRead,value,HKCU,Software\Classes\AHK-Studio
	(!value)?RegisterID("{DBD5A90A-A85C-11E4-B0C7-43449580656B}","AHK-Studio"):""
	if(FileExist("lib\Scintilla.xml"))
		Scintilla()
	FileGetTime,time,SciLexer.dll
	if(!FileExist("SciLexer.dll")||time<scidate){
		SplashTextOn,200,100,Downloading SciLexer.dll,Please Wait....
		UrlDownloadToFile,%base%/SciLexer.dll,SciLexer.dll
	}SplashTextOff
}
Filename(filename){
	return newfile:=filename~="\.ahk$"?filename:filename ".ahk"
}
Find_Replace(){
	static
	LastSC:=csc()
	infopos:=positions.Find("//*/@file",Current(3).file),last:=SSN(infopos,"@findreplace").text,ea:=Settings.EA("//findreplace"),nw:=new GUIKeep(30),value:=[]
	for a,b in ea
		value[a]:=b?"Checked":""
	nw.Add("Text,,Find","Edit,w200 vfind","Text,,Replace","Edit,w200 vreplace","Checkbox,vregex " value.regex ",Regex","Checkbox,vcs " value.cs ",Case Sensitive","Checkbox,vgreed " value.greed ",Greed","Checkbox,vml " value.ml ",Multi-Line","Checkbox,xm vInclude " value.Include ",Current Include Only","Checkbox,xm vcurrentsel hwndcs gcurrentsel " value.currentsel ",In Current Selection","Button,gfrfind Default,&Find","Button,x+5 gfrreplace,&Replace","Button,x+5 gfrall,Replace &All"),nw.Show("Find & Replace"),sc:=csc(),order:=[],order[sc.2585(0)]:=1,order[sc.2587(0)]:=1,last:=(order.MinIndex()!=order.MaxIndex())?sc.TextRange(order.MinIndex(),order.MaxIndex()):last,Hotkeys(30,{"!e":"frregex"})
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
	30Close:
	30Escape:
	info:=nw[],fr:=Settings.Add("findreplace")
	for a,b in {regex:info.regex,cs:info.cs,greed:info.greed,ml:info.ml,Include:info.Include,currentsel:info.currentsel}
		fr.SetAttribute(a,b)
	fr:=positions.Find("//*/@file",Current(3).file),fr.SetAttribute("findreplace",info.find),nw.SavePos(),hwnd({rem:30})
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
	info:=nw[],startsearch:=0,sc:=csc(),stop:=Current(3).file,looped:=0,current:=Current(1),pos:=sc.2008,pre:="O",find:="",find:=info.regex?info.find:"\Q" RegExReplace(info.find, "\\E", "\E\\E\Q") "\E",pre.=info.greed?"":"U",pre.=info.cs?"":"i",pre.=info.ml?"":"m`n",find:=pre ")" find ""
	if(info.currentsel){
		end:=sc.2509(2,start),text:=SubStr(Update({encoded:Current(3).file}),start+1,end-start+1),greater:=sc.2008>sc.2009?sc.2008:sc.2009,pos:=greater>start?greater-start:1
		if(RegExMatch(text,find,found,pos))
			fp:=found.Pos(1)!=""?found.Pos(1):found.Pos(0),fl:=found.len(1)!=""?found.len(1):found.len(0),sc.2160(start+fp-1,start+fp-1+fl)
		else{
			pos:=1
			if(RegExMatch(text,find,found,pos))
				fp:=found.Pos(1)!=""?found.Pos(1):found.Pos(0),fl:=found.len(1)!=""?found.len(1):found.len(0),sc.2160(start+fp-1,start+fp-1+fl)
		}
		return
	}
	frrestart:
	if(!info.find)
		return m("Enter search text")
	if(RegExMatch(text:=Update({encoded:Current(3).file}),find,found,sc.2008+1))
		return sc.2160(start:=StrPut(SubStr(text,1,found.Pos(0)),"utf-8")-2,start+StrPut(found.0,"utf-8")-1)
	list:=info.Include?SN(Current(),"self::*"):SN(Current(1),"descendant::file")
	while(current:=list.Item[A_Index-1],ea:=XML.EA(current)){
		if(ea.file!=stop&&startsearch=0)
			continue
		startsearch:=1
		text:=Update({get:ea.file})
		if(pos:=RegExMatch(text,find,found,pos))
			return np:=StrPut(SubStr(text,1,pos-1),"utf-8")-1,tv(files.SSN("//file[@id='" ea.id "']/@tv").text,{start:np,end:np+StrPut(found.0,"utf-8")-1}),WinActivate(nw.id)
		if(ea.file=stop&&looped=1)
			return m("No Matches Found")
		pos:=1
	}current:=Current(1).firstchild,looped:=1
	goto,frrestart
	return
	FRReplace:
	info:=nw[],sc.2170(0,[NewLines(info.replace)]),Update({sc:sc.2357})
	goto,frfind
	return
	frall:
	info:=nw[],sc:=csc(),stop:=Current(3).file,looped:=0,current:=Current(),pos:=sc.2008,pre:="O",find:="",find:=info.regex?info.find:"\Q" RegExReplace(info.find, "\\E", "\E\\E\Q") "\E",pre.=info.greed?"":"U",pre.=info.cs?"":"i",pre.=info.ml?"":"m`n",find:=pre ")" find ""
	if(info.currentsel)
		return pos:=1,end:=sc.2509(2,start),text:=SubStr(Update({encoded:Current(3).file}),start+1,end-start),text:=RegExReplace(text,find,info.replace),sc.2190(start),sc.2192(end),sc.2194(StrPut(text,"utf-8")-1,[text]),sc.2500(2),sc.2505(0,sc.2006),sc.2504(start,len:=StrPut(text,"utf-8")-1),end:=start+len
	if(info.Include)
		goto,frseg
	list:=SN(Current(1),"descendant::file"),All:=Update("get").1,info:=nw[],replace:=NewLines(info.replace)
	while,ll:=list.Item[A_Index-1]{
		text:=All[SSN(ll,"@file").text]
		if(RegExMatch(text,find,found)){
			rep:=RegExReplace(text,find,replace),ea:=XML.EA(ll)
			if(ea.sc)
				tv(ea.tv),sc.2181(0,[rep]),sc.2160(v.tvpos.start,v.tvpos.end),sc.2613(v.tvpos.scroll)
			else
				Update({file:ea.file,text:rep})
			ll.SetAttribute("edited",1),TVC.Modify(1,(v.Options.Hide_File_Extensions?"*" ea.nne:"*" ea.filename),ea.tv),WinSetTitle(1,ea)
	}}return WinActivate(nw.id)
	frseg:
	info:=nw[],sc:=csc(),pre:="O",find:="",find:=info.regex?info.find:"\Q" RegExReplace(info.find, "\\E", "\E\\E\Q") "\E",pre.=info.greed?"":"U",pre.=info.cs?"":"i",pre.=info.ml?"":"m`n",find:=pre ")" find "",replace:=NewLines(info.replace),sc.2181(0,[RegExReplace(sc.GetText(),find,replace)]),SetPos(SSN(Current(),"@tv").text)
	return
}
SearchWin(node:=""){
	static
	Gui,1:Default
	/*
		nw:=new GUIKeep("Search")
	*/
	;hwnd:=new InternalWindow("Search")
	Gui,Add,Edit,w200 hwndhwnd
	Gui,Add,TreeView,w200 hwndtv
	ControlGetPos,,,,h,,ahk_id%hwnd%
	MainWin.FindEditHeight:=h
	for a,b in {FindEdit:hwnd,FindTV:tv}
		MainWin[a]:=b+0
	/*
		nw.Add("Edit,gFindCheck w40,,w","TreeView,w40 h40 gFindTV,,wh","Checkbox,,Test,y") ;,"Button,xm gFindTV,Placeholder,y") ;,"Button,x+M,Placeholder,y")
		for a,b in ["FindCheck","FindTV"]
			MainWin[b]:=nw.XML.SSN("//*[@label='" b "']/@hwnd").text+0
	*/
	Gui,1:Default
	return hwnd+0
	FindTV:
	return
	SearchEscape:
	;m("HERE!!!!")
	/*
		MainWin.NewCtrlPos:={ctrl:nw.hwnd+0,win:hwnd(1)}
		MainWin.Delete()
	*/
	return
}
/*
	IMPORTANT!!!!!!!!!!!!!!!!!!!
	THE TREEVIEWS ARE GETTING OUT OF WHACK :(
	FIGURE OUT WHY THE POPULATION OF EASYVIEW IS GETTING ALL MESSED UP!!!!!!!!!!!!!!!!!!!!!
*/
Find(){
	static
	/*
		re-write this to be like Debug in that it pops up from the bottom of this window (or whatever window is current so long as it is a normal edit window)
	*/
	if(!FindXML)
		FindXML:=new XML("find"),FindXML.Add("top")
	if(!infopos:=positions.Find("//main/@file",file))
		infopos:=positions.Add("main",{file:file},,1)
	last:=SSN(infopos,"@search").text,search:=last?last:"Type in your query here",ea:=Settings.EA("//search/find"),NewWin:=new GUIKeep(5),sc:=csc(),order:=[],file:=Current(2).file
	value:=[],order[sc.2585(0)]:=1,order[sc.2587(0)]:=1,last:=(order.MinIndex()!=order.MaxIndex())?sc.TextRange(order.MinIndex(),order.MaxIndex()):last
	for a,b in ea
		Value[a]:=b?"Checked":""
	NewWin.Add("Edit,gfindcheck w400 vfind r1,,w","TreeView,w400 h200 AltSubmit gstate,,wh","Checkbox,vregex gfindfocus " value.regex ",&Regex Search,y","Checkbox,vgr x+10 gfindfocus " value.gr ",&Greed,y","Checkbox,xm vcs gfindfocus " value.cs ",&Case Sensitive,y","Checkbox,vsort gfsort " value.sort ",Sort by &Include,y","Checkbox,vallfiles gfindfocus " value.allfiles ",Search in &All Files,y","Checkbox,vacdc gfindfocus " value.acdc ",Auto Close on &Double Click,y","Checkbox,vdaioc " value.daioc ",Disable Auto Insert On Copy,y","Checkbox,vAuto_Show " Value.Auto_Show ",A&uto Show Selected,y","Button,gSearch Default,   Search   ,y","Button,gcomment,Toggle Comment,y"),NewWin.Show("Search"),Hotkeys(5,{"^Backspace":"FindBack"})
	Hotkeys(5,{Up:"FindUp",Down:"FindDown",F1:"FindShowXML",Left:"FindLeft",Right:"FindRight"})
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
		if(win=hwnd([5])&&NewWin[].daioc=0)
			ControlSetText,Edit1,%Clipboard%,%win%
		if(WinActive(hwnd([30]))&&hwnd(30))
			ControlSetText,Edit1,%Clipboard%,%win%
	}return
	FindBack:
	GuiControl,5:-Redraw,Edit1
	ControlSend,Edit1,^+{Left}{Backspace},% hwnd([5])
	GuiControl,5:+Redraw,Edit1
	return
	FindCheck:
	ControlGetText,Button,,% "ahk_id" NewWin.XML.SSN("//*[@label='Search']/@hwnd").text
	if(Button!="search")
		ControlSetText,,Search,% "ahk_id" NewWin.XML.SSN("//*[@label='Search']/@hwnd").text
	return
	Search:
	ControlGetText,Button,,% "ahk_id" NewWin.XML.SSN("//*[@label='Search']/@hwnd").text
	if(InStr(Button,"Search")){
		top:=FindXML.ReCreate("//top","top"),info:=NewWin[],count:=0
		if(!find:=info.find)
			return
		infopos.SetAttribute("search",find),foundinfo:=[]
		Gui,5:Default
		GuiControl,5:+g,SysTreeView321
		GuiControl,5:-Redraw,SysTreeView321
		list:=info.allfiles?files.SN("//file"):SN(Current(1),"descendant::file"),TV_Delete()
		pre:="m`nO",pre.=info.cs?"":"i",pre.=info.greed?"":"U",parent:=0,ff:=info.regex?find:"\Q" find "\E"
		while(l:=list.item(A_Index-1),ea:=XML.EA(l)){
			out:=Update({get:ea.file}),pos:=1,r:=0,fn:=ea.file
			SplitPath,fn,file,,,nne
			while(RegExMatch(out,pre ")(.*(" ff ").*$)",Found,pos),pos:=Found.pos(2)+Found.len(2)){
				if(info.Sort&&!FindXML.SSN("//file[@id='" ea.ID "']"))
					PP:=FindXML.Under(Top,"file",{text:fn,id:ea.ID},,1),DoSort:=1
				RegExReplace(str:=str:=SubStr(out,1,Found.pos(2)),"\R","",count)
				Next:=FindXML.Under((DoSort?PP:top),"info",Obj:={id:ea.ID,text:Found.2,found:Found.1,pos:StrPut(str,"UTF-8")-2,file:ea.file,line:Round(count)+1,filetv:ea.tv})
				for a,b in ["File","Line","Pos","Found"]
					FindXML.Under(Next,"moreinfo",{text:Obj[b],name:b})
				lastl:=fn
			}DoSort:=0
		}WinSetTitle(5,"Find: " FindXML.SN("//info").Length)
		if(TV_GetCount())
			ControlFocus,SysTreeView321
		GuiControl,5:+Redraw,SysTreeView321
		SetTimer,FindLabel,-200
		GuiControl,5:+gstate,SysTreeView321
		all:=FindXML.SN("//*")
		while(aa:=all.item[A_Index-1],ea:=XML.EA(aa)){
			if(ea.text)
				aa.SetAttribute("tv",TV_Add((ea.Name?ea.Name " = ":"") ea.Text,SSN(aa.ParentNode,"@tv").text))
		}Default("SysTreeView321",5)
		TV_Modify(FindXML.SSN("//info/@tv").text,"Select Vis Focus Expand"),Current:=FindXML.SSN("//info"),Current.SetAttribute("expand",1),Current.ParentNode.SetAttribute("expand",1)
	}else if(Button="jump"){
		ea:=FindXML.EA("//*[@tv='" TV_GetSelection() "']/ancestor-or-self::info"),Default("SysTreeView321",5),tv(ea.filetv),sc.2160(ea.pos,ea.pos+StrPut(ea.text,"UTF-8")-1),xpos:=sc.2164(0,ea.pos),ypos:=sc.2165(0,ea.pos)
		WinGetPos,xx,yy,ww,hh,% NewWin.ahkid
		WinGetPos,px,py,,,% "ahk_id" sc.sc
		WinGet,trans,Transparent,% NewWin.ahkid
		cxpos:=px+xpos,cypos:=py+ypos
		if(cxpos>xx&&cxpos<xx+ww&&cypos>yy&&cypos<yy+hh)
			WinSet,Transparent,50,% NewWin.ahkid
		else if(trans=50)
			WinSet,Transparent,255,% NewWin.ahk
		SetTimer,CenterSel,-10
		if(v.Options.Auto_Close_Find)
			return hwnd({rem:5})
		WinActivate(hwnd([5]))
	}else{
		sel:=TV_GetSelection(),TV_Modify(sel,ec:=TV_Get(sel,"E")?"-Expand":"Expand")
		SetTimer,FindLabel,-200
	}
	return
	state:
	if(A_GuiEvent="DoubleClick"){
		Default("SysTreeView321",5)
		if(Node:=FindXML.SSN("//*[@tv='" TV_GetSelection() "']")){
			info:=NewWin[],ea:=XML.EA(Node)
			if(!ea.File)
				return
			if(Current(3).ID!=ea.ID){
				tv(files.SSN("//file[@id='" ea.ID "']/@tv").text)
				WinActivate,% NewWin.ID
				Sleep,200
			}ea:=XML.EA(Node),sc:=csc(),sc.2160(ea.Pos,ea.Pos+StrPut(ea.text,"UTF-8")-1)
			if(info.acdc)
				goto,5Close
			return
		}
	}SetTimer,FindLabel,-200
	SetTimer,FindCurrent,-10
	return
	FindShowXML:
	FindXML.Transform()
	FindXML.Transform()
	m(FindXML[])
	return
	FindLeft:
	FindRight:
	ControlGetFocus,Focus,% NewWin.ID
	if(Focus!="SysTreeView321"){
		if(A_ThisLabel="FindLeft")
			Send,{Left}
		else
			Send,{Right}
		return
	}
	Default("SysTreeView321",5)
	Node:=FindXML.SSN("//*[@tv='" (Sel:=TV_GetSelection()) "']")
	if(A_ThisLabel="FindLeft"){
		TV_Modify(SSN(Node,"@tv").text,"-Expand")
		if(tv:=SSN(Node.ParentNode,"@tv").text)
			TV_Modify(tv,"Select Vis Focus -Expand")
	}else{
		if(tv:=SSN(Node,"descendant::*/@tv").text)
			TV_Modify(tv,"Select Vis Focus")
	}
	return
	FindUp:
	FindDown:
	Default("SysTreeView321",5)
	Node:=FindXML.SSN("//*[@tv='" (Sel:=TV_GetSelection()) "']")
	if(A_ThisLabel="FindUp"){
		if(Node.NodeName="info"){
			Count:=SN(Node,"preceding-sibling::info").Length
			if(Count)
				Current:=SSN(Node.ParentNode,"info[" Count "]")
			else if(Parent:=Node.ParentNode.PreviousSibling){
				if(!Current:=SSN(Parent,"descendant::info[last()]"))
					return
			}else
				return
		}else if(!Current:=SSN(Node,"ancestor::info"))
			Current:=SSN(Node,"descendant::info")
	}else{
		if(Node.NodeName="info"){
			if(!Current:=SSN(Node,"following-sibling::info")){
				if(!Parent:=Node.ParentNode.NextSibling)
					return
				Current:=SSN(Parent,"descendant::info")
			}
		}
	}
	FindCurrent:
	GuiControl,5:+g,SysTreeView321
	GuiControl,5:-Redraw,SysTreeView321
	Default("SysTreeView321",5),Sel:=SSN(Current,"@tv").text,Sel:=Sel?Sel:TV_GetSelection(),all:=FindXML.SN("//*[not(@tv='" Sel "')]")
	while(aa:=all.item[A_Index-1]){
		if(TV_Get((tv:=SSN(aa,"@tv").text),"Expand"))
			TV_Modify(tv,"-Expand"),aa.RemoveAttribute("expand")
	}TV_Modify(Sel,"Select Vis Focus Expand")
	/*
		for a,b in [Current,Current.ParentNode]
			b.SetAttribute("expand",1)
	*/
	GuiControl,5:+Redraw,SysTreeView321
	GuiControl,5:+gState,SysTreeView321
	Current:=""
	return
	FindLabel:
	Gui,5:Default
	sel:=TV_GetSelection()
	Node:=FindXML.SSN("//*[@tv='" sel "']")
	if(!TV_GetCount())
		Buttontext:="Search"
	else if(Node.NodeName="file")
		Buttontext:=TV_Get(sel,"E")?"Contract":"Expand"
	else if(SSN(Node,"ancestor-or-self::info"))
		Buttontext:="Jump"
	ControlSetText,,%Buttontext%,% "ahk_id" NewWin.XML.SSN("//*[@label='Search']/@hwnd").text
	if(Node.NodeName="info"){
		all:=FindXML.SN("//info[not(@tv='" sel "')]")
		while(aa:=all.item[A_Index-1],ea:=XML.EA(aa))
			TV_Modify(ea.tv,"-Expand")
		TV_Modify(sel,"Expand")
		if(NewWin[].Auto_Show){
			ea:=XML.EA(Node)
			if(Current(3).ID!=ea.ID){
				tv(files.SSN("//file[@id='" ea.ID "']/@tv").text)
				WinActivate,% NewWin.ID
				Sleep,200
			}
			sc:=csc()
			sc.2160(ea.Pos,ea.Pos+StrPut(ea.text,"UTF-8")-1)
		}
	}
	return
	fsort:
	ControlSetText,,Search,% "ahk_id" NewWin.XML.SSN("//*[@label='Search']/@hwnd").text
	goto,search
	return
	5Escape:
	5Close:
	ea:=NewWin[],Settings.Add("search/find",{daioc:ea.daioc,acdc:ea.acdc,Auto_Show:ea.Auto_Show,regex:ea.regex,cs:ea.cs,sort:ea.sort,gr:ea.gr,allfiles:ea.allfiles}),foundinfo:="",infopos.SetAttribute("search",ea.find)
	NewWin.SavePos(),hwnd({rem:5})
	return
	Comment:
	sc:=csc()
	Toggle_Comment_Line()
	return
	FindFocus:
	ControlFocus,Edit1,% hwnd([5])
	return
}
Fix_Indent(){
	sc:=csc()
	/*
		if(Current(3).ext="ahk")
			
	*/
	FixLines(0,sc.2166(sc.2006)),sc.Enable(1)
	/*
		else
			m("Sorry but this only works with .ahk files")
	*/
}
FixIndentArea(){
	sc:=csc(),find:=line:=sc.2166(sc.2008)
	if(sc.2225(line)>=0){
		while((find:=sc.2225(find))>=0)
			line:=find
		FixLines(line,sc.2224(line,-1)-line),sc.Enable(1)
	}else{
		start:=line
		while((above:=sc.2225(--start))<0)
			if(start<=0)
				Break
		StartLine:=(sl:=sc.2224(above,-1))>=0?sl:0,start:=line,lastline:=sc.2154-1
		while((below:=sc.2225(++start))<0)
			if(start>=lastline)
				Break
		below:=below>0?below:lastline,FixLines(StartLine,below-StartLine,0),sc.Enable(1)
	}
}
FixLines(line,total,base:=""){
	tick:=A_TickCount,sc:=csc(),ind:=Settings.Get("//tab",5),startpos:=sc.2008,code:=StrSplit((codetext:=sc.GetUNI()),"`n"),sc.Enable(),chr:="K",indentation:=sc.2121,lock:=[],block:=[],aaobj:=[],code:=StrSplit(codetext,"`n"),specialbrace:=skipcompile:=aa:=ab:=braces:=0,end:=total+line
	if(base="")
		base:=Round(sc.2127(line)/ind)
	IndentRegex:=Keywords.IndentRegex[Current(3).ext],IndentRegex:=IndentRegex?IndentRegex:"if|else|for|while"
	if(Current(3).ext="xml")
		return
	Loop,% code.MaxIndex(){
		if(A_Index-1>total)
			Break
		Text:=RegExReplace(Trim(code[(a:=line+A_Index)],"`t "),"U)(\x22.*\x22)")
		if(Text~="i)\Q* * * Compile_AH" Chr "\E"){
			skipcompile:=skipcompile?0:1
			Continue
		}if(skipcompile)
			Continue
		if(SubStr(Text,1,1)=";"&&v.Options.Auto_Indent_Comment_Lines!=1)
			Continue
		FirstTwo:=SubStr(Text,1,2)
		if(Instr(Text,";{")||InStr(Text,";}")){
			if(RegExReplace(Text,"\{","",count))
				specialbrace+=count
			if(RegExReplace(Text,"\}","",count))
				specialbrace-=count
			Continue
		}if(InStr(Text,Chr(59)))
			Text:=RegExReplace(SubStr(Text,1,InStr(Text,";")),"\s+" Chr(59) ".*"),comment:=1
		first:=SubStr(Text,1,1),last:=SubStr(Text,0,1),ss:=(Text~="i)^\s*(&&|\bOR\b|\bAND\b|\.|\,|\|\||:|\?)\s*"),indentcheck:=(RegExMatch(Text,"iA)}*\s*[^#]?\b(" IndentRegex ")\b",string)&&IndentRegex)
		if(first="<")
			Continue
		if(InStr(string,"try"))
			if(RegExReplace(Text,"i)(\{|try|\s)"))
				indentcheck:=0
		if(first="("&&InStr(Text,")")=0)
			skip:=1
		if(Skip){
			if(First=")")
				Skip:=0
			Continue
		}if(FirstTwo="*/")
			block:=[],aa:=0
		block.MinIndex()?(current:=block,cur:=1):(current:=lock,cur:=0),braces:=current[current.MaxIndex()].braces+1?current[current.MaxIndex()].braces:0,aa:=aaobj[cur]+0?aaobj[cur]:0
		if(first="}"){
			while((found:=SubStr(Text,A_Index,1))~="(}|\s)"){
				if(found~="\s")
					Continue
				if(cur&&current.MaxIndex()<=1)
					Break
				special:=current.pop().ind,braces--
		}}if(first="{"&&aa)
			aa--
		tind:=current[current.MaxIndex()].ind+1?current[current.MaxIndex()].ind:0,tind+=aa?aa*indentation:0,tind:=tind+1?tind:0,tind:=special?special-indentation:tind,tind:=current[current.MaxIndex()].ind+1?current[current.MaxIndex()].ind:0,tind+=aa?aa*indentation:0,tind:=tind+1?tind:0,tind:=special?special-indentation:tind,tind+=Abs(specialbrace*indentation)
		if(!(ss&&v.Options.Manual_Continuation_Line)&&sc.2127(a-1)!=tind+(base*ind))
			sc.2126(a-1,tind+base*ind)
		if(FirstTwo="/*"){
			if(block.1.ind="")
				block.Insert({ind:(lock.1.ind!=""?lock[lock.MaxIndex()].ind+indentation:indentation),aa:aa,braces:lock.1.ind+1?Lock[lock.MaxIndex()].braces+1:1})
			current:=block,aa:=0
		}if(last="{"||FirstTwo="{`t")
			braces++,aa:=ss&&last="{"?aa-1:aa,!current.MinIndex()?current.Insert({ind:(aa+braces)*indentation,aa:aa,braces:braces}):current.Insert({ind:(aa+current[current.MaxIndex()].aa+braces)*indentation,aa:aa+current[current.MaxIndex()].aa,braces:braces}),aa:=0
		if((aa||ss||indentcheck)&&(indentcheck&&last!="{"))
			aa++
		if(aa>0&&!(ss||indentcheck))
			aa:=0
		aaobj[cur]:=aa,special:=0,comment:=0
	}Update({sc:sc.2357}),SetStatus(A_ThisFunc " Process Time: " A_TickCount-tick "ms @ " A_TickCount " lines: " total,3)
}
Focus(a*){
	t("HERE!","time:1")
	if(a.1=0){
		sc:=csc()
		if(sc.sc=MainWin.tnsc.sc)
			csc(2),t("TOP! HERE!")
	}
	if(a.1=1&&A_Gui=1){
		csc().2400
		t("HERE!","time:1")
		if(a&&v.Options.Check_For_Edited_Files_On_Focus=1)
			Check_For_Edited()
		return 0
	}
}
Fold_All(){
	csc().2662
}
UnFold_All(){
	csc().2662(1)
}
Toggle_Fold_All(){
	csc().2662(2)
}
Fold_Current_Level(){
	sc:=csc(),level:=sc.2223(sc.2166(sc.2008))&0xff,level:=level-1>=0?level-1:level,Fold_Level_X(Level)
}
Unfold_Current_Level(){
	sc:=csc(),level:=sc.2223(sc.2166(sc.2008))&0xff,Unfold_Level_X(Level)
}
Fold_Level_X(Level=""){
	sc:=csc()
	if(level="")
		level:=InputBox(sc.sc,"Fold Levels","Enter a level to fold`n0-100")
	current:=0
	while,(current<sc.2154){
		fold:=sc.2223(current)
		if (fold&0xff=level)
			sc.2237(current,0),current:=sc.2224(current,fold)
		current+=1
	}
}
Toggle_Fold(){
	sc:=csc(),sc.2231(sc.2166(sc.2008))
}
Unfold_Level_X(Level=""){
	sc:=csc()
	if(level="")
		level:=InputBox(sc.sc,"Fold Levels","Enter a level to Un-fold`n0-100")
	if(ErrorLevel)
		return
	fold=0
	while,sc.2618(fold)>=0,fold:=sc.2618(fold){
		lev:=sc.2223(fold)
		if(lev&0xff=level)
			sc.2237(fold,1)
		fold++
	}
}
FoldParent(){
	sc:=csc(),line:=find:=sc.2166(sc.2008)
	while((find:=sc.2225(find))>=0)
		line:=find
	return line
}
FormatTime(format,time){
	FormatTime,out,%time%,%format%
	return out
}
Forum(){
	Run,https://autohotkey.com/boards/viewtopic.php?f=6&t=300&hilit=ahk+studio
}
Full_Backup(remove:=0){
	Save(),sc:=csc()
	SplashTextOn,300,100,Backing up...,Please wait, This may take some time if it has been a while since your last full backup.
	cur:=Current(2).file
	SplitPath,cur,,dir
	if(remove){
		Loop,%dir%\AHK-Studio Backup\*.*,2
			FileRemoveDir,%A_LoopFileFullPath%,1
	}
	backup:=dir "\AHK-Studio Backup\Full Backup" A_Now
	FileCreateDir,%backup%
	if(v.Options.Full_Backup_All_Files){
		loop,%dir%\*.*,0,1
		{
			if(InStr(a_loopfilename,".exe")||InStr(A_LoopFileName,".dll")||InStr(A_LoopFileDir,dir "\AHK-Studio Backup"))
				Continue
			file:=Trim(RegExReplace(A_LoopFileFullPath,"i)\Q" dir "\E"),"\")
			SplitPath,file,filename,ddir
			if(!FileExist(backup "\" ddir))
				FileCreateDir,% backup "\" ddir
			ndir:=ddir?backup "\" ddir:backup
			FileCopy,%A_LoopFileFullPath%,%ndir%\%filename%
		}
	}else{
		allfiles:=SN(Current(1),"descendant::file/@file")
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
GetAllTopClasses(text:="",startline:=0,lines:=0,Omni:=""){
	if(text)
		otext:=text
	else
		sc:=csc(),otext:=text:=sc.GetUNI()
	pos:=1,tops:=[]
	/*
		Omni:=GetOmni(GetLanguage())
	*/
	while(RegExMatch(text,Omni.Class,found)){
		if(!found.Len(1))
			Break
		CText:=GetClassText(text,found.2,,Omni)
		RegExReplace((FindStart:=SubStr(otext,1,InStr(otext,CText)-1)),"\R","",count)
		length:=StrLen(CText)
		if(!length)
			Break
		tops[found.2]:={found:found,start:(start:=InStr(otext,CText)),end:(end:=start+StrLen(CText)),text:CText,name:found.2,line:count}
		/*
			if(!v.startup)
				m(CText,lines)
		*/
		if(lines){
			RegExReplace(SubStr(otext,1,start),"\R","",linestart)
			RegExReplace(SubStr(otext,1,end),"\R","",lineend)
			for a,b in {linestart:linestart+startline,lineend:lineend+startline}
				tops[found.2,a]:=b
		}
		text:=SubStr(text,found.pos(1)+length)
	}
	return tops
}
GetWebBrowser(){
	SendMessage,DllCall("RegisterWindowMessage","str","WM_HTML_GETOBJECT"),0,0,Internet Explorer_Server1,AutoHotkey Help
	if(ErrorLevel=FAIL)
		return
	lResult:=ErrorLevel,VarSetCapacity(GUID,16,0),CLSID:=DllCall("ole32\CLSIDFromString","wstr","{332C4425-26CB-11D0-B483-00C04FD90119}","ptr",&GUID)>=0?&GUID:"",DllCall("oleacc\ObjectFromLresult", "ptr", lResult,"ptr",CLSID,"ptr",0,"ptr*",pdoc),pweb:=ComObjQuery(pdoc,id:="{0002DF05-0000-0000-C000-000000000046}",id),ObjRelease(pdoc)
	return ComObject(9,pweb,1)
}
GetClass(class,current:=""){
	current:=current?current:Current(5),root:=SSN(current,"info[@type='Class' and @text='" class.baseclass "']")
	if(class.baseclass!=class.inside)
		nest:=SSN(current,"descendant::info[@type='Class' and @text='" class.inside "']")
	return nest?nest:root
}
GetClassText(FileText,search,ReturnClass:=0,Omni:=""){
	find:=v.OmniFindText.Class
	searchtext:=find.1 (IsObject(search)?search.2:search) find.2
	if(RegExMatch(FileText,searchtext,found,IsObject(search)?search.pos(0):1)){
		start:=pos:=found.pos(1)
		while(RegExMatch(FileText,"OUm`n)((?<SkipClose>^\s*\Q*/\E)|(?<SkipOpen>^\s*\Q/*\E)|(?<Close>^\s*}.*((\{)\s*(;.*)*)*)$)|((?<Open>.*\{)(\s+;.*|\t\w?\d?.*)*(\s*)*$)",found,pos)),pos:=found.pos(0)+found.len(0){
			/*
				make a ?<Class> that deals with class opens
				have it make a not of the brace opens
				when it gets to that brace level, that's the text for that class.
				(?<Standard_Class>^\s*(class\s+((\w|[^\x00-\x7F])+))(\s*;.*\R){0,}\s*(\{))
				(?<OTB_Class>^[\s|}]*(class\s+((\w|[^\x00-\x7F])+))(\s*;.*\R){0,}\s*(\{))
				the OTB_Class may interfere with the standard Close so be aware of that
				see which one clicks off first...
				you will probably have to do the same thing for both :/
			*/
			if(!found.len)
				Break
			if(found.SkipOpen)
				skip:=1
			if(!skip)
				total.=found.0 "`n"
			if(found.SkipClose)
				Skip:=0
			count:=0
			if(found.close){
				for a,b in StrSplit(found.0){
					if(b~="\s|}"=0)
						break
					if(b="}")
						brace--
				}
				if(found.6="{")
					alt:=1
				if(brace<=0)
					Break
				if(found.6="{")
					brace++
			}
			if(found.open)
				brace++
			if(brace<=0)
				Break
		}
		if(ReturnClass)
			return {start:start,length:(alt?found.pos(1):found.pos(0)+found.len(0))-(start-1)}
		if(brace>0)
			return SubStr(FileText,start)
		return SubStr(FileText,start,(alt?found.pos(1):found.pos(0)+found.len(0))-(start-1))
	}
}
GetControl(ctrl){
	if(!node:=MainWin.gui.SSN("//*[@hwnd='" ctrl "']"))
		node:=MainWin.gui.SSN("//*[@hwnd='" ctrl+0 "']")
	return node
}
GetCurrentClass(Line){
	ScanFile.RemoveComments(Current(3),,1),Text:=ScanFile.CurrentText,b:=v.OmniFind[Current(3).Lang].Class,Pos:=LastPos:=1
	while(RegExMatch(Text,b.regex,Found,Pos),Pos:=Found.Pos(0)+Found.Len(0)){
		if(Pos=LastPos)
			Break
		LastPos:=Pos
		if(b.Open){
			Search:=b.Open,Start:=Pos1:=Found.Pos(1),Open:=LastPos1:=0,Bounds:=b.Bounds
			Loop
			{
				RegExMatch(Text,b.Open,OpenObj,Pos1),RegExMatch(Text,b.Close,Close,Pos1),OP:=OpenObj.Pos(1),CP:=Close.Pos(1)
				if(!OP||!CP)
					Break
				if(CP<OP)
					Pos1:=CP+Close.Len(1),FoundSearch:=Close.0,FIS:="Close"
				else
					Pos1:=OP+OpenObj.Len(1),FoundSearch:=OpenObj.0,FIS:="Open"
				RegExReplace(FoundSearch,"(" Bounds ")",,Count)
				if(Count){
					Open+=FIS="Open"?+Count:-Count
					SavedPos:=Pos1
					if(Open<=0)
						Break
				}if(Pos1=LastPos1)
					Break
				LastPos1:=Pos1
		}}if(InStr(SubStr(Text,Start,SavedPos-Start),Chr(127)))
			return Show_Class_Methods(Found.1)
	}
}			
GetID(){
	static ID:=0
	return ++ID
}
GetInclude(){
	main:=Current(2).file,sc:=csc()
	SplitPath,main,,dir
	FileSelectFile,filename,,%dir%,Select a file to include,*.ahk
	if(ErrorLevel||filename="")
		return
	newfile:=filename~="\.ahk$"?filename:filename ".ahk"
	Relative:=RelativePath(SSN(Current(),"@file").text,newfile)
	Encode(" " Relative,return),sc.2003(sc.2008,&return)
	Gui,1:Default
	Gui,1:TreeView,SysTreeView321
	if(!FileExist(newfile)){
		SplitPath,newfile,,dir
		if(!FileExist(dir))
			FileCreateDir,%dir%
		FileAppend,,%newfile%,UTF-8
	}Save(),Extract(main),ScanFiles(),FEUpdate(1) ;#[May Need Changed]
}
GetOTB(search){
	sc:=csc(),FileText:=sc.GetUNI(),find:=v.OmniFindText.Class,searchtext:=find.1 (IsObject(search)?search.2:search) find.2
	if(RegExMatch(FileText,searchtext,found)){
		pos:=found.pos(1),start:=StrPut(SubStr(FileText,1,found.pos(1)),"UTF-8")-1
		while(RegExMatch(FileText,"OUm`n)((?<SkipClose>^\s*\Q*/\E)|(?<SkipOpen>^\s*\Q/*\E)|(?<Close>^\s*}.*((\{)\s*(;.*)*)*)$)|((?<Open>.*\{)(\s+;.*)*(\s*)*$)",found,pos)),pos:=found.pos(0)+found.len(0){
			lastfound:=found
			if(!found.len)
				Break
			if(found.SkipOpen)
				skip:=1
			if(!skip)
				total.=found.0 "`n"
			if(found.SkipClose)
				Skip:=0
			count:=0
			if(found.close){
				for a,b in StrSplit(found.0){
					if(b~="\s|}"=0)
						break
					if(b="}")
						brace--
				}
				if(found.6="{")
					brace++
			}
			if(found.open)
				brace++
			if(brace<=0)
				Break
		}
		return {start:start,text:SubStr(FileText,start,lastfound.pos(0)+lastfound.len(0)-(start-1))}
	}
}
GetPos(Node:=0){
	if(!Current(1).xml)
		return
	sc:=csc(),cf:=Current(3).file
	if(!files.SSN("//*[@sc='" sc.2357 "']"))
		return
	if(!cf)
		return
	if(!Node)
		if(!Node:=Positions.Find("descendant::file/@file",cf))
			Node:=Positions.Under(positions.SSN("//*"),"file",{file:cf})
	for a,b in {start:sc.2008,end:sc.2009,scroll:sc.2152,file:SSN(Node,"@file").text}
		Node.SetAttribute(a,b)
	fold:=0,Node.RemoveAttribute("fold")
	while(sc.2618(fold)>=0,fold:=sc.2618(fold))
		list.=fold ",",fold++
	if(list)
		Node.SetAttribute("fold",Trim(list,","))
	return Node
}
GetRange(start,otext){
	start:=start-3>=0?start-3:0
	Loop,6
		text.=otext[start+(A_Index-1)]
	return text
}
GetTemplate(){
	ts:=Settings.SSN("//template").text,file:=FileOpen("c:\windows\shellnew\template.ahk",0),td:=file.Read(file.length),file.Close()
	return template:=ts?ts:RegExReplace(td,"\R","`n")
}
GetTotal(obj,line){
	total:=obj[line+1] "`n"
	for a,b in obj{
		if(a<line)
			Continue
		if(Trim(b))
			total.=b "`n"
		if(InStr(b,"{"))
			Break
	}
	return total
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
	sc:=csc(),InsertAll(",",1),list:=SN(cexml.Find("//file/@file",Current(3).file),"descendant::info[@type='Label']"),labels:=""
	while,ll:=list.item[A_Index-1]
		labels.=cexml.EA(ll).text " "
	Sort,labels,D%A_Space%
	if(Trim(Labels))
		sc.2100(0,Trim(labels))
	return
}
GoToPos(caret,pos){
	sc:=csc(),sc.2584(caret,pos),sc.2586(caret,pos)
}
Gui(){
	/*
		if(!Settings.SSN("//theme|//fonts"))
			DefaultFont(),ConvertTheme()
	*/
	Options("Auto_Advance")
	v.startup:=1,this:=MainWin:=New MainWindowClass(1),ea:=Settings.EA("//theme/descendant::*[@style=32]"),win:=1,Plug()
	if(!this.Gui.SSN("//control"))
		Gui,Show,Hide
	if(!Settings.SSN("//autoadd")){
		layout:=DllCall("GetKeyboardLayout",int,0),AltGR:=0
		if(layout&0xff!=9)
			if(m("Does your keyboard contain the AltGR key (AKA Alt Graph, Alt Graphic, Alt Graphics, Alt Char)","btn:yn")="Yes")
				AltGR:=1
		top:=Settings.Add("autoadd",{altgr:Round(AltGR)}),layout:={0:{"[":"]","{":"}",(Chr(34)):Chr(34),"'":"'","(":")"},1:{"<^>[":"]","<^>{":"}",(Chr(34)):Chr(34),"'":"'","(":")"}}
		for a,b in layout[AltGR]
			Settings.Under(top,"key",{trigger:a,add:b})
		opt:=Settings.Add("options")
		for a,b in StrSplit("Manual_Continuation_Line,Full_Auto_Indentation,Focus_Studio_On_Debug_Breakpoint,Word_Wrap_Indicators,Context_Sensitive_Help,Auto_Complete,Auto_Complete_In_Quotes,Auto_Complete_While_Tips_Are_Visible",",")
			opt.SetAttribute(b,1),v.Options[b]:=1
	}BraceSetup(),open:=Settings.SN("//open/file")
	while(oo:=open.item[A_Index-1])
		t("Opening: " oo.text,"Please Wait"),Extract(oo.text),opened:=1
	t()
	if(!opened)
		New("","",0),FocusNew:=1
	FEList:=files.SN("//main")
	Hotkeys(),Index_Lib_Files(),FEUpdate()
	if((list:=this.Gui.SN("//win[@win='" win "']/descendant::control")).length){
		this.Rebuild(list),ea:=this.gui.EA("//*[@type='Tracked Notes']"),this.SetWinPos(ea.hwnd,ea.x,ea.y,ea.w,ea.h,ea),this.Theme(),all:=MainWin.gui.SN("//*[@type='Scintilla' and @file]")
		while(aa:=all.item[A_Index-1]),ea:=XML.EA(aa){
			files.Find("//file/@file",ea.file).SetAttribute("sc",s.ctrl[ea.hwnd].2357)
			if(ea.file){
				pea:=XML.EA(nn:=positions.Find("//file/@file",ea.file))
				if(pea.start=""||pea.end="")
					SetPos({scroll:0,start:0,end:0,sc:ea.hwnd})
				else
					SetPos({scroll:pea.scroll,start:pea.start,end:pea.end,sc:ea.hwnd})
		}}if(last:=this.Gui.SSN("//*[@last]/@hwnd").text)
			s.ctrl[last].2400
		SetTimer,ScanFiles,-400
		ObjRegisterActive(PluginClass)
		SetTimer,SetTN,-600
		if(FocusNew)
			SetTimer,FocusNew,-100
		if(Node:=files.Find("//file/@file",v.OpenFile))
			tv(SSN(Node,"@tv").text)
		return this
	}if(Node:=files.Find("//file/@file",v.OpenFile))
		tv(SSN(Node,"@tv").text,m(Node.xml))
	this.qfhwnd:=this.QuickFind(),sc:=new s(1,{pos:"x0 y0 w100 h100"}),this.Add(sc.sc,"Scintilla"),sc.2277(v.Options.End_Document_At_Last_Line),this.test:=sc.sc,this.Pos(),Redraw(),ObjRegisterActive(PluginClass)
	/*
		if(FocusNew)
			tv(files.SSN("//*[@untitled]/@tv").text)
	*/
	SetTimer,SetTN,-600
	return
	FocusNew:
	tv(files.SSN("//*[@untitled]").text)
	return
	SetTN:
	/*
		ControlGetFocus,focus,% hwnd([1])
		ControlGet,hwnd,hwnd,,%focus%,% hwnd([1])
	*/
	TNotes.Set(),MarginWidth()
	SetTimer,ScanWID,-10
	SetupEnter(1),csc({Set:1})
	MainWin.Size(1)
	all:=menus.SN("//*[@startup]")
	while(aa:=all.item[A_Index-1],ea:=XML.EA(aa)){
		if(FileExist(ea.plugin))
			Run,% ea.plugin
		else
			aa.ParentNode.RemoveChild(aa)
	}
	return
}
exit:
Exit()
return
class GUIKeep{
	static table:=[],showlist:=[],Displays:=new XML("displays")
	__Get(){
		return this.Add()
	}__New(win,parent:=""){
		info:=PluginClass.Style(),owner:=WinExist("ahk_id" parent)?parent:"" ;hwnd(1)
		if(FileExist(A_ScriptFullPath "\AHKStudio.ico"))
			Menu,Tray,Icon,%A_ScriptFullPath%\AHKStudio.ico
		owner:=owner?owner:1
		Gui,%win%:Destroy
		Gui,%win%:+owner%owner% +hwndhwnd -DPIScale
		Gui,%win%:+ToolWindow
		hwnd(win,hwnd)
		if(Settings.SSN("//options/@Add_Margins_To_Windows").text!=1)
			Gui,%win%:Margin,0,0
		Gui,%win%:Font,% "c" info.color " s" info.size,% info.font
		Gui,%win%:Color,% info.Background,% info.Background
		this.xml:=new XML("gui"),this.XML.Add("window",{name:win}),this.gui:=[],this.sc:=[],this.hwnd:=hwnd,this.con:=[],this.ahkid:=this.id:="ahk_id" hwnd,this.win:=win,this.Table[win]:=this,this.var:=[],this.classcount:=[]
		for a,b in {border:A_OSVersion~="^10"?3:0,caption:DllCall("GetSystemMetrics",int,4,"int")}
			this[a]:=b
		Gui,%win%:+LabelGUIKeep.
		Gui,%win%:Default
	}Add(info*){
		static
		if(!info.1){
			var:=[]
			Gui,% this.win ":Submit",Nohide
			for a in this.var
				var[a]:=%a%
			return var
		}
		for a,b in info{
			i:=StrSplit(b,","),newpos:=""
			if(i.1="SetTab"){
				if(i.2=0){
					Gui,% this.win ":Tab"
					node:=""
					Continue
				}if(!node:=this.XML.SSN("//tab[@tab='" i.2 "']"))
					node:=this.XML.Add("tab",{tab:i.2},,1)
				Gui,% this.win ":Tab",% i.2
				Continue
			}
			if(i.1="sc"){
				for a,b in StrSplit("xywh")
					RegExMatch(i.2,"i)\b" b "(\S*)\b",found),newpos.=found1!=""?b found1 " ":""
				sc:=new SettingsScintilla(this.win,{pos:Trim(newpos)}),this.sc.push(sc),hwnd:=sc.sc
				if(i.3)
					GuiControl,% this.win ":+g" i.3,% sc.sc
			}else if(i.1="s"){
				for a,b in StrSplit("xywh")
					RegExMatch(i.2,"i)\b" b "(\S*)\b",found),newpos.=found1!=""?b found1 " ":""
				sc:=new s(this.win,{pos:Trim(newpos)}),this.sc.push(sc),hwnd:=sc.sc
				if(i.3)
					GuiControl,% this.win ":+g" i.3,% sc.sc
			}else{
				Gui,% this.win ":Add",% i.1,% i.2 " hwndhwnd",% i.3
				WinGetClass,class,ahk_id%hwnd%
				count:=this.classcount[class]:=Round(this.classcount[class])+1
				RegExMatch(i.2,"U)\bg(.*)\b",label)
				if(node)
					new:=this.XML.Under(node,"control",{hwnd:hwnd,class:class count,label:label1})
				else
					new:=this.XML.Add("control",{hwnd:hwnd,class:class count,label:label1},,1)
				if(RegExMatch(i.2,"U)\bv(.*)\b",var))
					this.var[var1]:=1
			}this.con[hwnd]:=[]
			if(i.4!="")
				this.con[hwnd,"pos"]:=i.4,this.resize:=1
			if(i.5)
				new.SetAttribute("id",i.5)
			if(i.6)
				new.SetAttribute("type",i.6)
	}}
	Close(a:=""){
		this:=GUIKeep.table[A_Gui]
		if(IsFunc(func:=A_Gui "Close"))
			return %func%()
		else if(IsLabel(label:=A_Gui "Close")){
			SetTimer,%label%,-1
		}else
			this.SavePos(),this.Exit()
	}
	DropFiles(filelist,ctrl,x,y){
		df:="DropFiles"
		if(IsFunc(df))
			%df%(filelist,ctrl,x,y)
	}
	GetPos(){
		Gui,% this.win ":Show",AutoSize Hide
		WinGet,cl,ControlListHWND,% this.ahkid
		pos:=this.WinPos(),ww:=pos.w,wh:=pos.h,flip:={x:"ww",y:"wh"}
		for index,hwnd in StrSplit(cl,"`n"){
			obj:=this.Gui[hwnd]:=[]
			ControlGetPos,x,y,w,h,,ahk_id%hwnd%
			for c,d in StrSplit(this.con[hwnd].pos)
				d~="w|h"?(obj[d]:=%d%-w%d%):d~="x|y"?(obj[d]:=%d%-(d="y"?wh+this.Caption+this.Border:ww+this.Border))
		}
		Gui,% this.win ":+MinSize"
	}
	Escape(){
		this:=GUIKeep.table[A_Gui]
		KeyWait,Escape,U
		if(IsFunc(func:=A_Gui "Escape"))
			return %func%()
		else if(IsLabel(label:=A_Gui "Escape"))
			SetTimer,%label%,-1
		else
			this.SavePos(),this.Exit()
	}
	Exit(){
		this.SavePos(),hwnd({rem:this.win})
	}
	SavePos(){
		if(!top:=Settings.SSN("//gui/position[@window='" this.win "']"))
			top:=Settings.Add("gui/position",,,1),top.SetAttribute("window",this.win)
		top.text:=this.WinPos().text
	}
	SetWinPos(){
		DllCall("SetWindowPos",int,ctrl,int,0,int,x,int,y,int,w,int,h,uint,(ea.type~="Project Explorer|Code Explorer|QF")?0x0004|0x0010|0x0020:0x0008|0x0004|0x0010|0x0020),DllCall("RedrawWindow",int,ctrl,int,0,int,0,uint,0x401|0x2)
	}
	GetDisplays(){
		SysGet,mon,MonitorCount
		Displays:=GUIKeep.Displays
		if(Displays.SSN("//displays/@count").text!=mon){
			rem:=Displays.SSN("//monitors"),rem.ParentNode.RemoveChild(rem),top:=Displays.Add("monitors"),Displays.SSN("//displays").SetAttribute("count",mon)
			Loop,%mon%
			{
				SysGet,mon,Monitor,%A_Index%
				Displays.Under(top,"monitor",{number:A_Index,l:monleft,t:montop,r:monright,b:monbottom})
			}
		}
		return GUIKeep.Displays
	}Show(name,position:="",NA:=0,Select:=0){
		static defpos,pos,sel,nn,Displays
		defpos:=position,this.GetPos(),pos:=this.resize=1?"":"AutoSize",this.name:=name,sel:=Select,this.NA:=NA
		Displays:=this.GetDisplays()
		if(this.resize=1)
			Gui,% this.win ":+Resize"
		GUIKeep.showlist.Push(this)
		SetTimer,GUIKeepShow,-1
		return
		GUIKeepShow:
		while,this:=GUIKeep.Showlist.pop(){
			position:=(node:=Settings.SSN("//gui/position[@window='" this.win "']")).text,position:=position?position:defpos,win:=[]
			for a,b in ["x","y","w","h"]
				RegExMatch(position,"Oi)" b "(-?\d*)\b",found),win[b]:=found.1
			if(!Displays.SSN("//*[(@l<" win.x " or @l<" win.x+win.w ") and @r>" win.x " and (@t<=" win.y " or @t<=" win.y+win.h ") and @b>" win.y "]")){
				position:="xCenter yCenter"
				if(win.w)
					position.=" w" win.w
				if(win.h)
					position.=" h" win.h
			}NA:=this.NA?"NA":""
			Gui,% this.win ":Show",% position " " pos " " NA,% this.name
			if(sel)
				SendMessage,0xB1,%sel%,%sel%,Edit1,% this.id
			this.Size()
			if(this.resize!=1)
				Gui,% this.win ":Show",AutoSize NA
			if(!NA)
				WinActivate,% this.id
		}return
	}Size(){
		this:=GUIKeep.table[A_Gui],pos:=this.WinPos()
		for a,b in this.gui
			for c,d in b
				GuiControl,% this.win ":MoveDraw",%a%,% c (c~="y|h"?pos.h:pos.w)+d
	}WinPos(){
		VarSetCapacity(rect,16),DllCall("GetClientRect",ptr,this.hwnd,ptr,&rect)
		WinGetPos,x,y,,,% this.ahkid
		w:=NumGet(rect,8,"int"),h:=NumGet(rect,12,"int"),text:=(x!=""&&y!=""&&w!=""&&h!="")?"x" x " y" y " w" w " h" h:""
		return {x:x,y:y,w:w,h:h,text:text}
	}
}
Header(type){
	node:=Current(7)
	if(!header:=SSN(node,"descendant::header[@type='" type "']/@cetv").text)
		cexml.Under(node,"header",{cetv:(header:=TVC.Add(2,type,SSN(node,"@cetv").text,"Sort")),type:type})
	return header
}
Highlight_to_Matching_Brace(){
	sc:=csc()
	if((start:=sc.2353(sc.2008-1))>0)
		return sc.2160(start,sc.2008)
	Else if((start:=sc.2353(sc.2008))>0)
		sc.2160(start+1,sc.2008)
}
History(Node,ctrl:=""){
	if(Node="Startup"||Node="Clear")
		return History.XML.LoadXML("<HistoryXML/>")
	ea:=XML.EA(Node),Nodes:=GetHistoryTop()
	if(SSN(Nodes.Back,"file[last()]/@sc").text!=ea.sc)
		History.Under(Nodes.Back,"file",{id:ea.ID,tv:ea.tv,sc:ea.sc},,1),Nodes.Forward.ParentNode.RemoveChild(Nodes.Forward)
	return
	Back:
	Nodes:=GetHistoryTop()
	if(SN(Nodes.Back,"descendant::*").length>1)
		Nodes.Forward.AppendChild(SSN(Nodes.Back,"file[last()]")),tv([SSN(Nodes.Back,"file[last()]/@tv").text])
	return
	Forward:
	Nodes:=GetHistoryTop()
	if(Node:=SSN(Nodes.Forward,"file[last()]"))
		Nodes.Back.AppendChild(Node),tv([SSN(Nodes.Back,"file[last()]/@tv").text])
	return
}GetHistoryTop(){
	if(!Node:=History.SSN("//Control[@sc='" (sc:=csc().sc) "']"))
		Node:=History.Add("Control",{sc:sc},,1)
	if(!Back:=SSN(Node,"back"))
		Back:=History.Under(Node,"back")
	if(!Forward:=SSN(Node,"forward"))
		Forward:=History.Under(Node,"forward")
	return {top:Node,Back:Back,Forward:Forward}
}
HltLine(){
	static ranges:=[]
	if(!v.Options.Highlight_Current_Area)
		return
	sc:=csc(),line:=sc.2166(sc.2008)
	if((parent:=sc.2225(line))>=0){
		last:=sc.2224(parent,-1),range:=ranges[sc.2357],sc.2045(3),sc.2043(line,3)
		if(range.parent=parent&&range.last=last)
			return
		sc.2045(2),sc.2045(3)
		Loop,% last-parent+1
			sc.2043(parent+(A_Index-1),2)
		sc.2043(line,3),ranges[sc.2357]:={parent:parent,last:last}
	}else if(sc.2047(0,2**2)>=0)
		sc.2045(2),sc.2045(3)
	return
}
Hotkeys(win:=1,keys:=""){
	static LastHotkeys:=[],Associate:=[]
	Associate:=[]
	Hotkey,IfWinActive,% hwnd([win])
	for a in LastHotkeys[win]
		Hotkey,%a%,HotkeyLabel,Off
	LastHotkeys.Delete(win)
	if(!keys){
		Hotkeys:=menus.SN("//@hotkey")
		while(hh:=Hotkeys.item[A_Index-1]),ea:=XML.EA(hh){
			if(hh.text)
				Try{
					Hotkey,% hh.text,HotkeyLabel,On
					LastHotkeys[win,hh.text]:=1
				}
		}
		for a,b in {Delete:"Delete",Backspace:"Backspace","~Escape":"Escape","^a":"SelectAll","^v":"Paste",WheelLeft:"ScrollWheel",WheelRight:"ScrollWheel","~Ctrl":"ToggleDuplicate"}{ ;,Hotkeys(1,Enter)
			Try
			Hotkey,%a%,%b%,On
	}}else{
		for a,b in keys{
			Try{
				if(!a)
					Continue
				Hotkey,%a%,Associate,On
				LastHotkeys[win,a]:=1,Associate[hwnd(win),a]:=b
			}
		}
	}
	for a,b in ["^R","^E"]{
		if(!menus.SSN("//*[@hotkey='" b "']"))
			Try
		Hotkey,%b%,DeadEnd,On
	}
	Hotkey,RButton,RButton,On
	Hotkey,IfWinActive
	return
	Associate:
	action:=Associate[WinExist("A"),A_ThisHotkey]
	SetTimer,%action%,-1
	return
	HotkeyLabel:
	clean:=menus.SSN("//*[@hotkey='" A_ThisHotkey "']/@clean").text
	if(IsFunc(clean)||IsLabel(clean))
		SetTimer,%clean%,-1
	else if(v.alloptions[clean])
		Options(clean)
	/*
		else if(clean="Quick_Scintilla_Code_Lookup"){
			MainWin.Gui.Transform()
			MainWin.Gui.Transform()
			m(MainWin.gui[])
			ExitApp
		}
	*/
	else if(plugin:=menus.EA("//*[@clean='" clean "']")){
		if(!FileExist(plugin.plugin))
			MissingPlugin(plugin.plugin,clean)
		Try
			Run,% plugin.plugin " " (plugin.option?plugin.option:plugin.clean)
	}else
		m("Not yet....Soon....","time:1",clean,menus.SSN("//*[@clean='" clean "']").xml)
	ShowOSD(clean)
	return
	DeadEnd:
	return
}
hwnd(win,hwnd=""){
	static window:=[]
	if(win="get")
		return window
	if(win.rem){
		MainWindowClass.Save(win.rem)
		Gui,1:-Disabled
		if(!window[win.rem])
			Gui,% win.rem ":Destroy"
		Else{
			DllCall("DestroyWindow",uptr,window[win.rem])
		}
		window[win.rem]:=""
		/*
			if(!win.na)
				WinActivate(hwnd([1]))
		*/
	}
	if(IsObject(win))
		return "ahk_id" window[win.1]
	if(!hwnd)
		return window[win]
	window[win]:=hwnd
}
Icons(il,icons,file,icon){
	if(file=""&&icon="")
		return 0
	if((ricon:=icons[file,icon])="")
		ricon:=icons[file,icon]:=IL_Add(il,file,icon)
	return ricon
}
Create_Include_From_Selection(){
	pos:=PosInfo(),sc:=csc()
	if(pos.start=pos.end)
		return m("Please select some text to create a new Include from")
	text:=sc.GetSelText(),RegExMatch(text,"^(\w+)",Include)
	Filename:=SelectFile(RegExReplace(Include1,"_"," ") ".ahk","New Include Filename")
	if(FileExist(Filename))
		return m("Include name already exists. Please choose another")
	if(files.Find(Current(1),"//@file",Filename))
		return m("This file is already included in this Project")
	sc.2326(),AddInclude(Filename(Filename),text,{start:StrPut(Include1 "(","UTF-8")-1,end:StrPut(Include1 "(","UTF-8")-1},0)
}
Include(MainFile,File){
	Relative:=RelativePath(MainFile,Filename(file))
	return "#Include " (SubStr(Relative,1,InStr(Relative,"\",0,0,1))="lib\"?"<" SplitPath(file).nne ">":relative)
}
Increment(){
	crement([9,1])
}
Decrement(){
	crement([0,-1])
}crement(add){
	sc:=csc(),sc.2078(),sc.Enable()
	loop,% sc.2570
	{
		start:=sc.2585(A_Index-1),end:=sc.2587(A_Index-1),end:=end=start?end+1:end,begin:=0,conclude:=0,text:=sc.TextRange(start,end)
		if(text~="(\d)"){
			while(Chr(sc.2007(start))=add.1)
				start--
			text:=sc.TextRange(start,end)
			if(RegExReplace(text,"-")~="\D")
				start++,text:=sc.TextRange(start,end)
			sc.2686(start,end),sc.2194(StrLen(text+add.2),[text+add.2]),sc.2584(A_Index-1,start),sc.2586(A_Index-1,end+(StrLen(text+add.2)-StrLen(text)))
		}
	}
	sc.Enable(1),sc.2079()
	return
}
/*
	Settings.SSN(a)
	Activate(a,b,c)
	text(text)text{text}text"text"
	text(text)text{text}text"text"
	text(text)text{text}text"text"
	MsgBox,hello
*/
;comments
IndentFrom(line){
	sc:=csc()
	begin:=sc.2127(line)
	FileText:=sc.TextRange(sc.2167(line),sc.2006)
	;m("Start at line: " line,"Indentation: " begin,"Text:",FileText)
}
Index_Lib_Files(){
	SplitPath,A_AhkPath,,ahkdir
	ahkdir.="\lib\",temp:=new xml("lib"),allfiles:=[],rem:=cexml.SSN("//lib"),rem.ParentNode.RemoveChild(rem),main:=files.Add("main",{file:"Libraries",id:GetID()},,1)
	for a,b in [A_MyDocuments "\AutoHotkey\Lib\",ahkdir]{
		Loop,%b%*.ahk
		{
			file:=A_LoopFileLongPath
			if(InStr(file,"'"))
				Continue
			SplitPath,file,filename,dir,Ext,nne
			if(filename="Studio.ahk")
				Continue
			FileGetTime,time,%file%
			new:=files.Under(main,"file",{file:file,dir:dir,ext:Ext,filename:filename,lang:LanguageFromFileExt(Ext),nne:nne,inside:"Libraries",scan:1,id:GetID()}),fff:=FileOpen(file,"R"),encoding:=fff.encoding,text:=fff.read(fff.length),fff.Close(),dir:=Trim(dir,"\"),new.SetAttribute("time",time),new.SetAttribute("encoding",encoding)
			StringReplace,text,text,`r`n,`n,All
			if(!Update({get:file}))
				Update({file:file,text:text,load:1,encoding:encoding})
}}}
InputBox(parent,title,prompt,default=""){
	sc:=csc()
	WinGetPos,x,y,,,% "ahk_id" (parent?parent:sc.sc+0)
	RegExReplace(prompt,"\n","",count),count:=count+2,sc:=csc(),height:=(sc.2279(0)*count)+(v.caption*3)+23+34,y:=((cpos:=sc.2165(0,sc.2008))<height)?y+cpos+sc.2279(sc.2166(sc.2008))+5:y
	InputBox,var,%title%,%prompt%,,,%height%,%x%,%y%,,,%default%
	if(ErrorLevel){
		sc.Enable(1)
		Exit
	}
	return var
}
Insert_Current_Time(){
	sc:=csc(),sc.2003(sc.2008,[A_Now]),sc.2025(sc.2008+StrLen(A_Now))
}
InsertAll(text,add){
	sc:=csc(),sc.2078
	Loop,% sc.2570
		InsertMultiple(A_Index-1,(pos:=sc.2585(A_Index-1)),text,pos+add)
	sc.2079
}
InsertDebugMessage(){
	sc:=v.debug
	if(hotkey:=menus.SSN("//*[@clean='Run_Program']/@hotkey").text){
		sc.2003(sc.2006,"Press " Convert_Hotkey(hotkey) " to continue" (debug.VarBrowser?"`n":""))
		Sleep,150
	}else{
		msg:="Click Here to Continue",msg.=debug.VarBrowser?"`n":"",end:=sc.2006(),sc.2003(end,msg)
		sc.2051(150,0xff00ff),sc.2032(end,150),sc.2033(StrPut(msg,"UTF-8")-1,150),sc.2409(150,1)
	}
	if(!debug.VarBrowser){
		if(hotkey:=menus.SSN("//*[@clean='List_Variables']/@hotkey").text)
			sc.2003(sc.2006," : Press " Convert_Hotkey(hotkey) " to show the Variable Browser`n")
		else
			msg:=" : Click Here to Show the Variable Browser`n",end:=sc.2006(),sc.2003(end,msg),sc.2032(end+3,151),sc.2033(StrPut(msg,"UTF-8")-1,151),sc.2409(151,1)
	}
	sc.2025(sc.2006)
}
InsertMultiple(caret,cpos,text,end){
	sc:=csc(),sc.2686(cpos,cpos),sc.2194(StrPut(text,"UTF-8")-1,text),sc.2584(caret,end),sc.2586(caret,end)
}
Jump_To_First_Available(){
	sc:=csc(),line:=sc.GetLine(sc.2166(sc.2008))
	/*
		Scan_Line()
	*/
	v.jtfa:=[]
	if(RegExMatch(line,"Oi)^\s*\x23include\s*(.*)(\s*;.*)?$",found))
		Jump_To_Include()
	else{
		word:=Upper(sc.GetWord()),root:=Current(7)
		if(SubStr(word,1,1)="g"&&node:=SSN(root,"descendant::*[@upper='" Upper(SubStr(word,2)) "' and(@type='Label' or @type='Function')]"))
			return CEXMLSel(node),SelectText(node,1)
		all:=cexml.SN("//*[@upper='" Word "']")
		if(all.length=1)
			SelectText(all.item[0],1)
		else{
			while(aa:=all.item[A_Index-1],ea:=XML.EA(aa))
				total.=(info:=ea.type " " StrSplit(SSN(aa,"ancestor-or-self::file[@file]/@file").text,"\").pop()) "|",v.jtfa[info]:=aa
			sc.2106(124),sc.2117(6,Trim(total,"|")),sc.2106(32)
			if(!InStr(total,"|"))
				sc.2104
		}
		/*
			if(SubStr(word,1,1)="g"&&node:=SSN(root,"descendant::*[@upper='" Upper(SubStr(word,2)) "' and(@type='Label' or @type='Function')]")){
				return CEXMLSel(node),SelectText(node,1)
			}if(sc.2007((pos:=sc.2266(sc.2008,1)-1))=46){
				word2:=Upper(sc.TextRange(sc.2266(pos-1,1),sc.2267(pos-1,1)))
				if(node:=SSN(root,"descendant::*[@upper='" word2 "' and @type='Instance']")){
					if(node:=SSN(root,"descendant::*[@upper='" word "' and @class='" SSN(node,"@class").text "' and @type='Method']"))
						total.=(info:=SSN(node,"@type").text " " StrSplit(SSN(node,"ancestor-or-self::file[@file]/@file").text,"\").pop()) "|",v.jtfa[info]:=node
				}if(node:=SSN(root,"descendant::*[@upper='" word2 "' and @type='Class']")){
					if(node:=SSN(node,"descendant::*[@upper='" word "' and (@type='Method' or @type='Property')]"))
						total.=(info:=SSN(node,"@type").text " " StrSplit(SSN(node,"ancestor-or-self::file[@file]/@file").text,"\").pop()) "|",v.jtfa[info]:=node
				}else if((list:=cexml.SN(root,"descendant::*[@upper='" word "' and @type='Method']")).length){
					while(ll:=list.item[A_Index-1]),ea:=XML.EA(ll)
						total.=(info:=ea.type " " StrSplit(SSN(ll,"ancestor-or-self::file[@file]/@file").text,"\").pop()) "|",v.jtfa[info]:=ll
				}
			}if(node:=SSN(root,"descendant::*[@upper='" word "' and (@type='Function' or @type='Label')]"))
				total.=(info:=SSN(node,"@type").text " " StrSplit(SSN(node,"ancestor-or-self::file[@file]/@file").text,"\").pop()) "|",v.jtfa[info]:=node
			if(node:=SSN(root,"descendant::*[@upper='" word "' and @type='Class']"))
				total.=(info:=SSN(node,"@type").text " " StrSplit(SSN(node,"ancestor-or-self::file[@file]/@file").text,"\").pop()) "|",v.jtfa[info]:=node
			if((list:=cexml.SN(node,"descendant::*[@upper='" word "' and @type!='Method' and @type!='Function']")).length)
				while(ll:=list.item[A_Index-1]),ea:=XML.EA(ll)
					total.=(info:=ea.type " " StrSplit(SSN(ll,"ancestor-or-self::file[@file]/@file").text,"\").pop()) "|",v.jtfa[info]:=ll
			if(total:=Trim(total,"|")){
				sc.2106(124),sc.2117(6,total),sc.2106(32)
				if(!InStr(total,"|"))
					sc.2104
			}
		*/
	}
}Jump_To(type){
	sc:=csc(),line:=sc.GetLine(sc.2166(sc.2008)),word:=Upper(sc.getword())
	if(node:=SSN(Current(7),"descendant::*[@type='" type "' and @upper='" word "']"))
		CEXMLSel(node)
}Jump_To_Function(){
	Jump_To("Function")
}Jump_To_Include(){
	sc:=csc(),line:=sc.GetLine(sc.2166(sc.2008)),tv(SSN(files.Find(Current(1),"descendant::file/@include",Trim(line,"`t`n ")),"@tv").text)
}Jump_To_Label(){
	Jump_To("Label")
}Jump_To_Method(){
	Jump_To("Method")
}Jump_To_Class(){
	Jump_To("Class")
}CEXMLSel(node){
	if(!IsObject(node))
		return
	tv(files.SSN("//*[@id='" SSN(node,"ancestor-or-self::file/@id").text "']/@tv").text),SelectText(Node,1)
}Jump_To_Project(){
	Omni_Search("^")
}Jump_To_Matching_Brace(){
	sc:=csc(),cpos:=sc.2008
	if((pos:=sc.2353(cpos))>=0)
		sc.2025(pos)
	else if((pos:=sc.2353(cpos-1))>=0)
		sc.2025(pos+1)
}
GetFind(Text){
	Start:=InStr(Text,"(?<Text"),Open:=0,Overall:=[]
	for a,b in ["(",")"]{
		Pos:=Start
		while(Pos:=InStr(Text,b,0,Pos))
			Overall[Pos]:=b,Pos++
	}for a,b in Overall{
		(b="(")?(Open++):(Open--)
		if(!Open){
			End:=a
			Break
		}
	}return SubStr(Text,1,Start) "$1" SubStr(Text,End)
}
Class Keywords{
	__New(){
		Static Dates:={ahk:"20171029061149"},BaseURL:="https://raw.githubusercontent.com/maestrith/AHK-Studio/Beta/lib/Languages/",BaseDir:="Lib\Languages\"
		for a,b in StrSplit("IndentRegex,KeywordList,Suggestions,Languages,Comments,OmniOrder,CodeExplorerExempt,Words,FirstChar,Delimiter,ReplaceFirst,SearchTrigger",",")
			Keywords[b]:=[]
		if(!IsObject(v.OmniFind))
			v.OmniFind:=[],v.OmniFindText2:=[]
		if(!FileExist("Lib\Languages"))
			FileCreateDir,Lib\Languages
		/*
			IMPORTANT!!!!!!!!!!!!!!!!!
			Language:=new XML("ahk","lib\Languages\ahk.xml")
			LangDate:="20171011091032"
			if(Language.SSN("//*")&&!Language.SSN("//date"))
				Language.Add("date",,LangDate),Language.Save(1)
			else if(Language.SSN("//date").text!=LangDate){
				FileCreateDir,Lib\Languages
				SplashTextOn,200,100,Downloading AHK.XML,Please Wait
				UrlDownloadToFile,https://raw.githubusercontent.com/maestrith/AHK-Studio/Beta/lib/Languages/ahk.xml,Lib\Languages\ahk.xml
				Language:=new XML("ahk","lib\Languages\ahk.xml"),Language.Add("date",,LangDate),Language.Save(1)
			}
		*/
		
		/*
			download the xml files using URLDownloadToVar()
			check to see if they are valid files First
			if they are
				update the current file
			if not
				continue with the old file unless it is blank then create a new one.
		*/
		
		FileList:={BaseDir "ahk.xml":1}
		Loop,Files,Lib\Languages\*.xml
			FileList[A_LoopFileFullPath]:=1
		Keywords.BreakBook:={Breakpoint:"OU)(\s+|^);\*\[(?<Text>.*)\]",Bookmark:"OU)(\s+|^);#\[(?<Text>.*)\]",multiple:1}
		Keywords.BreakBookFind:={Breakpoint:";\*\[$1\]",Bookmark:";#\[$1\]"}
		BreakBook:={Breakpoint:{Regex:Keywords.BreakBook.Breakpoint,Multiple:1},Bookmark:{Regex:Keywords.BreakBook.Bookmark,Multiple:1}}
		for a in FileList
		{
			xx:=new XML(Language,a)
			SplitPath,a,,,,NNE
			if(Date:=Dates[NNE]){
				if(!FileExist(BaseDir NNE ".xml")){
					Run,RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 8
					SplashTextOn,200,100,Downloading %NNE%.xml,Please Wait...
					URLDownloadToFile,% BaseURL Format("{:L}",NNE) ".xml",%a%
					xx:=new XML(Language,a)
				}if(xx.SSN("//date").text!=Date){
					SplashTextOn,200,100,Downloading %NNE%.xml,Please Wait...
					Run,RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 8
					URLDownloadToFile,% BaseURL Format("{:L}",NNE) ".xml",%a%
					xx:=new XML(Language,a)
				}if(!Node:=xx.SSN("//date"))
					Node:=xx.Add("date")
				Node.text:=Date,xx.Save(1)
				SplashTextOff
			}Lexer:=xx.SSN("//FileTypes")
			Keywords.Languages[(Language:=Format("{:L}",SSN(Lexer,"@language").text))]:=xx
			for i,Ext in StrSplit(Lexer.text," ")
				if(!Settings.SSN("//Extensions/Extension[text()='" Ext "']"))
					Settings.Add("Extensions/Extension",{language:SSN(Lexer,"@language").text},Format("{:L}",Ext),1)
			FileGetTime,Date,%A_LoopFileLongPath%
			if(Settings.SSN("//Languages/" Language "/@date").text!=Date)
				Settings.Add("Languages/" Language),KeyWords.Refresh(Language),Settings.SSN("//Languages/" Language).SetAttribute("date",Date)
			all:=xx.SN("//Code/*"),Find:=v.OmniFind[Language]:=[],Order:=Keywords.OmniOrder[Language]:=[],Index:=0,ExemptList:=""
			while(aa:=all.item[A_Index-1],ea:=XML.EA(aa)){
				Index++
				Keywords.FirstChar[Language,ea.FirstChar].=aa.NodeName "|"
				for a,b in ea{
					Find[aa.NodeName,a]:=(Value:=RegExReplace(b,"\x60n","`n")),Order[Index,aa.NodeName,a]:=Value
					if(a="Regex")
						Find[aa.NodeName,"Find"]:=GetFind(Value)
				}
				Under:=SN(aa,"*")
				if(Under.Length)
					Index++
				while(UU:=Under.item[A_Index-1],ea:=XML.EA(UU)){
					ExemptList.=UU.NodeName "|"
					Keywords.FirstChar[Language,ea.FirstChar].=UU.NodeName "|"
					for a,b in ea{
						Find[UU.NodeName,"Inside"]:=aa.NodeName,Find[UU.NodeName,a]:=(Value:=RegExReplace(b,"\x60n","`n")),Order[Index,aa.NodeName Chr(127) UU.NodeName,a]:=Value
						if(a="Regex")
							Find[UU.NodeName,"Find"]:=GetFind(Value)
					}
			}}Keywords.CodeExplorerExempt[Language]:=Trim(ExemptList,"|")
			for a,b in Keywords.FirstChar[Language]
				Keywords.FirstChar[Language,a]:=Trim(b,"|")
			for a,b in Keywords.BreakBook
				Order[++Index,a,"Regex"]:=b,Order[Index,a,"Find"]:=Keywords.BreakBookFind[a]
			
			
			
			
			for a,b in BreakBook
				for c,d in b
					Find[a,c]:=d
			
			
			
			Search:=""
			for a,b in xx.EA("//Comments")
				KeyWords.Comments[Language,a]:=b
			
			/*
				Search.="(?<" a ">" b ")|"
				m(Search)
			*/
			/*
				KeyWords.Comments[Language]:=RegExReplace(xx.SSN("//Comments").text,"\x60n","`n")
			*/
			Delimiter:=Keywords.Delimiter[Language]:=[]
			for a,b in xx.EA("//Delimiter"){
				Delimiter[a]:=b
				if(a="Replace"){
					if(b~="(\\|\.|\*|\?|\+|\[|\{|\||\(|\)|\^|\$)")
						Add:="\"
					Delimiter.ReplaceRegex:=Add b,Add:=""
				}
			}
			if(Node:=xx.SSN("//ReplaceFirst"))
				Keywords.ReplaceFirst[Language]:=XML.EA(Node)
			Keywords.SearchTrigger[Language]:=xx.SSN("//SearchTrigger").text
		}KeyWords.RefreshPersonal()
		/*
			for a,b in Keywords.CodeExplorerExempt
				m(a,b)
		*/
	}BuildList(Language,Refresh:=0){
		if(IsObject(Keywords.KeywordList[Language])&&!Refresh)
			return
		if(!IsObject(Obj:=Keywords.Obj))
			Obj:=Keywords.Obj:=[]
		Obj[Language]:=[]
		Lang:=this.GetXML(Language)
		Keywords.IndentRegex[Language]:=RegExReplace(Lang.SSN("//Indent").text," ","|")
		if(Optional:=Lang.SSN("//OptionalIndent").text)
			Keywords.IndentRegex[Language].="|" RegExReplace(Optional," ","|")
		if(Keywords.IndentRegex[Language]){
			Key:=Keywords.IndentRegex[Language]
			Sort,Key,UD|
			Keywords.IndentRegex[Language]:=Key
		}Obj:=Keywords.KeywordList[Language]:=[],MainXML:=Keywords.GetXML(Language),Suggestions:=Keywords.Suggestions[Language]:=[],KeywordXML:=MainXML.SN("//Styles/keyword")
		while(kk:=KeywordXML.item[A_Index-1],ea:=XML.EA(kk)){
			KeywordList:=kk.text
			if(ea.add)
				KeywordList.=" " MainXML.SSN(ea.add).text,KeywordList:=Trim(KeywordList)
			Sort,KeywordList,UD%A_Space%
			CamelKeywordList:=KeywordList
			/*
				if(InStr(KeywordList,"SplitPath"))
					m(KeywordList)
			*/
			StringLower,KeywordList,KeywordList
			Obj[ea.Set]:=RegExReplace(KeywordList,"#")
			for a,b in StrSplit(CamelKeywordList," ")
				Suggestions[SubStr(b,1,2)].=b " ",Keywords.Words[Language,b]:=b
		}
	}GetList(Language){
		return Keywords.KeywordList[Language]
	}GetSuggestions(Language,FirstTwo){
		return Keywords.Suggestions[Language,FirstTwo]
	}GetXML(Language){
		return Keywords.Languages[Language]
	}Refresh(Language){
		Lang:=this.GetXML(Language)
		all:=Lang.SN("//Styles/font"),Default:=DefaultFont(1)
		while(aa:=all.item[A_Index-1],ea:=XML.EA(aa)){
			if(Color:=Default.SSN("//font[@style='" ea.style "']/@color").text)
				ea.Color:=Color
			if(!Settings.SSN("//Languages/" Format("{:L}",Language) "/font[@style='" ea.Style "']"))
				ea.Delete("ex"),Settings.Add("Languages/" Format("{:L}",Language) "/font",ea,,1)
		}
	}RefreshPersonal(){
		Keywords.Personal:=Settings.SSN("//Variables").text
	}
}
/*
	Keywords(){
		list:=Settings.SN("//commands/*"),top:=commands.SSN("//Commands/Commands")
		cmd:=Custom_Commands.SN("//Commands/commands"),col:=Custom_Commands.SN("//Color/*"),con:=Custom_Commands.SN("//Context/*")
		while(new:=cmd.item[A_Index-1].CloneNode(1))
			commands.SSN("//Commands/Commands").ReplaceChild(new,commands.SSN("//Commands/commands[text()='" new.text "']"))
		;m(InStr(CommandsText,"ControlGetText"))
		while(new:=col.item[A_Index-1].CloneNode(1))
			commands.SSN("//Color").ReplaceChild(new,commands.SSN("//Color/" new.NodeName))
		while(new:=con.item[A_Index-1].CloneNode(1))
			commands.SSN("//Context").ReplaceChild(new,commands.SSN("//Context/" new.NodeName))
		v.keywords:=[],v.kw:=[],v.custom:=[],colors:=commands.SN("//Color/*")
		CommandsText:=commands.SSN("//Commands/Commands").text
		StringLower,CommandsText,CommandsText
		while(color:=colors.item[A_Index-1]){
			text:=color.text,all.=text " "
			StringLower,text,text
			if(color.NodeName="Commands"){
				CommandsAdd:=text
				Continue
			}
			v.color[color.NodeName]:=text
			RepText:=RegExReplace(text," ","\b|\b")
			CommandsText:=RegExReplace(CommandsText,"(\b" RepText "\b)")
		}
		personal:=Settings.SSN("//Variables").text,all.=personal
		StringLower,per,personal
		v.color.Personal:=Trim(per),v.IndentRegex:=RegExReplace(v.color.indent," ","|"),command:=commands.SSN("//Commands/Commands").text
		Sleep,4
		Loop,Parse,command,%A_Space%,%A_Space%
			v.kw[A_LoopField]:=A_LoopField,all.=" " A_LoopField
		Sort,All,UD%A_Space%
		list:=Settings.SSN("//custom_case_settings").text
		for a,b in StrSplit(list," ")
			all:=RegExReplace(all,"i)\b" b "\b",b)
		Loop,Parse,all,%a_space%
			v.keywords[SubStr(A_LoopField,1,1)].=A_LoopField " "
		v.all:=all,v.context:=[],list:=commands.SN("//Context/*"),v.Directives:=[]
		while,ll:=list.item[A_Index-1]{
			cl:=RegExReplace(ll.text," ","|")
			Sort,cl,UD|
			v.context[ll.NodeName]:=cl
		}for a,b in StrSplit(commands.SSN("//Directives").text," ")
			b:=SubStr(b,2),v.Directives[b]:=b
		while(RegExMatch(CommandsText,"\s#\s"))
			CommandsText:=RegExReplace(CommandsText,"\s#\s"," ")
		CommandsText:=RegExReplace(CommandsText,"(\s{2,})"," "),v.Color.Commands:=CommandsText " " CommandsAdd
		return
	}
*/
Kill_Process(){
	WinGet,AList,List,ahk_class AutoHotkey
	Loop,%AList%{
		ID:=AList%A_Index%
		WinGetTitle,ATitle,ahk_id%ID%
		if(Trim(SubStr(ATitle,1,InStr(ATitle,"-",0,0,1)-1))=Current(2).file){
			PostMessage,0x111,65405,0,,ahk_id%id%
			Break
		}
	}
}
LastFiles(){
	rem:=Settings.SSN("//last"),rem.ParentNode.RemoveChild(rem)
	for a,b in s.main{
		file:=files.SSN("//*[@sc='" b.2357 "']/@file").text
		if(file)
			Settings.Add("last/file",,file,1)
	}
}
LButton(a*){
	if(!GetKeyState("LButton"))
		MouseClick,Left,,,,,U
	if(WinExist(hwnd([20])))
		hwnd({rem:20})
	return 0
}
List_Variables(){
	if(!debug.socket)
		return m("Currently no file being debugged","time:1"),debug.off()
	VarBrowser(),debug.Send("stack_get")
}
Manage_File_Types(){
	new SettingsClass("Manage File Types")
}
Margin_Left(set:=0){
	sc:=csc()
	if(set){
		sc.2155(0,Round(Settings.SSN("//marginleft").text))
		return
	}
	margin:=sc.2156(),number:=InputBox(sc.sc,"Left Margin","Enter a new value for the left margin",margin!=""?margin:6)
	if(number="")
		return
	Settings.Add("marginleft","",number),Margin_Left(1)
}
MarginWidth(sc=""){
	sc:=sc?sc:csc(),sc.2242(0,sc.2276(33,"a" sc.2154()))
}
Menu_Help(){
	static help,newwin
	help:=new XML("help","lib\Help Menu.xml"),current:=new XML("current"),current.XML.LoadXML(x.get("menus"))
	newwin:=new GUIKeep("Menu_Help"),newwin.Add("TreeView,w300 h300 gMHSelect,,h","Edit,x+M w300 h300,,wh","Button,xm gUpdateHelp,Update Help File,y")
	if(!FileExist("lib\Help Menu.xml"))
		gosub,UpdateHelp
	newwin.Show("Menu Help")
	goto,MHPopulate
	return
	MHSelect:
	if(A_GuiEvent="S"){
		Default("SysTreeView321","Menu_Help"),node:=help.SSN("//*[@tv='" TV_GetSelection() "']"),text:=SSN(node,"descendant::*")?RegExReplace(SSN(node,"@clean").text,"_"," "):node.text
		GuiControl,Menu_Help:,Edit1,%text%
	}
	return
	UpdateHelp:
	SplashTextOn,200,75,Downloading Help Menu.xml,Please Wait...
	UrlDownloadToFile,https://raw.githubusercontent.com/maestrith/AHK-Studio/master/lib/Help Menu.xml,lib\Help Menu.xml
	SplashTextOff
	help:=new XML("help","lib\Help Menu.xml")
	if(!help.SSN("//menu"))
		return m("Unable to download the control file, Please try again.")
	goto,MHPopulate
	return
	MHPopulate:
	Default("SysTreeView321","Menu_Help"),TV_Delete(),all:=help.SN("//main/descendant::*")
	while,aa:=all.item[A_Index-1],ea:=XML.EA(aa)
		if(aa.nodename!="separator")
			aa.SetAttribute("tv",TV_Add(RegExReplace(ea.clean,"_"," "),SSN(aa.ParentNode,"@tv").text))
	return
}
Menu_Search(){
	Omni_Search("@")
}Add_Function_Call(){
	Omni_Search("+")
}Function_Search(){
	Omni_Search("(")
}Bookmark_Search(){
	Omni_Search("#")
}Variable_Search(){
	Omni_Search("%")
}Hotkey_Search(){
	Omni_Search("&")
}Property_Search(){
	Omni_Search(".")
}Instance_Search(){
	Omni_Search("<")
}Method_Search(){
	Omni_Search("[")
}Class_Search(){
	Omni_Search("{")
}File_Search(){
	Omni_Search("^")
}
Menu(menuname:="main"){
	v.available:=[],menu:=menus.SN("//" menuname "/descendant::*"),topmenu:=menus.SN("//" menuname "/*"),track:=[],exist:=[],Exist[menuname]:=1
	if(!top:=v.hkxml.SSN("//win[@hwnd='" hwnd(1) "']"))
		top:=v.hkxml.Add("win",{hwnd:hwnd(1)},,1)
	Disable:=[]
	Menu,%menuname%,UseErrorLevel,On
	while,mm:=topmenu.item[A_Index-1],ea:=XML.EA(mm)
		if(mm.HasChildNodes())
			Menu,% ea.name,DeleteAll
	Menu,%menuname%,DeleteAll
	while,aa:=menu.item[A_Index-1],ea:=XML.EA(aa),pea:=XML.EA(aa.ParentNode){
		parent:=pea.name?pea.name:menuname
		if(ea.hide)
			Continue
		if(!aa.HasChildNodes()){
			if(aa.nodename="separator"){
				Menu,%parent%,Add
				Continue
			}if((!IsFunc(ea.clean)&&!IsLabel(ea.clean))&&!ea.plugin&&!v.options.HasKey(ea.clean)){
				Disable[parent,ea.name (ea.hotkey?"`t" Convert_Hotkey(ea.hotkey):"")]:=1
				aa.SetAttribute("no",1) ;,fixlist.=ea.clean "`n"
				aa.SetAttribute("delete",1)
				Continue
			}if(ea.no)
				aa.RemoveAttribute("no")
			exist[parent]:=1
		}v.available[ea.clean]:=1,(aa.HasChildNodes())?(track.push({name:ea.name,parent:parent,clean:ea.clean}),route:="deadend",aa.SetAttribute("top",1)):(route:="MenuRoute")
		if(ea.hotkey)
			new:=v.hkxml.Under(top,"hotkey",{hotkey:ea.hotkey,action:ea.clean})
		hotkey:=ea.hotkey?"`t" Convert_Hotkey(ea.hotkey):""
		Menu,%parent%,Add,% ea.name hotkey,menuroute
		if(Disable[parent,ea.name hotkey]){
			Menu,%parent%,Icon,% ea.name hotkey,Shell32.dll,23
			Menu,%parent%,Disable,% ea.name hotkey
		}if(value:=Settings.SSN("//options/@" ea.clean).text){
			v.Options[ea.clean]:=value
			Menu,%parent%,ToggleCheck,% ea.name hotkey
		}if(ea.icon!=""&&ea.filename)
			Menu,%Parent%,Icon,% ea.name hotkey,% ea.filename,% ea.icon
	}for a,b in track{
		if(!Exist[b.name])
			Menu,% b.parent,Delete,% b.name
		Menu,% b.parent,Add,% b.name,% ":" b.name
	}
	Gui,1:Menu,%menuname%
	return menuname
	MenuRoute:
	item:=Clean(A_ThisMenuItem),ea:=menus.EA("//*[@clean='" item "']"),plugin:=ea.plugin,option:=ea.option
	ShowOSD(item)
	if(IsFunc(item)||IsLabel(item))
		SetTimer,%item%,-1
	else if(plugin){
		if(!FileExist(plugin))
			MissingPlugin(plugin,A_ThisMenuItem)
		Run,% plugin " " (option?option:item)
	}
	else if(v.Options.HasKey(item)){
		Options(item)
	}
	else
		m("nope, add it :(",item)
	ShowOSD(item)
	/*
		if(plugin){
			if(!FileExist(plugin))
				MissingPlugin(plugin,item)
			else
				SplitPath,plugin,,dir
			dir:=(dir="plugins")?"":dir
			Run,"%plugin%" %option%,%dir%
		}
		return
		}else if(IsFunc(item)||IsLabel(item))
			SetTimer,%item%,-1
		else
			Options(item)
	*/
	return
	show:
	/*
		WinActivate(hwnd([1]))
	*/
	return
}
MenuActions(){
	static SMM
	SWAction:
	Default("SysListView323","Settings"),LV_GetText(text,LV_GetNext())
	if(action:=SettingsWindow.CommandList[text].2)
		goto,%action%
	return
	AddNewMenu:
	top:=menus.SSN("//main"),info:=InputBox(this.hwnd,"New Top Level Menu","Enter a name for a new top level menu")
	if(menus.SSN("//*[@clean='" Clean(info) "' and @top=1]"))
		return m("A menu with this name already exists.  Please choose another")
	menus.Under(top,"menu",{clean:Clean(info),name:info,personal:1,last:1})
	return SettingsWindow.PopulateMenus()
	MoveSelected:
	Default("SysListView322","Settings"),LV_GetText(item,LV_GetNext())
	if(!LV_GetNext())
		return m("Please select a menu item/s to move")
	SMM:=new GUIKeep("SelectMoveMenu"),SMM.Add("TreeView,w300 h400,,wh","Button,gSMMSelect Default,Move To Selected Menu"),SMM.Show("Select Move Menu"),Default("SysTreeView321","SelectMoveMenu"),all:=menus.SN("//main/descendant::menu")
	while(aa:=all.item[A_Index-1]),ea:=XML.EA(aa){
		if(SSN(aa,"descendant::*")||ea.personal)
			aa.SetAttribute("ssmtv",TV_Add(RegExReplace(ea.clean,"_"," "),SSN(aa.ParentNode,"@ssmtv").text,SettingsWindow.Icon(ea)))
	}
	return
	SMMSelect:
	Default("SysTreeView321","SelectMoveMenu"),node:=menus.SSN("//*[@ssmtv='" TV_GetSelection() "']")
	Default("SysListView322","Settings")
	while(next:=LV_GetNext())
		LV_GetText(item,next),node.AppendChild(menus.SSN("//*[@clean='" Clean(item)"']")),LV_Delete(next)
	SelectMoveMenuEscape:
	SelectMoveMenuClose:
	SMM.Exit()
	all:=menus.SN("//*[@ssmtv]")
	while(aa:=all.item[A_Index-1])
		aa.RemoveAttribute("ssmtv")
	WinActivate,% SettingsWindow.win.ID
	return
	SettingsEditHotkey:
	ControlGet,tab,Tab,,SysTabControl321,% SettingsWindow.win.ID
	if(tab=12){
		obj:=SettingsWindow.IconInfo,node:=SettingsWindow.CurrentIconNode
		if(obj.file&&obj.icon){
			for a,b in {filename:obj.file,icon:obj.icon}
				node.SetAttribute(a,b)
			if(SSN(node,"descendant::*"))
				Default("SysTreeView322","Settings"),TV_Modify(SSN(node,"@tv").text,SettingsWindow.Icon(XML.EA(node)))
			else
				Default("SysListView322","Settings"),LV_Modify(SN(node,"preceding-sibling::*").length+1,SettingsWindow.Icon(XML.EA(node)))
			SettingsWindow.CurrentIconNode:=""
		}
		SettingsWindow.IconInfo:=[],SettingsWindow.LastControl(1)
		return
	}
	ControlGetFocus,focus,% SettingsWindow.win.ID
	if(focus="SysListView322"){
		Default("SysListView322","Settings"),LV_GetText(item,LV_GetNext())
		if(!node:=menus.SSN("//*[@clean='" Clean(item) "']"))
			return m("Select an item to change its hotkey")
		EditHotkey(node,"Settings")
	}else if(focus="SysListView323")
		SetTimer,SWAction,-1
	return
	Up:
	Down:
	next:=0,Default("SysListView322","Settings"),list:=SN((node:=SettingsWindow.GetNode()),"*")
	while(next:=LV_GetNext(next))
		SettingsWindow.ItemList[next].SetAttribute("select",1),node:=SettingsWindow.ItemList[next].ParentNode
	while(next:=LV_GetNext(next))
		list.item[next-1].SetAttribute("select",1)
	last:=A_ThisLabel="Down"?(list.item[list.length-1],prev:="previousSibling",next:="nextSibling",dir:=1):(last:=list.item[0],next:="previousSibling",prev:="nextSibling",dir:=0)
	while(last:=last[prev]){
		if(!SSN(last,"@select").text)
			Continue
		if(!SSN(last[next],"@select").text)
			last.ParentNode.InsertBefore(dir?last[next]:last,dir?last:last[next])
	}SettingsWindow.PopulateMenuItems(node)
	return
	SortSelectedMenu:
	Default("SysTreeView322","Settings"),node:=menus.SSN("//*[@tv='" TV_GetSelection() "']"),under:=SN(node,"*"),alpha:=[]
	while(uu:=under.item[A_Index-1]),ea:=XML.EA(uu)
		alpha[ea.clean]:=uu
	for a,b in alpha
		node.AppendChild(b)
	return SettingsWindow.PopulateMenuItems(node)
	RemoveIcon:
	Default("SysListView322","Settings")
	node:=SettingsWindow.ItemList[LV_GetNext()]
	if(!node)
		return m("Please select an item to remove its icon")
	if(!SSN(node,"@filename"))
		return
	for a,b in ["filename","icon"]
		node.RemoveAttribute(b)
	node.SetAttribute("select",1)
	return SettingsWindow.PopulateMenuItems(node.ParentNode)
	SWChangeIcon:
	ControlGetFocus,focus,% SettingsWindow.win.ID
	if(focus~="(SysTreeView322|SysListView322)"=0){
		ControlFocus,% (focus:="SysListView322"),% SettingsWindow.win.ID
		Sleep,100
	}if(focus="SysTreeView322"){
		Default(focus,"Settings")
		if(!TV_GetSelection())
			return m("Please select a Top Level Menu to change its icon")
		node:=SettingsWindow.GetNode()
		GuiControl,Settings:,Static1,% "Changing the icon for " RegExReplace((ea:=XML.EA(node)).clean,"_"," ")
		SettingsWindow.LastControl()
		Default("SysListView325","Settings"),LV_Modify(ea.icon?ea.icon:1,"Select Vis Focus"),SettingsWindow.CurrentIconNode:=node
		GuiControl,Settings:Choose,SysTabControl321,12
	}else if(focus="SysListView322"){
		Default(focus,"Settings")
		if(!LV_GetNext())
			return m("Please select a Menu Item to change its icon")
		SettingsWindow.LastControl()
		node:=SettingsWindow.ItemList[LV_GetNext()]
		if(node.NodeName="Separator")
			return m("Separators can not have icons.")
		;node:=SettingsWindow.GetNode(),Default("SysListView322","Settings")
		ea:=XML.EA(node)
		GuiControl,Settings:,Static1,% "Changing the icon for " Clean(ea.clean,2)
		Default("SysListView325","Settings"),LV_Modify(ea.icon?ea.icon:1,"Select Vis Focus"),SettingsWindow.CurrentIconNode:=node
		GuiControl,Settings:Choose,SysTabControl321,12
	}
	return
	SWCancelIcon:
	SettingsWindow.LastControl(1)
	return
	ShowOptionsTab:
	Default("SysTreeView321","Settings"),TV_Modify(SettingsWindow.Windows["Options"],"Select Vis Focus")
	return
	AddSeparator:
	;node:=SettingsWindow.GetNode()
	Default("SysListView322","Settings"),LV_GetText(item,LV_GetNext())
	if(!LV_GetNext())
		return m("Please select a menu item to add the Separator below")
	node:=menus.SSN("//*[@clean='" Clean(item) "' and not(@top)]"),new:=menus.Under(node.ParentNode,"separator",{clean:"<Separator>",select:1})
	if(before:=node.nextSibling)
		node.ParentNode.InsertBefore(new,before)
	SettingsWindow.PopulateMenuItems(node.ParentNode)
	return
	AddNewSubMenu:
	Default("SysTreeView322","Settings")
	node:=menus.SSN("//*[@tv='" TV_GetSelection() "']"),top:=menus.SSN("//main"),info:=InputBox(this.hwnd,"New Sub Menu","Enter a name for a sub menu for " SSN(node,"@clean").text)
	if(menus.SSN("//*[@clean='" Clean(info) "' and @top=1]"))
		return m("A menu with this name already exists.  Please choose another")
	new:=menus.Under(node,"menu",{clean:Clean(info),name:info,top:1,last:1,personal:1})
	return SettingsWindow.PopulateMenus()
	SortMenus:
	m("Coming Soon...")
	return
	ReloadDefaults:
	m("Coming Soon...")
	return
	RemoveAllIconsFromCurrentMenu:
	node:=SettingsWindow.GetNode()
	if(m("Are you sure you want to remove all of the icons from the " Clean(SSN(node,"@clean").text,2) " menu? This can not be undone","ico:!","btn:ync","def:2")="Yes"){
		all:=SN(node,"*")
		while(aa:=all.item[A_Index-1]){
			for a,b in ["filename","icon"]
				aa.RemoveAttribute(b)
		}SettingsWindow.PopulateMenuItems(node)
	}
	return
	RemoveAllIcons:
	if(m("Are you sure you want to remove ALL icons?","Can not be undone","ico:!","btn:ync","def:2")="Yes"){
		all:=menus.SN("//main/descendant::*")
		while(aa:=all.item[A_Index-1]){
			for a,b in ["filename","icon"]
				aa.RemoveAttribute(b)
		}
	}SettingsWindow.GetNode().SetAttribute("last",1),SettingsWindow.PopulateMenus()
	return
}
Menus(){
	new SettingsClass("Menus")
}
MenuWipe(x:=0){
	all:=menus.SN("//*")
	if(x)
		Gui,1:Menu
	while,aa:=all.item[A_Index-1],ea:=XML.EA(aa){
		parent:=SSN(aa.ParentNode,"@name").text,hotkey:=SSN(aa,"@hotkey").text,hotkey:=hotkey?"`t" Convert_Hotkey(hotkey):"",current:=SSN(aa,"@name").text
		Menu,%parent%,Delete,% current hotkey
	}
 	while,aa:=all.item[A_Index-1],ea:=XML.EA(aa)
		if(SSN(aa,"descendant::*"))
			Menu,main,Delete,% ea.name
	Sleep,100
}
MissingPlugin(file,menuname){
	SplitPath,file,filename,dir
	if(dir="plugins"&&!FileExist(file)){
		if(m("This requires a plugin that has not been downloaded yet, Download it now?","btn:yn")="yes"){
			UrlDownloadToFile,https://raw.githubusercontent.com/maestrith/AHK-Studio-Plugins/master/%filename%,%file%
			option:=menus.SSN("//*[@clean='" RegExReplace(menuname," ","_") "']/@option").text,Refresh_Plugins()
			Run,%file% "%option%"
		}else{
			m("Unable to run this option.")
			Exit
		}
	}
}
Move_Selected_Lines_Down(){
	sc:=csc()
	OLine:=line:=sc.2166(sc.2143)
	if(line+1=sc.2154)
		return
	if(line+1>=sc.2154&&Trim(sc.GetLine(line))="")
		return
	
	sc.Enable()
	/*
		in here the only thing that will change is going to be the current
		area and it will move it down.
		unless it happens to go into another area....
		damn...
		and if the start is a part of it then the top area as well...
		
	*/
	sc.2078(),start:=sc.2166(sc.2143),end:=sc.2166(sc.2145-1),LineStatus.StoreEdited(start,end,1),Edited()
	sc.2621()
	if(v.Options.Full_Auto_Indentation)
		FixIndentArea()
	
	sc.Enable(1)
	
	LineStatus.UpdateRange(),sc.2079
	return
}
Move_Selected_Lines_Up(){
	sc:=csc(),OLine:=line:=sc.2166(sc.2143)
	if(line=0)
		return
	sc.Enable(),sc.2078,start:=sc.2166(sc.2143),end:=sc.2166(sc.2145-1),LineStatus.StoreEdited(start,end,-1),Edited()
	sc.2620(),sc.Enable(1)
	if(v.Options.Full_Auto_Indentation)
		FixIndentArea()
	sc.Enable(1),LineStatus.UpdateRange(),sc.2079
}
Move_Selected_Word_Right(){
	MoveSelectedWord(1)
}
Move_Selected_Word_Left(){
	MoveSelectedWord(-1)
}
MoveSelectedWord(add){
	sc:=csc()
	sc.2078
	Loop,% sc.2570{
		index:=A_Index-1,start:=sc.2585(index),end:=sc.2587(index)
		if(start!=end){
			sc.2686(start,end)
			VarSetCapacity(text,end-start)
			sc.2687(0,&text)
			text:=StrGet(&text,end-start,"UTF-8")
			sc.2645(start,end-start)
			sc.2686(start+add,start+add)
			sc.2194(StrPut(text,"UTF-8")-1,[text])
			sc.2584(index,start+add),sc.2586(index,end+add)
		}
	}
	sc.2079
}
m(x*){
	static list:={btn:{oc:1,ari:2,ync:3,yn:4,rc:5,ctc:6},ico:{"x":16,"?":32,"!":48,"i":64}},msg:=[]
	list.title:="AHK Studio",list.def:=0,list.time:=0,value:=0,txt:=""
	for a,b in x
		obj:=StrSplit(b,":"),(vv:=List[obj.1,obj.2])?(value+=vv):(list[obj.1]!="")?(List[obj.1]:=obj.2):txt.=b "`n"
	msg:={option:value+262144+(list.def?(list.def-1)*256:0),title:list.title,time:list.time,txt:txt}
	Sleep,120
	MsgBox,% msg.option,% msg.title,% msg.txt,% msg.time
	for a,b in {OK:value?"OK":"",Yes:"YES",No:"NO",Cancel:"CANCEL",Retry:"RETRY"}
		IfMsgBox,%a%
			return b
}
t(x*){
	for a,b in x{
		if((obj:=StrSplit(b,":")).1="time"){
			SetTimer,killtip,% "-" obj.2*1000
			Continue
		}
		list.=b "`n"
	}
	Tooltip,% list
	return
	killtip:
	ToolTip
	return
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
	newwin:=new GUIKeep(28),newwin.Add("Edit,w500 r30,,wh","Button,gNFTDefault,Default Template,y","Button,gNFTClose Default,Save,y"),newwin.show("New File Template")
	if(template:=Settings.SSN("//template").text)
		ControlSetText,Edit1,% RegExReplace(template,"\R","`r`n"),% hwnd([28])
	else
		goto,nftdefault
	return
	NFTClose:
	ControlGetText,edit,Edit1,% hwnd([28])
	Settings.Add("template",,RegExReplace(edit,"\R","`n"))
	28Escape:
	28Close:
	hwnd({rem:28})
	return
	NFTDefault:
	FileRead,template,c:\windows\shellnew\template.ahk
	ControlSetText,Edit1,%template%,% hwnd([28])
	rem:=Settings.SSN("//template"),rem.ParentNode.RemoveChild(rem)
	return
}
New_Include(){
	if(Current(2).untitled)
		return m("You can not add Includes to untitled documents.  Please save this project before attempting to add Includes to it.")
	sc:=csc(),parent:=Current(2).file,Filename:=SelectFile("","New Include Name"),AddSpace:=v.Options.New_Include_Add_Space?" ":""
	SplitPath,Filename,,,,nne
	function:=Clean(nne),text:=(function~="i)^class_")?(m("Create Class called " (RegExReplace(SubStr(nne,InStr(nne," ")+1)," ","_")) "?","btn:ync")="Yes"?"Class " (RegExReplace(SubStr(nne,InStr(nne," ")+1)," ","_")) AddSpace "{`n`t`n}":"",pos:=StrPut(nne AddSpace "{`t","UTF-8")):(m("Create Function called " function "?","btn:ync")="Yes"?function "()" AddSpace "{`n`t`n}":"",pos:=StrPut(function "(","UTF-8")-1)
	AddInclude(Filename,text,{start:pos,end:pos})
}
NewIndent(indentwidth:=""){
	Critical
	static IncludeOpen
	tick:=A_TickCount
	filename:=Current(3).file
	SplitPath,filename,,,ext
	sc:=csc(),sc.Enable(),skipcompile:=0,chr:="K",codetext:=sc.GetUni(),indentation:=sc.2121,line:=sc.2166(sc.2008),posinline:=sc.2008-sc.2128(line),selpos:=PosInfo(),lock:=[],block:=[],aa:=ab:=braces:=0,code:=StrSplit(codetext,"`n"),aaobj:=[],specialbrace:=0,totalcount:=0
	for a,text in code{
		totalcount++
		text:=Trim(text,"`t ")
		if(text~="i)\Q* * * Compile_AH" Chr "\E"){
			skipcompile:=skipcompile?0:1
			Continue
		}
		if(skipcompile)
			Continue
		if(SubStr(text,1,1)=";"&&v.options.Auto_Indent_Comment_Lines!=1)
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
		first:=SubStr(text,1,1),last:=SubStr(text,0,1),ss:=(text~="i)^\s*(&&|\bOR\b|\bAND\b|\.|\,|\|\||:|\?)\s*"),indentcheck:=(RegExMatch(text,"iA)}*\s*#?\b(" Keywords.IndentRegex[Current(3).ext] ")\b",string))
		if(first="<"){
			Continue
		}
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
	}
	/*
		Update({sc:sc.2357})
	*/
	if(indentwidth){
		SetStatus(A_ThisFunc " Process Time: " A_TickCount-tick "ms @ " A_TickCount,3)
		return sc.Enable(1)
	}if(braces&&!IncludeOpen)
		WinSetTitle(1,files.EA("//*[@sc='" sc.2357 "']"),1),IncludeOpen:=1
	else if(!braces&&IncludeOpen)
		WinSetTitle(1,files.EA("//*[@sc='" sc.2357 "']")),IncludeOpen:=0
	if(selpos.start=selpos.end){
		newpos:=sc.2128(line)+posinline,newpos:=newpos>sc.2128(line)?newpos:sc.2128(line),sc.2025(newpos)
		/*
			;if cursor position gets really messed up.
				if(sc.2129(sc.2008)){
					Send,{Left}{Right}
				}
		*/
	}else
		sc.2160(sc.2167(startline),sc.2136(endline))
	line:=sc.2166(sc.2008)
	if(sc.2008=sc.2128(line)&&v.options.Manual_Continuation_Line){
		ss:=(sc.getline(line-1)~="i)^\s*(&&|OR|AND|\.|\,|\|\||:|\?)")
		if(ss)
			sc.2126(line,sc.2127(line-1)),sc.2025(sc.2128(line))
	}sc.Enable(1)
	SetStatus(A_ThisFunc " Process Time: " A_TickCount-tick "ms @ " A_TickCount " total: " totalcount ,3)
}
New(Filename:="",text:="",Select:=1){
	template:=GetTemplate()
	if(v.Options.New_File_Dialog&&!Filename){
		FileSelectFile,Filename,S16,,Enter a Filename for a new project,*.ahk
		if(!Filename)
			return
		SplitPath,Filename,,NewDir,Ext,NNE
		if(!Ext||!Settings.SSN("//Extensions/Extension[text()='" Ext "']")){
			Filename:=NewDir "\" NNE ".ahk"
		}
		file:=FileOpen(Filename,"RW"),file.Seek(0),file.Write(template),file.Length(file.Position),file.Close()
		if(FileExist(Filename))
			return tv(Open(Filename))
	}else
		Filename:=(list:=files.SN("//main[@untitled]").length)?"Untitled" list ".ahk":"Untitled.ahk",Untitled:=1
	Update({file:Filename,text:template,load:1,encoding:"UTF-8"})
	main:=files.Under(files.SSN("//*"),"main",{file:Filename,id:(id:=GetID())})
	SplitPath,Filename,mfn,maindir,Ext,mnne
	node:=files.Under(main,"file",{ext:Ext,file:Filename,dir:maindir,filename:mfn,id:id,nne:mnne,scan:1,lang:"ahk"})
	if(Untitled)
		main.SetAttribute("untitled",1),node.SetAttribute("untitled",1)
	FEUpdate(),ScanFiles()
	if(Select)
		tv(files.SSN("//*[@id='" id "']/@tv").text)
	return new
}
New_Include_From_Current_Word(){
	sc:=csc(),word:=sc.GetWord(),file:=Current(2).file
	if(Context(1).word="gui"){
		word:=InputBox(hwnd(1),"Possible g-label detected","Confirm the new Function and File to be created",word)
		if(ErrorLevel||word="")
			return
	}
	SplitPath,file,,dir
	FileSelectFile,Filename,S16,% dir "\" RegExReplace(word,"_"," ") ".ahk",Confirm New File,*.ahk
	if(ErrorLevel)
		return
	if(files.Find(Current(1),"//@file",filename))
		return m("This file is already included in this Project")
	AddInclude(Filename(Filename),word "(){`r`n`t`r`n}",{start:StrPut(word "(","UTF-8")-1,end:StrPut(word "(","UTF-8")-1})
}
NewLines(text){
	for a,b in {"``n":"`n","``r":"`n","``t":"`t","\r":"`n","\t":"`t","\n":"`n"}
		StringReplace,text,text,%a%,%b%,All
	return text
}
Next_File(){
	Default("SysTreeView321"),TV_Modify(TV_GetNext(TV_GetSelection(),"F"),"Select Vis Focus")
}
Next_Found(){
	sc:=csc(),sc.2606,sc.2169,CenterSel()
}
Next_Project(){
	current:=Current(1)
	next:=current.nextSibling?current.nextSibling:current.ParentNode.FirstChild
	if(SSN(next,"@file").text="Libraries")
		next:=current.ParentNode.FirstChild
	tv(SSN(next,"descendant::*/@tv").text)
}
Notifications(a*){
	static CodeList:={70:2068,71:2601}
	this:=SettingsClass.keep,Controls:=SettingsClass.Controls
	if(A_GuiControl="MenuTV"){
		this.Default("MenuTV")
		if(A_GuiEvent="K"&&A_EventInfo="32")
			node:=menus.SSN("//*[@tv='" TV_GetSelection() "']")
		else if(A_GuiEvent="Normal")
			node:=menus.SSN("//*[@tv='" A_EventInfo "']")
		if(node.xml)
			check:=TV_Get(SSN(node,"@tv").text,"Check"),(check?node.SetAttribute("check",1):node.RemoveAttribute("check"))
		return
	}if(A_GuiControl="ComboBox"){
		ControlGetText,item,,% "ahk_id" Controls.ComboBox
		this.Default("MenuTV"),TV_Modify(SettingsClass.MenuSearch[item],"Select Vis Focus")
		return 
	}if(A_GuiControl="Icon"){
		SettingsClass.Default("MenuTV"),node:=menus.SSN("//*[@tv='" TV_GetSelection() "']")
		if(node.NodeName="separator")
			return m("Separators can not have icons")
		for a,b in {filename:a.1.file,icon:a.1.icon}
			node.SetAttribute(a,b)
		opt:=SettingsClass.TVOptions(node)
		TV_Modify(SSN(node,"@tv").text,opt)
		GuiControl,Settings:+Redraw,% Controls.MenuTV
		return
	}if(A_GuiControl="FTAdd"){
		ControlGetText,text,,% "ahk_id" Controls.FTEdit
		if(Settings.SSN("//Extensions/Extension[text()='" text "']"))
			return m("File Type already exists")
		if(!text)
			return m("Please add a File Type to add to this list")
		Settings.Add("Extensions/Extension",,,1).text:=Text
		ControlSetText,,,% "ahk_id" Controls.FTEdit
		return this.PopulateMFT()
	}if(A_GuiControl="FTRemove"){
		this.Default("FileType"),list:=[],list.text:=""
		while(next:=LV_GetNext(next))
			LV_GetText(item,next),list[next]:=Settings.SSN("//Extensions/Extension[text()='" item "']"),list.text.=item "`n"
		if(m("Remove:",list.text,"btn:ync")="Yes")
			for a,b in list
				b.ParentNode.RemoveChild(b)
		return this.PopulateMFT()
	}if(A_GuiControl="ER"){
		this.Default("ERLV"),LV_GetText(item,LV_GetNext()),node:=Settings.SSN("//replacements/replacement[@replace='" item "']")
		for a,b in {ERReplace:RegExReplace(node.text,"\R","`r`n"),ERInsert:SSN(node,"@replace").text}
			GuiControl,Settings:,% Controls[a],%b%
		return
	}if(A_GuiControl="ERInsert"){
		GuiControl,Settings:+g,% Controls.ERLV
		ControlGetText,text,,% "ahk_id" Controls.ERInsert
		this.Default("ERLV"),next:=0
		Loop,% LV_GetCount(){
			LV_GetText(item,A_Index)
			if(item=text){
				LV_Modify(0,"-Select"),LV_Modify(A_Index,"Select Vis Focus")
				ControlSetText,,% RegExReplace(Settings.SSN("//replacements/replacement[@replace='" text "']").text,Chr(127) "|\R","`r`n"),% "ahk_id" Controls.ERReplace
				Break
			}
		}
		GuiControl,Settings:+gNotifications,% Controls.ERLV
		return
	}if(A_GuiControl="ERReplace"){
		info:=[],this.Default("ERLV"),LV_GetText(item,LV_GetNext()),node:=Settings.SSN("//replacements/replacement[@replace='" item "']")
		for a,b in ["ERInsert","ERReplace"]{
			ControlGetText,text,,% "ahk_id" Controls[b]
			info[b]:=text
		}if(item=info.ERInsert)
			LV_Modify(LV_GetNext(),"Col2",RegExReplace(info.ERReplace,"\R",Chr(127))),node.text:=RegExReplace(info.ERReplace,"\R",Chr(127))
		return
	}if(A_GuiControl="ERAdd"){
		info:=[]
		for a,b in ["ERInsert","ERReplace"]{
			ControlGetText,text,,% "ahk_id" Controls[b]
			info[b]:=text
		}
		if(!info.ERInsert||!info.ERReplace)
			return m("Both items need to have values")
		if(Settings.SSN("//replacements/replacement[@replace='" info.ERInsert "']"))
			return node.text:=info.ERReplace,this.PopulateER()
		node:=Settings.Add("replacements/replacement",{replace:info.ERInsert},,1),node.text:=RegExReplace(info.ERReplace,"\R",Chr(127))
		node.SetAttribute("replace",info.ERInsert) ;here for plugin
		for a,b in ["ERReplace","ERInsert"]
			GuiControl,Settings:,% Controls[b]
		ControlFocus,,% "ahk_id" Controls.ERInsert
		this.PopulateER()
	}if(A_GuiControl="ERRemove"){
		info:=[],this.Default("ERLV"),LV_GetText(item,LV_GetNext()),node:=Settings.SSN("//replacements/replacement[@replace='" item "']")
		if(m("Are you sure?","Can NOT be undone","btn:ync","def:2","ico:!")="Yes")
			node.ParentNode.RemoveChild(node),this.PopulateER()
		return
	}if(A_GuiControl="AddButton"){
		key:=[]
		for a,b in ["trigger","add"]{
			ControlGetText,text,,% "ahk_id" Controls[b]
			key[b]:=text
		}if(Settings.Find("//autoadd/key/@trigger",key.trigger))
			return m("Key already exists")
		if(!key.trigger||!key.add)
			return m("Both items need to have values")
		node:=Settings.Add("autoadd/key",{trigger:key.trigger,add:key.add},,1)
		for a,b in key ;here for plugin
			node.SetAttribute(a,b) ;here for plugin
		for a,b in ["trigger","add"]
			GuiControl,Settings:,% Controls[b]
		return this.PopulateAI(),BraceSetup()
	}if(A_GuiControl="RemoveButton"){
		this.Default("AutoInsert"),LV_GetText(item,LV_GetNext())
		ea:=xml.EA(node:=Settings.Find("//autoadd/key/@trigger",item))
		node.ParentNode.RemoveChild(node),this.PopulateAI()
		return BraceSetup()
	}if(A_GuiControl="AI"&&A_GuiEvent="I"){
		this.Default("AutoInsert"),LV_GetText(item,LV_GetNext())
		ea:=xml.EA(node:=Settings.Find("//autoadd/key/@trigger",item))
		for a,b in {trigger:ea.trigger,add:ea.add}
			GuiControl,Settings:,% Controls[a],%b%
		return
	}if(A_GuiControl="Options"&&A_GuiEvent="I"){
		Gui,Settings:ListView,SysListView321
		next:=LV_GetNext(A_EventInfo-1,"C"),LV_GetText(text,A_EventInfo),text:=RegExReplace(text," ","_")
		if((v.Options[text]&&next!=A_EventInfo)||(!v.Options[text]&&next=A_EventInfo))
			Options(text)
		return
	}code:=NumGet(A_EventInfo,8),Alt:=GetKeyState("Alt","P"),Ctrl:=GetKeyState("Ctrl","P"),Shift:=GetKeyState("Shift","P")
	if(Code=2010){
		Margin:=NumGet(A_EventInfo,64)
		if(Margin=1){
			Line:=this.2166(NumGet(A_EventInfo,12)),att:=this.EditedMarker[Line]
			if(att)
				Dlg_Color("theme/editedmarkers",,this.hwnd,att),RefreshThemes(1),this.Color()
			return
		}if(Margin=3){
			Marker:=this.2046(this.2166(NumGet(A_EventInfo,12))),att:=(Marker&(1<<29)||Marker&(1<<28))?"background":(Marker&(1<<32))?att:="color":""
			if(att)
				Dlg_Color("theme/fold",,this.hwnd,att),RefreshThemes(1),this.Color()
			return
		}if(Ctrl)
			return Dlg_Font(Node,,this.hwnd),this.Color()
		return Dlg_Color("theme/linenumbers",,this.hwnd,(Alt?"background":"color")),this.Color(),RefreshThemes(1)
	}if(code=2007){
		style:=this.2010(this.2008())
		SB_SetText("Style at Caret: " style) ;(style~="\b(101|70|71|0)\b"?"N/A":style))
	}if(A_GuiControl="Testing"){
		if(A_GuiEvent~="S|Normal")
			this.SwitchTab(A_EventInfo)
	}else if(code=2027){
		Style:=this.2010(pos:=NumGet(A_EventInfo,12)),Style:=(Style<0?255+Style+1:Style),ThemeXML:=Keywords.GetXML(Settings.Language)
		if(Style=255){
			Node:=Settings.Add("theme/bracematch") ;here...ish
			if(!Shift&&!Ctrl&&!alt)
				Dlg_Color(Node,,this.hwnd,"color")
			else if(Ctrl)
				Dlg_Font(Node,Settings.Add("theme/default"),this.hwnd)
			return RefreshThemes(1),this.Color(),Refresh:=0
		}else if(Style=254){
			return Node:=Settings.Add("theme/additionalselback"),Color:=Dlg_Color(Node,,this.hwnd),RefreshThemes(1),SettingsClass.SetHighlight()
		}else if(Style=253){
			return Node:=Settings.Add("theme/selback"),Node.SetAttribute("bool",1),Color:=Dlg_Color(Node,,this.hwnd),RefreshThemes(1),SettingsClass.SetHighlight()
		}
		
		
		
		StyleNode:=ThemeXML.SSN("//Styles/descendant::*[@style='" Style "']")
		if(!Node:=Settings.SSN("//theme/" StyleNode.NodeName)){
			Node:=Settings.SSN("//Languages/" Settings.Language "/descendant::*[@style='" Style "']")
		}
		/*
			m(Node.xml,Style,ThemeXML.SSN("//Styles").xml)
		*/
		if(GetKeyState("Ctrl","P"))
			Dlg_Font(Node,,SettingsClass.HWND)
		else
			Dlg_Color(Node,,SettingsClass.HWND)
		this.Color(),RefreshThemes(1)
		WinActivate,% "ahk_id" SettingsClass.HWND
		return ;m(Style,ThemeXML.SSN("//Styles/descendant::*[@style='" Style "']").xml,"Here!--->") ;here
		
		
		
		
		if(Shift){
			m("remove style")
			return
		}
		if(!node:=Settings.SSN("//theme/font[@style='" style "']")){
			if(style=34&&!node:=Settings.SSN("//theme/font[@code='2082']")){
				node:=Settings.Under(Settings.SSN("//theme"),"font",{code:2082})
				node.SetAttribute("code",2082) ;here for plugin
			}
		}
		if(cc:=CodeList[style]){
			node:=Settings.SSN("//theme/font[@code='" cc "']")
		}
		if(!node){
			node:=Settings.Under(Settings.SSN("//theme"),"font",{style:style})
			node.SetAttribute("style",style) ;here for plugin
		}
		if(ctrl&&SSN(node,"@code").text)
			return m("Nope!")
		if(ctrl){
			/*
				ea:=xml.EA(node),def:=xml.EA(Settings.SSN("//theme/default"))
			*/
			for a,b in def
				if(ea[a]="")
					ea[a]:=def[a]
			Dlg_Font(ea,,this.hwnd)
			for a,b in ea
				node.SetAttribute(a,b)
			node.SetAttribute("style",style)
			this.Color(),RefreshThemes(1)
			return
		}
		type:=Alt?"background":"color"
		if(!node)
			return m("Unable to find Style: " style,"This needs fixed for 70 and 71 for the match brace")
		color:=SSN(node,"@" type).text,color:=color!=""?color:Settings.SSN("//theme/default/@" type).text
		return m("FIX THIS COLOR")
		/*
			color:=Dlg_Color(color,this.hwnd)
			if(cc)
				this.2052(style,color)
			node.SetAttribute(type,color),this.Color(),RefreshThemes(1)
		*/
	}
}
Notify(csc*){
	static values:={0:"Obj",2:"Code",3:"position",4:"ch",5:"mod",6:"ModType",7:"text",8:"length",9:"linesadded",10:"msg",11:"wparam",12:"lparam",13:"line",14:"fold",15:"prevfold",17:"listType",22:"updated",23:"Method"}
	static codeget:={2001:{ch:4},2005:{ch:4,mod:5},2006:{position:3,mod:5},2007:{updated:22},2008:{position:3,ModType:6,text:7,length:8,linesadded:9,line:13,fold:14,prevfold:15},2010:{position:3},2011:{position:3},2014:{position:3,ch:4,text:7,listtype:17,Method:23},2016:{x:18,y:19},2019:{position:3,mod:5},2021:{position:3},2022:{position:3,ch:4,text:7,method:23},2027:{position:3,mod:5}}
	static poskeep,Mem:=[]
	Notify:
	static last,lastline,lastpos:=[],focus:=[],dwellfold:="",text
	if(csc.1=0)
		return lastpos:=[]
	fn:=[],Info:=A_EventInfo,Code:=NumGet(Info+8)
	if(!Code)
		return 0
	sc:=csc({hwnd:(Ctrl:=NumGet(A_EventInfo+0))})
	if(Code=2016){
		pos:=sc.2023(fn.x,fn.y)
		word:=sc.TextRange(sc.2266(pos,1),sc.2267(pos,1))
		list:=debug.XML.SN("//property[@name='" word "']"),info:=""
		/*
			debug.XML.Transform()
			CoordMode,ToolTip,Screen
			ToolTip,% (debug.xml[]) "`n`n`n`n" word,0,0,4
		*/
		while(ll:=list.item[A_Index-1]),ea:=XML.EA(ll)
			info:=ea.type="object"?"Object: Use List Variables (Alt+M LV) to see more info":info.=SSN(ll,"ancestor::*/@name").text " = " ll.text "`n"
		if(info)
			line:=sc.2166(pos),end:=sc.2136(line),ShowPos:=sc.2166(pos+3)=line?pos+3:pos,sc.2200(ShowPos,word ": " Trim(info,"`n"))
		else
			sc.2201
		return
	}if(Code=2017)
		return sc.2201
	if(Code=2007){
		if(NumGet(Info+88)&2)
			SetTimer("UpPos",-31)
		return 0,SetTimers("BraceHighlight,-10")
	}else if(Code=2028){
		if(s.ctrl[Ctrl])
			sc:=csc({hwnd:hwnd})
		sc.2400()
		if(sc.sc=MainWin.tnsc.sc)
			WinSetTitle(1,"Tracked Notes")
		else
			WinSetTitle(1,ea:=files.EA("//*[@sc='" sc.2357 "']"))
		MouseGetPos,,,win
		if(win=hwnd(1))
			SetTimer,LButton,-200
		TVC.Disable(1)
		if(v.Options.Check_For_Edited_Files_On_Focus)
			Check_For_Edited()
		if(ea.tv)
			TV_Modify(ea.tv,"Select Vis Focus")
		TVC.Enable(1)
		if(CheckLayout())
			Hotkeys()
		return 0
	}else if(Code=2029){
		return 0
	}else if((ctrl:=NumGet(Info+0))=v.debug.sc&&v.debug.sc){
		sc:=v.debug
		if(Code=2027){
			style:=sc.2010(sc.2008)
			if(style=-106)
				Run_Program()
			else if(style=-105)
				List_Variables()
		}return
	}if Code not in 2007,2001,2006,2008,2010,2014,2022,2016,2019
		return 0
	fn:=[],fn.Code:=Code,fn.Ctrl:=NumGet(A_EventInfo+0)
	for a,b in CodeGet[Code]{
		if(a="Text")
			fn.Text:=StrGet(NumGet(Info+(A_PtrSize*b)),"UTF-8")
		else
			fn[a]:=NumGet(Info+(A_PtrSize*b))
	}if(fn.Code)
		Mem.Push(fn)
	SetTimer,ReadLater,-50
	return 0
	ReadLater:
	Edited:=[]
	while(fn:=Mem.RemoveAt(1)){
		sc:=csc({hwnd:fn.Ctrl}),tn:=0,Code:=fn.Code
		if(MainWin.tnsc.sc=fn.Ctrl)
			TNotes.Write(),tn:=1
		if(fn.Code=2001){
			SetWords(1),cpos:=sc.2008,start:=sc.2266(cpos,1),end:=sc.2267(cpos,1),word:=sc.TextRange(start,cpos),SetWords()
			if(sc.2007(start-1)=46){
				if(Show_Class_Methods(pre:=sc.TextRange(sc.2266(start-2,1),sc.2267(start-2,1)),word))
					return
			}if((StrLen(word)>1&&sc.2102=0&&v.Options.Auto_Complete))
				SetTimer,ShowAutoComplete,-15
			style:=sc.2010(cpos-2)
			if(v.Options.Context_Sensitive_Help)
				SetTimer,Context,-150
			c:=fn.ch
			if(c~="44|32")
				Replace()
			if(c=44&&v.Options.Auto_Space_Before_Comma){
				sc.2003(cpos-1," "),sc.2025(++cpos)
				if(v.Options.Auto_Space_After_Comma)
					sc.2003(cpos," ") ,sc.2025(cpos+1)
			}if(c=44&&v.Options.Auto_Space_After_Comma)
				sc.2003(cpos," "),sc.2025(cpos+1)
			ch:=c?c:sc.2007(sc.2008),SetStatus("Last Entered Character: " Chr(ch) " Code:" ch,2)
			if(c=125){
				SetTimer,FixBrace,-10
				Continue
			}if(c=10){
				SetupEnter(1),line:=sc.2166(sc.2008),indent:=sc.2127(line-1),sc.2126(line,indent),sc.2025(sc.2128(line))
				Continue
			}
		}else if(Code=2002){
			current:=Current(),ea:=XML.EA(current),current.RemoveAttribute("edited"),TVC.Modify(1,v.Options.Hide_File_Extensions?ea.nne:ea.filename,ea.tv),WinSetTitle(1,ea),LineStatus.Save(ea.id),LineStatus.tv()
			Continue
		}else if(Code=2006){
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
			}else{
				if(sc.2007((npos:=sc.2266(pos)-1))=35)
					sc.2160(npos,sc.2267(pos))
		}}else if(fn.Code=2008){
			Edited.Push(sc)
			if(sc.2570>1&&(sc.2266(sc.2008)-sc.2267(sc.2008)>1))
				SetTimer("ShowAutoComplete",-15)
			if(fn.ModType&0x400&&!tn){
				Text:=fn.Text
				line:=sc.2166(fn.position)
				/*
					oh this is going to get real tricky...
					Maybe store the important bits that need waching by position and length
					or at least a pos/end.  Then if anything in there gets edited it gets flagged?
					;#[Working Here]
					t(Text)
					m(Text)
					t(Text)
					m(Text)
					I am Typing Text
					Enter does not trigger
					In here and the else below
					Make sure to figure out how many lines are being added/deleted
					see if you can figure out exactly the above
					Text is the text being added
					So{
						you know where, both line and position, the entered text is being added
						so lets just send that info to the ScanFile class and see what happens
					}
				*/
				/*
					t("Added",A_TickCount,"time:2")
				*/
				if(!Current(3).edited)
					Edited()
				if(!v.LineEdited[line]){
					if(fn.ModType&0x20||fn.ModType&0x40){
						if(text)
							RegExReplace(text,"\R",,count),AddNewLines(text,Current(5)),LineStatus.DelayAdd(line,count)
					}else{
						if(MainWin.tnsc.sc!=ctrl)
							SetScan(line)
						if(v.Options.Disable_Line_Status!=1){
							LineStatus.Add(line,2)
			}}}}else if(fn.ModType&0x800&&!tn){
				/*
					fn.Position and fn.Length will have values.
					this will be helpful because you can figure out what was being deleted
					Delete/Backspace Key DOES NOT TRIGGER THIS!
					make sure that whatever you do here you do in Backspace() as well
					m(fn.Position,fn.Length)
				*/
				if(!Current(3).edited)
					Edited()
				if(sc.2008=sc.2009&&fn.ModType&0x20=0&&fn.ModType&0x40=0)
					epos:=fn.position,del:=sc.2007(epos),poskeep:=""
				start:=sc.2166(fn.position),end:=sc.2166(fn.position+fn.length)
				/*
					if(start!=end){
						RemoveLines(start,sc.2166(fn.position+fn.length-1))
						SetScan()
					}else
						
					Run,%A_StartMenu%
				*/
				/*
					t("Deleted",A_TickCount,"time:2")
				*/
				if(!v.LineEdited[start]){
					if(MainWin.tnsc.sc!=ctrl)
						SetScan(start)
					if(v.Options.Disable_Line_Status!=1)
						LineStatus.Add(start,2)
				}
			}if(fn.ModType&0x02&&(fn.ModType&0x20=0&&fn.ModType&0x40=0)){
				if(fn.linesadded)
					MarginWidth(sc)
			}SetTimer,UpPos,-10
			if(sc.2423=3&&sc.2570>1){
				list:=[]
				Loop,% sc.2570
					list.Push({caret:sc.2577(A_Index-1),anchor:sc.2579(A_Index-1)})
				for a,b in list{
					if(A_Index=1)
						sc.2160(b.anchor,b.caret)
					else
						sc.2573(b.caret,b.anchor)
			}}
		}else if(fn.Code=2010){
			margin:=NumGet(Info+(A_PtrSize*16)),line:=sc.2166(fn.position)
			if(margin=3)
				sc.2231(line)
			if(margin=1){
				line:=sc.2166(fn.position),shift:=GetKeyState("Shift","P"),ShiftBP:=v.Options.Shift_Breakpoint,text:=Trim(sc.GetLine(line)),search:=(shift&&ShiftBP||!shift&&!ShiftBP)?["*","UO)(\s*;\*\[(.*)\])","Breakpoint",";*[","]"]:["#","UO)(\s*;#\[(.*)\])","Bookmark",";#[","]"]
				if(pos:=RegExMatch(text,search.2,found)){
					start:=sc.2128(line),sc.2645(start+pos-1,StrPut(found.1,"UTF-8")-1)
					if(ShiftBP&&shift||!shift&&!ShiftBP)
						if(debug.Socket>0){
							if(node:=files.SSN("//*[@id='" debug.id "']/descendant::*[@sc='" sc.2357 "']")){
								dea:=XML.EA(node)
								if(dobj:=debug.Breakpoints[dea.id])
									debug.Send("breakpoint_remove -d " dobj.id)
				}}}else{
					if(ShiftBP&&shift||!shift&&!ShiftBP)
						if(debug.Socket>0)
							if(node:=files.SSN("//*[@id='" debug.id "']/descendant::*[@sc='" sc.2357 "']"))
								debug.Send("breakpoint_set -t line -f " SSN(node,"@file").text " -n" line+1 " -i " SSN(node,"@id").text "|" line)
					name:=AddBookmark(line,search)
		}}}else if(Code=2018){
			MarginWidth(sc)
			Continue
		}else if(fn.Code=2014){
			if(fn.listtype=1){
				if(!IsObject(scintilla))
					scintilla:=new xml("scintilla","lib\scintilla.xml")
				command:=fn.Text,info:=scintilla.SSN("//commands/item[@name='" command "']"),ea:=XML.EA(info),start:=sc.2266(sc.2008,1),end:=sc.2267(sc.2008,1),syn:=ea.syntax?ea.Code "()":ea.Code,sc.2160(start,end),sc.2170(0,[syn])
				if(ea.syntax)
					sc.2025(sc.2008-1),sc.2200(start,ea.Code ea.syntax)
			}else if(fn.listType=2){
				/*
					look up what sc.2117() uses 2 as the thing
				or add one that uses the vault stuff
				*/
				vv:=fn.Text,start:=sc.2266(sc.2008,1),end:=sc.2267(sc.2008,1),sc.2645(start,end-start),sc.2003(sc.2008,vault.SSN("//*[@name='" vv "']").text)
				if(v.Options.Full_Auto_Indentation)
					SetTimer,NewIndent,-1
			}else if(fn.listType=3){
				text:=fn.Text
				loop,% sc.2570
					cpos:=sc.2585(A_Index-1),add:=sc.2007(cpos)=40?"":"()",start:=sc.2266(cpos,1),end:=sc.2267(cpos,1),sc.2686(start,end),send:=(reptext:=RegExReplace(text,"(\(|\))")) add,len:=StrPut(send,"UTF-8")-1,sc.2194(len,send),len:=StrPut(reptext,"UTF-8"),GoToPos(A_Index-1,cpos:=sc.2585(A_Index-1)+len)
			}else if(fn.listtype=4)
				text:=fn.Text,start:=sc.2266(sc.2008,1),end:=sc.2267(sc.2008,1),sc.2645(start,end-start),sc.2003(sc.2008,text "."),sc.2025(sc.2008+StrLen(text ".")),Show_Class_Methods(text)
			else if(fn.listtype=5){
				text:=fn.Text,start:=sc.2266(sc.2008,1),end:=sc.2267(sc.2008,1),add:=sc.2007(end)=40?"":"()",sc.2645(start,end-start),sc.2003(sc.2008,text add),sc.2025(sc.2008+StrLen(text "."))
				SetTimer,Context,-10
			}else if(fn.listtype=6){
				text:=fn.Text,list:=v.firstlist
				SetTimer,NJT,-50
				Continue
				NJT:
				ll:=v.jtfa[text],SelectText(ll,1)
				return
			}else if(fn.listtype=7){
				text:=fn.Text,s.ctrl[v.jts[text]].2400()
			}else if(fn.listtype=8){
				static methods
				text:=fn.Text,start:=sc.2266(sc.2008,1),end:=sc.2267(sc.2008,1),sc.2645(start,end-start),sc.2003(sc.2008,text (sc.2007(sc.2008)=46?"":".")),sc.2025(sc.2008+StrLen(text ".")),methods:="",node:=cexml.Find("//main/@file",Current(2).file,"descendant::info[@type='Class' and @upper='" Upper(text) "']/*[@type='Method']")
				while(nn:=node.item[A_Index-1]),ea:=XML.EA(nn)
					methods.=ea.text " "
				SetTimer,ShowMethod,-10
				Continue
				ShowMethod:
				KeyWait,Enter,U
				sc.2117(5,Trim(methods))
				return
			}else if(fn.listtype=9){
				compare:=[],sea:=Settings.EA("//quickoptions/profile[@name='" fn.Text "']/optionlist")
				for a,b in v.Options
					if(b)
						if(sea[a]!=b)
							Options(a)
				for a,b in sea
					if(b)
						if(v.Options[sea]!=b)
							Options(a)
				m("hmm...")
				/*
					this.
					ToggleMenu(x)
					control:=x="Multi_Line"?"Multi-Line":RegExReplace(x,"_"," ")
					GuiControl,Quick_Find:,%control%,%onoff%
				*/
			}else if(fn.listtype=10){
				name:=fn.Text,sc.2645(fn.Position,Abs(fn.Position-sc.2008)),RegExMatch(name,"O)\|\s+(.*)",Found),sc.2025(fn.Position),sc.2003(fn.Position,Found.1)
				if(pos:=fn.Position+StrPut(Found.1,"UTF-8")-1)
					sc.2025(pos)
			}
		}else if(fn.Code=2022){
			v.Word:=fn.Text,List:=""
			for a,b in fn
				List.=a " = " b "`n"
			if(v.Options.Autocomplete_Enter_Newline){
				SetTimer,Enter,-1
			}Else{
				v.word:=fn.Text
				if(A_ThisHotkey="("){
					SetTimer,notifynext,-1
					return
					notifynext:
					Loop,% sc.2570{
						cpos:=sc.2585(A_Index-1)
						if(Chr(sc.2007(cpos))="(")
							GoToPos(A_Index-1,cpos+1)
						else
							InsertMultiple(A_Index-1,cpos,"()",cpos+1)
					}
					Continue
				}
				if(v.word="#Include"&&v.Options.Disable_Include_Dialog!=1){
					SetTimer,GetInclude,-200
				}else if(v.word~="i)\b(goto|gosub)\b"){
					SetTimer,goto,-100
				}else if(v.word="SetTimer"){
					SetTimer,ShowLabels,-80
				}else if(Syntax:=Keywords.GetXML(Current(3).Lang).SSN("//*[text()='" v.word "']/@syntax").text){ ;syntax:=commands.SSN("//Commands/commands[text()='" v.word "']/@syntax").text){
					if(SubStr(syntax,1,1)="(")
						SetTimer,AutoParen,-40
					else
						SetTimer,AutoMenu,-150
					Continue
					AutoParen:
					Loop,% sc.2570{
						cpos:=sc.2585(A_Index-1)
						if(sc.2007(cpos-1)!=40&&sc.2007(cpos)!=40)
							InsertMultiple(A_Index-1,cpos,"()",cpos+1)
						if(sc.2007(cpos)=40)
							GoToPos(A_Index-1,cpos+1)
						if(!Context(1))
							GoToPos(A_Index-1,cpos+1)
					}
					Context()
					Continue
				}else if(node:=cexml.SSN("//file[@id='" Current(2).ID "']/descendant::*[@text='" v.word "' and(@type='Class' or @type='Function' or @type='Instance')]")){
					type:=SSN(node,"@type").text
					if(type~="Class|Instance")
						SetTimer,AutoClass,-100
					else if(type="function")
						SetTimer,AutoParen,-40
				}else
					SetTimer,AutoMenu,-150
		}}
	}for a,sc in Edited
		Update({sc:sc.2357}),Edited()
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
	static newwin,select:=[],obj:=[],pre,sort,search,running,PrefixHotkeys:={Bookmark:"Bookmark_Search",Hotkey:"Hotkey_Search",Function:"Function_Search","Add Function Call":"Add_Function_Call",Property:"Property_Search",Label:"Search_Label",Instance:"Instance_Search",Menu:"Menu_Search",Method:"Method_Search",File:"File_Search",Class:"Class_Search"}
	if(hwnd(20))
		return
	sc:=csc()
	/*
		change the listview to a treeview
		split up the data so that all the info needed is below the top item
		this needs re-written anyway...
		When an item is selected it shows the info below
		Up/Down selects the next item like before
		but it collapses the previous item and expands the next tv item
		Sounds like fun :)
	*/
	if(sc.notes)
		csc({hwnd:gui.SSN("//*[@type='Scintilla']/@hwnd").text}),sc:=csc(),sc.2400
	/*
		if(v.LineEdited.MinIndex()!="")
			Scan_Line()
	*/
	Update({sc:sc.2357})
	Code_Explorer.AutoCList(1)
	newwin:=new GUIKeep(20),newwin.Add("Edit,goss w600 vsearch,,w","ListView,w600 h200 -hdr -Multi gosgo,Menu C|A|1|2|R|I,wh")
	;Gui,20:-Caption
	Gui,1:-Disabled
	GuiControl,20:,Edit1,%start%
	newwin.Show("Omni-Search",,,StrLen(start))
	Hotkey,IfWinActive,% newwin.ID
	for a,b in {up:"omnikey",down:"omnikey",PgUp:"omnikey",PgDn:"omnikey","^Backspace":"deleteback",Enter:"osgo"}{
		Try
			Hotkey,%a%,%b%,On
		Catch,e
			m(e.message,a,b)
	}
	oss:
	break:=1,running:=1
	SetTimer,omnisearch,-10
	return
	omnisearch:
	Gui,20:Default
	GuiControl,20:-Redraw,SysListView321
	FileSearch:=osearch:=search:=newwin[].search,Select:=[],LV_Delete(),sort:=[],stext:=[],fsearch:=search="^"?1:0
	if(InStr(search,")")){
		if(!v.Options.Clipboard_History){
			Options("Clipboard_History")
			m("Clipboard History was off. Turning it on now")
			return running:=0
		}LV_Delete()
		for a in v.Clipboard
			b:=v.Clipboard[v.Clipboard.MaxIndex()-(A_Index-1)],Sort[LV_Add("",b)]:=b
		LV_ModifyCol(1,"AutoHDR")
		GuiControl,20:+Redraw,SysListView321
		return running:=0
	}for a in Omni_Search_Class.prefix{
		osearch:=RegExReplace(osearch,"\Q" a "\E")
		if(a!=".")
			FileSearch:=RegExReplace(FileSearch,"\Q" a "\E")
	}if(InStr(search,"?")||search=""){
		LV_Delete()
		for a,b in Omni_Search_Class.Prefix{
			info:=a="+"?"Add Function Call":b
			LV_Add("",a,info,Convert_Hotkey(menus.SSN("//*[@clean='" PrefixHotkeys[info] "']/@hotkey").text))
		}
		GuiControl,20:+Redraw,SysListView321
		Loop,4
			LV_ModifyCol(A_Index,"AutoHDR")
		LV_Modify(1,"Select Vis Focus")
		GuiControl,20:+g,Edit1
		GuiControl,20:,Edit1,Fuzzy Search find Check For Update by typing @CFU
		SendMessage,0xB1,0,49,Edit1,% NewWin.ID
		GuiControl,20:+goss,Edit1
		return running:=0
	}else if(RegExMatch(search,"O)(\W)",found)){
		if(found.1="^")
			OnlyTop:=1
		pos:=1,replist:=[],find1:="",index:=1
		while,RegExMatch(search,"O)(\W)",found,pos),pos:=found.Pos(1)+found.len(1){
			if(found.1=" ")
				Continue
			if(pre:=omni_search_class.prefix[found.1]){
				replist.push(found.1)
				if(found.1="+"){
					find:="//main[@file='" Current(2).file "']/descendant::*[@type='Class' or @type='Function'"
					break
				}else if(pre)
					add:="@type='" pre "'"
				find1.=index>1?" or " add:add
			}index++
		}for a,b in replist
			search:=RegExReplace(search,"\Q" b "\E")
		find:=find1?"//*[" find1 "]":"//*"
	}else
		find:="//*"
	if(OnlyTop&&!search)
		find:="//main/file[1]",OnlyTop:=0
	if(SubStr(newwin[].search,1,1)="&")
		search:=SubStr(newwin[].search,2),find:="//*[@type='Hotkey']"
	for a,b in searchobj:=StrSplit(search)
		b:=b~="(\\|\.|\*|\?|\+|\[|\{|\||\(|\)|\^|\$)"?"\" b:b,stext[b]:=stext[b]=""?1:stext[b]+1
	list:=cexml.SN(find),break:=0,currentparent:=Current(2).file,index:=1
	while(ll:=list.Item[A_Index-1],b:=XML.EA(ll)){
		if(break){
			break:=0
			break
		}order:=ll.NodeName="file"?"filename,type,dir":b.type="menu"?"text,type,additional1":"text,type,file,args",info:=StrSplit(order,","),text:=b[info.1],rating:=0
		if(b.filename="libraries")
			Continue
		if(b.libraries)
			Continue
		if(!b.id)
			b.id:=SSN(ll,"ancestor::file/@id").text
		if(!b.file)
			b.file:=SSN(ll,"ancestor-or-self::file[@id='" b.id "']/@file").text
		if(!b.filename)
			b.filename:=SplitPath(b.file).filename
		if(v.Options.HasKey(b.clean))
			b.type:=(v.Options[b.clean]?"Enabled":"Disabled")
		if(b.type="menu"&&b.clean="Omni_Search")
			Continue
		if(fsearch){
			if(b.file=SSN(ll,"ancestor::main/@file").text)
				rating+=50
			if(currentparent=b.file)
				rating+=100
		}else{
			if(search){
				for c,d in stext{
					RegExReplace(text,"i)" c,"",count)
					if(Count<d)
						Continue,2
					if(pos:=RegExMatch(text,Upper(c)))
						rating+=100/pos
				}spos:=1
				for c,d in searchobj
					if(pos:=RegExMatch(text,"iO)(\b" d ")",found,spos),spos:=found.Pos(1)+found.len(1))
						rating+=100/pos
				for c,d in StrSplit(FileSearch," ")
					if(text~="i)\b" d)
						rating+=400
				if(currentparent=SSN(ll,"ancestor::main/@file").text)
					rating+=100
				if(FPos:=InStr(text,FileSearch))
					rating+=100/FPos
		}}if(b[info.1])
			b.node:=ll,LV_Add("",b[info.1],b[info.2],(b[info.2]="Method"?b.class " : ":"") (info.3="file"?Trim(StrSplit(b[info.3],"\").pop(),".ahk"):b[info.3]),b[info.4],rating,++Index),Select[index]:=ll
	}running:=0
	loops:=v.Options.Omni_Search_Stats?[5,[6]]:[4,[5,6]]
	Loop,% loops.1
		LV_ModifyCol(A_Index,"AutoHDR")
	for a,b in loops.2
		LV_ModifyCol(b,0)
	LV_ModifyCol(5,"Logical SortDesc"),LV_Modify(1,"Select Vis Focus")
	GuiControl,20:+Redraw,SysListView321
	return
	20Escape:
	20Close:
	newwin.SavePos(),hwnd({rem:20})
	return
	osgo:
	if(running)
		return m("here?")
	Gui,20:Default
	LV_GetText(num,LV_GetNext(),6),item:=XML.EA(node:=Select[num]),search:=newwin[].search,pre:=SubStr(search,1,1),LV_GetText(LV_Text,LV_GetNext())
	if(!num){
		LV_GetText(item,LV_GetNext())
		ControlGetText,text,Edit1,% hwnd([20])
		if(InStr(text,"?")){
			ControlSetText,Edit1,% RegExReplace(text,"\?"),% hwnd([20])
			Send,{End}
		}
		ControlFocus,Edit1,% hwnd([20])
		Send,{%item%}
	}
	if(SubStr(search,1,1)=")"){
		text:=sort[LV_GetNext()]
		return Clipboard:=text,m("Clipboard now contains:",text,"time:1")
	}
	if(InStr(search,"?")){
		LV_GetText(pre,LV_GetNext())
		ControlSetText,Edit1,%pre%,% newwin.id
		ControlSend,Edit1,^{End},% newwin.id
		return
	}else if(type:=item.launch){
		text:=Clean(item.text)
		if(type="label")
			SetTimer,%text%,-1
		else if(type="func")
			%text%()
		else if(type="option"){
			Options(text)
		}else{
			if(!FileExist(type))
				MissingPlugin(type,item.sort)
			else{
				option:=menus.SSN("//*[@clean='" RegExReplace(item.sort," ","_") "']/@option").text
				Run,%type% "%option%"
			}
		}
		hwnd({rem:20})
	}else if(pre="+"){
		hwnd({rem:20}),args:=item.args,sc:=csc(),args:=RegExReplace(args,"U)=?" chr(34) "(.*)" chr(34)),build:=item.text "("
		for a,b in StrSplit(args,",")
			comma:=A_Index>1?",":"",value:=InputBox(sc.sc,"Add Function Call","Insert a value for : " b " :`n" item.text "(" item.args ")`n" build ")",""),value:=value?value:Chr(34) Chr(34),build.=comma value
		build.=")"
		sc.2003(sc.2008,build)
	}else if(item.type="file")
		hwnd({rem:20}),tv(files.SSN("//*[@id='" SSN(node,"ancestor::main/@id").text "']/descendant::*[@id='" item.id "']/@tv").text)
	else if(item.type!="gui"){
		if(!item.id)
			item.id:=SSN(node,"ancestor::file/@id").text
		hwnd({rem:20}),tv:=files.SSN("//*[@id='" item.id "']/@tv").text
		if(TVC.Selection(1)!=tv){
			tv(tv)
			Sleep,400
		}
		if(item.type~="Bookmark|Breakpoint"){
			sc:=csc(),Text:=sc.GetUNI(),pre:=SN(node,"preceding-sibling::*[@type='" item.type "' and @text='" item.text "']").Length,Pos:=0,Search:=RegExReplace(Keywords.BreakBookFind[Item.Type],"\$1",Item.Text)
			Loop,% 1+pre
				Pos:=RegExMatch(Text,Search,,Pos+1)
			line:=sc.2166(StrPut(SubStr(Text,1,Pos),"UTF-8")-1),sc.2160(sc.2128(line),sc.2136(line)),hwnd({rem:20}),CenterSel()
		}else{
			NN:=(xx:=Keywords.Languages[LanguageFromFileExt(SSN(Node,"ancestor::file/@ext").text)]).SSN("//Code/descendant::" Item.Type)
			Omni:=GetOmni(Current(3).Lang)
			if((Parent:=NN.ParentNode)!="Code")
				Item.SelectParent:=SSN(Node.ParentNode,"@text").text,Item.ParentRegex:=RegExReplace(Omni[Parent.NodeName].Find,"\$1",Item.SelectParent)
			/*
				for a,b in Item
					List.=a " = " b "`n"
			*/
			Item.Regex:=RegExReplace(Omni[NN.NodeName].Find,"\$1",Item.Text)
			/*
				return m("Parent: " Item.ParentRegex,Item.Regex,Parent.xml)
			*/
			/*
				FIX THIS TO BE THE RIGHT THING!!!!!
				FIX ALL THE OTHER SelectText() STUFF
			*/
			Item.File:=SSN(Node,"ancestor-or-self::file/@file").text,SelectText(Item)
		}
	}
	else if(item.type="gui"){
		hwnd({rem:20}),tv(files.SSN("//*[@id='" item.id "']/@tv").text)
		Sleep,200
		csc().2160(item.pos,item.pos+StrLen(item.text)),CenterSel()
		text:=Update({get:item.file})
		if(search~=">.*>")
			m("Edit this GUI",SubStr(text,item.start,item.end-item.start))
		else
			m("Go to " item.text,SubStr(text,item.start,item.end-item.start))
	}else if(!item.text&&!item.type){
		return
	}else{
		m("Omni-Search",item.text,item.type,"Broken :(") ;leave this until I figure things out.
	}
	return
	omnikey:
	ControlSend,SysListView321,{%A_ThisHotkey%},% newwin.ahkid
	return
	deleteback:
	GuiControl,20:-Redraw,Edit1
	Send,+^{Left}{Backspace}
	GuiControl,20:+Redraw,Edit1
	return
}
One_Backup(){
	current:=Current(2).file
	SplitPath,current,,dir
	RunWait,% comspec " /C RD /S /Q " Chr(34) dir "\backup" Chr(34),,Hide
	Full_Backup()
}
Online_Help(){
	Run,https://github.com/maestrith/AHK-Studio/wiki
}
Open_Folder(){
	sc:=csc()
	file:=Current(3).file
	SplitPath,file,,dir
	if(!dir){
		file:=Current(2).file
		SplitPath,file,,dir
	}if(!dir){
		for a,b in s.ctrl{
			if(File:=files.SSN("//*[@sc='" b.2357 "']/@file").text){
				m(File)
				SplitPath,File,,Dir
				Break
			}
		}
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
		openfile:=Current(2).file
		SplitPath,openfile,,dir
		Gui,1:+OwnDialogs
		list:=Settings.SN("//Extensions/Extension"),extlist:=""
		while(ll:=list.item[A_Index-1]),ea:=XML.EA(ll)
			extlist.="*." ll.text "; "
		CloseID:=CloseSingleUntitled()
		FileSelectFile,filename,,%dir%,,% SubStr(extlist,1,-2)
		if(ErrorLevel)
			return
		if(!FileExist(filename))
			return m("File does not exist. Create a new file with File/New")
		SplitPath,filename,,,ext
		if(!Settings.SSN("//Extensions/Extension[text()='" ext "']")){
			extlist:=""
			list:=Settings.SN("//Extensions/Extension")
			while(ll:=list.item[A_Index-1]),ea:=XML.EA(ll)
				extlist.=ll.text "`n"
			if(m("AHK Studio by default can only open these file types:","",extlist,"","While " ext " files may be a text based file I had to add these restrictions to prevent opening media or other types of files","Would you like to add this to the list of acceptable extensions?","ico:!","btn:ync")="Yes")
				Settings.Under(Settings.SSN("//Extensions"),"Extension",,ext)
			else
				return
		}
		if(ff:=files.Find("//main/@file",filename))
			return tv(SSN(ff,"descendant::file/@tv").text)
		fff:=FileOpen(filename,"RW","utf-8"),file1:=file:=fff.read(fff.length)
		gosub,addfile
		if(CloseID)
			Close(files.SN("//*[@id='" CloseID "']"),,0),CloseID:=""
		Gui,1:TreeView,SysTreeView321
		filelist:=SN(files.Find("//main/@file",filename),"descendant::file"),tv(SSN(files.Find("//main/@file",filename),"file/@tv").text)
		ScanFiles(),Code_Explorer.Refresh_Code_Explorer(),PERefresh(),v.tngui.Populate()
	}else{
		CloseSingleUntitled()
		for a,b in StrSplit(filelist,"`n"){
			/*
				if(InStr(b,"'"))
					return m("Filenames and folders can not contain the ' character (Chr(39))")
			*/
			SplitPath,b,,,ext
			if(ext="lnk"){
				FileGetShortcut,%b%,b
				SplitPath,b,,,ext
			}if(!Settings.SSN("//Extensions/Extension[text()='" ext "']")){
				m("Files with the extension: " ext " are not permitted by AHK Studio.","You can add this file type if you wish in Manage File Types")
				exit
			}if(files.Find("//main/@file",b))
				Continue
			fff:=FileOpen(b,"RW","utf-8"),file1:=file:=fff.read(fff.length),filename:=b
			gosub,addfile
		}
		SetTimer,ScanFiles,-1000
		return SSN(files.Find("//main/@file",StrSplit(filelist,"`n").1),"descendant::file/@tv").text,PERefresh(),v.tngui.Populate()
	}
	return root
	AutoExpand:
	Default("SysTreeView321"),current:=TV_GetSelection(),next:=0,TVState()
	all:=files.SN("//main/descendant::*")
	while(aa:=all.item[A_Index-1]),ea:=XML.EA(aa)
		if(SSN(aa,"descendant::*"))
			TV_Modify(ea.tv,"+Expand")
	TVState(1),TV_Modify(current,"Select Vis Focus")
	return
	addfile:
	Gui,1:Default
	SplitPath,filename,fn,dir,,nne
	FileGetTime,time,%filename%
	GuiControl,1:+g,SysTreeView321
	GuiControl,1:-Redraw,SysTreeView321
	Extract(filename),FEUpdate()
	if(!Settings.SSN("//open/file[text()='" filename "']"))
		Settings.Add("open/file",,filename,1)
	Gui,1:Default
	if(Redraw)
		GuiControl,1:+Redraw,SysTreeView321
	if(!v.opening)
		GuiControl,1:+gtv,SysTreeView321
	return
}
OpenHelpFile(url){
	RegRead,outdir,HKEY_LOCAL_MACHINE,SOFTWARE\AutoHotkey,InstallDir
	if(!outdir)
		SplitPath,A_AhkPath,,outdir
	if(WinExist("AutoHotkey Help ahk_class HH Parent")=0){
		Run,% outdir "\AutoHotkey.chm"
		WinWaitActive,AutoHotkey Help,,3
		Sleep,300
	}
	if(!help:=GetWebBrowser())
		return m("Please open the help file.")
	help.Navigate(url),WinActivate("AutoHotkey Help ahk_class HH Parent")
	while(help.busy)
		Sleep,10
	if(InStr(help.document.body.OuterHtml,"This page can't be displayed"))
		help.Navigate("mk:@MSITStore:C:\Program%20Files%20(x86)\AutoHotkey\AutoHotkey.chm::/docs/AutoHotkey.htm")
}
Options(x:=0){
	static list:={Virtual_Space:[2596,3],End_Document_At_Last_Line:2277,Show_EOL:2356,Show_Caret_Line:2096,Show_Whitespace:2021,Word_Wrap:2268,Hide_Indentation_Guides:2132,Center_Caret:[2403,0x04|0x08],Word_Wrap_Indicators:2460,Hide_Horizontal_Scrollbars:2130,Hide_Vertical_Scrollbars:2280},Disable,options,other
	if(x="startup"){
		v.Options:=[]
		disable:="Center_Caret|Disable_Autosave|Disable_Backup|Disable_Line_Status|Disable_Variable_List|Word_Wrap_Indicators|End_Document_At_Last_Line|Hide_File_Extensions|Hide_Indentation_Guides|Remove_Directory_Slash|Run_As_Admin|Show_Caret_Line|Show_EOL|Show_Type_Prefix|Show_WhiteSpace|Warn_Overwrite_On_Export|Hide_Horizontal_Scrollbars|Hide_Vertical_Scrollbars|Virtual_Space"
		options:="Add_Margins_To_Windows|Disable_Auto_Advance|Auto_Close_Find|Auto_Expand_Includes|Auto_Indent_Comment_Lines|Auto_Set_Area_On_Quick_Find|Auto_Space_After_Comma|Autocomplete_Enter_Newline|Build_Comment|Center_Caret|Check_For_Edited_Files_On_Focus|Auto_Check_For_Update_On_Startup|Clipboard_History|Copy_Selected_Text_on_Quick_Find|Disable_Auto_Complete|Auto_Complete_In_Quotes|Auto_Complete|Auto_Complete_While_Tips_Are_Visible|Disable_Auto_Delete|Disable_Auto_Indent_For_Non_Ahk_Files|Disable_Auto_Insert_Complete|Disable_Autosave|Disable_Backup|Disable_Compile_AHK|Context_Sensitive_Help|Disable_Folders_In_Project_Explorer|Disable_Include_Dialog|Disable_Line_Status|Disable_Variable_List|Enable_Close_On_Save|End_Document_At_Last_Line|Full_Auto_Indentation|Full_Backup_All_Files|Full_Tree|Hide_File_Extensions|Hide_Indentation_Guides|Highlight_Current_Area|Includes_In_Place|Manual_Continuation_Line|New_File_Dialog|OSD|Remove_Directory_Slash|Run_As_Admin|Shift_Breakpoint|Show_Caret_Line|Show_EOL|Show_Type_Prefix|Show_WhiteSpace|Small_Icons|Top_Find|Virtual_Scratch_Pad|Warn_Overwrite_On_Export|Regex|Word_Border|Current_Area|Case_Sensitive|Greed|Multi_Line|Require_Enter_For_Search|Omni_Search_Stats|Verbose_Debug_Window|Focus_Studio_On_Debug_Breakpoint|Select_Current_Debug_Line|Global_Debug_Hotkeys|Smart_Delete|Auto_Variable_Browser|Inline_Brace|New_Include_Add_Space"
		other:="Auto_Space_After_Comma|Auto_Space_Before_Comma|Autocomplete_Enter_Newline|Disable_Auto_Delete|Disable_Auto_Insert_Complete|Disable_Folders_In_Project_Explorer|Disable_Include_Dialog|Enable_Close_On_Save|Full_Tree|Highlight_Current_Area|Manual_Continuation_Line|Small_Icons|Top_Find|Hide_Tray_Icon|Match_Any_Word|Force_UTF-8"
		special:="Word_Wrap"
		alloptions.=disable "|" options "|" other "|" special
		Sort,alloptions,UD|
		for a,b in StrSplit(alloptions,"|")
			v.Options[b]:=0
		if(Settings.SSN("//options[@Auto_Project_Explorer_Width]"))
			Settings.SSN("//options").RemoveAttribute("Auto_Project_Explorer_Width")
		opt:=Settings.EA("//options")
		for a,b in opt{
			if(v.Options.HasKey(a)&&b)
				v.Options[a]:=b
			else
				Settings.SSN("//options").RemoveAttribute(a)
		}return
	}else if(x=0)
		return new SettingsClass("Options")
	if(x~=Disable){
		sc:=csc(),OnOff:=Settings.SSN("//options/@" x).text?0:1,att:=[],att[x]:=OnOff,Settings.Add("options",att),v.Options[x]:=OnOff,ToggleMenu(x),sc[list[x]](OnOff),ea:=Settings.EA("//options")
		for c,d in s.ctrl{
			for a,b in ea{
				if(!IsObject(list[a])){
					if(a~="Hide_Indentation_Guides|Hide_Horizontal_Scrollbars|Hide_Vertical_Scrollbars")
						b:=b?0:1
					d[list[a]](b)
				}Else if IsObject(list[a])&&b
					d[list[a].1](list[a].2,list[a].3)
				else if IsObject(list[a])&&OnOff=0
					d[list[a].1](0)
		}}
		if(x="Hide_Indentation_Guides")
			OnOff:=OnOff?0:1,sc[list[x]](OnOff)
		if(x="Word_Wrap_Indicators")
			OnOff:=OnOff?4:0,sc[list[x]](OnOff)
		if(x="Hide_File_Extensions"||x=""){
			fl:=files.SN("//file")
			GuiControl,1:-Redraw,SysTreeView321
			while(ff:=fl.item[A_Index-1]),ea:=XML.EA(ff)
				TVC.Modify(1,(ea.edited?"*":"")(v.Options.Hide_File_Extensions?ea.nne:ea.filename),ea.tv)
			GuiControl,1:+Redraw,SysTreeView321
		}if(x="Remove_Directory_Slash")
			FEUpdate(1)
		if(x="margin_left")
			csc().2155(0,6)
		if(x="Center_Caret")
			sc.2402((OnOff?0x04|0x8:0x8),0),sc.2403((OnOff?0x04|0x8:0x8),0)
	}else if(x~=other){
		OnOff:=Settings.SSN("//options/@" x).text?0:1,att:=[],att[x]:=OnOff,Settings.Add("options",att),ToggleMenu(x)
		if(x="Small_Icons")
			return m("Requires that you restart Studio to take effect.")
		if(x="Highlight_Current_Area"){
			if(OnOff)
				HltLine()
			Else
				sc:=csc(),sc.2045(2),sc.2045(3)
		}if(x="Hide_Tray_Icon")
			Menu,Tray,% v.Options.Hide_Tray_Icon?"Icon":"NoIcon"
		v.Options[x]:=OnOff
		if(x="Top_Find")
			this:=MainWin,this.TL:={x:0,y:v.Options.Top_Find?21:0},this.BR:={x:0,y:v.Options.Top_Find?0:21},this.Size([1]),Redraw()
		if(x~="i)Disable_Folders_In_Project_Explorer|Full_Tree")
			FEUpdate(1)
	}else if(obj:=list[x]){
		OnOff:=Settings.SSN("//options/@" x).text?0:1,att:=[],att[x]:=OnOff,v.Options[x]:=OnOff,Settings.Add("options",att),ToggleMenu(x)
		for c,d in s.ctrl
			d[obj](v.Options[x])
	}else
		OnOff:=Settings.SSN("//options/@" x).text?0:1,att:=[],att[x]:=OnOff,v.Options[x]:=OnOff,Settings.Add("options",att),ToggleMenu(x)
	if(x~="Regex|Case_Sensitive|Greed|Multi_Line"){
		ToggleMenu(x)
		control:=x="Multi_Line"?"Multi-Line":RegExReplace(x,"_"," ")
		GuiControl,1:,%control%,%OnOff%
	}if(x="Top_Find")
		RefreshThemes()
}
ShowOSD(show){
	static list:=new XML("osd"),top,win:="OSD"
	if(!v.Options.OSD)
		return
	if(!hwnd(win)){
		rem:=list.SSN("//list"),rem.ParentNode.RemoveChild(rem)
		Gui,win:Destroy
		Gui,win:Default
		Gui,Color,0x111111,0x111111
		Gui,+hwndhwnd +Owner1 -DPIScale
		Gui,Margin,0,0
		hwnd(win,hwnd)
		Gui,Font,s12 c0xff00ff,Consolas
		Gui,Add,ListView,w300 h400 -Hdr,info|x
		Gui,Show,x0 y0 w0 h0 Hide NA,OSD
		WinGetPos,x,y,w,h,% hwnd([1])
		Gui,-Caption
		Gui,win:Show,% "x" (x+w-MainWin.Border)-(300) " y" y+MainWin.caption+MainWin.menu+MainWin.Border+(v.Options.top_find?.qfheight:0) " NA AutoSize",OSD
		top:=list.Add("list")
	}show:=RegExReplace(show,"_"," ")
	Gui,win:Default
	Gui,win:ListView,SysListView321
	if((ea:=XML.EA(node:=list.SSN("//list").LastChild())).name=show)
		node.SetAttribute("count",ea.count+1)
	else
		node:=list.under(top,"item",{name:show,count:1})
	LV_Delete()
	all:=list.SN("//item")
	while,aa:=all.item[A_Index-1],ea:=XML.EA(aa)
		LV_Add("",ea.name,ea.count)
	Loop,2
		LV_ModifyCol(A_Index,"AutoHDR")
	SetTimer,killosd,-2000
	return
	killosd:
	hwnd({rem:win,na:1}),rem:=list.SSN("//list"),rem.ParentNode.RemoveAttribute(rem)
	return
}
Paste(){
	ControlGetFocus,Focus,% MainWin.ID
	if(Focus="Edit1"){
		SendMessage,0x302,0,0,Edit1,% MainWin.ID
		return
	}sc:=csc(),line:=sc.2166(sc.2008),sc.2078(),sc.2179(),MarginWidth(sc),Edited(),RegExReplace(Clipboard,"\n",,count)
	Loop,% count+1
		LineStatus.Add(line+(A_Index-1),2)
	if(v.Options.Full_Auto_Indentation)
		FixIndentArea()
	sc.2079
	SetTimer,Scan_Line,-1
}
PDX(){
	GuiControl,98:-Redraw,SysTreeView321
	xx:=debug.xml
	all:=xx.SN("//variables/descendant::*[@update]")
	Default("SysTreeView321",98)
	while(aa:=all.item[A_Index-1],ea:=XML.EA(aa)){
		value:=debug.Decode(aa.text),TV_Modify(ea.tv,"",ea.fullname (value!=""?" = " value:""))
	}
	GuiControl,98:+Redraw,SysTreeView321
}
PERefresh(){
	Gui,1:Default
	GuiControl,+Redraw,SysTreeView321
}
Personal_Variable_List(){
	static
	newwin:=new GUIKeep(6),newwin.Add("ListView,w200 h400,Variables,wh","Edit,w200 vvariable,,yw","Button,gaddvar Default,Add,y","Button,x+10 gvdelete,Delete Selected,y")
	newwin.Show("Variables",1),vars:=Settings.SN("//Variables/*")
	ControlFocus,Edit1,% hwnd([6])
	while,vv:=vars.item(A_Index-1)
		LV_Add("",vv.text)
	ControlFocus,Edit1,% hwnd([6])
	return
	vdelete:
	while,LV_GetNext(){
		LV_GetText(string,LV_GetNext()),rem:=Settings.SSN("//Variable[text()='" string "']")
		rem.ParentNode.RemoveChild(rem),LV_Delete(LV_GetNext())
	}
	return
	addvar:
	if(!variable:=newwin[].variable)
		return
	if(!Settings.SSN("//Variables/Variable[text()='" variable "']"))
		Settings.Add("Variables/Variable",,variable,1),LV_Add("",variable)
	Settings.Transform()
	ControlSetText,Edit1,,% hwnd([6])
	return
	6Close:
	6Escape:
	Keywords.RefreshPersonal(),newwin.SavePos(),hwnd({rem:6})
	return
}
Plug(refresh:=0){
	if(!FileExist("plugins"))
		FileCreateDir,Plugins
	plHks:=[]
	if(refresh){
		list:=menus.SN("//main/menu[@clean='Plugin']/menu")
		while,ll:=list.item[A_Index-1],ea:=XML.EA(ll)
			if(!FileExist(ea.plugin))
				ll.ParentNode.RemoveChild(ll)
	}Loop,Files,plugins\*.ahk
	{
		if(!plugin:=menus.SSN("//menu[@clean='Plugin']"))
			plugin:=menus.Add("menu",{clean:"Plugin",name:"P&lugin"},,1)
		FileRead,plg,%A_LoopFileFullPath%
		pos:=1
		while,pos:=RegExMatch(plg,"Oim)\;menu\s+(.*)\R",found,pos){
			item:=StrSplit(found.1,","),item.1:=Trim(item.1,"`r|`r`n|`n")
			if(!ii:=menus.SSN("//*[@clean='" Clean(Trim(item.1)) "']"))
				ii:=menus.Under(plugin,"menu",{name:Trim(item.1),clean:Clean(item.1),plugin:A_LoopFileFullPath,option:item.2,hotkey:plHks[item.1]})
			else
				ii.SetAttribute("plugin",A_LoopFileFullPath),ii.SetAttribute("option",item.2)
			pos:=found.Pos(1)+1
		}if(RegExMatch(plg,";Startup"))
			ii.SetAttribute("startup",1)
	}if(refresh)
		SetTimer,RefreshMenu,-300
	return
	RefreshMenu:
	Gui,1:Default
	MenuWipe(),Omni_Search_Class.Menus()
	Gui,1:Menu,% Menu("main")
	return
}
PosInfo(){
	sc:=csc(),current:=sc.2008,line:=sc.2166(current),ind:=sc.2128(line),lineend:=sc.2136(line)
	if(sc.2008!=sc.2009)
		startline:=sc.2166(sc.2143),endline:=sc.2166(sc.2145-(sc.2007(sc.2145-1)=10?1:0))
	else
		startline:=endline:=sc.2166(sc.2143)
	return {current:current,line:line,ind:ind,lineend:lineend,start:sc.2143,end:sc.2145,startline:startline,endline:endline}
}
Previous_File(){
	Default("SysTreeView321"),prev:=0,tv:=TV_GetSelection()
	while,tv!=prev:=TV_GetNext(prev,"F")
		newtv:=prev
	TV_Modify(newtv,"Select Vis Focus")
}
Previous_Found(){
	sc:=csc(),current:=sc.2575,total:=sc.2570-1,(current=0)?sc.2574(total):sc.2574(--current),CenterSel()
}
Previous_Project(){
	current:=Current(1)
	next:=current.previousSibling?current.previousSibling:current.ParentNode.LastChild
	if(SSN(next,"@file").text="Libraries")
		next:=next.previousSibling
	tv(SSN(next,"descendant::*/@tv").text)
}
Previous_Scripts(filename=""){
	static nw
	nw:=new GUIKeep("Previous_Scripts"),nw.Add("Edit,w430 gPSSort vSort,,w","ListView,w430 h400,File,wh","Button,xm gPSOpen Default,&Open Selected,y","Button,x+M gPSRemove,&Remove Selected,y","Button,x+M gPSClean,&Clean Up Deleted Projects,y"),nw.show("Previous Scripts"),Hotkeys("Previous_Scripts",{up:"pskey",down:"pskey",PgUp:"pskey",PgDn:"pskey","+up":"pskey","+down":"pskey"})
	gosub,populateps
	return
	PSSort:
	PSBreak:=1
	Sleep,20
	PSBreak:=0
	goto,populateps
	return
	PSClean:
	scripts:=Settings.SN("//previous_scripts/*"),filelist:=[]
	while,ss:=scripts.item[A_Index-1],ea:=XML.EA(ss)
		if(!FileExist(ss.text))
			filelist.push(ss)
	for a,b in filelist
		b.ParentNode.RemoveChild(b)
	m("Removed " Round(filelist.MaxIndex()) " file" (filelist.MaxIndex()=1?"":"s")),WinActivate(hwnd([nw.win]))
	goto,PopulatePS
	return
	PSRemove:
	filelist:=[]
	while,next:=LV_GetNext()
		LV_GetText(file,next),filelist[file]:=1,LV_Modify(next,"-Select")
	scripts:=Settings.SN("//previous_scripts/*")
	while,scr:=scripts.item[A_Index-1]
		if(filelist[scr.text])
			scr.ParentNode.RemoveChild(scr)
	goto,populateps
	return
	pskey:
	key:=RegExReplace(A_ThisHotkey,"\+",,count),shift:=count?"+":""
	ControlSend,SysListView321,%shift%{%key%},% hwnd([nw.win])
	return
	Previous_ScriptsClose:
	Previous_ScriptsEscape:
	nw.Exit()
	return
	PSOpen:
	Default("SysListView321","Previous_Scripts"),openlist:=""
	while,next:=LV_GetNext()
		LV_GetText(file,next),openlist.=file "`n",LV_Modify(next,"-Select")
	Open(Trim(openlist,"`n")),tv(SSN(files.Find("//file/@file",StrSplit(openlist,"`n").1),"@tv").text),nw.Exit()
	return
	PopulatePS:
	Gui,Previous_Scripts:Default
	Gui,Previous_Scripts:ListView,SysListView321
	scripts:=Settings.SN("//previous_scripts/*")
	LV_Delete(),sort:=nw[].Sort
	while,scr:=scripts.item[A_Index-1]{
		if(PSBreak)
			break
		info:=scr.text
		SplitPath,info,filename
		if(InStr(filename,sort))
			LV_Add("",info)
	}PSBreak:=0,LV_ModifyCol(1,"AutoHDR"),LV_Modify(1,"Select Vis Focus")
	return
}
ProcessDebugXML(){
	if(!debug.VarBrowser)
		return v.ready:=1
	xx:=debug.xml
	scope:=xx.SN("//scope[not(@tv)]"),new:=xx.SN("//*[not(@tv) and @name]") ;new:=xx.SN("//*[@new]")
	while(ss:=scope.item[A_Index-1]),ea:=XML.EA(ss){
		if(SN(ss,"descendant::property").length)
			if((id:=SN(ss,"descendant-or-self::scope")).length){
				while(ii:=id.item[A_Index-1]),ea:=XML.EA(ii)
					if(!ea.tv)
						Default("SysTreeView321",98),ii.SetAttribute("tv",TV_Add(ea.name,SSN(ii.ParentNode,"@tv").text))
	}}
	while(nn:=new.item[A_Index-1]),ea:=XML.EA(nn){
		text:=nn.text,ParentTV:=SSN(nn.ParentNode,"@tv").text,nn.RemoveAttribute("new")
		if((ea.type="object"&&ea.children))
			add:="",wait:=1
		else if(ea.type="object"&&!ea.children)
			add:=" = {}"
		if(!SSN(nn,"descendant::*")&&text!="")
			add:=" = " text
		Default("SysTreeView321",98),nn.SetAttribute("tv",(tv:=TV_Add(ea.name add,ParentTV)))
		if(wait){
			if(!SSN(nn,"descendant::*"))
				Default("SysTreeView321",98),xx.Under(nn,"wait",{tv:TV_Add("Please Wait...",tv)})
			wait:=0
		}
	}
	updated:=xx.SN("//*[@updated]")
	while(uu:=updated.item[A_Index-1]),ea:=XML.EA(uu){
		text:=uu.text,ParentTV:=SSN(uu.ParentNode,"@tv").text,uu.RemoveAttribute("updated")
		if((ea.type="object"&&ea.children)){
			add:=""
			if(!SSN(uu,"descendant::*"))
				Default("SysTreeView321",98),xx.Under(uu,"wait",{tv:TV_Add("Please Wait...",ea.tv)})
		}else if(ea.type="object"&&!ea.children)
			add:=" = {}"
		else if(text="")
			add:=""
		if(!SSN(uu,"descendant::*")&&text!="")
			add:=" = " text
		Default("SysTreeView321",98),TV_Modify(ea.tv,"",ea.name add),add:=""
	}
	remove:=xx.SN("//*[@expanded=1]/wait")
	while(rr:=remove.item[A_Index-1]),ea:=XML.EA(rr){
		if(tv:=ea.tv)
			Default("SysTreeView321",98),TV_Delete(tv),rr.ParentNode.RemoveChild(rr)
	}
	v.ready:=1
	GuiControl,98:+Redraw,SysTreeView321
}
Project_Specific_AutoComplete(){
	static
	if(!Node:=Settings.Find("//autocomplete/project/@file",Current(2).file))
		Node:=Settings.Add("autocomplete/project",{file:Current(2).file},,1)
	NewWin:=new GuiKeep("Project_Specific_AutoComplete")
	NewWin.Add("ListView,w300 h300,Word List,wh","Button,gPSAAdd Default,&Add,y","Button,x+M gPSADelete,Delete Selected (Delete),y"),NewWin.Show("Project Specific AutoComplete")
	Hotkeys("Project_Specific_AutoComplete",{Delete:"PSADelete"})
	goto,PSAPopulate
	return
	PSAPopulate:
	Default("SysListView321","Project_Specific_AutoComplete"),LV_Delete()
	for a,b in StrSplit(Node.text," ")
		LV_Add("",b)
	return
	PSAAdd:
	text:=InputBox(hwnd("Project_Specific_AutoComplete"),"Add Words","Add a list of Space Delimited Words")
	for a,b in StrSplit(text," ")
		if(!RegExMatch(Node.text,"\b\Q" b "\E\b"))
			Node.text:=Node.text " " b
	goto,PSAPopulate
	return
	PSADelete:
	Default("SysListView321","Project_Specific_AutoComplete")
	while(next:=LV_GetNext(0))
		LV_GetText(text,next),Node.text:=RegExReplace(Node.text,"\Q" text "\E"),LV_Delete(next)
	Node.text:=RegExReplace(Node.text,"\s{2,}"," ")
	if(!Node.text)
		Node.ParentNode.RemoveChild(Node)
	return
	Project_Specific_AutoCompleteGuiEscape:
	Project_Specific_AutoCompleteGuiClose:
	hwnd({rem:"Project_Specific_AutoComplete"})
	return
}
Add_Selected_To_Project_Specific_AutoComplete(){
	text:=csc().getseltext()
	if(!text)
		return m("Please select some text first")
	if(!Node:=Settings.Find("//autocomplete/project/@file",Current(2).file))
		Node:=Settings.Add("autocomplete/project",{file:Current(2).file},,1)
	pos:=1
	while(RegExMatch(text,"UO)\b(\w+)\b",found,pos)){
		pos:=found.pos(1)+found.len(1)
		if((!RegExMatch(Node.text,"\b\Q" found.1 "\E\b"))&&StrLen(found.1)>1)
			Node.text:=Node.text " " found.1,list.=found.1 "`n"
		if(pos=lastpos)
			break
		lastpos:=pos
	}m("Added:",SubStr(list,1,300)(StrLen(list)>300?"...":""),"To " Current(2).file)
}
Publish(return=""){
	sc:=csc()
	text:=Update("get").1
	Save()
	mainfile:=Current(2).file
	publish:=Update({encoded:mainfile})
	includes:=SN(Current(1),"descendant::*/@include/..")
	number:=SSN(vversion.Find("//info/@file",Current(2).file),"descendant::version/@number").text
	if(!number)
		number:=SSN(vversion.Find("//info/@file",Current(2).file),"descendant::version/@name").text
	while,ii:=includes.item[A_Index-1]
		if(InStr(publish,SSN(ii,"@include").text))
			StringReplace,publish,publish,% SSN(ii,"@include").text,% Update({encoded:SSN(ii,"@file").text}),All
	rem:=SN(Current(1),"descendant::remove")
	while,rr:=rem.Item[A_Index-1]
		publish:=RegExReplace(publish,"m)^\Q" SSN(rr,"@inc").text "\E$")
	change:=Settings.SSN("//auto_version").text?Settings.SSN("//auto_version").text:"Version:=" Chr(34) "$v" Chr(34)
	if(InStr(publish,Chr(59) "auto_version"))
		publish:=RegExReplace(publish,Chr(59) "auto_version",RegExReplace(change,"\Q$v\E",number))
	publish:=RegExReplace(publish,"U)^\s*(;{.*\R|;}.*\R)","`n")
	StringReplace,publish,publish,`n,`r`n,All
	if(!publish)
		return sc.GetEnc()
	if(return)
		return publish
	Clipboard:=v.Options.Full_Auto_Indentation?PublishIndent(publish):publish
	TrayTip,AHK Studio,Code copied to your clipboard
}
PublishIndent(Code,Indent:="`t",Newline:="`r`n"){
	indentregex:=Keywords.IndentRegex[Current(3).ext],Lock:=[],Block:=[],ParentIndent:=Braces:=0,ParentIndentObj:=[]
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
		throw Exception("Include Open! You have " braces " open braces")
	return SubStr(Out,StrLen(Newline)+1)
}
QF(x:=0){
	static quickFind:=[],Find,LastFind:=[],break,select,MinMax:=new XML("MinMax"),search
	qf:
	if(v.Options.Require_Enter_For_Search&&x!="Enter")
		return
	if(x=1)
		lastFind:=[]
	sc:=csc(),startpos:=sc.2008,break:=1
	ControlGetText,Find,,% "ahk_id" MainWin.QFEdit
	if(Find=lastFind&&sc.2570>1){
		if(GetKeyState("Shift","P"))
			return current:=sc.2575,sc.2574((current=0)?sc.2570-1:current-1),CenterSel()
		return sc.2606(),CenterSel()
	}
	pre:="O",Find1:="",Find1:=v.Options.Regex?Find:"\Q" RegExReplace(Find,"\\E","\E\\E\Q") "\E",pre.=v.Options.greed?"":"U",pre.=v.Options.case_sensitive?"":"i",pre.=v.Options.multi_line?"m`n":"",Find1:=pre ")" (v.Options.Word_Border?"\b":"") Find1 (v.Options.Word_Border?"\b":"")
	if(Find=""||Find="."||Find=".*"||Find="\")
		return sc.2571
	sc.Enable()
	opos:=select.opos,select:=[],select.opos:=opos?opos:sc.2008,select.items:=[],text:=sc.GetUNI()
	if(sc.2508(0,start:=quickFind[sc.2357]+1)!=""){
		end:=sc.2509(0,start)
		if(end)
			text:=SubStr(text,1,end)
	}
	pos:=start?start:1,pos:=pos=0?1:pos,mainsel:="",index:=1,break:=0
	start:=1,rem:=MinMax.SSN("//list"),rem.ParentNode.RemoveChild(rem),top:=MinMax.Add("list")
	while(start<sc.2006){
		min:=sc.2508(2,start),max:=sc.2509(2,start)
		if((min!=0||max!=0)&&sc.2507(2,min))
			MinMax.Under(top,"sel",{min:min,max:max})
		if(min=0&&max=0){
			MinMax.Under(top,"sel",{min:0,max:sc.2006})
			break
		}
		if(min||max)
			start:=max
	}
	if(v.Options.Current_Area){
		Line:=sc.2166(sc.2008)
		if((parent:=sc.2225(line))>=0){
			MinMax.XML.LoadXML("<MinMax/>"),top:=MinMax.Add("list")
			last:=sc.2224(parent,-1)
			MinMax.Under(top,"sel",{min:sc.2167(Parent),max:sc.2167(Last)})
		}
	}
	search:=sc.GetText(),pos:=1
	while(RegExMatch(search,Find1,found,pos)){
		if(found.len(1)=0)
			break
		if(break){
			break:=0
			Break
		}
		if(found.Count()){
			if(!found.len(A_Index))
				Break
			Loop,% found.Count(){
				ns:=StrPut(SubStr(search,1,found.Pos(A_Index)),"utf-8")-2
				if(MinMax.SSN("//*[@min<='" ns "' and @max>='" ns "']"))
					select.items.push({start:ns,end:ns+StrPut(found[A_Index],"UTF-8")-1})
				pos:=found.Pos(A_Index)+found.len(A_Index)
			}
		}else{
			if(found.len=0)
				Break
			ns:=StrPut(SubStr(search,1,found.Pos(0)),"utf-8")-2
			if(MinMax.SSN("//*[@min<='" ns "' and @max>='" ns "']"))
				select.items.InsertAt(1,{start:ns,end:ns+StrPut(found[0],"UTF-8")-1})
			pos:=found.Pos(0)+found.len(0)
		}
		if(lastpos=pos)
			Break
		lastpos:=pos
	}
	lastFind:=Find
	if(select.items.MaxIndex()=1)
		obj:=select.items.1,sc.2160(obj.start,obj.end)
	else{
		num:=-1
		while(obj:=select.items.Pop()){
			if(break)
				break
			sc[A_Index=1?2160:2573](A_Index=1?obj.start:obj.end,A_Index=1?obj.end:obj.start),num:=(obj.end>select.opos&&num<0)?A_Index-1:num
		}
		if(num>=0)
			sc.2574(num)
	}select:=[],sc.Enable(1),CenterSel()
	return
	next:
	sc:=csc(),sc.2606(),sc.2169()
	return
	Clear_Selection:
	sc:=csc(),sc.2500(2),sc.2505(0,sc.2006),quickFind.remove(sc.2357)
	return
	Set_Selection:
	sc:=csc(),sc.2505(0,sc.2006),sc.2500(2)
	if(sc.2008=sc.2009)
		goto,Clear_Selection
	SetSel:=[]
	Loop,% sc.2570
		o:=[],o[sc.2577(A_Index-1)]:=1,o[sc.2579(A_Index-1)]:=1,SetSel.Insert({min:o.MinIndex(),max:o.MaxIndex()})
	for a,b in SetSel
		sc.2504(b.min,b.max-b.min)
	return
	Quick_Find:
	sc:=csc()
	if(v.Options.Copy_Selected_Text_on_Quick_Find)
		if(text:=sc.TextRange(sc.2143,sc.2145))
			ControlSetText,Edit1,% text,% hwnd([1])
	if(v.Options.Auto_Set_Area_On_Quick_Find)
		gosub,Set_Selection
	;ControlFocus,Edit1,% hwnd([1])
	ControlFocus,,% "ahk_id" MainWin.QFEdit
	ControlSend,Edit1,^A,% hwnd([1])
	lastFind:=""
	return
	Case_Sensitive:
	Regex:
	Multi_Line:
	Greed:
	Word_Border:
	Current_Area:
	Options(A_ThisLabel),lastFind:=""
	ControlGetText,text,,% "ahk_id" MainWin.QFEdit
	if(text)
		goto,qf
	return
	QFText:
	SetTimer,qf,-300
	return
}
Quick_Options(){
	new SettingsClass("Options")
}
Quick_Scintilla_Code_Lookup(){
	sc:=csc(),word:=Upper(sc.TextRange(start:=sc.2266(sc.2008,1),end:=sc.2267(sc.2008,1))),Scintilla()
	ea:=scintilla.EA("//commands/item[@name='" word "']")
	if(ea.code){
		syn:=ea.syntax?ea.code "()":ea.code,sc.2160(start,end),sc.2170(0,[syn])
		if(ea.syntax)
			sc.2025(sc.2008-1),Context()
		return
	}
	slist:=scintilla.SN("//commands/item[contains(@name,'" word "')]"),ll:="",count:=0
	while,sl:=slist.item[A_Index-1]
		ll.=SSN(sl,"@name").text " ",count++
	if(count=0)
		return
	sc.2117(1,Trim(ll)),sc.2160(start,end)
}
RButton(){
	MouseGetPos,,,win
	if(MainWin.hwnd!=win){
		MouseClick,Right
		return
	}
	MainWin.ContextMenu(1)
}
Redo(){
	csc().2011
}
Redraw(){
	WinSet,Redraw,,% MainWin.ID
}
Refresh_Code_Explorer(){
	Save(),currentfile:=Current(3).file,cexml:=new XML("cexml"),files:=new xml("files"),sc.2358(0,0),new ScanFile(1)
	Loop,2
		TVC.Delete(A_Index,0)
	TVC.Add(2,"Please Wait..."),new Omni_Search_Class(),open:=Settings.SN("//open/file"),Index_Lib_Files()
	while(oo:=open.item[A_Index-1])
		Extract(oo.text)
	FEUpdate(),tv(SSN(files.Find("//file/@file",currentfile),"@tv").text),ScanFiles(),Code_Explorer.Refresh_Code_Explorer()
}
Refresh_Project_Explorer(){
	Refresh_Code_Explorer()
}
Refresh_Plugins(){
	Plug(1)
}
RefreshThemes(RefreshColor:=0){
	static bcolor,fcolor,Controls:={1:"projectexplorer",2:"codeexplorer",3:"trackednotes",msctls_statusbar321:"statusbar"}
	if(Statusbar:=Settings.SSN("//theme/custom[@gui='1' and @control='msctls_statusbar321']"))
		SetStatus(Statusbar)
	else
		SetStatus(Settings.SSN("//theme/default"))
	ea:=Settings.EA("//theme/default")
	default:=ea.Clone()
	tf:=v.Options.Top_Find
	cea:=Settings.EA("//theme/find")
	bcolor:=(cea.tb!=""&&tf)?cea.tb:(cea.bb!=""&&!tf)?cea.bb:ea.Background
	fcolor:=(cea.tf!=""&&tf)?cea.tf:(cea.bf!=""&&!tf)?cea.bf:ea.Color
	for win,b in hwnd("get"){
		WinGet,ControlList,ControlList,% "ahk_id" b
		Gui,%win%:Default
		Gui,Color,% RGB(bcolor),% RGB(cea.qfb!=""?cea.qfb:bcolor)
		for a,b in StrSplit(ControlList,"`n"){
			List.=b "`n"
			if((b~="i)Static1|Button|Edit1")&&win=1){
				GuiControl,% "1:+background" RGB(bcolor) " c" RGB(fcolor),%b%
			}else{
				ControlGet,HWND,HWND,,%b%,% hwnd([win])
				if(win=1&&(NodeName:=TVC.HWND[HWND])){
					if(Node:=Settings.SSN("//theme/" NodeName))
						text:=CompileFont(Node),ea:=XML.EA(Node)
					else
						text:=CompileFont(Settings.SSN("//theme/default")),ea:=Default
				}if(b="msctls_statusbar321")
					Text:=CompileFont(Statusbar),ea:=XML.EA(Statusbar)
				Gui,%win%:font,%text%,% ea.font
				GuiControl,% "+background" RGB(ea.Background!=""?ea.Background:default.Background) " c" RGB(ea.color!=""?ea.color:default.color),%HWND%
				GuiControl,% "font",%HWND%
		}}ControlGetPos,,,,h,,% "ahk_id" v.statushwnd
		v.status:=h
		SendMessage,0x2001,0,%bcolor%,,% "ahk_id" v.statushwnd
	}for a,b in Toolbar.keep{
		Gui,% b.windowname ":Color",% RGB(bcolor)
	}if(Settings.SSN("//theme/font[@style='34']"))
		2498(0,8)
	if(number:=Settings.SSN("//theme/font[@code='2188']/@value").text)
		for a,b in s.ctrl
			b.2188(number)
	all:=gui.SN("//*"),Default:=XML.EA("//theme/default")
	while(pp:=all.item[A_Index-1]),ea:=XML.EA(pp){
		if(ea.win){
			Gui,% ea.win ":Color",% Default.Background,% default.Background
			WinSet,Redraw,,% "ahk_id" ea.parent
	}}for a,b in s.Ctrl{
		if(Settings.SSN("//theme/font[@style='34']"))
			b.2498(0,8)
		if(RefreshColor)
			Color(b)
	}
}
RegexSettings(){
	ControlGet,Check,Checked,,%A_GuiControl%,% MainWin.ID
	Options(Clean(A_GuiControl))
}
RegisterID(CLSID,APPID){
	RegWrite,REG_SZ,HKCU,Software\Classes\%APPID%,,%APPID%
	RegWrite,REG_SZ,HKCU,Software\Classes\%APPID%\CLSID,,%CLSID%
	RegWrite,REG_SZ,HKCU,Software\Classes\CLSID\%CLSID%,,%APPID%
}
RelativePath(main,new){
	for a,b in {"%A_AppData%":A_AppData,"%A_AppDataCommon%":A_AppDataCommon}
		if(InStr(new,b))
			return RegExReplace(new,"\Q" b "\E",a)
	VarSetCapacity(relative,260)
	if(DllCall("Shlwapi\PathRelativePathTo",ptr,&relative,str,main,"UInt",0,str,new,"UInt",0)){
		rel:=StrGet(&relative)
		if(SubStr(rel,1,2)=".\")
			return SubStr(rel,3)
		return rel
	}
}
Remove_Current_Selection(){
	sc:=csc(),main:=sc.2575,sc.2671(main),sc.2606,sc.2169
}
Remove_Include(){
	current:=Current(),mainnode:=Current(1),Parent:=Current(1)
	if(Current(3).file=Current(2).file)
		return m("Can not remove the main Project")
	if(m("Are you sure you want to remove this Include?","btn:yn","def:2")="no")
		return
	MainTV:=files.SSN("//main[@id='" Current(2).ID "']/file/@tv").text,HistoryEA:=Current(3)
	all:=files.SN("//main[@id='" Current(2).ID "']/descendant::file"),contents:=Update("get").1,inc:=Current(3).include
	while(aa:=all.item[A_Index-1],ea:=XML.EA(aa)){
		text:=contents[ea.file]
		if(InStr(text,inc)){
			if(m("Permanently delete this file?","btn:yn","def:2")="Yes")
				FileDelete,% HistoryEA.file
			Update({file:ea.file,text:RegExReplace(text,"\R?\Q" inc "\E\R?","`n")})
			files.SSN("//main[@id='" Current(2).ID "']/file").RemoveAttribute("sc")
			if(tv:=HistoryEA.tv)
				Default("SysTreeView321"),TV_Delete(tv)
			all:=cexml.SN("//*[@id='" HistoryEA.ID "']")
			while(aa:=all.item[A_Index-1])
				aa.ParentNode.RemoveChild(aa)
			node:=files.SSN("//file[@id='" HistoryEA.ID "']"),node.ParentNode.RemoveChild(node)
			tv(MainTV),RemoveHistory(HistoryEA),Edited(Current(1)),WinSetTitle(1,Current(3))
			return
		}
	}
}
Remove_Scintilla_Window(){
	this:=MainWin,sc:=csc(),pos:=this.WinPos(sc.sc),this.NewCtrlPos:={x:pos.x,y:pos.y,win:MainWin.hwnd,ctrl:sc.sc},this.Delete()
}
Remove_Spaces_From_Selected(){
	sc:=csc()
	if(!text:=sc.GetSelText())
		return m("Select some text first")
	sc.2170(0,[RegExReplace(text,"\s")])
}
RemoveAllButClass(RemoveClassText,current){
	Omni:=GetOmni(SSN(Current,"@ext").text)
	for a,b in Omni{
		if(a~="Property|Class")
			Continue
		pos:=1
		while(RegExMatch(RemoveClassText,b,found,pos),pos:=found.Pos(1)+found.Len(1)){
			if(!found.len(1))
				Break
			Code_Explorer.RemoveItem(current,a,found.1)
}}}
RemoveComment(text){
	text:=Trim(text,"`n")
	if(InStr(text,Chr(59)))
		text:=RegExReplace(text,"\s+" Chr(59) ".*")
	return text
}
RemoveHistory(ea){
	while(hh:=History.SSN("//*[@id='" ea.ID "']"))
		hh.ParentNode.RemoveChild(hh)
}
RemoveLines(start,end){
	return
	static current,Classes,AllText,OText,node
	current:=Current(5),sc:=csc(),StartScan:=sc.2167(start),AllText:=sc.GetUNI(),EndScan:=sc.2136(end),LineStatus.Delete(start,end),Classes:=[]
	if(StartScan>EndScan)
		return
	if(start=end&&sc.2127(start)=0)
		return
	RemoveClassText:=text:=OText:=sc.TextRange(StartScan,EndScan),Omni:=GetOmni(SSN(Current,"@ext").text)
	if(!Trim(OText))
		return
	for a,b in [start,end]
		if(sc.2225(b)>=0){
			while((b:=sc.2225(b))>=0)
				if(RegExMatch(ScanLines(b).text,Omni.Class,found))
					lastclass:=found.2
			Classes.push(lastclass)
		}
	if(Classes.1==Classes.2&&Classes.1)
		node:=SSN(current,"descendant::*[@type='Class' and @text='" Classes.1 "']"),RemoveAllButClass(text,current),Code_Explorer.RemoveTV(SN(node,"descendant-or-self::*"))
	else if(!Classes.1&&!Classes.2){
		RemoveAllButClass(text,current)
	}else if(Classes.1||Classes.2){
		class1:=GetClassText(AllText,Classes.1,,Omni),class2:=GetClassText(AllText,Classes.2,,Omni),Class(class1,current,1),Class(class2,current,1)
		for a,b in [class1,class2]{
			start:=0,total:="",text:=Trim(text,"`n")
			for c,d in StrSplit(text,"`n"){
				if(!start&&InStr(b,d))
					start:=1
				if(!InStr(b,d)&&start)
					Break
				if(start)
					total.="`n" d
			}
			StringReplace,text,text,% Trim(total,"`n")
		}RemoveAllButClass(text,current)
	}
	SetTimer,RLRC,-10
	SetTimer,RWID,-100
	return
	RWID:
	Words_In_Document(1,OText,1,1)
	return
	RLRC:
	Class(GetClassText(csc().GetUNI(),Classes.1,,GetOmni(Current(3).ext)),current)
	GuiControl,1:+Redraw,SysTreeView322
	return
}
Rename_Current_Include(current:=""){
	if(!current.xml)
		current:=Current()
	ea:=XML.EA(current)
	if(ea.file=Current(2).file)
		return m("You can not rename the main Project using this function.")
	FileSelectFile,Rename,,% ea.file,Rename Current Include,*.ahk
	if(ErrorLevel)
		return
	rename:=Filename(rename)
	Loop,Files,%rename%,F
		rnme:=A_LoopFileLongPath
	rename:=rnme?rnme:rename
	if(ErrorLevel)
		return
	if(files.Find(Current(1),"descendant-or-self::file/@file",rename))
		return m("You can not rename this the same as another #Include in the same project")
	Rename:=Filename(Rename),Code_Explorer.RemoveTV(SN((root:=cexml.Find("//file/@file",ea.file)),"descendant-or-self::*")),MainFile:=SSN(current.ParentNode,"@file").text,sc:=csc(),RootFile:=Current(2).file,Include:=Include(RootFile,Rename),text:=RegExReplace(Update({get:MainFile}),"\Q" ea.include "\E",Include),current.ParentNode.RemoveAttribute("sc"),current.SetAttribute("scan",1),Update({file:MainFile,text:text})
	if(tv:=SSN(current,"@tv").text)
		Default("SysTreeView321"),TV_Delete(tv)
	current.ParentNode.RemoveChild(current),tv(SSN(files.Find("//file/@file",MainFile),"@tv").text),Edited(current.ParentNode)
	FileMove,% ea.file,%Rename%,1
	SplashTextOn,,100,Indexing Files,Please Wait....
	Update({remove:ea.file}),Save(),Extract(RootFile),FEUpdate(RootFile),id:=SSN((main:=files.Find("//file/@file",rename)),"@id").text
	if(!root:=cexml.SSN("//*[@id='" ea.id "']"))
		root:=cexml.SSN("//*").AppendChild(main.CloneNode(0)),root.SetAttribute("type","File")
	ScanFiles(),node:=cexml.Find("//@file",ea.file),node.ParentNode.RemoveChild(node),Code_Explorer.Refresh_Code_Explorer()
	SplashTextOff
}
Replace_Selected(){
	sc:=csc(),TotalReplaced:=sc.2570,OnMessage(6,""),replace:=InputBox(sc.sc,"Replace Selected","Input text to replace what is selected"),clip:=Clipboard
	if(ErrorLevel)
		return
	for a,b in StrSplit("``r,``n,``r``n,\r,\n,\r\n",",")
		replace:=RegExReplace(replace,"i)\Q" b "\E","`n")
	Clipboard:=replace,sc.2614(1),sc.2179,Clipboard:=clip,OnMessage(6,"Activate"),SetStatus("Total Replaced: " TotalReplaced,3)
}
Replace(){
	sc:=csc(),cp:=sc.2008,word:=sc.TextRange(start:=sc.2266(cp-1,1),end:=sc.2267(cp-1,1)),rep:=Settings.SSN("//replacements/*[@replace='" word "']").text
	if(!rep)
		return
	sc.2078
	pos:=1,list:=[],foundList:=[],origRepLen:=StrLen(rep)
	while(pos:=RegExMatch(rep,"U)(\$\||\$.+\b)",found,pos)){
		if(found1="$E"){
			pos++
			Continue
		}if(!ObjHasKey(foundList,found))
			foundList[found]:=pos,List.Insert(found)
		pos++
	}
	for a,b in List{
		value:=""
		if(b!="$|"){
			value:=InputBox(sc,"Value for " b,"Insert value for: "  b "`n`n" rep)
			StringReplace,rep,rep,%b%,%value%,All
	}}if(rep){
		AddLine:=0
		if(eend:=InStr(rep,"$E"))
			RegExReplace(SubStr(rep,1,eend),"\R|" Chr(127),,AddLine)
		pos:=InStr(rep,"$|"),rep:=RegExReplace(RegExReplace(RegExReplace(rep,"\$\|"),Chr(127),"`n"),"\$E","",EOL),ind:=sc.2127(line:=sc.2166(sc.2143)),sc.2190(start),sc.2192(end),sc.2194(StrLen(rep),rep),_:=pos?sc.2025(start+pos-1):"",RegExReplace(rep,"\R",,count)
		Loop,%count%
			sc.2126(line+A_Index,ind)
		if(EOL)
			sc.2025(sc.2136(line+AddLine))
		else
			sc.2025(cp-(StrPut(word,"UTF-8")-1)+(StrPut(rep,"UTF-8")-1))
	}else if(A_ThisHotkey="+Enter")
		sc.2025(start+StrLen(rep))
	if(v.Options.Auto_Space_After_Comma)
		sc.2003(sc.2008," "),sc.2025(sc.2008+1)
	v.word:=rep?rep:word
	SetTimer,AutoMenu,-80
	sc.2079(),sc.Enable(1)
}
ReplaceText(start,end,text){
	sc:=csc(),sc.2686(start,end),sc.2194(StrPut(text,"UTF-8")-1,text)
}
Report_Bugs(){
	if(m("Do you have a Github account?","btn:yn")="Yes")
		Run,https://github.com/maestrith/AHK-Studio/issues
	else
		Run,https://gitreports.com/issue/maestrith/AHK-Studio
}
Reset_Zoom(){
	csc().2373(0),Settings.SSN("//gui/zoom").text:=0,CenterSel(),MarginWidth()
}
RGB(c){
	return Format("0x{:06X}",(c&255)<<16|c&65280|c>>16)
}
Right_Click_Menu_Editor(menu){
	static TVRCM:=new EasyView(),nw,node,lastevent,find:=[]
	nw:=new GUIKeep("RCMEditor"),node:=RCMXML.SSN("//main[@name='" menu "']")
	nw.Add("ListView,w200 h150 AltSubmit,Menus","TreeView,x+M w300 h400,,wh","ComboBox,x+M w300 gRCMF vfind","TreeView,w300 h377,,xh","ListView,xm y150 w200 h250,Commands|Hotkey,h")
	for a,b in [["l1","SysListView321","RCME"],["l2","SysListView322"],["t1","SysTreeView321"],["t2","SysTreeView322"]]
		TVRCM.Register(b.1,nw.XML.SSN("//*[@class='" b.2 "']/@hwnd").text,b.3,"RCMEditor")
	all:=RCMXML.SN("//main")
	while(aa:=all.item[A_Index-1]),ea:=XML.EA(aa)
		value:=TVRCM.Add("l1",ea.name),item:=ea.name=menu?value:item
	all:=menus.SN("//main/descendant::*"),
	while(aa:=all.item[A_Index-1]),ea:=XML.EA(aa){
		if(aa.NodeName="Separator")
			Continue
		aa.SetAttribute("tv",(tv:=TVRCM.Add("t2",(add:=Clean(ea.name,1)),SSN(aa.ParentNode,"@tv").text))),list.=add "|",find[add]:=tv
	}
	GuiControl,RCMEditor:,ComboBox1,% Trim(list,"|")
	Hotkey,IfWinActive,% nw.id
	for a,b in [["Remove Selected","RCMRS","!r"],["Add Selected","RCMAS","!a"]]{
		TVRCM.Add("l2",[b.1,Convert_Hotkey(b.3)])
		Hotkey,% b.3,% b.2
	}
	Loop,2
		LV_ModifyCol(A_Index,"AutoHDR")
	TVRCM.Enable("l1")
	startup:=1
	LV_Modify(item,"Select Vis Focus")
	startup:=0
	nw.Show("Right Click Menu Editor")
	return
	RCMF:
	if(tv:=find[nw[].find])
		TVRCM.Modify("t2",,tv,"Select Vis Focus")
	return
	RCMRS:
	TVRCM.Default("t1"),sel:=TV_GetSelection()
	if(!sel)
		return m("Select an item first")
	else{
		current:=RCMXML.SSN("//*[@tv='" sel "']")
		if(SSN(current,"@name").text~=""){
			next:=current.nextSibling?current.nextSibling:current.previousSibling
			next.SetAttribute("last",1)
			current.ParentNode.RemoveChild(current),update:=1
			Goto,RCME
		}
	}
	return
	RCMAS:
	TVRCM.Default("t2"),sel:=TV_GetSelection()
	if(!sel)
		return m("Select an item first")
	else{
		current:=menus.SSN("//*[@tv='" sel "']")
		if(SSN(current,"@name").text~=""){
			TVRCM.Default("t2"),current:=menus.SSN("//*[@tv='" TV_GetSelection() "']")
			TVRCM.Default("t1"),before:=RCMXML.SSN("//*[@tv='" TV_GetSelection() "']")
			before.SetAttribute("last",1),update:=1
			before:=before.nextSibling?before.nextSibling:before
			if(!before)
				node.AppendChild(current.CloneNode(1))
			else
				before.ParentNode.InsertBefore(current.CloneNode(1),before)
			Goto,RCME
		}
	}	
	return
	RCME:
	if(A_GuiEvent~="Normal|I"|update){
		if(A_EventInfo=lastevent&&!update)
			Return
		all:=RCMXML.SN("//*[@tv]")
		while(aa:=all.item[A_Index-1])
			aa.RemoveAttribute("tv")
		TVRCM.Default("l1"),LV_GetText(menu,LV_GetNext())
		if(node:=RCMXML.SSN("//main[@name='" menu "']")){
			all:=SN(node,"descendant::*"),TVRCM.Delete("t1",0)
			while(aa:=all.item[A_Index-1]),ea:=XML.EA(aa)
				aa.SetAttribute("tv",TVRCM.Add("t1",aa.NodeName="menu"?ea.name:"<Separator>",SSN(aa.ParentNode,"@tv").text))
		}
		lastevent:=A_EventInfo,update:=0,all:=RCMXML.SN("//*[@last]")
		while(aa:=all.item[A_Index-1]),ea:=XML.EA(aa)
			TVRCM.Modify("t1","",ea.tv,"Select Vis Focus"),aa.RemoveAttribute("last")
	}
	return
	RCMEditorEscape:
	RCMEditorClose:
	nw.SavePos(),nw.Exit()
	for a,b in [menus.SN("//*[@tv]"),RCMXML.SN("//*[@tv]")]
		while(rr:=b.item[A_Index-1]),ea:=XML.EA(rr)
			rr.RemoveAttribute("tv")
	return
}
Run_Comment_Block(){
	sc:=csc(),tab:=sc.2121,line:=sc.2166(sc.2008),sc.2045(2),sc.2045(3)
	if (sc.2127(line)>0){
		up:=down:=line
		ss:=sc.2127(line)-tab
		while,sc.2127(--line)!=ss
			up:=line
		while,sc.2127(++line)!=ss
			down:=line
	}
	Dynarun(sc.textrange(sc.2128(up),sc.2136(down)))
}
Run_Program(){
	if(!debug.socket)
		return Run()
	debug.Send("run")
}
Run_Selected_Text(){
	sc:=csc()
	if(sc.2570=1)
		text:=sc.GetSelText()
	else
		Loop,% sc.2570
			tt:=sc.TextRange(sc.2585(A_Index-1),sc.2587(A_Index-1)),text.=tt "`n"
	DynaRun(text)
}
Run(){
	if(v.opening)
		return
	KeyWait,Alt,U
	sc:=csc(),Save(4),file:=Current(2).file
	if(file=A_ScriptFullPath){
		Run,%A_ScriptFullPath%
		Exit(1)
	}SetStatus("Run Script: " SplitPath(Current(2).file).Filename " @ " FormatTime("hh:mm:ss",A_Now),3)
	if(v.options.Virtual_Scratch_Pad&&InStr(Current(2).file,"Scratch Pad.ahk"))
		return DynaRun(Update({encoded:Current(3).file}))
	if(Current(2).untitled)
		return DynaRun(Update({encoded:Current(3).file}),1,Current(2).file)
	SplitPath,file,,dir,ext
	if(ext!="ahk")
		return Save()
	if(!Current(1).xml)
		return
	main:=SSN(Current(1),"@file").text
	if(FileExist(A_ScriptDir "\AutoHotkey.exe"))
		run:=Chr(34) A_ScriptDir "\AutoHotkey.exe" Chr(34) " " Chr(34) file Chr(34)
	else
		run:=FileExist(dir "\AutoHotkey.exe")?Chr(34) dir "\AutoHotkey.exe" Chr(34) " " Chr(34) file Chr(34):Chr(34) file Chr(34)
	admin:=v.options.Run_As_Admin?"*RunAs ":""
	if(!v.Options.Run_As_Admin)
		ExecScript()
	else
		Run,%admin%%run%,%dir%,,pid
	if(!IsObject(v.runpid))
		v.runpid:=[]
	v.runpid[Current(2).file]:=pid
	if(file=A_ScriptFullPath){
		sc:=csc()
		for a,b in s.ctrl{
			node:=gui.SSN("//*[@hwnd='" b.sc+0 "']"),node.SetAttribute("file",files.SSN("//*[@sc='" b.2357 "']/@file").text)
			(b.sc=sc.sc)?node.SetAttribute("last",1):node.RemoveAttribute("last")
		}
		Settings.Add("last/file").text:=Current(3).file,Positions.Save(1),Settings.Save(1)
		ExitApp
	}
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
	file:=Current(2).file
	Save()
	SplitPath,A_AhkPath,,dir
	SplitPath,file,,fdir
	Run,%dir%\%exe% "%file%",%fdir%,,pid
	if(!IsObject(v.runpid))
		v.runpid:=[]
	v.runpid[pid]:=1
}
Save_As(){
	Send,{Alt Up}
	current:=Current(1),CurrentFile:=Current(2).file,all:=SN(current,"descendant-or-self::*[@untitled]")
	while(aa:=all.item[A_Index-1])
		aa.RemoveAttribute("untitled")
	current.RemoveAttribute("untitled")
	SplitPath,CurrentFile,,dir
	if(!NewFile:=DLG_FileSave(hwnd(1),"AHK Files (*.ahk)|All Files (*.*)",,"My Dialog Text",CurrentFile))
		return
	SplitPath,Newfile,NewFN,NewDir,Ext,NNE
	/*
		FileSelectFile,Newfile,S16,%dir%,Save File As...,*.ahk
		if(ErrorLevel||Newfile="")
			return
		if(!Ext||!Settings.SSN("//Extensions/Extension[text()='" Ext "']")){
			Newfile:=NewDir "\" NNE ".ahk"
			SplitPath,Newfile,NewFN,NewDir,Ext
		}
	*/
	filelist:=SN(Current(1),"descendant::*")
	while(fl:=filelist.item[A_Index-1],ea:=XML.EA(fl)){
		if(NewFN=ea.filename&&A_Index>1)
			return m("File conflicts with an include.  Please choose another filename")
	}SplashTextOn,200,100,Creating New File(s)
	while(fl:=filelist.item[A_Index-1],ea:=XML.EA(fl)){
		filename:=ea.file
		SplitPath,filename,file
		if(v.Options["Force_UTF-8"])
			fl.SetAttribute("encoding","UTF-8"),ea.encoding:="UTF-8"
		if(A_Index=1)
			FileAppend,% Update({get:filename}),%NewDir%\%NewFN%,% ea.encoding
		else if !FileExist(NewDir "\" file)
			FileAppend,% Update({get:filename}),%NewDir%\%file%
	}SplashTextOff
	Open(Newfile),Close(files.SN("//main[@id='" Current(2).id "']")),tv(SSN(files.Find("//file/@file",Newfile),"@tv").text)
}
Save_Untitled(node,ask:=1){
	ea:=XML.EA(node),template:=GetTemplate(),text:=Update({get:ea.file})
	if(RegExReplace(template,"\R","`n")=text)
		return
	if(text!=template){
		if(ask){
			option:=m("The file " ea.file " Containing:",SubStr(text,1,100) (StrLen(text)>100?"...":""),"Has not been saved.  Save this file?","btn:ync","ico:!")
			if(option="Cancel")
				Exit
			if(option!="Yes")
				return
		}FileSelectFile,filename,S16,,Save File,*.ahk
		if(ErrorLevel)
			return
		filename:=Filename(filename),file:=FileOpen(filename,"W","UTF-8"),file.Write(RegExReplace(text,"\R","`r`n")),file.Length(file.Position),all:=SN(SSN(node,"ancestor-or-self::main"),"descendant-or-self::*[@untitled]")
		while(aa:=all.item[A_Index-1])
			aa.RemoveAttribute("untitled")
		Close(files.SN("//main[@id='" SSN(node,"@id").text "']")),Open(filename),tv(SSN(files.Find("//main/@file",filename),"descendant::*/@tv").text)
	}
}
Save(option=""){
	sc:=csc(),Update({sc:sc.2357}),info:=Update("get"),now:=A_Now
	/*
		Scan_Line()
	*/
	if(Current(3).untitled&&option!=4)
		Save_Untitled(Current(),(option=""?0:1))
	SavedFiles:=[],saveas:=[],all:=files.SN("//*[@edited]")
	while(aa:=all.item[A_Index-1]),ea:=XML.EA(aa){
		SavedFiles.Push(1),text:=RegExReplace(info.1[ea.file],"\R","`r`n"),SetStatus("Saving " ea.filename,3),updirty:=files.SN("//*[@id='" ea.id "']")
		while(uu:=updirty.item[A_Index-1]),dea:=XML.EA(uu)
			TVC.Modify(1,(v.Options.Hide_File_Extensions?dea.nne:dea.filename),dea.tv)
		if(!SplitPath(ea.file).dir)
			Continue
		if(ea.untitled&&option=3){
			Save_Untitled(aa)
			Continue
		}if(ea.untitled)
			Continue
		if(!v.Options.Disable_Backup){
			parent:=SSN(aa,"ancestor::main/@file").text
			SplitPath,parent,,dir
			if(!FileExist(dir "\AHK-Studio Backup"))
				FileCreateDir,% dir "\AHK-Studio Backup"
			if(!FileExist(dir "\AHK-Studio Backup\" now))
				FileCreateDir,% dir "\AHK-Studio Backup\" now
			FileCopy,% ea.file,% dir "\AHK-Studio Backup\" now "\" ea.filename,1 ;change this to FileOpen()
			if(ErrorLevel)
				m("There was an issue saving " ea.file,"Please close any error messages and try again")
		}LineStatus.Save(ea.id),encoding:=ea.encoding
		if(v.Options["Force_UTF-8"])
			fl:=FileOpen(ea.file,"W","UTF-8"),fl.Write(text),fl.Length(fl.Position),fl.Close(),aa.SetAttribute("encoding","UTF-8")
		else if(encoding="UTF-16")
			len:=VarSetCapacity(var,(StrPut(text,encoding)*2)),StrPut(text,&var,len,encoding),tt:=StrGet(&var,len),fl:=FileOpen(ea.file,"W",encoding),fl.Write(RegExReplace(tt,"\R","`r`n")),fl.Length(fl.Position),fl.Close()
		else if(RegExMatch(text,"[^\x0-\xFF]")&&encoding~="UTF-8"=0)
			fl:=FileOpen(ea.file,"W","UTF-8"),fl.Write(text),fl.Length(fl.Position),fl.Close(),aa.SetAttribute("encoding","UTF-8")
		else if(encoding!="utf-16")
			fl:=FileOpen(ea.file,"W",encoding),fl.Write(text),fl.Length(fl.Position),fl.Close()
		FileGetTime,time,% ea.file
		aa.SetAttribute("time",time),aa.RemoveAttribute("edited")
	}WinSetTitle(1,Current(3)),plural:=SavedFiles.MaxIndex()=1?"":"s",SetStatus(Round(SavedFiles.MaxIndex()) " File" plural " Saved",3)
	LineStatus.Save(),LineStatus.tv(),SaveGUI(),vversion.Save(1),LastFiles()
}
SaveGUI(win:=1){
	WinGet,max,MinMax,% hwnd([win])
	info:=WinPos(win)
	if(!top:=Settings.SSN("//gui/position[@window='" win "']"))
		top:=Settings.Add("gui/position",{window:win},,1)
	text:=max?top.text:info.text,top.text:=text,top.SetAttribute("max",max)
	if(max)
		top.SetAttribute("lastw",info.w),top.SetAttribute("lastah",info.ah)
	else
		top.RemoveAttribute("lastw"),top.RemoveAttribute("lastah")
}
Scan_Line(text:=""){
	while(b:=v.LineEdited.Pop()){
		Current:=Current(3),Orig:=b,Tick:=A_TickCount,Text:=ScanFile.RemoveComments(b.Text,Current.Lang),Obj:=StrSplit(Text,Chr(127))
		if(!Obj.2)
			return SetStatus("Scan_Line() " A_TickCount-Tick "ms No Results",3)
		RegExReplace(Obj.1,"\R",,Count),StartLine:=Count+1,StartPosition:=StrLen(Obj.1),AfterText:=SubStr(Obj.2,1,InStr(Obj.2,"`n",0,1,2)-1)
		if(RegExMatch(AfterText,"^\s*\{"))
			RegExMatch(Text,"OUm`n)\R?(.*\R" Chr(127) ".*\R)",Found),AfterText:=RegExReplace(Found.1,Chr(127) " ")
		Text:=Update({get:Current.File}),Pos1:=InStr(Text,"`n",0,1,b.Line),NewText:=(SubStr(Text,1,Pos1) Chr(127) " " SubStr(Text,Pos1+1)),NewText:=ScanFile.RemoveComments(NewText,Current.Lang),Obj:=StrSplit(NewText,Chr(127)),AfterText1:=SubStr(Obj.2,1,InStr(Obj.2,"`n",0,1,2)-1)
		Words:=v.words[(sc:=csc()).2357],OldWords:=RegExReplace(RegExReplace(RegExReplace(AfterText,"(\b\d+\b|\b(\w{1,2})\b)",""),"x)([^\w])","|"),"\|{2,}","|"),NewWords:=RegExReplace(RegExReplace(RegExReplace(AfterText1,"(\b\d+\b|\b(\w{1,2})\b)",""),"x)([^\w])"," "),"\s{2,}"," "),OWords:=Words,Words:=RegExReplace(Words,"\b(" Trim(OldWords,"|") ")\b"),Words.=NewWords,Words:=RegExReplace(Words,"\s{2,}"," ")
		Sort,Words,CUD%A_Space%
		v.words[sc.2357]:=Words
		FoundStartPos:=StrLen(Obj.1)
		if(RegExMatch(AfterText1,"^\s*\{"))
			RegExMatch(NewText,"OUm`n)\R?(.*\R" Chr(127) ".*\R)",Found),AfterText1:=RegExReplace(Found.1,Chr(127) " ")
		OverallFind:=RegExReplace(NewText,Chr(127) " ")
		TextObj:=StrSplit(OverallFind,"`n")
		/*
			This could be put into a timer and lowered priority
		*/
		Omni:=GetOmni(Current.Lang),OmniOrder:=Keywords.OmniOrder[Current.Lang]
		/*
			Do the Breakpoint and Bookmark stuff like below but better.
		*/
		AfterText1:=AfterText1,AddItems:=[]
		for a,b in OmniOrder{
			for c,d in b{
				Pos:=1,LastPos:=0
				if(InStr(c,Chr(127))){
					Obj:=StrSplit(c,Chr(127)),Pos:=1
					Regex:=((FindObj:=v.OmniFind[Current.Lang,Obj.1]).Regex),Count:=StartLine,LastPos2:=Pos2:=1
					if(!Parents)
						Parents:=ScanParent(OverallFind,FindObj)
					while(RegExMatch(AfterText1,d.Regex,FindIt,Pos2)){
						if(FindIt.Pos(1)=LastPos2)
							Break
						LastPos2:=FindIt.Pos(1)
						if(FindIt.Text){
							if(RegExMatch(FindIt.Text,"(" d.Exclude ")"))
								Continue
						}else
							Continue
						CurrentPos:=FindIt.Pos("Text")+StartPosition
						if(!CurrentPos)
							Continue
						PP:=Parents.SN("//*[@start<'" CurrentPos "' and @end>'" CurrentPos "']")
						if(ParentNode:=PP.Item[PP.Length-1]){
							IPos:=LastIPos:=1,Parent:=SSN(Current(5),"descendant::*[@type='" Obj.1 "' and @text='" SSN(ParentNode,"@text").text "']")
							Total:=Combine({type:Obj.2,upper:Upper(FindIt.Text),cetv:TVC.Add(2,FindIt.Text,SSN(Parent,"@cetv").text,"Vis Sort")},FindIt)
							AddItems.Push({obj:Total,parent:Parent})
							StringReplace,AfterText1,AfterText1,% FindIt.0
						}else
							Pos2:=FindIt.Pos(1)+FindIt.Len(1)
					}if(ParentItem:=AddItems.1){
						while(RegExMatch(AfterText,d.Regex,Old,IPos),IPos:=Old.Pos(1)+Old.Len(1)){
							StringReplace,AfterText,AfterText,% Old.Text
							if(IPos=LastIPos)
								Break
							LastIPos:=IPos
							RemoveNode:=SSN(ParentItem.Parent,"descendant::*[@type='" Obj.2 "' and @text='" Old.Text "']")
							if(tv:=SSN(RemoveNode,"@cetv").text)
								TVC.Delete(2,tv)
							RemoveNode.ParentNode.RemoveChild(RemoveNode)
					}}while(Item:=AddItems.Pop())
						cexml.Under(Item.Parent,"item",Item.Obj)
					Continue
				}Parent:=Current(5)
				while(RegExMatch(AfterText,d.Regex,Found)){
					StringReplace,AfterText,AfterText,% Found.Text
					if(A_Index>20){
						t("This may cause problems First!: " A_TickCount,"time:1",AfterText,LastAfterText)
						Sleep,300
					}if(AfterText=LastAfterText)
						Break
					LastAfterText:=AfterText
					if(RegExMatch(Found.Text,"(" d.Exclude ")"))
						Continue
					if(tv:=(SSN(Node:=SSN(Parent,"descendant::*[@type='" c "' and @text='" Found.Text "']"),"@cetv").text))
						TVC.Delete(2,tv)
					Node.ParentNode.RemoveChild(Node)
				}LastAfterText:=""
				while(RegExMatch(AfterText1,d.Regex,Found)){
					StringReplace,AfterText1,AfterText1,% Found.Text
					if(A_Index>20){
						t("This may cause problems Second!: " A_TickCount,"time:1")
						Sleep,300
					}if(AfterText1=LastAfterText)
						Break
					LastAfterText:=AfterText1
					if(RegExMatch(Found.Text,"(" d.Exclude ")"))
						Continue
					Total:=Combine({upper:Upper(Found.text),type:c,cetv:TVC.Add(2,Found.Text,Header(c),"Vis Sort")},Found)
					New:=cexml.Under(Parent,"item",Total)
				}
			}
		}
	}SetStatus("Scan_Line() " A_TickCount-Tick "ms Tick: " A_TickCount,3)
}
ScanChildren(){
	xx:=debug.XML,exp:=xx.SN("//descendant::*[@expanded=1]")
	while(ee:=exp.item[A_Index-1]),ea:=XML.EA(ee){
		if(!ea.transaction)
			ee.SetAttribute("transaction",(ea.transaction:=xx.SN("//*[@transaction]").length+1))
		if((list:=SN(ee,"descendant::*[@expanded=1]")).length){
			children:=1,numchildren:=Round(ea.children)
			while(ll:=list.item[A_Index-1]),cea:=XML.EA(ll)
				children++,numchildren+=cea.numchildren
			if(ee.NodeName="scope"){
				ea.fullname:=ea.name
			}
		}
		if(SN(ee,"ancestor::*[@expanded=1]").length)
			Continue
		if(children&&numchildren)
			scope:=SSN(ss,"ancestor::scope/@name").text,debug.Send("feature_set -n max_depth -v " children),debug.Send("feature_set -n max_children -v " numchildren),debug.Send("property_get -n " ea.fullname " -i " ea.transaction " -c 0")
		else
			scope:=SSN(ss,"ancestor::scope/@name").text,debug.Send("feature_set -n max_depth -v " ea.children),debug.Send("feature_set -n max_children -v " ea.numchildren),debug.Send("property_get -n " ea.fullname " -i " ea.transaction)
		children:=numchildren:=0
	}debug.Send("feature_set -n max_depth -v 0"),debug.Send("feature_set -n max_children -v 0")
	SetTimer,ProcessDebugXML,-1
}
ScanFiles(){
	list:=files.SN("//*[@scan]")
	if(Visible:=MainWin.Gui.SSN("//*[@win='1']/descendant::control[@type='Code Explorer']"))
		TVC.Delete(2,0),TVC.Add(2,"Updating Information, Please Wait...")
	Tick:=A_TickCount
	while(ll:=list.item[A_Index-1])
		WinSetTitle(1,"AHK Studio: Scanning " SSN(ll,"@file").text " Please Wait..."),ScanFile.Scan(ll),ll.RemoveAttribute("scan")
	SetStatus("File Scan " A_TickCount-Tick "ms",2)
	if(Visible)
		Code_Explorer.Refresh_Code_Explorer()
	Sleep,100
	WinSetTitle(1,files.EA("//*[@sc='" csc().2357 "']"))
	if(v.Options.Auto_Expand_Includes)
		SetTimer,AutoExpand,-200
	v.Startup:=0,Words_In_Document(1),Code_Explorer.AutoCList(1),csc({last:1})
}
ScanLines(line){
	sc:=csc(),total:=sc.2154
	if(RegExMatch(sc.GetLine(line),"^\s*\{")){
		Loop,% line+1{
			LineText:=sc.GetLine(line-(A_Index-1))
			if(SubStr(Trim(RegExReplace(LineText,"(\s+;.*)|(\s*)"),"`n"),0,1)="{"&&A_Index>1) ;#[AHK-Studio]
				return {text:text,line:line-(A_Index-1)}
			if(A_Index>1&&!RegExMatch(LineText,"^\s*;"))
				return {text:LineText text,line:line-(A_Index-1)}
			text:=LineText text
		}
	}else{
		Loop,% total-line{
			LineText:=sc.GetLine(line+(A_Index-1))
			if(SubStr(Trim(RegExReplace(LineText,"(\s+;.*)|(\s*)"),"`n"),0,1)="{"&&A_Index=1)
				return {text:LineText,line:line}
			if(RegExMatch(LineText,"^\s*\{"))
				return {text:text.=LineText,line:line} ;#[AHK-Studio]
			else if(A_Index>1&&!RegExMatch(LineText,"^\s*;"))
				return {text:text,line:line}
			else if(RegExMatch(LineText,"^\s*\}")&&A_Index>1)
				return {text:text,line:line}
			text.=LineText
		}return {text:text,line:line}
	}
}
Scintilla_Code_Lookup(){
	static slist,cs,newwin
	Scintilla(),slist:=scintilla.SN("//commands/item")
	newwin:=new GUIKeep(8),newwin.Add("Edit,Uppercase w500 gCodeSort vcs,,w","ListView,w720 h500 -Multi,Name|Code|Syntax,wh","Radio,xm Checked gCodeSort,&Commands,y","Radio,x+5 gCodeSort,C&onstants,y","Radio,x+5 gCodeSort,&Notifications,y","Button,xm ginsert Default,Insert code into script,y","Button,gdocsite,Goto Scintilla Document Site,y")
	while,sl:=slist.item(A_Index-1)
		LV_Add("",SSN(sl,"@name").text,SSN(sl,"@code").text,SSN(sl,"@syntax").text)
	newwin.Show("Scintilla Code Lookup")
	Loop,3
		LV_ModifyCol(A_Index,"AutoHDR")
	Hotkeys(8,{up:"page",down:"page",PgDn:"page",PgUp:"page"})
	return
	page:
	ControlSend,SysListView321,{%A_ThisHotkey%},% newwin.ahkid
	return
	docsite:
	Run,http://www.scintilla.org/ScintillaDoc.html
	return
	CodeSort:
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
	slist:=scintilla.SN("//" value "/*[contains(@name,'" cs "')]")
	while,(sl:=XML.EA(slist.item(A_Index-1))).name
		LV_Add("",sl.name,sl.code,sl.syntax)
	LV_Modify(1,"Select Vis Focus")
	Loop,3
		LV_ModifyCol(A_Index,"AutoHDR")
	GuiControl,1:+Redraw,SysListView321
	return
	Insert:
	LV_GetText(code,LV_GetNext(),2),hwnd({rem:8}),sc:=csc(),sc.2003(sc.2008,[code]),npos:=sc.2008+StrLen(code),sc.2025(npos)
	return
	lookupud:
	Gui,8:Default
	count:=A_ThisHotkey="up"?-1:+1,pos:=LV_GetNext()+count<1?1:LV_GetNext()+count,LV_Modify(pos,"Select Focus Vis")
	return
	8Close:
	8Escape:
	newwin.SavePos(),hwnd({rem:8})
	return
}
Scintilla_Control(){
	sc:=csc(),test:=MainWin.Gui.SN("//*[@type='Scintilla']"),list:="",v.jts:=[]
	while,ss:=test.item[A_Index-1],ea:=XML.EA(ss)
		list.=ea.file ",",v.jts[ea.file]:=ea.hwnd
	sc.2106(44),sc.2117(7,Trim(list,",")),sc.2106(32)
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
		Scintilla:=new XML("scintilla","lib\scintilla.xml")
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
	Omni_Search(":")
}
Select_Current_Word(){
	sc:=csc(),sc.2160(sc.2266(sc.2008),sc.2267(sc.2008))
}
Select_Next_Duplicate(){
	sc:=csc(),xx:=sc.2577(sc.2575())
	for a,b in v.duplicateselect[sc.2357]{
		if(xx<a){
			sc.2573(a+b,a),sc.2169()
			break
}}}
SelectAll(){
	SelectAll:
	ControlGetFocus,Focus,A
	if(!InStr(Focus,"Scintilla")){
		Send,^A
		return
	}
	sc:=csc(),count:=Abs(sc.2008-sc.2009)
	if(!count)
		sc.2013
	if(!sc.2230(line:=sc.2166(sc.2008)))
		return level:=sc.2223(line),last:=sc.2224(line,level),start:=sc.2167(line),end:=sc.2136(last),sc.2160(start,end),v.pastefold:=1
	if(v.duplicateselect[sc.2357]){
		for a,b in v.duplicateselect[sc.2357]
			if(A_Index=1)
				sc.2160(a+b,a)
		else
			sc.2573(a+b,a)
	}
	return
}
SelectFile(Filename:="",Title:="New File",Ext:="*.ahk",Options:="S16"){
	MainFile:=Current(2).file
	SplitPath,MainFile,,Dir
	if(Path:=Settings.SSN("//DefaultFolder").text){
		Dir:=Dir "\" Path
		if(!FileExist(Dir))
			FileCreateDir,%Dir%
	}
	FileSelectFile,Filename,%Options%,% Dir "\" Filename,%Title%,*.ahk
	if(ErrorLevel)
		Exit
	return Filename(Filename)
}
SelectText(Item,Node:=0){
	sc:=csc()
	if(Node){
		Node:=Item,Item:=XML.EA(Node),FEA:=XML.EA(SSN(Node,"ancestor::file"))
		if(!Ext:=FEA.Ext)
			return
		NN:=(xx:=Keywords.Languages[LanguageFromFileExt(Ext)]).SSN("//Code/descendant::" Item.Type)
		if((Parent:=NN.ParentNode).NodeName!="Code")
			Item.SelectParent:=SSN(Node.ParentNode,"@text").text,Item.SelectParentRegex:=RegExReplace(SSN(Parent,"@find").text,"\x60n")
		Item.File:=FEA.File
		if(TVC.Selection(1)!=FEA.tv){
			tv(FEA.tv)
			Sleep,400
		}Item.ID:=FEA.ID
	}Text:=Update({get:Current(3).File}),Pos:=1
	if(!Regex:=Item.Regex){
		Omni:=GetOmni(Files.SSN("//*[@id='" Item.ID "']/@ext").text)
		Regex:=RegExReplace(Omni[Item.Type].Find,"\$1",Item.Text)
	}
	if(ParentRegex:=Item.ParentRegex)
		Pos:=RegExMatch(Text,ParentRegex)
	else{
		II:=[]
		/*
			Push in all that is found and then figure out which one is right
			cause it might be inside a class or whatever
			
		*/
	}
	
	RegExMatch(Text,Regex,Found,Pos)
	Pos:=Found.Pos(1)
	Pos:=StrPut(SubStr(Text,1,Pos),"UTF-8")-2
	sc.2160(Pos,Pos+StrPut(Item.Text,"UTF-8")-1)
	
	
	
	return
	
	
	
	
	
	
	
	
	
	if(!Omni[Item.Type].Inside){
		for a,b in Omni
			List.=a " = " b "`n"
		m(List)
		Search:=GetSearchRegex(Omni[Item.Type].Regex,Item.Text)
		Pos:=1,Total:=[]
		while(RegExMatch(Text,Search,Found,Pos),Pos:=Found.Pos(1)+Found.Len(1))
			Total.Push(Found.Pos(1))
		if(!Total.2){
			Start:=StrPut(SubStr(Text,1,Total.1-1),"UTF-8")-1
			sc.2160(Start,Start+StrPut(Item.Text,"UTF-8")-1)
			return
		}
		Doc:=StrSplit(Text,"`n"),all:=xx.SN("//Code/descendant::*")
		for a,b in Total{
			RegExReplace(SubStr(Text,1,b),"\R",,Count),StartLine:=Count+1
			while(aa:=all.item[A_Index-1]){
				if(SSN(aa,"*")){
					Regex:=SSN(aa,"@regex").text,SearchText:=""
					while(StartLine>0){
						SearchText:=Doc[StartLine] "`n" SearchText
						Regex:=v.OmniFind[Current(3).Lang,aa.NodeName].Regex
						if(RegExMatch(SearchText,Regex,FoundParent))
							Break
						StartLine--
					}
					FindObj:=v.OmniFind[Current(3).Lang,aa.NodeName]
					Search:=FindObj.Open
					Pos1:=RegExMatch(Text,"\Q" SearchText "\E")
					StartPos:=Pos1
					Open:=0
					LastPos1:=0
					Multiple:=FindObj.Multiple
					/*
						return m("Search: " Search,"SearchText: " SearchText,"Multiple: " Multiple,Current(3).Lang,Item.Type)
					*/
					while(RegExMatch(Text,Search,FF,Pos1),Pos1:=FF.Open?FF.Pos("Open")+FF.Len("Open"):FF.Pos("Close")+FF.Len("Close")){
						if(RegExReplace(FF.0,"(" Multiple ")",,Count)){
							Open+=FF.Open?+Count:-Count
							SavedPos:=Pos1
							if(Open<=0&&FF.Close&&Count)
								break
					}}Start:=StrPut(SubStr(Text,1,StartPos),"UTF-8")-2,Start:=Start<0?0:Start
					End:=StrPut(SubStr(Text,1,SavedPos),"UTF-8")-2
					if(!(Start<b&&End>b)){
						Start:=StrPut(SubStr(Text,1,b),"UTF-8")-2
						sc.2160(Start,Start+StrPut(Item.Text,"UTF-8")-1)
						break
					}
					/*
						if(!Parent:=SSN(Current(5),"descendant::info[@type='" Obj.1 "' and @text='" FoundParent.1 "']"))
							Continue
						End:=StrPut(SubStr(Text,1,SavedPos),"UTF-8")-2,LinePos:=sc.2128(Orig.Line)
					*/
				}
			}
			/*
				m(Doc[Count+1],Item.Type)
			*/
		}
		
		return
	}
	for a,b in Item
		List.=a " = " b "`n"
	return m(List)
	Regex:=RegExReplace(Item.Find,"\$1",Item.Text)
	FindSearch:=Omni[Item.Type].Regex
	Regex:=GetSearchRegex(FindSearch,Item.Text)
	Node:=(xx:=Keywords.Languages[GetLanguage()]).SSN("//Code/descendant::" Item.Type)
	if(!Regex.Multi){
		Count:=0
		SelectAgain:
		if(ParentText:=Item.SelectParent){
			Search:=RegExReplace(Item.SelectParentRegex,"\$1",ParentText)
			if(RegExMatch(Text,Search,Found)){
				Pos:=Found.Pos(1)
				m(Search,Item.SelectParentRegex,ParentText)
				if(RegExMatch(Text,Regex,Found,Pos)){
					Start:=StrPut(SubStr(Text,1,Found.Pos(1)-1),"UTF-8")-1
					sc.2160(Start,Start+StrPut(Item.Text,"UTF-8")-1)
				}else{
					m("Unable to find: " Regex,"After: " Pos)
				}
			}else{
				m("Can't Find:",Search)
			}
		}else if(RegExMatch(Text,Regex,Found)){
			Tick:=A_TickCount
			ScanFile.ScanText(Files.SSN("//*[@id='" Current(3).ID "']"))
			Pos:=cexml.SSN("//*[@file='" Item.File "']/descendant::*[@type='" Item.Type "' and @text='" Item.text "']/@pos").text
			SetStatus("Scan took " A_TickCount-Tick "ms.  Change this when you get everything else working properly: " A_TickCount,2)
			;Start:=StrPut(SubStr(Text,1,Found.Pos(1)-1),"UTF-8")-1
			;sc.2160(Start,Start+StrPut(Item.Text,"UTF-8")-1)
			sc.2160(Pos,Pos+StrPut(Item.Text,"UTF-8")-1)
		}else
			m("Can't Find it.",Item.Text,List)
	}else{
		m("Most Likely Class")
	}
}
GetSearchRegex(FindSearch,Text,Replace:="Text"){
	if(RegExMatch(FindSearch,"OU)(\(\?\<" Replace "\>)",FF)){
		Start:=FF.Pos(1),Open:=0
		for a,b in StrSplit(FindSearch){
			if(A_Index<Start)
				Continue
			if(b="(")
				Open++
			if(b=")")
				Open--
			if(Open=0){
				End:=A_Index
				Regex:=SubStr(FindSearch,1,Start) Text SubStr(FindSearch,End)
				Break
	}}}if(!Regex){
		m("No Text found in the regex")
		Exit
	}Return Regex
}
Set_As_Default_Editor(){
	RegRead,current,HKCU,SOFTWARE\Classes\AutoHotkeyScript\Shell\Edit\Command
	SplitPath,A_ScriptFullPath,,,ext
	q:=Chr(34),p:=Chr(37),s:=Chr(32)
	if(ext="exe")
		New_Editor:=q A_ScriptFullPath q s q p 1 q
	else if(ext="ahk")
		New_Editor:=q A_AhkPath q s q A_ScriptFullPath q s q p 1 q
	if(InStr(current,A_ScriptFullPath))
		New_Editor:=q A_WinDir "\Notepad.exe" q s q p 1 q
	RegWrite,REG_SZ,HKCU,SOFTWARE\Classes\AutoHotkeyScript\Shell\Edit\Command,,%New_Editor%
	RegRead,output,HKCU,SOFTWARE\Classes\AutoHotkeyScript\Shell\Edit\Command
	if(InStr(output,A_ScriptName))
		m("AHK Studio is now your default editor for .ahk file")
	else if(InStr(output,"notepad.exe"))
		m("Notepad.exe is now your default editor")
	else
		m("Something went wrong :( Please restart Studio and try again.")
}
Set_New_File_Default_Folder(){
	NewFolder:=InputBox("","New Default File Folder","Enter the name of the folder you wish to have all new files created in",Settings.SSN("//DefaultFolder").text)
	if(!NewFolder)
		Rem:=Settings.SSN("//DefaultFolder"),Rem.ParentNode.RemoveChild(Rem)
	else
		Settings.Add("DefaultFolder",,NewFolder)
}
SetPos(oea:=""){
	static
	if(IsObject(oea)){
		if(oea.file&&oea.line!=""){
			sc:=csc()
			tv(SSN(files.Find("//file/@file",oea.file),"@tv").text)
			Sleep,100
			sc.2160(sc.2128(oea.line),sc.2136(oea.line))
		}else if(s.ctrl[oea.sc].sc){
			sc:=s.ctrl[oea.sc]
			if(oea.scroll!="")
				sc.2613(oea.scroll)
			if(oea.start!=""&&oea.end!="")
				sc.2160(oea.start,oea.end)
			sc.2399
			return
		}else
			sc:=csc()
		return
	}
	delay:=(WinActive("A")=hwnd(1))?1:200
	if(delay=1)
		goto,spnext
	SetTimer,spnext,-%delay%
	return
	spnext:
	sc:=csc(),sc.2397(0),node:=files.SSN("//*[@sc='" sc.2357 "']"),file:=SSN(node,"@file").text,parent:=SSN(node,"ancestor::main/@file").text,posinfo:=positions.Find(positions.Find("//main/@file",parent),"descendant::file/@file",file),doc:=SSN(node,"@sc").text,ea:=XML.EA(posinfo),fold:=ea.fold
	SetTimer,fold,-1
	return
	fold:
	if(ea.file){
		for a,b in StrSplit(fold,",")
			sc.2231(b)
		if(ea.start&&ea.end)
			sc.2160(ea.start,ea.end),sc.2399
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
SetScan(Line,Delete:=0){
	Text:=Update({get:Current(3).File}),Pos1:=InStr(Text,"`n",0,1,Line),NewText:=(SubStr(Text,1,Pos1) Chr(127) " " SubStr(Text,Pos1+1)),v.LineEdited[Line]:={text:NewText,Line:Line}
}
SetStatus(text,part=""){
	static widths:=[],width
	if(IsObject(text)){
		WinSet,Redraw,,% hwnd([1])
		ControlGetPos,,,,h,,% "ahk_id" v.statushwnd
		v.status:=h,ea:=XML.EA(text)
		return sc:=csc(),sc.2056(99,ea.font),sc.2055(99,ea.size),width:=sc.2276(99,"a")+1
	}
	Gui,1:Default
	widths[part]:=width*StrLen(text 1),SB_SetParts(widths.1,widths.2,widths.3),SB_SetText(text,part)
}
SetTimer(timer,duration){
	SetTimer,%timer%,%duration%
}
Settings(){
	new SettingsClass("Auto Insert")
}
Class SettingsClass{
	static pos:=[],Controls:=[],Sizes:=[],Node:=[],Types:=[],scc:=[],Current:=[],DefaultStyle:={"default":1,"inlinecomment":1,"numbers":1,"punctuation":1,"multilinecomment":1,"completequote":1,"incompletequote":1,"backtick":1,"linenumbers":1,"indentguide":1,"hex":1,"hexerror":1}
	__New(Tab:=""){
		for a,b in {HotkeyXML:new XML("hotkeys"),TempXML:new XML("temp"),SavedThemes:new XML("SavedThemes","Themes\SavedThemes.xml")}
			SettingsClass[a]:=b
		SettingsClass.Hotkeys:=[["Move Selected Item Up","^Up","MSIU"],["Move Selected Item Down","^Down","MSID"],["Move Checked Selected Menu","!M","MCTSM"],["Move Checked Items Up","!Up","MCIU"],["Move Checked Items Down","!Down","MCID"],["Insert Menu","!I","IM"],["Change Hotkey","Enter","CH"],["Insert Separator","!S","IS"],["Remove/Hide Menu Item","Delete","Delete"],["Clear Checks","!C","CC"],["Removed Checked Icons","^!I","RCI"],["Check All Child Menu Items","^A","CACMI"],["Random Icons","^!R","Random"]],Parent:=hwnd(1),SettingsClass.SavedThemes:=new XML("themes","Themes\SavedThemes.xml")
		if(!FileExist("Themes"))
			FileCreateDir,Themes
		if(!Settings.SSN("//autoadd"))
			Settings.Add("//autoadd")
		DetectHiddenWindows,On
		Gui,Settings:Destroy
		Gui,Settings:+Resize -DPIScale +LabelSettingsClass. hwndhwnd +ToolWindow +Owner%Parent% +MinSize700x500
		Gui,Settings:Color,0,0
		Gui,Settings:Font,c0xFFFFFF s10,Consolas
		Gui,Settings:Margin,0,0
		Gui,Settings:Add,Button,Hidden,Testing
		xx:=this.tvxml:=new XML("treeview"),this.Tabs:=[],this.Controls:=[],this.pos:=[],SettingsClass.ID:=this.ID:="ahk_id" hwnd,this.hwnd:=hwnd,SettingsClass.hwnd:=hwnd
		ControlGetPos,,,,h,Button1,% this.ID
		Hotkey,IfWinActive,ahk_id%hwnd%
		Hotkey,Escape,SettingsClose,On
		SettingsClass.Sizes.Button:=h,SettingsClass.Tabs:=[]
		for a,b in this.WindowList:=["Auto Insert","Edit Replacements","Manage File Types","Menus","Options","Theme"]
			tabs.=A_Index "|",SettingsClass.Tabs[RegExReplace(b," ","_")]:=A_Index
		Gui,Settings:Add,StatusBar,hwndsb,Testing
		ControlGetPos,,,,sbh,,ahk_id%sb%
		this.Add("TreeView,xm ym w300 h800 AltSubmit gNotifications vTesting,,MainTV,h-" sbh),this.Add("Tab,x0 y0 w0 h0 Buttons," Trim(tabs,"|"))
		this.SetTab(SettingsClass.Tabs.Options)
		this.Add("ListView,x300 ym Checked AltSubmit gNotifications vOptions,Option,Options,w-300|h-" sbh)
		Gui,Settings:Default
		for a,b in v.Options
			LV_Add((Settings.SSN("//options/@" a).text?"Check":""),RegExReplace(a,"_"," "))
		this.SetTab(SettingsClass.Tabs.Auto_Insert),this.Add("ListView,x300 ym vAI gNotifications AltSubmit,Type|Insert,AutoInsert,w-300|h-150","Text,x302,Typed Key:,TK,y-" sbh+125,"Edit,x300,,trigger,y-" sbh+105,"Text,x302,Inserted Text:,IT,y-" sbh+80,"Edit,x300,,Add,y-" sbh+60,"Button,x300 vAddButton gNotifications,&Add,AddButton,y-" sbh+30,"Button,x+M vRemoveButton gNotifications,&Remove,RemoveButton,y-" sbh+30)
		this.SetTab(SettingsClass.Tabs.Edit_Replacements),this.Add("ListView,x300 h240 ym vER gNotifications AltSubmit,Input|Replacement,ERLV,w-300","Text,x302 yp+240,Input:,ERI","Edit,x300 yp+15 vERInsert gNotifications,,ERInsert","Text,x302 yp+23,Replacement:,ERR","Edit,x300 yp+15 Multi +WantReturn vERReplace gNotifications,,ERReplace,w-300|h-350","Button,x300 vERAdd gNotifications,&Add,ERAdd,y-" sbh+30,"Button,x+M vERRemove gNotifications,&Remove,ERRemove,y-" sbh+30)
		this.SetTab(SettingsClass.Tabs.Manage_File_Types),this.Add("ListView,x300 ym,Extension,FileType,w-300|h-100","Text,,FileType:,FTT,y-" sbh+75,"Edit,w200,,FTEdit,y-" sbh+60,"Button,vFTAdd gNotifications,&Add,FTAdd,y-" sbh+35,"Button,x+M vFTRemove gNotifications,&Remove,FTRemoe,y-" sbh+35)
		this.SetTab(SettingsClass.Tabs.Menus),this.Add("ComboBox,x300 ym gNotifications vComboBox,,ComboBox,w-600","TreeView,x300 y+M Checked vMenuTV gNotifications AltSubmit,,MenuTV,w-600|h-323","ListView,h277 Icon vIcon gSelectIcon AltSubmit,Icon,Icon,w-300|y-" sbh+277,"Button,w110 gLoadDefault,&Default Icons,FButton,x-200|y-328","Button,w90 gLoadFile,&Load Icons,SButton,x-90|y-328","Listview,ym w300,Description|Hotkey,Hotkeys,x-300|h-328"),TV_Add("Please Wait...")
		this.ILAdd("init"),ib:=new Icon_Browser("",SettingsClass.Controls.Icon,"Settings",,,"Notifications"),SettingsClass.IconID:="ahk_id" SettingsClass.Controls.Icon,this.SetTab(SettingsClass.Tabs.Theme)
		Gui,Settings:Add,custom,x300 ym classScintilla hwndsc gNotifications
		this.SC({register:sc}),obj:=SettingsClass,obj.Controls.Scintilla:=sc,obj.pos["Scintilla"]:={h:-sbh,w:-300}
		if(!node:=Settings.SSN("//gui/position[@window='Settings']"))
			node:=Settings.Add("gui/position"),node.SetAttribute("window","Settings")
		SettingsClass.Node:=node
		for a,b in [[2052,32,0],[2050],[2051,5,0xFFFFFF],[2051,11,0x00AA00],[2171,1]]
			this[b.1](b.2,b.3)
		for a,b in this.WindowList
			xx.Add("item",{name:b},,1)
		parent:=xx.Under((theme:=xx.SSN("//*[@name='Theme']")),"top",{name:"Color"}),this.Default()
		for a,b in [{"Brace Match":"Indicator Reset"},{"Caret":"Caret,Caret Line Background,Debug Caret Color,Multiple Indicator Color,Width"},{"Code Explorer":"Background,Default Background,Text Style,Default Style"},{Default:"Background Color,Font Style,Reset To Default"},{"":"Indent Guide"},{"Main Selection":"Foreground,Remove Forground"},{"Multiple Selection":"Foreground,Remove Forground"},{"Project Explorer":"Background,Default Background,Text Style,Default Style"},{"Quick Find":"Bottom Background,Bottom Forground,Quick Find Clear,Quick Find Edit Background,Top Background,Top Forground"},{"":"StatusBar Text Style"}]{
			for c,d in b{
				node:=c?xx.Under(parent,"parent",{name:c}):parent
				for e,f in StrSplit(d,",")
					xx.Under(node,"theme",{name:f})
		}}parent:=xx.Under(theme,"top",{name:"Theme Options"})
		for a,b in StrSplit("Edit Theme Name,Edit Author,Export Theme,Import Theme,Save Theme",",")
			xx.Under(parent,"theme",{name:b})
		parent:=xx.Under(theme,"top",{name:"Download Themes"}),parent:=xx.Under(theme,"top",{name:"Saved Themes"})
		Gui,Settings:Default
		all:=xx.SN("//treeview/descendant::*")
		while(aa:=all.item[A_Index-1],ea:=XML.EA(aa))
			aa.SetAttribute("tv",TV_Add(ea.name,SSN(aa.ParentNode,"@tv").text))
		TV_Modify(xx.SSN("//top/@tv").text,"Expand Vis"),this.ThemeText(),SettingsClass.keep:=this,this.Color(),this.UpdateSavedThemes(),this.PopulateER(),this.PopulateAI(),this.PopulateMFT(),this.Default("Hotkeys")
		for a,b in SettingsClass.Hotkeys
			LV_Add("",b.1,Convert_Hotkey(b.2))
		this.2409(0,0)
		LV_ModifyCol(),this.Show(),this.2188(1),TV_Modify(this.tvxml.SSN("//*[@name='" Tab "']/@tv").text,"Select Vis Focus"),ib.Populate()
		Hotkey,IfWinActive,% this.ID
		for a,b in SettingsClass.Hotkeys{
			Hotkey,% b.2,SettingsHotkeys,On
			SettingsClass.HotkeyXML.Add("Hotkey",{d:b.1,k:b.2,a:b.3},,1)
		}Hotkey,IfWinActive,% "ahk_id" this.hwnd
		Hotkey,F1,SettingsTest,On
		SettingsClass.Current:=this,this.SetHighlight()
		return this
		SettingsTest:
		this:=SettingsClass.Current
		this.ThemeText(),SettingsClass.keep:=this,this.Color(),this.UpdateSavedThemes(),this.PopulateER(),this.PopulateAI(),this.PopulateMFT(),this.Default("Hotkeys")
		return
		SettingsClose:
		Gui,Settings:Destroy
		SettingsClass.SavedThemes.Save(1)
		return
	}__Call(info*){
		if(info.1+0){
			(info.2?((a:=info.2+0?"int":"str")(b:=info.2)):(a:="int",b:=0)),scc:=SettingsClass.scc
			(info.3?((c:=info.3+0?"int":"str")(d:=info.3)):(c:="int",d:=0))
			if(c="str"){
				VarSetCapacity(var,(len:=StrPut(info.3,"UTF-8"))),StrPut(info.3,&var,len,"UTF-8"),d:=&var
				c:="int"
			}resp:=DllCall(scc.fn,"Ptr",scc.ptr,"UInt",info.1,a,b,c,d,"int")
			if(info.4)
				m(scc.fn,scc.ptr,a,b,c,d,info.1,resp)
			return resp
		}
	}Add(x*){
		static
		for a,b in x{
			i:=StrSplit(b,",")
			Gui,Settings:Add,% i.1,% i.2 " hwndhwnd",% i.3
			if(i.4)
				SettingsClass.Controls[i.4]:=hwnd
			if(i.5){
				for c,d in StrSplit(i.5,"|"){
					RegExMatch(d,"(.)(.*)",found)
					SettingsClass.pos[i.4,found1]:=found2
				}
			}SettingsClass.Types[hwnd]:=i.1,SettingsClass.Types[i.4]:=i.1
		}
	}AddText(text*){
		static var
		for a,b in text{
			VarSetCapacity(var,(len:=StrPut(b.1,"UTF-8"))),StrPut(b.1,&var,len,"UTF-8"),this.2003((start:=this.2006()),&var),this.ThemeTextText.=b.1,this.2032(start),this.2033(len,b.2)
			if(b.2=255)
				SettingsClass.OpenBrace:=this.2006()-2
		}
	}Close(){
		SettingsClass.keep.Escape()
	}Color(){
		static list:={Font:2056,Size:2055,Color:2051,Background:2052,Bold:2053,Italic:2054,Underline:2059}
		GuiControl,Settings:-Redraw,Scintilla1
		this.2409(32,1),this.2050()
		if(!Settings.SSN("//theme/font[@style='96']"))
			this.2051(96,0xff00ff)
		if(!Settings.SSN("//theme/font[@style='100']"))
			this.2051(100,0x0000ff)
		for a,b in [[2080,7,6],[2242,1,20],[2082,8,0xff00ff],[2080,8,1],[2080,6,14],[2080,2,8],[2082,2,0xff00ff],[2082,6,0xC08080],[2080,3,14],[2680,3,6],[2516,1]]
			this[b.1](b.2,b.3)
		text:=this.ThemeTextText,pos:=InStr(text,"(")
		for a,b in {70:2068,71:2601}
			this.2052(a,Settings.SSN("//theme/font[@code='" b "']/@color").text)
		for a,b in {20:Settings.Get("//theme/font[@style='30']/@background",0x0000ff),21:Settings.Get("//theme/font[@style='31']/@background",0x00ff00)}
			this.2040(a,26),this.2042(a,b)
		if(node:=Settings.SSN("//theme/fold")){
			ea:=XML.EA(node)
			Loop,7
				this.2041(24+A_Index,ea.color!=""?ea.color:"0"),this.2042(24+A_Index,ea.background!=""?ea.Background:"0xaaaaaa")
		}ea:=Settings.EA("//theme/default"),this.2051(101,ea.color),this.2052(101,ea.background)
		WinGet,cl,ControlList,% this.ID
		for a,b in StrSplit(cl,"`n"){
			Gui,Settings:Font,% "c" RGB(ea.color),% ea.font
			GuiControl,% "Settings:+background" RGB(ea.Background) " c" RGB(ea.color),%b%
			GuiControl,Settings:Font,%b%
		}
		/*
			Make an RCM that you can edit the font, color, etc.
		*/
		this.2371(0),this.2188(1),Language:=GetLanguage(),Settings.Language:=Language
		Gui,Settings:Color,% RGB(ea.Background),% RGB(ea.background)
		Color(this,Language,A_ThisFunc " Settings"),ea:=Settings.EA("//theme/bracematch")
		ea.Style:=255
		if(ea.code=2082){
			this.2082(7,ea.color),this.2498(1,7)
			this.2351(SettingsClass.OpenBrace,SettingsClass.OpenBrace+1)
		}else{
			for a,b in ea{
				if((st:=list[a]))
					this[st](ea.Style,b)
				if(ea.code&&ea.value!="")
					this[ea.code](ea.value)
				else if(ea.code&&ea.bool!=1)
					this[ea.code](ea.color,0)
				else if(ea.code&&ea.bool)
					this[ea.code](ea.bool,ea.color)
			}
		}this.2246(0,1),this.2409(0,0)
		GuiControl,Settings:+Redraw,Scintilla1
		return RefreshThemes(1),MarginWidth(this)
	}ContextMenu(a*){
		for a,b in Keywords.Languages
			list.=a "`n"
		this:=SettingsClass.Current
		this.ThemeText(),SettingsClass.keep:=this,this.Color(),this.UpdateSavedThemes(),this.PopulateER(),this.PopulateAI(),this.PopulateMFT(),this.Default("Hotkeys")
		m("Language List: ",list,"Please ask maestrith to finish this...he got distracted","It's called Context Menu and it is in the Settings window")
	}Default(name:="MainTV"){
		Gui,Settings:Default
		Gui,% "Settings:" SettingsClass.Types[name],% SettingsClass.Controls[name]
	}EH(){
		static
		SettingsClass.Default("MenuTV"),node:=menus.SSN("//*[@tv='" TV_GetSelection() "']")
		Gui,EditHotkey:Destroy
		Gui,EditHotkey:Default
		Gui,Add,Text,,% "Editing hotkey for: " RegExReplace(SSN(node,"@clean").text,"_"," ")
		Gui,Add,Text,,Hotkey
		Gui,Add,Hotkey,w300 gDisplayDup vHotkey Limit1,% (hk:=SSN(node,"@hotkey").text)
		Gui,Add,Text,,Non-Standard Hotkey
		Gui,Submit,Nohide
		Gui,Add,Edit,w300 vedit gSetNonStandard,% !hotkey?Convert_Hotkey(hk):""
		Gui,Add,ListView,w300 h300,Duplicate Hotkey
		Gui,Add,Button,gSetHotkey Default,Set Hotkey
		Gui,Show,,Edit Hotkey
		return
		DisplayDup:
		Gui,EditHotkey:Submit,Nohide
		StringUpper,hotkey,hotkey
		Gui,EditHotkey:Default
		LV_Delete()
		if(!hotkey)
			return
		all:=menus.SN("//*[@hotkey='" hotkey "']")
		while(aa:=all.item[A_Index-1],ea:=XML.EA(aa)){
			LV_Add("",ea.clean)
		}
		return
		SetNonStandard:
		Gui,EditHotkey:Submit,Nohide
		GuiControl,EditHotkey:,msctls_hotkey321,%edit%
		return
		EditHotkeyGuiEscape:
		KeyWait,Escape,U
		Gui,EditHotkey:Destroy
		return
		SetHotkey:
		Gui,EditHotkey:Submit,Nohide
		Gui,EditHotkey:Destroy
		SettingsClass.Default("MenuTV")
		node:=menus.SSN("//*[@tv='" TV_GetSelection() "']")
		if(!hotkey&&!edit)
			return node.RemoveAttribute("hotkey"),TV_Modify(SSN(node,"@tv").text,,SettingsClass.TVName(node))
		if(edit){
			Try
				Hotkey,%edit%,deadend,On
			Catch m
				return m(m.message)
			hotkey:=edit
		}StringUpper,hotkey,hotkey
		all:=menus.SN("//*[@hotkey='" hotkey "']")
		if(all.length){
			if(m("Hotkey belongs to: " SSN(all.item[0],"@clean").text,"Bind to: " SSN(node,"@clean").text "?","btn:ync")!="Yes")
				return
		}while(aa:=all.item[A_Index-1],ea:=xml.EA(aa))
			aa.RemoveAttribute("hotkey"),TV_Modify(ea.tv,,SettingsClass.TVName(aa))
		node.SetAttribute("hotkey",hotkey)
		TV_Modify(SSN(node,"@tv").text,,SettingsClass.TVName(node))
		return
	}Escape(){
		Save(),Settings.Save()
		this:=SettingsClass.keep,this.Default("MenuTV"),menus.SSN("//*[@tv='" TV_GetSelection() "']").SetAttribute("last",1)
		if(SettingsClass.PopulatedMenu&&!InStr(A_ScriptName,"settings"))
			MenuWipe(),Menu(),Hotkeys()
		WinGetPos,x,y,,,% SettingsClass.keep.ID
		all:=menus.SN("//*[@tv]")
		while(aa:=all.item[A_Index-1])
			aa.RemoveAttribute("tv")
		for a,b in {x:x,y:y,w:SettingsClass.Width,h:SettingsClass.Height}
			pos.=a b " "
		SettingsClass.Node.text:=Trim(pos),SettingsClass.SavedThemes.Save(1),SettingsClass.PopulatedMenu:=0
		if(InStr(A_ScriptName,"settings"))
			ExitApp
		else
			Gui,Settings:Destroy
		SettingsClass.SavedThemes.Save(1)
	}GetTab(){
		ControlGet,tab,Tab,,SysTabControl321,% SettingsClass.ID
		return tab
	}ILAdd(file:="Shell32.dll",icon:=0){
		static ILOBJ:=[],init:=0,IL:=IL_Create(1,1)
		if(file="init")
			return this.Default("MenuTV"),ic:=IL_Add(IL,"Shell32.dll",50),ILOBJ["",""]:=0,init:=1,TV_SetImageList(IL)
		if((ii:=ILOBJ[file,icon])="")
			ii:=ILOBJ[file,icon]:=IL_Add(IL,file,icon)
		return ii
	}NN(){
		this.Default()
		return this.tvxml.SSN("//*[@tv='" TV_GetSelection() "']")
	}PopulateAI(){
		this.Default("AutoInsert"),all:=Settings.SN("//autoadd/key"),LV_Delete()
		while(aa:=all.item[A_Index-1],ea:=XML.EA(aa))
			LV_Add("",ea.trigger,ea.add)
		Loop,2
			LV_ModifyCol(A_Index,"AutoHDR")
	}PopulateER(){
		this.Default("ERLV"),all:=Settings.SN("//replacements/*"),LV_Delete()
		while(aa:=all.item[A_Index-1],ea:=XML.EA(aa))
			LV_Add("",ea.replace,aa.text)
		Loop,2
			LV_ModifyCol(A_Index,"AutoHDR")
	}PopulateMenu(){
		GuiControl,Settings:-Redraw,% SettingsClass.Controls.MenuTV
		Sleep,10
		this.Default("MenuTV"),SettingsClass.PopulatedMenu:=1,SettingsClass.MenuSearch:=[]
		all:=Menus.SN("//*/descendant::*"),TV_Delete()
		while(aa:=all.item[A_Index-1],ea:=XML.EA(aa)){
			if(name:=RegExReplace(ea.name,"&"))
				aa.SetAttribute("tv",(tv:=TV_Add(SettingsClass.TVName(aa),SSN(aa.ParentNode,"@tv").text,SettingsClass.TVOptions(aa)))),SettingsClass.MenuSearch.text.=name "|",SettingsClass.MenuSearch[name]:=tv
			if(ea.last)
				last:=SSN(aa,"@tv").text,aa.RemoveAttribute("last")
		}text:=SettingsClass.MenuSearch.text
		Sort,text,D|
		SettingsClass.MenuSearch.text:=text
		GuiControl,Settings:+Redraw,% SettingsClass.Controls.MenuTV
		GuiControl,Settings:,% SettingsClass.Controls.ComboBox,% SettingsClass.MenuSearch.text
		if(last)
			TV_Modify(last,"Select Vis Focus")
	}PopulateMFT(){
		this.Default("FileType"),all:=Settings.SN("//Extensions/*"),LV_Delete()
		while(aa:=all.item[A_Index-1])
			LV_Add("",aa.text)
		Loop,2
			LV_ModifyCol(A_Index,"AutoHDR")
	}SC(info*){
		sc:=SettingsClass.scc
		if(hwnd:=info.1.register){
			for a,b in {fn:2184,ptr:2185}
				sc[a]:=DllCall("SendMessageA",UInt,hwnd,int,b,int,0,int,0)
			sc.hwnd:=hwnd
	}}SetHighlight(){
		this:=SettingsClass.Current,this.2052(253,Settings.SSN("//theme/selback/@color").text),this.2052(254,Settings.SSN("//theme/additionalselback/@color").text),this.2160(0,0)
	}SetTab(tab){
		Gui,Settings:Tab,%tab%
	}SettingsHotkeys(){
		static EHHotkey
		SettingsHotkeys:
		tab:=SettingsClass.GetTab()
		if(SettingsClass.Tabs.Edit_Replacements=tab){
			Send,{%A_ThisHotkey%}
		}else if(SettingsClass.Tabs.Menus=tab){
			StringUpper,key,A_ThisHotkey
			xx:=SettingsClass.HotkeyXML,action:=xx.SSN("//*[@k='" key "']/@a").text,SettingsClass.Default("MenuTV"),ea:=xml.EA(node:=menus.SSN("//*[@tv='" (tv:=TV_GetSelection()) "']"))
			if(action~="MSIU|MSID"){
				SettingsClass.Default("MenuTV"),nodes:=[],nn:=node
				if(action="MSIU"){
					Loop,3
						nodes.Push(nn),nn:=nn.previousSibling
					if(nodes.3.xml||nodes.2.xml)
						new:=TV_Add(SettingsClass.TVName(node),SSN(node.ParentNode,"@tv").text,(nodes.3.xml?SSN(nodes.3,"@tv").text:"First")),TV_Modify(new,"Select Vis Focus Icon" SettingsClass.ILAdd(ea.filename,ea.icon) (ea.check?" Check":"")),TV_Delete(SSN(node,"@tv").text),node.SetAttribute("tv",new),node.ParentNode.InsertBefore(node,nodes.2)
				}else if(action="MSID"){
					Loop,3
						nodes.Push(nn),nn:=nn.nextSibling
					if(nodes.3.xml||nodes.2.xml){
						new:=TV_Add(SettingsClass.TVName(node),SSN(node.ParentNode,"@tv").text,(nodes.2.xml?SSN(nodes.2,"@tv").text:"")),TV_Modify(new,"Select Vis Focus Icon" SettingsClass.ILAdd(ea.filename,ea.icon) (ea.check?" Check":"")),TV_Delete(SSN(node,"@tv").text),node.SetAttribute("tv",new)
						if(nodes.3.xml)
							node.ParentNode.InsertBefore(node,nodes.3)
						else
							node.ParentNode.AppendChild(node)
					}
				}return
			}else if(action~="MCIU|MCID"){
				list:=[],SettingsClass.Default("MenuTV"),nodes:=[],final:=[]
				GuiControl,Settings:-Redraw,% SettingsClass.Controls.MenuTV
				if(action="MCIU"){
					node:=menus.SSN("//*[@tv='" TV_GetSelection() "']"),node.SetAttribute("last",1)
					parent:=node.ParentNode
					all:=SN(parent,"descendant::*")
					while(aa:=all.item[A_Index-1],ea:=XML.EA(aa)){
						if(ea.check){
							if(SN(aa,"preceding-sibling::*[@check]").length+1!=A_Index)
								aa.ParentNode.InsertBefore(aa,aa.previousSibling)
						}TV_Delete(ea.tv)
				}}else{
					node:=menus.SSN("//*[@tv='" TV_GetSelection() "']"),node.SetAttribute("last",1)
					parent:=node.ParentNode
					all:=SN(parent,"descendant::*")
					while(aa:=all.item[all.length-A_Index],ea:=xml.EA(aa)){
						if(SN(aa,"following-sibling::*[@check]").length+1!=A_Index&&ea.check){
							if(next:=aa.nextSibling.nextSibling)
								aa.ParentNode.InsertBefore(aa,next)
							else if(aa.nextSibling)
								aa.ParentNode.AppendChild(aa)
						}TV_Delete(ea.tv)
				}}all:=SN(parent,"descendant::*")
				while(aa:=all.item[A_Index-1],ea:=XML.EA(aa))
					aa.SetAttribute("tv",TV_Add(SettingsClass.TVName(aa),SSN(aa.ParentNode,"@tv").text,SettingsClass.TVOptions(aa)))
				if(node:=menus.SSN("//*[@last]"))
					TV_Modify(SSN(node,"@tv").text,"Select Vis Focus")
				all:=menus.SN("//*[@last]")
				while(aa:=all.item[A_Index-1])
					aa.RemoveAttribute("last")
				GuiControl,Settings:+Redraw,% SettingsClass.Controls.MenuTV
			}else if(action="IM"){
				NewMenu:=InputBox(SettingsClass.hwnd,"New Menu","Enter the name of the new menu")
				if(menus.SSN("//*[@name='" NewMenu "']"))
					return m("Menu item already exists")
				tv:=TV_Add(NewMenu,SSN(node.ParentNode,"@tv").text,SSN(node,"@tv").text)
				new:=menus.Add("menu",{clean:RegExReplace(RegExReplace(NewMenu,"\s","_"),"&"),name:NewMenu,tv:tv,user:1},,1)
				(above:=node.nextSibling)?node.ParentNode.InsertBefore(new,above):node.ParentNode.AppendChild(new)
			}else if(action="MCTSM"){
				all:=menus.SN("//*[@check]")
				if(!all.length)
					return m("Please check the menu items you wish to move")
				if(!node.HasChildNodes()&&!SSN(node,"@user"))
					return m("Please highlight a Sub-Menu item",node.HasChildNodes())
				while(aa:=all.item[A_Index-1],ea:=XML.EA(aa))
					TV_Delete(ea.tv),aa.SetAttribute("tv",TV_Add(SettingsClass.TVName(aa),SSN(node,"@tv").text,SettingsClass.TVOptions(aa))),node.AppendChild(aa)
				GuiControl,Settings:+Redraw,% SettingsClass.Controls.MenuTV
			}else if(action="CH"){
				if(node.NodeName="separator")
					return m("Separators can not have hotkeys")
				if(node.HasChildNodes())
					return m("Top level menu items can not have hotkeys")
				SettingsClass.EH()
			}else if(action="IS"){
				tv:=TV_GetPrev(ea.tv)?TV_GetPrev(ea.tv):"First"
				new:=menus.Add("separator",{clean:"<Separator>",tv:(tv:=TV_Add("<Separator>",SSN(node.ParentNode,"@tv").text,tv))},,1)
				node.ParentNode.InsertBefore(new,node)
			}else if(action="Delete"){
				all:=SN(node.ParentNode,"*[@check]")
				if(all.length){
					while(aa:=all.item[A_Index-1],ea:=XML.EA(aa)){
						if(aa.NodeName!="separator")
							(ea.Hide?aa.RemoveAttribute("hide"):aa.SetAttribute("hide",1)),TV_Modify(ea.tv,"",SettingsClass.TVName(aa))
						else
							aa.ParentNode.RemoveChild(aa),TV_Delete(ea.tv)
				}}else{
					if((ea.user&&SSN(node,"menu")))
						return m("This menu needs to be empty before you can delete it")
					if(ea.user)
						TV_Delete(ea.tv),node.ParentNode.RemoveChild(node)
					(node.NodeName="separator")?(node.ParentNode.RemoveChild(node),TV_Delete(ea.tv)):(ea.Hide?node.RemoveAttribute("hide"):node.SetAttribute("hide",1)),TV_Modify(ea.tv,"",SettingsClass.TVName(node))
			}}else if(action="CC"){
				all:=menus.SN("//*[@check]")
				while(aa:=all.item[A_Index-1],ea:=XML.EA(aa))
					TV_Modify(ea.tv,"-Check"),aa.RemoveAttribute("check")
			}else if(action="Random"){
				all:=menus.SN("//menu[not(@filename)]")
				while(aa:=all.item[A_Index-1],ea:=XML.EA(aa)){
					while(!Random){
						Random,Random,1,326
						if(A_Index=20)
							Random,Random,1,49
						if(Random>=50||Random<=53)
							Continue
					}
					for a,b in {filename:"Shell32.dll",icon:Random}
						aa.SetAttribute(a,b)
					TV_Modify(ea.tv,SettingsClass.TVOptions(aa)),Random:=""
				}
			}else if(action="RCI"){
				all:=menus.SN("//*[@check]")
				while(aa:=all.item[A_Index-1],ea:=XML.EA(aa)){
					for a,b in ["filename","icon"]
						aa.RemoveAttribute(b)
					TV_Modify(ea.tv,"Icon" 0)
			}}else if(action="CACMI"){
				all:=SN(node,"descendant-or-self::*")
				while(aa:=all.item[A_Index-1],ea:=XML.EA(aa))
					aa.SetAttribute("check",1),TV_Modify(ea.tv,"Check")
			}else{
				m("Item Coming Soon: " action)
			}
		}
		return
	}Show(){
		Gui,Settings:Show,% (SettingsClass.Node.text?SettingsClass.Node.text:"w" A_ScreenWidth-200 " h" A_ScreenHeight-200),Settings
	}Size(a,w,h){
		for a,b in SettingsClass.pos{
			hwnd:=SettingsClass.Controls[a],pos:=""
			for c,d in b
				pos.=c (c="w"?w+d:c="h"?h+d:c="x"?w+d:h+d) " "
			GuiControl,% "Settings:" (SettingsClass.Types[hwnd]~="ListView|Treeview"?"Move":"MoveDraw"),%hwnd%,%pos%
			SettingsClass.Width:=w,SettingsClass.Height:=h
		}SendMessage,0x1000+22,0,0,,% SettingsClass.IconID
	}SetColor(node,code:="",codevalue:="",attribute:="",value:=""){
		return m("This color selecting method has changed.  Please let maestrith know what color you were trying to change so he can fix it.")
	}SwitchTab(tv){
		if((node:=this.tvxml.SSN("//*[@tv='" tv "']")).NodeName="item"){
			GuiControl,Settings:Choose,SysTabControl321,% SN(node,"preceding-sibling::*").length+1
			if(SSN(node,"@name").text="Menus"&&!SettingsClass.PopulatedMenu)
				this.PopulateMenu()
		}else if(node1:=SSN(node,"ancestor::item[@name='Theme']")){
			GuiControl,Settings:Choose,SysTabControl321,% SN(node1,"preceding-sibling::*").length+1
			if(A_GuiEvent="Normal")
				this.ThemeSettings(node)
	}}ThemeSettings(node){
		static info:={Color:{Background:32}}
		Alt:=GetKeyState("Alt","P"),Ctrl:=GetKeyState("Ctrl","P")
		if(node.NodeName="parent")
			return
		parent:=SSN(node.ParentNode,"@name").text,item:=SSN(node,"@name").text
		if(Parent="Caret"){
			static CaretAtt:={Caret:"color","Caret Line Background":"lineback","Multiple Indicator Color":"multi","Debug Caret Color":"debug"}
			Node:=Settings.SSN("//caret")
			if(Attribute:=CaretAtt[Item]){
				Dlg_Color(Node,Settings.SSN("//caret"),SettingsClass.hwnd,Attribute)
			}else if(Item="Width"){
				Value:=InputBox(SettingsClass.hwnd,"Caret Width","Enter the new caret width (either 1, 2, or 3)",SSN(Node,"@width").text)
				if(Value<1||Value>3)
					return
				Node.SetAttribute("width",Value)
			}
		}else if(RegExMatch(parent,"(\w+) Explorer",found)){
			node.text:="",NodeName:=found1="Project"?"projectexplorer":"codeexplorer"
			Node:=Settings.Add("theme/" NodeName),Default:=Settings.SSN("//default")
			if(item="Default Background")
				Node.RemoveAttribute("background")
			else if(item="Background")
				Dlg_Color(Node,Default,SettingsClass.hwnd,"background")
			else if(item="Text Style"){
				Dlg_Font(Node,Default,SettingsClass.hwnd)
			}else if(item="Default Style"){
				Node.ParentNode.RemoveChild(Node)
			}
		}else if(parent="Default"){
			if(item="Background Color"){
				all:=Settings.SN("//theme/descendant::*[@background]|//Languages/descendant::*[@background]")
				while(aa:=all.item[A_Index-1])
					if(aa.NodeName!="Default")
						aa.RemoveAttribute("background")
			}else if(item="Font Style"){
				all:=Settings.SN("//theme/descendant::*|//Languages/descendant::*")
				while(aa:=all.item[A_Index-1]){
					if(aa.NodeName!="Default"){
						for a,b in StrSplit("font,bold,italic,underline,strikeout,size",",")
							aa.RemoveAttribute(b)
			}}}else if(item="Reset To Default"){
				if(m("This can not be undone, Are you sure?","btn:ync","ico:?","def:2")!="Yes")
					Exit
				node:=Settings.SSN("//theme"),node.ParentNode.RemoveChild(node),DefaultFont(),ConvertTheme(),this.Color()
			}else
				m(item " is coming soon")
		}else if(item="Indent Guide"){
			Dlg_Color(Settings.SSN("//indentguide"),Settings.SSN("//default"),SettingsClass.HWND)
		}else if(parent="Main Selection"){
			Node:=Settings.Add("theme/selfore")
			if(Item="Foreground")
				Dlg_Color(Node,,SettingsClass.HWND,"color"),Node.SetAttribute("bool",1),Node.SetAttribute("code",2067)
			else if(Item="Remove Forground")
				Node.SetAttribute("bool",0)
		}else if(Parent="Multiple Selection"){
			Node:=Settings.Add("theme/additionalselfore",{code:2600})
			if(Item="Foreground")
				Dlg_Color(Node,,SettingsClass.HWND)
			else if(Item="Remove Foreground")
				Node.ParentNode.RemoveChild(Node)
		}else if(item="StatusBar Text Style"){
			Node:=(Node:=Settings.SSN("//theme/custom[@control='msctls_statusbar321']"))?node:Settings.Add("theme/custom",{control:"msctls_statusbar321"},,1),ea:=XML.EA(node),Node.SetAttribute("gui",1),Dlg_Font(Node,,SettingsClass.hwnd)
		}else if(parent="Brace Match"){
			if(item="Indicator Reset"){
				node:=Settings.SSN("//theme/bracematch"),node.ParentNode.RemoveChild(node)
		}}else if(item="Export Theme"){
			name:=Settings.SSN("//theme/name").text,temp:=new XML("temp","Themes\" name ".xml"),font:=Settings.SSN("//theme"),temp.xml.LoadXML(font.xml),temp.Save(1),m("Exported to:",A_ScriptDir "\Themes\" name ".xml")
		}else if(item="Import Theme"){
			FileSelectFile,tt,,,,*.xml
			if(ErrorLevel)
				return
			file:=FileOpen(tt,"R","UTF-8"),tt:=file.Read(file.Length),file.Close()
			temp:=new XML("temp"),temp.xml.LoadXML(tt)
			if(!(temp.SSN("//name").xml&&temp.SSN("//author").xml&&temp.SSN("//theme").xml))
				return m("Theme not compatible")
			rem:=Settings.SSN("//theme"),rem.ParentNode.RemoveChild(rem),node:=Settings.SSN("//settings"),nn:=temp.SSN("//theme").CloneNode(1),Settings.SSN("//settings").AppendChild(nn)
		}else if(item="Edit Author"){
			author:=Settings.SSN("//theme/author"),newauthor:=InputBox(theme.sc,"New Author","Enter your name",author.text)
			if(ErrorLevel)
				return item:=""
			return author.text:=newauthor,this.ThemeText()
		}else if(item="Edit Theme Name"){
			themename:=Settings.SSN("//theme/name"),newtheme:=InputBox(theme.sc,"New Theme Name","Enter the new theme name",themename.Text)
			if(ErrorLevel)
				return event:=""
			return themename.text:=newtheme,this.ThemeText()
		}else if(item="Save Theme"){
			xx:=SettingsClass.SavedThemes,temp:=new XML("temp"),temp.xml.LoadXML(Settings.SSN("//theme").xml)
			if(!rem:=xx.SSN("//theme/name[text()='" Settings.SSN("//theme/name").text "']/.."))
				xx.SSN("//*").AppendChild(temp.SSN("//*"))
			else
				rem.ParentNode.RemoveChild(rem),xx.SSN("//*").AppendChild(temp.SSN("//*"))
			return Settings.Save(1),SettingsClass.SavedThemes.Save(1),m("Theme Saved","time:1"),this.UpdateSavedThemes()
		}else if(item="Download Themes"){
			xx:=this.tvxml
			if(!xx.SSN("//*[@name='Download Themes']/*")){
				Run,RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 8
				nx:=ComObjCreate("Msxml2.XMLHTTP"),nx.Open("GET","https://raw.githubusercontent.com/maestrith/AHK-Studio/master/lib/Themes.xml",1),nx.Send()
				while(nx.ReadyState!=4)
					Sleep,200
				nn:=SettingsClass.TempXML,nn.XML.LoadXML(nx.ResponseText),all:=xx.SN("//theme[@name='Download']/*"),this.Default(),top:=xx.SSN("//*[@name='Download Themes']")
				while(aa:=all.item[A_Index-1],ea:=XML.EA(aa))
					aa.ParentNode.RemoveChild(aa)
				all:=nn.SN("//fonts")
				while(aa:=all.item[A_Index-1])
					xx.Under(top,"DownloadedTheme",{tv:TV_Add((name:=SSN(aa,"name").text),SSN(top,"@tv").text),name:name})
				TV_Modify(xx.SSN("//*[@name='Download Themes']/*/@tv").text,"Select Vis Focus")
			}return
		}else if(parent="Download Themes"||node.NodeName="SavedTheme"){
			xx:=SettingsClass.TempXML,name:=SSN(node,"@name").text,nn:=parent="Download Themes"?xx.SSN("//name[text()='" name "']/.."):SettingsClass.SavedThemes.SSN("//name[text()='" name "']/.."),current:=Settings.SSN("//theme"),saved:=SettingsClass.SavedThemes.SSN("//name[text()='" SSN(current,"name").text "']/..")
			for a,b in ["//theme","//fonts"]
				rem:=Settings.SSN(b),rem.ParentNode.RemoveChild(rem)
			Settings.SSN("//*").AppendChild(nn.CloneNode(1))
			ConvertTheme(),this.ThemeText()
			if(parent="Download Themes"&&name){
				xx:=SettingsClass.SavedThemes
				if(!node:=xx.SSN("//name[text()='" name "']"))
					xx.SSN("//*").AppendChild(nn.CloneNode(1))
				else
					node.ParentNode.RemoveChild(node),xx.SSN("//*").AppendChild(nn.CloneNode(1))
				this.UpdateSavedThemes()
			}
		}else if(InStr(parent,"Quick Find")){
			static qfobj:={"Bottom Background":"bb","Bottom Forground":"bf","Top Background":"tb","Top Forground":"tf","Quick Find Edit Background":"qfb"}
			if(!Top:=Settings.SSN("//theme/find"))
				Top:=Settings.Add("theme/find")
			attribute:=qfobj[item]
			if(item="Quick Find Clear")
				for a,b in qfobj
					Top.RemoveAttribute(b)
			else
				ea:=xml.EA(Top),color:=Dlg_Color(Top,,SettingsClass.hwnd,qfobj[Item])
		}SettingsClass.keep.Color(),RefreshThemes()
		for a,b in s.Ctrl
			Color(b,GetLanguage(b))
	}ThemeText(){
		GuiControl,Settings:-Redraw,Scintilla1
		this.2171(0),this.2004(),this.ThemeTextText:="",Header:=((name:=Settings.SSN("//theme/name").text)?header:=name "`n":"")((author:=Settings.SSN("//theme/author").text)?"Theme by " author "`n":"") "Instructions at the bottom:`n"
		this.AddText([header,0],["Main Selection",253],[" - ",0],["Multiple Selection",254],[" <---- Additional Options in the TreeView to the Left with Main Selection * and Multiple Selection *`n`n",""])
		this.AddText(["Matching Brace Style ",0],["()",255],["`n`n",0]),EditedMarker:=this.EditedMarker:=[]
		for a,b in {edited:"<----Edited Marker (Click to change)`n",saved:"<----Saved Line`n`n"}
			EditedMarker[(Line:=this.2154()-1)]:=a,this.AddText([b,0]),this.2043(Line,(a="Edited"?20:21))
		this.EditedMarkerStartLine:=this.2166(this.2006())
		if(!ControlFile:=Keywords.GetXML(Current(3).ext))
			ControlFile:=new XML("","lib\Languages\ahk.xml")
		all:=ControlFile.SN("//Styles/*[@ex]")
		while(aa:=all.item[A_Index-1],ea:=XML.EA(aa)){
			if(ea.Fold)
				Start:=this.2166(this.2006())
			ex:=RegExReplace(RegExReplace(ea.ex,"\\n","`n"),"\\t","`t")
			if(aa.NodeName="keyword"&&ea.ex="Personal Variables")
				this.AddText(["Personal Variables = " Settings.SSN("//Variables").text "`n",ea.style])
			else if(aa.NodeName="keyword"&&ea.ex!="Personal Variables"){
				if(ea.Add)
					Add:=ControlFile.SSN(ea.Add).text
				this.AddText([ea.ex " = " aa.text " " Add "`n",ea.style])
			}else if(RegExMatch(ex,"\[\d+\]")){
				pos:=1
				while(RegExMatch(ex,"OU)\[(\d+)\](.+)((\[\d+\])|$)",Found,pos),pos:=Found.Pos(1)+Found.Len(1))
					this.AddText([Found.2,Found.1])
			}else
				this.AddText([ex,ea.style])
			if(ea.Fold){
				End:=this.2166(this.2006())
				while(Start+A_Index<=End)
					this.2043(A_Index+Start-1,(A_Index=1?31:Start+A_Index=End?28:29))
			}
		}this.AddText(["`n`nLeft Click to edit the fonts color`nControl+Click to edit the font style, size, italic...etc`nAlt+Click to change the Background color`nThis works for the Line Numbers as well",0]),this.2171(1)
		GuiControl,Settings:+Redraw,Scintilla1
	}TVName(node){
		ea:=xml.EA(node)
		return RegExReplace(RegExReplace(ea.clean,"_"," "),"&") (ea.hotkey?"  :  " Convert_Hotkey(ea.hotkey):"") (ea.hide?"  :  Hidden":"")
	}TVOptions(node){
		ea:=xml.EA(node)
		return opt:=(ea.check?"Check":"") " Icon" SettingsClass.ILAdd(ea.filename,ea.icon)
	}UpdateSavedThemes(){
		all:=SettingsClass.SavedThemes.SN("//fonts"),xx:=this.tvxml,top:=xx.SSN("//top[@name='Saved Themes']"),this.Default()
		while(aa:=all.item[A_Index-1]){
			if(!SSN(top,"SavedTheme[@name='" (name:=SSN(aa,"name").text) "']")&&name)
				xx.Under(top,"SavedTheme",{name:name,tv:TV_Add(name,SSN(top,"@tv").text,"Vis")})
}}}
Setup(window,nodisable=""){
	ea:=Settings.EA(Settings.SSN("//theme/default")),size:=10,Background:=RGB(ea.Background),font:=ea.font,color:=RGB(ea.color),Background:=Background?Background:0
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
	Gui,Color,%Background%,%Background%
	Gui,Font,% "s" size " c" color " bold",%font%
	Gui,%window%:Default
	v.window[window]:=1,hwnd(window,hwnd)
	return hwnd
}
SetupEnter(On:=0){
	Hotkey,IfWinActive,% MainWin.ID
	for a,b in ["+","^","!","!^",""]{
		Hotkey,%b%Enter,Enter,% On?"On":"Off"
		Hotkey,%b%NumpadEnter,Enter,% On?"On":"Off"
	}
}
SetWords(hyphen:=0){
	if(hyphen=1)
		csc().2077(0,"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ#-_1234567890")
	else if(hyphen=2)
		csc().2077(0,"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ#-_1234567890*[];")
	else
		csc().2444
}
Show_Class_Methods(object,search:=""){
	static list
	sc:=csc()
	if(object="this")
		class:=GetCurrentClass(sc.2166(sc.2008)),list:=SN(class.node,"descendant::*[@type='Method']")
	else if(class:=SSN((parent:=Current(7)),"descendant::*[@type='Instance' and @upper='" Upper(object) "']/@class").text){
		list:=SN(parent,"descendant::*[@type='Class' and @upper='" Upper(Class) "']/descendant::*[@type='Method']")
	}else if(parent:=SSN(Current(7),"descendant::*[@type='Class' and @upper='" Upper(object) "']"))
		list:=SN(parent,"descendant::*[@type='Method']")
	while,ll:=list.item[A_Index-1],ea:=XML.EA(ll)
		if(RegExMatch(ea.text,"i)\b" search))
			total.=ea.text " "
	if(total:=Trim(total))
		sc.2117(3,total)
	return sc.2102?1:0
}
Show_Scintilla_Code_In_Line(){
	Scintilla(),sc:=csc()
   	text:=sc.TextRange(sc.2128(sc.2166(sc.2008)),sc.2136(sc.2166(sc.2008))),pos:=1
	while,RegExMatch(text,"O)(\d\d\d\d)",found,pos),pos:=found.pos(1)+found.len(1){
		codes:=scintilla.SN("//*[@code='" found.1 "']"),list.="Code : " found.1 " = "
		while,c:=codes.item(A_Index-1)
			list.=A_Index>1?" - " SSN(c,"@name").text:SSN(c,"@name").text
		list.="`n"
	}
	if(list)
		sc.2200(sc.2128(sc.2166(sc.2008)),Trim(list,"`n"))
}
ShowAutoComplete(){
	sc:=csc(),cpos:=sc.2008,SetWords(1),start:=sc.2266(cpos,1),end:=sc.2267(cpos,1),word:=sc.TextRange(start,cpos),SetWords(),word:=LTrim(word,"-")
	if((sc.2202&&!v.Options.Auto_Complete_While_Tips_Are_Visible)||(sc.2010(cpos)~="\b(13|1|11|3)\b"=1&&!v.Options.Auto_Complete_In_Quotes)){
	}else{
		word:=RegExReplace(word,"^\d*"),List:=Trim(Keywords.GetSuggestions((Language:=GetLanguage(sc)),FirstTwo:=SubStr(word,1,2)))
		if(v.words[sc.2357])
			List.=" " v.words[sc.2357]
		List.=" " Code_Explorer.AutoCList()
		if(node:=Settings.Find("//autocomplete/project/@file",Current(2).file))
			List.=" " node.text
		List.=" " Keywords.Personal " ",List.=" " Keywords.Suggestions[Language,FirstTwo] " ",List:=Trim(List)
		Sort,List,CUD%A_Space%
		if(List&&InStr(List,word)&&word)
			sc.2100(StrLen(word),Trim(List))
	}
}
ShowLabels(x:=0){
	Code_Explorer.Scan(Current()),all:=cexml.SN("//main[@id='" Current(2).ID "']/descendant::info[@type='Function' or @type='Label']/@text")
	sc:=csc(),sc.2634(1),dup:=[]
	if(x!="nocomma")
		Loop,% sc.2570
			cpos:=sc.2585(A_Index-1),InsertMultiple(A_Index-1,cpos,",",cpos+1)
	while,aa:=all.item[A_Index-1]
		if(!dup[aa.text])
			list.=aa.text " ",dup[aa.Text]:=1
	Sort,list,list,D%A_Space%
	if(List)
		sc.2100(0,Trim(list))
}
SplitPath(file){
	SplitPath,file,filename,dir,ext,nne,drive
	return {file:file,filename:filename,dir:dir,ext:ext,nne:nne,drive:drive}
}
Step_Into(){
	if(!debug.socket)
		return m("There is currently no script being debugged","time:1")
	debug.Send("step_into")
}
Step_Over(){
	if(!debug.socket)
		return m("There is currently no script being debugged","time:1")
	debug.Send("step_over")
}
Step_Out(){
	if(!debug.socket)
		return m("There is currently no script being debugged","time:1")
	debug.Send("step_out")
}
Stop_Debugger(){
	if(!debug.socket)
		return m("There is currently no script being debugged","time:1")
	debug.Send("stop"),obj:=MainWin.NewCtrlPos:=[],obj.ctrl:=MainWin.Gui.SSN("//*[@type='Debug']/@hwnd").text
	Sleep,500
	MainWin.Delete(),debug.Disconnect()
}
StripError(text,fn){
	for a,b in StrSplit(text,"`n"){
		if RegExMatch(b,"i)^Error in")
			filename:=StrSplit(b,Chr(34)).2
		if InStr(b,"error at line"){
			RegExMatch(b,"(\d+)",line) ;,debug.disconnect()
			filename:=StrSplit(b,Chr(34)).2
		}if InStr(b,"--->")
			RegExMatch(b,"(\d+)",line) ;,debug.disconnect()
		if(InStr(b,"==>")){
			RegExMatch(b,"\((\d+)\)",line),line:=line1,RegExMatch(b,"(.*)\s+\(",filename),filename:=filename1
			Break
	}}filename:=filename?filename:fn
	return {file:filename,line:line-1}
}
Switch_Focus(){
	/*
		ControlGetFocus,focus,% hwnd([1])
		ControlGet,hwnd,hwnd,,%focus%,% hwnd([1])
	*/
	hwnd:=DllCall("GetFocus")
	hwnd:=hwnd=MainWin.tnsc.sc?MainWin.tnsc.sc+0:hwnd+0,sc:=csc(),test:=MainWin.Gui.SN("//*[@type='Scintilla']"),list:="",v.jts:=[]
	if(hwnd!=MainWin.tnsc.sc)
		list:="Tracked Notes,",v.jts["Tracked Notes"]:=MainWin.tnsc.sc
	while,ss:=test.item[A_Index-1],ea:=XML.EA(ss){
		if(hwnd=ea.hwnd)
			Continue
		if(ea.type="scintilla"){
			/*
				if(MainWin.tnsc.sc=ea.hwnd)
					list.="Tracked Notes,",v.jts["Tracked Notes"]:=MainWin.tnsc.sc
				else
			*/
			doc:=s.ctrl[ea.hwnd].2357,file:=StrSplit(files.SSN("//*[@sc='" doc "']/@file").text,"\").pop()
			if(file)
				list.=file ",",v.jts[file]:=ea.hwnd
		}
	}list:=Trim(list,",")
	if(!InStr(list,","))
		return s.ctrl[v.jts[list]].2400()
	sc.2106(44),sc.2117(7,Trim(list,",")),sc.2106(32)
}
Tab_To_Next_Comma(){
	sc:=csc()
	Loop,% sc.2570{
		line:=sc.2166(start:=sc.2585(A_Index-1))
		sc.2686(start,sc.2136(line))
		if((pos:=sc.2197(1,","))>=0)
			GoToPos(A_Index-1,pos+1)
		else
			sc.2136(line)
	}
}
Tab_To_Previous_Comma(){
	sc:=csc()
	Loop,% sc.2570{
		line:=sc.2166(start:=sc.2585(A_Index-1))
		sc.2686(start-1,sc.2167(line))
		if((pos:=sc.2197(1,","))>=0){
			GoToPos(A_Index-1,pos+1)
		}else
			GoToPos(A_Index-1,sc.2167(line))
	}
}
Tab_Width(){
	static
	Setup(23),width:=Settings.SSN("//tab").text?Settings.SSN("//tab").text:5
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
	tabwidth:=tabwidth?tabwidth:5,csc().2036(tabwidth),Settings.Add("tab").text:=tabwidth
	return
}
Test_Plugin(){
	Exit(1)
}
Theme(){
	new SettingsClass("Theme")
}
Toggle_Comment_Line(){
	sc:=csc(),sc.2078
	pi:=PosInfo(),sl:=sc.2166(pi.start),el:=sc.2166(pi.end),end:=pi.end,single:=sl=el?1:0
	replace:=Settings.SSN("//comment").text,replace:=replace?replace:";",replace:=RegExReplace(replace,"%a_space%"," ")
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
		sc:=csc(),order:=[],pi:=PosInfo(),order[sc.2166(sc.2008)]:=1,order[sc.2166(sc.2009)]:=1,min:=order.MinIndex(),max:=order.MaxIndex()
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
ToggleMenu(Label){
	if(!Label)
		return
	Menu,main,UseErrorLevel
	top:=menus.SSN("//*[@clean='" label "']"),ea:=XML.EA(top),pea:=XML.EA(top.ParentNode)
	Menu,% pea.name (pea.hotkey?"`t" Convert_Hotkey(pea.hotkey):""),% (v.Options[label]?"Check":"Uncheck"),% ea.name (ea.hotkey?"`t" Convert_Hotkey(ea.Hotkey):"")
}
Toggle_Multiple_Line_Comment(){
	sc:=csc(),TopStyle:=sc.2010(sc.2143),BottomStyle:=sc.2010(sc.2145),CommentStyle:=Keywords.GetXML(Current(3).ext).SSN("//Styles/multilinecomment/@style").text
	if(TopStyle=CommentStyle&&BottomStyle!=CommentStyle||BottomStyle=CommentStyle&&TopStyle!=CommentStyle)
		return m("I am not exactly sure what you want to do.  Move the selection either inside or outside of a Multiple Line Comment")
	topline:=sc.2166(sc.2143),bottomline:=sc.2166(sc.2145)
	Loop,% bottomline-topline{
		if(sc.2010(sc.2128((A_Index-1)+topline))=CommentStyle)
			return m("With your current selection I can not create a Multiple Line Comment","If you wish to remove this comment block place your caret between the /* and */ and use this Command again")
	}sc.2078(),sc.Enable(),indent:=Settings.Get("//tab",5)
	top:=sc.2166(sc.2143),bottom:=sc.2166(sc.2145)
	indent:=Settings.Get("//tab",5)
	if(TopStyle!=CommentStyle){
		AddLine:=1,SLine:=sc.2166(sc.2143),ELine:=sc.2166(sc.2145),ind:=sc.2127(SLine),sc.2003(sc.2136(ELine),"`n*/"),sc.2126(ELine+1,ind),sc.2003(sc.2128(SLine),"/*`n"),sc.2126(SLine+1,ind)
		Loop,% ELine-SLine+1
			sc.2126((line:=SLine+(A_Index)),sc.2127(line)+indent)
		ELine+=2,nextline:=1
	}else{
		AddLine:=0,top:=sc.2225(sc.2166(sc.2143)),bottom:=sc.2224(top,-1),indent:=Settings.Get("//tab",5),SLine:=top,ELine:=bottom-2,nextline:=0
		Loop,% bottom-top-1
			ind:=sc.2127(A_Index+top),sc.2126(A_Index+top,ind-indent)
		if(Trim(Trim(sc.GetLine(top)),"`n")="/*")
			for a,b in [bottom,top]
				start:=sc.2167(b),length:=(sc.2136(b)+1)-start,start:=sc.2136(b)=sc.2006?start-1:start,sc.2645(start,length)
	}
	if(v.Options.Disable_Line_Status!=1)
		Loop,% ELine-SLine+1
			LineStatus.Add(SLine+(A_Index-1),2)
	sc.2079(),sc.Enable(1),Edited(),sc.2025(sc.2128(top+AddLine)),sc.2399
}
ToggleDuplicate(){
	MouseGetPos,x,y,,control,2
	if(!sc:=s.ctrl[control+0])
		return
	ControlGetPos,wx,wy,,,,% "ahk_id" sc.sc
	pos:=sc.2022(x-wx,y-wy),main:=Selection.GetMain(),select:=[]
	for a,b in v.duplicateselect[sc.2357]
		if(a<pos&&a+b>pos){
			select:={start:a,end:a+b}
			Break
		}
	if(!select.end)
		return
	Loop,% sc.2570{
		if(sc.2585(A_Index-1)=select.start)
			return sc.2671(A_Index-1)
	}sc.2573(select.end,select.start)
	return
}
Toolbar_Editor(control){
	static oea,LastID,OControl,nw,tb,ExternalTV,ea
	ctrl:=control,color:=RGB(Settings.Get("//Toolbar_Editor/@highlight",0xEE00AA))
	if(ctrl.file){
		Default("SysTreeView321","Toolbar_Editor")
		if(!id:=Settings.SSN("//toolbar/bar[@id='" LastID "']/button[@tv='" TV_GetSelection() "']/@id").text)
			id:=Settings.SSN("//toolbar/bar[@id='" LastID "']/button[@func='" menus.SSN("//*[@tv='" TV_GetSelection() "']/@clean").text "']/@id").text
		tb.ChangeIcon(id,ctrl.icon-1,ctrl.file)
		return
	}
	Gui,1:+Disabled
	oea:=XML.EA(control),OControl:=control,nw:=new GUIKeep("Toolbar_Editor"),width:=Settings.Get("//IconBrowser/Win[@win='Toolbar_Editor']/@w",300),tb:=ToolBar.keep[oea.toolbar]
	nw.Add("ComboBox,gtesearch w460 vedit gTEFindTV,,w","ListView,xm w260 h200 gTESelect AltSubmit -Multi,Toolbars,h","TreeView,x+0 w200 h200 Checked AltSubmit,,wh","ListView,x+M200 yM w" width " h180 icon Section gSelectIcon AltSubmit,Icon,xh")
	ControlGet,hwnd,hwnd,,SysListView322,% hwnd(["Toolbar_Editor"])
	new Icon_Browser(nw,hwnd,"Toolbar_Editor","xy",300,"Toolbar_Editor","Toolbar_Editor"),nw.Add("Button,xm gTEHighlight,Toolbar Selection Highlight Color,y","Button,x+M gNextChecked,&Next Button,y","Button,x+M gAddExternal,Add &External Program,y"),nw.show("Toolbar Editor"),total:="",cross:=[],Default("SysTreeView321","Toolbar_Editor"),all:=menus.SN("//main/descendant::*")
	while,aa:=all.item[A_Index-1],ea:=XML.EA(aa){
		if(aa.HasChildNodes())
			aa.SetAttribute("tv",TV_Add(ea.clean,SSN(aa.ParentNode,"@tv").text))
		else if(aa.nodename="menu")
			clean:=RegExReplace(ea.clean,"_"," "),aa.SetAttribute("tv",TV_Add(clean,SSN(aa.ParentNode,"@tv").text)),total.=clean "|",cross[clean]:=ea.clean
	}
	GuiControl,Toolbar_Editor:,ComboBox1,% Trim(total,"|")
	Gosub,TEPopulateBars
	Enable("SysTreeView321","tetv","Toolbar_Editor")
	Hotkey,IfWinActive,% nw.ID
	Hotkey,Delete,DeleteButton,On
	goto,TESelect
	return
	TEHighlight:
	color:=RGB(clr:=Dlg_Color(Settings.Get("//Toolbar_Editor/@highlight",0xEE00AA),nw.hwnd)),Settings.Add("Toolbar_Editor",{highlight:clr}),Default("SysListView321","Toolbar_Editor"),LV_GetText(id,LV_GetNext()),ea:=MainWin.gui.EA("//controls[@win=1]/descendant::control[@id='" id "']"),winname:=ea.win,current:=ea.hwnd,tb:=ToolBar.keep[ea.hwnd]
	Gui,% oea.win ":Color",%color%,%color%
	WinActivate,% nw.id
	return
	ResetToolbar:
	color:=RGB(Settings.SSN("//theme/default/@background").text),all:=MainWin.Gui.SN("//*[@type='Toolbar']")
	while(aa:=all.item[A_Index-1]),ea:=XML.EA(aa)
		Gui,% ea.win ":Color",%color%,%color%
	return
	TESelect:
	Default("SysListView321","Toolbar_Editor"),LV_GetText(id,LV_GetNext())
	if(!Settings.SSN("//toolbar/bar[@id='" id "']"))
		return Default("SysListView321","Toolbar_Editor"),LV_Modify(1,"Select Vis Focus")
	if(id!=LastID){
		Gosub,ResetToolbar
		DeSelect:=Settings.SN("//toolbar/bar[@id='" LastID "']/descendant::button"),LastID:=id
		while(dd:=DeSelect.item[A_Index-1]),ea:=XML.EA(dd)
			Default("SysTreeView321","Toolbar_Editor"),TV_Modify(menus.SSN("//*[@clean='" ea.func "']/@tv").text,"-Check")
		oea:=XML.EA(OControl:=MainWin.GUI.SSN("//*[@id='" id "']")),color:=RGB(Settings.Get("//Toolbar_Editor/@highlight",0xEE00AA)),LastID:=id
		Gui,% oea.win ":Color",%color%,%color%
		Select:=Settings.SN("//toolbar/bar[@id='" LastID "']/descendant::button")
		while(ss:=Select.item[A_Index-1]),ea:=XML.EA(ss)
			Default("SysTreeView321","Toolbar_Editor"),TV_Modify(menus.SSN("//*[@clean='" ea.func "']/@tv").text,"Check")
	}
	if(ExternalTV)
		TV_Delete(ExternalTV)
	ExternalTV:=TV_Add("External Programs")
	External:=Settings.SN("//toolbar/bar[@id='" LastID "']/descendant::button[@runfile]")
	while(ee:=External.item[A_Index-1],ea:=XML.EA(ee)){
		ee.SetAttribute("tv",TV_Add(ea.runfile,ExternalTV,ea.vis?"Check":""))
	}
	return
	TEPopulateBars:
	all:=MainWin.Gui.SN("//*[@type='Toolbar']"),Default("SysListView321","Toolbar_Editor"),LV_Delete()
	while(aa:=all.item[A_Index-1]),ea:=XML.EA(aa)
		LV_Add((ea.id=oea.id?"Select Vis Focus":""),ea.id)
	return
	Toolbar_EditorEscape:
	Toolbar_EditorClose:
	Gui,1:-Disabled
	nw.SavePos(),nw.Exit(),nw.Destroy(),remtv:=menus.SN("//*[@tv]"),oea:=LastID:=OControl:=nw:=tb:=""
	while,rr:=remtv.item[A_Index-1],ea:=XML.EA(rr)
		rr.RemoveAttribute("tv")
	Gosub,ResetToolbar
	return
	tetv:
	if(A_GuiEvent="+"||A_GuiEvent="-"||A_GuiEvent="S")
		return
	Default("SysTreeView321","Toolbar_Editor")
	tvitem:=(A_GuiEvent="K")?TV_GetSelection():A_EventInfo
	if(!node:=menus.SSN("//*[@tv='" tvitem "']"))
		node:=Settings.SSN("//*[@tv='" tvitem "']")
	ea:=XML.EA(node)
	if(!tvitem)
		return
	if(TV_GetChild(tvitem)){
		GuiControl,Toolbar_Editor:+g,SysTreeView321
		if(TV_Get(tvitem,"Check"))
			Expand:=TV_Get(tvitem,"Expand")?"-Expand":"+Expand",TV_Modify(tvitem,"-Check " Expand)
		GuiControl,Toolbar_Editor:+gtetv,SysTreeView321
		return
	}if(TV_Get(tvitem,"C")){
		if(!Settings.SSN("//toolbar/bar[@id='" LastID "']/button[@func='" ea.clean "']")){
			start:=9999
			while(Settings.SSN("//toolbar/bar[@id='" LastID "']/descendant::*[@id='" ++start "']")){
			}new:=Settings.Under(Settings.SSN("//toolbar/bar[@id='" LastID "']"),"button",{file:"shell32.dll",func:ea.clean,icon:2,id:start,state:4,text:RegExReplace(ea.clean,"_"," "),vis:1}),tb.Add(nea:=XML.EA(new)),tb.AddButton(start),Default("SysTreeView321","Toolbar_Editor"),TV_Modify(A_EventInfo,"Select")
	}}else if(node:=Settings.SSN("//toolbar/bar[@id='" LastID "']/button[@func='" ea.clean "']"))
		tb.Delete(XML.EA(node)),node.ParentNode.RemoveChild(node)
	else if(node:=Settings.SSN("//toolbar/bar[@id='" LastID "']/button[@runfile='" ea.runfile "']"))
		tb.Delete(XML.EA(node)),node.ParentNode.RemoveChild(node)
	return
	TEFindTV:
	item:=nw[].edit
	if(tv:=menus.SSN("//*[@clean='" Clean(item) "']/@tv").text)
		Default("SysTreeView321","Toolbar_Editor"),TV_Modify(tv,"Select Vis Focus")
	return
	NextChecked:
	Default("SysTreeView321","Toolbar_Editor"),next:=TV_GetSelection()
	NextStartOver:
	ControlFocus,SysTreeView321,% nw.ID
	while(next:=TV_GetNext(next,"F"))
		if(TV_Get(next,"C"))
			return TV_Modify(next,"Select Vis Focus"),found:=1
	if(A_ThisLabel="NextChecked"){
		next:=0
		Goto,NextStartOver
	}
	return
	tesearch:
	info:=nw[]
	if(tv:=menus.SSN("//*[@clean='" cross[info.edit] "']/@tv").text){
		GuiControl,Toolbar_Editor:+g,SysTreeView321
		TV_Modify(0,"-Select"),TV_Modify(tv,"Select Vis Focus")
		GuiControl,Toolbar_Editor:+gtetv,SysTreeView321
	}
	return
	AddExternal:
	FileSelectFile,Filename,,,Select Item To Run,*.ahk;*.exe
	if(ErrorLevel||!Filename)
		return
	if(Settings.SSN("//toolbar/bar[@id='" LastID "']/descendant::button[@runfile='" filename "']"))
		return m("File already exists.")
	if(!node:=Settings.SSN("//toolbar/bar[@id='" LastID "']"))
		return
	start:=9999,Default("SysTreeView321","Toolbar_Editor")
	while(Settings.SSN("//toolbar/bar[@id='" LastID "']/descendant::*[@id='" ++start "']")){
	}new:=Settings.Under(Settings.SSN("//toolbar/bar[@id='" LastID "']"),"button",{file:"shell32.dll",runfile:filename,icon:2,id:start,state:4,text:SplitPath(filename).filename,vis:1}),tb.Add(nea:=XML.EA(new)),tb.AddButton(start),Default("SysTreeView321","Toolbar_Editor"),TV_Modify(A_EventInfo,"Select Vis Focus"),new.SetAttribute("tv",TV_Add(Filename,ExternalTV,"Select Vis Focus Check"))
	return
	DeleteButton:
	Default("SysTreeView321","Toolbar_Editor"),ea:=Settings.EA("//*[@tv='" TV_GetSelection() "']"),bummer:=ea
	if(!ea.runfile)
		return
	if(m("Are you sure you want to delete: " ea.text,"btn:ync","def:2")="Yes")
		TV_Delete(bummer.tv),tb.Delete(bummer)
	return
}
class Tracked_Notes{
	keep:=[]
	__New(){
		this.XML:=new XML("Tracked_Notes","lib\Tracked Notes.XML")
		if(!this.XML.SSN("//master"))
			this.XML.Under(this.XML.Add("master",{file:"Global Notes",id:1}),"global")
		list:=this.XML.SN("//Tracked_Notes/descendant::*[not(@id)]")
		while(ll:=list.item[A_Index-1]),ea:=XML.EA(ll){
			id:=1
			while(this.XML.SSN("//*[@id='" ++id "']")){
			}ll.SetAttribute("id",id)
		}this.Populate()
		return this
	}Register(sc){
		this.sc:=sc
	}
	Populate(){
		TVC.Default(3),this.XML.SSN("//*[@tv='" TV_GetSelection() "']").SetAttribute("last",1),all:=this.XML.SN("//*"),TVC.Delete(3,0)
		while,aa:=all.item[A_Index-1],ea:=XML.EA(aa){
			if(aa.NodeName="global")
				Continue
			if(aa.NodeName="master"||aa.NodeName="file"||aa.NodeName="main")
				aa.SetAttribute("tv",TV_Add(SubStr(text:=StrSplit(ea.file,"\").pop(),1,(InStr(text,".")?InStr(text,".")-1:StrLen(text))),SSN(aa.ParentNode,"@tv").text,ea.last?"Select Vis Focus":""))
			if(ea.last)
				aa.RemoveAttribute("last")
		}
	}Track(){
		project:=Current(2).file,file:=Current(3).file,id:=0
		if(node:=this.XML.Find("//*/@file",file))
			return m("File already being tracked",node.xml,"","",file)
		if(!project||!file)
			return
		if(!master:=this.XML.Find("//main/@file",project))
			master:=this.XML.Add("main",{file:project},,1),this.XML.Under(master,"global"),TVC.Add(3,files.Find("//file/@file",project,"@filename").text)
		if(!node:=this.XML.Find(master,"descendant::file/@file",file))
			node:=this.XML.Under(master,"file",{file:file})
		if(!SSN(node,"@id"))
			while(this.XML.SSN("//*[@id='" ++id "']")){
			}node.SetAttribute("id",id)
		this.node:=node,this.Populate(),this.Set(file)
	}SetText(){
		static node
		sc:=MainWin.tnsc,last:=csc().sc
		if(this.node.XML!=node.XML&&this.node.XML){
			Encode(RegExReplace(this.node.text,Chr(127),"`n"),txt),sc.2181(0,&txt)
			ea:=XML.EA(this.node),sc.2160(Round(ea.start),Round(ea.end))
			Sleep,10
			for a,b in StrSplit(ea.fold,",")
				sc.2237(b,0)
			sc.2613(Round(ea.scroll))
			MarginWidth(sc)
		}
		node:=this.node,csc({hwnd:last})
	}
	Set(file:=""){
		TVC.Disable(3),project:=Current(2).file,file:=Current(3).file
		if(master:=this.XML.Find("//main/@file",project)){
			if(node:=this.XML.Find(master,"descendant::file/@file",file))
				TVC.Modify(3,,SSN(node,"@tv").text,"Select Vis Focus"),this.node:=node
			else
				TVC.Modify(3,,SSN(master,"@tv").text,"Select Vis Focus"),this.node:=SSN(master,"global")
			this.SetText()
		}else
			node:=this.XML.SSN("//master"),TVC.Modify(3,,SSN(node,"@tv").text,"Select Vis Focus"),this.node:=node,this.SetText()
		TVC.Enable(3)
	}
	tn(){
		tn:
		if(A_GuiEvent="S"){
			if(node:=TNotes.XML.SSN("//*[@tv='" A_EventInfo "']")){
				TNotes.node:=node
				if(node.NodeName!="master"){
					if(tv:=SSN(files.Find("//file/@file",SSN(node,"@file").text),"@tv").text)
						tv(tv)
					else
						TNotes.node:=TNotes.node.NodeName="main"?SSN(TNotes.node,"global"):TNotes.node,TNotes.SetText()
				}else
					TNotes.SetText()
		}}
		return
	}
	GetPos(){
		sc:=MainWin.tnsc,fold:=0,node:=this.node,node.RemoveAttribute("fold")
		for a,b in {start:sc.2008,end:sc.2009,scroll:sc.2152}
			node.SetAttribute(a,b)
		while(sc.2618(fold)>=0,fold:=sc.2618(fold))
			list.=fold ",",fold++
		if(list)
			node.SetAttribute("fold",list)
	}
	Write(){
		this.node.text:=RegExReplace(csc().GetUni(),"\R",Chr(127))
	}
}
tv(tv*){
	/*
		static fn,noredraw,tvbak,historysave
	*/
	static lasttv,LastExt:=[],Last
	Default("SysTreeView321",1),ctv:=TV_GetSelection()
	/*
		Scan_Line()
	*/
	if(!sel:=files.SSN("//*[@tv='" tv.1 "']/@tv").text)
		sel:=files.SSN("//*[@tv='" tv.3 "']/@tv").text
	if(files.SSN("//*[@tv='" sel "']").NodeName="files")
		return
	if(IsObject(tv.1))
		sel:=tv.1.1
	lasttv:=sel
	if(!tv.2.sc)
		sc:=csc()
	else
		sc:=csc({hwnd:tv.2.sc})
	if(sc.sc=MainWin.tnsc.sc||sc.sc=v.debug.sc)
		sc:=csc(1)
	if(sc.sc=MainWin.tnsc.sc)
		sc:=csc({set:1})
	if(tv.1="Split")
		sel:=Current(3).tv
	if(sel){
		sc:=csc()
		/*
			sc.2112(0,".(")
			sc.2105(0,".,")
			Value:=305|13
			DllCall(sc.fn,"Ptr",sc.ptr,"UInt",2105,UInt,0,UInt,Value,"Cdecl")
			t(sc.fn,sc.ptr)
		*/
		/*
			gu
		*/
		if((filename:=files.SSN("//*[@sc='" sc.2357 "']/@file").text)){
			if(node:=positions.Find("//file/@file",Filename))
				GetPos(node)
			else
				GetPos(positions.Under(positions.SSN("//*"),"file",{file:filename}))
		}onode:=node:=files.SSN("//*[@tv='" sel "']"),ea:=XML.EA(node),v.DisableContext:="",TV_Modify(sel,"Vis")
		Update({sc:sc.2357}),sc.2045(2),sc.2045(3)
		if(node.NodeName="folder"||ea.folder=1)
			return
		sc.Enable()
		if(!ea.sc){
			if((nodes:=files.SN("//*[@id='" ea.id "']")).length>1){
				while(nn:=nodes.item[A_Index-1]),fea:=XML.EA(nn){
					if(fea.sc){
						node.SetAttribute("sc",fea.sc),ea:=XML.EA(node)
						Break
		}}}}if(ea.sc){
			TVState(),TVC.Disable(1),TVC.Modify(1,"",ea.tv,"Select Vis Focus"),TVC.Enable(1),sc.2358(0,ea.sc),TVState(1),Color(sc,GetLanguage(sc)),sc.Enable(1)
		}else if(ea.sc!=sc.2357){
			if(!ea.sc){
				sc.2358(0,0)
				Sleep,80
				doc:=sc.2357,sc.2376(0,doc),node.SetAttribute("sc",doc),tt:=Update({get:ea.file}),encoding:=ea.encoding,sc.2037(65001),Len:=Encode(tt,text,encoding),sc.2181(0,&text),sc.2175()
				Language:=Settings.SSN("//Extensions/Extension[text()='" ea.ext "']/@language").text,Language:=Language?Language:"ahk",sc.4006(0,Language),Keywords.BuildList(Language),Color(sc,GetLanguage(sc))
			}else
				m("The current document is not the right document. If this continues to happen please let maestrith know."),tv(files.SSN("//main/file/@tv").text)
		}TVC.Disable(1),TVC.Modify(1,"",sel,"Select Vis Focus"),TVC.Enable(1)
		if(IsObject(tv.2)&&tv.2.start!=""){
			if(pos.fold!="")
				for a,b in StrSplit(pos.fold,",")
					sc.2237(b,0)
			sc.2160(tv.2.start,tv.2.end),CenterSel()
			v.tvpos:=pos:=XML.EA(positions.Find("//file/@file",SSN(node,"@file").text))
		}else{
			pos:=positions.EA(positions.Find("//file/@file",SSN(node,"@file").text))
			if(pos.fold!="")
				for a,b in StrSplit(pos.fold,",")
					sc.2237(b,0)
			(pos.scroll!="")?sc.2613(pos.scroll):"",(pos.start||pos.end)?sc.2160(pos.start,pos.end):""
		}sc.Enable(1),node:=gui.SSN("//*[@hwnd='" sc.sc+0 "']"),node.SetAttribute("file",ea.file)
	}else if(tv.2.end!="")
		pos:=tv.2,sc.2160(pos.start,pos.end),CenterSel()
	else{
		SetTimer,ScanWID,-200
		Default("SysTreeView321"),TV_Modify(A_EventInfo,(TV_Get(A_EventInfo,"Expand")?"-":"") "Expand")
		return
	}
	if(SplitPath(ea.file).ext="cxx"){
		for a,b in ["fold","foldComment","foldCommentMultiline","foldSyntaxBased","foldCommentExplicit","foldExplicitAnywhere","foldPreprocessorAtElse","foldPreprocessor","foldCompact","foldAtElse",""]
			sc.4004(b,["1"])
		sc.4004("foldExplicitStart","//{")
		sc.4004("foldExplicitEnd","//}")
		/*
			sc.4005(1,"and and_eq asm auto bitand bitor bool break case catch char class compl const const_cast continue default delete do double dynamic_cast else enum explicit export extern false float for friend goto if inline int long mutable namespace new not not_eq operator or or_eq private protected public register reinterpret_cast return short signed sizeof static static_cast struct switch template this throw true try typedef typeid typename union unsigned using virtual void volatile wchar_t while xor xor_eq")
			sc.4005(3,"a addindex addtogroup anchor arg attention author b brief bug c class code date def defgroup deprecated dontinclude e em endcode endhtmlonly endif endlatexonly endlink endverbatim enum example exception f$ f[ f] file fn hideinitializer htmlinclude htmlonly if image include ingroup internal invariant interface latexonly li line link mainpage name namespace nosubgrouping note overload p page par param param[in] param[out] post pre ref relates remarks return retval sa section see showinitializer since skip skipline struct subsection test throw throws todo typedef union until var verbatim verbinclude version warning weakgroup")
			sc.4005(4,"_MSC_VER SCI_NAMESPACE")
		*/
		sc.2056(11,"Consolas")
		sc.2051(11,0xFFFFFF)
		text=auto array bool break case char class complex ComplexInf ComplexNaN const continue default delete do double else enum export extern float for foreach goto if Inf inline int long namespace NaN new NULL private public register restrict return short signed sizeof static string_t struct switch this typedef union unsigned using void volatile wchar_t while __declspec
		/*
			Loop,10
				sc.4005(A_Index-1,text)
		*/
	}
	SetTimer,ScanWID,-200
	sc.2400(),WinSetTitle(1,ea),DebugHighlight()
	if(!v.startup)
		TNotes.GetPos(),TNotes.Set(ea.file)
	if(onode)
		History(onode,sc)
	LineStatus.tv()
	return
	ScanWID:
	Words_In_Document(1),MarginWidth()
	return
}
TVIcons(x:=""){
	static il,track:=[]
	if(x=1||x=2){ ;I can edit it and it will remember
		obj:={1:"File Icon",2:"Folder Icon"}
	}else if(x.file){
		root:=Settings.SSN("//icons/pe")
		if(x.return="File Icon")
			obj:={filefile:x.file,file:x.number}
		else if(x.return="Folder Icon")
			obj:={folderfile:x.file,folder:x.number}
		for a,b in obj
			root.SetAttribute(a,b)
		seticons:=1
	}else if(x.get){
		if(!index:=track[x.get]){
			index:=IL_Add(il,x.get,1),track[x.get]:=index
			if(!index)
				return "icon2"
		}
		return "Icon" index
	}if(Settings.SSN("//icons/pe/@show").text||seticons)
		ea:=Settings.EA("//icons/pe"),il:=IL_Create(3,1,0),IL_Add(il,ea.folderfile?ea.folderfile:"shell32.dll",ea.folder?ea.folder:4),IL_Add(il,ea.filefile?ea.filefile:"shell32.dll",ea.file?ea.file:2)
	else
		IL_Destroy(il)
	TV_SetImageList(il)
}
TVState(x:=0){
	if(x){
		GuiControl,1:+gtv,SysTreeView321
		GuiControl,1:+Redraw,SysTreeView321
	}else{
		GuiControl,1:+g,SysTreeView321
		GuiControl,1:-Redraw,SysTreeView321
	}
}
UnderlineDuplicateWords(){
	sc:=csc(),sc.2500(6),sc.2505(0,sc.2006)
	if(sc.2507(6,sc.2008))
		return
	word:=sc.GetWord(),length:=StrPut(word,"UTF-8")-1
	if(length<=1)
		return
	dup:=[],sc.2686(0,sc.2006),sc.2500(6)
	if(!word)
		return
	while(found:=sc.2197(length,[word]))>=0
		dup.Insert(found),sc.2686(++found,sc.2006)
	if(dup.MaxIndex()>1){
		for a,b in dup
			sc.2500(6),sc.2504(b,length)
}}
Undo(){
	csc().2176
}
UnSaved(){
	un:=files.SN("//main[@untitled]"),ts:=Settings.SSN("//template").text,file:=FileOpen("c:\windows\shellnew\template.ahk",0),td:=file.Read(file.length),file.Close(),template:=ts?ts:td
	while,uu:=un.item[A_Index-1],ea:=XML.EA(uu.FirstChild){
		text:=Update({encoded:ea.file})
		if(text=template)
			Continue
		if(m(ea.file,"This is an untitled document meaning there is no file created to the HDD/SSD yet.","Would you like to save it?","Contents:",SubStr(text,1,200) (StrLen(text)>200?"...":""),b,"btn:ync")="Yes"){
			FileSelectFile,newfile,S16,,Save Untitled File,*.ahk
			if(ErrorLevel||newfile="")
				Continue
			if(FileExist(newfile)){
				SplitPath,newfile,,dir,ext,nne
				FileMove,%newfile%,%dir%\%nne%-%A_Now%.%ext%,1
			}
			newfile:=SubStr(newfile,-3)!=".ahk"?newfile ".ahk":newfile,file:=FileOpen(newfile,"RW","UTF-8"),file.seek(0),file.write(RegExReplace(text,"\R","`r`n")),file.length(file.position),file.Close()
			if(!Settings.SSN("//open/file[text()='" newfile "']")&&newfile)
				Settings.Add("open/file",,newfile)
			Settings.Add("last/file",,newfile)
			uu.RemoveChild(uu.FirstChild)
	}}v.unsaved:=1
}
Update_Github_Info(){
	static
	info:=Settings.EA("//github"),Setup(36)
	controls:={owner:"Owner (GitHub Username)",email:"Email",name:"Your Full Name"}
	for a,b in {owner:100,email:200,name:100}{
		Gui,Add,Text,xm,% controls[a]
		Gui,Add,Edit,x+5 w%b% gUpdateGithubInfo v%a%,% info[a]
	}
	Gui,Add,Text,xm,Github Token
	Gui,Add,Edit,xm w300 Password gUpdateGithubInfo vtoken,% info.token
	Gui,Add,Button,ggettoken,Get A Token
	Gui,Show,,Github Information
	return
	UpdateGithubInfo:
	Gui,36:Submit,NoHide
	if !hub:=Settings.SSN("//github")
		hub:=Settings.Add({path:"github"})
	for a,b in {owner:owner,email:email,name:name,token:token}
		hub.SetAttribute(a,b)
	return
	36GuiEscape:
	36GuiClose:
	hwnd({rem:36})
	if WinExist(hwnd([10]))
		WinActivate,% hwnd([10])
	return
	gettoken:
	Run,https://github.com/settings/applications
	return
}
Update(info){
	/*
		need to remove the updated stuff alltogether
	*/
	static update:=[],updated:=[],encoding:=[]
	if(info.Delete)
		return update.Delete(info.Delete),updated.Delete(info.Delete)
	else if(info.remove)
		return update.Delete(info.remove),updated.Delete(info.remove)
	else if(info="updated")
		return updated
	else if(info.edited)
		return updated[info.edited]:=1
	else if(info="clearupdated")
		return updated:=[]
	else if(info="get")
		return [update,updated]
	else if(info.file){
		if(info.text)
			update[info.file]:=info.text
		if(!info.load)
			Edited(info.node)
		if(info.encoding)
			encoding[info.file]:=info.encoding
		return
	}else if(info.get)
		return update[info.get]
	else if(info.encoded){
		if(SSN(files.Find("//main[@file",Current(2).file),"/descendant::*/@virtual").text)
			return csc().GetUNI()
		if(!encoding[info.encoded]){
			m("ENCODING ERROR!","Closing Studio to prevent issues. If this continues contact maestrith",info.encoded)
			Save(),Settings.Save(1)
			ExitApp
		}
		if(!update[info.encoded])
			return
		Encode(update[info.encoded],tt,encoding[info.encoded])
		return StrGet(&tt,"utf-8")
	}
	else if(info.encoding)
		return encoding[info.file]:=info.encoding
	else if(info.sc){
		ea:=files.EA("//*[@sc='" info.sc "']"),item:=ea.file?ea.file:ea.note,text:=csc().GetUNI()
		if(ea.virtual)
			return
		if(!item)
			return
		return update[item]:=text
	}
	return
}
UpdateMethod(Add,node){
	for a,b in {text:add.1,upper:Upper(add.1)}
		node.SetAttribute(a,b)
	node.SetAttribute("args",add.3),TVC.Modify(2,Add.1,SSN(node,"@cetv").text)
	TVC.Modify(2,,SSN(node.ParentNode,"@cetv").text,"Sort")
}
Upper(text){
	StringUpper,text,text
	return text
}
UpPos(NoContext:=0){
	static LastLine,LastPos,Multi
	sc:=csc(),CPos:=sc.2008,EPos:=sc.2009,Line:=sc.2166(CPos),Length:=sc.2006
	if(v.track.Line)
		if(v.track.Line!=Line||v.track.file!=Current(2).file)
			v.track:=[]
	if(LastLine!=Line)
		HltLine()
	if(Abs(CPos-EPos)>1&&CPos!=LastPos)
		LastPos:=CPos,Duplicates()
	else
		sc.2500(3),sc.2505(0,Length),v.DuplicateSelect:=[]
	if(sc.2570>1&&!Multi)
		sc.2188(3),sc.2069(Settings.Get("//theme/caret/@multi",0x00A5FF)),Multi:=1
	if(sc.2570=1&&Multi){
		if(debug.socket)
			debug.Caret(1)
		else
			sc.2069(Settings.Get("//theme/caret/@color",0xFFFFFF)),sc.2188(Settings.SSN("//theme/caret/@width").text),Multi:=0
	}Text:="Line:" sc.2166(CPos)+1 " Column:" sc.2129(CPos) " Length:" Length " Position:" CPos,total:=0
	if(CPos!=EPos)
		Text.=" Selected Count:" Abs(CPos-EPos)
	if(sc.2570>1){
		Loop,% sc.2570
			total+=Abs(sc.2579(A_Index-1)-sc.2577(A_Index-1))
		if(Total)
			Text.=" Total Selected:" total 
		Text.=" Selections: " sc.2570
	}if(v.LineEdited.MinIndex()!=""&&!v.LineEdited.HasKey(Line)&&Line)
		Scan_Line()
	SetStatus(Text,1),LastLine:=Line
	if(CPos=EPos&&LastPos!=CPos)
		SetTimer,UnderlineDuplicateWords,-500
	else if(CPos!=EPos)
		sc.2500(6),sc.2505(0,Length)
	LastPos:=CPos
	if(!NoContext)
		SetTimer,Context,-500
}
URIDecode(str){
	Loop{ ;by Titam
		If(RegExMatch(str,"i)(?<=%)[\da-f]{1,2}",hex))
			StringReplace,str,str,`%%hex%,% Chr("0x" hex),All
		else Break
	}
	return, str
}
URLDownloadToVar(URL){
	/*
		req:=ComObjCreate("Msxml2.XMLHTTP")
		if(proxy:=Settings.SSN("//proxy").text)
			req.SetProxy(2,proxy)
		req.Open("GET",URL)
		req.Send()
		m(req.ResponseText)
		return req.ResponseText
	*/
	http:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
	if(proxy:=Settings.SSN("//proxy").text)
		http.SetProxy(2,proxy)
	http.Open("GET",URL,1)
	http.SetRequestHeader("Pragma","no-cache")
	http.SetRequestHeader("Cache-Control","no-cache")
	http.Send(),http.WaitForResponse
	return http.ResponseText
}
VarBrowser(){
	static newwin,treeview
	if(!debug.VarBrowser){
		debugwin:=newwin:=new GUIKeep(98),newwin.Add("TreeView,w450 h200 gvalue vtreeview AltSubmit hwndtreeview,,wh","ListView,w450 r4 AltSubmit gVBGoto,Stack|File|Line,wy","Text,w200 Section,Debug Controls:,y"
			,"Button,gRun_Program,&Run,y","Button,x+M gStep_Into,Step &Into,y","Button,x+M gStep_Out,Step &Out,y"
			,"Button,x+M gStep_Over,Step O&ver,y","Button,x+M gVarBrowserRefresh,R&efresh Variables,y","Button,x+M gStop_Debugger,&Stop,y"),newwin.show("Variable Browser"),hwnd:=newwin.XML.SSN("//*/@hwnd").text,debug.VarBrowser:=1
	}
	SetTimer,ProcessDebugXML,-100
	return
	VarBrowserRefresh:
	/*
		SetTimer,VarBrowserAutoRefresh,500
		return
		VarBrowserAutoRefresh:
	*/
	if(debug.Socket<0){
		/*
			SetTimer,VarBrowserAutoRefresh,Off
		*/
		return
	}
	debug.Send("stack_get") ;#[VarBrowser]
	return
	98Close:
	98Escape:
	debug.xml:=new XML("debug"),debug.XML.Add("local"),debug.XML.Add("global"),debug.VarBrowser:=0,newwin.Exit()
	return
	VBGoto:
	if(A_GuiEvent~="Normal|I"){
		Default("SysListView321",98),LV_GetText(file,LV_GetNext(),2),LV_GetText(line,LV_GetNext(),3)
		if(tv:=SSN(files.Find("//file/@file",file),"@tv").text){
			tv(tv),sc:=csc()
			Sleep,40
			SelectDebugLine(line-1)
	}}
	return
	value:
	if(debug.socket<1)
		return
	if(A_GuiEvent="+"&&(node:=debug.XML.SSN("//*[@tv='" A_EventInfo "']"))){
		if(node.NodeName="property"){
			node.SetAttribute("expanded",1)
			if(SSN(node,"descendant::wait"))
				scan:=1
	}}
	if(A_GuiEvent="Normal"){
		ea:=xml.EA(node:=debug.XML.SSN("//*[@tv='" A_EventInfo "']"))
		if(SSN(node,"*")&&node.NodeName)
			return
		if(v.CurrentScope="Global"&&SSN(node,"ancestor::scope/@name").text!="Global")
			return m("Not in Current Scope.","Current Scope: " v.CurrentScope,"You can only change values in the current scope")
		else if(v.CurrentScope!="Global"&&!SSN(node,"ancestor::scope[@name='" v.CurrentScope "']"))
			return m("Not in Current Scope.","Current Scope: " v.CurrentScope,"You can only change values in the current scope")
		InputBox,value,New Value,% "Enter a new value for " ea.FullName
		if(ErrorLevel)
			return
		debug.Send("property_set -n " ea.FullName " -- " debug.Encode(value)),debug.Send("context_get -c " (v.CurrentScope="Global"?1:0) " -i " v.CurrentScope)
	}
	if(A_GuiEvent="-"&&(node:=debug.XML.SSN("//*[@tv='" A_EventInfo "']")))
		if(node.NodeName="property")
			node.SetAttribute("expanded",0)
	if(scan){
		scan:=0
		SetTimer,ScanChildren,-1
	}
	return
	VarBrowserStop:
	if(WinExist(newwin.id)){
		wait:=debug.XML.SN("//wait")
		while(ww:=wait.item[A_Index-1]),ea:=XML.EA(ww)
			Default("SysTreeView321",98),TV_Modify(ea.tv,,"Information Unavailable, Debugging has stopped")
	}
	return
}
WalkDownClasses(text,find){
	pos:=1,Omni:=GetOmni(Current(3).Ext)
	while(RegExMatch(text,Omni.Class,ff,pos)),pos:=ff.Pos(1)+ff.Len(1){
		if(!ff.len(1))
			break
		found:=GetClassText(text,ff.2,ff.pos(1),Omni)
		search:=SubStr(text,ff.pos(1),found.pos(1)-ff.pos(1))
		RegExMatch(search,Omni.Class,ss)
		if(ss.2=find)
			return {StartLine:StartLine,EndLine:EndLine,text:search,obj:ff}
		pos:=found.pos(1)+found.len(1)
	}
}
WinActivate(win){
	WinActivate,%win%
}
WinPos(hwnd){
	VarSetCapacity(rect,16),DllCall("GetClientRect",ptr,hwnd,ptr,&rect)
	WinGetPos,x,y,,,% "ahk_id" hwnd
	w:=NumGet(rect,8),h:=NumGet(rect,12),text:=(x!=""&&y!=""&&w!=""&&h!="")?"x" x " y" y " w" w " h" h:""
	return {x:x,y:y,w:w,h:h,ah:h-v.status-v.qfh,text:text}
}
WinSetTitle(win:=1,Title:="AHK Studio",Open:=0){
	if(IsObject(Title)){
		if(!Title.dir)
			v.NoCurrentEditFile:=1
		else
			v.NoCurrentEditFile:=0
		WinSetTitle,% hwnd([win]),,% (open?"Include Open!  -  ":"") "AHK Studio - " (Current(3).edited?"*":"") (Title.dir "\" (v.Options.Hide_File_Extensions?Title.nne:Title.filename))
	}else if(Title!="AHK Studio"){
		WinSetTitle,% hwnd([win]),,%Title%
	}else{
		Info:=Current(3)
		WinSetTitle,% hwnd([win]),,% (open?"Include Open!  -  ":"") "AHK Studio - " (Info.edited?"*":"") (Info.dir "\" (v.Options.Hide_File_Extensions?Info.nne:Info.filename))
	}
}
Words_In_Document(NoDisplay:=0,text:="",Remove:="",AllowLastWord:=0){
	Text:=Update({Get:Current(3).File})
	Words:=RegExReplace(RegExReplace(RegExReplace(Text,"(\b\d+\b|\b(\w{1,2})\b)",""),"x)([^\w])"," "),"\s{2,}"," ")
	sc:=csc()
	v.Words[sc.2357]:=Trim(Words)
	if(!NoDisplay){
		Words:=Trim(Words)
		Sort,Words,CUD%A_Space%
		sc.2100(StrLen(sc.GetWord()),Words)
	}
}
Wrap_Word_In_Quotes(){
	sc:=csc(),sc.2078,cpos:=sc.2008,start:=sc.2266(sc.2008,1),end:=sc.2267(sc.2008,1),sc.2003(start,Chr(34)),sc.2003(end+1,Chr(34)),sc.2025(cpos+1),sc.2079
}
GetLanguage(sc:=""){
	sc:=sc?sc:csc(),VarSetCapacity(Language,4),sc.4012(0,&Language)
	return StrGet(&Language,"UTF-8")
}
ConvertTheme(){
	static Controls:={msctls_statusbar321:"statusbar",SysTreeView321:"projectexplorer",SysTreeView322:"codeexplorer"}
	Language:="ahk"
	if(rem:=Settings.SSN("//ahk"))
		rem.ParentNode.RemoveChild(rem)
	Orig:=(rem:=Settings.SSN("//fonts|//theme")).CloneNode(1),rem.ParentNode.RemoveChild(rem),Root:=Settings.Add("theme"),Top:=Settings.Add("Languages/ahk"),Default:=DefaultFont(1),all:=Default.SN("//theme/*")
	while(aa:=all.item[A_Index-1],ea:=XML.EA(aa)){
		if(aa.NodeName="author"||aa.NodeName="name"){
			aa.text:=SSN(Orig,"//" aa.NodeName).text
		}else if(aa.NodeName="caret"){
			for a,b in {color:["@code=2069","@color"],lineback:["@code=2098","@color"],width:["@code=2188","@value"],debug:["@debug","@debug"],multi:["@multi","@multi"]}
				if((Value:=SSN(Orig,"descendant::font[" b.1 "]/" b.2).text)!="")
					aa.SetAttribute(a,Value)
		}else if(aa.NodeName="bracematch"){
			for a in ea
				aa.RemoveAttribute(a)
			if(nn:=SSN(Orig,"*[@code=2082 and @color!='']"))
				aa.SetAttribute("bool",1),aa.SetAttribute("color",SSN(nn,"@color").text),aa.SetAttribute("code",2082)
			else if(Node:=SSN(Orig,"//*[@style=34]")){
				for a,b in XML.EA(Node)
					aa.SetAttribute(a,b)
			}
		}else if(aa.NodeName="default"){
			for a in ea
				Orig.RemoveAttribute(a)
			for a,b in XML.EA(SSN(Orig,"//*[@style=5]"))
				aa.SetAttribute(a,b)
		}else if(NodeName:=Controls[ea.Control]){
			New:=Settings.Add("theme/" NodeName)
			for a,b in ea
				if(a!="control"&&a!="gui")
					New.SetAttribute(a,b)
			aa.ParentNode.RemoveChild(aa)
			Continue
		}else if(aa.NodeName~="i)(projectexplorer|codeexplorer)"){
			for a,b in XML.EA(SSN(Orig,"//" aa.NodeName))
				aa.SetAttribute(a,b)
		}else if(aa.NodeName!="font"&&aa.NodeName!="keyword"){
			if(Node:=SSN(Orig,"//*[@style='" ea.style "' or @code='" ea.code "']")){
				for a in ea
					aa.RemoveAttribute(a)
				for a,b in XML.EA(Node)
					aa.SetAttribute(a,b)
			}
		}else if(aa.NodeName="keyword"){
			if(Node:=SSN(Orig,"//*[@style='" ea.style "']")){
				for a in ea
					if(a!="set")
						aa.RemoveAttribute(a)
				for a,b in XML.EA(Node)
					aa.SetAttribute(a,b)
			}
		}else if(aa.NodeName="font"){
			if(Settings.SSN("//fonts/descendant::*[@style='" ea.style "']")) ;here ct
				for a in ea
					aa.RemoveAttribute(a)
			for a,b in Settings.EA("//fonts/descendant::*[@style='" ea.style "']")
				aa.SetAttribute(a,b)
			if(Node:=SSN(Top,"descendant::*[@style='" ea.style "' or @code='" ea.code "']"))
				Top.ReplaceChild(aa,Node)
			else
				Top.AppendChild(aa)
			Continue
		}
		if(aa.NodeName!="font")
			aa.RemoveAttribute("style")
		Root.AppendChild(aa)
	}
	Root.ParentNode.InsertBefore(Root,Settings.SSN("//Languages"))
	/*
		New:=Default.SSN("//theme"),Node:=Settings.SSN("//fonts|//theme"),Node.ParentNode.ReplaceChild(New,Node)
		m(Settings.SSN("//theme").xml)
	*/
}
GetOmni(Ext){
	Language:=Settings.SSN("//Extensions/Extension[text()='" Ext "']/@language").text,Omni:=v.OmniFind[Language?Language:"ahk"]
	return Omni
}
GetOmniOrder(Ext){
	Language:=Settings.SSN("//Extensions/Extension[text()='" Ext "']/@language").text,Omni:=Keywords.OmniOrder[Language?Language:"ahk"]
	return Omni
}
GetOmniText(Ext){
	Language:=Settings.SSN("//Extensions/Extension[text()='" Ext "']/@language").text,OmniText:=v.OmniFindText2[Language?Language:"ahk"]
	return OmniText
}
class ScanFile{
	All:=[]
	__New(Refresh:=0){
		(IsObject(ScanFile.XML&&Refresh)?ScanFile.XML.XML.LoadXML("<ScanFile/>"):ScanFile.XML:=new XML("ScanFile","Lib\ScanFile.xml"))
		if(Refresh)
			ScanFile.__New(),Scanfile.XML.XML.LoadXML("<ScanFile/>")
		ScanFile.FileList:=[],all:=ScanFile.XML.SN("//file")
		while(aa:=all.item[A_Index-1],ea:=XML.EA(aa))
			ScanFile.FileList[ea.file]:=aa
		ScanFile.MainList:=[],all:=ScanFile.XML.SN("//main")
		while(aa:=all.item[A_Index-1],ea:=XML.EA(aa))
			ScanFile.MainList[ea.file]:=aa
	}GetAll(ea){
		if(!ea.ID)
			return
		return ScanFile.All[ea.ID]
	}GetCEXML(ea){
		static obj:=[]
		if(!Node:=obj[ea.File]){
			all:=cexml.SN("//file")
			while(aa:=all.item[A_Index-1],eea:=XML.EA(aa))
				obj[eea.File]:={Node:aa,Parent:aa.ParentNode}
			Node:=obj[ea.File]
		}
		return Node
	}RemoveComments(ea,Language:=0,SetCurrentPos:=0){
		xx:=Scanfile.XML,Text:=ea.File?Update({get:ea.file}):ea,Tick:=A_TickCount,Search:=[]
		if(SetCurrentPos){
			sc:=csc(),Split:=sc.TextRange(0,sc.2008),Text:=SubStr(Text,1,StrLen(Split)-1) Chr(127) SubStr(Text,StrLen(Split))
		}
		for a,b in Keywords.Comments[Language?Language:(ea.Lang?ea.Lang:Language)]{
			String:=b
			Add:="(\x7F\s)?"
			String:=(Pos:=InStr(String,"^"))?SubStr(String,1,Pos) Add SubStr(String,Pos+1):Add String
			Search[a]:=RegExReplace(String,"\x60n","`n")
		}
		if(Search.Open){
			while(RegExMatch(Text,Search.Open,Start)){
				if(!RegExMatch(Text,Search.Close,End))
					Break
				While((RegExMatch(Text,Search.Close,End))<Start.Pos(0)){
					if(!End)
						Break,2
					Text:=SubStr(Text,1,End.Pos(0)-1) SubStr(Text,End.Pos(0)+End.Len(0))
					RegExMatch(Text,Search.Open,Start)
				}
				Text:=SubStr(Text,1,Start.Pos(0)-1) SubStr(Text,End.Pos(0)+End.Len(0))
			}if(Search.Line)
				Text:=RegExReplace(Text,Search.Line)
			Text:=RegExReplace(Text,"(\R\s*)","`n")
			Text:=RegExReplace(Text,"\R\R")
			ScanFile.CurrentText:=Text
		}
		/*
			if(ea.FileName="AHK-Studio.ahk")
				m(Clipboard:=RegExReplace(Text,"\R","`r`n"))
		*/
		/*
			if(!Scanfile.Once)
				m(Search.Open,"","",Text),Scanfile.Once:=1
		*/
		if(Language)
			return Text
		if(!ea.ID)
			return
		rem:=xx.SSN("//file[@id='" ea.ID "']")
		if(!Language){
			rem.ParentNode.RemoveChild(rem),Top:=xx.Add("file",{id:ea.ID,filename:ea.FileName},,1)
		}else{
			Top:=Rem,all:=SN(Top,"comment")
			while(aa:=all.item[A_Index-1],ea:=XML.EA(aa))
				aa.ParentNode.RemoveChild(aa)
		}LastPos:=0
		return Top
	}Scan(Node,Refresh:=0){
		static ceobj,Count:=0
		if(ScanFile.Once)
			return
		Parent:=SSN(Node,"ancestor::main")
		ea:=XML.EA(Node),Time:=ea.Time,Omni:=GetOmniOrder(ea.Ext),All:=ScanFile.All[ea.ID]:={Omni:Omni,Language:LanguageFromFileExt(ea.Ext)},Main:=ScanFile.FileList[ea.File]
		xx:=ScanFile.XML
		if(SSN(Main,"@time").text!=Time||Refresh){
			Main.ParentNode.RemoveChild(Main),this.ScanText(ea,(Node:=this.RemoveComments(ea)))
		}else{
			if(Node:=ScanFile.FileList[ea.File]){
				Node.SetAttribute("id",ea.ID),Obj:=ScanFile.GetCEXML(ea)
				for a,b in XML.EA(Obj.Node)
					Node.SetAttribute(a,b)
				rem:=Obj.Node,rem.ParentNode.RemoveChild(rem),Obj.Parent.AppendChild(Node.CloneNode(1))
			}
		}Node.SetAttribute("time",Time),Node.SetAttribute("file",ea.File),Node.SetAttribute("id",ea.ID)
		if(!Top:=ScanFile.MainList[(PFile:=SSN(Parent,"@file").text)])
			Parent:=Parent.CloneNode(0),Top:=xx.XML.DocumentElement.AppendChild(Parent),ScanFile.MainList[PFile]:=Top
		if(Node.ParentNode.NodeName!="main")
			Top.AppendChild(Node)
		return Node
	}ScanText(ea,No:=""){
		Oea:=ea,Text:=ScanFile.CurrentText,All:=ScanFile.GetAll(ea),Nea:=XML.EA(Node:=cexml.SSN("//file[@id='" ea.ID "']")),Parent:=Node.ParentNode,Node.ParentNode.RemoveChild(Node),Node:=cexml.Under(Parent,"file",NEA),xx:=ScanFile.XML,Omni:=All.Omni,No:=No?No:xx.SSN("//file[@id='" ea.ID "']")
		for c,d in Omni{
			for a,b in d{
				LastPos:=""
				if(InStr(a,Chr(127))){
					Obj:=StrSplit(a,Chr(127)),Pos:=1
					while(RegExMatch(Text,b.Regex,FUnder,Pos),Pos:=FUnder.Pos(1)+FUnder.Len(1)){
						if(FUnder.Text~="i)\b(" b.exclude ")\b"!=0&&FUnder.Text)
							Continue
						Start:=FUnder.Pos(1) ;StrPut(SubStr(Text,1,FUnder.Pos(1)),"UTF-8")-2
						NNList:=SN(No,"descendant::*[@start<'" Start "' and @end>'" Start "']")
						if(NNList.Length)
							NN:=NNList.item[NNList.Length-1],UnderHere:=SSN(Node,"descendant::*[@text='" SSN(NN,"@text").text "' and @type='" Obj.1 "']"),Spam:=cexml.Under(UnderHere,"info",{type:Obj.2,att:FUnder.Att,pos:Start,text:FUnder.Text,upper:Upper(FUnder.Text)}),NN.AppendChild(Spam.CloneNode(0))
					}
				}else{
					Pos:=1
					/*
						if(ea.FileName="ScanLines.ahk"&&a="BookMark") I have a list of multiples within Keywords. Omni NOT ORDER
							m(a,b.regex,Found.Text)
					*/
					while(RegExMatch(Text,b.regex,Found,Pos),Pos:=Found.Pos(0)+Found.Len(0)){
						if(Pos=LastPos)
							Break
						if(b.Open){
							Search:=b.Open,Pos1:=Found.Pos(1),Open:=0,LastPos1:=0,Bounds:=b.Bounds
							Start:=Found.Pos(1)
							Loop
							{
								RegExMatch(Text,b.Open,OpenObj,Pos1)
								RegExMatch(Text,b.Close,Close,Pos1)
								OP:=OpenObj.Pos(1),CP:=Close.Pos(1)
								if(!OP||!CP)
									Break
								if(CP<OP)
									Pos1:=CP+Close.Len(1),FoundSearch:=Close.0,FIS:="Close"
								else
									Pos1:=OP+OpenObj.Len(1),FoundSearch:=OpenObj.0,FIS:="Open"
								RegExReplace(FoundSearch,"(" Bounds ")",,Count)
								if(Count){
									Open+=FIS="Open"?+Count:-Count
									SavedPos:=Pos1
									if(Open<=0)
										Break
								}if(Pos1=LastPos1)
									Break
								LastPos1:=Pos1
							}
							Atts:=Combine({start:Found.Pos(1),end:SavedPos,type:a,upper:Upper(Found.Text)},Found)
							Start:=Found.Pos(1)
							Spam:=((Deepest:=SN(Node,"descendant::*[@start<'" Start "' and @end>'" Start "']")).length)?cexml.Under(Deepest.item[Deepest.Length-1],"info",Atts):cexml.Under(Node,"info",Atts)
							New:=No.AppendChild(Spam.CloneNode(0))
							if((GoUnder:=SN(No,"descendant::*[@start<'" Start "' and @end>'" End "']")).Length)
								GoUnder.item[GoUnder.Length-1].AppendChild(New)
							else
								No.AppendChild(New)
						}else{
							if(b.Exclude){
								if(Found.Text~="\b(" b.exclude ")\b"=0&&Found.Text){
									Start:=Found.Pos(1) ;StrPut(SubStr(Text,1,Found.Pos(1)),"UTF-8")-2
									if(!SSN(No,"descendant::*[@start<'" Start "' and @end>'" Start "']"))
										Spam:=cexml.Under(Node,"info",{type:a,att:Found.Att,pos:Start,text:Found.Text,upper:Upper(Found.Text)}),No.AppendChild(Spam.CloneNode(0))
								}
							}else if(Found.Text){
								Start:=Found.Pos(1) ;StrPut(SubStr(Text,1,Found.Pos(1)),"UTF-8")-2
								if(!SSN(No,"descendant::*[@start<'" Start "' and @end>'" Start "']")){
									Atts:=[]
									Loop,% Found.Count(){
										if(NNN:=Found.Name(A_Index)){
											if(VVV:=Found[NNN]){
												Atts[Format("{:L}",NNN)]:=VVV
										}}
									}
									for q,r in {type:a,upper:Upper(Found.Text)}{
										Atts[q]:=r
									}
									Spam:=cexml.Under(Node,"info",Atts)
									No.AppendChild(Spam.CloneNode(0))
								}
							}
						}
						LastPos:=Pos
					}
				}
			}
		}
	}
}
LanguageFromFileExt(Ext){
	static Languages:=[]
	return (Languages[Ext]:=Languages[Ext]?Languages[Ext]:Settings.SSN("//Extensions/Extension[text()='" Format("{:L}",Ext) "']/@language").text)
}
Combine(Atts,Found){
	Loop,% Found.Count(){
		if(Name:=Found.Name(A_Index))
			if(Value:=Found[Name])
				Atts[Format("{:L}",Name)]:=Value
	}return Atts
}
ScanParent(Text,b){
	static SP:=new XML("SP")
	SP.XML.LoadXML("<SP/>"),Bounds:=b.Bounds,LastOuterPos:=OuterPos:=1,Parents:=[]
	while(RegExMatch(Text,b.Regex,OuterFound,OuterPos),OuterPos:=OuterFound.Pos(1)+OuterFound.Len(1)){
		if(OuterPos=LastOuterPos)
			Break
		LastOuterPos:=OuterPos,StartPos:=Pos1:=OuterFound.Pos(1)
		Loop
		{
			RegExMatch(Text,b.Open,OpenObj,Pos1),RegExMatch(Text,b.Close,Close,Pos1)
			OP:=OpenObj.Pos(1),CP:=Close.Pos(1)
			if(!OP||!CP)
				Break
			if(CP<OP)
				Pos1:=CP+Close.Len(1),FoundSearch:=Close.0,FIS:="Close"
			else
				Pos1:=OP+OpenObj.Len(1),FoundSearch:=OpenObj.0,FIS:="Open"
			RegExReplace(FoundSearch,"(" Bounds ")",,Count)
			if(Count){
				Open+=FIS="Open"?+Count:-Count
				SavedPos:=Pos1
				if(Open<=0)
					Break
			}if(Pos1=LastPos1)
				Break
			LastPos1:=Pos1
		}Parent:=SP.SN("//*[@start<'" StartPos "' and @end>'" SavedPos "']")
		SP.Under((Parent.Length?Parent.Item[Parent.Length-1]:SP.SSN("//*")),"info",{start:StartPos,end:SavedPos,text:OuterFound.Text})
	}
	return SP
}
SetTimers(Timers*){
	for a,b in Timers{
		Obj:=StrSplit(b,",")
		SetTimer,% Obj.1,% Obj.2
	}
}
DLG_FileSave(HWND:=0,Filter="Text Files (*.txt)|All Files (*.*)",DefaultFilter=1,DialogTitle="Select file to open",DefaultFile:="",Flags:=0x00000002){
	VarSetCapacity(lpstrFileTitle,0xFFFF,0),VarSetCapacity(lpstrFile,0xFFFF,0),VarSetCapacity(lpstrFilter,0xFFFF,0),VarSetCapacity(lpstrCustomFilter,0xFF,0),VarSetCapacity(OFName,90,0),VarSetCapacity(lpstrTitle,255,0)
	Address:=&lpstrFilter
	for a,b in StrSplit(Filter,"|"){
		for c,d in StrSplit(b)
			Address:=NumPut(Asc(d),Address+0,"UChar")
		Address:=NumPut(0,Address+0,"UChar")
		RegExMatch(b,"OU)\((.*)\)",Found)
		for c,d in StrSplit(Found.1)
			Address:=NumPut(Asc(d),Address+0,"UChar")
		Address:=NumPut(0,Address+0,"UChar")
	}NumPut(0,Address+0,"UChar"),StrPut(File,&lpstrFile,"UTF-8"),StrPut(DialogTitle,&lpstrTitle,"UTF-8")
	;Structure https://msdn.microsoft.com/en-us/library/windows/desktop/ms646839(v=vs.85).aspx
	Address:=&OFName
	for a,b in [76,HWND,0,&lpstrFilter,&lpstrCustomFilter,255,defaultFilter,&lpstrFile,0xFFFF,&lpstrFileTitle,0xFFFF,&lpstrInitialDir,&lpstrTitle,Flags,0,&lpstrDefExt]
		Address:=NumPut(b,Address+0,"UInt")
	if(!DllCall("comdlg32\GetSaveFileNameA","Uint",&OFName))
		Exit
	while(Char:=NumGet(lpstrFile,A_Index-1,"UChar"))
		FileName.=Chr(Char)
	return FileName
}