#SingleInstance,Off
SetBatchLines,-1
SetWorkingDir,%A_ScriptDir%
SetControlDelay,-1
#MaxHotkeysPerInterval,2000
DetectHiddenWindows,On
CoordMode,ToolTip,Screen
global v:=[],MainWin,settings:=new XML("settings","lib\Settings.xml"),files:=new XML("files"),Positions:=new XML("positions","lib\Positions.xml"),cexml:=new XML("cexml"),History:=new XML("HistoryXML"),vversion:=new XML("versions","lib\Versions.xml"),commands,menus,scintilla,TVC:=new EasyView(),RCMXML:=new XML("RCM","lib\RCM.xml"),TNotes,debugwin
if(!settings[]){
	Run,lib\settings.xml
	m("Oh boy...check the settings file to see what's up.")
}
v.LineEdited:=[],v.LinesEdited:=[],v.RunObject,v.OmniFind:={Function:"OUm`n)^[\s|}]*((\w|[^\x00-\x7F])+)\((.*)\)(\s*;.*\R){0,}\s*(\{)(\s*;\R){0,}",Class:"Oim`n)^[\s|}]*(class\s+((\w|[^\x00-\x7F])+))[\s+extends\s+\w+\s*]*(\s*;.*\R){0,}\s*(\{)",Property:"Om`n)^[\s|}]*((\w|[^\x00-\x7F])+)\[(.*)\](\s*;.*\R){0,}\s*(\{)",Label:"UOm`n)^\s*((\w|[^\x00-\x7F])+):[\s|\R][\s+;]?",Hotkey:"OUi`nm)^\s*(((\w|[^\x00-\x7F]|#|!|\^|\+|~|\$|&|<|>|\*)+\s+&\s+)*(\w|[^\x00-\x7F]|#|!|\^|\+|~|\$|&|<|>|\*)+)::",Bookmark:"OU);#\[(.*)\]",Breakpoint:"OU);\*\[(.*)\]",Instance:"OUi)(\w+)\s*:=\s*new\s*(\w+)\("},v.OmniFindText:={Function:["OUm`n)^[\s|}]*(",")\((.*)\)(\s*;.*\R){0,}\s*(\{)"],Class:["Oim`n)^[\s|}]*(class\s+(","))[\s+extends\s+\w+\s*]*(\s*;.*\R){0,}\s*(\{)"],Method:["OUm`n)^[\s|}]*(",")\((.*)\)(\s*;.*\R){0,}\s*(\{)"],Property:["Om`n)^[\s|}]*(",")\[(.*)\](\s*;.*\R){0,}\s*(\{)"],Label:["UOm`n)^\s*(","):[\s|\R][\s+;]?"],Bookmark:["OU);#\[(",")\]"],Breakpoint:["OU);\*\[(",")\]"],Hotkey:["OUi`nm)^\s*(\Q","\E)::"],Instance:["OUi).*(",")\s*:=\s*new\s*(\w+)\("]},v.OmniFindMinimum:={Function:"OUm`n)^[\s|}]*((\w|[^\x00-\x7F])+)\(.*\)",Class:"Oim`n)^[\s|}]*(class\s+((\w|[^\x00-\x7F])+))",Property:"Om`n)^[\s|}]*((\w|[^\x00-\x7F])+)\[(.*)?\]"},v.OmniFindString:="OUm`n)(?<Function>^[\s|}]*((\w|[^\x00-\x7F])+)\((.*)\)(\s*;.*\R){0,}\s*(\{)(\s*;\R){0,})|(?<Class>^[\s|}]*(class\s+((\w|[^\x00-\x7F])+))[\s+extends\s+\w+\s*]*(\s*;.*\R){0,}\s*(\{))|(?<Property>^[\s|}]*((\w|[^\x00-\x7F])+)\[(.*)\](\s*;.*\R){0,}\s*(\{))|(?<Label>^\s*((\w|[^\x00-\x7F])+):[\s|\R][\s+;]?)|(?<Hotkey>^\s*(((\w|[^\x00-\x7F]|#|!|\^|\+|~|\$|&|<|>|\*)+\s+&\s+)*(\w|[^\x00-\x7F]|#|!|\^|\+|~|\$|&|<|>|\*)+)::)|(?<Bookmark>;#\[(.*)\])|(?<Breakpoint>;\*\[(.*)\])|(?<Instance>(\w+)\s*:=\s*new\s*(\w+)\()"
;,Variable:"Osm`n)(\w+)\s*:="
/*
	MISC NOT WORKING:
	Undo:
	When you undo something with more than 1 class it doesn't undo properly
	Joe_Glines{
		Check Edited Files On Focus:
		have it so that it asks first to replace the text rather than automaticxally
		More languages (programming)
	}
	Fix Bugs
	Misc Ideas:
	more languages (spoken)
	When you edit/add a line with an include:{
		have it scan that line (add a thing in the Scan_Line() for it)
	}
*/
ComObjError(0),FileCheck(%true%),Options("startup"),menus:=new XML("menus","Lib\Menus.xml"),Keywords(),new Omni_Search_Class(),Gui(),DefaultRCM()
return
WinPos(hwnd){
	VarSetCapacity(rect,16),DllCall("GetClientRect",ptr,hwnd,ptr,&rect)
	WinGetPos,x,y,,,% "ahk_id" hwnd
	w:=NumGet(rect,8),h:=NumGet(rect,12),text:=(x!=""&&y!=""&&w!=""&&h!="")?"x" x " y" y " w" w " h" h:""
	return {x:x,y:y,w:w,h:h,ah:h-v.status-v.qfh,text:text}
}
Debug(text){
	static sc,NewWin
	if(!WinExist("ahk_id" sc.sc)){
		csc:=csc(),NewWin:=new GUIKeep("Debug"),NewWin.Add("s,w400 h200,,wh")
		GuiControl,Debug:+g,% NewWin.sc.1.sc
		NewWin.Show("Debug Window",,1),sc:=NewWin.sc.1,sc.2277(1),csc({hwnd:csc.sc})
	}
	text.="`n"
	sc.2003(sc.2006,text),sc.2025(sc.2006)
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
	Setup(11),Hotkeys(11,{"Esc":"11Close"}), Version:="1.003.2"
	Gui,Margin,0,0
	sc:=new s(11,{pos:"x0 y0 w700 h500"}),csc({hwnd:sc})
	Gui,Add,Button,gdonate,Donate
	Gui,Add,Button,x+M gsite,Website
	Gui,Show,w700 h550,AHK Studio Help Version: %version%
	sc.2181(0,about),sc.2025(0),sc.2268(1)
	return
	11Close:
	11Escape:
	hwnd({rem:11})
	return
	site:
	Run,https://github.com/maestrith/AHK-Studio
	return
}
Testing(){
	;BraceSetup(1)
	if(A_UserName!="maestrith")
		return m("Testing")
	Hotkey,IfWinActive,% hwnd([1])
	Hotkey,<^>{,brace,On
	m("set")
	
	
	
	
	
	
	return
	fucker:
	msgbox fucker zaz
	return
	/*
		sc:=csc()
		sc.2198(0)
		dup:=[]
		cexml.xml.preserveWhiteSpace:=1
		current:=Current(5)
		list:=SN(current,"descendant::*[@type='Breakpoint']")
		while(ll:=list.item[A_Index-1]),ea:=xml.EA(ll){
			if(dup[ea.text])
				Continue
			sc.2686(0,sc.2006),search:=";*[" ea.text "]"
			total:=SN(current,"descendant::*[@type='Breakpoint' and @text='" ea.text "']")
			while((pos:=sc.2197(StrPut(search,"UTF-8")-1,search))>=0){
				sc.2686(pos+1,sc.2006)
				total.item[A_Index-1].SetAttribute("line",sc.2166(pos))
			}
			dup[ea.text]:=1
		}
		cexml.xml.preserveWhiteSpace:=0
		sc.2198(0x2)
		
		;debug.Send("breakpoint_set -t line -f " bpea.filename " -n" bpea.line)
		return
	*/
	/*
		;Display current in Code Explorer
		SetWords(1),line:=ScanLines((LineNum:=sc.2166(sc.2008))),class:=GetCurrentClass(LineNum),word:=sc.GetWord(),SetWords()
		for a,b in v.OmniFind{
			if(RegExMatch(line.text,b,found)){
				if(class.name){
					node:=SSN(Current(5),"descendant::*[@type='Class' and @text='" class.name "']")
					if(a="Class")
						TVC.Modify(2,,SSN(node,"@cetv").text,"Select Vis Focus")
					else if(tv:=SSN(node,"descendant::*[@type='" (a="Function"?"Method":a) "' and @text='" word "']/@cetv").text)
						TVC.Modify(2,,tv,"Select Vis Focus")
					Break
				}else{
					if(tv:=SSN(Current(5),"descendant::*[@type='" a "' and @text='" word "']/@cetv").text){
						TVC.Modify(2,,tv,"Select Vis Focus")
						Break
					}
				
			}
		}
		return
	*/
	/*
		Gui,Separate:Default
		doc:=csc().2357
		sc:=new s("Separate",{pos:"w400 h400"})
		sc.2358(0,doc)
		Hotkeys("Separate")
		BraceSetup("Separate")
		Gui,Show
		return
	*/
	/*
		make this a universal thing.
		save the last import directory by 
	*/
	FileSelectFile,file,,D:\AHK\Duplicate Programs\AHK Studio,Import from main script,*.ahk
	if(ErrorLevel)
		return
	if(!FileExist(file))
		return m("File does not exist")
	SplitPath,file,filename
	FileCopy,%file%,%A_ScriptDir%\%filename%
	if(ErrorLevel)
		return m("already there")
	sc:=csc(),sc.2003(sc.2008,"#Include " filename "`n"),sc.2025(sc.2008+StrPut("#Include " filename))
	SplitPath,file,,dir
	settings.Add("Import").text:=dir,Save(),Extract(Current(2).file),ScanFiles(),FEUpdate(1)
}
Activate(a,b,c,d){
	if(a&&v.Options.Check_For_Edited_Files_On_Focus=1)
		Check_For_Edited()
	csc().2400
	return 0
}
AddBookmark(line,search){
	sc:=csc(),end:=sc.2136(line),start:=sc.2128(line),name:=(settings.SSN("//bookmark").text),name:=name?name:SubStr(StrSplit(Current(2).file,"\").pop(),1,-4)
	for a,b in {"$file":SubStr(StrSplit(Current(3).file,"\").pop(),1,-4),"$project":SubStr(StrSplit(Current(2).file,"\").pop(),1,-4)}
		name:=RegExReplace(name,"i)\Q" a "\E",b)
	if(RegExMatch(name,"UO)\[(.*)\]",time)){
		FormatTime,currenttime,%A_Now%,% time.1
		name:=RegExReplace(name,"\Q[" time.1 "]\E",currenttime)
	}sc.2003(end," " Chr(59) search.1 "[" name "]"),sc.2160(end+4,end+4+StrPut(name,utf-8)-1)
	return name
}
AddMissing(){
	all:=SN(Current(5),"descendant::*[not(@cetv)]")
	while(aa:=all.item[A_Index-1]),ea:=xml.EA(aa){
		if(!header:=SSN(aa.ParentNode,"@cetv").text)
			header:=Header(ea.type)
		aa.SetAttribute("cetv",TVC.Add(2,ea.text,header,(ea.type~="Method|Property"=0?"Sort":"")))
	}
}
AddNewLines(text,current){
	for a,b in GetAllTopClasses(text){
		if((nodes:=SN(current,"descendant::*[@type='Class' and @text='" b.name "']")).length)
			Code_Explorer.RemoveTV(nodes)
		Class(b.text,current)
		for c,d in v.OmniFind{
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
	for a,b in v.OmniFind{
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
AddInclude(Filename:="",text:="",pos:=""){
	static new
	file:=FileOpen(filename,"RW","UTF-8"),file.write(text),file.length(file.position),rel:=RelativePath(Current(2).file,filename),sc:=csc()
	SplitPath,filename,fn,dir,ext,nne,drive
	FileGetTime,time,%filename%
	if(v.Options.Includes_In_Place){
		current:=Current(7),line:=sc.2166(sc.2008)
		if(Trim(RegExReplace(sc.GetLine(line),"\R"))){
			sc.2003(sc.2136(line),"`n#Include " rel)
			if(v.Options.Full_Auto_Indentation)
				NewIndent()
		}else
			sc.2003(sc.2008,"#Include " rel)
	}else{
		current:=Current(4)
		if(SSN(current,"@file").text=Current(3).file)
			sc.2003(sc.2006,"`n#Include " rel)
		else
			Update({file:Current(2).file,text:Update({get:Current(2).file}) "`n#Include " rel}),current.RemoveAttribute("sc")
	}
	 ;#[Needs to check to see if it is in a folder first]
	new:=files.Under(current,"file",{id:GetID(),file:filename,include:"#Include " rel,inside:SSN(current,"@file").text,dir:dir,filename:fn,github:fn,nne:nne,time:time,encoding:"UTF-8",scan:1,tv:TVC.Add(1,fn,SSN(current,"@tv").text,"Sort")}),add:=Current(7).AppendChild(new.CloneNode(1)),add.SetAttribute("type","File"),Update({file:filename,text:text}),ScanFiles(),Update({file:filename,text:text,node:current}),Code_Explorer.scan(new),Default("SysTreeView321"),tv(SSN(new,"@tv").text,pos)
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
	}}
	return
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
	static setup:={"<":">",(Chr(34)):Chr(34),"'":"'","(":")","%":"%"},keep:=[]
	v.AutoAdd:=[],v.BraceMatch:=[],v.MatchBrace:=[],v.BraceDelete:=[],v.DeleteBrace:=[],list:=settings.SSN("//autoadd/@altgr").text?{"<^>[":"]","<^>{":"}"}:{"{":"}","[":"]"}
	/*
		make this list editable at some point.
	*/
	for a,b in list
		setup[a]:=b
	Hotkey,IfWinActive,% hwnd([win])
	all:=settings.SN("//autoadd/*")
	while(aa:=all.item[A_Index-1]),ea:=XML.EA(aa){
		Try
			Hotkey,% ea.trigger,Brace,On
		Catch,e
			m(e.message,aa.xml)
		v.AutoAdd[ea.trigger]:=ea.add,v.BraceMatch[ea.add]:=ea.trigger,v.MatchBrace[ea.trigger]:=ea.add
	}
	if(!(nodes:=settings.SN("//autodelete/*")).length){
		node:=settings.Add("autodelete")
		for a,b in setup
			settings.Under(node,"key",{open:a,close:b})
		nodes:=settings.SN("//autodelete/*")
	}while(nn:=nodes.item[A_Index-1]),ea:=xml.EA(nn)
		v.BraceDelete[ea.open]:=ea.close,v.DeleteBrace[ea.close]:=ea.open
	return
	Brace:
	ControlGetFocus,focus,A
	if(!InStr(focus,"Scintilla")){
		Send,{%A_ThisHotkey%}
		return
	}
	sc:=csc(),Hotkey:=SubStr(A_ThisHotkey,0),line:=sc.2166(sc.2008)
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
		}
	}if(sc.2008!=sc.2009)
		return BookEnd(v.BraceMatch[Hotkey],Hotkey)
	add:=v.MatchBrace[Hotkey]?v.MatchBrace[Hotkey]:v.BraceMatch[Hotkey]
	if(Hotkey=Chr(34)){
		sc.2078
		loop,% sc.2570{
			cpos:=sc.2585(A_Index-1)
			if(sc.2007(cpos)=34)
				sc.2584(A_Index-1,cpos+1),sc.2586(A_Index-1,cpos+1)
			else
				bad:=sc.2010(cpos)=13,sc.2686(cpos,cpos),sc.2194(bad?1:2,(bad?Chr(34):Chr(34) Chr(34))),sc.2584(A_Index-1,cpos+1),sc.2586(A_Index-1,cpos+1)
		}
		return sc.2079
	}else if(Hotkey="'"){
		sc.2078
		loop,% sc.2570{
			cpos:=sc.2585(A_Index-1)
			if(sc.2007(cpos)=39)
				sc.2584(A_Index-1,cpos+1),sc.2586(A_Index-1,cpos+1)
			else
				one:=sc.2267(cpos-1,1)=cpos,sc.2686(cpos,cpos),sc.2194(one?1:2,(one?"'":"''")),sc.2584(A_Index-1,cpos+1),sc.2586(A_Index-1,cpos+1)
		}
		return sc.2079
	}
	if(sc.2102&&v.Options.Disable_Auto_Insert_Complete!=1&&(Hotkey~="\(|\{")){
		word:=sc.GetWord()
		VarSetCapacity(text,sc.2610),sc.2610(0,&text),word:=StrGet(&text,"UTF-8") Hotkey v.BraceMatch[Hotkey]
		loop,% sc.2570
			pos:=sc.2585(A_Index-1),start:=sc.2266(pos,1),end:=sc.2267(pos,1),sc.2686(start,end),sc.2194((len:=StrPut(word,"UTF-8")-1),[word]),GoToPos(A_Index-1,start+len-1),sc.2101()
		return
	}
	Loop,% sc.2570{
		cpos:=sc.2585(A_Index-1),line:=sc.2166(cpos)
		if(Chr(sc.2007(cpos))=Hotkey&&!v.Options.Disable_Auto_Advance){
			sc.2584(A_Index-1,cpos+1),sc.2586(A_Index-1,cpos+1)
			Continue
		}
		if(Hotkey="{"&&v.AutoAdd[Hotkey]){
			sc.2078(),ind:=sc.2127(line),tab:=settings.Get("//tab",5)
			if(sc.2128(line)=sc.2136(line)){
				prev:=sc.GetLine(line-1)
				if(RegExMatch(prev,"iA)(}|\s)*#?\b(" v.indentregex ")\b"))
					if(SubStr(RegExReplace(prev,"\s+" Chr(59) ".*"),0,1)!="{")
						if(sc.2127(line)>sc.2127(line-1))
							sc.2126(line,sc.2127(line)-tab),GoToPos(A_Index-1,(cpos:=sc.2128(line)))
				sc.2686(cpos,cpos),sc.2194(4,"{`n`n}"),ind:=sc.2127(line),sc.2126(line+1,ind+tab),sc.2126(line+2,ind),sc.2584(A_Index-1,sc.2128(line+1)),sc.2586(A_Index-1,sc.2128(line+1)),sc.2399
			}else if(sc.2128(line)=cpos)
				end:=sc.2136(line),sc.2686(end,end),sc.2194(2,"`n}"),sc.2686(cpos,cpos),sc.2194(2,"{`n"),ind:=sc.2127(line),sc.2126(line+1,ind+tab),sc.2126(line+2,ind),sc.2584(A_Index-1,sc.2128(line+1)),sc.2586(A_Index-1,sc.2128(line+1)),sc.2399
			else
				sc.2686(cpos,cpos),sc.2194(2,hotkey v.AutoAdd[Hotkey]),sc.2584(A_Index-1,cpos+1),sc.2586(A_Index-1,cpos+1)
			sc.2079
		}else if(v.AutoAdd[Hotkey])
			sc.2686(cpos,cpos),sc.2194(2,hotkey v.AutoAdd[Hotkey]),sc.2584(A_Index-1,cpos+1),sc.2586(A_Index-1,cpos+1)
		else
			sc.2686(cpos,cpos),sc.2194(1,hotkey),sc.2584(A_Index-1,cpos+1),sc.2586(A_Index-1,cpos+1)
	}return SetStatus("Last Entered Character: " hotkey " Code:" Asc(hotkey),2)
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
	sc:=csc(),sc.2169,a:=sc.2166(sc.2585(sc.2575)),total:=sc.2370/2-1
	if(v.Options.center_caret!=1){
		sc.2403(0x04|0x08)
		Sleep,1
		sc.2169(),sc.2403(0x08,0)
	}
}
Check_For_Edited(){
	all:=files.SN("//file"),sc:=csc()
	while,aa:=all.item[A_Index-1],ea:=xml.ea(aa){
		FileGetTime,time,% ea.file
		if(time!=ea.time&&ea.note!=1){
			list.=ea.filename ",",aa.SetAttribute("time",time)
			FileRead,text,% ea.file
			text:=RegExReplace(text,"\r\n|\r","`n")
			if(ea.sc=sc.2357)
				sc.2181(0,[text])
			else if(ea.sc&&ea.sc!=sc.2357)
				sc.2377(ea.sc),aa.RemoveAttribute("sc")
			Update({file:ea.file,text:text}),SetPos()
		}
	}
	if(list)
		SetStatus("Files Updated:" Trim(list,","),3)
	return 1
}
class Code_Explorer{
	static explore:=[]
	Add(type,found,node:=""){
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
	}RemoveItem(current,type,text){
		rem:=SSN(current,"descendant::*[@type='" type "' and @text='" text "']")
		if(tv:=SSN(rem,"@cetv").text)
			TVC.Delete(2,tv)
		rem.ParentNode.RemoveChild(rem)
	}
	Scan(node,text:=""){
		ea:=xml.ea(node)
		if(SSN(node,"//*").NodeName="files"){
			if(!ea.ID)
				return
			current:=cexml.SSN("//file[@id='" ea.id "']"),text:=Update({get:ea.file}),node:=current
		}
		text:=RegExReplace(text,"\R\R")
		this.ScanComments(text),this.ScanClass(text,node),this.ScanFM(text,node),no:=v.CommentArea
		for type,find in {Hotkey:v.OmniFind.Hotkey,Label:v.OmniFind.Label}{
			pos:=1
			while,RegExMatch(text,find,fun,pos),pos:=fun.pos(1)+fun.len(1){
				if(!fun.len(1))
					Break
				if(!no.SSN("//bad[@min<'" fun.pos(1) "' and @max>'" fun.pos(1) "' and @type!='Class']"))
					cexml.under(node,"info",{type:type,pos:StrPut(SubStr(text,1,fun.Pos(1)),"utf-8")-3,text:fun.1,upper:upper(fun.1)})
		}}pos:=1
		/*
			add this.InComment to the other things...
		*/
		while,RegExMatch(text,v.OmniFind.Instance,found,pos),pos:=found.Pos(2)+found.len(2){
			if(!found.len(1))
				break
			if(!no.SSN("//bad[@min<'" found.pos(1) "' and @max>'" found.pos(1) "' and @type!='Class']"))
				cexml.Under(node,"info",{type:"Instance",upper:upper(found.1),pos:StrPut(SubStr(text,1,found.Pos(1)),"utf-8")-3,text:found.1,class:found.2})
		}pos:=1
		while,RegExMatch(text,"OUi);gui\[(.*)\].*\R(.*)\R;/gui\[.*\]",found,pos),pos:=found.Pos(1)+found.len(1)
			cexml.Under(node,"info",{type:"Gui",opos:found.Pos(1)-1,pos:ppp:=StrPut(SubStr(text,1,found.Pos(1)),"utf-8")-3,start:found.Pos(2)-1,end:found.Pos(2)+found.len(2),text:found.1,upper:upper(found.1)})
		for a,b in {Bookmark:"\s+;#\[(.*)\]",Breakpoint:"\s+;\*\[(.*)\]"}{
			pos:=1
			while,pos:=RegExMatch(text,"OU)" b,found,pos),pos:=found.Pos(1)+found.len(1){
				nnn:=cexml.Under(node,"info",{type:a,upper:upper(found.1),pos:StrPut(enter:=SubStr(text,1,found.Pos(0)),"utf-8"),text:found.1})
				if(a="Breakpoint"){
					RegExReplace(enter,"\R",,Count)
					nnn.SetAttribute("line",Count),nnn.SetAttribute("filename",ea.file)
	}}}}RemoveTV(nodes){
		type:=SSN(nodes.item[0],"@type").text
		while(nn:=nodes.item[A_Index-1]),ea:=xml.EA(nn){
			if(ea.cetv)
				TVC.Delete(2,ea.cetv)
			nn.ParentNode.RemoveChild(nn)
		}if(!SSN((Parent:=Current(7)),"descendant::info[@type='" type "']")){
			node:=SSN(Parent,"descendant::header[@type='" type "']")
			if(tv:=SSN(node,"@cetv").text)
				TVC.Delete(2,tv)
			node.ParentNode.RemoveChild(node)
		}
	}InComment(found,start:=0){
		return v.CommentArea.SSN("//*[@min<" found.pos(0)+start " and @max>" found.pos(0)+start "]")?1:0
	}
	ScanClass(FileText,parent){
		if(!v.startup)
			this.ScanComments(FileText)
		classes:=GetAllTopClasses(FileText),SubClass:=[],move:=[]
		for a,b in classes{
			pos:=1,start:=InStr(FileText,b.text)-1
			while(RegExMatch(b.text,v.OmniFind.Class,found,pos)),pos:=found.pos(1)+found.len(1){
				InComment:=this.InComment(found,start)
				if(InComment)
					Continue
				if(!found.len(1))
					break
				if(A_Index=1){
					main:=cexml.Under(parent,"info",{start:start+found.pos(1)-1,end:start+found.pos(1)+StrLen(b.text)-1,type:"Class",text:found.2,upper:Upper(found.2)})
				}else
					ScanText:=SubStr(b.text,found.pos(1)),CText:=GetClassText(ScanText,found.2),new:=cexml.Under(main,"info",{start:start+found.pos(1)-1,end:start+found.pos(1)+StrLen(CText)-1,type:"Class",text:found.2,upper:Upper(found.2)})
			}
		}
		all:=SN(parent,"descendant::*")
		while(aa:=all.item[A_Index-1]),ea:=xml.EA(aa){
			inside:=SN(parent,"descendant::*[@start<" ea.start " and @end>" ea.end "]"),last:=[]
			while(ii:=inside.item[A_Index-1]),ea:=xml.EA(ii)
				last[ea.start]:=ii
			if(last.MaxIndex())
				move.push([last[last.MaxIndex()],aa])
		}for a,b in move
			b[1]["AppendChild"](b.2)
	}
	ScanComments(FileText){
		static no:=new xml("no")
		v.CommentArea:=no,no:=v.CommentArea,classes:=[],rem:=no.SSN("//bad"),rem.ParentNode.RemoveChild(rem),notop:=no.add("bad"),pos:=1
		while(RegExMatch("`n" FileText,"OU)(\n\s*\x2F\x2A.*\s*\x2A\x2F)",found,pos),pos:=found.pos(1)+found.len(1)){
			if(!found.len(1))
				Break
			if(!found.len(1)&&!found.len(2))
				Break
			if(found.pos(1))
				pos:=found.pos(1)+found.len(1),no.under(notop,"bad",{min:found.pos(1)-3,max:found.pos(1)+found.len(1)-3,type:"comment"})
		}pos:=1
		while(RegExMatch(FileText,"OU).*(\s+;.*)(\R|$)",found,pos),pos:=found.pos(1)+found.len(1)){
			if(!found.len(1))
				Break
			no.under(notop,"bad",{min:found.pos(1)-3,max:found.pos(1)+found.len(1)-3,type:"comment",semi:1})
		}
	}
	ScanFM(FileText,parent){
		if(SSN(parent,"@type").text="class"){
			top:=Current(5),start:=SSN(parent,"@start").text
			for a,b in {Method:v.OmniFind.Function,Property:v.OmniFind.Property}{
				pos:=1
				while(RegExMatch(FileText,b,found,pos)),pos:=found.pos(1)+found.len(1){
					if(!found.len(1))
						Break
					if(found.1~="i)if|while|RegExMatch|RegExReplace")
						Continue
					if(this.InComment(found)){
						Continue
					}
					max:=[],all:=SN(top,"descendant::*[@type='Class' and @start<" start+found.pos(1) " and @end>" start+found.pos(1) "]")
					while(aa:=all.item[A_Index-1]),ea:=xml.EA(aa){
						max[ea.start]:=aa
					}node:=max[max.MaxIndex()]
					TVC.Default(2),cexml.Under(node,"info",{class:SSN(node,"@text").text,text:found.1,upper:Upper(found.1),type:a,cetv:TV_Add(found.1,SSN(node,"@cetv").text,"Sort")})
		}}}else{
			for a,b in {Function:v.OmniFind.Function,Property:v.OmniFind.Property}{
				pos:=1
				while(RegExMatch(FileText,b,found,pos)),pos:=found.pos(1)+found.len(1){
					last:=[]
					if(!found.len(1))
						break
					if(found.1~="i)\b(" v.IndentRegex ")\b")
						Continue
					if(this.InComment(found))
						Continue
					list:=SN(parent,"descendant::*[@start<" found.pos(1) " and @end>" found.pos(1) "]")
					while(ll:=list.item[A_Index-1]),ea:=xml.EA(ll){
						last[ea.start]:=ll
					}if((under:=last[last.MaxIndex()]).xml){
						cexml.Under(under,"info",{args:found.3,id:SSN(parent,"ancestor-or-self::file/@id").text,class:SSN(under,"@text").text,type:(a="Function"?"Method":a),text:found.1,upper:Upper(found.1)})
					}else
						cexml.Under(parent,"info",{type:a,text:found.1,id:SSN(parent,"ancestor-or-self::file/@id").text,args:found.3,upper:Upper(found.1)})
		}}}
		/*
			all:=SN(parent,"descendant::*[@start or @end]")
			while(aa:=all.item[A_Index-1]),ea:=xml.EA(aa)
				aa.RemoveAttribute("start"),aa.RemoveAttribute("end")
		*/
	}
	Remove(filename){
		this.explore.remove(SSN(filename,"@file").text),list:=SN(filename,"@file")
		while,ll:=list.item[A_Index-1]
			this.explore.Remove(ll.text)
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
		while,fn:=fz.Item[A_Index-1]{
			things:=SN(fn,"descendant::info"),filename:=SSN(fn,"@file").text
			SplitPath,filename,file
			Default("SysTreeView322"),fn.SetAttribute("cetv",(main:=TV_Add(file,0,"Sort")))
			while,tt:=things.Item[A_Index-1],ea:=xml.ea(tt){
				if(!top:=SSN(fn,"descendant::header[@type='" ea.type "']"))
					if(ea.type~="Method|Property"=0)
						top:=cexml.Under(fn,"header",{type:ea.type,cetv:TV_Add(ea.type,SSN(fn,"@cetv").text,"Sort" (SSN(tt,"ancestor::main[@file='Libraries']")?"":" Vis"))})
				if(ea.type~="(Method|Property)")
					tt.SetAttribute("cetv",TV_Add(ea.text,((tv:=SSN(tt.ParentNode,"@cetv").text)?tv:SSN(top,"@cetv").text),"Sort"))
				else
					last:=tt,tt.SetAttribute("cetv",TV_Add(ea.text,((tv:=SSN(tt.ParentNode,"@cetv").text)?tv:SSN(top,"@cetv").text),(ea.type="Class"?"Sort":"Sort")))
		}}TVC.Enable(2)
		return
	}CEGO(){
		static last
		CEGO:
		if((node:=cexml.SSN("//*[@cetv='" A_EventInfo "']"))&&A_GuiEvent="Normal"){
			GetPos()
			if(!tv:=files.SSN("//*[@id='" SSN(node,"ancestor-or-self::file/@id").text "']/@tv").text)
				return
			tv(tv),SelectText(node)
		}
		return
	}AutoCList(node:=0){
		static list:=[]
		if(node=1){
			all:=cexml.SN("//main")
			while(aa:=all.item[A_Index-1]),mea:=xml.ea(aa){
				obj:=list[mea.file]:=[],CF:=SN(aa,"descendant::*[@type='Class' or @type='Function' or @type='Instance']")
				while(cc:=CF.item[A_Index-1]),ea:=xml.ea(cc){
					if(mea.file="libraries")
						v.keywords[SubStr(ea.text,1,1)].=" " ea.text
					obj.list.=ea.text " "
				}
				obj.list:=Trim(obj.list)
			}
			return
		}if(node){
			parent:=SSN(node,"ancestor-or-self::main/@file").text
			if(!obj:=IsObject(list[parent]))
				obj:=list[parent]:=[]
			obj.list:=[],all:=SN(node.ParentNode,"descendant::*[@type='Class' or @type='Function']")
			while(aa:=all.item[A_Index-1]),ea:=xml.ea(aa)
				obj.list.=ea.text " "
			obj.list:=Trim(obj.list)
			return
		}else{
			return list[Current(2).file].list
}}}
class EasyView{
	Register(Control,hwnd,Label,win:=1){
		WinGetClass,class,ahk_id%hwnd%
		obj:=this.Controls[Control]:=[],obj.Label:=Label,obj.hwnd:=hwnd,obj.type:=InStr(class,"TreeView")?"TreeView":"ListView",this.win:=win
	}Default(Control){
		if(A_DefaultGUI!=this.win)
			Gui,% this.win ":Default"
		Gui,% this.win ":" this.Controls[Control].type,% this.Controls[Control].hwnd
	}Delete(Control,Item:=0){
		this.Default(Control),(this.Controls[Control].type="TreeView")?TV_Delete(item):LV_Delete(item)
	}Add(Control,text,parentopt:=0,options:=""){
		this.Default(Control),this.Controls[Control].type="TreeView"?(value:=TV_Add(text,parentopt,options)):(IsObject(text)?(value:=LV_Add(parentopt,text*)):value:=LV_Add(parentopt,text))
		return value
	}Modify(Control,text:="",Item:="",Options:=""){
		this.Default(Control),this.Controls[Control].type="TreeView"?(text?TV_Modify(Item,Options,text):TV_Modify(Item,Options)):(LV_Modify(Item,Options,(IsObject(text)?text*:text)))
	}Disable(Control){
		this.Default(Control)
		GuiControl,% this.win ":-Redraw",% this.Controls[Control].hwnd
		GuiControl,% this.win ":+g",% this.Controls[Control].hwnd
	}Enable(Control){
		this.Default(Control)
		GuiControl,% this.win ":+Redraw",% this.Controls[Control].hwnd
		GuiControl,% this.win ":+g" this.Controls[Control].Label,% this.Controls[Control].hwnd
	}
}
Class Icon_Browser{
	static start:="",window:=[],keep:=[],newwin,caller
	__New(obj,hwnd,win,pos:="xy",min:=300,Function:="",Reload:=""){
		this.hwnd:=hwnd,this.win:=win,this.min:=min
		if(min)
			obj.Add("Button,xs gloadfile,Load File," pos,"Button,x+M gloaddefault,Default Icons," pos,"Button,x+M gIBWidth,Width," pos)
		Icon_Browser.keep[win]:=this,this.Reload:=Reload=1?Function:Reload,this.Function:=Function,this.file:=settings.Get("//icons/@last","Shell32.dll"),this.start:=0,this.populate()
	}
	things(){
		IBWidth:
		this:=Icon_Browser.keep[A_Gui],min:=settings.Get("//IconBrowser/Win[@win='" this.win "']/@w",this.min)
		InputBox,out,Icon Viewer Width,% "Only Numbers with a minimum of " this.min,,,,,,,,%min%
		if(ErrorLevel)
			return
		if(out~="\D"||out<this.min)
			return m("Invalid value. Must be a NUMBER at least " min)
		if(!node:=settings.SSN("//IconBrowser/Win[@win='" this.win "']"))
			node:=settings.Add("IconBrowser/Win",{win:this.win},,1)
		node.SetAttribute("w",out)
		if(func:=this.reload)
			%func%()
		return
		SelectIcon:
		this:=Icon_Browser.keep[A_Gui]
		if(A_GuiEvent="I"&&ErrorLevel~="S")
			function:=this.function,%function%({file:this.file,icon:A_EventInfo})
		return
		loadfile:
		FileSelectFile,file,,,,*.exe;*.dll;*.png;*.jpg;*.gif;*.bmp;*.icl;*.ico
		if(ErrorLevel)
			return
		this:=icon_browser.keep[A_Gui],this.file:=file,this.start:=0,this.populate(),settings.add("icons",{"last":this.file})
		return
		loaddefault:
		this:=icon_browser.keep[A_Gui],this.file:="Shell32.dll",this.start:=0,this.populate(),settings.add("icons",{"last":this.file})
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
		}
		SendMessage,0x1000+53,0,(47<<16)|(47&0xffff),,% "ahk_id" this.hwnd
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
		if(!node:=this.xml.SSN("//*[@id='" (id:=Current(8)) "']"))
			node:=this.xml.Add("state",{id:id},,1)
		node.SetAttribute("state",state)
	}Delete(start,end){
		add:=start+1=end?0:1,sc:=csc()
		Loop,% end+add-start
			sc.2044(end+2-A_Index,-1)
	}Clear(){
		sc:=csc(),node:=this.xml.SSN("//*[@id='" Current(8) "']").SetAttribute("state",0),next:=0
		while((next:=sc.2047(next,2**20+2**21))>=0)
			this.RemoveStatus(next)
		node.ParentNode.RemoveChild(node)
	}Save(id){
		this.XML.SSN("//*[@id='" id "']").SetAttribute("state",1)
	}tv(){
		sc:=csc(),state:=SSN(node:=this.xml.SSN("//*[@id='" Current(8) "']"),"@state").text
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
	__New(win:=1){
		;obj:=new MainWindowClass() for AHK Studio
		MainWindowClass.keep[win]:=this
		this.GUI:=new XML("GUI","lib\GUI.xml")
		if(!this.GUI.SSN("//control"))
			this.GUI.xml.LoadXML("<GUI><win win=""1"" pos=""xcenter ycenter w800 h508""><control hwnd=""11"" type=""Scintilla"" h=""464"" w=""700"" x=""0"" y=""0"" file=""" A_ScriptFullPath """ ra=""2"" last=""11""></control><control hwnd=""2"" type=""Project Explorer"" h=""206"" w=""190"" x=""879"" y=""0"" ba=""3"" lp=""0.75""></control><control hwnd=""3"" type=""Code Explorer"" h=""258"" w=""190"" x=""879"" y=""206"" lp=""0.75"" tp=""0.5""></control></win></GUI>")
		;this.GUI.xml.LoadXML("<GUI><win win=""1"" pos=""xcenter ycenter w800 h508""><control hwnd=""1508692"" type=""Scintilla"" h=""454"" w=""592"" x=""0"" y=""0"" file=""" A_ScriptFullPath """ ra=""3868102"" ba=""2491774""></control><control hwnd=""2491774"" type=""Console"" h=""10"" w=""800"" x=""0"" y=""454"" tp=""0.980562""></control><control hwnd=""2032152"" type=""Project Explorer"" h=""232"" w=""208"" x=""592"" y=""0"" ba=""3868102"" lp=""0.74""></control><control hwnd=""3868102"" type=""Code Explorer"" h=""222"" w=""208"" x=""592"" y=""232"" ba=""2491774"" lp=""0.74"" tp=""0.50108""></control></win></GUI>")
		/*
			This will need to be an external thing... possibly a static outside :)
		*/
		OnMessage(0xA0,MainWindowClass.ChangePointer),OnMessage(0x232,MainWindowClass.Fix),OnMessage(0xA1,MainWindowClass.Resize),OnMessage(0x0211,MainWindowClass.EnterOff),OnMessage(0x0212,MainWindowClass.EnterOn),OnMessage(6,"Focus")
		MainWin:=this,this.Hidden:=[]
		if(!this.GUI.SSN("//win[@win=1]"))
			this.GUI.Add("win",{win:1},,1)
		for a,b in {border:32,caption:4,menu:15}
			MainWindowClass[a]:=this[a]:=DllCall("GetSystemMetrics",int,b),v[a]:=MainWindowClass[a]
		v.qfh:=23
		for a,b in {all:32646,ns:32645,ew:32644}
			this["curs" a]:=DllCall("LoadCursor",int,0,int,b,uptr)
		GUI,%win%:Default
		if(v.Options.Hide_Tray_Icon)
			Menu,Tray,NoIcon
		else if(FileExist(A_ScriptDir "\AHKStudio.ico"))
			Menu,Tray,Icon,%A_ScriptDir%\AHKStudio.ico
		for a,b in ["tl","br","locator"]
			GUI,Add,Text,x0 y0 w0 h0 hwnd%b%,%b%
		this.locator:=locator,this.StatusHeight:=0,this.TLhwnd:=tl,this.BRhwnd:=br,this.TL:={x:0,y:v.Options.Top_Find?21:0},this.BR:={x:0,y:v.Options.Top_Find?0:21}
		GUI,+Resize +LabelMainWindowClass. +hwndmain +MinSize400x200 -DPIScale
		this.win:=win,this.hwnd:=main,this.id:="ahk_id"main
		GUI,1:Default
		return this
	}Add(hwnd,type){
		return this.GUI.Under(this.GUI.SSN("//win[@win='" this.win "']"),"control",{hwnd:hwnd,type:type})
	}ChangePointer(a,b:="",c:=""){
		obj:=MainWindowClass.keep[1]
		if((this=18||a="Update")&&!obj.mousedown){
			m:=obj.MousePos(),x:=m.x,y:=m.y
			if(x<5||y<5)
				return obj.list:=""
			if(found:=obj.GUI.SSN("//*[@type='Quick Find' and @y+4>=" y " and @y+-4<=" y "]"))
				return obj.list:=""
			if((list:=obj.GUI.SN("//win[@win='Tracked_Notes']/descendant::*[(@x+-4<='" x "' and @x+@w+4>='" x "')and(@y+-4<='" y "' and @y+@h+4>='" y "')]")).length>1)
				obj.list:=list,obj.ResizeType:=2
			else if((list:=obj.GUI.SN("//win[@win=1]/descendant::*[(@x+-4<='" x "' and @x+@w+4>='" x "')and(@y+-4<='" y "' and @y+@h+4>='" y "')]")).length>1)
				obj.list:=list,obj.ResizeType:=1
			if(obj.ResizeType=1){
				if((list:=obj.GUI.SN("//*[@win=1]descendant::control[(@x+-10<='" x "' and @x+@w+10>='" x "')and(@y+-10<='" y "' and @y+@h+10>='" y "')]")).length>1)
					left:=obj.GUI.SSN("//win[@win='1']/descendant::control[@x+-10<='" x "' and @x+10>='" x "']").xml,top:=obj.GUI.SSN("//win[@win='1']/descendant::control[@y+-10<='" y "' and @y+10>='" y "']").xml
				DllCall("SetCursor","UInt",list.length>2?obj.cursall:top?obj.cursns:obj.cursew)
			}else if(obj.ResizeType=2){
				DllCall("SetCursor","UInt",(obj.GUI.SSN("//control[@vertical]")?obj.cursns:obj.cursew))
		}}else
			obj.list:="",obj.place:=this
	}Client(){
		ControlGetPos,x,y,,,,% "ahk_id" this.locator
		return {x:x,y:y}
		SetTimer,Redraw,-200
	}Close(){
		Exit()
	}ContextMenu(a*){
		if(A_Gui=1)
			this:=obj:=MainWindowClass.keep[A_Gui],m:=this.MousePos(),this.NewCtrlPos:=m,ContextMenu()
		else
			m("Add a menu here")
	}DebugWindow(){
		if(type="Debug"&&this.Gui.SSN("//win[@win=1]/descendant::*[@type='Debug']"))
			return
		sc:=csc()
		if(sc.sc=TNotes.sc.sc)
			sc:=csc(2)
		ControlGetPos,x,y,w,h,,% "ahk_id" sc.sc
		this.NewCtrlPos:=[],this.NewCtrlPos.y:=Round((y+h)*.75),this.NewCtrlPos.ctrl:=sc.sc,this.Split("Below","Debug")
	}Delete(){ ;xx:=new XML() here for Studio
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
		oea:=xml.EA(onode),nope:=1,top:="win[@win='1']/descendant::"
		if(xx.SN("//" top "*[@type='Scintilla']").length=1&&oea.type="Scintilla")
			return t("Can not delete the last Control","time:1")
		if(xx.SSN("//" top "*[@x=" oea.x+oea.w " and @y=" oea.y "]")&&xx.SSN("//" top "*[@x=" oea.x+oea.w " and @y+@h=" oea.y+oea.h "]")){
			list:=xx.SN("//" top "*[@x=" oea.x+oea.w " and ((@y=" oea.y ")or(@y>" oea.y " and @y+@h<" oea.y+oea.h ")or(@y+@h=" oea.y+oea.h "))]")
			while(ll:=list.item[A_Index-1]),ea:=xml.EA(ll)
				ll.SetAttribute("x",oea.x),ll.SetAttribute("w",oea.w+ea.w),nope:=0,this.SetWinPos(xml.EA(ll))
		}else if(xx.SSN("//" top "*[@x+@w=" oea.x " and @y=" oea.y "]")&&xx.SSN("//" top "*[@x+@w=" oea.x " and @y+@h=" oea.y+oea.h "]")){
			list:=xx.SN("//" top "*[@x+@w=" oea.x " and ((@y=" oea.y ")or(@y>" oea.y " and @y+@h<" oea.y+oea.h ")or(@y+@h=" oea.y+oea.h "))]")
			while(ll:=list.item[A_Index-1]),ea:=xml.EA(ll)
				ll.SetAttribute("w",oea.w+ea.w),nope:=0,this.SetWinPos(xml.EA(ll))
		}else if(xx.SSN("//" top "*[@y+@h=" oea.y " and @x=" oea.x "]")&&xx.SSN("//" top "*[@y+@h=" oea.y " and @x+@w=" oea.x+oea.w "]")){
			list:=xx.SN("//" top "*[@y+@h=" oea.y " and ((@x=" oea.x ")or(@x>" oea.x " and @x+@w<" oea.x+oea.w ")or(@x+@w=" oea.x+oea.w "))]")
			while(ll:=list.item[A_Index-1]),ea:=xml.EA(ll)
				ll.SetAttribute("h",oea.h+ea.h),nope:=0,this.SetWinPos(xml.EA(ll))
		}else if(xx.SSN("//" top "*[@y=" oea.y+oea.h " and @x=" oea.x "]")&&xx.SSN("//" top "*[@y=" oea.y+oea.h " and @x+@w=" oea.x+oea.w "]")){
			list:=xx.SN("//" top "*[@y=" oea.y+oea.h " and ((@x=" oea.x ")or(@x>" oea.x " and @x+@w<" oea.x+oea.w ")or(@x+@w=" oea.x+oea.w "))]")
			while(ll:=list.item[A_Index-1]),ea:=xml.EA(ll)
				ll.SetAttribute("y",oea.y),ll.SetAttribute("h",oea.h+ea.h),nope:=0,this.SetWinPos(xml.EA(ll))
		}if(!nope){
			onode.ParentNode.RemoveChild(onode),this.Fix()
			if(oea.type~="Project Explorer|Code Explorer")
				this.SetWinPos(oea.hwnd,0,0,0,0,ea)
			else if(oea.type~="Scintilla|Debug"){
				s.Hidden.push(oea.hwnd):=1,this.SetWinPos(oea.hwnd,0,0,0,0)
				if(oea.type="Debug"){
					v.debug:=""
					debug.Send("stop")
			}}else if(oea.type="Tracked Notes")
				this.SetWinPos(oea.scintilla,0,0,0,0,ea),this.SetWinPos(oea.TreeView,0,0,0,0,ea),Redraw()
			else
				DllCall("DestroyWindow",uptr,oea.hwnd)
			if(oea.type="Tracked Notes")
				rem:=this.GUI.SSN("//win[@win='Tracked_Notes']"),rem.ParentNode.RemoveChild(rem)
		}else
			m("Please report this, Include a screenshot and where your mouse was at the time")
		Redraw()
		SetTimer,FocusMain,-300
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
	}Fix(){
		Sleep,200
		if(!this.hwnd)
			this:=MainWindowClass.keep[A_Gui]
		top:=this.TopY,controls:=this.GUI.SN("//win[@win='1']/descendant::control"),win:=this.WinPos(this.hwnd,1),this.Pos(),add:=v.Options.Top_Find?21:0
		while(cc:=controls.item[A_Index-1])
			for a,b in ["rx","ry","lp","tp","ba","ra"]
				cc.RemoveAttribute(b)
		while(cc:=controls.item[A_Index-1]),ea:=xml.EA(cc){
			cc.RemoveAttribute("ra"),cc.RemoveAttribute("ba")
			if((right:=this.GUI.SN("//win[@win='1']/descendant::control[@x>=" ea.x+ea.w " and ((@y=" ea.y ") or (@y+@h=" ea.y+ea.h ") or (@y>" ea.y " and @y<" ea.y+ea.h ") or (@y+@h>" ea.y " and @y+@h<=" ea.y+ea.h ") or (@y<=" ea.y " and @y+@h>=" ea.y "))]")).length),min:=[]{
				while(rr:=right.item[A_Index-1]),nea:=xml.EA(rr)
					min[nea.x]:=nea.hwnd
				cc.SetAttribute("ra",min[min.MinIndex()])
			}if((below:=this.GUI.SN("//win[@win='1']/descendant::control[@y>='" ea.y+ea.h "' and ((@x=" ea.x ")or(@x+@w=" ea.x+ea.w ")or(@x+@w>" ea.x " and @x+@w<" ea.x+ea.w ")or(@x>" ea.x " and @x<=" ea.x+ea.w ")or(@x<" ea.x " and @x+@w>" ea.x+ea.w "))]")).length),min:=[]{
				while(bb:=below.item[A_Index-1]),nea:=xml.EA(bb)
					min[nea.y]:=nea.hwnd
				cc.SetAttribute("ba",min[min.MinIndex()])
			}if(ea.x){
				nlp:=Round(ea.x/win.w,6)
				cc.SetAttribute("lp",nlp>1?.9:nlp)
			}if(ea.y){
				ntp:=Round((ea.y)/(this.height),6)
				cc.SetAttribute("tp",ntp>1?.9:ntp)
		}}this.mousedown:=0
		WinGet,mm,MinMax,% MainWin.ID
		if(A_Gui=1&&mm=0) ;DisplayStats(A_ThisFunc)
			this.Pos()
		return
	}MousePos(){
		global
		MouseGetPos,x,y,win,Control,2
		ControlGetPos,xx,yy,,,,% "ahk_id" this.TLhwnd
		if(this.GUI.SSN("//*[@hwnd='" Control "']/ancestor::win/@win").text="Tracked_Notes")
			Control:=this.GUI.SSN("//win[@win='" this.win "']/descendant::*[@type='Tracked Notes']/@hwnd").text
		return {x:x-xx,y:y-yy,win:win,ctrl:Control+0}
	}Pos(){
		top:=this.TopY,all:=this.GUI.SN("//control")
		while(aa:=all.item[A_Index-1]),ea:=xml.EA(aa){
			if(ea.type="Tracked Notes"){
				tvp:=this.WinPos(ea.TreeView)
				scp:=this.WinPos(ea.Scintilla)
				width:=(ea.vertical?tvp.w:tvp.w+scp.w),height:=(ea.vertical?tvp.h+scp.h:tvp.h)
				for a,b in {x:tvp.x,y:tvp.y,w:width,h:height}
					aa.SetAttribute(a,b)
				
			}else{
				Pos:=this.WinPos(ea.hwnd)
				for a,b in {x:pos.x,y:pos.y-Round(top),w:pos.w,h:pos.h}
					aa.SetAttribute(a,b)
			}
	}}QuickFind(){
		GUI,Quick_Find:Default
		GUI,+parent1 -Caption -Border hwndhwnd -DPIScale
		GUI,Margin,0,0
		ea:=settings.EA("//fonts/font[@style=5]")
		GUI,Color,% RGB(ea.Background),% RGB(ea.Background)
		GUI,Font,% "c" RGB(ea.color)
		GUI,Add,Text,x3 y4,Quick Find:
		GUI,Add,Edit,x+5 y0 hwndqf gqf
		for a,b in ["Regex","Case Sensitive","Greed","Multi-Line","Require Enter For Search"]{
			GUI,Add,Checkbox,% "x+M hwndregex gRegexSettings hwndcontrol " (A_Index=1?"y4 x+5":"") (settings.SSN("//options/@" Clean(RegExReplace(b,"-","_"))).text?" Checked":""),%b%
			v.qfhwnd[RegExReplace(b,"\W","_")]:=control
		}
		GUI,Quick_Find:Show,x0 y356
		SetTimer,Redraw,-200
		GUI,1:Default
		SetTimer,Redraw,-200
		this.QF:=hwnd
	}Rebuild(list){
		while(ll:=list.item[A_Index-1]),ea:=xml.EA(ll){
			if(ea.type="scintilla"){
				sc:=new s(1,{pos:"x" ea.x " y" ea.y " w" ea.w " h" ea.h}),hwnd:=sc.sc,sc.2277(v.Options.End_Document_At_Last_Line) ;,sc.2402(0x08|0x04,40)
				if(ea.file){
					if(tv:=SSN(files.find("//file/@file",ea.file),"@tv").text)
						tv(tv,{sc:sc.sc})
					else
						tv(files.SSN("//main/descendant::*/@tv").text,{sc:sc.sc})
				}
			}else if(ea.type="ToolBar")
				tb:=new ToolBar(1,"x" ea.x " y" ea.y " w" ea.w " h" ea.h,ea.id,ll),ll.SetAttribute("win",tb.win),hwnd:=tb.hwnd,ll.SetAttribute("toolbar",tb.tb)
			else if(ea.type="Project Explorer")
				hwnd:=this.pe
			else if(ea.type="Code Explorer")
				hwnd:=this.ce
			else if(ea.type="Tracked Notes"){
				Tracked_Notes(ll),hwnd:=this.tn
			}else if(ea.type="Debug"){
				sc:=new s(1,{pos:"x" ea.x " y" ea.y " w" ea.w " h" ea.h}),hwnd:=sc.sc,v.debug:=sc
				Loop,4
					sc.2242(A_Index-1,0)
				sc.2403(0x08,0)
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
	}Resize(a,b,c){
		if(this=7||this=8)
			return
		obj:=MainWindowClass.keep[1],mouse:=obj.MousePos(),x:=mouse.x,y:=mouse.y,win:=obj.WinPos(obj.hwnd,1),search:="",obj.mousedown:=1,list:=obj.list
		if(x<5||y<5)
			return
		if(obj.ResizeType=1){
			while(ll:=list.item[A_Index-1]),ea:=xml.EA(ll){
				if(ea.x-4<=x&&ea.x+4>=x)
					search.=" @x='" ea.x "' or @x+@w='" ea.x "' or"
				if(ea.y-4<=y&&ea.y+4>=y)
					search.=" @y='" ea.y "' or @y+@h='" ea.y "' or"
			}
			if(!search)
				return
			list:=obj.GUI.SN("//win[@win=1]/descendant::control[" Trim(search," or") "]")
			while(ll:=list.item[A_Index-1]),ea:=xml.EA(ll){
				if(ea.x-4<=x&&ea.x+4>=x)
					ll.SetAttribute("rx",1)
				if(ea.y-4<=y&&ea.y+4>=y)
					ll.SetAttribute("ry",1)
			}top:=this.TopY
			bounds:=[]
			for a,b in {left:obj.bounds.t.x,top:obj.bounds.t.y,right:obj.bounds.b.x,bottom:obj.bounds.b.y}
				bounds[a]:=b
			while(GetKeyState("LButton")){
				m:=obj.MousePos(),move:=[]
				if(lastx=m.x&&lasty=m.y)
					Continue
				if(m.x<bounds.left+10||m.y<bounds.top+10||m.x>bounds.right-10||m.y>bounds.bottom-10)
					goto,ResizeBottom
				while(ll:=list.item[A_Index-1]),ea:=xml.EA(ll){
					/*
						here is where all the lock stuff is going to go....not looking forward to that...
					*/
					if(ea.rx){
						if(right:=obj.GUI.ea("//control[@hwnd='" ea.ra "']").x)
							if(right-5<m.x)
								goto,ResizeBottom
						if(left:=obj.GUI.ea("//control[@ra='" ea.hwnd "']").x)
							if(left+5>m.x)
								goto,ResizeBottom
						move[ll,"x"]:=m.x
					}if(ea.ry){
						if(below:=obj.GUI.ea("//control[@hwnd='" ea.ba "']").y){
							if(below-5<m.y)
								goto,ResizeBottom
						}
						if(above:=obj.GUI.ea("//control[@ba='" ea.hwnd "']").y)
							if(above+5>m.y)
								goto,ResizeBottom
						move[ll,"y"]:=m.y
				}}for a,b in move
					for c,d in b
						a.SetAttribute(c,d)
				ResizeBottom:
				obj.Size([obj.win]),lastx:=m.x,lasty:=m.y
			}obj.Fix(),obj.ChangePointer("Update"),Redraw()
		}else if(obj.ResizeType=2){
			pea:=xml.EA(node:=obj.GUI.SSN("//*[@type='Tracked Notes']")),posadj:=pea.vertical?["y","h"]:["x","w"]
			while(GetKeyState("LButton")){
				m:=obj.MousePos()
				while(ll:=list.item[A_Index-1]),ea:=xml.EA(ll){
					pct:=Round((m[posadj.1]-pea[posadj.1])/pea[posadj.2],6)
					if(pct>0.1&&pct<.9&&lastpct!=pct)
						node.SetAttribute("split",pct),obj.Size([obj.win])
					lastpct:=pct
			}}obj.Pos(),obj.mousedown:=0,obj.list:="",obj.ChangePointer("Update"),Redraw()
	}}SetWinPos(ctrl,x:=0,y:=0,w:=0,h:=0,ea:=0){
		static last:=[]
		if(IsObject(ctrl))
			x:=ctrl.x,y:=ctrl.y,w:=ctrl.w,h:=ctrl.h,ea:=ctrl,ctrl:=ctrl.hwnd
		if(ea.type="Tracked Notes"){
			split:=ea.split?ea.split:.2
			if(ea.vertical)
				DllCall("SetWindowPos",ptr,ea.TreeView,int,0,int,x,int,y,int,w,int,(height:=Round(h*split)),uint,0x0004|0x0010|0x0020),DllCall("SetWindowPos",ptr,ea.scintilla,int,0,int,x,int,y+height,int,w,int,h-height,uint,0x0008|0x0004|0x0010|0x0020)
			else
				DllCall("SetWindowPos",ptr,ea.TreeView,int,0,int,x,int,y,int,(width:=Round(w*split)),int,h,uint,0x0004|0x0010|0x0020),DllCall("SetWindowPos",ptr,ea.Scintilla,int,0,int,x+width,int,y,int,w-width,int,h,uint,0x0008|0x0004|0x0010|0x0020)
			DllCall("RedrawWindow",int,ea.TreeView,int,0,int,0,uint,0x401|0x2),DllCall("RedrawWindow",int,ea.Scintilla,int,0,int,0,uint,0x401|0x2)
			return
		}
		if(last[ctrl].x=x&&last[ctrl].y=y&&last[ctrl].w=w&&last[ctrl].h=h&&ea.type!="Tracked Notes")
			return
		DllCall("SetWindowPos",int,ctrl,int,0,int,x,int,y,int,w,int,h,uint,(ea.type~="Project Explorer|Code Explorer|QF")?0x0004|0x0010|0x0020:0x0008|0x0004|0x0010|0x0020),DllCall("RedrawWindow",int,ctrl,int,0,int,0,uint,0x401|0x2)
		if(ea.type="ToolBar")
			DllCall("SetWindowPos",int,ea.ToolBar,int,0,int,0,int,0,int,w,int,h,uint,0x0008|0x0004|0x0010|0x0020)
		last[ctrl]:={x:x,y:y,w:w,h:h}
	}Size(a,w="",h=""){
		static width,height
		if(!IsObject(this))
			SetTimer,Redraw,-200
		this:=MainWindowClass.keep[1]
		if(!this)
			this:=MainWindowClass.keep[1]
		(w)?(width:=w,h:=height:=h-this.statusheight):(w:=width,h:=height),this.SetWinPos(this.TLhwnd,0,this.tl.y,0,0,""),this.SetWinPos(this.BRhwnd,w-1,h-1-this.br.y,0,0,""),this.height:=h-1-this.br.y-this.tl.y,pos:=[],controls:=this.GUI.SN("//win[@win=1]/descendant::control")
		for c,d in {t:this.TLhwnd,b:this.BRhwnd}
			cp:=this.WinPos(d),pos[c]:={x:cp.x+(c="t"?0:0),y:cp.y+(c="t"?0:1)},this.Bounds[c]:=pos[c]
		this.TopY:=pos.t.y
		if(!IsObject(a)||a.1="Resize"){
			while(cc:=controls.item[A_Index-1]),ea:=xml.EA(cc){
				if(ea.lp)
					cc.SetAttribute("x",Round(ea.lp*w))
				if(ea.tp)
					cc.SetAttribute("y",Round(ea.tp*this.height))
			}while(cc:=controls.item[A_Index-1]),ea:=xml.EA(cc)
				this.SetWinPos(ea.hwnd,ea.x,ea.y+pos.t.y,(neww:=(xx:=this.GUI.SSN("//control[@hwnd='" ea.ra "']/@x").text)?xx-ea.x:w-ea.x),(nh:=(yy:=this.GUI.SSN("//control[@hwnd='" ea.ba "']/@y").text)?yy-ea.y:h-ea.y-this.statusheight+2),ea),cc.SetAttribute("w",neww),cc.SetAttribute("h",nh)
		}else{
			h-=this.statusheight
			while(cc:=controls.item[A_Index-1]),ea:=xml.EA(cc)
				this.SetWinPos(ea.hwnd,ea.x,ea.y+pos.t.y,((xx:=this.GUI.SSN("//control[@hwnd='" ea.ra "']/@x").text)?xx-ea.x:w-ea.x),((yy:=this.GUI.SSN("//control[@hwnd='" ea.ba "']/@y").text)?yy-ea.y:h-ea.y+2),ea)
		}if(a=0||a=2){
			this.mousedown:=0
		}if(this.place=9)
			Redraw()
		this.SetWinPos(this.QF,pos.t.x,(v.Options.Top_Find?0:pos.b.y),pos.b.x,21,{type:"QF"}),w:=pos.b.x,h:=(v.Options.top_find?pos.b.y:pos.b.y+21)+2
	}Split(direction:=0,type:="Scintilla"){
		space:=[],np:=this.NewCtrlPos,hwnd:=np.ctrl,add:=v.Options.Top_Find?21:0
		if(!node:=this.GUI.SSN("//*[@hwnd='" hwnd "']"))
			if(!node:=this.GUI.SSN("//*[@hwnd='" hwnd+0 "']"))
				return m("Something went Terribly wrong.")
		ea:=xml.EA(node),npos:=this.WinPos(ea.hwnd),x-=this.Border+npos.x
		if(direction="Above")
			this.SetWinPos(hwnd,ea.x,np.y+add,ea.w,ea.h-(np.y-ea.y),ea),space:={x:ea.x,y:ea.y+add,w:ea.w,h:np.y-ea.y}
		if(direction="Below")
			this.SetWinPos(hwnd,ea.x,ea.y+add,ea.w,np.y-ea.y,ea),space:={x:ea.x,y:np.y+add,w:ea.w,h:ea.h-(np.y-ea.y)}
		if(direction="Left")
			this.SetWinPos(hwnd,np.x,ea.y+add,ea.w-(np.x-ea.x),ea.h,ea),space:={x:ea.x,y:ea.y+add,w:np.x-ea.x,h:ea.h}
		if(direction="Right")
			this.SetWinPos(hwnd,ea.x,ea.y+add,np.x-ea.x,ea.h,ea),space:={x:np.x,y:ea.y+add,w:ea.w-(np.x-ea.x),h:ea.h}
		if(type~="i)(Scintilla|Debug)"){
			sc:=new s(1,{pos:"x" space.x " y" space.y " w" space.w " h" space.h}),Redraw()
			node:=this.Add(sc.sc,type),Color(sc),sc.2277(v.Options.End_Document_At_Last_Line)
			for a,b in space
				node.SetAttribute(a,b)
			if(type="Debug"){
				Loop,4
					sc.2242(A_Index-1,0)
				v.debug:=sc,sc.2403(0x08,0)
			}
		}
		this.NewCtrlPos:="",this.mousedown:=0,this.Update(),this.Fix(),this.ChangePointer("Update")
		WinSet,Redraw,,% MainWin.id
	}Theme(){
		if(node:=settings.SSN("//fonts/custom[@GUI='1' and @control='msctls_statusbar321']"))
			SetStatus(node)
		else
			SetStatus(settings.SSN("//fonts/font[@style='5']"))
		ea:=settings.ea("//fonts/descendant::*[@style=5]")
		WinGet,cl,ControlList,% this.ID
		GUI,Font,% "c" RGB(ea.color),% ea.font
		node:=settings.SSN("//fonts/font[@style='5']"),dea:=xml.EA(node),all:=this.GUI.SN("//control[not(@type='Scintilla')]"),wins:=[]
		while(aa:=all.item[A_Index-1]),ea:=xml.EA(aa){
			win:=SSN(aa,"ancestor::win/@win").text
			GUI,%win%:Default
			if(!wins[win]){
				wins[win]:=1
				GUI,%win%:Color,% RGB(dea.Background),% RGB(dea.Background)
			}
			GUI,font,% CompileFont(node),% ea.font
			GuiControl,% win ":+background" RGB(dea.Background) " c" rgb(dea.color),% ea.hwnd
			GuiControl,%win%:font,% ea.hwnd
			GUI,%win%:Color,% RGB(ea.Background),% RGB(ea.Background)
		}
		custom:=settings.SN("//fonts/custom")
		while(node:=custom.item[A_Index-1]),ea:=xml.EA(node){
			text:=CompileFont(node)
			ControlGet,hwnd,hwnd,,% ea.control,% MainWin.ID
			GUI,% ea.GUI ":font",%text%,% ea.font
			GuiControl,% ea.GUI ":font",%hwnd%
			GUI,% ea.GUI ":font"
	}}Type(new,id:=0){
		static NewHwnd,hwnd,newtype
		np:=this.NewCtrlPos,hwnd:=np.ctrl
		if(!node:=this.GUI.SSN("//*[@hwnd='" hwnd "']")){
			hwnd+=0
			if(!node:=this.GUI.SSN("//*[@hwnd='" hwnd "']"))
				return m("Sorry, something went really wrong.")
		}win:=this.WinPos(hwnd),ea:=xml.EA(node)
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
		if(new="scintilla"){
			if(NewHwnd:=this.Hidden.pop()){
				SetFormat,integer,H
				NewHwnd+=0
				SetFormat,Integer,D
			}else
				sc:=new s(1,{pos:"x" ea.x " y" ea.y " w" ea.w " h" ea.h}),NewHwnd:=sc.sc,Color(sc)
			for a,b in this.Hidden
				m("remaining Scintilla Controls: " a)
		}if(new="ToolBar")
			tb:=new ToolBar(1,"x" ea.x " y" ea.y " w" ea.w " h" ea.h,id,node),NewHwnd:=tb.hwnd,node.SetAttribute("toolbar",tb.tb),node.SetAttribute("win",tb.WindowName)
		if(new="Tracked Notes")
			Tracked_Notes(node),ea:=xml.EA(node),NewHwnd:=ea.hwnd
		node.SetAttribute("type",new)
		all:=this.GUI.SN("//@node()[.='" hwnd "']")
		while(aa:=all.item[A_Index-1]),ea:=xml.EA(aa)
			aa.text:=NewHwnd
		this.Size([1]),this.Updatnode:=this.GUI.SSN("//win[@win='" A_Gui "']").SetAttribute("pos",win.text),this.NewCtrlPos:="",this.Size(1),Redraw(),this.Fix()
		if(new~="Project Explorer|Code Explorer")
			RefreshThemes()
		;DisplayStats(A_ThisFunc)
		return
	}Update(){
		all:=this.GUI.SN("//win[@win='1']/descendant::control"),adjust:=this.Client()
		while(aa:=all.item[A_Index-1]),ea:=xml.EA(aa){
			ControlGetPos,x,y,w,h,,% "ahk_id" ea.hwnd
			for a,b in {x:x-=adjust.x,y:y-adjust.y,w:w,h:h}
				aa.SetAttribute(a,b)
	}}WinPos(hwnd,win:=0){
		VarSetCapacity(rect,16)
		if(win){
			WinGetPos,x,y,,,ahk_id%hwnd%
			DllCall("GetClientRect",ptr,hwnd,ptr,&rect),w:=NumGet(rect,8,"Int"),h:=NumGet(rect,12,"Int")
		}else{
			ControlGetPos,x,y,,,,ahk_id%hwnd%
			DllCall("GetWindowRect",ptr,hwnd,ptr,&rect),x:=x-this.Border,offset:=this.Client(),y:=y-offset.y,w:=NumGet(rect,8,"Int")-NumGet(rect,0,"Int"),h:=NumGet(rect,12,"Int")-NumGet(rect,4,"Int")
		}text:=(x!=""&&y!=""&&w!=""&&h!="")?"x" x " y" y " w" w " h" h:""
		return {x:x,y:y,w:w,h:h,text:text}
}}
Class Omni_Search_Class{
	static prefix:={"@":"Menu","^":"File",":":"Label","(":"Function","{":"Class","[":"Method","&":"Hotkey","+":"Function","#":"Bookmark",".":"Property","<":"Instance","*":"Breakpoint",">":"Gui",")":"Clipboard"} ;,"%":"Variable"
	static iprefix:={Menu:"@",File:"^",Label:":",Function:"(",Class:"{",Method:"[",Hotkey:"&",Bookmark:"#",Property:".",Variable:"%",Instance:"<",Breakpoint:"*",Gui:">",Clipboard:")"}
	__New(){
		this.menus()
		return this
	}Menus(){
		rem:=cexml.SSN("//menu"),rem.ParentNode.RemoveChild(rem),this.menulist:=[],list:=menus.SN("//menu"),top:=cexml.Add("menu")
		while,mm:=list.item[A_Index-1],ea:=xml.ea(mm){
			clean:=ea.clean,hotkey:=Convert_Hotkey(ea.hotkey)
			StringReplace,clean,clean,_,%A_Space%,All
			launch:=IsFunc(ea.clean)?"func":IsLabel(ea.clean)?"label":v.Options.HasKey(ea.clean)?"option":""
			if(launch=""&&ea.plugin=""&&!v.Options.HasKey(ea.clean))
				Continue
			cexml.Under(top,"item",{launch:launch?launch:ea.plugin,text:clean,type:"Menu",sort:clean,additional1:hotkey,order:"text,type,additional1",clean:ea.clean})
}}}
Class PluginClass{
	__New(){
		return this
	}File(){
		return A_ScriptFullPath
	}Path(){
		return A_ScriptDir
	}SetTimer(timer,period:=-10){
		if(!IsFunc(timer)&&!IsLabel(timer))
			return
		period:=period>0?-period:period
		SetTimer,%timer%,%period%
	}
	AutoClose(script){
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
	}Update(filename,text){
		Update({file:filename,text:text})
	}Show(){
		sc:=csc()
		WinActivate(hwnd([1]))
		GuiControl,+Redraw,% sc.sc
		SetPos(sc.2357),sc.2400
	}Style(){
		return ea:=settings.ea(settings.SSN("//fonts/font[@style='5']")),ea.color:=RGB(ea.color),ea.Background:=RGB(ea.Background)
	}TrayTip(info){
		TrayTip,AHK Studio,%info%,2
	}csc(obj,hwnd){
		csc({plugin:obj,hwnd:hwnd})
	}MoveStudio(){
		Version:="1.003.2"
		SplitPath,A_ScriptFullPath,,,,name
		FileMove,%A_ScriptFullPath%,%name%-%version%.ahk,1
	}Version(){
		Version:="1.003.2"
		return version
	}EnableSC(x:=0){
		sc:=csc()
		if(x){
			GuiControl,1:+Redraw,% sc.sc
			GuiControl,1:+gnotify,% sc.sc
		}else{
			GuiControl,1:-Redraw,% sc.sc
			GuiControl,1:+g,% sc.sc
	}}Publish(info:=0){
		return,Publish(info)
	}Hotkey(win:=1,key:="",label:="",on:=1){
		if(!(win,key,label))
			return m("Unable to set hotkey")
		Hotkey,IfWinActive,% hwnd([win])
		Hotkey,%key%,%label%,% _:=on?"On":"Off"
	}Save(){
		Save()
	}sc(){
		return csc()
	}hwnd(win:=1){
		return hwnd(win)
	}Get(name){
		return _:=%name%
	}tv(tv){
		return tv(tv)
	}Current(x:=""){
		return current(x)
	}m(info*){
		m(info*)
	}AllCtrl(code,lp,wp){
		for a,b in s.ctrl
			b[code](lp,wp)
	}DynaRun(script){
		return DynaRun(script)
	}Activate(){
		WinActivate(hwnd([1]))
	}Call(info*){
		;this can cause major errors
		if(IsFunc(info.1)&&info.1~="i)(Fix_Indent|newindent)"=0){
			func:=info.1,info.Remove(1)
			return %func%(info*)
		}
		SetTimer,% info.1,-100
	}Plugin(action,hwnd){
		SetTimer,%action%,-10
	}Open(info){
		tv:=open(info),tv(tv)
		WinActivate(hwnd([1]))
	}GuiControl(info*){
		GuiControl,% info.1,% info.2,% info.3
	}SSN(node,path){
		return node.SelectSingleNode(path)
	}__Call(x*){
		m(x)
	}StudioPath(){
		return A_ScriptFullPath
	}Files(){
		return update("get").1
	}SetText(contents){
		length:=VarSetCapacity(text,strput(contents,"utf-8")),StrPut(contents,&text,length,"utf-8"),csc().2181(0,&text)
	}ReplaceSelected(text){
		Encode(text,return),csc().2170(0,&return)
	}CallTip(text){
		sc:=csc(),sc.2200(sc.2128(sc.2166(sc.2008)),text)
	}InsertText(text){
		Encode(text,return),sc:=csc(),sc.2003(sc.2008,&return)
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
		mask:=0x10000000|0x400000|0x40000000
		Gui,%win%:Add,custom,%pos% classScintilla +%mask% hwndsc gnotify ;g%notify% ; +1387331584
		for a,b in {fn:2184,ptr:2185}
			this[a]:=DllCall("SendMessageA",UInt,sc,int,b,int,0,int,0)
		this.parent:=sc,this.sc:=sc+0,s.ctrl[sc]:=this
		for a,b in [[2563,1],[2565,1],[2614,1],[2124,1]]
			this[b.1](b.2,b.3?b.3:0)
		this.2403(15,20)
		if(info.main)
			s.main.push(this)
		if(info.temp)
			s.temp.push(this)
		this.2246(2,1),this.2052(32,0),this.2051(32,0xaaaaaa),this.2050,this.2052(33,0x222222),this.2069(0xAAAAAA),this.2601(0xaa88aa),this.2563(1),this.2614(1),this.2565(1),this.2660(1),this.2036(width:=settings.SSN("//tab").text?settings.SSN("//tab").text:5),this.2124(1),this.2260(1),this.2122(5),this.2056(38,"Consolas"),this.2516(1),this.2663(5),this.2277(v.Options.End_Document_At_Last_Line),Color(this),this.2402(0x04|0x01,140),this.2403(0x04|0x01,40),this.2359(0x1|0x2|0x800|0x400),Color(this)
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
			cap:=VarSetCapacity(text,abs(lparam-wparam)),VarSetCapacity(TextRange,12,0),NumPut(lparam,TextRange,0),NumPut(wparam,TextRange,4),NumPut(&text,TextRange,8),this.2162(0,&TextRange)
			return strget(&text,cap,"UTF-8")
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
Class Toolbar{
	static keep:=[],order:=[],list:=[],imagelist:="",toolbar1,toolbar2,toolbar3,fun
	__New(win,pos,id:="",node:=""){
		static count:=0
		static
		WindowName:=b:="window" count,count++,mask:=mask?mask:0x800|0x100|0x10|0x2|0x20|0x200|0x8000|0x4|0x0040|0x40000000|0x00800000|0x800000
		Gui,%b%:+parent1 -Caption -Border +0x400000 hwndhwnd -DPIScale
		Gui,%b%:Color,0x222222,0x222222
		Gui,%b%:Add,Custom,% "ClassToolbarWindow32 hwndhwnd +" mask " gtoolbar vtoolbar" count " w20 h20 hwndtbhwnd"
		Gui,%b%:show,%pos%
		this.name:=name,this.iconlist:=[],this.hwnd:=hwnd+0,this.tb:=tbhwnd+0,this.count:=count,this.buttons:=[],this.returnbutton:=[],this.keep["toolbar" count]:=this,this.ahkid:="ahk_id" hwnd,this.win:=b,this.imagelist:=IL_Create(20,1,settings.SSN("//options/@Small_Icons").text?0:1),this.SetImageList(),this.list[id]:=this,this.id:=id,this.SetMaxTextRows()
		Toolbar.keep[tbhwnd]:=this,this.WindowName:=WindowName
		if(!id){
			FormatTime,date,%A_Now%,longdate
			FormatTime,time,%A_Now%,H:mm:ss
			if(!top:=settings.SSN("//toolbar"))
				top:=settings.Add("toolbar")
			id:=date " " time "." A_MSec,next:=settings.Under(top,"bar",{id:id})
			for a,b in [{file:"Shell32.dll",func:"Open",text:"Open",icon:3,id:10000,state:4,vis:1},{file:"Shell32.dll",func:"Run",text:"Run",icon:76,id:11102,state:4,vis:1}]
				settings.Under(next,"button",b)
			node.SetAttribute("id",id)
			Sleep,1
		}txml:=settings.SN("//toolbar/descendant::*[@id='" id "']/*")
		;MainWin.Gui.SSN("//*/descendant::*[@id='" id "']").SetAttribute("win",WindowName)
		if(txml.length){
			while(tt:=txml.item[A_Index-1]),ea:=xml.ea(tt){
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
		node:=settings.SSN("//toolbar/bar[@id='" this.id "']/descendant::button[@id='" id "']"),node.SetAttribute("icon",icon),node.SetAttribute("file",file)
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
			VarSetCapacity(STR,StrLen(info.text)*2)
			StrPut(info.text,&STR,strlen(info.text)*2)
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
		if(IsFunc(info.func)=0&&IsLabel(info.func)=0&&!menus.SSN("//*[@clean='" info.func "']")) ;&&FileExist(menus.SSN("//*[@clean='" info.func "']/@plugin").text)="")
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
		rem:=settings.SSN("//toolbar/bar[@id='" this.id "']/button[@id='" button.id "']")
		rem.ParentNode.RemoveChild(rem)
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
			this.save()
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
					for a,b in [settings.SSN("//rebar/band[@id='" removeid "']"),settings.SSN("//toolbar/bar[@id='" removeid "']")]
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
					info:=menus.ea("//*[@clean='" func "']")
					Run,% Chr(34) info.plugin Chr(34) " " Chr(34) info.option Chr(34)
				}
				return 1
			}else if(IsFunc(button.func)||IsLabel(button.func))
				SetTimer,% button.func,-1
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
		if(!top:=settings.SSN("//toolbar/bar[@id='" this.name "']"))
			top:=settings.add("toolbar/bar",{id:this.name},,1)
		sep:=SN(top,"descendant::separator")
		while,ss:=sep.item[A_Index-1]
			ss.ParentNode.RemoveChild(ss)
		all:=SN(top,"descendant::button")
		while,aa:=all.item[A_Index-1]
			aa.SetAttribute("vis",0)
		top:=settings.SSN("//toolbar/bar[@id='" this.name "']")
		SendMessage,0x400+24,0,0,,% this.ahkid ;TB_BUTTONCOUNT
		Loop,%ErrorLevel%{
			VarSetCapacity(button,80)
			SendMessage,0x400+23,% A_Index-1,&button,,% this.ahkid ;TB_GETBUTTON
			id:=NumGet(&button,4),btn:=this.buttons[id].Clone()
			if(NumGet(&button,4)=0){
				new:=settings.under(top,"separator",{vis:1},1)
				continue
			}
			if(!node:=SSN(top,"descendant::button[@id='" id "']")){
				btn.Delete("iimage"),btn.vis:=1
				settings.under(top,"button",btn)
			}else
				node.SetAttribute("vis",1)
			node.ParentNode.AppendChild(node)
		}
	}Remove(){
		DllCall("DestroyWindow","Ptr",this.tb),Toolbar.keep.Delete(this.tb)
	}
}
Tracked_Notes(node){
	Gui,1:Default
	if(!NewNode:=MainWin.Gui.SSN("//win[@win='Tracked_Notes']"))
		NewNode:=MainWin.Gui.Add("win",{win:"Tracked_Notes"},,1)
	sc:=new s(1,{pos:"x0 y0 w0 h0"}),TNotes.Register(sc)
	for a,b in {TreeView:MainWin.tn,type:"Tracked Notes",Scintilla:sc.sc}
		node.SetAttribute(a,b)
	v.tnsc:=sc.sc,ea:=XML.EA(node),split:=ea.split?ea.split:.2
	for a,b in {TreeView:[MainWin.tn,{x:ea.x,y:ea.y,w:(width:=Round(ea.w*split)),h:ea.h}],Scintilla:[sc.sc,{x:ea.x+width,y:ea.y,w:ea.w-width,h:ea.h}]}{
		if(!ctrl:=SSN(NewNode,"descendant::control[@type='" a "']"))
			ctrl:=MainWin.Gui.Under(NewNode,"control",{type:a})
		ctrl.SetAttribute("hwnd",b.1)
	}TNotes.Set(),RefreshThemes()
}
Class XML{
	keep:=[]
	__New(param*){
		if(!FileExist(A_ScriptDir "\lib"))
			FileCreateDir,%A_ScriptDir%\lib
		root:=param.1,file:=param.2,file:=file?file:root ".xml",temp:=ComObjCreate("MSXML2.DOMDocument"),temp.setProperty("SelectionLanguage","XPath"),this.xml:=temp,this.file:=file,xml.keep[root]:=this
		;temp.preserveWhiteSpace:=1
		if(FileExist(file)){
			FileRead,info,%file%
			if(info=""){
				this.xml:=this.CreateElement(temp,root)
				FileDelete,%file%
			}else
				temp.LoadXML(info),this.xml:=temp
		}else
			this.xml:=this.CreateElement(temp,root)
	}CreateElement(doc,root){
		return doc.AppendChild(this.xml.CreateElement(root)).ParentNode
	}Add(path,att:="",text:="",dup:=0){
		p:="/",add:=(next:=this.SSN("//" path))?1:0,last:=SubStr(path,InStr(path,"/",0,0)+1)
		if(!next.xml){
			next:=this.SSN("//*")
			for a,b in StrSplit(path,"/")
				p.="/" b,next:=(x:=this.SSN(p))?x:next.AppendChild(this.xml.CreateElement(b))
		}if(dup&&add)
			next:=next.ParentNode.AppendChild(this.xml.CreateElement(last))
		for a,b in att
			next.SetAttribute(a,b)
		next.text:=text
		return next
	}
	Find(info*){
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
	}
	Under(under,node,att:="",text:="",list:=""){
		new:=under.AppendChild(this.xml.CreateElement(node)),new.text:=text
		for a,b in att
			new.SetAttribute(a,b)
		for a,b in StrSplit(list,",")
			new.SetAttribute(b,att[b])
		return new
	}ReCreate(path,new){
		rem:=this.SSN(path),rem.ParentNode.RemoveChild(rem),new:=this.Add(new)
		return new
	}SSN(path){
		return this.xml.SelectSingleNode(path)
	}SN(path){
		return this.xml.SelectNodes(path)
	}__Get(x=""){
		return this.xml.xml
	}Get(Path,Default){
		text:=this.SSN(path).text
		return text?text:Default
	}Transform(){
		static
		if(!IsObject(xsl))
			xsl:=ComObjCreate("MSXML2.DOMDocument"),xsl.loadXML("<xsl:stylesheet version=""1.0"" xmlns:xsl=""http://www.w3.org/1999/XSL/Transform""><xsl:output method=""xml"" indent=""yes"" encoding=""UTF-8""/><xsl:template match=""@*|node()""><xsl:copy>`n<xsl:apply-templates select=""@*|node()""/><xsl:for-each select=""@*""><xsl:text></xsl:text></xsl:for-each></xsl:copy>`n</xsl:template>`n</xsl:stylesheet>"),style:=null
		this.xml.transformNodeToObject(xsl,this.xml)
	}Save(x*){
		if(x.1=1)
			this.Transform()
		if(this.xml.SelectSingleNode("*").xml="")
			return m("Errors happened while trying to save " this.file ". Reverting to old version of the XML")
		filename:=this.file?this.file:x.1.1,ff:=FileOpen(filename,0),text:=ff.Read(ff.length),ff.Close()
		if(!this[])
			return m("Error saving the " this.file " xml.  Please get in touch with maestrith if this happens often")
		if(text!=this[])
			file:=FileOpen(filename,"rw"),file.seek(0),file.write(this[]),file.length(file.position)
	}EA(path,att:=""){
		list:=[]
		if(att)
			return path.NodeName?SSN(path,"@" att).text:this.SSN(path "/@" att).text
		nodes:=path.NodeName?path.SelectNodes("@*"):nodes:=this.SN(path "/@*")
		while,n:=nodes.item(A_Index-1)
			list[n.NodeName]:=n.text
		return list
}}
SSN(node,path){
	return node.SelectSingleNode(path)
}
SN(node,path){
	return node.SelectNodes(path)
}
Class(text,current:="",Remove:=0){
	if(Remove){
		for c,d in v.OmniFind{
			if(c~="Function|Class|Method|Property")
				Continue
			pos:=1
			while(RegExMatch(text,d,found,pos),pos:=found.Pos(1)+found.Len(1)){
				if(!found.len(1))
					Break
				Code_Explorer.RemoveTV(SN(current,"descendant::*[@type='" c "' and @text='" found.1 "']"))
		}}
		if(RegExMatch(text,v.OmniFind.Class,found))
			Code_Explorer.RemoveTV(SN(current,"descendant::*[@type='Class' and @text='" found.2 "']"))
	}else{
		for c,d in v.OmniFind{
			if(c~="Function|Class|Method|Property")
				Continue
			pos:=1
			while(RegExMatch(text,d,found,pos),pos:=found.Pos(1)+found.Len(1)){
				if(!found.len(1))
					Break
				Code_Explorer.Add(c,found)
				;Code_Explorer.RemoveTV(SN(current,"descendant::*[@type='" c "' and @text='" found.1 "']"))
			}
		}
		Code_Explorer.ScanComments(text),Code_Explorer.ScanClass(text,current),Code_Explorer.ScanFM(text,current),AddMissing()
	}
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
	LineStatus.Clear()
}
Close(x:=1,all:="",Redraw:=1){
	parent:=Current(1),pea:=xml.EA(parent),nodes:=all?files.SN("//main[@file!='Libraries']"):files.SN("//main[@id='" pea.id "']")
	if(!Current(2).untitled)
		Save(3)
	Loop,2
		TVC.Disable(A_Index)
	if(x.length)
		nodes:=x
	while(nn:=nodes.item[A_Index-1]),pea:=xml.EA(nn){
		if(!settings.Find("//previous_scripts/script/text()",pea.file))
			settings.Add("previous_scripts/script",,pea.file,1)
		if(pea.untitled&&Redraw)
			Save_Untitled(nn,1)
		all:=SN(nn,"descendant::*[@tv]")
		while(aa:=all.item[A_Index-1]),ea:=xml.EA(aa){
			Update({Delete:ea.file})
			if(A_Index=1)
				store:=ea.tv
			else if(ea.tv)
				TVC.Delete(1,ea.tv)
			RemoveHistory(ea.file)
		}if(store){
			TVC.Delete(1,store)
		}
		all:=cexml.SN("//*[@id='" pea.id "']")
		while(aa:=all.item[A_Index-1]),ea:=xml.EA(aa){
			if(A_Index=1)
				store:=ea.cetv
			else if(ea.cetv)
				TVC.Delete(2,ea.cetv)
		}if(store)
			TVC.Delete(2,store)
		rem:=settings.Find("//open/file/text()",pea.file),rem.ParentNode.RemoveChild(rem)
		for a,b in [files.SSN("//main[@id='" pea.id "']"),cexml.SSN("//main[@id='" pea.id "']")]
			b.ParentNode.RemoveChild(b)
	}
	Loop,2
		TVC.Enable(A_Index)
	Default("SysTreeView321"),TV_Modify(TV_GetChild(0),"Select Vis Focus")
	if(tv:=files.SSN("//main[@file!='Libraries']/file/@tv").text)
		csc().2400(),tv(tv)
	else
		New()
}
Close_All(){
	Close(1,1),New(1)
}
Color(con:=""){
	con:=con?con:v.con
	if(!con.sc)
		return v.con:=""
	static options:={show_eol:2356,Show_Caret_Line:2096}
	list:={Font:2056,Size:2055,Color:2051,Background:2052,Bold:2053,Italic:2054,Underline:2059},nodes:=settings.SN("//fonts/font")
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
	}}SetWords()
	for a,b in [[2040,25,13],[2244,3,0xFE000000],[2040,26,15],[2040,27,17],[2040,28,16],[2040,29,9],[2040,30,12],[2040,31,14],[2242,0,20],[2242,1,13],[2134,1],[2260,1],[2246,1,1],[2246,2,1],[2115,1],[2029,2],[2031,2],[2240,3,0],[2242,3,15],[2246,1,1],[2246,3,1],[2244,2,3],[2040,0,0],[2041,0,0],[2042,0,0xff],[2115,1],[2056,38,"Tahoma"],[2041,1,0],[4006,0,"ahk"],[2042,1,0xff0000],[2040,2,22],[2042,2,0x444444],[2040,3,22],[2042,3,0x666666],[2040,4,31],[2042,4,0xff0000],[2037,65001],[2132,v.Options.Hide_Indentation_Guides=1?0:1],[2280,v.Options.Hide_Vertical_Scrollbars=1?0:1],[2130,v.Options.Hide_Horizontal_Scrollbars=1?0:1],[2040,1,0],[2042,1,0x0000ff]]
		con[b.1](b.2,b.3)
	if(v.Options.Word_Wrap_Indicators)
		con.2460(4)
	if(v.Options.Word_Wrap)
		con.2268(1)
	con.2472(2),con.2036(width:=settings.SSN("//tab").text?settings.SSN("//tab").text:5)
	con.2082(3,0xFFFFFF)
	if(!settings.SSN("//fonts/font[@code='2082']"))
		con.2082(7,0xff00ff)
	if(!(settings.SSN("//fonts/font[@style='34']")))
		con.2498(1,7)
	con.2212(),con.2371(0),indic:=settings.SN("//fonts/indicator")
	while,in:=indic.item[A_Index-1],ea:=xml.ea(in)
		for a,b in ea
			if(ea.Background!="")
				con.2082(ea.indic,ea.Background)
	con.2636(1),con.2516(1),con.2458(2),con.2373(settings.Get("//gui/@zoom",0)),con.2051(151,settings.Get("//debug/continuecolor",0xFF8080)),con.2051(35,0xff00ff)
	for a,b in options
		if(v.Options[a])
			con[b](b)
	kwind:={Personal:0,indent:1,Directives:2,Commands:3,builtin:4,keywords:5,functions:6,flow:7,KeyNames:8}
	for a,b in v.color
		con.4005(kwind[a],RegExReplace(b,"#"))
	if(node:=settings.SSN("//fonts/fold")){
		ea:=xml.ea(node)
		Loop,7
			con.2041(24+A_Index,ea.color!=""?ea.color:"0"),con.2042(24+A_Index,ea.background!=""?ea.Background:"0xaaaaaa")
	}con.4004("fold",[1]),con.2680(3,6),con.2242(4,1),con.2240(4,5),con.2110(1)
	/*
		split out the indicators and have their own area in here
	*/
	;indicators
	for a,b in [[2080,7,6],[2082,8,0xff00ff],[2080,8,1],[2080,6,14],[2080,2,8],[2082,2,0xff00ff],[2082,6,0xC08080],[2080,3,14],[2680,3,6]]
		con[b.1](b.2,b.3)
	if(!v.Options.Match_Any_Word)
		con.2198(0x2)
	SetTimer,editedmarker,-1
	return
	editedmarker:
	sc:=csc()
	for a,b in {20:settings.Get("//fonts/font[@style='30']/@background",0x0000ff),21:settings.Get("//fonts/font[@style='31']/@background",0x00ff00)}
		sc.2040(a,27),sc.2042(a,b)
	return
}
Command_Help(){
	static stuff,hwnd,ifurl:={between:"commands/IfBetween.htm",in:"commands/IfIn.htm",contains:"commands/IfIn.htm",is:"commands/IfIs.htm"}
	sc:=csc(),info:=Context(1),line:=sc.getline(sc.2166(sc.2008)),found1:=info.word
	RegRead,outdir,HKEY_LOCAL_MACHINE,SOFTWARE\AutoHotkey,InstallDir
	if(!outdir)
		SplitPath,A_AhkPath,,outdir
	if(!found1)
		RegExMatch(line,"[\s+]?(\w+)",found)
	if(InStr(commands.SSN("//Commands/Commands").text,found1)){
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
		help.Navigate(url),WinActivate("AutoHotkey Help ahk_class HH Parent")
		while(help.busy)
			Sleep,10
		if(InStr(help.document.body.OuterHtml,"This page can’t be displayed"))
			help.Navigate("mk:@MSITStore:C:\Program%20Files%20(x86)\AutoHotkey\AutoHotkey.chm::/docs/AutoHotkey.htm")
	}
	return
}
Compile(main=""){
	main:=SSN(current(1),"@file").Text,v.compiling:=1
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
	RunWait,%file% /in "%A_ScriptDir%\temp\temp.upload" /out "%dir%\%name%.exe" %add%
	if(FileExist("upx.exe")){
		SplashTextOn,,50,Compressing EXE,Please wait...
		RunWait,upx.exe -9 "%dir%\%name%.exe",,Hide
	}
	FileDelete,temp\temp.upload
	SplashTextOff
	v.compiling:=0
}
CompileFont(XMLObject,RGB:=1){
	ea:=xml.ea(XMLObject),style:=[],name:=ea.name,styletext:="norm"
	for a,b in {bold:"",color:"c",italic:"",size:"s",strikeout:"",underline:""}{
		if(a="color")
			styletext.=" c" _:=RGB?RGB(ea[a]):ea[a]
		else if(ea[a])
			styletext.=" " _:=b?b ea[a]:a
	}
	return styletext
}
Context(return=""){
	sc:=csc(),cp:=sc.2008,line:=sc.2166(cp),start:=sc.2128(line),end:=sc.2136(line),synmatch:=[],startpos:=0,found:=[],string:=sc.TextRange(start,cp),pos:=1,sub:=cp-start,commas:=0,current:=cexml.Find("//main/@file",Current(2).file),flag:=sc.2199(),sc.2198(0),start:=cp
	while(start<end){
		found:=[]
		for a,b in {open:"(",close:")"}{
			sc.2686(start,end)
			if((pos:=sc.2197(1,b))>=0)
				if(sc.2010(pos)=4)
					found[pos]:=a
		}if(found[found.MinIndex()]="open"){
			match:=sc.2353(found.MinIndex())
			if(match<=end)
				start:=match+1
			Continue
		}if(found[found.MinIndex()]="close"){
			match:=sc.2353(found.MinIndex()),word:=sc.TextRange((WordStartPos:=sc.2266(match,1)),sc.2267(match,1))
			if(sc.2007(WordStartPos-1)=46)
				pre:=sc.TextRange(sc.2266(WordStartPos-2,1),sc.2267(WordStartPos-2,1)),WordStartPos-=StrPut(pre,"UTF-8")
			Break
		}start++
	}if(word!="if"&&word){
		start:=match+1,end:=sc.2008,comma:=0
		while(start<end){
			found:=[]
			for a,b in {open:"(",comma:","}{
				sc.2686(start,end)
				if((pos:=sc.2197(1,b))>=0){
					if(a!="comma"&&sc.2010(pos)=4)
						found[pos]:=a
					if(a="comma")
						found[pos]:=sc.2010(pos)
			}}if(found[found.MinIndex()]="open"){
				start:=sc.2353(found.MinIndex())+1
				Continue
			}if(found[found.MinIndex()]=97)
				comma++,start:=found.MinIndex()+1
			if(found.MinIndex())
				start:=found.MinIndex()
			start++
		}
		sc.2198(flag)
		if(word){
			if(sc.2007(wb-1)=46)
				pre:=sc.TextRange(sc.2266(wb-1,1),sc.2267(wb-1,1))
			if(pre="this")
				class:=GetCurrentClass(sc.2166(sc.2008)),args:=SSN(Current(5),"descendant::*[@type='Class' and @text='" class.baseclass "']/descendant::*[@type='Method' and @upper='" Upper(word) "']/@args").text,start:=pre "." word
			else if((ea:=scintilla.EA("//scintilla/commands/item[@code='" word "']")).syntax)
				start:=pre "." word,args:=RegExReplace(ea.syntax,"\(|\)") "``n" ea.name
			else if(RegExMatch(string,"i):=\s*\bnew\b\s+" word)){
				if(node:=SSN(current,"descendant::info[@type='Class' and @upper='" Upper(word) "']")){
					start:="new " word,args:=SSN(node,"descendant::*[@type='Method' and @upper='__NEW']/@args").text
				}else if(node:=cexml.SSN("//main[@file='Libraries']/descendant::info[@upper='" Upper(word) "']"))
					start:="new " word,args:=SSN(node,"descendant::*[@type='Method' and @upper='__NEW']/@args").text
			}else if(class:=SSN(current,"descendant::*[@type='Instance' and @upper='" Upper(pre) "']/@class").text)
				start:=pre "." word,args:=SSN(current,"descendant-or-self::*[@type='Class' and @upper='" Upper(class) "']/descendant-or-self::*[@upper='" Upper(word) "']/@args").text
			else if(class:=SSN(current,"descendant::*[@type='Class' and @upper='" Upper(pre) "']/descendant::*[@type='Method' and @upper='" Upper(word) "']"))
				start:=pre "." word,args:=SSN(class,"@args").text
			else if(args:=SSN(current,"descendant::*[@type='Function' and @upper='" Upper(word) "']/@args").text)
				start:=word
			else if(fun:=cexml.SSN("//main[@file='Libraries']/descendant::info[@upper='" Upper(word) "']"))
				start:=word,args:=xml.ea(fun).args
			else if(syn:=commands.SSN("//Commands/Commands/commands[text()='" v.kw[word] "']/@syntax").text)
				start:=word,args:=RegExReplace(syn,"\(|\)")
			else
				return sc.2198(flag)
			Sleep,20
			if(!sc.2102&&v.Options.Context_Sensitive_Help){
				new:=StrSplit(args,Chr(96) "n"),add:=""
				for a,b in new
					if(A_Index>1)
						add.="`n" b
				sc.2207(0xff0000),sc.2200(WordStartPos,(main:=start "(" new.1 ")") add),begin:=StrPut(start "(","UTF-8")-1,end:=StrPut(main,"UTF-8")-2,pos:=InStr(new.1,",",0,1,comma),pos1:=InStr(new.1,",",0,1,comma+1),cma:=StrSplit(new.1,",")
				if(pos&&pos1)
					sc.2204(begin+pos,begin+pos1)
				else if(pos1&&!pos)
					sc.2204(begin,begin+pos1)
				else if(pos&&!pos1)
					sc.2204(begin+pos,end)
				else if(!pos&&!pos1&&!comma&&new.1){
					sc.2204(begin,end)
				}else if(!pos&&!pos1){
					if(InStr(cma[cma.MaxIndex()],"*")){
						complete:=""
						while(A_Index<cma.MaxIndex())
							complete.=cma[A_Index] ","
						sc.2204(begin+StrPut(complete,"UTF-8")-1,end)
					}else
						sc.2207(0x0000ff),sc.2204(0,end+1)
			}}if(return)
				return {word:word,last:last}
			return {word:word,last:last}
		}
		return
	}else{
		RegExMatch(string,"O)^[\s|\W]*(\w+)",word),word:=v.kw[word.1]?v.kw[word.1]:word.1,startpos:=start,loopword:=word,loopstring:=string,build:=word,start:=""
		if(Trim(string,";")~="^\s*#"){
			if(RegExMatch(v.Keywords["#"],"i)#\b(" word ")\b",found))
				if(node:=commands.SSN("//Commands/commands[text()='#" found1 "']"))
					start:="#" word,syn:=SSN(node,"@syntax").text
		}else if((syn:=commands.SSN("//Commands/commands[text()='" word "' or text()='" word "']/@syntax").text)&&word!="if")
			start:=word
		else if((list:=v.context[word])&&word!="if"){
			for a,b in StrSplit(string,","){
				if(RegExMatch(b,"Oi)\b(" list ")\b",found))
					RegExMatch(list,"Oi)\b(" found.1 ")\b",found),last:=found.1,build.=A_Index=1?",":b ","
				else
					Break
			}if(top:=commands.SSN("//Context/" word)){
				list:=SN(top,"list"),find:="",build:=word ","
				while,ll:=list.item[A_Index-1],ea:=xml.ea(ll)
					find.=ea.list " "
				start:=sc.2128(line:=sc.2166(sc.2008)),end:=sc.2136(line)
				for a,b in StrSplit(Trim(find)," "){
					sc.2686(start,end),pos:=sc.2197(StrLen(b),b)
					if((sc.2010(pos)~="3")=0&&pos>0)
						last:=b,build.=b ","
				}
				if(syn:=SSN(top,"syntax[contains(text(),'" last "')]/@syntax").text)
					start:=Trim(build,","),AddComma:=1
		}}else if(word="if"){
			start:=sc.2128(line:=sc.2166(sc.2008)),end:=sc.2136(line),flag:=sc.2199,sc.2198(2)
			for a,b in ["contains","in","between","is"]{
				sc.2686(start,end),pos:=sc.2197(StrLen(b),b)
				if((sc.2010(pos)~="3")=0&&pos>0){
					last:=b
					break
			}}start:="if",syn:=" " commands.SSN("//Context/if/descendant-or-self::syntax[text()='" (last?last:"if") "']/@syntax").text,sc.2198(flag)
		}sstart:=sc.2128(line),end:=sc.2008,comma:=0
		while(sstart<end){
			sc.2686(sstart,end)
			if((pos:=sc.2197(1,","))>=0){
				if(sc.2010(pos)=4)
					comma++,sstart:=pos
			}sstart++
		}sc.2198(flag)
		if(return)
			return {word:word,last:last}
		if(start="if"&&!sc.2202&&!sc.2102)
			return sc.2200(sc.2128(line),start syn)
		else{
			if(!sc.2102&&syn&&v.Options.Context_Sensitive_Help){
				syn:=StrSplit(syn,Chr(96) "n"),add:=""
				for a,b in new
					if(A_Index>1)
						add.="`n" b
				sc.2207(0xff0000)
				syntax:=start syn.1,extra:=""
				for a,b in syn
					if(A_Index>1)
						extra.="`n" b
				sc.2200(sc.2128(line),syntax extra),end:=StrPut(syntax,"UTF-8")-2,pos:=InStr(syntax,",",0,1,comma),pos1:=InStr(syntax,",",0,1,comma+1),cma:=StrSplit(syntax,",")
				if(pos&&pos1)
					sc.2204(pos,pos1)
				else if(pos1&&!pos)
					sc.2204(0,pos1)
				else if(pos&&!pos1)
					sc.2204(pos,end)
				else if(!pos&&!pos1){
					if(InStr(cma[cma.MaxIndex()],"*")){
						complete:=""
						while(A_Index<cma.MaxIndex())
							complete.=cma[A_Index] ","
						sc.2204(StrPut(complete,"UTF-8")-1,end)
					}else
						sc.2207(0x0000ff),sc.2204(0,end+1)
		}}}return {word:word,last:last}
}}
ContextMenu(){
	static ONode,Kill
	SetupEnter()
	for a,b in ["RCM","toolbars"]
		Menu,%b%,DeleteAll
	MouseGetPos,,,,ctrl,2
	if(!node:=MainWin.Gui.SSN("//*[@hwnd='" ctrl+0 "']")){
		if(!node:=MainWin.Gui.SSN("//*[@toolbar='" ctrl+0 "']")){
			xx:=MainWin.Gui
			Menu,RCM,Add,% "Move to " (settings.SSN("//options/@Top_Find").text?"Bottom":"Top"),MoveFind
			Menu,RCM,Show
			Menu,RCM,DeleteAll
			return
			MoveFind:
			Options("Top_Find")
			return
		}
	}
	ONode:=node,oea:=xml.EA(ONode)
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
	}
	all:=SN(node,"descendant::*"),track:=[],count:=MainWin.Gui.SN("//win[@win=1]/descendant::control[@type='Scintilla']").length
	while(aa:=all.item[A_Index-1]),ea:=xml.EA(aa),pea:=XML.EA(parent:=aa.ParentNode){
		if(type=ea.name)
			Continue
		if(aa.NodeName="Separator"){
			Menu,RCM,Add
			Continue
		}else if(aa.ParentNode.NodeName="menu"){
			parent:=xml.EA(aa.ParentNode.ParentNode)
			track[pea.name]:=aa.ParentNode.ParentNode.NodeName="Menu"?parent.name:"RCM"
			Menu,% pea.name,Add,% ea.name,MenuEnd
			Continue
		}else{
			Menu,RCM,Add,% ea.name,MenuEnd
			if(v.Options[Clean(ea.name)])
				Menu,% parent.NodeName="main"?"RCM":pea.name,Check,% ea.name
	}}for a,b in track
		Menu,%b%,Add,%a%,:%a%
	Menu,RCM,Add
	if(oea.type="Toolbar")
		Menu,RCM,Add,Edit Toolbar,EditToolbar
	for a,b in ["Above","Below","Left","Right"]
		Menu,Split,Add,%b%,RCMSplit
	for a,b in ["Project Explorer","Code Explorer","Tracked Notes"]
		if(!MainWin.Gui.SSN("//win[@win=1]/descendant::*[@type='" b "']"))
			Menu,Type,Add,%b%,Type
	if(SSN(ONode,"@type").text!="Scintilla")
		Menu,Type,Add,Scintilla,Type
	list:=settings.SN("//toolbar/bar")
	Menu,toolbars,Add,New Toolbar,NewToolbar
	Menu,toolbars,Add
	while(ll:=list.item[A_Index-1]),ea:=xml.EA(ll)
		if(!MainWin.Gui.SSN("//win[@win=1]/descendant::*[@id='" ea.id "']"))
			Menu,toolbars,Add,% ea.id,ChangeToolbar
	Menu,Type,Add,Toolbar,:toolbars
	Menu,RCM,Add,Split Control,:Split
	Menu,RCM,Add,Control Type,:Type
	Menu,RCM,Add,Remove Control,RCMRC
	Menu,RCM,Add
	Menu,RCM,Add,Edit Menu,EditRCM
	WinGet, AList, List, ahk_class AutoHotkey
	Loop,%AList%{
		ID:=AList%A_Index%
		WinGetTitle,ATitle,ahk_id%ID%
		if(Trim(SubStr(ATitle,1,InStr(ATitle,"-",0,0,1)-1))=Current(2).file){
			Menu,RCM,Add,Kill Current Script,KillCurrentScript
			Kill:=ID
		}
	}
	Menu,RCM,Show
	for a,b in ["Split","Type"]
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
	MainWin.Type("Toolbar")
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
	MainWin.Split(A_ThisMenuItem)
	return
	MenuEnd:
	StrSplit("this")
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
		MainWin.Size(1),Redraw(),MainWin.Pos()
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
		options("Hide_File_Extensions")
	else
		m("Coming soon:",A_ThisMenu,A_ThisMenuItem)
	SetupEnter(1)
	return
	RCMRC:
	MainWin.Delete(),SetupEnter(1)
	;m("Remove the control :)")
	/*
		I need to add in a way to add toolbars.
	*/
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
csc(set:=0){
	static current
	if(set.plugin)
		return current:=set.plugin
	if(set.hwnd)
		current:=s.ctrl[set.hwnd]
	if(set=2){
		if(current.sc=TNotes.sc.sc)
			return current:=s.ctrl[MainWin.Gui.SSN("//*[@type='Scintilla']/@hwnd").text]
		else if(current.Hidden){
			current:=s.ctrl[MainWin.Gui.SSN("//win[@win=1]/descendant::control[@type='Scintilla']/@hwnd").text],current.2400()
			return current
		}else
			return current
	}
	if(set=1||!current.sc||InStr(set,"Scintilla")){
		hwnd:=MainWin.Gui.SSN("//*[@type='Scintilla']/@hwnd").text
		current:=s.ctrl[hwnd]
		if(!current.sc)
			current:=s.main.1,current.2400()
	}if(s.ctrl[current].hidden){
		m("OH NO!")
		for a,b in s.ctrl
			if(!b.hidden){
				current:=a
				Break
	}}
	return current
}
Current(parent=""){
	sc:=csc(),node:=files.SSN("//*[@sc='" sc.2357 "']"),id:=SSN(node,"@id").text
	if(parent=1)
		return SSN(node,"ancestor-or-self::main")
	else if(parent=2)
		return XML.EA(SSN(node,"ancestor-or-self::main"))
	else if(parent=3)
		return XML.EA(node)
	else if(parent=4)
		return SSN(node,"ancestor-or-self::main/file")
	else if(parent=5)
		return cexml.SSN("//file[@id='" id "']")
	else if(parent=6)
		return cexml.EA("//file[@id='" id "']")
	else if(parent=7)
		return SSN(cexml.SSN("//*[@id='" id "']"),"ancestor-or-self::main")
	else if(parent=8)
		return id
	else if(parent=9)
		return SSN(cexml.SSN("//*[@id='" id "']"),"ancestor::main/@id").text
	return node
}
Cut(){
	ControlGetFocus,Focus,% hwnd([1])
	SendMessage,0x300,0,0,%Focus%,% hwnd([1])
	if(v.Options.Clipboard_History){
		for a,b in v.Clipboard
			if(b=Clipboard)
				return
		v.Clipboard.push(Clipboard)
}}
Default(Control:="SysTreeView321",win:=1){
	type:=InStr(Control,"SysTreeView32")?"TreeView":"ListView"
	Gui,%win%:Default
	Gui,%win%:%type%,%control%
}
DefaultFont(){
	temp:=new xml("temp")
	info=<fonts><name>Zenburn_dark_with_maestrith</name><author>Run1e and maestrith</author><font background="3158064" bold="0" color="16777215" font="Consolas" size="10" style="5" italic="0" strikeout="0" underline="0"></font><font background="3158064" style="33" color="16777215" font="Consolas" bold="0" italic="0"></font><font style="0" color="12632256"></font><font style="1" color="8363903" bold="0" italic="1" size="10" strikeout="0" underline="0"></font><font style="2" color="8421616"></font><font style="3" color="8816334"></font><font style="4" color="16777215"></font><font style="11" color="16744576" bold="0" italic="0" size="10" strikeout="0" underline="0"></font><font style="13" color="255" background="0"></font><font style="15" color="12110995"></font><font style="17" color="7843024"></font><font style="18" color="13617276"></font><font style="19" color="16758590"></font><font style="21" color="9749720"></font><font style="22" color="14732901"></font><font style="37" color="4227327"></font><font bool="1" code="2068" color="32896"></font><font code="2069" color="16777215"></font><font code="2098" color="4473924"></font><font code="2601" color="8421504"></font><font style="20" color="16759366"></font><font style="24" color="15458669"></font><font style="23" color="8241367"></font><font style="9" color="11184810"></font><font style="8" color="9737364"></font><font style="10" color="255" background="0"></font><font style="16" color="5741559"></font><font style="55" color="4227327"></font><font style="56" color="8421440"></font><font style="57" color="16744576"></font><font style="58" color="8388863"></font><font style="41" color="16776960"></font><font style="40" color="65408"></font><font style="42" color="0" background="255"></font><font background="8388863" style="30"></font><font background="4227072" style="31"></font><font code="2188" value="1"></font><font background="65535" style="48"></font><custom control="msctls_statusbar321" gui="1" bold="0" color="0" font="Comic Sans MS" italic="0" size="10" strikeout="0" underline="0"></custom><font style="34" bold="0" color="8388863" font="Consolas" italic="0" size="10" strikeout="0" underline="0"></font><font style="97" color="8421504"></font><font style="99" color="16744576"></font></fonts>
	top:=settings.SSN("//*"),temp.xml.LoadXML(info),temp.Transform(2),tt:=temp.SSN("//*"),top.AppendChild(tt)
}
DefaultRCM(){
	static all:={Scintilla:"Undo,Redo,Copy,Cut,Paste,Select All,Close,Delete,Open,Open Folder,Omni Search"
		    ,"Tracked Notes":"Track File,Backup Notes,Contract All,Switch Orientation,Remove Tracked File"
		    ,"Project Explorer":"New,Close,Open,Rename Current Include,Remove Include,Copy File Path,Copy Folder Path,Open Folder,Hide/Show Icons,File Icon,Folder Icon,Hide/Show File Extensions,Refresh Project Explorer"
		    ,"Code Explorer":"Refresh Code Explorer"
		    ,Toolbar:"Small Icons"
		    ,Debug:"Close Debug Window"}
	for a,b in ["Scintilla","Code Explorer","Project Explorer","Tracked Notes","Toolbar","Debug"]{
		if(!RCMXML.SSN("//main[@name='" b "']")){
			main:=RCMXML.Add("main",{name:b},,1)
			for c,d in StrSplit(all[b],",")
				RCMXML.Under(main,"menu",{name:d})
		}
	}
}
Delete_Line(){
	sc:=csc(),line:=sc.2166(sc.2008),pos:=sc.2128(line),diff:=sc.2008-pos,sc.2338(),start:=sc.2128(line),end:=sc.2136(line),sc.2025(diff<=end-start?start+diff:end)
}
Delete_Matching_Brace(){
	sc:=csc(),value:=[]
	GuiControl,1:+g,% sc.sc
	for a,b in [v.braceend,v.bracestart]
		value[b]:=1
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
Dlg_Color(Color,hwnd){
	static
	if(settings.SSN("//colorinput").text){
		color:=InputBox(sc,"Color Code","Input your color code in RGB",RGB(color))
		if(!InStr(color,"0x"))
			color:="0x" color
		if(!ErrorLevel)
			return RGB(color)
		return
	}if(!cc){
		VarSetCapacity(cccc,16*A_PtrSize,0),cc:=1,size:=VarSetCapacity(CHOOSECOLOR,9*A_PtrSize,0)
		Loop,16{
			IniRead,col,color.ini,color,%A_Index%,0
			NumPut(col,cccc,(A_Index-1)*4,"UInt")
		}
	}
	NumPut(size,CHOOSECOLOR,0,"UInt"),NumPut(hwnd,CHOOSECOLOR,A_PtrSize,"UPtr"),NumPut(Color,CHOOSECOLOR,3*A_PtrSize,"UInt"),NumPut(3,CHOOSECOLOR,5*A_PtrSize,"UInt"),NumPut(&cccc,CHOOSECOLOR,4*A_PtrSize,"UPtr"),ret:=DllCall("comdlg32\ChooseColorW","UPtr",&CHOOSECOLOR,"UInt")
	if(!ret)
		exit
	Loop,16
		IniWrite,% NumGet(cccc,(A_Index-1)*4,"UInt"),color.ini,color,%A_Index%
	IniWrite,% Color:=NumGet(CHOOSECOLOR,3*A_PtrSize,"UInt"),color.ini,default,color
	return Color
}
Donate(){
	donate:
	Run,http://www.maestrith.com/donations/
	return
}
Duplicate_Line(){
	csc().2469
}
Duplicates(){
	sc:=csc(),sc.2500(3),sc.2505(0,sc.2006),dup:=[],len:=StrLen(search:=Trim(sc.TextRange(sc.2143,sc.2145),"`n`t ")),v.lastsearch:=search,v.selectedduplicates:=""
	if(len<2)
		return
	sc.2686(0,sc.2006),sc.2500(3)
	sc.2198((v.Options.Match_Any_Word?0:0x2))
	len:=StrPut(search,"UTF-8")-1,obj:=v.duplicateselect[sc.2357]:=[]
	while(found:=sc.2197(len,[search]))>=0{
		sc.2504(found,len),sc.2686(found+1,sc.2006),obj[found]:=len
	}
	/*
		dup.Insert(found),sc.2686(++found,sc.2006)
		if(dup.MaxIndex()>1){
			for a,b in dup
				sc.2686(b,sc.2006),sc.2504(b,len),found++
			v.duplicateselect[sc.2357]:=dup
		}
	*/
}
DynaRun(Script,Wait:=true,name:="Untitled"){
	static exec,started,filename
	filename:=name,MainWin.Size()
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

Edit_Hotkeys(ret:=""){
	static newwin
	if(ret.NodeName)
		return ea:=xml.ea(ret),Default("SysTreeView321","Edit_Hotkeys"),TV_Modify(TV_GetSelection(),"",RegExReplace(ea.clean,"_"," ")(ea.hotkey?" - " Convert_Hotkey(ea.hotkey):""))
	newwin:=new GUIKeep("Edit_Hotkeys"),newwin.add("ComboBox,w400 gehfind vfind,,w","TreeView,w400 h400,,wh","Button,gehgo Default,Change Hotkey,y"),all:=menus.SN("//main/descendant::*")
	while,aa:=all.item[A_Index-1],ea:=xml.ea(aa)
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
	MenuWipe(),editnode:=node,win:=window,nw:=new GUIKeep("Edit_Hotkey"),nw.add("Hotkey,w240 vhotkey gEditHotkey","Edit,w240 vedit gCustomHotkey","ListView,w240 h220,Duplicate Hotkey Definitions","Button,gEHSet Default,Set Hotkey,y"),nw.show("Edit Hotkey")
	GuiControl,Edit_Hotkey:,msctls_hotkey321,% SSN(node,"@hotkey").text
	return
	EditHotkey:
	info:=nw[],hotkey:=info.hotkey,edit:=info.edit,LV_Delete()
	StringUpper,uhotkey,hotkey
	if(dup:=menus.SN("//*[(@hotkey='" hotkey "' or @hotkey='" uhotkey "')and(@clean!='" SSN(editnode,"@clean").text "')]"))
		while,dd:=dup.item[A_Index-1],ea:=xml.ea(dd)
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
		while,dd:=dup.item[A_Index-1],ea:=xml.ea(dd)
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
Edit_Replacements(){
	static
	newwin:=new GUIKeep(7),SN:=settings.SN("//replacements/*"),newwin.Add("ListView,w500 h400 ger AltSubmit,Value|Replacement,wh","Text,,Value:,y","Edit,w500 vvalue,,wy","Text,xm,Replacement:,y","Edit,w500 r6 vreplacement gedrep,,wy","Button,xm geradd Default,Add,y","Button,x+10 gerremove,Remove Selected,y")
	while,val:=SN.item(A_Index-1)
		LV_Add("",SSN(val,"@replace").text,val.text)
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
	if(item:=settings.SSN("//replacements/replacement[@replace='" info.replacement "']"))
		item.text:=info.value,LV_Modify(LV_GetNext(),"Col2",info.value)
	return
	eradd:
	rep:=newwin[]
	if(!(rep.replacement&&rep.value))
		return m("both values are required")
	if(!settings.SSN("//replacements/*[@replace='" rep.value "']"))
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
		rem:=settings.SSN("//replacements/*[@replace='" value "']"),LV_Delete(LV_GetNext()),rem.ParentNode.RemoveChild(rem)
	return
	7Close:
	7Escape:
	newwin.SavePos(),hwnd({rem:7})
	return
}
Edited(current:=""){
	current:=current?current:Current()
	if(!SSN(current,"@edited"))
		current.SetAttribute("edited",1),ea:=xml.EA(current),TVC.Modify(1,(v.Options.Hide_File_Extensions?"*" ea.nne:"*" ea.filename),ea.tv),WinSetTitle(1,ea)
}
Enable(Control,label:="",win:=1){
	value:=label?"+":"-"
	Gui,%win%:Default
	GuiControl,%win%:%value%Redraw,%Control%
	GuiControl,%win%:+g%label%,%Control%
}
Encode(tt,ByRef text,encoding:="UTF-8"){
	len:=VarSetCapacity(text,(StrPut(tt,encoding)*((encoding="utf-16"||encoding="cp1200")?2:1))),StrPut(tt,&text,len,"UTF-8")
	return text
}
Enter(){
	static map:=new XML("map")
	ControlGetFocus,Focus,% hwnd([1])
	checkqf:
	sc:=csc(),fixlines:=[],ind:=settings.Get("//tab",5),ShowOSD(GetKeyState("Shift","P")?"Shift+Enter":"Enter")
	if(InStr(focus,"scintilla")){
		SetTimer,Scan_Line,-100
		if(sc.2202)
			sc.2201
		if(sc.2102)
			return sc.2104(),sc.Enable(1)
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
		all:=map.SN("descendant::*[@line]"),add:=0,state:=GetKeyState("Shift","P")
		while(aa:=all.item[A_Index-1],ea:=xml.EA(aa)){
			if(!state){
				if(ea.between)
					InsertMultiple(ea.caret,ea.pos,"`n`n",ea.pos+1),indent:=sc.2127(ea.line),sc.2126(ea.line+1,indent+ind),sc.2126(ea.line+2,indent),GoToPos(ea.caret,sc.2128(ea.line+1))
				else{
					InsertMultiple(ea.caret,ea.pos,"`n",ea.pos+1),oindent:=indent:=sc.2127(ea.line),prevtext:=RemoveComment(sc.GetLine(ea.line-1)),text:=RemoveComment(sc.GetLine(ea.line))
					if(SubStr(text,0,1)="{"||sc.2223(ea.line)&0x2000)
						indent+=ind
					else if(RegExMatch(text,"iA)(}|\s)*#?\b(" v.indentregex ")\b",string))
						indent+=ind
					else if(RegExMatch(prevtext,"iA)(}|\s)*#?\b(" v.indentregex ")\b",string)&&SubStr(prevtext,0,1)!="{")
						indent:=sc.2127(ea.line-1)
					if(ea.skip)
						indent:=oindent
					sc.2126(ea.line+1,indent),GoToPos(ea.caret,sc.2128(ea.line+1))
				}
			}else if(state){
				if(ea.group!=lastgroup&&lastgroup!=""){
					sea:=map.EA("//*[@fix]")
					FixLines(sc.2166(sea.pos),sc.2166(sc.2353(sea.pos-1))-sc.2166(sea.pos))
					map.SSN("//*[@fix]").RemoveAttribute("fix")
				}
				if(ea.between){
					lea:=xml.EA(map.SSN("//*[@group='" ea.group "']"))
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
		while(aa:=all.item[A_Index-1]),ea:=xml.EA(aa)
			FixLines(sc.2166(ea.pos),sc.2166(sc.2353(ea.pos-1))-sc.2166(ea.pos))
		sc.2079
	}else if(focus="Edit1")
		QF("Enter")
	all:=map.SN("descendant::*[@line]")
	while(aa:=all.item[A_Index-1])
		aa.ParentNode.RemoveChild(aa)
	return sc.2169,MarginWidth(sc),sc.Enable(1)
}
Escape(){
	sc:=csc(),ShowOSD("Escape")
	ControlGetFocus,Focus,% hwnd([1])
	if(!InStr(Focus,"scintilla")){
		selections:=[],main:=sc.2575,sel:=sc.2570()
		Loop,% sc.2570()
			selections.Push([sc.2577(A_Index-1),sc.2579(A_Index-1)])
		sc.2400(),sc.2571()
		Sleep,0
		for a,b in selections
			(A_Index=1)?sc.2160(b.2,b.1):sc.2573(b.1,b.2)
		sc.2574(main),CenterSel()
	}
	v.DisableContext:=sc.2166(sc.2008),sc.2201
	if(InStr(Focus,"Scintilla"))
		Send,{Escape}
	DllCall("EndMenu")
}
ExecScript(){
	static exec,time,script
	shell:=ComObjCreate("WScript.Shell"),file:=Current(2).file
	v.RunObject[Current(2).file].exec.Terminate()
	SplitPath,file,,dir
	SetWorkingDir,%dir%
	exec:=shell.Exec("AutoHotkey.exe /ErrorStdOut " Chr(34) Current(2).file Chr(34))
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
			return m("Do it again but add #Include %A_ScriptDir% to the script")
		exec.Terminate(),sc:=csc(),info:=StripError(text,"*"),tv(SSN(files.Find(Current(1),"descendant::file/@file",info.file),"@tv").text),line:=info.line
		Sleep,100
		sc.2160(sc.2128(line),sc.2136(line)),sc.2200(sc.2128(line),text)
	}
}
Exit(ExitApp:=0){
	GuiClose:
	Save(3)
	WinGet,mm,MinMax,% MainWin.ID
	node:=MainWin.Gui.SSN("//win[@win=1]")
	fn:=MainWin.Gui.SN("//win[@win=1]/descendant::*[@type='Scintilla']")
	while(ff:=fn.item[A_Index-1]),ea:=XML.ea(ff){
		sc:=s.ctrl[ea.hwnd],doc:=sc.2357
		if(filename:=files.SSN("//*[@sc='" doc "']/@file").text)
			if(filename!="untitled.ahk")
				ff.SetAttribute("file",filename)
	}all:=files.SN("//open/*"),sc:=csc()
	while(aa:=all.item[A_Index-1])
		aa.ParentNode.RemoveChild(aa)
	open:=files.SN("//main"),top:=settings.Add("open")
	if(!GNode:=settings.SSN("//gui"))
		GNode:=settings.Add("gui")
	GNode.SetAttribute("zoom",sc.2374)
	while(oo:=open.item[A_Index-1]),ea:=XML.EA(oo)
		if(!settings.Find("//open/file",ea.file)&&ea.file!="Libraries"&&!ea.untitled)
			settings.Under(top,"file",,ea.file)
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
	node.SetAttribute("pos",MainWin.WinPos(MainWin.hwnd,1).text)
	while(ll:=last.item[A_Index-1])
		ll.RemoveAttribute("last")
	RCMXML.Save(1)
	MainWin.Gui.SSN("//*[@hwnd='" csc().sc "']").SetAttribute("last",1),MainWin.Gui.Save(1)
	menus.Save(1),GetPos(),positions.Save(1),TNotes.GetPos(),TNotes.XML.Save(1)
	Settings.Save(1)
	if(debug.socket)
		debug.Send("stop")
	if(ExitApp)
		Reload
	ExitApp
	return
}
Export(){
	indir:=settings.Find("//export/file/@file",SSN(Current(1),"@file").text),warn:=v.Options.Warn_Overwrite_On_Export?"S16":"S"
	FileSelectFile,filename,%warn%,% indir.text,Export Compiled AHK,*.ahk
	SplitPath,filename,,outdir
	filename:=InStr(filename,".ahk")?filename:filename ".ahk"
	FileDelete,%filename%
	file:=FileOpen(filename,"rw","UTF-8"),file.Seek(0),file.Write(Publish(1)),file.Length(file.length)
	if(!indir)
		indir:=settings.Add("export/file",{file:SSN(Current(1),"@file").text},,1)
	if(outdir)
		indir.text:=filename
}
Extract(mainfile){
	FileList:=[],file:=mainfile,pool:=[]
	if(!main:=files.Find("//main/@file",mainfile))
		main:=files.Under(files.SSN("//*"),"main",{file:mainfile,id:(inside:=id:=GetID())})
	SplitPath,mainfile,mfn,maindir,,mnne
	SplitPath,A_AhkPath,,ahkdir
	pool[maindir]:=1,pool[ahkdir]:=1
	if(!node:=files.Find(main,"descendant::file/@file",file))
		node:=files.Under(main,"file",{file:file,dir:maindir,filename:mfn,id:id,nne:mnne,scan:1})
	out:=SplitPath(mainfile)
	ExtractNext:
	id:=GetID(),fff:=FileOpen(file,"R"),encoding:=fff.encoding,text:=fff.Read(fff.length),fff.Close(),dir:=Trim(dir,"\")
	FileGetTime,time,%file%
	SplitPath,file,filename,dir,,nne
	set:=files.Find(node,"descendant-or-self::file/@file",file),set.SetAttribute("time",time),set.SetAttribute("encoding",encoding),pos:=1
	if(!SSN(set,"@id"))
		set.SetAttribute("id",id)
	StringReplace,text,text,`r`n,`n,All
	if(!Update({get:file}))
		Update({file:file,text:text,load:1,encoding:encoding})
	while(RegExMatch(text,"iOm`nU)^\s*\x23Include\s*,?\s*(.*)(\s+;.*)?$",found,pos)),pos:=found.pos(1)+found.len(1){
		info:=found.1,info:=RegExReplace(Trim(found.1,", `t`r`n"),"i)\Q*i\E\s*"),added:=0,orig:=info
		if(FileExist(info)="D")
			pool[Trim(info,"\")]:=1
		if(InStr(info,"%")){
			if(InStr(info,"%A_ScriptDir%")){
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
			}
			if(FileExist(fn:=A_MyDocuments "\AutoHotkey\lib\" info ".ahk")&&!libfile){
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
		}
		filelist.Delete(fn),file:=obj.file:=Trim(obj.file)
		if(!files.Find(node,"descendant::file/@file",file)){
			SplitPath,file,filename,dir,,nne
			new:=files.Under(files.Find(node,"descendant-or-self::file/@file",obj.inside),"file",obj)
			for a,b in {file:file,filename:filename,dir:dir,nne:nne,github:(maindir=dir?filename:"lib\" filename),scan:1}
				new.SetAttribute(a,b)
			qea:=xml.ea(new)
		}
		Goto,ExtractNext
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
		while(aa:=all.item[A_Index-1]),ea:=xml.EA(aa)
			aa.RemoveAttribute("tv")
		TVC.Delete(1,0),Libraries:=""
	}master:=files.SSN("//files"),mea:=xml.EA(master)
	if(!mea.tv)
		master.SetAttribute("tv",TVC.Add(1,"Projects"))
	projects:=SSN(master,"@tv").text,all:=files.SN("descendant::*[not(@tv)]")
	while(aa:=all.item[A_Index-1]),ea:=xml.ea(aa){
		if(aa.NodeName="folder"){
			aa.ParentNode.RemoveChild(aa)
			Continue
		}if(aa.NodeName="files"){
			Continue
		}if(aa.NodeName="main"){
			main:=aa,ea:=xml.EA(main),id:=ea.id,file:=ea.file
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
	,scidate:=20160512235500,XMLFiles:={menus:[20160723200034,"lib/menus.xml","lib\Menus.xml"],commands:[20160508000000,"lib/commands.xml","lib\Commands.xml"]}
	,OtherFiles:={scilexer:{date:20160418100600,loc:"SciLexer.dll",url:"SciLexer.dll",type:1},icon:{date:20150914131604,loc:"AHKStudio.ico",url:"AHKStudio.ico",type:1},Studio:{date:20151021125614,loc:A_MyDocuments "\Autohotkey\Lib\Studio.ahk",url:"lib/Studio.ahk",type:1}}
	,DefaultOptions:="Manual_Continuation_Line,Full_Auto_Indentation,Focus_Studio_On_Debug_Breakpoint,Word_Wrap_Indicators,Context_Sensitive_Help,Auto_Complete,Auto_Complete_In_Quotes,Auto_Complete_While_Tips_Are_Visible"
	/*
		Add in the opposite of all the "Disable" items
	*/
	if(!FileExist(A_MyDocuments "\Autohotkey\Lib")){
		FileCreateDir,% A_MyDocuments "\Autohotkey"
		FileCreateDir,% A_MyDocuments "\Autohotkey\Lib"
	}if(FileExist("lib\Studio.ahk"))
		FileMove,lib\Studio.ahk,%A_MyDocuments%\Autohotkey\Lib\Studio.ahk,1
	if(!file&&x:=ComObjActive("AHK-Studio")){
		x.Activate()
		ExitApp
	}if(file){
		if(file){
			if(!settings.ssn("//open/file[text()='" file "']"))
				settings.add("open/file",{select:1},file,1)
		}if(x:=ComObjActive("AHK-Studio")){
			x.Open(file),x.ScanFiles(),x.Show()
			ExitApp
	}}
	if((A_PtrSize=8&&A_IsCompiled="")||!A_IsUnicode){
		SplitPath,A_AhkPath,,dir
		if(!FileExist(correct:=dir "\AutoHotkeyU32.exe")){
			m("Requires AutoHotkey 1.1 to run")
			ExitApp
		}
		Run,"%correct%" "%A_ScriptName%",%A_ScriptDir%
		ExitApp
		return
	}for a,b in XMLFiles{
		if(!FileExist(b.3)){
			SplashTextOn,200,100,% "Downloading " b.2,Please Wait...
			UrlDownloadToFile,% base b.2,% b.3
		}
		SplashTextOff
		new:=%a%:=new XML(a,b.3)
		if(!new.SSN("//date"))
			new.Add("date",,b.1),new.Save(1)
		if(new.SSN("//date").text!=b.1){
			SplashTextOn,200,100,% "Downloading " b.2,Please Wait...
			if(a="menus"){
				temp:=new XML("temp"),temp.xml.LoadXML(URLDownloadToVar(base b.2)),all:=temp.SN("//*[@clean]")
				while(aa:=all.item[A_Index-1]),ea:=xml.ea(aa){
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
						if(DefaultOptions~="\b" ea.clean "\b") ;(DefaultOptions[ea.clean])
							settings.Add("options",{(ea.clean):1})
				}}Menus.Add("date",,b.1),Menus.Save(1)
			}else{
				UrlDownloadToFile,% base b.2,% b.3
				new:=%a%:=new XML(a,b.3),new.Add("date",,b.1),new.Save(1)
			}
			Options("Startup")
	}}for a,b in OtherFiles{
		FileGetTime,time,% b.loc
		if(time<b.date){
			SplashTextOn,200,100,% "Downloading " b.url,"Please Wait..."
			URLDownloadToFile,% base b.url,% b.loc
			SplashTextOff
	}}RegRead,value,HKCU,Software\Classes\AHK-Studio
	(!value)?RegisterID("{DBD5A90A-A85C-11E4-B0C7-43449580656B}","AHK-Studio"):""
	if(FileExist("lib\Scintilla.xml"))
		Scintilla()
	FileGetTime,time,SciLexer.dll
	if(!FileExist("SciLexer.dll")||time<scidate){
		SplashTextOn,200,100,Downloading SciLexer.dll,Please Wait....
		UrlDownloadToFile,%base%/SciLexer.dll,SciLexer.dll
	}
	SplashTextOff
}
Filename(filename){
	return newfile:=filename~="\.ahk$"?filename:filename ".ahk"
}
Find_Replace(){
	static
	infopos:=positions.Find("//*/@file",Current(3).file),last:=SSN(infopos,"@findreplace").text,ea:=settings.EA("//findreplace"),nw:=new GUIKeep(30),value:=[]
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
	info:=nw[],fr:=settings.Add("findreplace")
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
	if(RegExMatch(text:=Update({encoded:Current(3).file}),find,found,sc.2008+1)){
		return sc.2160(start:=StrPut(SubStr(text,1,found.Pos(0)),"utf-8")-2,start+StrPut(found.0,"utf-8")-1)
	}
	list:=info.Include?SN(Current(),"self::*"):SN(Current(1),"descendant::file")
	while,current:=list.Item[A_Index-1],ea:=xml.ea(current){
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
	sc:=csc(),info:=nw[],sc.2170(0,[RegExReplace(sc.GetSelText(),"\Q" info.find "\E",NewLines(info.replace))]),Update({sc:sc.2357})
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
			rep:=RegExReplace(text,find,replace),ea:=xml.EA(ll)
			if(ea.sc)
				tv(ea.tv),sc.2181(0,[rep]),sc.2160(v.tvpos.start,v.tvpos.end),sc.2613(v.tvpos.scroll)
			else
				Update({file:ea.file,text:rep})
			ll.SetAttribute("edited",1),TVC.Modify(1,(v.Options.Hide_File_Extensions?"*" ea.nne:"*" ea.filename),ea.tv),WinSetTitle(1,ea)
	}}return WinActivate(nw.id)
	frseg:
	GetPos(),info:=nw[],sc:=csc(),pre:="O",find:="",find:=info.regex?info.find:"\Q" RegExReplace(info.find, "\\E", "\E\\E\Q") "\E",pre.=info.greed?"":"U",pre.=info.cs?"":"i",pre.=info.ml?"":"m`n",find:=pre ")" find "",replace:=NewLines(info.replace),sc.2181(0,[RegExReplace(sc.GetText(),find,replace)]),SetPos(SSN(Current(),"@tv").text)
	return
}
Find(){
	static
	if(!FindXML)
		FindXML:=new XML("find"),FindXML.Add("top")
	sc:=csc(),order:=[],file:=Current(2).file,infopos:=positions.Find("//*/@file",file),last:=SSN(infopos,"@search").text,search:=last?last:"Type in your query here",ea:=settings.EA("//search/find"),newwin:=new GUIKeep(5),value:=[],order[sc.2585(0)]:=1,order[sc.2587(0)]:=1,last:=(order.MinIndex()!=order.MaxIndex())?sc.TextRange(order.MinIndex(),order.MaxIndex()):last
	for a,b in ea
		value[a]:=b?"Checked":""
	newwin.Add("Edit,gfindcheck w400 vfind r1,,w","TreeView,w400 h200 AltSubmit gstate,,wh","Checkbox,vregex gfindfocus " value.regex ",&Regex Search,y","Checkbox,vgr x+10 gfindfocus " value.gr ",&Greed,y","Checkbox,xm vcs gfindfocus " value.cs ",&Case Sensitive,y","Checkbox,vsort gfsort " value.sort ",Sort by &Include,y","Checkbox,vallfiles gfindfocus " value.allfiles ",Search in &All Files,y","Checkbox,vacdc gfindfocus " value.acdc ",Auto Close on &Double Click,y","Checkbox,vdaioc " value.daioc ",Disable Auto Insert On Copy,y","Button,gsearch Default,   Search   ,y","Button,gcomment,Toggle Comment,y"),newwin.Show("Search"),Hotkeys(5,{"^Backspace":"findback"})
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
		if(win=hwnd([5])&&newwin[].daioc=0)
			ControlSetText,Edit1,%Clipboard%,%win%
		if(WinActive(hwnd([30]))&&hwnd(30))
			ControlSetText,Edit1,%Clipboard%,%win%
	}
	return
	findback:
	GuiControl,5:-Redraw,Edit1
	ControlSend,Edit1,^+{Left}{Backspace},% hwnd([5])
	GuiControl,5:+Redraw,Edit1
	return
	findcheck:
	ControlGetText,Button,Button8,% hwnd([5])
	if(Button!="search")
		ControlSetText,Button8,Search,% hwnd([5])
	return
	search:
	ControlGetText,Button,Button8,% hwnd([5])
	if(InStr(button,"search")){
		top:=FindXML.ReCreate("//top","top"),info:=newwin[],count:=0
		if(!find:=info.find)
			return
		infopos.SetAttribute("search",find),foundinfo:=[]
		Gui,5:Default
		GuiControl,5:+g,SysTreeView321
		GuiControl,5:-Redraw,SysTreeView321
		list:=info.allfiles?files.SN("//file"):SN(current(1),"descendant::file"),TV_Delete()
		pre:="m`nO",pre.=info.cs?"":"i",pre.=info.greed?"":"U",parent:=0,ff:=info.regex?find:"\Q" find "\E"
		while(l:=list.item(A_Index-1),ea:=XML.EA(l)){
			out:=Update({get:ea.file}),pos:=1,r:=0,fn:=ea.file
			SplitPath,fn,file,,,nne
			while(RegExMatch(out,pre ")(.*(" ff ").*$)",found,pos),pos:=found.pos(2)+found.len(2)){
				if(info.sort&&lastl!=fn)
					parent:=TV_Add(nne)
				FindXML.Under(top,"info",{text:found.2,pos:StrPut(SubStr(out,1,found.pos(2)),"UTF-8")-2,file:ea.file,filetv:ea.tv,tv:TV_Add(nne " : " found.2 " : " found.1,parent)}),lastl:=fn,count++
		}}WinSetTitle(5,"Find: " count)
		if(TV_GetCount())
			ControlFocus,SysTreeView321
		GuiControl,5:+Redraw,SysTreeView321
		SetTimer,findlabel,-200
		GuiControl,5:+gstate,SysTreeView321
	}else if(Button="jump"){
		ea:=FindXML.EA("//*[@tv='" TV_GetSelection() "']"),Default("SysTreeView321",5),tv(ea.filetv),sc.2160(ea.pos,ea.pos+StrPut(ea.text,"UTF-8")-1),xpos:=sc.2164(0,ea.pos),ypos:=sc.2165(0,ea.pos)
		WinGetPos,xx,yy,ww,hh,% newwin.ahkid
		WinGetPos,px,py,,,% "ahk_id" sc.sc
		WinGet,trans,Transparent,% newwin.ahkid
		cxpos:=px+xpos,cypos:=py+ypos
		if(cxpos>xx&&cxpos<xx+ww&&cypos>yy&&cypos<yy+hh)
			WinSet,Transparent,50,% newwin.ahkid
		else if(trans=50)
			WinSet,Transparent,255,% newwin.ahk
		SetTimer,CenterSel,-10
		if(v.Options.Auto_Close_Find)
			return hwnd({rem:5})
		WinActivate(hwnd([5]))
	}else{
		sel:=TV_GetSelection(),TV_Modify(sel,ec:=TV_Get(sel,"E")?"-Expand":"Expand")
		SetTimer,findlabel,-200
	}
	return
	state:
	if(A_GuiEvent="DoubleClick"){
		info:=newwin[],ea:=foundinfo[TV_GetSelection()],SetPos({start:ea.start,end:ea.end,file:ea.file})
		if(info.acdc)
			goto,5Close
	}
	SetTimer,findlabel,-200
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
	ControlSetText,Button8,%Buttontext%,% hwnd([5])
	return
	fsort:
	ControlSetText,Button8,Search,% hwnd([5])
	goto,search
	return
	5Escape:
	5Close:
	ea:=newwin[],settings.Add("search/find",{daioc:ea.daioc,acdc:ea.acdc,regex:ea.regex,cs:ea.cs,sort:ea.sort,gr:ea.gr,allfiles:ea.allfiles}),foundinfo:="",infopos.SetAttribute("search",ea.find)
	newwin.SavePos(),hwnd({rem:5})
	return
	Comment:
	sc:=csc()
	toggle_comment_line()
	return
	FindFocus:
	ControlFocus,Edit1,% hwnd([5])
	return
}
FixLines(line,total,base:=""){
	tick:=A_TickCount,sc:=csc(),ind:=settings.Get("//tab",5),startpos:=sc.2008,code:=StrSplit((codetext:=sc.GetUNI()),"`n"),sc.Enable(),chr:="K",indentation:=sc.2121,lock:=[],block:=[],aaobj:=[],code:=StrSplit(codetext,"`n"),specialbrace:=skipcompile:=aa:=ab:=braces:=0,end:=total+line
	if(base="")
		base:=Round(sc.2127(line)/ind)
	Loop,% code.MaxIndex(){
		if(A_Index-1>total)
			Break
		text:=Trim(code[(a:=line+A_Index)],"`t ")
		if(text~="i)\Q* * * Compile_AH" Chr "\E"){
			skipcompile:=skipcompile?0:1
			Continue
		}
		if(skipcompile)
			Continue
		if(SubStr(text,1,1)=";"&&v.Options.Auto_Indent_Comment_Lines!=1)
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
		first:=SubStr(text,1,1),last:=SubStr(text,0,1),ss:=(text~="i)^\s*(&&|\bOR\b|\bAND\b|\.|\,|\|\||:|\?)\s*"),indentcheck:=(RegExMatch(text,"iA)}*\s*#?\b(" v.indentregex ")\b",string))
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
		if(!(ss&&v.Options.Manual_Continuation_Line)&&sc.2127(a-1)!=tind+(base*ind))
			sc.2126(a-1,tind+base*ind)
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
	}Update({sc:sc.2357}),SetStatus(A_ThisFunc " Process Time: " A_TickCount-tick "ms @ " A_TickCount " lines: " total,3)
}
Focus(a*){
	if(a.1=0){
		sc:=csc()
		if(sc.sc=TNotes.sc.sc)
			csc(2)
	}
	if(a.1=1&&A_Gui=1){
		csc().2400
		if(a&&v.Options.Check_For_Edited_Files_On_Focus=1)
			Check_For_Edited()
		return 0
	}
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
	if(v.Options.Full_Backup_All_Files){
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
		allfiles:=SN(current(1),"descendant::file/@file")
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
GetAllTopClasses(text:="",startline:=0,lines:=0){
	if(text)
		otext:=text
	else
		sc:=csc(),otext:=text:=sc.GetUNI()
	pos:=1,tops:=[]
	while(RegExMatch(text,v.OmniFind.Class,found)){
		if(!found.Len(1))
			Break
		CText:=GetClassText(text,found.2)
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
GetClassText(FileText,search,ReturnClass:=0){
	find:=v.OmniFindText.Class
	searchtext:=find.1 (IsObject(search)?search.2:search) find.2
	if(RegExMatch(FileText,searchtext,found,IsObject(search)?search.pos(0):1)){
		start:=pos:=found.pos(1)
		while(RegExMatch(FileText,"OUm`n)((?<SkipClose>^\s*\Q*/\E)|(?<SkipOpen>^\s*\Q/*\E)|(?<Close>^\s*}.*((\{)\s*(;.*)*)*)$)|((?<Open>.*\{)(\s+;.*)*(\s*)*$)",found,pos)),pos:=found.pos(0)+found.len(0){
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
GetCurrentClass(line){
	sc:=csc(),find:=oline:=line
	if(sc.2225(line)<0)
		return
	while((find:=sc.2225(find))>=0)
		line:=find
	text:=sc.TextRange(sc.2167(line),sc.2136(sc.2224(line,-1))),classes:=GetAllTopClasses(text,line,1)
	for a,b in classes
		if(b.linestart<=oline&&b.lineend>=oline){
			pos:=1,SearchClass:=GetClassText(text,a),max:=[],findline:=oline-b.linestart
			while(RegExMatch(SearchClass,v.OmniFind.Class,found,pos),pos:=found.pos(1)+found.len(1)){
				if(!found.len(1))
					Break
				text:=Trim(GetClassText(SubStr(SearchClass,found.pos(1)),found.2),"`n"),RegExReplace(SubStr(SearchClass,1,found.pos(1)),"\R",,start),RegExReplace(text,"\R",,end)
				if(findline>start&&findline<end+start)
					max[A_Index]:=found.2
			}node:=Current(5)
			for c,d in max
				node:=SSN(node,"info[@type='Class' and @text='" d "']")
			return {text:b.text,node:node,baseclass:a}
		}return
}			
GetID(){
	DllCall("QueryPerformanceCounter","Int64*",ID),id:=A_TickCount ID
	return id
}
GetInclude(){
	main:=current(2).file,sc:=csc()
	SplitPath,main,,dir
	FileSelectFile,filename,,%dir%,Select a file to include,*.ahk
	if(ErrorLevel||filename="")
		return
	newfile:=filename~="\.ahk$"?filename:filename ".ahk"
	Relative:=RelativePath(SSN(current(),"@file").text,newfile)
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
GetPos(All:=0){
	if(!current(1).xml)
		return
	sc:=csc(),current:=Current(2).file
	cf:=Current(3).file
	if(!top:=positions.Find("//main/@file",current))
		top:=positions.Add("main",{file:current},,1)
	if(!fix:=positions.Find(top,"descendant::*/@file",cf))
		fix:=settings.Under(top,"file",{file:cf})
	for a,b in {start:sc.2008,end:sc.2009,scroll:sc.2152,file:SSN(current(),"@file").text}
		fix.SetAttribute(a,b)
	fold:=0,ff:=0,fix.RemoveAttribute("fold")
	while,sc.2618(fold)>=0,fold:=sc.2618(fold)
		list.=fold ",",fold++
	if(list)
		fix.SetAttribute("fold",Trim(list,","))
}
GetRange(start,otext){
	start:=start-3>=0?start-3:0
	Loop,6
		text.=otext[start+(A_Index-1)]
	return text
}
GetTemplate(){
	ts:=settings.SSN("//template").text,file:=FileOpen("c:\windows\shellnew\template.ahk",0),td:=file.Read(file.length),file.Close()
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
Goto(){
	goto:
	sc:=csc(),InsertAll(",",1),list:=SN(cexml.Find("//file/@file",Current(3).file),"descendant::info[@type='Label']"),labels:=""
	while,ll:=list.item[A_Index-1]
		labels.=cexml.ea(ll).text " "
	Sort,labels,D%A_Space%
	if(Trim(Labels))
		sc.2100(0,Trim(labels))
	return
}
Gui(){
	v.startup:=1,this:=MainWin:=New MainWindowClass(1),ea:=settings.ea("//fonts/descendant::*[@style=5]"),win:=1,Plug()
	if(!settings.SSN("//fonts"))
		DefaultFont(),Options("Auto_Advance")
	Gui,Menu,% Menu("main")
	Gui,Margin,0,0
	Gui,Color,% RGB(ea.Background),% RGB(ea.Background)
	hwnd(1,this.hwnd)
	Gui,Add,StatusBar,hwndhwnd
	v.statushwnd:=hwnd
	ControlGetPos,,,,h,,ahk_id%hwnd%
	Gui,Add,TreeView,x0 y0 w0 h0 hwndpe +0x400000
	this.pe:=pe+0
	Gui,Add,TreeView,x0 y0 w0 h0 hwndce AltSubmit +0x400000 gCEGO
	TVC.Register(1,pe,"tv"),TVC.Register(2,ce,"CEGO")
	this.ce:=ce+0,TV_Add("Right Click to Refresh")
	Gui,Add,TreeView,hwndtn x0 y0 w0 h0 +0x400000 gtn
	this.tn:=tn+0
	TVC.Register(3,tn,"tn"),TNotes:=new Tracked_Notes()
	if(!this.gui.SSN("//control"))
		Gui,Show,Hide
	this.statusheight:=h
	if(!settings.SSN("//autoadd")){
		layout:=DllCall("GetKeyboardLayout",int,0),AltGR:=0
		if(layout&0xff!=9)
			if(m("Does your keyboard contain the AltGR key (AKA Alt Graph, Alt Graphic, Alt Graphics, Alt Char)","btn:yn")="Yes")
				AltGR:=1
		top:=settings.Add("autoadd",{altgr:Round(AltGR)}),layout:={0:{"[":"]","{":"}",(Chr(34)):Chr(34),"'":"'","(":")"},1:{"<^>[":"]","<^>{":"}",(Chr(34)):Chr(34),"'":"'","(":")"}}
		for a,b in layout[AltGR]
			settings.Under(top,"key",{trigger:a,add:b})
		opt:=settings.Add("options")
		for a,b in StrSplit("Manual_Continuation_Line,Full_Auto_Indentation,Focus_Studio_On_Debug_Breakpoint,Word_Wrap_Indicators,Context_Sensitive_Help,Auto_Complete,Auto_Complete_In_Quotes,Auto_Complete_While_Tips_Are_Visible",",")
			opt.SetAttribute(b,1),v.Options[b]:=1
	}BraceSetup(),open:=settings.SN("//open/file")
	while(oo:=open.item[A_Index-1])
		Extract(oo.text),opened:=1
	if(!opened)
		New(),FocusNew:=1
	FEList:=files.SN("//main")
	Hotkeys(),Index_Lib_Files(),FEUpdate()
	if((list:=this.Gui.SN("//win[@win='" win "']/descendant::control")).length){
		this.Rebuild(list),ea:=this.gui.EA("//*[@type='Tracked Notes']"),this.SetWinPos(ea.hwnd,ea.x,ea.y,ea.w,ea.h,ea),this.QuickFind(),this.Theme(),all:=MainWin.gui.SN("//*[@type='Scintilla' and @file]")
		while(aa:=all.item[A_Index-1]),ea:=xml.ea(aa){
			files.Find("//file/@file",ea.file).SetAttribute("sc",s.ctrl[ea.hwnd].2357)
			if(ea.file){
				pea:=xml.EA(nn:=positions.Find("//file/@file",ea.file))
				if(pea.start=""||pea.end="")
					SetPos({scroll:0,start:0,end:0,sc:ea.hwnd})
				else
					SetPos({scroll:pea.scroll,start:pea.start,end:pea.end,sc:ea.hwnd})
		}}if(last:=this.Gui.SSN("//*[@last]/@hwnd").text)
			s.ctrl[last].2400
		SetTimer,ScanFiles,-200
		this.Size([1]),ObjRegisterActive(PluginClass)
		SetTimer,SetTN,-600
		if(FocusNew)
			tv(files.SSN("//*[@untitled]/@tv").text)
		return this
	}this.qfhwnd:=this.QuickFind(),sc:=new s(1,{pos:"x0 y0 w100 h100"}),this.Add(sc.sc,"Scintilla"),sc.2277(v.Options.End_Document_At_Last_Line),this.test:=sc.sc,this.Pos(),Redraw(),ObjRegisterActive(PluginClass)
	Gui,Show,w800 h400 Center,Testing
	if(FocusNew)
		tv(files.SSN("//*[@untitled]/@tv").text)
	SetTimer,SetTN,-600
	return
	SetTN:
	/*
		ControlGetFocus,focus,% hwnd([1])
		ControlGet,hwnd,hwnd,,%focus%,% hwnd([1])
		
	*/
	TNotes.Set(),MarginWidth()
	SetTimer,ScanWID,-10
	SetupEnter(1)
	return
}
exit:
exit()
return
class GUIKeep{
	static table:=[],showlist:=[]
	__Get(){
		return this.add()
	}
	__New(win,parent:=""){
		info:=PluginClass.Style(),owner:=WinExist("ahk_id" parent)?parent:"" ;hwnd(1)
		if(FileExist(A_ScriptFullPath "\AHKStudio.ico"))
			Menu,Tray,Icon,%A_ScriptFullPath%\AHKStudio.ico
		owner:=owner?owner:1
		Gui,%win%:Destroy
		Gui,%win%:+owner%owner% +hwndhwnd -DPIScale
		Gui,%win%:+ToolWindow
		hwnd(win,hwnd)
		if(settings.SSN("//options/@Add_Margins_To_Windows").text!=1)
			Gui,%win%:Margin,0,0
		Gui,%win%:Font,% "c" info.color " s" info.size,% info.font
		Gui,%win%:Color,% info.Background,% info.Background
		this.xml:=new XML("gui"),this.gui:=[],this.sc:=[],this.hwnd:=hwnd,this.con:=[],this.ahkid:=this.id:="ahk_id" hwnd,this.win:=win,this.Table[win]:=this,this.var:=[],this.classcount:=[]
		for a,b in {border:A_OSVersion~="^10"?3:0,caption:DllCall("GetSystemMetrics",int,4)}
			this[a]:=b
		Gui,%win%:+LabelGUIKeep.
		Gui,%win%:Default
	}
	Add(info*){
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
			if(i.1="s"){
				for a,b in StrSplit("xywh")
					RegExMatch(i.2,"i)\b" b "(\S*)\b",found),newpos.=found1!=""?b found1 " ":""
				sc:=new s(this.win,{pos:Trim(newpos)}),this.sc.push(sc),hwnd:=sc.sc
			}else{
				Gui,% this.win ":Add",% i.1,% i.2 " hwndhwnd",% i.3
				WinGetClass,class,ahk_id%hwnd%
				count:=this.classcount[class]:=Round(this.classcount[class])+1
				this.XML.Add("control",{hwnd:hwnd,class:class count},,1)
				if(RegExMatch(i.2,"U)\bv(.*)\b",var))
					this.var[var1]:=1
			}this.con[hwnd]:=[]
			if(i.4!="")
				this.con[hwnd,"pos"]:=i.4,this.resize:=1
	}}
	Close(a:=""){
		this:=GUIKeep.table[A_Gui]
		if(IsFunc(func:=A_Gui "Close"))
			return %func%()
		else if(IsLabel(label:=A_Gui "Close"))
			SetTimer,%label%,-1
		else
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
		if(!top:=settings.SSN("//gui/position[@window='" this.win "']"))
			top:=settings.Add("gui/position",,,1),top.SetAttribute("window",this.win)
		top.text:=this.WinPos().text
	}
	SetWinPos(){
		DllCall("SetWindowPos",int,ctrl,int,0,int,x,int,y,int,w,int,h,uint,(ea.type~="Project Explorer|Code Explorer|QF")?0x0004|0x0010|0x0020:0x0008|0x0004|0x0010|0x0020)
		DllCall("RedrawWindow",int,ctrl,int,0,int,0,uint,0x401|0x2)
	}
	Show(name,position:="",NA:=0,Select:=0){
		static defpos,pos,sel,nn
		defpos:=position,this.GetPos(),pos:=this.resize=1?"":"AutoSize",this.name:=name,sel:=Select,NN:=NA
		if(this.resize=1)
			Gui,% this.win ":+Resize"
		GUIKeep.showlist.push(this)
		SetTimer,GUIKeepShow,-1
		return
		GUIKeepShow:
		while,this:=GUIKeep.Showlist.pop(){
			position:=settings.SSN("//gui/position[@window='" this.win "']").text,position:=position?position:defpos
			for a,b in ["x","y","w","h"]{
				if(position~="i)" b "\d+"=0){
					position:="AutoSize"
					break
			}}NA:=NN?"NA":""
			Gui,% this.win ":Show",% position " " pos " " NA,% this.name
			if(sel)
				SendMessage,0xB1,%sel%,%sel%,Edit1,% this.id
			this.Size()
			if(this.resize!=1)
				Gui,% this.win ":Show",AutoSize NA
			WinActivate,% this.id
		}return
	}
	Size(){
		this:=GUIKeep.table[A_Gui],pos:=this.WinPos()
		for a,b in this.gui{
			for c,d in b{
				GuiControl,% this.win ":MoveDraw",%a%,% c (c~="y|h"?pos.h:pos.w)+d
	}}}
	WinPos(){
		VarSetCapacity(rect,16),DllCall("GetClientRect",ptr,this.hwnd,ptr,&rect)
		WinGetPos,x,y,,,% this.ahkid
		w:=NumGet(rect,8),h:=NumGet(rect,12),text:=(x!=""&&y!=""&&w!=""&&h!="")?"x" x " y" y " w" w " h" h:""
		return {x:x,y:y,w:w,h:h,text:text}
	}
}
Header(type){
	node:=Current(7)
	if(!header:=SSN(node,"descendant::header[@type='" type "']/@cetv").text)
		cexml.Under(node,"header",{cetv:(header:=TVC.Add(2,type,SSN(node,"@cetv").text,"Sort")),type:type})
	return header
}
History(node,ctrl){
	if(!top:=History.SSN("//History[@hwnd='" ctrl.sc+0 "']"))
		top:=History.Under(History.SSN("//*"),"History",{hwnd:ctrl.sc+0})
	Remove:=SSN(top,"//forward"),Remove.ParentNode.RemoveChild(remove)
	if(!back:=SSN(top,"back"))
		back:=History.Under(top,"back")
	if(SSN(back.LastChild,"@file").text!=SSN(node,"@file").text)
		back.AppendChild(node.CloneNode(0))
	return
	Back:
	sc:=csc(),top:=History.SSN("//History[@hwnd='" sc.sc+0 "']")
	if(SN(top,"descendant::back/descendant::*").length<2)
		return
	node:=SSN(top,"descendant::back").LastChild
	if(!forward:=SSN(top,"descendant::forward"))
		forward:=History.Under(top,"forward")
	forward.AppendChild(node),node:=History.SSN("//History[@hwnd='" sc.sc+0 "']/descendant::back").LastChild,tv([SSN(node,"@tv").text])
	return
	Forward:
	sc:=csc(),top:=History.SSN("//History[@hwnd='" sc.sc+0 "']")
	if(node:=SSN(top,"descendant::forward").LastChild)
		tv([SSN(node,"@tv").text]),SSN(top,"descendant::back").AppendChild(node)
	return
}
hltline(){
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
		while(hh:=Hotkeys.item[A_Index-1]),ea:=xml.ea(hh){
			if(hh.text)
				Try{
					Hotkey,% hh.text,HotkeyLabel,On
					LastHotkeys[win,hh.text]:=1
				}
		}
		for a,b in {Delete:"Delete",Backspace:"Backspace","~Escape":"Escape","^a":"SelectAll","^v":"Paste",WheelLeft:"ScrollWheel",WheelRight:"ScrollWheel","~Ctrl":"ToggleDuplicate"} ;,Hotkeys(1,Enter)
			Hotkey,%a%,%b%,On
	}else{
		for a,b in keys{
			Try{
				if(!a)
					Continue
				Hotkey,%a%,Associate,On
				LastHotkeys[win,a]:=1,Associate[hwnd(win),a]:=b
			}catch e{
				m(e.message)
			}
		}
	}
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
		Run,% plugin.plugin " " plugin.options
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
		MainWindowClass.save(win.rem)
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
Include(MainFile,File){
	Relative:=RelativePath(MainFile,Filename(file))
	return "#Include " (SubStr(Relative,1,InStr(Relative,"\",0,0,1))="lib\"?"<" SplitPath(file).nne ">":relative)
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
			SplitPath,file,filename,dir,,nne
			if(filename="Studio.ahk")
				Continue
			FileGetTime,time,%file%
			new:=files.Under(main,"file",{file:file,dir:dir,filename:filename,nne:nne,inside:"Libraries",scan:1,id:GetID()}),fff:=FileOpen(file,"R"),encoding:=fff.encoding,text:=fff.read(fff.length),fff.Close(),dir:=Trim(dir,"\"),new.SetAttribute("time",time),new.SetAttribute("encoding",encoding)
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
Jump_To_First_Available(){
	sc:=csc(),GetPos(),line:=sc.GetLine(sc.2166(sc.2008))
	Scan_Line()
	v.jtfa:=[]
	if(RegExMatch(line,"Oi)^\s*\x23include\s*(.*)(\s*;.*)?$",found))
		Jump_To_Include()
	else{
		word:=Upper(sc.GetWord()),root:=Current(7)
		if(SubStr(word,1,1)="g"&&node:=SSN(root,"descendant::*[@upper='" Upper(SubStr(word,2)) "' and(@type='Label' or @type='Function')]")){
			return SelectText(node)
		}if(sc.2007((pos:=sc.2266(sc.2008,1)-1))=46){
			word2:=Upper(sc.TextRange(sc.2266(pos-1,1),sc.2267(pos-1,1)))
			if(node:=SSN(root,"descendant::*[@upper='" word2 "' and @type='Instance']")){
				if(node:=SSN(root,"descendant::*[@upper='" word "' and @class='" SSN(node,"@class").text "' and @type='Method']"))
					total.=(info:=SSN(node,"@type").text " " StrSplit(SSN(node,"ancestor-or-self::file[@file]/@file").text,"\").pop()) "|",v.jtfa[info]:=node
			}if(node:=SSN(root,"descendant::*[@upper='" word2 "' and @type='Class']")){
				if(node:=SSN(node,"descendant::*[@upper='" word "' and (@type='Method' or @type='Property')]"))
					total.=(info:=SSN(node,"@type").text " " StrSplit(SSN(node,"ancestor-or-self::file[@file]/@file").text,"\").pop()) "|",v.jtfa[info]:=node
			}else if((list:=cexml.SN(root,"descendant::*[@upper='" word "' and @type='Method']")).length){
				while(ll:=list.item[A_Index-1]),ea:=xml.ea(ll)
					total.=(info:=ea.type " " StrSplit(SSN(ll,"ancestor-or-self::file[@file]/@file").text,"\").pop()) "|",v.jtfa[info]:=ll
			}
		}if(node:=SSN(root,"descendant::*[@upper='" word "' and (@type='Function' or @type='Label')]"))
			total.=(info:=SSN(node,"@type").text " " StrSplit(SSN(node,"ancestor-or-self::file[@file]/@file").text,"\").pop()) "|",v.jtfa[info]:=node
		if(node:=SSN(root,"descendant::*[@upper='" word "' and @type='Class']"))
			total.=(info:=SSN(node,"@type").text " " StrSplit(SSN(node,"ancestor-or-self::file[@file]/@file").text,"\").pop()) "|",v.jtfa[info]:=node
		if((list:=cexml.SN(node,"descendant::*[@upper='" word "' and @type!='Method' and @type!='Function']")).length)
			while(ll:=list.item[A_Index-1]),ea:=xml.ea(ll)
				total.=(info:=ea.type " " StrSplit(SSN(ll,"ancestor-or-self::file[@file]/@file").text,"\").pop()) "|",v.jtfa[info]:=ll
		if(total:=Trim(total,"|")){
			GetPos(),sc.2106(124),sc.2117(6,total),sc.2660(1),sc.2106(32)
			if(!InStr(total,"|"))
				sc.2104
		}
	}
}
Jump_To(type){
	sc:=csc(),GetPos(),line:=sc.getline(sc.2166(sc.2008)),word:=Upper(sc.getword())
	if(node:=SSN(Current(7),"descendant::*[@type='" type "' and @upper='" word "']"))
		cexmlsel(node)
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
}cexmlsel(node){
	if(!IsObject(node))
		return
	tv(files.SSN("//*[@id='" SSN(node,"ancestor-or-self::file/@id").text "']/@tv").text),SelectText(xml.EA(node))
}Jump_To_Project(){
	Omni_Search("^")
}Jump_To_Matching_Brace(){
	sc:=csc(),cpos:=sc.2008
	if((pos:=sc.2353(cpos))>=0)
		sc.2025(pos)
	else if((pos:=sc.2353(cpos-1))>=0)
		sc.2025(pos+1)
}
Keywords(){
	list:=settings.SN("//commands/*"),top:=commands.SSN("//Commands/Commands")
	cmd:=Custom_Commands.SN("//Commands/commands"),col:=Custom_Commands.SN("//Color/*"),con:=Custom_Commands.SN("//Context/*")
	while,new:=cmd.item[A_Index-1].clonenode(1)
		commands.SSN("//Commands/Commands").replaceChild(new,commands.SSN("//Commands/commands[text()='" new.text "']"))
	while,new:=col.item[A_Index-1].clonenode(1)
		commands.SSN("//Color").replaceChild(new,commands.SSN("//Color/" new.nodename))
	while,new:=con.item[A_Index-1].clonenode(1)
		commands.SSN("//Context").replaceChild(new,commands.SSN("//Context/" new.nodename))
	v.keywords:=[],v.kw:=[],v.custom:=[],colors:=commands.SN("//Color/*")
	while,color:=colors.item[A_Index-1]{
		text:=color.text,all.=text " "
		stringlower,text,text
		v.color[color.nodename]:=text
	}
	personal:=settings.SSN("//Variables").text,all.=personal
	StringLower,per,personal
	v.color.Personal:=Trim(per),v.IndentRegex:=RegExReplace(v.color.indent," ","|"),command:=commands.SSN("//Commands/Commands").text
	Sleep,4
	Loop,Parse,command,%A_Space%,%A_Space%
		v.kw[A_LoopField]:=A_LoopField,all.=" " A_LoopField
	Sort,All,UD%A_Space%
	list:=settings.SSN("//custom_case_settings").text
	for a,b in StrSplit(list," ")
		all:=RegExReplace(all,"i)\b" b "\b",b)
	Loop,Parse,all,%a_space%
		v.keywords[SubStr(A_LoopField,1,1)].=A_LoopField " "
	v.all:=all,v.context:=[],list:=commands.SN("//Context/*")
	while,ll:=list.item[A_Index-1]{
		cl:=RegExReplace(ll.text," ","|")
		Sort,cl,UD|
		v.context[ll.NodeName]:=cl
	}
	return
}
LastFiles(){
	rem:=settings.SSN("//last"),rem.ParentNode.RemoveChild(rem)
	for a,b in s.main{
		file:=files.SSN("//*[@sc='" b.2357 "']/@file").text
		if(file)
			settings.add("last/file",,file,1)
	}
}
LButton(){
	if(!GetKeyState("LButton"))
		MouseClick,Left,,,,,U
	if(WinExist(hwnd([20])))
		hwnd({rem:20})
	return 0
}
MarginWidth(sc=""){
	sc:=sc?sc:sc:=csc(),sc.2242(0,sc.2276(32,"a" sc.2154))
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
		top:=v.hkxml.add("win",{hwnd:hwnd(1)},,1)
	Disable:=[]
	Menu,%menuname%,UseErrorLevel,On
	while,mm:=topmenu.item[A_Index-1],ea:=xml.ea(mm)
		if(mm.HasChildNodes())
			Menu,% ea.name,DeleteAll
	Menu,%menuname%,DeleteAll
	while,aa:=menu.item[A_Index-1],ea:=xml.ea(aa),pea:=xml.ea(aa.ParentNode){
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
			new:=v.hkxml.under(top,"hotkey",{hotkey:ea.hotkey,action:ea.clean})
		hotkey:=ea.hotkey?"`t" Convert_Hotkey(ea.hotkey):""
		Menu,%parent%,Add,% ea.name hotkey,menuroute
		if(Disable[parent,ea.name hotkey]){
			Menu,%parent%,Icon,% ea.name hotkey,Shell32.dll,23
			Menu,%parent%,Disable,% ea.name hotkey
		}if(value:=settings.SSN("//options/@" ea.clean).text){
			v.Options[ea.clean]:=value ;hmm
			Menu,%parent%,ToggleCheck,% ea.name hotkey
		}if(ea.icon!=""&&ea.filename)
			Menu,%Parent%,Icon,% ea.name hotkey,% ea.filename,% ea.icon
	}for a,b in track{
		if(!Exist[b.name])
			Menu,% b.parent,Delete,% b.name
		Menu,% b.parent,Add,% b.name,% ":" b.name
	}
	/*
		Sort,fixlist,U
		m(Clipboard:=fixlist)
		Hotkeys(1)
	*/
	Gui,1:Menu,%menuname%
	/*
		for a,b in Disable
			Menu,%a%,Disable,%b%
	*/
	return menuname
	MenuRoute:
	item:=clean(A_ThisMenuItem),ea:=menus.ea("//*[@clean='" item "']"),plugin:=ea.plugin,option:=ea.option
	if(IsFunc(item)||IsLabel(item))
		SetTimer,%item%,-1
	else if(plugin){
		if(!FileExist(plugin))
			MissingPlugin(plugin,A_ThisMenuItem)
		Run,% plugin " " option
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
MenuWipe(x:=0){
	all:=menus.SN("//*")
	if(x)
		Gui,1:Menu
	while,aa:=all.item[A_Index-1],ea:=xml.ea(aa){
		parent:=SSN(aa.ParentNode,"@name").text,hotkey:=SSN(aa,"@hotkey").text,hotkey:=hotkey?"`t" convert_hotkey(hotkey):"",current:=SSN(aa,"@name").text
		Menu,%parent%,Delete,% current hotkey
	}
 	while,aa:=all.item[A_Index-1],ea:=xml.ea(aa)
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
		}else
			return m("Unable to run this option.")
	}
}
Move_Selected_Lines_Down(){
	sc:=csc()
	OLine:=line:=sc.2166(sc.2143)
	if(line+1=sc.2154)
		return
	if(line+1>=sc.2154&&Trim(sc.GetLine(line))="")
		return
	sc.Enable(),sc.2078,start:=sc.2166(sc.2143),end:=sc.2166(sc.2145-1),LineStatus.StoreEdited(start,end,1),Edited()
	sc.2621
	if(v.Options.Full_Auto_Indentation)
		FixIndentArea()
	sc.Enable(1),LineStatus.UpdateRange(),sc.2079
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
m(x*){
	active:=WinActive("A")
	ControlGetFocus,Focus,A
	ControlGet,hwnd,hwnd,,%Focus%,ahk_id%active%
	static list:={btn:{oc:1,ari:2,ync:3,yn:4,rc:5,ctc:6},ico:{"x":16,"?":32,"!":48,"i":64}},msg:=[],msgbox
	list.title:="AHK Studio",list.def:=0,list.time:=0,value:=0,msgbox:=1,txt:=""
	for a,b in x
		obj:=StrSplit(b,":"),(vv:=List[obj.1,obj.2])?(value+=vv):(list[obj.1]!="")?(List[obj.1]:=obj.2):txt.=b "`n"
	msg:={option:value+262144+(list.def?(list.def-1)*256:0),title:list.title,time:list.time,txt:txt}
	Sleep,120
	MsgBox,% msg.option,% msg.title,% msg.txt,% msg.time
	msgbox:=0
	for a,b in {OK:value?"OK":"",Yes:"YES",No:"NO",Cancel:"CANCEL",Retry:"RETRY"}
		IfMsgBox,%a%
		{
			WinActivate,ahk_id%active%
			ControlFocus,%Focus%,ahk_id%active%
			return b
		}
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
NewIndent(indentwidth:=""){
	Critical
	static IncludeOpen
	tick:=A_TickCount
	filename:=current(3).file
	SplitPath,filename,,,ext
	sc:=csc(),sc.Enable(),skipcompile:=0,chr:="K",codetext:=sc.GetUni(),indentation:=sc.2121,line:=sc.2166(sc.2008),posinline:=sc.2008-sc.2128(line),selpos:=posinfo(),lock:=[],block:=[],aa:=ab:=braces:=0,code:=StrSplit(codetext,"`n"),aaobj:=[],specialbrace:=0,totalcount:=0
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
		first:=SubStr(text,1,1),last:=SubStr(text,0,1),ss:=(text~="i)^\s*(&&|\bOR\b|\bAND\b|\.|\,|\|\||:|\?)\s*"),indentcheck:=(RegExMatch(text,"iA)}*\s*#?\b(" v.indentregex ")\b",string))
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
		update({sc:sc.2357})
	*/
	if(indentwidth){
		SetStatus(A_ThisFunc " Process Time: " A_TickCount-tick "ms @ " A_TickCount,3)
		return sc.Enable(1)
	}if(braces&&!IncludeOpen)
		WinSetTitle(1,files.ea("//*[@sc='" sc.2357 "']"),1),IncludeOpen:=1
	else if(!braces&&IncludeOpen)
		WinSetTitle(1,files.ea("//*[@sc='" sc.2357 "']")),IncludeOpen:=0
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
New_Scintilla_Window(){
	this:=MainWin,sc:=csc(),pos:=this.WinPos(sc.sc),this.NewCtrlPos:={x:Floor(pos.x+(pos.w/2)),y:Floor(pos.y+(pos.h/2)),win:1,ctrl:sc.sc},this.Split(v.Options.New_Window_Below?"Below":"Right")
}
New_Include(){
	if(current(2).untitled)
		return m("You can not add Includes to untitled documents.  Please save this project before attempting to add Includes to it.")
	sc:=csc(),parent:=current(2).file
	SplitPath,parent,,dir
	FileSelectFile,Filename,S16,%dir%,New Include Name (Include),*.ahk
	if(ErrorLevel||Filename="")
		return
	Filename:=Filename(filename)
	SplitPath,Filename,,,,nne
	function:=Clean(nne)
	text:=(function~="i)^class_")?(m("Create Class called " (RegExReplace(SubStr(nne,InStr(nne," ")+1)," ","_")) "?","btn:ync")="Yes"?"Class " (RegExReplace(SubStr(nne,InStr(nne," ")+1)," ","_")) "{`n`t`n}":"",pos:=StrPut(nne "{`t","UTF-8")):(m("Create Function called " function "?","btn:ync")="Yes"?function "(){`n`t`n}":"",pos:=StrPut(function "(","UTF-8")-1)
	AddInclude(Filename,text,{start:pos,end:pos})
}
New(filename:="",text:=""){
	template:=GetTemplate()
	if(v.options.New_File_Dialog&&!filename){
		FileSelectFile,filename,S16,,Enter a filename for a new project,*.ahk
		if(!filename)
			return
		filename:=SubStr(filename,-3)=".ahk"?filename:filename ".ahk",file:=FileOpen(filename,"RW"),file.Seek(0),file.Write(template),file.Length(file.Position)
		if(FileExist(filename))
			return tv(Open(filename))
	}else
		filename:=(list:=files.SN("//main[@untitled]").length)?"Untitled" list ".ahk":"Untitled.ahk",Untitled:=1
	Update({file:filename,text:template,load:1,encoding:"UTF-8"})
	main:=files.Under(files.SSN("//*"),"main",{file:filename,id:(id:=GetID())})
	SplitPath,filename,mfn,maindir,,mnne
	node:=files.Under(main,"file",{file:filename,dir:maindir,filename:mfn,id:id,nne:mnne,scan:1})
	if(Untitled)
		main.SetAttribute("untitled",1),node.SetAttribute("untitled",1)
	FEUpdate(),ScanFiles(),tv(files.SSN("//*[@id='" id "']/@tv").text)
	return new
}
NewLines(text){
	for a,b in {"``n":"`n","``r":"`n","``t":"`t","\r":"`n","\t":"`t","\n":"`n"}
		StringReplace,text,text,%a%,%b%,All
	return text
}
Next_Found(){
	sc:=csc(),sc.2606,sc.2169,CenterSel()
}
Notify(csc*){
	static values:={0:"Obj",2:"Code",3:"position",4:"ch",5:"mod",6:"modType",7:"text",8:"length",9:"linesadded",10:"msg",11:"wparam",12:"lparam",13:"line",14:"fold",15:"prevfold",17:"listType",22:"updated",23:"Method"}
	static codeget:={2001:{ch:4},2005:{ch:4,mod:5},2006:{position:3,mod:5},2007:{updated:22},2008:{code:2,position:3,modType:6,text:7,length:8,linesadded:9,line:13,fold:14,prevfold:15},2010:{position:3},2011:{position:3},2014:{position:3,ch:4,text:7,listtype:17,Method:23},2016:{x:18,y:19},2019:{position:3,mod:5},2021:{position:3},2022:{position:3,ch:4,text:7,method:23},2027:{position:3,mod:5}},PreType:=[]
	static poskeep,savedel,stuff:=[]
	notify:
	static last,lastline,lastpos:=[],focus:=[],dwellfold:="",text
	if(csc.1=0)
		return lastpos:=[]
	fn:=[],info:=A_EventInfo,code:=NumGet(info+(A_PtrSize*2))
	if(code=2007){
		return UpPos()
	}if(code="")
		return
	if((ctrl:=NumGet(info+0))=v.debug.sc&&v.debug.sc){
		sc:=v.debug
		if(code=2027){
			style:=sc.2010(sc.2008)
			if(style=-106)
				Run_Program()
			else if(style=-105)
				List_Variables()
		}
		return
	}
	if(info=256||info=512||info=768)
		return
	sc:=csc({hwnd:NumGet(A_EventInfo+0)})
	if(code=2002)
		return current:=Current(),ea:=xml.EA(current),current.RemoveAttribute("edited"),TVC.Modify(1,v.Options.Hide_File_Extensions?ea.nne:ea.filename,ea.tv),WinSetTitle(1,ea),LineStatus.Save(ea.id),LineStatus.tv()
	if(code=2029){
		if(sc.2008&&sc.2009&&!v.startup)
			GetPos()
		return 0
	}
	if(code=2028){
		ea:=files.ea("//*[@sc='" sc.2357 "']"),list:=""
		/*
			ControlGetFocus,focus,% hwnd([1])
			ControlGet,hwnd,hwnd,,%focus%,% hwnd([1])
			sc:=csc({hwnd:hwnd})
		*/
		sc:=csc()
		sc.2400
		if(csc().sc=TNotes.sc.sc)
			WinSetTitle(1,"Tracked Notes")
		else
			WinSetTitle(1,ea:=files.ea("//*[@sc='" sc.2357 "']"))
		MouseGetPos,,,win
		if(win=hwnd(1))
			SetTimer,LButton,-200
		;if(sc.sc=v.tnsc.sc)
		;return 1
		;SetTimer,NotifyTN,-200
		;return 1
		;NotifyTN:
		;sc:=csc()
		;ea:=files.ea("//*[@sc='" sc.2357 "']")
		;if(tv:=v.tracked.SSN("//*[@file='" ea.file "']/@tv").text)
		;v.tngui.set(tv)
		;else
		;v.tngui.set(2)
		return 0
	}
	if(code=2017)
		sc.2201
	if code not in 2001,2006,2008,2010,2014,2022,2016,2019
		return 0
	for a,b in codeget[code]
		fn[a]:=NumGet(Info+(A_PtrSize*b))
	if(code=2016){
		pos:=sc.2023(fn.x,fn.y)
		word:=sc.TextRange(sc.2266(pos,1),sc.2267(pos,1))
		list:=debug.XML.SN("//property[@name='" word "']"),info:=""
		while(ll:=list.item[A_Index-1]),ea:=XML.EA(ll){
			info:=ea.type="object"?"Object: Use List Variables (Alt+M LV) to see more info":info.=SSN(ll,"ancestor::*/@name").text " = " ll.text "`n"
		}if(info){
			line:=sc.2166(pos)
			end:=sc.2136(line)
			ShowPos:=sc.2166(pos+3)=line?pos+3:pos
			sc.2200(ShowPos,word ": " Trim(info,"`n"))
		}else
			sc.2201
		return
	}if(v.tnsc=ctrl)
		TNotes.Write(),tn:=1
	if(fn.modType&0x400&&!tn){
		text:=StrGet(fn.text,fn.length,"UTF-8")
		line:=sc.2166(fn.position)
		if(!Current(3).edited)
			Edited()
		if(!v.LineEdited[line]){
			if(fn.modType&0x20||fn.modType&0x40){
				if(text){
					RegExReplace(text,"\R",,count)
					AddNewLines(text,Current(5))
					LineStatus.DelayAdd(line,count)
			}}else{
				SetScan(line)
				if(v.Options.Disable_Line_Status!=1){
					LineStatus.Add(line,2)
	}}}}else if(fn.modType&0x800&&!tn){
		if(!Current(3).edited)
			Edited()
		if(sc.2008=sc.2009&&fn.modType&0x20=0&&fn.modType&0x40=0){
			epos:=fn.position,del:=sc.2007(epos),poskeep:=""
		}
		start:=sc.2166(fn.position),end:=sc.2166(fn.position+fn.length)
		if(start!=end){
			RemoveLines(start,sc.2166(fn.position+fn.length-1))
		}else if(!v.LineEdited[start]){
			SetScan(start)
			if(v.Options.Disable_Line_Status!=1){
				LineStatus.Add(start,2)
			}
		}
	}if(code=2008&&fn.modType&0x02&&(fn.modtype&0x20=0&&fn.modtype&0x40=0)){
		del:=SubStr((DeletedText:=StrGet(fn.text,fn.length,"UTF-8")),1,1)
		if(fn.linesadded)
			MarginWidth(sc)
	}if(code=2008)
		SetTimer,UpdateUpdate,-200
	fn.code:=code,tn:=0
	if(fn.ch=125){
		SetTimer,FixBrace,-10
		return
	}if(fn.ch=10)
		return SetupEnter(1),line:=sc.2166(sc.2008),indent:=sc.2127(line-1),sc.2126(line,indent),sc.2025(sc.2128(line))
	if(code=2008&&fn.modType&0x01&&(fn.modtype&0x20=0&&fn.modtype&0x40=0)){
		if(sc.sc=v.tnsc.sc)
			v.TNGui.Write()
	}
	doc:=sc.2357
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
	}}if(code="2008"){
		if(sc.2423=3&&sc.2570>1){
			list:=[]
			Loop,% sc.2570
				list.push({caret:sc.2577(A_Index-1),anchor:sc.2579(A_Index-1)})
			for a,b in list{
				if(A_Index=1)
					sc.2160(b.anchor,b.caret)
				else
					sc.2573(b.caret,b.anchor)
	}}}if(fn.code=2010){
		margin:=NumGet(Info+(A_PtrSize*16)),line:=sc.2166(fn.position)
		if(margin=3)
			sc.2231(line)
		if(margin=1){
			line:=sc.2166(fn.position),shift:=GetKeyState("Shift","P"),ShiftBP:=v.Options.Shift_Breakpoint,text:=Trim(sc.GetLine(line)),search:=(shift&&ShiftBP||!shift&&!ShiftBP)?["*","UO)(\s*;\*\[(.*)\])","Breakpoint",";*[","]"]:["#","UO)(\s*;#\[(.*)\])","Bookmark",";#[","]"]
			if(pos:=RegExMatch(text,search.2,found)){
				start:=sc.2128(line),sc.2645(start+pos-1,StrPut(found.1,"UTF-8")-1),Scan_Line()
				if(ShiftBP&&shift||!shift&&!ShiftBP)
					if(debug.Socket>0){
						if(node:=files.SSN("//*[@id='" debug.id "']/descendant::*[@sc='" sc.2357 "']")){
							dea:=xml.EA(node)
							if(dobj:=debug.Breakpoints[dea.id])
								debug.Send("breakpoint_remove -d " dobj.id)
			}}}else{
				if(ShiftBP&&shift||!shift&&!ShiftBP)
					if(debug.Socket>0)
						if(node:=files.SSN("//*[@id='" debug.id "']/descendant::*[@sc='" sc.2357 "']"))
							debug.Send("breakpoint_set -t line -f " SSN(node,"@file").text " -n" line+1 " -i " SSN(node,"@id").text "|" line)
				name:=AddBookmark(line,search),Scan_Line()
	}}}if(fn.code=2022){
		if(v.Options.Autocomplete_Enter_Newline){
			SetTimer,Enter,-1
		}Else{
			v.word:=StrGet(fn.text,"UTF-8")
			if(A_ThisHotkey="("){
				SetTimer,notifynext,-1
				return
				notifynext:
				sc:=csc()
				Loop,% sc.2570{
					cpos:=sc.2585(A_Index-1)
					if(Chr(sc.2007(cpos))="(")
						GoToPos(A_Index-1,cpos+1)
					else
						InsertMultiple(A_Index-1,cpos,"()",cpos+1)
				}
				return
			}
			if(v.word="#Include"&&v.Options.Disable_Include_Dialog!=1){
				SetTimer,GetInclude,-200
			}else if(v.word~="i)\b(goto|gosub)\b"){
				SetTimer,goto,-100
			}else if(v.word="SetTimer"){
				SetTimer,ShowLabels,-80
			}else if(syntax:=commands.SSN("//Commands/commands[text()='" v.word "']/@syntax").text){
				if(SubStr(syntax,1,1)="(")
					SetTimer,AutoParen,-40
				else
					SetTimer,AutoMenu,-100
				return
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
				Sleep,20
				Context()
				return
			}else if(node:=SSN(cexml.Find("//main/@file",Current(2).file),"descendant::*[@text='" v.word "' and(@type='Class' or @type='Function' or @type='Instance')]")){
				type:=SSN(node,"@type").text
				if(type~="Class|Instance")
					SetTimer,AutoClass,-100
				else if(type="function")
					SetTimer,AutoParen,-40
			}
			else
				SetTimer,AutoMenu,-100
	}}
	if(fn.code=2001){
		/*
			if(fn.ch=46)
				if(fn.ch=46)
					Show_Class_Methods(sc.TextRange(sc.2266(sc.2008-1,1),sc.2267(sc.2008-1,1)))
		*/
		SetWords(1),cpos:=sc.2008,start:=sc.2266(cpos,1),end:=sc.2267(cpos,1),word:=sc.TextRange(start,cpos),SetWords()
		if(sc.2007(start-1)=46){
			if(Show_Class_Methods(pre:=sc.TextRange(sc.2266(start-2,1),sc.2267(start-2,1)),word))
				return
		}if((StrLen(word)>1&&sc.2102=0&&v.Options.Auto_Complete)){
			if((sc.2202&&!v.Options.Auto_Complete_While_Tips_Are_Visible)||(sc.2010(cpos)~="\b(13|1|11|3)\b"=1&&!v.Options.Auto_Complete_In_Quotes)){
			}else{
				word:=RegExReplace(word,"^\d*"),list:=Trim(v.keywords[SubStr(word,1,1)])
				if(v.words[sc.2357])
					list.=" " v.words[sc.2357]
				list.=" " Code_Explorer.AutoCList()
				if(node:=settings.Find("//autocomplete/project/@file",Current(2).file))
					list.=" " node.text
				Sort,list,UCD%A_Space%
				if(list&&InStr(list,word)&&word)
					sc.2100(StrLen(word),Trim(list))
		}}style:=sc.2010(cpos-2)
		if(v.Options.Context_Sensitive_Help)
			SetTimer,Context,-150
		c:=fn.ch
		if(c~="44|32")
			Replace()
		if(fn.ch=44&&v.Options.Auto_Space_Before_Comma){
			sc.2003(cpos-1," "),sc.2025(++cpos)
			if(v.Options.Auto_Space_After_Comma)
				sc.2003(cpos," ") ,sc.2025(cpos+1)
		}if(fn.ch=44&&v.Options.Auto_Space_After_Comma)
			sc.2003(cpos," "),sc.2025(cpos+1)
		ch:=fn.ch?fn.ch:sc.2007(sc.2008),UpPos(),SetStatus("Last Entered Character: " Chr(ch) " Code:" ch,2)
	}
	if(fn.code=2014){
		if(fn.listtype=1){
			if(!IsObject(scintilla))
				scintilla:=new xml("scintilla","lib\scintilla.xml")
			command:=StrGet(fn.text,"UTF-8"),info:=scintilla.SSN("//commands/item[@name='" command "']"),ea:=xml.ea(info),start:=sc.2266(sc.2008,1),end:=sc.2267(sc.2008,1),syn:=ea.syntax?ea.code "()":ea.code,sc.2160(start,end),sc.2170(0,[syn])
			if(ea.syntax)
				sc.2025(sc.2008-1),sc.2200(start,ea.code ea.syntax)
		}else if(fn.listType=2){
			vv:=StrGet(fn.text,"UTF-8"),start:=sc.2266(sc.2008,1),end:=sc.2267(sc.2008,1),sc.2645(start,end-start),sc.2003(sc.2008,vault.SSN("//*[@name='" vv "']").text)
			if(v.Options.Full_Auto_Indentation)
				SetTimer,NewIndent,-1
		}else if(fn.listType=3){
			text:=StrGet(fn.text,"UTF-8")
			loop,% sc.2570
				cpos:=sc.2585(A_Index-1),add:=sc.2007(cpos)=40?"":"()",start:=sc.2266(cpos,1),end:=sc.2267(cpos,1),sc.2686(start,end),send:=(reptext:=RegExReplace(text,"(\(|\))")) add,len:=StrPut(send,"UTF-8")-1,sc.2194(len,send),len:=StrPut(reptext,"UTF-8"),GoToPos(A_Index-1,cpos:=sc.2585(A_Index-1)+len)
		}else if(fn.listtype=4)
			text:=StrGet(fn.text,"UTF-8"),start:=sc.2266(sc.2008,1),end:=sc.2267(sc.2008,1),sc.2645(start,end-start),sc.2003(sc.2008,text "."),sc.2025(sc.2008+StrLen(text ".")),Show_Class_Methods(text)
		else if(fn.listtype=5){
			text:=StrGet(fn.text,"UTF-8"),start:=sc.2266(sc.2008,1),end:=sc.2267(sc.2008,1),add:=sc.2007(end)=40?"":"()",sc.2645(start,end-start),sc.2003(sc.2008,text add),sc.2025(sc.2008+StrLen(text "."))
			SetTimer,Context,-10
		}else if(fn.listtype=6){
			text:=StrGet(fn.text,"UTF-8"),list:=v.firstlist
			SetTimer,NJT,-50
			return
			NJT:
			ea:=xml.ea(ll:=v.jtfa[text]),obj:=[],obj.start:=ea.pos,obj.end:=obj.start+StrPut(ea.text,"UTF-8")-1,tv(files.SSN("//*[@id='" SSN(ll,"ancestor-or-self::file/@id").text "']/@tv").text),SelectText(ea)
			return
		}else if(fn.listtype=7){
			text:=StrGet(fn.text,"UTF-8"),s.ctrl[v.jts[text]].2400()
		}else if(fn.listtype=8){
			static methods
			text:=StrGet(fn.text,"UTF-8"),start:=sc.2266(sc.2008,1),end:=sc.2267(sc.2008,1),sc.2645(start,end-start),sc.2003(sc.2008,text (sc.2007(sc.2008)=46?"":".")),sc.2025(sc.2008+StrLen(text ".")),methods:="",node:=cexml.Find("//main/@file",Current(2).file,"descendant::info[@type='Class' and @upper='" Upper(text) "']/*[@type='Method']")
			while(nn:=node.item[A_Index-1]),ea:=xml.ea(nn)
				methods.=ea.text " "
			SetTimer,ShowMethod,-10
			return
			ShowMethod:
			KeyWait,Enter,U
			sc.2117(5,Trim(methods))
			return
		}else if(fn.listtype=9){
			/*
				for a,b in v.Options
					if(b>0&&b!="")
						Options(a),offlist.=a "`n"
				if(node:=settings.SSN("//quickoptions/profile[@name='" StrGet(fn.text,"UTF-8") "']/optionlist")){
					rem:=settings.SSN("//options"),rem.ParentNode.RemoveChild(rem),settings.Add("options",(ea:=xml.EA(node)))
					for a,b in ea
						if(v.Options[a]!=b)
							Options(a),onlist.=a "`n"
				}
			*/
			compare:=[]
			sea:=settings.EA("//quickoptions/profile[@name='" StrGet(fn.text,"UTF-8") "']/optionlist")
			for a,b in v.Options
				if(b)
					if(sea[a]!=b)
						Options(a)
			for a,b in sea
				if(b)
					if(v.Options[sea]!=b)
						Options(a)
			;m("Remove:",remove,"Add:",add)
			/*
				for a,b in v.Options
					if(!sea[a])
						m(a " is on and is not on in the new one")
			*/
			m("hmm...")
			;m("Off: " offlist,"On: " onlist)
			
			/*
				ToggleMenu(x)
				control:=x="Multi_Line"?"Multi-Line":RegExReplace(x,"_"," ")
				GuiControl,Quick_Find:,%control%,%onoff%
			*/
			
		}
	}
	return
	UpdateUpdate:
	Update({sc:csc().2357}),edited()
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
	static newwin,select:=[],obj:=[],pre,sort,search
	if(hwnd(20))
		return
	sc:=csc()
	if(sc.notes)
		csc({hwnd:gui.SSN("//*[@type='Scintilla']/@hwnd").text}),sc:=csc(),sc.2400
	if(v.LineEdited.MinIndex()!="")
		Scan_Line()
	Update({sc:sc.2357})
	Code_Explorer.AutoCList(1)
	newwin:=new GUIKeep(20),newwin.Add("Edit,goss w600 vsearch,,w","ListView,w600 h100 -hdr -Multi gosgo,Menu C|A|1|2|R|index,wh")
	Gui,20:-Caption
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
	break:=1
	SetTimer,omnisearch,-10
	return
	omnisearch:
	Gui,20:Default
	GuiControl,20:-Redraw,SysListView321
	FileSearch:=osearch:=search:=newwin[].search,Select:=[],LV_Delete(),sort:=[],stext:=[],fsearch:=search="^"?1:0
	if(InStr(search,")")){
		if(!v.options.Clipboard_History){
			Options("Clipboard_History")
			m("Clipboard History was off. Turning it on now")
			return
		}LV_Delete()
		for a in v.Clipboard
			b:=v.Clipboard[v.Clipboard.MaxIndex()-(A_Index-1)],Sort[LV_Add("",b)]:=b
		LV_ModifyCol(1,"AutoHDR")
		GuiControl,20:+Redraw,SysListView321
		return
	}for a in Omni_Search_Class.prefix{
		osearch:=RegExReplace(osearch,"\Q" a "\E")
		if(a!=".")
			FileSearch:=RegExReplace(FileSearch,"\Q" a "\E")
	}if(InStr(search,"?")||search=""){
		LV_Delete()
		for a,b in Omni_Search_Class.Prefix{
			info:=a="+"?"Add Function Call":b
			LV_Add("",a,info)
		}
		GuiControl,20:+Redraw,SysListView321
		Loop,4
			LV_ModifyCol(A_Index,"AutoHDR")
		LV_Modify(1,"Select Vis Focus")
		return
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
					find:="//main[@file='" current(2).file "']/descendant::*[@type='Class' or @type='Function'"
					break
				}else if(pre)
					add:="@type='" pre "'"
				find1.=index>1?" or " add:add
			}index++
		}for a,b in replist{
			search:=RegExReplace(search,"\Q" b "\E")
		}
		find:=find1?"//*[" find1 "]":"//*"
	}else
		find:="//*"
	/*
		if the first symbol in find is &
			make it so that it will just do a hotkey search for the rest of the text
		cause hotkeys have all the ^+etc that can cause issues with the search
		huck brought this up.
	*/
	if(OnlyTop&&!search)
		find:="//main/file[1]",OnlyTop:=0
	if(SubStr(newwin[].search,1,1)="&")
		search:=SubStr(newwin[].search,2),find:="//*[@type='Hotkey']"
	for a,b in searchobj:=StrSplit(search)
		b:=b~="(\\|\.|\*|\?|\+|\[|\{|\||\(|\)|\^|\$)"?"\" b:b,stext[b]:=stext[b]=""?1:stext[b]+1
	list:=cexml.SN(find),break:=0,currentparent:=Current(2).file,index:=1
	while(ll:=list.Item[A_Index-1],b:=xml.ea(ll)){
		if(break){
			break:=0
			break
		}order:=ll.nodename="file"?"filename,type,dir":b.type="menu"?"text,type,additional1":"text,type,file,args",info:=StrSplit(order,","),text:=b[info.1],rating:=0
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
		/*
			if(b.type="menu"){
				build:="",next:=ll
				while(SSN(next.ParentNode,"@clean").text){
					next:=next.ParentNode
					;full auto indentation
					;m(next.xml)
					build:=RegExReplace(SSN(next,"@text").text,"_"," ") "/" build
				}
				;t(build)
				;b.additional1:=build
			}
		*/
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
	}
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
	Gui,20:Default
	LV_GetText(num,LV_GetNext(),6),item:=xml.EA(node:=Select[num]),search:=newwin[].search,pre:=SubStr(search,1,1)
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
			comma:=a_index>1?",":"",value:=InputBox(sc.sc,"Add Function Call","Insert a value for : " b " :`n" item.text "(" item.args ")`n" build ")",""),value:=value?value:Chr(34) Chr(34),build.=comma value
		build.=")"
		sc.2003(sc.2008,build)
	}else if(item.type="file"){
		hwnd({rem:20}),tv(files.SSN("//*[@id='" item.id "']/@tv").text)
	}else if(item.type~="i)(breakpoint|label|instance|method|function|hotkey|class|property|variable|bookmark)"){
		if(!item.id)
			item.id:=SSN(node.ParentNode,"@id").text
		hwnd({rem:20}),tv(files.SSN("//*[@id='" item.id "']/@tv").text)
		Sleep,200
		if(item.type~="Bookmark|Breakpoint"){
			sc:=csc(),text:=sc.GetUNI(),pre:=SN(node,"preceding-sibling::*[@type='" item.type "' and @text='" item.text "']"),syntax:=v.OmniFindText[item.type],pos1:=1
			RegExMatch(text,syntax.1 item.text syntax.2,found,pos1)
			Loop,% 1+pre.length
				pos:=RegExMatch(text,syntax.1 item.text syntax.2,found,pos1),pos1:=found.Pos(1)+found.len(1)
			pos:=StrPut(SubStr(text,1,found.pos(0)),"UTF-8"),line:=sc.2166(pos),sc.2160(sc.2128(line),sc.2136(line)),hwnd({rem:20}),CenterSel()
		}else
			SelectText(item)
	}else if(item.type="gui"){
		hwnd({rem:20}),tv(files.SSN("//*[@id='" item.id "']/@tv").text)
		Sleep,200
		csc().2160(item.pos,item.pos+StrLen(item.text)),CenterSel()
		text:=update({get:item.file})
		if(search~=">.*>")
			m("Edit this GUI",SubStr(text,item.start,item.end-item.start))
		else
			m("Go to " item.text,SubStr(text,item.start,item.end-item.start))
	}else{
		m(A_TickCount,"Omni-Search",item.text,item.type,"Broken :(") ;leave this until I figure things out.
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
	if(!settings.SSN("//filetypes")){
		top:=settings.Add("filetypes")
		for a,b in StrSplit("ahk,txt,xml,htm,html",",")
			settings.Under(top,"type",,b)
	}
	if(!filelist){
		openfile:=current(2).file
		SplitPath,openfile,,dir
		Gui,1:+OwnDialogs
		list:=settings.SN("//filetypes/type"),extlist:=""
		while(ll:=list.item[A_Index-1]),ea:=XML.EA(ll)
			extlist.="*." ll.text "; "
		CloseID:=CloseSingleUntitled()
		FileSelectFile,filename,,%dir%,,% SubStr(extlist,1,-2)
		if(ErrorLevel)
			return
		if(!FileExist(filename))
			return m("File does not exist. Create a new file with File/New")
		SplitPath,filename,,,ext
		if(!settings.SSN("//filetypes/type[text()='" ext "']")){
			extlist:=""
			list:=settings.SN("//filetypes/type")
			while(ll:=list.item[A_Index-1]),ea:=XML.EA(ll)
				extlist.=ll.text "`n"
			if(m("AHK Studio by default can only open these file types:","",extlist,"","While " ext " files may be a text based file I had to add these restrictions to prevent opening media or other types of files","Would you like to add this to the list of acceptable extensions?","ico:!","btn:ync")="Yes")
				settings.Under(settings.SSN("//filetypes"),"type",,ext)
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
		filelist:=SN(files.Find("//main/@file",filename),"descendant::file"),TV(SSN(files.Find("//main/@file",filename),"file/@tv").text)
		ScanFiles(),Code_Explorer.Refresh_Code_Explorer(),PERefresh(),v.tngui.Populate()
	}else{
		CloseSingleUntitled()
		for a,b in StrSplit(filelist,"`n"){
			/*
				if(InStr(b,"'"))
					return m("Filenames and folders can not contain the ' character (Chr(39))")
			*/
			SplitPath,b,,,ext
			if(!settings.SSN("//filetypes/type[text()='" ext "']")){
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
	if(!settings.SSN("//open/file[text()='" filename "']"))
		settings.add("open/file",,filename,1)
	Gui,1:Default
	if(Redraw)
		GuiControl,1:+Redraw,SysTreeView321
	if(!v.opening)
		GuiControl,1:+gtv,SysTreeView321
	return
}
Options(x:=0){
	static list:={Virtual_Space:[2596,3],End_Document_At_Last_Line:2277,Show_EOL:2356,Show_Caret_Line:2096,Show_Whitespace:2021,Word_Wrap:2268,Hide_Indentation_Guides:2132,Center_Caret:[2403,0x04|0x08],Word_Wrap_Indicators:2460,Hide_Horizontal_Scrollbars:2130,Hide_Vertical_Scrollbars:2280},Disable,options,other
	if(x="startup"){
		v.Options:=[]
		disable:="Center_Caret|Disable_Autosave|Disable_Backup|Disable_Line_Status|Disable_Variable_List|Word_Wrap_Indicators|End_Document_At_Last_Line|Hide_File_Extensions|Hide_Indentation_Guides|Remove_Directory_Slash|Run_As_Admin|Show_Caret_Line|Show_EOL|Show_Type_Prefix|Show_WhiteSpace|Virtual_Space|Warn_Overwrite_On_Export|Word_Wrap|Hide_Horizontal_Scrollbars|Hide_Vertical_Scrollbars"
		options:="Add_Margins_To_Windows|Disable_Auto_Advance|Auto_Close_Find|Auto_Expand_Includes|Auto_Indent_Comment_Lines|Auto_Set_Area_On_Quick_Find|Auto_Space_After_Comma|Autocomplete_Enter_Newline|Build_Comment|Center_Caret|Check_For_Edited_Files_On_Focus|Auto_Check_For_Update_On_Startup|Clipboard_History|Copy_Selected_Text_on_Quick_Find|Disable_Auto_Complete|Auto_Complete_In_Quotes|Auto_Complete|Auto_Complete_While_Tips_Are_Visible|Disable_Auto_Delete|Disable_Auto_Indent_For_Non_Ahk_Files|Disable_Auto_Insert_Complete|Disable_Autosave|Disable_Backup|Disable_Compile_AHK|Context_Sensitive_Help|Disable_Folders_In_Project_Explorer|Disable_Include_Dialog|Disable_Line_Status|Disable_Variable_List|Enable_Close_On_Save|End_Document_At_Last_Line|Full_Auto_Indentation|Full_Backup_All_Files|Full_Tree|Hide_File_Extensions|Hide_Indentation_Guides|Highlight_Current_Area|Includes_In_Place|Manual_Continuation_Line|New_File_Dialog|OSD|Remove_Directory_Slash|Run_As_Admin|Shift_Breakpoint|Show_Caret_Line|Show_EOL|Show_Type_Prefix|Show_WhiteSpace|Small_Icons|Top_Find|Virtual_Scratch_Pad|Virtual_Space|Warn_Overwrite_On_Export|Word_Wrap|Regex|Case_Sensitive|Greed|Multi_Line|Require_Enter_For_Search|Omni_Search_Stats|Verbose_Debug_Window|Focus_Studio_On_Debug_Breakpoint|Select_Current_Debug_Line|Global_Debug_Hotkeys|Smart_Delete|Auto_Variable_Browser"
		other:="Auto_Space_After_Comma|Auto_Space_Before_Comma|Autocomplete_Enter_Newline|Disable_Auto_Delete|Disable_Auto_Insert_Complete|Disable_Folders_In_Project_Explorer|Disable_Include_Dialog|Enable_Close_On_Save|Full_Tree|Highlight_Current_Area|Manual_Continuation_Line|Small_Icons|Top_Find|Hide_Tray_Icon|Match_Any_Word"
		alloptions.=disable "|" options "|" other
		Sort,alloptions,UD|
		for a,b in StrSplit(alloptions,"|")
			v.Options[b]:=0
		if(settings.SSN("//options[@Auto_Project_Explorer_Width]"))
			settings.SSN("//options").RemoveAttribute("Auto_Project_Explorer_Width")
		opt:=settings.EA("//options")
		for a,b in opt{
			if(v.Options.HasKey(a)&&b)
				v.Options[a]:=b
			else
				settings.SSN("//options").RemoveAttribute(a)
		}
		return
	}
	if(x~=Disable){
		sc:=csc(),onoff:=settings.SSN("//options/@" x).text?0:1,att:=[],att[x]:=onoff,settings.Add("options",att),ToggleMenu(x),v.Options[x]:=onoff,sc[list[x]](onoff),ea:=settings.EA("//options")
		for c,d in s.ctrl{
			for a,b in ea{
				if(!IsObject(list[a])){
					if(a~="Hide_Indentation_Guides|Hide_Horizontal_Scrollbars|Hide_Vertical_Scrollbars")
						b:=b?0:1
					d[list[a]](b)
				}Else if IsObject(list[a])&&b
					d[list[a].1](list[a].2,list[a].3)
				else if IsObject(list[a])&&onoff=0
					d[list[a].1](0)
		}}
		if(x="Hide_Indentation_Guides")
			onoff:=onoff?0:1,sc[list[x]](onoff)
		if(x="Word_Wrap_Indicators")
			onoff:=onoff?4:0,sc[list[x]](onoff)
		if(x="Hide_File_Extensions"||x=""){
			fl:=files.SN("//file")
			GuiControl,1:-Redraw,SysTreeView321
			while(ff:=fl.item[A_Index-1]),ea:=xml.ea(ff)
				TVC.Modify(1,(ea.edited?"*":"")(v.Options.Hide_File_Extensions?ea.nne:ea.filename),ea.tv)
			GuiControl,1:+Redraw,SysTreeView321
		}if(x="Remove_Directory_Slash")
			FEUpdate(1)
		if(x="margin_left")
			csc().2155(0,6)
	}else if(x~=other){
		onoff:=settings.SSN("//options/@" x).text?0:1,att:=[],att[x]:=onoff,settings.add("options",att),ToggleMenu(x)
		if(x="Small_Icons")
			return m("Requires that you restart Studio to take effect.")
		if(x="Highlight_Current_Area"){
			if(onoff)
				hltline()
			Else
				sc:=csc(),sc.2045(2),sc.2045(3)
		}if(x="Hide_Tray_Icon")
			Menu,Tray,NoIcon
		v.Options[x]:=onoff
		if(x="Top_Find")
			this:=MainWin,this.TL:={x:0,y:v.Options.Top_Find?21:0},this.BR:={x:0,y:v.Options.Top_Find?0:21},this.Size([1]),Redraw()
		if(x~="i)Disable_Folders_In_Project_Explorer|Full_Tree")
			FEUpdate(1)
	}else{
		onoff:=settings.SSN("//options/@" x).text?0:1,att:=[],att[x]:=onoff,v.Options[x]:=onoff,settings.add("options",att),ToggleMenu(x)
	}
	if(x~="Regex|Case_Sensitive|Greed|Multi_Line"){
		ToggleMenu(x)
		control:=x="Multi_Line"?"Multi-Line":RegExReplace(x,"_"," ")
		GuiControl,Quick_Find:,%control%,%onoff%
	}
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
		Gui,win:Show,% "x" (x+w-v.Border)-(300) " y" y+v.caption+v.menu+v.Border+(v.options.top_find?v.qfh:0) " NA AutoSize",OSD
		top:=list.Add("list")
	}show:=RegExReplace(show,"_"," ")
	Gui,win:Default
	Gui,win:ListView,SysListView321
	if((ea:=xml.ea(node:=list.SSN("//list").LastChild())).name=show)
		node.SetAttribute("count",ea.count+1)
	else
		node:=list.under(top,"item",{name:show,count:1})
	LV_Delete()
	all:=list.SN("//item")
	while,aa:=all.item[A_Index-1],ea:=xml.ea(aa)
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
	}
	sc:=csc(),line:=sc.2166(sc.2008),sc.2078,sc.2179,MarginWidth(sc),Edited(),RegExReplace(Clipboard,"\n",,count)
	Loop,% count+1
		LineStatus.Add(line+(A_Index-1),2)
	if(v.Options.Full_Auto_Indentation)
		FixIndentArea()
	sc.2079
	SetTimer,Scan_Line,-1
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
		rem.ParentNode.RemoveChild(rem),LV_Delete(LV_GetNext())
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
	6Close:
	6Escape:
	keywords(),newwin.SavePos(),hwnd({rem:6})
	return
}
Plug(refresh:=0){
	if(!FileExist("plugins"))
		FileCreateDir,Plugins
	plHks:=[]
	if(refresh){
		list:=menus.SN("//main/menu[@clean='Plugin']/menu")
		while,ll:=list.item[A_Index-1],ea:=xml.ea(ll)
			if(!FileExist(ea.plugin))
				ll.ParentNode.RemoveChild(ll)
	}
	Loop,Files,plugins\*.ahk
	{
		if(!plugin:=menus.SSN("//menu[@clean='Plugin']"))
			plugin:=menus.Add("menu",{clean:"Plugin",name:"P&lugin"},,1)
		FileRead,plg,%A_LoopFileFullPath%
		pos:=1
		while,pos:=RegExMatch(plg,"Oim)\;menu\s+(.*)\R",found,pos){
			item:=StrSplit(found.1,","),item.1:=Trim(item.1,"`r|`r`n|`n")
			if(!ii:=menus.SSN("//*[@clean='" clean(Trim(item.1)) "']"))
				menus.under(plugin,"menu",{name:Trim(item.1),clean:clean(item.1),plugin:A_LoopFileFullPath,option:item.2,hotkey:plHks[item.1]})
			else
				ii.SetAttribute("plugin",A_LoopFileFullPath),ii.SetAttribute("option",item.2)
			pos:=found.Pos(1)+1
		}
	}
	if(refresh)
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
Previous_Found(){
	sc:=csc(),current:=sc.2575,total:=sc.2570-1,(current=0)?sc.2574(total):sc.2574(--current),CenterSel()
}
Publish(return=""){
	sc:=csc()
	text:=Update("get").1
	Save()
	mainfile:=Current(2).file
	publish:=Update({encoded:mainfile})
	includes:=SN(Current(1),"descendant::*/@include/..")
	number:=SSN(vversion.Find("//info/@file",Current(2).file),"descendant::version/@number").text
	while,ii:=includes.item[A_Index-1]
		if(InStr(publish,SSN(ii,"@include").text))
			StringReplace,publish,publish,% SSN(ii,"@include").text,% Update({encoded:SSN(ii,"@file").text}),All
	rem:=SN(Current(1),"descendant::remove")
	while,rr:=rem.Item[A_Index-1]
		publish:=RegExReplace(publish,"m)^\Q" SSN(rr,"@inc").text "\E$")
	change:=settings.SSN("//auto_version").text?settings.SSN("//auto_version").text:"Version:=" Chr(34) "$v" Chr(34)
	if(InStr(publish,Chr(59) "auto_version"))
		publish:=RegExReplace(publish,Chr(59) "auto_version",RegExReplace(change,"\Q$v\E",number))
	publish:=RegExReplace(publish,"U)^\s*(;{.*\R|;}.*\R)","`n")
	StringReplace,publish,publish,`n,`r`n,All
	if(!publish)
		return sc.GetEnc()
	if(return)
		return publish
	Clipboard:=v.Options.Full_Auto_Indentation?PublishIndent(publish):publish
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
	ControlGetText,Find,Edit1,% hwnd([1])
	if(Find=lastFind&&sc.2570>1){
		if(GetKeyState("Shift","P"))
			return current:=sc.2575,sc.2574((current=0)?sc.2570-1:current-1),CenterSel()
		return sc.2606(),CenterSel()
	}
	pre:="O",Find1:="",Find1:=v.Options.Regex?Find:"\Q" RegExReplace(Find,"\\E","\E\\E\Q") "\E",pre.=v.options.greed?"":"U",pre.=v.options.case_sensitive?"":"i",pre.=v.options.multi_line?"m`n":"",Find1:=pre ")" Find1 ""
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
	start:=1,rem:=MinMax.SSN("//list"),rem.ParentNode.RemoveChild(rem),top:=MinMax.add("list")
	while,(start<sc.2006){
		min:=sc.2508(2,start),max:=sc.2509(2,start)
		if((min!=0||max!=0)&&sc.2507(2,min))
			MinMax.under(top,"sel",{min:min,max:max})
		if(min=0&&max=0){
			MinMax.under(top,"sel",{min:0,max:sc.2006})
			break
		}
		if(min||max)
			start:=max
	}
	search:=sc.GetText(),pos:=1
	while,RegExMatch(search,Find1,found,pos){
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
		while,obj:=select.items.pop(){
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
	if(v.options.Copy_Selected_Text_on_Quick_Find)
		if(text:=sc.TextRange(sc.2143,sc.2145))
			ControlSetText,Edit1,% text,% hwnd([1])
	if(v.options.Auto_Set_Area_On_Quick_Find)
		gosub,Set_Selection
	ControlFocus,Edit1,% hwnd([1])
	ControlSend,Edit1,^A,% hwnd([1])
	lastFind:=""
	return
	Case_Sensitive:
	Regex:
	Multi_Line:
	Greed:
	Options(A_ThisLabel),lastFind:=""
	ControlGetText,text,Edit1,% hwnd([1])
	if(text)
		goto,qf
	return
}
Quick_Find(){
	ControlGetFocus,Focus,% MainWin.ID
	if(Focus="Edit1"){
		Sleep,200
		csc().2400
	}else
		ControlFocus,Edit1,% MainWin.ID
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
Redo(){
	csc().2011
}
Redraw(){
	WinSet,Redraw,,% MainWin.ID
}
Refresh_Code_Explorer(){
	Save(),currentfile:=Current(3).file,cexml:=new XML("cexml"),files:=new xml("files"),sc.2358(0,0)
	;cexml.xml.preserveWhiteSpace:=1
	Loop,2
		TVC.Delete(A_Index,0)
	TVC.Add(2,"Please Wait..."),new Omni_Search_Class(),open:=settings.SN("//open/file"),Index_Lib_Files()
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
Refresh(){
	parents:=gui.sn("//*"),Default:=xml.ea("//fonts/font[@style='5']")
	while(pp:=parents.item[A_Index-1]),ea:=xml.ea(pp){
		if(ea.win){
			Gui,% ea.win ":Color",% Default.Background,% default.Background
			WinSet,Redraw,,% "ahk_id" ea.parent
		}
	}
	for a,b in s.Ctrl{
		if(settings.ssn("//fonts/font[@style='34']"))
			b.2498(0,8)
		Color(b)
	}
}
RefreshThemes(){
	static bcolor,fcolor
	if(node:=settings.ssn("//fonts/custom[@gui='1' and @control='msctls_statusbar321']"))
		SetStatus(node)
	else
		SetStatus(settings.ssn("//fonts/font[@style='5']"))
	ea:=settings.ea("//fonts/font[@style='5']")
	default:=ea.clone()
	cea:=settings.ea("//fonts/find")
	tf:=v.options.top_find
	bcolor:=(cea.tb!=""&&tf)?cea.tb:(cea.bb!=""&&!tf)?cea.bb:ea.Background
	fcolor:=(cea.tf!=""&&tf)?cea.tf:(cea.bf!=""&&!tf)?cea.bf:ea.Color
	for win,b in hwnd("get"){
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
		}}
		ControlGetPos,,,,h,,% "ahk_id" v.statushwnd
		v.status:=h
		SendMessage,0x2001,0,%bcolor%,,% "ahk_id" v.statushwnd
	}
	if(settings.ssn("//fonts/font[@style='34']"))
		2498(0,8)
	if(number:=settings.ssn("//fonts/font[@code='2188']/@value").text)
		for a,b in s.ctrl
			b.2188(number)
	Refresh()
	return
}
RegexSettings(){
	ControlGet,Check,Checked,,%A_GuiControl%,% MainWin.ID
	Options(Clean(A_GuiControl))
	;settings.Add("options",{(Clean(A_GuiControl)):Check}),v.Options[Clean(A_GuiControl)]:=Check,sc:=csc(),cpos:=sc.2009,sc.2571,sc.2025(cpos),QF(1),ToggleMenu(clean(A_GuiControl))
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
Remove_Scintilla_Window(){
	this:=MainWin,sc:=csc(),pos:=this.WinPos(sc.sc),this.NewCtrlPos:={x:pos.x,y:pos.y,win:MainWin.hwnd,ctrl:sc.sc},this.Delete()
}
RemoveAllButClass(RemoveClassText,current){
	for a,b in v.OmniFind{
		if(a~="Property|Class")
			Continue
		pos:=1
		while(RegExMatch(RemoveClassText,b,found,pos),pos:=found.Pos(1)+found.Len(1)){
			if(!found.len(1))
				Break
			Code_Explorer.RemoveItem(current,a,found.1)
}}}
RemoveLines(start,end){
	static current,Classes,AllText,OText,node
	current:=Current(5),sc:=csc(),StartScan:=sc.2167(start),AllText:=sc.GetUNI(),EndScan:=sc.2136(end),LineStatus.Delete(start,end),Classes:=[]
	if(StartScan>EndScan)
		return
	if(start=end&&sc.2127(start)=0)
		return
	RemoveClassText:=text:=OText:=sc.TextRange(StartScan,EndScan)
	if(!Trim(OText))
		return
	for a,b in [start,end]
		if(sc.2225(b)>=0){
			while((b:=sc.2225(b))>=0)
				if(RegExMatch(ScanLines(b).text,v.OmniFind.Class,found))
					lastclass:=found.2
			Classes.push(lastclass)
		}
	if(Classes.1==Classes.2&&Classes.1)
		node:=SSN(current,"descendant::*[@type='Class' and @text='" Classes.1 "']"),RemoveAllButClass(text,current),Code_Explorer.RemoveTV(SN(node,"descendant-or-self::*"))
	else if(!Classes.1&&!Classes.2){
		RemoveAllButClass(text,current)
	}else if(Classes.1||Classes.2){
		class1:=GetClassText(AllText,Classes.1),class2:=GetClassText(AllText,Classes.2),Class(class1,current,1),Class(class2,current,1)
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
	Class(GetClassText(csc().GetUNI(),Classes.1),current)
	GuiControl,1:+Redraw,SysTreeView322
	return
}
RemoveOldLines(text,current){
	UpdateWordsInDocument(text,1)
	for a,b in classes:=GetAllTopClasses(text){
		RegExMatch(b.text,v.OmniFind.Class,found)
		if((nodes:=SN(current,"descendant::*[@type='Class' and @text='" found.2 "']")).length){
			Code_Explorer.RemoveTV(SN(current,"descendant::*[@type='Class' and @text='" found.2 "']"))
			for c,d in v.OmniFind{
				if(c~="Class|Function|Property")
					Continue
				pos:=1
				while(RegExMatch(text,d,found,pos),pos:=found.Pos(1)+found.Len(1)){
					if(!found.Len(1))
						Break
					if(node:=SSN(current,"descendant::*[@type='" c "' and @text='" found.1 "']")){
						if(tv:=SSN(node,"@cetv").text)
							TVC.Delete(2,tv)
						node.ParentNode.RemoveChild(node)
			}}}
			Code_Explorer.RemoveTV(nodes)
		}
		StringReplace,text,text,% b.text
	}
	for a,b in v.OmniFind{
		if(a~="Class|Property")
			Continue
		pos:=1
		while(RegExMatch(text,b,found,pos),pos:=found.Pos(1)+found.Len(1)){
			if(!found.len(1))
				Break
			if((nodes:=SN(current,"descendant::*[@type='" a "' and @text='" found.1 "']")).length)
				Code_Explorer.RemoveTV(nodes)
		}
	}
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
	sc:=csc(),cp:=sc.2008,word:=sc.TextRange(start:=sc.2266(cp-1,1),end:=sc.2267(cp-1,1)),rep:=settings.SSN("//replacements/*[@replace='" word "']").text
	if(!rep)
		return
	sc.2078
	pos:=1,list:=[],foundList:=[],origRepLen:=StrLen(rep)
	while,pos:=RegExMatch(rep,"U)(\$\||\$.+\b)",found,pos){
		if(!ObjHasKey(foundList,found))
			foundList[found]:=pos,List.Insert(found)
		pos++
	}
	for a,b in List{
		value:=""
		if(b!="$|"){
			value:=InputBox(sc,"Value for " b,"Insert value for: "  b "`n`n" rep)
			StringReplace,rep,rep,%b%,%value%,All
	}}if(rep){
		pos:=InStr(rep,"$|"),rep:=RegExReplace(rep,"\$\|"),ind:=sc.2127(line:=sc.2166(sc.2143)),sc.2190(start),sc.2192(end),sc.2194(StrLen(rep),rep),_:=pos?sc.2025(start+pos-1):"",RegExReplace(rep,"\R",,count)
		Loop,%count%
			sc.2126(line+A_Index,ind)
	}else if(A_ThisHotkey="+Enter")
		sc.2160(start+StrLen(rep),start+StrLen(rep))
	if(v.Options.Auto_Space_After_Comma)
		sc.2003(sc.2008," "),sc.2025(sc.2008+1)
	v.word:=rep?rep:word
	SetTimer,AutoMenu,-80
	sc.2079(),sc.Enable(1)
}
Reset_Zoom(){
	csc().2373(0),settings.ssn("//gui/zoom").text:=0,CenterSel()
}
RGB(c){
	setformat,IntegerFast,H
	c:=(c&255)<<16|c&65280|c>>16 ""
	SetFormat,integerfast,D
	return c
}
Right_Click_Menu_Editor(menu){
	static TVRCM:=new EasyView(),nw,node,lastevent,find:=[]
	nw:=new GUIKeep("RCMEditor"),node:=RCMXML.SSN("//main[@name='" menu "']")
	nw.Add("ListView,w200 h150 AltSubmit,Menus","TreeView,x+M w300 h400,,wh","ComboBox,x+M w300 gRCMF vfind","TreeView,w300 h377,,xh","ListView,xm y150 w200 h250,Commands|Hotkey,h")
	for a,b in [["l1","SysListView321","RCME"],["l2","SysListView322"],["t1","SysTreeView321"],["t2","SysTreeView322"]]
		TVRCM.Register(b.1,nw.XML.SSN("//*[@class='" b.2 "']/@hwnd").text,b.3,"RCMEditor")
	all:=RCMXML.SN("//main")
	while(aa:=all.item[A_Index-1]),ea:=xml.EA(aa)
		value:=TVRCM.Add("l1",ea.name),item:=ea.name=menu?value:item
	all:=menus.SN("//main/descendant::*"),
	while(aa:=all.item[A_Index-1]),ea:=xml.EA(aa){
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
			while(aa:=all.item[A_Index-1]),ea:=xml.EA(aa)
				aa.SetAttribute("tv",TVRCM.Add("t1",aa.NodeName="menu"?ea.name:"<Separator>",SSN(aa.ParentNode,"@tv").text))
		}
		lastevent:=A_EventInfo,update:=0,all:=RCMXML.SN("//*[@last]")
		while(aa:=all.item[A_Index-1]),ea:=xml.EA(aa)
			TVRCM.Modify("t1","",ea.tv,"Select Vis Focus"),aa.RemoveAttribute("last")
	}
	return
	RCMEditorEscape:
	RCMEditorClose:
	nw.SavePos(),nw.Exit()
	for a,b in [menus.SN("//*[@tv]"),RCMXML.SN("//*[@tv]")]
		while(rr:=b.item[A_Index-1]),ea:=xml.EA(rr)
			rr.RemoveAttribute("tv")
	return
}
Run(){
	if(v.opening)
		return
	KeyWait,Alt,U
	sc:=csc(),GetPos(),Save(4)
	file:=Current(2).file
	if(v.exec.ProcessID)
		v.exec.Terminate()
	if(file=A_ScriptFullPath){
		Run,%A_ScriptFullPath%
		Exit(1)
	}
	SetStatus("Run Script: " SplitPath(Current(2).file).Filename " @ " FormatTime("hh:mm:ss",A_Now),3)
	if(v.options.Virtual_Scratch_Pad&&InStr(current(2).file,"Scratch Pad.ahk"))
		return DynaRun(Update({encoded:Current(3).file}))
	if(Current(2).untitled)
		return DynaRun(Update({encoded:Current(3).file}),1,Current(2).file)
	SplitPath,file,,dir,ext
	if(!Current(1).xml)
		return
	main:=SSN(current(1),"@file").text
	if(FileExist(A_ScriptDir "\AutoHotkey.exe"))
		run:=Chr(34) A_ScriptDir "\AutoHotkey.exe" Chr(34) " " Chr(34) file Chr(34)
	else
		run:=FileExist(dir "\AutoHotkey.exe")?Chr(34) dir "\AutoHotkey.exe" Chr(34) " " Chr(34) file Chr(34):Chr(34) file Chr(34)
	admin:=v.options.Run_As_Admin?"*RunAs ":""
	if(!v.Options.Run_As_Admin)
		ExecScript() ;Update({get:Current(2).file}))
	else
		Run,%admin%%run%,%dir%,,pid
	if(!IsObject(v.runpid))
		v.runpid:=[]
	v.runpid[Current(2).file]:=pid
	if(file=A_ScriptFullPath){
		sc:=csc(),GetPos()
		for a,b in s.ctrl{
			node:=gui.SSN("//*[@hwnd='" b.sc+0 "']"),node.SetAttribute("file",files.SSN("//*[@sc='" b.2357 "']/@file").text)
			(b.sc=sc.sc)?node.SetAttribute("last",1):node.RemoveAttribute("last")
		}
		settings.add("last/file").text:=current(3).file,positions.save(1),settings.save(1)
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
	file:=current(2).file
	SplitPath,A_AhkPath,,dir
	SplitPath,file,,fdir
	Run,%dir%\%exe% "%file%",%fdir%,,pid
	if(!IsObject(v.runpid))
		v.runpid:=[]
	v.runpid[pid]:=1
}
Save_As(){
	Send,{Alt Up}
	current:=Current(1),currentfile:=Current(2).file
	all:=SN(current,"descendant-or-self::*[@untitled]")
	while(aa:=all.item[A_Index-1])
		aa.RemoveAttribute("untitled")
	current.RemoveAttribute("untitled")
	SplitPath,currentfile,,dir
	FileSelectFile,newfile,S,%dir%,Save File As...,*.ahk
	if(ErrorLevel||newfile="")
		return
	newfile:=SubStr(newfile,-3)=".ahk"?newfile:newfile ".ahk"
	if(FileExist(newfile))
		return m("File exists... Please choose another")
	filelist:=SN(Current(1),"descendant::*")
	SplitPath,newfile,newfn,newdir
	while,fl:=filelist.item[A_Index-1],ea:=XML.EA(fl)
		if(newfn=ea.filename)
			return m("File conflicts with an include.  Please choose another filename")
	SplashTextOn,200,100,Creating New File(s)
	while,fl:=filelist.item[A_Index-1],ea:=XML.EA(fl){
		filename:=ea.file
		SplitPath,filename,file
		if(A_Index=1)
			FileAppend,% Update({get:filename}),%newdir%\%newfn%,% ea.encoding
		else if !FileExist(newdir "\" file)
			FileAppend,% Update({get:filename}),%newdir%\%file%
	}
	SplashTextOff
	Close(),Open(newfile),tv(SSN(files.Find("//file/@file",newfile),"@tv").text)
}
Save_Untitled(node,ask:=1){
	ea:=xml.EA(node),template:=GetTemplate(),text:=Update({get:ea.file})
	if(RegExReplace(template,"\R","`n")=text)
		return
	if(text!=template){
		if(ask){
			option:=m("The file " ea.file " Containing:",SubStr(text,1,100) (StrLen(text)>100?"...":""),"Has not been saved.  Save this file?","btn:ync","ico:!")
			if(option="Cancel")
				Exit
			if(option!="Yes")
				return
		}
		FileSelectFile,filename,S16,,Save File,*.ahk
		if(ErrorLevel)
			return
		filename:=Filename(filename)
		file:=FileOpen(filename,"W","UTF-8"),file.Write(RegExReplace(text,"\R","`r`n")),file.Length(file.Position)
		all:=SN(SSN(node,"ancestor-or-self::main"),"descendant-or-self::*[@untitled]")
		while(aa:=all.item[A_Index-1])
			aa.RemoveAttribute("untitled")
		Close(files.SN("//main[@id='" SSN(node,"@id").text "']"))
		Open(filename)
		tv(SSN((damn:=files.Find("//main/@file",filename)),"descendant::*/@tv").text)
		/*
			m("Save this untitled file containing: " text,"As: " filename)
		*/
	}
}
Save(option=""){
	sc:=csc()
	if(option!=3)
		GetPos()
	Update({sc:sc.2357}),info:=Update("get"),now:=A_Now,Scan_Line()
	if(Current(3).untitled&&option!=4)
		Save_Untitled(Current(),(option=""?0:1))
	SavedFiles:=[],saveas:=[],all:=files.SN("//*[@edited]")
	while(aa:=all.item[A_Index-1]),ea:=xml.EA(aa){
		SavedFiles.push(1),text:=RegExReplace(info.1[ea.file],"\R","`r`n"),TVC.Modify(1,(v.Options.Hide_File_Extensions?ea.nne:ea.filename),ea.tv),SetStatus("Saving " ea.filename,3)
		if(!SplitPath(ea.file).dir)
			Continue
		if(ea.untitled&&option=3){
			Save_Untitled(aa)
			Continue
		}
		if(ea.untitled)
			Continue
		if(!v.Options.Disable_Backup){
			parent:=SSN(aa,"ancestor::main/@file").text
			SplitPath,parent,,dir
			if(!FileExist(dir "\backup"))
				FileCreateDir,% dir "\backup"
			if(!FileExist(dir "\backup\" now))
				FileCreateDir,% dir "\backup\" now
			FileCopy,% ea.file,% dir "\backup\" now "\" ea.filename,1
			if(ErrorLevel)
				m("There was an issue saving " ea.file,"Please close any error messages and try again")
		}LineStatus.Save(ea.id),encoding:=ea.encoding
		if(encoding="UTF-16")
			len:=VarSetCapacity(var,(StrPut(text,encoding)*2)),StrPut(text,&var,len,encoding),tt:=StrGet(&var,len),fl:=FileOpen(ea.file,"W",encoding),fl.Write(RegExReplace(tt,"\R","`r`n")),fl.Length(fl.Position),fl.Close()
		else if(RegExMatch(text,"[^\x0-\xFF]")&&encoding~="UTF-8"=0)
			fl:=FileOpen(ea.file,"W","UTF-8"),fl.Write(text),fl.Length(fl.Position),fl.Close(),aa.SetAttribute("encoding","UTF-8")
		else if(encoding!="utf-16")
			fl:=FileOpen(ea.file,"W",encoding),fl.Write(text),fl.Length(fl.Position),fl.Close()
		FileGetTime,time,% ea.file
		aa.SetAttribute("time",time),aa.RemoveAttribute("edited")
	}WinSetTitle(1,Current(3)),plural:=SavedFiles.MaxIndex()=1?"":"s",SetStatus(Round(SavedFiles.MaxIndex()) " File" plural " Saved",3)
	LineStatus.Save(),LineStatus.tv(),SaveGUI(),vversion.save(1),LastFiles()
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
	sc:=csc(),TVC.Disable(2),current:=Current(5),tick:=A_TickCount
	sc.2198(0),dup:=[],cexml.xml.preserveWhiteSpace:=1,current:=Current(5),list:=SN(current,"descendant::*[@type='Breakpoint']")
	while(ll:=list.item[A_Index-1]),ea:=xml.EA(ll){
		if(dup[ea.text])
			Continue
		sc.2686(0,sc.2006),search:=";*[" ea.text "]"
		total:=SN(current,"descendant::*[@type='Breakpoint' and @text='" ea.text "']")
		while((pos:=sc.2197(StrPut(search,"UTF-8")-1,search))>=0){
			sc.2686(pos+1,sc.2006)
			total.item[A_Index-1].SetAttribute("line",sc.2166(pos))
		}
		dup[ea.text]:=1
	}cexml.xml.preserveWhiteSpace:=0
	if(!v.Options.Match_Any_Word)
		sc.2198(0x2)
	while(b:=v.LineEdited.pop()){
		obj:=ScanLines(b.line),class:=GetCurrentClass(b.line)
		if(obj.text)
			Words_In_Document(1,obj.text,0,1)
		for c,d in v.OmniFind{
			if(c~="Breakpoint|Bookmark|Instance"){
				for e,f in {Remove:[b.text,obj.text],Add:[obj.text,b.text]}{
					pos:=1
					while(RegExMatch(f.1,d,found,pos),pos:=found.Pos(1)+found.Len(1)){
						if(!found.len(1))
							Break
						find:=v.OmniFindText[c]
						if(!RegExMatch(f.2,find.1 found.1 find.2)){
							if(e="Add")
								Code_Explorer.Add(c,found,current)
							if(e="Remove")
								Code_Explorer.RemoveItem(current,c,found.1)
			}}}}else{
				action:=[]
				for e,f in {add:obj.text,remove:b.text}
					if(RegExMatch(f,d,found))
						action[e]:=found
				if(c~="Function|Property"&&(action.add||action.remove)){
					if(action.add.1~="i)\b(" v.IndentRegex ")\b"&&action.Remove.1~="i)\b(" v.IndentRegex ")\b"){
						Continue
					}if(b.class){
						c:=c="Function"?"Method":c
						if(action.remove.1&&action.add.1){
							node:=SSN(class.node,"descendant::info[@type='" c "' and @text='" action.remove.1 "']")
							for y,z in {text:action.add.1,upper:Upper(action.add.1),args:action.add.3}
								node.SetAttribute(y,z)
							TVC.Modify(2,action.add.1,SSN(node,"@cetv").text) ;remove vis ;#[Remove Select Vis Focus from all these!]
						}else if(action.remove&&!action.add)
							Code_Explorer.RemoveTV(SN(GetClass(b.class,current),"descendant::info[@type='" c "' and @text='" action.remove.1 "']"))
						else if(action.add&&!action.remove)
							cexml.Under(class.node,"info",{class:SSN(class.node,"@text").text,text:action.add.1,upper:Upper(action.add.1),args:action.add.3,file:SSN(current,"@file").text,type:c,cetv:TVC.Add(2,action.add.1,SSN(class.node,"@cetv").text)})
					}else{
						remove:=SSN(current,"descendant::*[@type='" c "' and @text='" action.remove.1 "']")
						if(action.add.1~="i)\b(" v.IndentRegex ")\b"=0&&action.add.1){
							if(remove&&action.add.1)
								UpdateMethod(action.add,remove)
							else if(!remove&&action.add.1)
								Code_Explorer.Add(c,action.add,current)
						}else if(remove)
							TVC.Delete(2,SSN(remove,"@cetv").text),Remove.ParentNode.RemoveChild(remove)
				}}else if(c="Class"&&(action.add||action.remove)){
					if(action.add&&action.remove){
						node:=SSN(class.node,"descendant::*[@type='Class' and @text='" action.remove.2 "']")
						for a,b in {text:action.add.2,upper:Upper(action.add.2)}
							node.SetAttribute(a,b)
						TVC.Modify(2,action.add.2,SSN(node,"@cetv").text),all:=SN(node,"descendant::*[@class='" action.remove.2 "']")
						while(aa:=all.item[A_Index-1]),ea:=xml.EA(aa)
							aa.SetAttribute("class",action.add.2)
						all:=SN(Current(7),"descendant::*[@type='Instance' and @class='" action.remove.2 "']")
						while(aa:=all.item[A_Index-1]),ea:=xml.EA(aa)
							aa.SetAttribute("class",action.add.2),SelectText(aa),linetext:=sc.GetLine((line:=sc.2166(sc.2008))),sc.2686(sc.2128(line),sc.2136(line)),replace:=Trim(RegExReplace(linetext,"\Q" action.remove.2 "\E",action.add.2),"`n"),sc.2194(StrPut(replace,"UTF-8")-1,replace)
					}else if(action.add&&!action.remove){
						if(SSN(class.node,"@type").text="Class")
							cexml.Under(class.node,"info",{text:action.add.2,type:c,upper:Upper(action.add.2),cetv:TVC.Add(2,action.add.2,SSN(class.node,"@cetv").text)})
						else
							Code_Explorer.Add(c,action.add,current)
					}else if(action.remove&&!action.add){
						node:=SSN(b.class.node,"info[@type='Class' and @text='" action.remove.2 "']")
						if(SSN(node.ParentNode,"@type").text="Class"){
							all:=SN(node,"descendant::*")
							while(aa:=all.item[A_Index-1]),ea:=xml.EA(aa){
								if(ea.cetv)
									TVC.Delete(2,ea.cetv)
								aa.SetAttribute("cetv",TVC.Add(2,ea.text,SSN(node.ParentNode,"@cetv").text)),aa.SetAttribute("class",SSN(node.ParentNode,"@text").text),all:=SN(Current(7),"descendant::*[@type='Instance' and @class='" action.remove.2 "']")
								while(aa:=all.item[A_Index-1]),ea:=xml.EA(aa)
									aa.SetAttribute("class",SSN(node.ParentNode,"@text").text),SelectText(aa),linetext:=sc.GetLine((line:=sc.2166(sc.2008))),sc.2686(sc.2128(line),sc.2136(line)),replace:=Trim(RegExReplace(linetext,"\Q" action.remove.2 "\E",SSN(node.ParentNode,"@text").text),"`n"),sc.2194(StrPut(replace,"UTF-8")-1,replace)
						}}else{
							master:=SSN(current,"*[@type='Class' and @text='" action.remove.2 "']"),node:=SN(master,"descendant::*")
							while(nn:=node.item[A_Index-1]),ea:=xml.EA(nn){
								if(ea.cetv)
									TVC.Delete(2,ea.cetv)
								if(ea.type="Method")
									Code_Explorer.Add("Function",{1:ea.text,3:ea.args},current)
								else
									nn.ParentNode.RemoveChild(nn)
							}
							if(tv:=SSN(master,"@cetv").text)
								TVC.Delete(2,tv)
							master.ParentNode.RemoveChild(master)
				}}}else if(action.add||action.remove){
					if(action.add.1!=action.remove.1&&action.add)
						Code_Explorer.Add(c,action.add,current)
					if(action.remove.1!=action.add.1&&action.remove)
						Code_Explorer.RemoveItem(current,c,action.remove.1)
	}}}}SetStatus("Scan_Line() Process Time: " A_TickCount-tick "ms @" A_TickCount,3),v.LineEdited:=[],TVC.Enable(2),Code_Explorer.AutoCList(1),t()
	return
}
ScanFiles(){
	list:=files.SN("//*[@scan]")
	while(ll:=list.item[A_Index-1])
		WinSetTitle(1,"AHK Studio: Scanning " SSN(ll,"@file").text " Please Wait..."),Code_Explorer.Scan(ll),ll.RemoveAttribute("scan")
	if(MainWin.gui.SSN("//*[@win='1']/descendant::control[@type='Code Explorer']"))
		Code_Explorer.Refresh_Code_Explorer()
	Sleep,100
	WinSetTitle(1,files.ea("//*[@sc='" csc().2357 "']"))
	FEScan:=files.SN("//main")
	if(v.options.Auto_Expand_Includes)
		SetTimer,AutoExpand,-200
	v.Startup:=0,Words_In_Document(1),Code_Explorer.AutoCList(1)
}
ScanLines(line){
	sc:=csc(),total:=sc.2154
	if(RegExMatch(sc.GetLine(line),"^\s*\{")){
		Loop,% line+1{
			LineText:=sc.GetLine(line-(A_Index-1))
			if(SubStr(Trim(RegExReplace(LineText,"(\s+;.*)|(\s*)"),"`n"),0,1)="{"&&A_Index>1)
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
				return {text:text.=LineText,line:line}
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
	while,(sl:=xml.ea(slist.item(A_Index-1))).name
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
	while,ss:=test.item[A_Index-1],ea:=xml.ea(ss)
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
	omni_search(":")
}
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
SelectText(item){
	sc:=csc(),text:=sc.GetUNI(),find:=v.OmniFindText[item.type],string:=find.1 item.text find.2
	if(item.nodename){
		ea:=XML.EA(item)
		if(ea.type="Class"){
			alltop:=GetAllTopClasses(text)
			if(master:=SSN(item,"ancestor::*[@type='Class']"))
				top:=alltop[SSN(master,"@text").text],find:=v.OmniFindText.Class,RegExMatch(text,find.1 ea.text find.2,found,top.start),pos:=StrPut(SubStr(text,1,found.pos(1)),"UTF-8")-2,sc.2160(pos,pos+StrPut("Class " ea.text,"UTF-8")-1)
			else
				sc.2160(alltop[ea.text].start-1,alltop[ea.text].start+StrPut("Class " ea.text,"UTF-8")-2)
			return
		}
		if(ea.type~="Method|Property"){
			return class:=GetClassText(text,ea.class,1),pos:=class.start,find:=v.OmniFindText[ea.type],RegExMatch(text,find.1 ea.text find.2,found,pos),pos:=StrPut(SubStr(text,1,found.pos(1)),"UTF-8")-2,sc.2160(pos,pos+StrPut(ea.text,"UTF-8")-1),CenterSel()
		}else if(ea.type="Function"){
			find:=v.OmniFindText.Function,pos:=1
			while(RegExMatch(text,find.1 ea.text find.2,found,pos),pos:=found.Pos(1)+found.Len(1)){
				if(!found.len(1))
					Break
				findline:=SubStr(text,1,found.pos(1))
				RegExReplace(findline,"\R",,line)
				if(!GetCurrentClass(line)){
					return pos:=StrPut(SubStr(text,1,found.pos(1)),"UTF-8")-2,sc.2160(pos,pos+StrPut(ea.text,"UTF-8")-1),CenterSel()
		}}}
		pre:=SN(item,"preceding-sibling::*[@type='" ea.type "' and @text='" ea.text "']"),syntax:=v.OmniFindText[ea.type],pos1:=1
		Loop,% 1+pre.length
			pos:=RegExMatch(text,syntax.1 ea.text syntax.2,found,pos1),pos1:=found.Pos(1)+found.len(1)
		pos:=StrPut(SubStr(text,1,found.pos(1)),"UTF-8")-2
		if(ea.type~="Bookmark|Breakpoint")
			line:=sc.2166(pos),sc.2160(sc.2128(line),sc.2136(line)),hwnd({rem:20}),CenterSel()
		else
			sc.2160(pos,pos+StrPut((ea.type="Class"?"Class ":"") ea.text,"UTF-8")-1)
		return
	}
	if(item.type="method")
		return ff:=v.OmniFindText.class,RegExMatch(text,ff.1 item.class ff.2,found),pos:=RegExMatch(text,string,found,found.pos(1)),start:=StrPut(SubStr(text,1,found.pos(1)),"UTF-8")-2,sc.2160(start,start+StrPut(item.text,"UTF-8")-1),CenterSel(),sc.2400
	RegExMatch(text,string,found),pos:=found.Pos(1)
	if(pos)
		start:=StrPut(SubStr(text,1,pos),"UTF-8")-2,sc.2160(start,start+StrPut(item.type="Class"?"Class " item.text:item.text,"UTF-8")-1),CenterSel(),sc.2400
	else
		m("Didn't find it. Please report this to maestrith","Include the original script and " Chr(34) string Chr(34) " so he can fix it")
}
Set_As_Default_Editor(){
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
Set(sc:=""){
	sc:=sc?sc:csc()
	Color(sc)
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
	sc:=csc(),sc.2397(0),node:=files.SSN("//*[@sc='" sc.2357 "']"),file:=SSN(node,"@file").text,parent:=SSN(node,"ancestor::main/@file").text,posinfo:=positions.Find(positions.Find("//main/@file",parent),"descendant::file/@file",file),doc:=SSN(node,"@sc").text,ea:=xml.ea(posinfo),fold:=ea.fold
	SetTimer,fold,-1
	return
	fold:
	if(ea.file){
		Loop,Parse,fold,`,
			sc.2231(A_LoopField)
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
SetScan(line){
	obj:=ScanLines(line)
	class:=GetCurrentClass(line)
	if(Trim(obj.text)){
		for a,b in v.OmniFind{
			if(RegExMatch(obj.text,b)){
				v.LineEdited[line]:={text:obj.text,line:line,class:class,classtext:class.text}
				return
			}
		}
	}
	v.LineEdited[line]:={text:obj.text,line:line,class:class}
}
SetStatus(text,part=""){
	static widths:=[],width
	if(IsObject(text)){
		WinSet,Redraw,,% hwnd([1])
		ControlGetPos,,,,h,,% "ahk_id" v.statushwnd
		v.status:=h
		ea:=xml.ea(text)
		return sc:=csc(),ea:=xml.ea(text),sc.2056(99,ea.font),sc.2055(99,ea.size),width:=sc.2276(99,"a")+1
	}
 	/*
		if(part=1)
			widths.3:=0
	*/
	Gui,1:Default
	widths[part]:=width*StrLen(text 1),SB_SetParts(widths.1,widths.2,widths.3),SB_SetText(text,part)
}
SetTimer(timer,duration){
	SetTimer,%timer%,%duration%
}
Class SettingsWindow{
	/*
		add the toolbar editor to this as well.
	*/
	__New(option:=0){
		;obj:=new GUIKeep()
		Gui,settings:Destroy
		MenuWipe(1)
		sww:=SettingsWindow.Windows:=[],obj:=SettingsWindow.win:=new GuiKeep("Settings"),obj.Add("TreeView,x0 y0 w300 h600 AltSubmit gSettingsWindow.Tab,,h","Tab,x+M y0 w0 h0 Section,1|2|3|4|5|6|7|8|9|10|11|12")
		SettingsWindow.menu:=[],SettingsWindow.IL:=IL_Create(20),SettingsWindow.Icons:=[]
		Gui,Settings:Default
		Gui,Tab,1
		obj.Add("ComboBox,xs ys w600 gSettingsWindow.MenuSearch AltSubmit,Search,w"
			  ,"ListView,w600 h200 gSettingsWindow.SelectMenuItem AltSubmit,Menu Item|Hotkey|Search Weight,w"
			  ,"TreeView,w300 h200 gSettingsWindow.PopulateMenu AltSubmit,,h"
			  ,"ListView,x+0 w300 h200 NoSortHdr,Item|Hotkey|Visible,wh"
			  ,"ListView,xs w600 h150 gSWAction,Action|Hotkey,yw")
		Gui,Tab,2
		obj.Add("ListView,xs ys w600 h600 Checked AltSubmit,Options,wh")
		;moar tabz
		
		
		
		
		
		
		
		;icons
		Gui,Tab,12
		obj.add("Text,xs ys,Info On What Icon You Are Setting,w"
			  ,"ListView,w600 h500 Icons AltSubmit +0x100 gSelectIcon -Multi,Options,wh"
			  ,"Button,gloadfile,Load Icon File,y"
			  ,"Button,x+M gloaddefault,Default Icons,y"
			  ,"Button,x+M gEH,Set Icon (Enter),y"
			  ,"Button,x+M gSWCancelIcon,&Cancel,y")
		
		
		ControlGet,hwnd,hwnd,,SysListView325,% hwnd(["Settings"])
		v.ib:=new Icon_Browser(obj,hwnd,"Settings","xy",0,"Settings",1)
		;/icons
		
		;populate things
		;/populate things
		
		
		for a in SettingsWindow.menu
			list.=RegExReplace(a,"_"," ") "|"
		GuiControl,Settings:,ComboBox1,% Trim(list,"|")
		GuiControl,Settings:Choose,ComboBox1,1
		SettingsWindow.CommandList:=CommandList:={"Add A New Menu":["!A","ANM"],"Move Menu Item Up":["^Up","Up"],"Move Menu Item Down":["^Down","Down"],"Add Separator":["!S","AS"],"Edit Hotkey":["Enter","EH"],"Re-Load Defaults":["","RD"],"Sort Menus":["","SM"],"Sort Selected Menu":["","SSM"],"Remove Icon":["!^x","RI"],"Remove All Icons From Current Menu":["","RAICM"],"Move Selected":["^M","MS"],"Show Options Tab":["!O","SOT"],"Add New Sub-Menu":["!U","ANSM"],"Remove All Icons":["","RAI"],"Delete/Hide Items":["Delete","SettingsDelete"],"Change Icon":["!I","SWCI"]}
		Default("SysListView323","Settings"),hotkeys:=[]
		for a,b in CommandList
			LV_Add("",a,Convert_Hotkey(b.1)),hotkeys[b.1]:=b.2
		Loop,2
			LV_ModifyCol(A_Index,"AutoHDR")
		hotkeys.Delete:="SWDelete"
		Hotkey,IfWinActive,% SettingsWindow.win.ID
		for a,b in hotkeys{
			Try
				Hotkey,%a%,%b%,On
			if(!IsLabel(b))
				MissingList.= b "`n"
		}
		
		
		Default("SysTreeView322","Settings"),TV_SetImageList(SettingsWindow.IL)
		Default("SysListView322","Settings"),LV_SetImageList(SettingsWindow.IL)
		
		
		
		
		
		;setup glabels
		SettingsWindow.ControlList:={"SettingsWindow.SelectMenuItem":"SysListView321"
							   ,"SettingsWindow.PopulateMenu":"SysTreeView322"
							   ,"SettingsWindow.SetOption":"SysListView324"
							   ,"SettingsWindow.MenuSearch":"ComboBox1"}
		SettingsWindow.Enable()
		;/setup glabels
		obj.Show("Settings")
		for a,b in ["Menus","Options"] ;<----Add tab stuffs here make sure to move the icon list to the end
			Default("SysTreeView321","Settings"),sww[TV_Add(b)]:=A_Index
		sww[TV_Add("Help")]:="Help"
		Default("SysListView322","Settings")
		Loop,3
			LV_ModifyCol(A_Index,"AutoHDR")
		SetTimer,SWAfter,-100
		return
		SWAfter:
		SettingsWindow.PopulateMenus()
		SettingsWindow.PopulateOptions()
		SettingsWindow.Shown:=1
		return
		SettingsEscape:
		SettingsClose:
		if(SettingsWindow.GetTab()=12)
			return SettingsWindow.LastControl(1)
		Default("SysTreeView322","Settings"),menus.SSN("//*[@tv='" TV_GetSelection() "']").SetAttribute("last",1),SettingsWindow.win.Exit(),SettingsWindow.win:=""
		all:=menus.SN("//*[@tv]")
		while(aa:=all.item[A_Index-1])
			aa.RemoveAttribute("tv")
		SetTimer,RefreshMenu,-1
		return
	}Icon(ea){
		list:=SettingsWindow.Icons
		if(!ea.filename)
			return
		if(!num:=list[ea.clean])
			num:=IL_Add(SettingsWindow.IL,ea.filename?ea.filename:"Shell32.dll",ea.icon)
		return "icon" num
		;SettingsWindow.IL:=IL_Create(20)
	}Tab(a*){
		if(a.1="S"){
			if((tab:=SettingsWindow.Windows[A_EventInfo])~="\d")
				GuiControl,Settings:Choose,SysTabControl321,%tab%
			else
				m(tab)
		}
	}Enable(){
		for a,b in SettingsWindow.ControlList{
			GuiControl,Settings:+g%a%,%b%
			GuiControl,Settings:+Redraw,%b%
		}
	}Delete(a*){
		SWDelete:
		ControlGetFocus,Focus,% SettingsWindow.win.ID
		Default(Focus,"Settings")
		if(Focus="SysTreeView322"){
			;Top Level Menus
			node:=menus.SSN("//*[@tv='" TV_GetSelection() "']")
			if(SSN(node,"descendant::menu"))
				return m("Can not delete a menu that has items in it.")
			else
				if(m("Are you sure you want to remove this menu?","btn:ync","def:2")="Yes")
					(node.previousSibling?node.previousSibling.SetAttribute("last",1):node.nextSibling?node.nextSibling.SetAttribute("last",1):node.ParentNode.NodeName="menu"?node.ParentNode.SetAttribute("last",1):""),node.ParentNode.RemoveChild(node),SettingsWindow.PopulateMenus()
		}if(Focus="SysListView322"){
			;Menu Items (Hide)
			Default("SysListView322","Settings"),LV_GetText(item,LV_GetNext())
			if(!node:=menus.SSN("//*[@clean='" Clean(item) "']"))
				return
			if(node.NodeName="Separator")
				(node.nextSibling?node.nextSibling.SetAttribute("select",1):node.previousSibling.SetAttribute("select",1))node.ParentNode.RemoveChild(node)
			SettingsWindow.SelectMenuNode(SettingsWindow.GetNode())
		}
		return
	}Disable(){
		for a,b in SettingsWindow.ControlList{
			GuiControl,Settings:+g,%b%
			GuiControl,Settings:-Redraw,%b%
		}
	}SelectMenuNode(node,Redraw:=0){
		static ItemList,il:=[]
		SettingsWindow.PopulatingMenus:=1,SettingsWindow.Disable(),Default("SysTreeView322","Settings")
		if(SSN(node,"descendant::*|@personal")){
			TV_Modify(SSN(node,"@tv").text,"Select Vis"),list:=SN(node,"*"),Default("SysListView322","Settings"),LV_Delete(),ItemList:=[]
			selcount:=SN(node,"*/@select").length,index:=0
			while(ll:=list.item[A_Index-1]),ea:=XML.EA(ll){
				if(!SN(ll,"descendant::*").length&&!ea.personal){
					if(selcount>1&&index=0&&ea.select)
						select:="Select Vis Focus",index:=1
					if(selectcount=1&&ea.select)
						select:="Select Vis Focus"
					if(select)
						m(ea.clean,select)
					;(ea.select&&selcount=1?"Select Vis Focus":ea.select&&selcount>1&&index=0?"Select":"")
					index:=ItemList[ea.clean]:=LV_Add(select " " SettingsWindow.Icon(ea),RegExReplace(ea.clean,"_"," "),Convert_Hotkey(ea.hotkey),(ea.hide?"Hidden":"Visible")),il[index]:=ll
				}
			}
		}else{
			tv:=SSN(node.ParentNode,"@tv").text
			if(tv!=TV_GetSelection()||Redraw){
				ItemList:=[],TV_Modify(tv,"Select Vis Focus"),list:=SN(node.ParentNode,"*"),Default("SysListView322","Settings"),LV_Delete()
				selcount:=SN(node,"*/@select").length
				while(ll:=list.item[A_Index-1]),ea:=XML.EA(ll)
					index:=ItemList[ea.clean]:=LV_Add((ea.select&&selcount=1?"Select Vis Focus":ea.select&&selcount>1?"Select":"") " " SettingsWindow.Icon(ea),RegExReplace(ea.clean,"_"," "),Convert_Hotkey(ea.hotkey),(ea.hide?"Hidden":"Visible")),il[index]:=ll
			}else
				ea:=xml.EA(node),LV_Modify(ItemList[ea.clean],"Col2",Convert_Hotkey(ea.hotkey))
		}
		if(item:=ItemList[SSN(node,"@clean").text])
			LV_Modify(0,"-Select"),LV_Modify(item,"Select Vis Focus")
		else if(!LV_GetNext())
			LV_Modify(0,"-Select"),LV_Modify(1,"Select Vis Focus")
		SettingsWindow.PopulatingMenus:=0,SettingsWindow.ItemList:=il,all:=menus.SN("//*[@select]")
		while(aa:=all.item[A_Index-1])
			aa.RemoveAttribute("select")
		SettingsWindow.Enable()
		Default("SysListView322","Settings")
		Loop,3
			LV_ModifyCol(A_Index,"AutoHDR")
	}PopulateMenu(a*){
		if(A_GuiEvent="S"){
			if(node:=menus.SSN("//*[@tv='" A_EventInfo "']")){
				if(SettingsWindow.Shown)
					while(SettingsWindow.PopulatingMenus){
						t(A_Index,SettingsWindow.PopulatingMenus)
						Sleep,100
					}t()
				SettingsWindow.SelectMenuNode(node)
	}}}PopulateMenus(){
		SettingsWindow.Disable(),Default("SysTreeView322","Settings"),TV_Delete(),list:=menus.SN("//menu/descendant-or-self::*") 
		while(ll:=list.item[A_Index-1]),ea:=XML.EA(ll){
			if(SSN(ll,"descendant::menu")||ea.personal)
				ll.SetAttribute("tv",TV_Add(RegExReplace(ea.clean,"_"," "),SSN(ll.ParentNode,"@tv").text,SettingsWindow.Icon(ea)))
			else
				SettingsWindow.menu[ea.clean]:=1
			if(ea.last)
				node:=ll,ll.RemoveAttribute("last")
		}
		if(node)
			SettingsWindow.SelectMenuNode(node)
		SettingsWindow.Enable()
	}MenuSelect(){
		if(item:=SettingsWindow.SelectItem)
			Default("SysListView322","Settings"),LV_Modify(item,"Select Vis Focus"),SettingsWindow.SelectItem:=0
	}PopulateOptions(){
		Default("SysListView324","Settings")
		for a,b in v.Options
			LV_Add(b?"Check":"",RegExReplace(a,"_"," "))
	}SetOption(a*){
		if(InStr(A_GuiEvent,"I")){
			if(ErrorLevel="c"){
				Default("SysListView324","Settings"),LV_GetText(option,LV_GetNext())
				if(!LV_GetNext())
					return
			}
			if(ErrorLevel=="C")
				Options(Clean(option))
			if(ErrorLevel=="c")
				Options(Clean(option))
		}
	}MenuSearch(a*){
		ControlGet,text,Choice,,ComboBox1,% SettingsWindow.win.ID
		if(text){
			if(node:=menus.SSN("//*[@clean='" Clean(text) "']"))
				SettingsWindow.SelectMenuNode(node)
		}else{
			ControlGetText,text,ComboBox1,% SettingsWindow.win.ID
			SettingsWindow.Disable()
			text:=Trim(text)
			if(text~="\W"&&text~="\s"=0){
				list:=menus.SN("//*[@hotkey!='']"),Default("SysListView321","Settings"),LV_Delete()
				while(ll:=list.item[A_Index-1]),ea:=XML.EA(ll){
					for a,b in StrSplit(text)
						if(!InStr(ea.hotkey,b))
							Continue,2
					LV_Add("",RegExReplace(ea.clean,"_"," "),Convert_Hotkey(ea.hotkey))
				}
			}else{
				list:=menus.SN("//menu"),Default("SysListView321","Settings"),LV_Delete(),find:=RegExReplace(text," ","_")
				while(ll:=list.item[A_Index-1]),ea:=XML.EA(ll){
					if(SSN(ll,"descendant::*"))
						Continue
					for a,b in StrSplit(find)
						if(!InStr(ea.clean,b))
							Continue,2
					weight:=0
					if(RegExMatch(ea.clean,"i)^" find))
						weight+=100
					for a,b in StrSplit(find,"_"){
						for c,d in StrSplit(b)
							if(pos:=RegExMatch(ea.clean,"i)" d))
								weight+=40/pos
						if(RegExMatch(ea.clean,"i)" b))
							weight+=100
					}
					LV_Add("",RegExReplace(ea.clean,"_"," "),Convert_Hotkey(ea.hotkey),weight)
				}
			}
			Loop,3
				LV_ModifyCol(A_Index,"AutoHDR")
			SettingsWindow.Enable()
			LV_ModifyCol(3,"SortDesc Logical")
			SetTimer,SWSelectFirst,-200
			return
			SWSelectFirst:
			Default("SysListView321","Settings"),LV_Modify(1,"Select Vis Focus")
			return
		}
	}SelectMenuItem(a*){
		static last,lasttv
		if(A_GuiEvent~="Normal|I"){
			SettingsWindow.Disable()
			Default("SysListView321","Settings"),LV_GetText(item,LV_GetNext()),item:=Clean(item)
			if(item!=last){
				if(node:=menus.SSN("//*[@clean='" item "']")){
					tv:=menus.SSN("//*[@clean='" SSN(node.ParentNode,"@clean").text "']/@tv").text,Default("SysTreeView322","Settings"),TV_Modify(tv,"Select Vis Focus")
					if(tv!=lasttv){
						ItemList:=[],all:=SN(node.ParentNode,"*"),Default("SysListView322","Settings"),LV_Delete()
						while(aa:=all.item[A_Index-1]),ea:=XML.EA(aa)
							ItemList[LV_Add(SettingsWindow.Icon(ea) (ea.select||Clean(item)=ea.clean?" Select":""),RegExReplace(ea.clean,"_"," "),Convert_Hotkey(ea.hotkey),ea.hide?"Hidden":"Visible")]:=aa
						SettingsWindow.ItemList:=ItemList
						Loop,2
							LV_ModifyCol(A_Index,"AutoHDR")
					}else
						Default("SysListView322","Settings"),LV_Modify(0,"-Select"),LV_Modify(SN(node,"preceding-sibling::*").length+1,"Select Vis Focus")
			}}last:=item,lasttv:=tv,SettingsWindow.Enable()
	}}Actions(){
		static SMM
		SWAction:
		Default("SysListView323","Settings"),LV_GetText(text,LV_GetNext())
		if(action:=SettingsWindow.CommandList[text].2)
			goto,%action%
		return
		ANM:
		top:=menus.SSN("//main"),info:=InputBox(this.hwnd,"New Top Level Menu","Enter a name for a new top level menu")
		if(menus.SSN("//*[@clean='" clean(info) "' and @top=1]"))
			return m("A menu with this name already exists.  Please choose another")
		menus.Under(top,"menu",{clean:Clean(info),name:info,personal:1,last:1})
		return SettingsWindow.PopulateMenus()
		MS:
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
		EH:
		ControlGet,tab,Tab,,SysTabControl321,% SettingsWindow.win.ID
		if(tab=12){
			obj:=SettingsWindow.IconInfo,node:=SettingsWindow.CurrentIconNode
			if(obj.file&&obj.icon){
				for a,b in {filename:obj.file,icon:obj.icon}
					node.SetAttribute(a,b)
				if(SSN(node,"descendant::*"))
					Default("SysTreeView322","Settings"),TV_Modify(SSN(node,"@tv").text,SettingsWindow.Icon(xml.EA(node)))
				else
					Default("SysListView322","Settings"),LV_Modify(SN(node,"preceding-sibling::*").length+1,SettingsWindow.Icon(xml.EA(node)))
				SettingsWindow.CurrentIconNode:=""
			}
			SettingsWindow.IconInfo:=[],SettingsWindow.LastControl(1)
			return
		}
		Default("SysListView322","Settings"),LV_GetText(item,LV_GetNext())
		if(!node:=menus.SSN("//*[@clean='" Clean(item) "']"))
			return m("Select an item to change its hotkey")
		EditHotkey(node,"Settings")
		return
		Up:
		Down:
		next:=0,Default("SysListView322","Settings"),list:=SN(node,"*")
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
		}SettingsWindow.SelectMenuNode(node)
		/*
			this is selecting extra crap and not moving the right items. :(
		*/
		return
		SSM:
		Default("SysTreeView322","Settings"),node:=menus.SSN("//*[@tv='" TV_GetSelection() "']"),under:=SN(node,"*"),alpha:=[]
		while(uu:=under.item[A_Index-1]),ea:=xml.ea(uu)
			alpha[ea.clean]:=uu
		for a,b in alpha
			node.AppendChild(b)
		return SettingsWindow.SelectMenuNode(node)
		RI:
		Default("SysListView322","Settings"),LV_GetText(item,LV_GetNext()),node:=menus.SSN("//*[@clean='" Clean(item) "' and not(@top)]")
		if(!node)
			return m("Select an item to remove the icon from")
		node.RemoveAttribute("filename"),node.RemoveAttribute("icon")
		return SettingsWindow.SelectMenuNode(node)
		SWCI:
		ControlGetFocus,focus,% SettingsWindow.win.ID
		if(focus~="(SysTreeView322|SysListView322)"=0){
			ControlFocus,% (focus:="SysListView322"),% SettingsWindow.win.ID
			Sleep,100
		}if(focus="SysTreeView322"){
			Default(focus,"Settings")
			if(!TV_GetSelection())
				return m("Please select a Top Level Menu to change its icon")
			node:=SettingsWindow.GetNode()
			GuiControl,Settings:,Static1,% "Changing the icon for " RegExReplace((ea:=xml.EA(node)).clean,"_"," ")
			SettingsWindow.LastControl()
			Default("SysListView325","Settings"),LV_Modify(ea.icon?ea.icon:1,"Select Vis Focus"),SettingsWindow.CurrentIconNode:=node
			GuiControl,Settings:Choose,SysTabControl321,12
		}else if(focus="SysListView322"){
			Default(focus,"Settings")
			if(!LV_GetNext())
				return m("Please select a Menu Item to change its icon")
			SettingsWindow.LastControl()
			node:=SettingsWindow.GetNode(),Default("SysListView322","Settings")
			GuiControl,Settings:,Static1,% "Changing the icon for " RegExReplace((ea:=xml.EA(icon:=SSN(node,"menu[" LV_GetNext() "]"))).clean,"_"," ")
			Default("SysListView325","Settings"),LV_Modify(ea.icon?ea.icon:1,"Select Vis Focus"),SettingsWindow.CurrentIconNode:=icon
			GuiControl,Settings:Choose,SysTabControl321,12
		}
		return
		SWCancelIcon:
		SettingsWindow.LastControl(1)
		return
		SOT:
		GuiControl,Settings:Choose,SysTabControl321,2
		return
		AS:
		;node:=SettingsWindow.GetNode()
		Default("SysListView322","Settings"),LV_GetText(item,LV_GetNext())
		if(!LV_GetNext()){
			return m("Please select a menu item to add the Separator below")
			/*
				Default("SysTreeView322","Settings"),node:=menus.SSN("//*[@tv='" TV_GetSelection() "']")
				menus.Under(node,"separator",{clean:"<Separator>",select:1})
				goto,PopulateMenu
				return
			*/
		}
		node:=menus.SSN("//*[@clean='" Clean(item) "' and not(@top)]"),new:=menus.Under(node.ParentNode,"separator",{clean:"<Separator>",select:1})
		if(before:=node.nextSibling)
			node.ParentNode.InsertBefore(new,before)
		SettingsWindow.SelectMenuNode(SettingsWindow.GetNode())
		return
		ANSM:
		Default("SysTreeView322","Settings")
		node:=menus.SSN("//*[@tv='" TV_GetSelection() "']")
		top:=menus.SSN("//main")
		info:=InputBox(this.hwnd,"New Sub Menu","Enter a name for a sub menu for " SSN(node,"@clean").text)
		if(menus.SSN("//*[@clean='" Clean(info) "' and @top=1]"))
			return m("A menu with this name already exists.  Please choose another")
		menus.Under(node,"menu",{clean:Clean(info),name:info,top:1,last:1,personal:1})
		return SettingsWindow.SelectMenuNode(node)
	}GetTab(){
		ControlGet,tab,Tab,,SysTabControl321,% SettingsWindow.win.ID
		return tab
	}SetIcon(file,icon){
		SettingsWindow.IconInfo:={file:file,icon:icon}
	}LastControl(set:=0){
		static info:=[]
		if(!set){
			ControlGet,tab,tab,,SysTabControl321,% SettingsWindow.win.ID
			ControlGetFocus,focus,% SettingsWindow.win.ID
			info:={tab:tab,focus:focus}
		}else{
			GuiControl,Settings:Choose,SysTabControl321,% info.tab
			Sleep,100
			ControlFocus,% info.focus,% SettingsWindow.win.ID
		}
	}GetNode(){
		Default("SysTreeView322","Settings"),node:=menus.SSN("//*[@tv='" TV_GetSelection() "']")
		return node
	}
}
Settings(option:=""){
	if(option.file)
		return SettingsWindow.SetIcon(option.file,option.icon)
	if(SSN(option,"@clean"))
		return SettingsWindow.SelectMenuNode(option,1)
	new SettingsWindow(option)
}
Setup(window,nodisable=""){
	ea:=settings.ea(settings.SSN("//fonts/font[@style='5']")),size:=10,Background:=RGB(ea.Background),font:=ea.font,color:=RGB(ea.color),Background:=Background?Background:0
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
	if(hyphen)
		csc().2077(0,"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ#-_1234567890")
	else
		csc().2444
}
Show_Class_Methods(object,search:=""){
	static list
	sc:=csc()
	if(object="this")
		class:=GetCurrentClass(sc.2166(sc.2008)),list:=SN(class.node,"descendant::*[@type='Method']")
	else if(class:=SSN((parent:=Current(7)),"descendant::*[@type='Instance' and @upper='" Upper(object) "']/@class").text)
		list:=SN(parent,"descendant::*[@type='Class' and @text='" class "']/descendant::*[@type='Method']")
	else if(parent:=SSN(Current(7),"descendant::*[@type='Class' and @upper='" Upper(object) "']"))
		list:=SN(parent,"descendant::*[@type='Method']")
	while,ll:=list.item[A_Index-1],ea:=xml.ea(ll)
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
ShowLabels(x:=0){
	Code_Explorer.Scan(current()),all:=cexml.SN("//main[@file'" current(2).file "']/descendant::info[@type='Function' or @type='Label']/@text")
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
	GetPos()
	ControlGetFocus,focus,% hwnd([1])
	ControlGet,hwnd,hwnd,,%focus%,% hwnd([1])
	hwnd:=hwnd=v.tngui.sc.sc?v.tngui.hwnd+0:hwnd+0,sc:=csc(),test:=MainWin.gui.SN("//*[@type='Scintilla']"),list:="",v.jts:=[]
	while,ss:=test.item[A_Index-1],ea:=xml.ea(ss){
		if(hwnd=ea.hwnd)
			Continue
		if(ea.type="scintilla"){
			if(v.tnsc.sc=ea.hwnd)
				list.="Tracked Notes,",v.jts["Tracked Notes"]:=v.tnsc.sc
			else
				doc:=s.ctrl[ea.hwnd].2357,file:=StrSplit(files.SSN("//*[@sc='" doc "']/@file").text,"\").pop(),list.=file ",",v.jts[file]:=ea.hwnd
			}}list:=Trim(list,",")
	if(!InStr(list,","))
		return s.ctrl[v.jts[list]].2400()
	sc.2106(44),sc.2117(7,Trim(list,",")),sc.2106(32)
}
Toggle_Comment_Line(){
	sc:=csc(),sc.2078
	pi:=posinfo(),sl:=sc.2166(pi.start),el:=sc.2166(pi.end),end:=pi.end,single:=sl=el?1:0
	replace:=settings.SSN("//comment").text,replace:=replace?replace:";",replace:=RegExReplace(replace,"%a_space%"," ")
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
ToggleMenu(Label){
	if(!Label)
		return
	Menu,main,UseErrorLevel
	top:=menus.SSN("//*[@clean='" label "']"),ea:=xml.ea(top),pea:=xml.ea(top.ParentNode)
	Menu,% pea.name (pea.hotkey?"`t" Convert_Hotkey(pea.hotkey):""),% (v.Options[label]?"Check":"Uncheck"),% ea.name (ea.hotkey?"`t" Convert_Hotkey(ea.Hotkey):"")
}
Toggle_Multiple_Line_Comment(){
	sc:=csc(),sc.2078,sc.Enable(),indent:=Settings.Get("//tab",5)
	if(sc.2010(sc.2143)!=11&&sc.2010(sc.2145)!=11){
		SLine:=sc.2166(sc.2143),ELine:=sc.2166(sc.2145),ind:=sc.2127(SLine),sc.2003(sc.2136(ELine),"`n*/"),sc.2126(ELine+1,ind),sc.2003(sc.2128(SLine),"/*`n"),sc.2126(SLine+1,ind)
		Loop,% ELine-SLine+1
			sc.2126((line:=SLine+(A_Index)),sc.2127(line)+indent)
		ELine+=2,nextline:=1
	}else{
		top:=sc.2225(sc.2166(sc.2143)),bottom:=sc.2224(top,-1),indent:=Settings.Get("//tab",5),SLine:=top,ELine:=bottom-2,nextline:=0
		Loop,% bottom-top-1
			ind:=sc.2127(A_Index+top),sc.2126(A_Index+top,ind-indent)
		if(Trim(Trim(sc.GetLine(top)),"`n")="/*")
			for a,b in [bottom,top]
				start:=sc.2167(b),length:=(sc.2136(b)+1)-start,start:=sc.2136(b)=sc.2006?start-1:start,sc.2645(start,length)
	}if(v.Options.Disable_Line_Status!=1)
		Loop,% ELine-SLine+1
			LineStatus.Add(SLine+(A_Index-1),2)
	sc.2079(),sc.Enable(1),Edited(),sc.2025(sc.2128(SLine+nextline)),sc.2399
}
ToggleDuplicate(){
	MouseGetPos,x,y,,control,2
	if(!sc:=s.ctrl[control+0])
		return
	ControlGetPos,wx,wy,,,,% "ahk_id" sc.sc
	pos:=sc.2022(x-wx,y-wy)
	if(sc.2507(3,pos)){
		start:=end:=pos
		while(sc.2507(3,start-1))
			start--
		while(sc.2507(3,end+1))
			end++
		end++
		Loop,% sc.2570{
			sstart:=sc.2585(A_Index-1),eend:=sc.2587(A_Index-1)
			if(sstart=start&&eend=end){
				sc.2671(A_Index-1)
				goto,DupSelEnd
			}
		}sc.2573(start,end)
	}
	DupSelEnd:
	KeyWait,Control,U
}
Toolbar_Editor(control){
	static oea,LastID,OControl,nw,tb
	ctrl:=control,color:=RGB(settings.Get("//Toolbar_Editor/@highlight",0xEE00AA))
	if(ctrl.file)
		return Default("SysTreeView321","Toolbar_Editor"),tb.ChangeIcon(settings.SSN("//toolbar/bar[@id='" LastID "']/button[@func='" menus.SSN("//*[@tv='" TV_GetSelection() "']/@clean").text "']/@id").text,ctrl.icon-1,ctrl.file)
	oea:=xml.EA(control),OControl:=control,nw:=new GUIKeep("Toolbar_Editor"),width:=Settings.Get("//IconBrowser/Win[@win='Toolbar_Editor']/@w",300),tb:=ToolBar.keep[oea.toolbar]
	nw.Add("ComboBox,gtesearch w460 vedit gTEFindTV,,w", "ListView,xm w260 h200 gTESelect AltSubmit -Multi,Toolbars,h", "TreeView,x+0 w200 h200 Checked AltSubmit,,wh", "ListView,x+M200 yM w" width " h180 icon Section gSelectIcon AltSubmit,Icon,xh")
	ControlGet,hwnd,hwnd,,SysListView322,% hwnd(["Toolbar_Editor"])
	new Icon_Browser(nw,hwnd,"Toolbar_Editor","xy",300,"Toolbar_Editor","Toolbar_Editor"),nw.add("Button,xm gTEHighlight,Toolbar Selection Highlight Color,y","Button,x+M gNextChecked,&Next Button,y"),nw.show("Toolbar Editor"),total:="",cross:=[],Default("SysTreeView321","Toolbar_Editor"),all:=menus.SN("//main/descendant::*")
	while,aa:=all.item[A_Index-1],ea:=xml.ea(aa){
		if(aa.HasChildNodes())
			aa.SetAttribute("tv",TV_Add(ea.clean,SSN(aa.ParentNode,"@tv").text))
		else if(aa.nodename="menu")
			clean:=RegExReplace(ea.clean,"_"," "),aa.SetAttribute("tv",TV_Add(clean,SSN(aa.ParentNode,"@tv").text)),total.=clean "|",cross[clean]:=ea.clean
	}
	GuiControl,Toolbar_Editor:,ComboBox1,% Trim(total,"|")
	Gosub,TEPopulateBars
	Enable("SysTreeView321","tetv","Toolbar_Editor")
	goto,TESelect
	return
	TEHighlight:
	color:=RGB(clr:=Dlg_Color(settings.Get("//Toolbar_Editor/@highlight",0xEE00AA),nw.hwnd)),settings.Add("Toolbar_Editor",{highlight:clr}),Default("SysListView321","Toolbar_Editor"),LV_GetText(id,LV_GetNext()),ea:=MainWin.gui.ea("//controls[@win=1]/descendant::control[@id='" id "']"),winname:=ea.win,current:=ea.hwnd,tb:=ToolBar.keep[ea.hwnd]
	Gui,% oea.win ":Color",%color%,%color%
	WinActivate,% nw.id
	return
	ResetToolbar:
	color:=RGB(settings.SSN("//fonts/font[@style=5]/@background").text),all:=MainWin.Gui.SN("//*[@type='Toolbar']")
	while(aa:=all.item[A_Index-1]),ea:=xml.EA(aa)
		Gui,% ea.win ":Color",%color%,%color%
	return
	TESelect:
	Default("SysListView321","Toolbar_Editor"),LV_GetText(id,LV_GetNext())
	if(!settings.SSN("//toolbar/bar[@id='" id "']"))
		return Default("SysListView321","Toolbar_Editor"),LV_Modify(1,"Select Vis Focus")
	if(id!=LastID){
		Gosub,ResetToolbar
		DeSelect:=settings.SN("//toolbar/bar[@id='" LastID "']/descendant::button"),LastID:=id
		while(dd:=DeSelect.item[A_Index-1]),ea:=XML.EA(dd)
			Default("SysTreeView321","Toolbar_Editor"),TV_Modify(menus.SSN("//*[@clean='" ea.func "']/@tv").text,"-Check")
		oea:=xml.EA(OControl:=MainWin.GUI.SSN("//*[@id='" id "']")),color:=RGB(settings.Get("//Toolbar_Editor/@highlight",0xEE00AA)),LastID:=id
		Gui,% oea.win ":Color",%color%,%color%
		Select:=settings.SN("//toolbar/bar[@id='" LastID "']/descendant::button")
		while(ss:=Select.item[A_Index-1]),ea:=XML.EA(ss)
			Default("SysTreeView321","Toolbar_Editor"),TV_Modify(menus.SSN("//*[@clean='" ea.func "']/@tv").text,"Check")
	}
	return
	TEPopulateBars:
	all:=MainWin.Gui.SN("//*[@type='Toolbar']"),Default("SysListView321","Toolbar_Editor"),LV_Delete()
	while(aa:=all.item[A_Index-1]),ea:=XML.EA(aa)
		LV_Add((ea.id=oea.id?"Select Vis Focus":""),ea.id)
	return
	Toolbar_EditorEscape:
	Toolbar_EditorClose:
	nw.SavePos(),nw.exit(),nw.Destroy(),remtv:=menus.SN("//*[@tv]"),oea:=LastID:=OControl:=nw:=tb:=""
	while,rr:=remtv.item[A_Index-1],ea:=xml.ea(rr)
		rr.RemoveAttribute("tv")
	Gosub,ResetToolbar
	return
	tetv:
	if(A_GuiEvent="+"||A_GuiEvent="-"||A_GuiEvent="S")
		return
	Default("SysTreeView321","Toolbar_Editor"),tvitem:=(A_GuiEvent="K")?TV_GetSelection():A_EventInfo,node:=menus.SSN("//*[@tv='" tvitem "']"),ea:=xml.ea(node)
	if(!tvitem)
		return
	if(TV_GetChild(tvitem)){
		GuiControl,Toolbar_Editor:+g,SysTreeView321
		if(TV_Get(tvitem,"Check"))
			Expand:=TV_Get(tvitem,"Expand")?"-Expand":"+Expand",TV_Modify(tvitem,"-Check " Expand)
		GuiControl,Toolbar_Editor:+gtetv,SysTreeView321
		return
	}if(TV_Get(tvitem,"C")){
		if(!settings.SSN("//toolbar/bar[@id='" LastID "']/button[@func='" ea.clean "']")){
			start:=9999
			while(settings.SSN("//toolbar/bar[@id='" LastID "']/descendant::*[@id='" ++start "']")){
			}new:=settings.Under(settings.SSN("//toolbar/bar[@id='" LastID "']"),"button",{file:"shell32.dll",func:ea.clean,icon:2,id:start,state:4,text:RegExReplace(ea.clean,"_"," "),vis:1}),tb.Add(nea:=xml.ea(new)),tb.AddButton(start),Default("SysTreeView321","Toolbar_Editor"),TV_Modify(A_EventInfo,"Select")
	}}else if(node:=settings.SSN("//toolbar/bar[@id='" LastID "']/button[@func='" ea.clean "']")){
		tb.Delete(xml.EA(node)),node.ParentNode.RemoveChild(node)
	}
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
	
	/*
		-------------------old code------------------
	*/
	/*
		sgui.xml.Transform(),Default("SysListView321","Toolbar_Editor"),LV_GetText(id,LV_GetNext()),mea:=MainWin.Gui.EA("//win[@win=1]/descendant::control[@id='" id "']")
		if(!mea.win)
			return
		color:=RGB(settings.Get("//Toolbar_Editor/@highlight",0xEE00AA))
		winname:=ea.win,current:=ea.toolbar,tb:=ToolBar.keep[mea.toolbar],LastID:=id
		Gui,% mea.win ":Color",%color%,%color%
		check:=settings.SSN("//toolbar/bar[@id='" id "']"),all:=menus.SN("//main/descendant::*")
		while,aa:=all.item[A_Index-1],ea:=xml.ea(aa)
			TV_Modify(ea.tv,SSN(check,"button[@func='" ea.clean "']")?"Check":"-Check")
		returnSelectToolbar:
		Gosub,ResetToolbar
		sgui.xml.Transform(),Default("SysListView321","Toolbar_Editor"),LV_GetText(id,LV_GetNext()),mea:=MainWin.Gui.EA("//win[@win=1]/descendant::control[@id='" id "']")
		if(!mea.win)
			return
		color:=RGB(settings.Get("//Toolbar_Editor/@highlight",0xEE00AA))
		winname:=ea.win,current:=ea.toolbar,tb:=ToolBar.keep[mea.toolbar],LastID:=id
		Gui,% mea.win ":Color",%color%,%color%
		check:=settings.SSN("//toolbar/bar[@id='" id "']"),all:=menus.SN("//main/descendant::*")
		while,aa:=all.item[A_Index-1],ea:=xml.ea(aa)
			TV_Modify(ea.tv,SSN(check,"button[@func='" ea.clean "']")?"Check":"-Check")
	*/
	return
	
	
	
	
	
	return
	;static tb,nw,LastID,cross,Visible,Current,all,color,ctrl,mea
	/*
		mea:=ea:=xml.ea(ctrl),current:=ea.hwnd,Visible:=[],items:=[],all:=menus.SN("//main/descendant::*"),nw:=new GUIKeep("Toolbar_Editor"),width:=Settings.Get("//IconBrowser/Win[@win='Toolbar_Editor']/@w",300),nw.Add("ComboBox,gtesearch w460 vedit,,w","ListView,xm w260 h200 AltSubmit,Toolbars,h","TreeView,x+0 w200 h200 Checked AltSubmit,,wh","ListView,x+M200 yM w" width " h180 icon Section gSelectIcon AltSubmit,Icon,xh")
		ControlGet,hwnd,hwnd,,SysListView322,% hwnd(["Toolbar_Editor"])
		new Icon_Browser(nw,hwnd,"Toolbar_Editor","xy",300,"Toolbar_Editor","Toolbar_Editor"),nw.add("Button,xm gTEHighlight,Highlight Color,y","Button,x+M gNextChecked,&Next Button,y"),nw.show("Toolbar Editor"),total:="",cross:=[],Default("SysTreeView321","Toolbar_Editor")
	*/
	
	
	Default("SysListView321","Toolbar_Editor"),tools:=MainWin.Gui.SN("//*[@type='Toolbar']")
	current:=ctrl.hwnd?ctrl.hwnd:current
	while(aa:=tools.item[A_Index-1]),ea:=xml.ea(aa)
		Visible[ea.hwnd]:=ToolBar.keep[ea.hwnd],LV_Add((ea.hwnd=current?"Select Vis Focus":""),ea.id)
	;Gosub,SelectToolbar
	if(ctrl.button)
		clean:=settings.SSN("//toolbar/bar[@id='" ctrl.id "']/button[@id='" ctrl.button "']/@func").text,TV_Modify(menus.SSN("//*[@clean='" clean "' and not(@top)]/@tv").text,"Select Vis Focus")
	Sort,total,UD|
	ControlFocus,Edit1,% nw.ahkid
	return
	/*
		ResetToolbar:
		color:=RGB(settings.SSN("//fonts/font[@style=5]/@background").text)
		all:=MainWin.Gui.SN("//*[@type='Toolbar']")
		while(aa:=all.item[A_Index-1]),ea:=xml.EA(aa){
			Gui,% ea.win ":Color",%color%,%color%
		}
		return
	*/
	/*
		SelectToolbar:
		Gosub,ResetToolbar
		sgui.xml.Transform(),Default("SysListView321","Toolbar_Editor"),LV_GetText(id,LV_GetNext()),mea:=MainWin.Gui.EA("//win[@win=1]/descendant::control[@id='" id "']")
		if(!mea.win)
			return
		color:=RGB(settings.Get("//Toolbar_Editor/@highlight",0xEE00AA))
		winname:=ea.win,current:=ea.toolbar,tb:=ToolBar.keep[mea.toolbar],LastID:=id
		Gui,% mea.win ":Color",%color%,%color%
		check:=settings.SSN("//toolbar/bar[@id='" id "']"),all:=menus.SN("//main/descendant::*")
		while,aa:=all.item[A_Index-1],ea:=xml.ea(aa)
			TV_Modify(ea.tv,SSN(check,"button[@func='" ea.clean "']")?"Check":"-Check")
		return
	*/
	tesearch:
	info:=nw[]
	if(tv:=menus.SSN("//*[@clean='" cross[info.edit] "']/@tv").text){
		GuiControl,Toolbar_Editor:+g,SysTreeView321
		TV_Modify(0,"-Select"),TV_Modify(tv,"Select Vis Focus")
		GuiControl,Toolbar_Editor:+gtetv,SysTreeView321
	}
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
		}
		this.Populate()
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
			return m("File already being tracked")
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
		sc:=this.sc,last:=csc().sc
		if(this.node.XML!=node.XML&&this.node.XML){
			Encode(RegExReplace(this.node.text,Chr(127),"`n"),txt),sc.2181(0,&txt)
			ea:=XML.ea(this.node),sc.2160(ea.start,ea.end)
			Sleep,10
			for a,b in StrSplit(ea.fold,","){
				sc.2237(b,0)
			}
			sc.2613(ea.scroll)
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
		sc:=this.sc,fold:=0,node:=this.node,node.RemoveAttribute("fold")
		for a,b in {start:sc.2008,end:sc.2009,scroll:sc.2152}
			node.SetAttribute(a,b)
		while,sc.2618(fold)>=0,fold:=sc.2618(fold)
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
	Default("SysTreeView321",1),ctv:=TV_GetSelection(),Scan_Line()
	if(tv.1=ctv)
		return GetPos()
	if(!sel:=files.SSN("//*[@tv='" tv.1 "']/@tv").text)
		sel:=files.SSN("//*[@tv='" tv.3 "']/@tv").text
	if(files.SSN("//*[@tv='" sel "']").NodeName="files")
		return
	if(IsObject(tv.1))
		sel:=tv.1.1
	if(!tv.2.sc)
		sc:=csc()
	else
		sc:=csc({hwnd:tv.2.sc})
	if(sc.sc=v.tnsc||sc.sc=v.debug.sc)
		sc:=csc(1)
	if(sc.sc=v.tnsc)
		return
	if(sel){
		if(!v.startup)
			GetPos()
		onode:=node:=files.SSN("//*[@tv='" sel "']"),ea:=xml.ea(node),v.DisableContext:=""
		Update({sc:sc.2357}),sc.2045(2),sc.2045(3)
		if(node.NodeName="folder"||ea.folder=1)
			return
		sc.Enable()
		if(ea.sc){
			TVState(),TVC.Modify(1,"",ea.tv,"Select Vis Focus"),sc.2358(0,ea.sc),TVState(1)
		}else if(ea.sc!=sc.2357){
			if(!ea.sc){
				sc.2358(0,0)
				Sleep,80
				doc:=sc.2357,sc.2376(0,doc),node.SetAttribute("sc",doc),tt:=update({get:ea.file}),encoding:=ea.encoding,sc.2037(65001),Encode(tt,text,encoding),sc.2181(0,&text),sc.2175(),Set(sc)
			}else
				m("The current document is not the right document. If this continues to happen please let maestrith know."),tv(files.SSN("//main/file/@tv").text)
		}TVC.Disable(1),TVC.Modify(1,"",sel,"Select Vis Focus"),TVC.Enable(1)
		if(IsObject(tv.2)){
			sc.2160(tv.2.start,tv.2.end),CenterSel()
			v.tvpos:=pos:=xml.EA(positions.Find(positions.Find("//main/@file",SSN(node.ParentNode,"@file").text),"descendant::file/@file",SSN(node,"@file").text))
			if(pos.fold!="")
				for a,b in StrSplit(pos.fold,",")
					sc.2237(b,0)
		}else{
			pos:=positions.EA(positions.Find(positions.Find("//main/@file",SSN(node,"ancestor-or-self::*/@file").text),"descendant::file/@file",SSN(node,"@file").text))
			(pos.scroll!="")?sc.2613(pos.scroll):"",(pos.start||pos.end)?sc.2160(pos.start,pos.end):""
			if(pos.fold!="")
				for a,b in StrSplit(pos.fold,",")
					sc.2237(b,0)
		}sc.Enable(1),node:=gui.SSN("//*[@hwnd='" sc.sc+0 "']"),node.SetAttribute("file",ea.file)
	}else if(tv.2.end!="")
		pos:=tv.2,sc.2160(pos.start,pos.end),CenterSel()
	else{
		SetTimer,ScanWID,-200
		return Default("SysTreeView321"),TV_Modify(A_EventInfo,(TV_Get(A_EventInfo,"Expand")?"-":"") "Expand")
	}
	SetTimer,ScanWID,-200
	sc.2400(),WinSetTitle(1,ea),DebugHighlight()
	if(!v.startup)
		TNotes.GetPos(),TNotes.Set(ea.file)
	if(!IsObject(tv.1))
		History(onode,sc)
	LineStatus.tv()
	return
	ScanWID:
	Words_In_Document(1),MarginWidth()
	return
}
TVIcons(x:=""){
	static il,track:=[]
	if(x=1||x=2){
		obj:={1:"File Icon",2:"Folder Icon"}
	}else if(x.file){
		root:=settings.SSN("//icons/pe")
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
	}if(settings.SSN("//icons/pe/@show").text||seticons)
		ea:=settings.ea("//icons/pe"),il:=IL_Create(3,1,0),IL_Add(il,ea.folderfile?ea.folderfile:"shell32.dll",ea.folder?ea.folder:4),IL_Add(il,ea.filefile?ea.filefile:"shell32.dll",ea.file?ea.file:2)
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
Undo(){
	csc().2176
}
UnSaved(){
	un:=files.SN("//main[@untitled]"),ts:=settings.SSN("//template").text,file:=FileOpen("c:\windows\shellnew\template.ahk",0),td:=file.Read(file.length),file.close(),template:=ts?ts:td
	while,uu:=un.item[A_Index-1],ea:=xml.ea(uu.FirstChild){
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
			newfile:=SubStr(newfile,-3)!=".ahk"?newfile ".ahk":newfile,file:=FileOpen(newfile,"RW","UTF-8"),file.seek(0),file.write(RegExReplace(text,"\R","`r`n")),file.length(file.position),file.close()
			if(!settings.SSN("//open/file[text()='" newfile "']")&&newfile)
				settings.add("open/file",,newfile)
			settings.add("last/file",,newfile)
			uu.RemoveChild(uu.FirstChild)
	}}v.unsaved:=1
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
			Save(),settings.Save(1)
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
		sc:=csc(),fn:=files.SSN("//*[@sc='" info.sc "']"),ea:=xml.ea(fn),item:=ea.file?ea.file:ea.note,text:=sc.GetUNI()
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
UpdateWordsInDocument(text,remove:=0){
	sc:=csc()
	if(remove){
		words:=v.words[sc.2357],NewWords:=RegExReplace(RegExReplace(text,"(\b\d+\b|\b\w{1,2}\b)",""),"x)(\W)"," "),OText:=sc.GetUNI()
		if(NewWords){
			for a,b in StrSplit(NewWords," "){
				if(OText~="i)\b" b "\b"=0)
					StringReplace,words,words,%b%
			}
			v.words[sc.2357]:=Trim(RegExReplace(words,"\s+"," "))
		}
	}else{
		words:=v.words[sc.2357]
		NewWords:=RegExReplace(RegExReplace(text,"(\b\d+\b|\b\w{1,2}\b)",""),"x)(\W)"," ")
		if(NewWords){
			words.=" " NewWords
			Sort,words,UCD%A_Space%
			v.words[sc.2357]:=Trim(words)
		}
	}
}
Upper(text){
	StringUpper,text,text
	return text
}
UpPos(){
	static lastline,lastpos
	sc:=csc(),line:=sc.2166(sc.2008)
	if(v.track.line)
		if(v.track.line!=line||v.track.file!=Current(2).file)
			v.track:=[]
	if(lastline!=line)
		hltline()
	if(Abs(sc.2008-sc.2009)>1){
		Duplicates()
	}else
		sc.2500(3),sc.2505(0,sc.2006),v.duplicateselect:=[]
	text:="Line:" sc.2166(sc.2008)+1 " Column:" sc.2129(sc.2008) " Length:" sc.2006 " Position:" sc.2008,total:=0
	if(sc.2008!=sc.2009){
		text.=" Selected Count:" Abs(sc.2008-sc.2009)
		if(sc.2570>1){
			Loop,% sc.2570
				total+=Abs(sc.2579(A_Index-1)-sc.2577(A_Index-1))
			text.=" Total Selected:" total
	}}if(v.LineEdited.MinIndex()!=""&&!v.LineEdited.HasKey(line)&&line)
		Scan_Line()
	if(line!=lastline)
		v.DisableContext:=""
	SetStatus(text,1),lastline:=line
	SetTimer,BraceHighlight,-1
	if(sc.2008=sc.2009&&lastpos!=sc.2008)
		SetTimer,UnderlineDuplicateWords,-500
	else if(sc.2008!=sc.2009)
		sc.2500(6),sc.2505(0,sc.2006)
	lastpos:=sc.2008
}
URLDownloadToVar(url){
	http:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
	if(proxy:=settings.ssn("//proxy").text)
		http.setProxy(2,proxy)
	http.Open("GET",url,1),http.Send(),http.WaitForResponse
	return http.ResponseText
}
WalkDownClasses(text,find){
	pos:=1
	while(RegExMatch(text,v.OmniFind.Class,ff,pos)),pos:=ff.Pos(1)+ff.Len(1){
		if(!ff.len(1))
			break
		found:=GetClassText(text,ff.2,ff.pos(1))
		search:=SubStr(text,ff.pos(1),found.pos(1)-ff.pos(1))
		RegExMatch(search,v.OmniFind.Class,ss)
		if(ss.2=find)
			return {StartLine:StartLine,EndLine:EndLine,text:search,obj:ff}
		pos:=found.pos(1)+found.len(1)
	}
}
WinActivate(win){
	WinActivate,%win%
}
WinSetTitle(win:=1,title:="AHK Studio",Open:=0){
	if(IsObject(title)){
		WinSetTitle,% hwnd([win]),,% (open?"Include Open!  -  ":"") "AHK Studio - " (Current(3).edited?"*":"") (title.dir "\" (v.options.Hide_File_Extensions?title.nne:title.filename))
	}else
		WinSetTitle,% hwnd([win]),,%title%
}
Words_In_Document(NoDisplay:=0,text:="",Remove:="",AllowLastWord:=0){
	sc:=csc(),AllText:=sc.GetUNI(),word:=sc.GetWord(),doc:=text?text:AllText,pos:=1
	while(RegExMatch(doc,"OU)(\w+-\w+)",found,pos),pos:=found.Pos(1)+found.Len(1)){
		if(!found.len(1))
			Break
		doc:=RegExReplace(doc,found.1)
	}
	Words:=RegExReplace(RegExReplace(doc,"(\b\d+\b|\b(\w{1,2})\b)",""),"x)([^\w])"," ")
	if(word&&!AllowLastWord)
		words:=RegExReplace(words,"\b" word "\b")
	if(text){
		OWords:=v.words[sc.2357]
		if(Remove){
			pos:=1
			Sort,words,CUD%A_Space%
			while(RegExMatch(words,"O)\b(\w+)\b",found,pos),pos:=found.Pos(1)+found.Len(1)){
				if(!found.len(1))
					Break
				if(!RegExMatch(AllText,"i)\b" found.1 "\b"))
					OWords:=RegExReplace(OWords,"\b" found.1 "\b")
			}
			words:=OWords
		}else
			words.=" " OWords
	}
	Sort,words,CUD%A_Space%
	words:=Trim(words),v.words[sc.2357]:=words
	if(!NoDisplay)
		sc.2100(StrLen(word),words)
}
Wrap_Word_In_Quotes(){
	sc:=csc(),sc.2078,cpos:=sc.2008,start:=sc.2266(sc.2008,1),end:=sc.2267(sc.2008,1),sc.2003(start,Chr(34)),sc.2003(end+1,Chr(34)),sc.2025(cpos+1),sc.2079
}
Delete(){
	return Backspace(0)
}
Backspace(sub:=1){
	ControlGetFocus,focus,A
	send:=sub?"Backspace":"Delete"
	if(!InStr(focus,"Scintilla")||!v.Options.Smart_Delete){
		Send,{%send%}
		Edited()
		return
	}
	sc:=csc()
	if(sc.2102){
		if(sub)
			Send,{Backspace}
		else
			sc.2101
		return
	}
	sc.2078
	Loop,% sc.2570{
		cpos:=sc.2585(A_Index-1)-sub,chr:=Chr(sc.2007(cpos)),style:=sc.2010(cpos),pos:=sc.2585(A_Index-1),line:=sc.2166(cpos)
		if((start:=sc.2585(A_Index-1))!=(end:=sc.2587(A_Index-1))){
			sc.2645(start,end-start)
			Continue
		}else if(style~="\b(13|11|1)\b"){
			sc.2645(cpos,1)
			Continue
		}chr:=Chr(sc.2007(cpos))
		if(!v.BraceDelete[chr]&&!v.DeleteBrace[chr]){
			sc.2645(cpos,1)
			Continue
		}else if(match:=v.BraceDelete[chr]){
			if(match=Chr(sc.2007(cpos+1)))
				sc.2645(cpos,2)
			else if((bracematch:=sc.2353(cpos))>=0)
				sc.2645(bracematch,1),sc.2645(cpos,1),sc.2584(A_Index-1,cpos),sc.2586(A_Index-1,bracematch-1)
			else
				GoToPos(A_Index-1,cpos)
		}else if(match:=v.DeleteBrace[chr]){
			if(match=Chr(sc.2007(cpos-1)))
				sc.2645(cpos-1,2)
			else
				GoToPos(A_Index-1,cpos-(sub?0:-1))
		}
	}sc.2079
}
IndentFrom(line){
	sc:=csc()
	begin:=sc.2127(line)
	FileText:=sc.TextRange(sc.2167(line),sc.2006)
	;m("Start at line: " line,"Indentation: " begin,"Text:",FileText)
}
FoldParent(){
	sc:=csc(),line:=find:=sc.2166(sc.2008)
	while((find:=sc.2225(find))>=0)
		line:=find
	return line
}
GetClass(class,current:=""){
	current:=current?current:Current(5),root:=SSN(current,"info[@type='Class' and @text='" class.baseclass "']")
	if(class.baseclass!=class.inside)
		nest:=SSN(current,"descendant::info[@type='Class' and @text='" class.inside "']")
	return nest?nest:root
}
InsertMultiple(caret,cpos,text,end){
	sc:=csc(),sc.2686(cpos,cpos),sc.2194(StrPut(text,"UTF-8")-1,text),sc.2584(caret,end),sc.2586(caret,end)
}
GoToPos(caret,pos){
	sc:=csc(),sc.2584(caret,pos),sc.2586(caret,pos)
}
InsertAll(text,add){
	sc:=csc(),sc.2078
	Loop,% sc.2570
		InsertMultiple(A_Index-1,(pos:=sc.2585(A_Index-1)),text,pos+add)
	sc.2079
}
ReplaceText(start,end,text){
	sc:=csc(),sc.2686(start,end),sc.2194(StrPut(text,"UTF-8")-1,text)
}
RemoveComment(text){
	text:=Trim(text,"`n")
	if(InStr(text,Chr(59)))
		text:=RegExReplace(text,"\s+" Chr(59) ".*")
	return text
}
Download_Plugins(){
	static plug
	if(!FileExist("plugins"))
		FileCreateDir,Plugins
	DllCall("InetCpl.cpl\ClearMyTracksByProcess",uint,8)
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
		LV_GetText(name,num),pos:=1,text:=RegExReplace(URLDownloadToVar("https://raw.githubusercontent.com/maestrith/AHK-Studio-Plugins/master/" name ".ahk"),"\R","`r`n"),list:=""
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
	m("Installation Report:",RegExReplace(pluglist,"\R"," - "))
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
Previous_File(){
	Default("SysTreeView321"),prev:=0,tv:=TV_GetSelection()
	while,tv!=prev:=TV_GetNext(prev,"F")
		newtv:=prev
	TV_Modify(newtv,"Select Vis Focus")
}
Next_File(){
	Default("SysTreeView321"),TV_Modify(TV_GetNext(TV_GetSelection(),"F"),"Select Vis Focus")
}
Previous_Scripts(filename=""){
	static nw
	nw:=new GUIKeep("Previous_Scripts"),nw.add("Edit,w400 gPSSort vSort,,w","ListView,w400 h400,File,wh","Button,xm gPSOpen Default,&Open Selected,y","Button,x+M gPSRemove,&Remove Selected,y","Button,x+M gPSClean,&Clean UpProjects,y"),nw.show("Previous Scripts"),Hotkeys("Previous_Scripts",{up:"pskey",down:"pskey",PgUp:"pskey",PgDn:"pskey","+up":"pskey","+down":"pskey"})
	gosub,populateps
	return
	PSSort:
	PSBreak:=1
	Sleep,20
	PSBreak:=0
	goto,populateps
	return
	PSClean:
	scripts:=settings.sn("//previous_scripts/*"),filelist:=[]
	while,ss:=scripts.item[A_Index-1],ea:=xml.ea(ss)
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
	scripts:=settings.sn("//previous_scripts/*")
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
	nw.exit()
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
	scripts:=settings.SN("//previous_scripts/*")
	LV_Delete(),sort:=nw[].Sort
	while,scr:=scripts.item[A_Index-1]{
		if(PSBreak)
			break
		info:=scr.text
		SplitPath,info,filename
		if(InStr(filename,sort))
			LV_Add("",info)
	}PSBreak:=0
	LV_ModifyCol(1,"AutoHDR"),LV_Modify(1,"Select Vis Focus")
	return
}
Rename_Current_Include(current:=""){
	if(!current.xml)
		current:=Current()
	ea:=xml.EA(current)
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
	RemoveHistory(ea.file),ScanFiles(),node:=cexml.Find("//@file",ea.file),node.ParentNode.RemoveChild(node),Code_Explorer.Refresh_Code_Explorer()
	SplashTextOff
}
Remove_Include(){
	current:=Current(),mainnode:=Current(1),curfile:=Current(3).file,Parent:=Current(1)
	if(Current(3).file=Current(2).file)
		return m("Can not remove the main Project")
	if(m("Are you sure you want to remove this Include?","btn:yn","def:2")="no")
		return
	all:=files.SN("//main[@file='" Current(2).file "']/descendant::file"),contents:=Update("get").1,inc:=Current(3).include
	while,aa:=all.item[A_Index-1],ea:=xml.ea(aa){
		text:=contents[ea.file]
		if(f:=InStr(text,inc)){
			if(m("Permanently delete this file?","btn:yn","def:2")="Yes")
				FileDelete,% Current(3).file
			FileNode:=files.Find(Current(1),"descendant::file/@file",Current(3).file)
			Update({file:ea.file,text:RegExReplace(text,"\R?\Q" inc "\E\R?","`n")})
			files.Find(files.Find("//main/@file",Current(2).file),"descendant::file/@file",Current(2).file).RemoveAttribute("sc")
			Update({delete:curfile})
			if(tv:=SSN(FileNode,"@tv").text)
				Default("SysTreeView321"),TV_Delete(tv)
			all:=cexml.Find(cexml.Find("//main/@file",Current(2).file),"descendant::*/@file",Current(3).file,0)
			while(aa:=all.item[A_Index-1]),ea:=xml.EA(aa)
				aa.ParentNode.RemoveChild(aa)
			node:=files.Find(Parent,"descendant::file/@file",curfile),node.ParentNode.RemoveChild(node)
			RemoveHistory(ea.file),Edited(Current(1))
			return
		}
	}
}
RemoveHistory(file){
	if((list:=History.Find("//*/@file",file,0)).length)
		while(ll:=list.item[A_Index-1])
			ll.ParentNode.RemoveChild(ll)
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
	while(aa:=all.item[A_Index-1]),ea:=xml.EA(aa)
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
	settings.SSN(a)
	Activate(a,b,c)
	text(text)text{text}text"text"
	text(text)text{text}text"text"
	text(text)text{text}text"text"
	MsgBox,hello
*/
;comments
Add_Selected_To_Personal_Variables(){
	sc:=csc()
	if(!text:=sc.GetSelText())
		return m("Please select some text first")
	Words:=RegExReplace(RegExReplace(text,"x)([^\w])"," "),"(\b\d+\b|\b(\w{1,2})\b)","")
	Sort,Words,UD%A_Space%
	if(!top:=settings.SSN("//Variables"))
		top:=settings.Add("Variables")
	for a,b in StrSplit(Words," "){
		if(!b:=Trim(b))
			Continue
		if(!settings.SSN("//Variables/Variable[text()='" b "']"))
			settings.Under(top,"Variable",,b)
	}Keywords()
}
Select_Next_Duplicate(){
	sc:=csc(),xx:=sc.2577(sc.2575())
	for a,b in v.duplicateselect[sc.2357]{
		if(xx<a){
			sc.2573(a+b,a),sc.2169()
			break
}}}
Create_Include_From_Selection(){
	pos:=PosInfo(),sc:=csc()
	if(pos.start=pos.end)
		return m("Please select some text to create a new Include from")
	text:=sc.GetSelText(),RegExMatch(text,"^(\w+)",Include),filename:=Current(2).file
	SplitPath,filename,,dir
	FileSelectFile,Filename,S16,% dir "\" RegExReplace(Include1,"_"," ") ".ahk",Confirm New File,*.ahk
	if(ErrorLevel||Filename="")
		return
	if(FileExist(Filename))
		return m("Include name already exists. Please choose another")
	if(files.Find(Current(1),"//@file",Filename))
		return m("This file is already included in this Project")
	sc.2326()
	AddInclude(Filename(Filename),text,{start:StrPut(Include1 "(","UTF-8")-1,end:StrPut(Include1 "(","UTF-8")-1})
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
Fix_Indent(){
	sc:=csc(),FixLines(0,sc.2166(sc.2006)),sc.Enable(1)
}
Remove_Spaces_From_Selected(){
	sc:=csc()
	if(!text:=sc.GetSelText())
		return m("Select some text first")
	sc.2170(0,[RegExReplace(text,"\s")])
}
Go_To_Line(){
	sc:=csc()
	value:=InputBox(sc.sc,"Go To Line","Enter the Line Number you want to go to max = " sc.2154,sc.2166(sc.2008)+1)
	if(RegExMatch(value,"\D")||value="")
		return m("Please enter a line number")
	sc.2025(sc.2128(value-1))
}
Display_Hotkeys(){
	all:=menus.SN("//*[@hotkey!='']"),newwin:=new GUIKeep("hotkeys"),newwin.Add("ListView,w400 h600,Action|Hotkey,wh")
	while(aa:=all.item[A_Index-1]),ea:=xml.EA(aa)
		LV_Add("",ea.clean,Convert_Hotkey(ea.hotkey))
	Loop,2
		LV_ModifyCol(A_Index,"AutoHDR")
	newwin.Show("Hotkeys"),LV_ModifyCol(1,"Sort")
}
Edit_Comment_Insert(){
	InputBox,comment,Enter a new comment insert,Enter your new comment insert,,,,,,,,% settings.Get("//comment",";")
	if(ErrorLevel)
		return
	settings.Add("comment",{"xml:space":"preserve"},comment)
}
FormatTime(format,time){
	FormatTime,out,%time%,%format%
	return out
}
Check_For_Update(startup:=""){
	static newwin
	static DownloadURL:="https://raw.githubusercontent.com/maestrith/AHK-Studio/master/AHK-Studio.ahk",VersionTextURL:="https://raw.githubusercontent.com/maestrith/AHK-Studio/master/AHK-Studio.text"
	;static DownloadURL:="https://raw.githubusercontent.com/maestrith/AHK-Studio/flan/AHK-Studio.ahk",VersionTextURL:="https://raw.githubusercontent.com/maestrith/AHK-Studio/flan/AHK-Studio.text"
	Run,RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 8
	auto:=settings.ea("//autoupdate"),sub:=A_NowUTC
	if(startup=1){
		if(v.Options.Auto_Check_For_Update_On_Startup!=1)
			return
		if(auto.reset>A_Now)
			return
	}
	sub-=A_Now,hh
	FileGetTime,time,%A_ScriptFullPath%
	time+=sub,hh
	ea:=settings.ea("//github"),token:=ea.token?"?access_token=" ea.token:"",url:="https://api.github.com/repos/maestrith/AHK-Studio/commits" token,http:=ComObjCreate("WinHttp.WinHttpRequest.5.1"),http.Open("GET",url)
	if(proxy:=settings.ssn("//proxy").text)
		http.setProxy(2,proxy)
	http.Send(),RegExMatch(http.ResponseText,"iUO)\x22date\x22:\x22(.*)\x22",found),date:=RegExReplace(found.1,"\D")
	if(startup="1"){
		if(reset:=http.GetResponseHeader("X-RateLimit-Reset")){
			seventy:=19700101000000
			for a,b in {s:reset,h:-sub}
				EnvAdd,seventy,%b%,%a%
			settings.add("autoupdate",{reset:seventy})
			if(time>date)
				return
		}else
			return
	}
	Version:="1.003.2"
	newwin:=new GUIKeep("CFU"),newwin.add("Edit,w400 h400 ReadOnly,No New Updates,wh","Button,gautoupdate,&Update,y","Button,x+5 gcurrentinfo,&Current Changelog,y","Button,x+5 gextrainfo,Changelog &History,y"),newwin.show("AHK Studio Version: " version)
	if(time<date){
		file:=FileOpen("changelog.txt","rw"),file.seek(0),file.write(update:=RegExReplace(UrlDownloadToVar(VersionTextURL),"\R","`r`n")),file.length(file.position),file.Close()
		ControlSetText,Edit1,%update%,% newwin.ahkid
	}if(!found.1)
		ControlSetText,Edit1,% http.ResponseText,% newwin.ahkid
	return
	autoupdate:
	save(),settings.save(1),menus.save(1),studio:=URLDownloadToVar(DownloadURL)
	if(!InStr(studio,";download complete"))
		return m("There was an error. Please contact maestrith@gmail.com if this error continues")
	SplitPath,A_ScriptFullPath,,,ext,nne
	if(!FileExist("Older Versions"))
		FileCreateDir,Older Versions
	FileMove,%nne%.ahk,%A_ScriptDir%\Older Versions\%nne% - %version%.ahk,1
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
		file:=FileOpen("changelog.txt","rw"),file.seek(0),file.write(RegExReplace(UrlDownloadToVar(VersionTextURL),"\R","`r`n")),file.length(file.position)
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
		VarSetCapacity(hints,8*A_PtrSize,0)
		for a,b in {6:8,1:12}
			NumPut(a,hints,b)
		DllCall("ws2_32\getaddrinfo",astr,"127.0.0.1",astr,"9000","uptr",hints,"ptr*",results)
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
				return m("Debugging has stopped")
			While(debug.wait){
				Sleep,10
				if(debug.socket<1)
					return
				if(A_Index>20){
					debug.wait:=0,v.ready:=1,debug.Receive(),InsertDebugMessage()
					Break
		}}}
		return
	}Receive(){
		static last
		;Thank you Lexikos and fincs http://ahkscript.org/download/tools/DBGP.ahk
		socket:=debug.socket
		while(DllCall("ws2_32\recv","ptr",socket,"char*",c,"int",1,"int",0)){
			if(c=0)
				break
			length.=Chr(c)
		}
		now:=A_Now
		if(length<=0)
			return debug.wait:=0
		VarSetCapacity(packet,++length,0),recd:=0
		While(r<length){
			index:=A_Index,rr:=r
			r:=DllCall("ws2_32\recv","ptr",socket,"ptr",&packet,"int",length,"int",0x2)
			if(!debug.socket)
				m("Socket Disconnected, Debugging has stopped")
			if(r<1)
				error:=DllCall("GetLastError"),t(r,socket,length,received,"An error occured",error,"Possible reasons for the error:","1.  Sending OutputDebug faster than 1ms per message","2.  Max_Depth or Max_Children value too large","time:2")
			if(r<length)
				Sleep,5
			if(A_Index>10){
				crap:=1
				break
		}}DllCall("ws2_32\recv","ptr",socket,"ptr",&packet,"int",length,"int",0)
		debug.wait:=0
		if(!IsObject(v.displaymsg))
			v.displaymsg:=[]
		if(info:=StrGet(&packet,length-1,"UTF-8")){
			v.displaymsg.push(info)
			SetTimer,Display,-10
		}
		if(crap){
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
		color:=state=1?0x0000ff:settings.Get("//fonts/font[@code=2069]/@color",0xFFFFFF)
		width:=state=1?3:settings.Get("//fonts/font[@code=2188]/@value",1)
		for a,b in s.ctrl
			b.2069(color),b.2188(width)
	}
}
Debug_Current_Script(){
	Scan_Line()
	if(debug.socket){
		sc:=v.debug,sc.2003(sc.2006,"`nKilling Current Process"),debug.Send("stop")
		Sleep,200
		if(debug.Socket){
			debug.Send("stop")
			Sleep,200
	}}new debug()
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
Run_Program(){
	if(!debug.socket)
		return Run()
	debug.Send("run")
}
GetChildren(){
	obj:=v.GetChildren
	while(ea:=obj.pop()){
		debug.Send("feature_set -n max_depth -v " ea.children),debug.Send("feature_set -n max_children -v " ea.numchildren),debug.Send("property_get -n " ea.fullname " -m " ea.numchildren " -i " ea.scope),debug.Send("feature_set -n max_depth -v 0"),debug.Send("feature_set -n max_children -v 0")
		Sleep,50
}}
VarBrowser(){
	static newwin,treeview
	if(!debug.VarBrowser){
		debugwin:=newwin:=new GUIKeep(98),newwin.Add("TreeView,w400 h200 gvalue vtreeview AltSubmit hwndtreeview,,wh","ListView,w400 r4 AltSubmit gVBGoto,Stack|File|Line,wy","Text,w200 Section,Debug Controls:,y","Button,gRun_Program,&Run,y","Button,x+M gStep_Into,Step &Into,y","Button,x+M gStep_Out,Step &Out,y","Button,x+M gStep_Over,Step O&ver,y","Button,x+M gStop_Debugger,&Stop,y"),newwin.show("Variable Browser"),hwnd:=newwin.XML.SSN("//*/@hwnd").text,debug.VarBrowser:=1
	}
	SetTimer,ProcessDebugXML,-100
	return
	98Close:
	98Escape:
	debug.xml:=new XML("debug"),debug.xml.Add("local"),debug.xml.Add("global"),debug.VarBrowser:=0,newwin.Exit()
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
	if(A_GuiEvent="+"&&(node:=debug.xml.SSN("//*[@tv='" A_EventInfo "']"))){
		if(node.NodeName="property"){
			node.SetAttribute("expanded",1)
			if(SSN(node,"descendant::wait"))
				scan:=1
	}}
	if(A_GuiEvent="-"&&(node:=debug.xml.SSN("//*[@tv='" A_EventInfo "']")))
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
Display(PopulateVarBrowser:=0){
	static receive:=new XML("receive"),total,width,addhotkey,lastid,StoreXML:=[],c:=[],ProcessProperties:=[],scope
	store:="",sc:=v.debug,xx:=debug.xml
	;xx:=new XML() ;for Studio
	while(store:=v.displaymsg.pop()){
		receive.xml.LoadXML(store),rea:=xml.EA(info:=receive.SSN("//*"))
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
			while,bb:=bp.item[A_Index-1],bpea:=xml.ea(bb)
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
					file:=ea.filename,scope:=ea.where="Auto-execute thread"?"Global":RegExReplace(ea.where,"(\..*)"),xx.Add("master",{scope:scope}),exist:=1,v.DebugLineNumber:=ea.lineno-1
					if(WinExist(debugwin.id)){
						WinSetTitle,% debugwin.id,,% "Variable Browser : Current Scope = " ea.where
						scope:=receive.SN("//descendant::stack"),Default("SysListView321",98),LV_Delete()
						while(ss:=scope.item[A_Index-1]),ea:=XML.EA(ss){
							LV_Add("",ea.where,filename,ea.lineno)
						}Loop,3
							LV_ModifyCol(A_Index,"AutoHDR")
			}}}DebugHighlight(),debug.Send("context_names -i Context_Names"),sc:=v.debug,debug.Focus()
		}else if(rea.command="context_names"){
			context:=receive.SN("//context")
			while(cc:=context.item[A_Index-1]),ea:=XML.EA(cc){
				if(!xx.SSN("//scope[@id='" ea.id "']"))
					xx.Add("scope",ea,,1)
				Sleep,100
				debug.Send("context_get -c " ea.id " -i " (ea.id=0?xx.SSN("//master/@scope").text:ea.name))
		}}else if(rea.command="context_get"){
			all:=SN(info,"descendant-or-self::property"),pea:=xml.EA(info),xx:=debug.xml,master:=xx.SSN("//scope[@id='" pea.context "']"),scope:=xx.SSN("//master/@scope").text
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
		}if(v.Options.Verbose_Debug_Window)
			receive.Transform(),receive.Transform(),Debug(receive[]),t()
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
URIDecode(str){
	Loop{ ;by Titam
		If(RegExMatch(str,"i)(?<=%)[\da-f]{1,2}",hex))
			StringReplace,str,str,`%%hex%,% Chr("0x" hex),All
		else Break
	}
	Return, str
}
List_Variables(){
	if(!debug.socket)
		return m("Currently no file being debugged","time:1"),debug.off()
	VarBrowser(),debug.Send("stack_get")
}
listvars(){
	List_Variables()
}
Previous_Project(){
	current:=Current(1)
	next:=current.previousSibling?current.previousSibling:current.ParentNode.LastChild
	if(SSN(next,"@file").text="Libraries")
		next:=next.previousSibling
	tv(SSN(next,"descendant::*/@tv").text)
}
Next_Project(){
	current:=Current(1)
	next:=current.nextSibling?current.nextSibling:current.ParentNode.FirstChild
	if(SSN(next,"@file").text="Libraries")
		next:=current.ParentNode.FirstChild
	tv(SSN(next,"descendant::*/@tv").text)
}
Highlight_to_Matching_Brace(){
	sc:=csc()
	if((start:=sc.2353(sc.2008-1))>0)
		return sc.2160(start,sc.2008)
	Else if((start:=sc.2353(sc.2008))>0)
		sc.2160(start+1,sc.2008)
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
ScanChildren(){
	xx:=debug.XML,exp:=xx.SN("//descendant::*[@expanded=1]") ;xx:=new XML()
	while(ee:=exp.item[A_Index-1]),ea:=XML.EA(ee){
		if(!ea.transaction)
			ee.SetAttribute("transaction",(ea.transaction:=xx.SN("//*[@transaction]").length+1))
		if((list:=SN(ee,"descendant::*[@expanded=1]")).length){
			children:=1,numchildren:=Round(ea.children)
			while(ll:=list.item[A_Index-1]),cea:=XML.EA(ll)
				children++,numchildren+=cea.numchildren
			if(ee.NodeName="scope")
				ea.fullname:=ea.name
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
ProcessDebugXML(){
	if(!debug.VarBrowser)
		return v.ready:=1
	xx:=debug.xml ;xx:=new XML()
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
DebugHighlight(){
	sc:=csc(),sc.2045(2),sc.2045(3)
	for a,b in v.DebugHighlight[Current(3).file]{
		sc.2043(b,2)
		if(A_Index=1)
			SelectDebugLine(b)
}}
SelectDebugLine(line){
	sc:=csc()
	if(v.Options.Select_Current_Debug_Line)
		sc.2160(sc.2167(line),sc.2136(line))
	else
		first:=sc.2152,lines:=sc.2370,half:=Floor(lines/2),NewLine:=((((line)-half)>0)?(line)-half:0),sc.2613(NewLine)
}
Report_Bugs(){
	if(m("Do you have a Github account?","btn:yn")="Yes")
		Run,https://github.com/maestrith/AHK-Studio/issues
	else
		Run,https://gitreports.com/issue/maestrith/AHK-Studio
}
Manage_File_Types(){
	static newwin
	newwin:=new GUIKeep("Manage_File_Types"),newwin.Add("ListView,w200 h200,File Type,wh","Edit,vedit,,y","Button,gMFTAdd Default,Add,y","Button,x+M gMFTDelete,&Delete Selected,y"),newwin.Show("Manage File Types")
	Hotkeys("Manage_File_Types",{Delete:"MFTDelete",Backspace:"MFTDelete"})
	Gosub,MFTPopulate
	ControlFocus,Edit1,% newwin.id
	return
	MFTAdd:
	value:=newwin[].edit
	if(!value)
		return m("Please enter a single extension in the Edit Control")
	if(value~="\W")
		return m("File extensions can not include any non-character items. Only valid characters are [A-Z,a-z,0-9]")
	if(settings.SSN("//filetypes/type[text()='" value "']")){
		GuiControl,Manage_File_Types:,Edit1
		return m("File extension already exists")
	}settings.Under(settings.SSN("//filetypes"),"type",,value)
	GuiControl,Manage_File_Types:,Edit1
	Gosub,MFTPopulate
	return
	MFTDelete:
	Default("SysListView321","Manage_File_Types")
	while(LV_GetNext()){
		LV_GetText(ext,LV_GetNext())
		if(rem:=settings.SSN("//filetypes/type[text()='" ext "']"))
			rem.ParentNode.RemoveChild(rem)
		LV_Delete(LV_GetNext())
	}
	goto,MFTPopulate
	return
	MFTPopulate:
	Default("SysListView321","Manage_File_Types"),LV_Delete()
	list:=settings.SN("//filetypes/type"),extlist:=""
	while(ll:=list.item[A_Index-1]),ea:=XML.EA(ll)
		LV_Add("",ll.text)
	return
}
Quick_Options(){
	Settings("Options")
	/*
		if(!(list:=settings.SN("//quickoptions/profile")).length)
			return Manage_Quick_Options()
		while(ll:=list.item[A_Index-1]),ea:=XML.EA(ll)
			QOList.=ea.name "|"
		sc:=csc(),QOList:=Trim(QOList,"|"),sc.2106(124),sc.2117(9,QOList),sc.2106(32)
	*/
}
/*
	Manage_Quick_Options(){
		static newwin
		newwin:=new GUIKeep("Manage_Quick_Options"),newwin.Add("ListView,w200 h400,Quick Options Profile,h","ListView,x+M w300 h400 Checked,Options,wh","Edit,xm vedit,,y","Button,gMQOAdd Default,Add Profile,y","Button,x+M gMQODelete,&Delete Selected,y","Button,x+M gMQOExport,Export Quick Options,y"),newwin.Show("Manage Quick Options")
		if(!settings.SSN("//quickoptions"))
			settings.Add("quickoptions")
		Hotkeys("Manage_Quick_Options",{Delete:"MQODelete",Backspace:"MQODelete"})
		Gosub,MQOPopulate
		return
		MQOExport:
		m("Coming soon")
		return
		MQOAdd:
		value:=newwin[].edit
		if(!value)
			return m("Please add a name for the new profile")
		clean:=RegExReplace(value,"(\'|\|)")
		if(!settings.SSN("//quickoptions/profile[@name='" clean "']")){
			new:=settings.Under(settings.SSN("//quickoptions"),"profile",{name:clean})
			node:=settings.Under(new,"optionlist",settings.EA("//options"))
		}else
			return m("Profile already exists")
		GuiControl,Manage_Quick_Options:,Edit1
		goto,MQOPopulate
		return
		MQODelete:
		Default("SysListView321","Manage_Quick_Options")
		while(next:=LV_GetNext()){
			LV_GetText(profile,next)
			if(rem:=settings.SSN("//quickoptions/profile[@name='" profile "']"))
				rem.ParentNode.RemoveChild(rem)
			LV_Delete(next)
		}
		goto,MQOPopulate
		return
		MQOPopulate:
		Default("SysListView321","Manage_Quick_Options"),LV_Delete()
		list:=settings.SN("//quickoptions/profile"),extlist:=""
		while(ll:=list.item[A_Index-1]),ea:=XML.EA(ll)
			LV_Add("",ea.name)
		LV_ModifyCol(1,"AutoHDR"),LV_Modify(1,"Select Vis Focus")
		return
	}
*/
CloseSingleUntitled(){
	count:=files.SN("//main[@file!='Libraries']")
	if(count.length=1&&SSN(count.item[0],"@untitled").text){
		template:=GetTemplate(),text:=Update({get:(SSN(count.item[0],"@file").text)})
		if(template=text)
			CloseID:=SSN(count.item[0],"descendant::*/@id").text
	}
	return CloseID
}
Project_Specific_AutoComplete(){
	static
	if(!node:=settings.Find("//autocomplete/project/@file",current(2).file))
		node:=settings.Add("autocomplete/project",{file:current(2).file},,1)
	newwin:=new GuiKeep("Project_Specific_AutoComplete")
	newwin.add("ListView,w300 h300,Word List,wh","Button,gPSAAdd Default,Add,y","Button,x+M gPSADelete,Delete Selected (Delete),y"),newwin.Show("Project Specific AutoComplete")
	Hotkeys("Project_Specific_AutoComplete",{Delete:"PSADelete"})
	goto,PSAPopulate
	return
	PSAPopulate:
	Default("SysListView321","Project_Specific_AutoComplete"),LV_Delete()
	for a,b in StrSplit(node.text," ")
		LV_Add("",b)
	return
	PSAAdd:
	text:=InputBox(hwnd("Project_Specific_AutoComplete"),"Add Words","Add a list of Space Delimited Words")
	for a,b in StrSplit(text," ")
		if(!RegExMatch(node.text,"\b\Q" b "\E\b"))
			node.text:=node.text " " b
	goto,PSAPopulate
	return
	PSADelete:
	Default("SysListView321","Project_Specific_AutoComplete")
	while(next:=LV_GetNext(0))
		LV_GetText(text,next),node.text:=RegExReplace(node.text,"\Q" text "\E"),LV_Delete(next)
	node.text:=RegExReplace(node.text,"\s{2,}"," ")
	if(!node.text)
		node.ParentNode.RemoveChild(node)
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
	if(!node:=settings.Find("//autocomplete/project/@file",current(2).file))
		node:=settings.Add("autocomplete/project",{file:current(2).file},,1)
	pos:=1
	while(RegExMatch(text,"UO)\b(\w+)\b",found,pos)){
		pos:=found.pos(1)+found.len(1)
		if((!RegExMatch(node.text,"\b\Q" found.1 "\E\b"))&&StrLen(found.1)>1)
			node.text:=node.text " " found.1,list.=found.1 "`n"
		if(pos=lastpos)
			break
		lastpos:=pos
	}m("Added:",SubStr(list,1,300)(StrLen(list)>300?"...":""),"To " Current(2).file)
}
Update_Github_Info(){
	static
	info:=settings.ea("//github"),setup(36)
	controls:={owner:"Owner (GitHub Username)",email:"Email",name:"Your Full Name"}
	for a,b in {owner:100,email:200,name:100}{
		Gui,Add,Text,xm,% controls[a]
		Gui,Add,Edit,x+5 w%b% gupdate v%a%,% info[a]
	}
	Gui,Add,Text,xm,Github Token
	Gui,Add,Edit,xm w300 Password gupdate vtoken,% info.token
	Gui,Add,Button,ggettoken,Get A Token
	Gui,Show,,Github Information
	return
	update:
	Gui,36:Submit,NoHide
	if !hub:=settings.ssn("//github")
		hub:=settings.Add({path:"github"})
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
Google_Search_Selected(){
	sc:=csc(),text:=sc.getseltext()
	if(!text)
		return m("Please select some text to search for")
	Run,https://www.google.com/search?q=%text%
}
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
Test_Plugin(){
	Exit(1)
}
New_File_Template(){
	newwin:=new GUIKeep(28),newwin.add("Edit,w500 r30,,wh","Button,gNFTDefault,Default Template,y","Button,gNFTClose Default,Save,y"),newwin.show("New File Template")
	if(template:=settings.ssn("//template").text)
		ControlSetText,Edit1,% RegExReplace(template,"\R","`r`n"),% hwnd([28])
	else
		goto,nftdefault
	return
	NFTClose:
	ControlGetText,edit,Edit1,% hwnd([28])
	settings.Add("template",,RegExReplace(edit,"\R","`n"))
	28Escape:
	28Close:
	hwnd({rem:28})
	return
	NFTDefault:
	FileRead,template,c:\windows\shellnew\template.ahk
	ControlSetText,Edit1,%template%,% hwnd([28])
	rem:=settings.SSN("//template"),rem.ParentNode.RemoveChild(rem)
	return
}
Default_Project_Folder(){
	FileSelectFolder,directory,,3,% "Current Default Folder: " settings.ssn("//directory").text
	if(ErrorLevel)
		return
	settings.add("directory","",directory)
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
Custom_Version(){
	change:=settings.ssn("//auto_version").text?settings.ssn("//auto_version").text:"Version:=" Chr(34) "$v" Chr(34),cc:=InputBox(csc().sc,"Custom auto_version","Enter your custom" Chr(59) "auto_version in the form of Version:=$v",change)
	if(cc)
		settings.add("auto_version").text:=cc
}
Remove_Current_Selection(){
	sc:=csc(),main:=sc.2575,sc.2671(main),sc.2606,sc.2169
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
Select_Current_Word(){
	sc:=csc(),sc.2160(sc.2266(sc.2008),sc.2267(sc.2008))
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
Forum(){
	Run,https://autohotkey.com/boards/viewtopic.php?f=6&t=300&hilit=ahk+studio
}
Menu_Help(){
	static help,newwin
	help:=new XML("help","lib\Help Menu.xml"),current:=new XML("current"),current.xml.LoadXML(x.get("menus"))
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
	while,aa:=all.item[A_Index-1],ea:=xml.ea(aa)
		if(aa.nodename!="separator")
			aa.SetAttribute("tv",TV_Add(RegExReplace(ea.clean,"_"," "),SSN(aa.ParentNode,"@tv").text))
	return
}
Online_Help(){
	Run,https://github.com/maestrith/AHK-Studio/wiki
}
Auto_Insert(){
	static newwin,wname
	wname:="Auto_Insert",newwin:=new GUIKeep(wname),newwin.Add("ListView,w220 h200 AltSubmit gchange,Entered Key|Added Key,wh","Text,,Entered Key:,y","Edit,venter x+M w100,,yw","Text,xm,Added Key:,y","Edit,vadd x+M w100 Limit1,,yw","Button,xm gaddkey Default,Add Keys,y","Button,x+M gremkey,&Remove Selected,y"),newwin.Show("Auto Insert")
	if(!settings.SSN("//autoadd"))
		settings.Add("//autoadd")
	Hotkeys(wname,{Delete:"remkey",Backspace:"remkey"})
	Gosub,AIPopulate
	return
	AIPopulate:
	all:=settings.SN("//autoadd/*"),Default("SysListView321",wname),LV_Delete()
	while(aa:=all.item[A_Index-1]),ea:=XML.EA(aa)
		LV_Add("",ea.trigger,ea.add)
	Loop,2
		LV_ModifyCol(A_Index,"AutoHDR")
	return
	Auto_InsertClose:
	Auto_InsertEscape:
	BraceSetup(),newwin.Exit()
	return
	change:
	if(A_GuiEvent!="I")
		return
	LV_GetText(enter,LV_GetNext()),ff:=settings.Find("//autoadd/key/@trigger",enter),ea:=xml.EA(ff)
	for a,b in [ea.trigger,ea.add]
		ControlSetText,Edit%A_Index%,%b%,% newwin.id
	return
	addkey:
	value:=newwin[],enter:=value.enter,add:=value.add
	if(!(enter&&add))
		return m("Both values need to be filled in")
	if(ff:=settings.Find("//autoadd/key/@trigger",enter))
		ff.SetAttribute("add",add)
	else
		if(!settings.SSN("//autoadd/key[@trigger='" enter "']"))
			settings.Under(settings.SSN("//autoadd"),"key",{add:add,trigger:enter})
	Loop,2
		GuiControl,Auto_Insert:,Edit%A_Index%
	ControlFocus,Edit1,% newwin.ID
	goto,AIPopulate
	return
	remkey:
	Default("SysListView321",wname)
	while,LV_GetNext()
		LV_GetText(trigger,LV_GetNext()),rem:=settings.find("//autoadd/key/@trigger",trigger),rem.ParentNode.RemoveChild(rem),LV_Delete(LV_GetNext())
	return
}