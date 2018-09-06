#SingleInstance,Off
#MaxHotkeysPerInterval,2000
#NoEnv
SetBatchLines,-1
SetWorkingDir,%A_ScriptDir%
SetControlDelay,-1
SetWinDelay,-1
DetectHiddenWindows,On
CoordMode,ToolTip,Screen
global v:=[],MainWin,Settings:=new XML("settings",A_ScriptDir "\lib\Settings.xml"),Positions:=new XML("positions",A_ScriptDir "\lib\Positions.xml"),cexml:=new XML("cexml",A_ScriptDir "\Lib\CEXML.xml"),History,VVersion,scintilla,TVC:=new EasyView(),RCMXML:=new XML("RCM",A_ScriptDir "\lib\RCM.xml"),TNotes,DebugWin,Selection:=new SelectionClass(),Menus,Vault:=new XML("vault",A_ScriptDir "\lib\Vault.xml")
v.WordsObj:=[],v.Tick:=A_TickCount,new ScanFile(),History:=new HistoryClass()
if(!settings[]){
	Run,lib\Settings.xml
	m("Oh boy...Check the settings file to see what's up.")
}v.LineEdited:=[],v.LinesEdited:=[],v.RunObject,ComObjError(0),new Keywords(),FileCheck(%True%)
Options("startup"),Menus:=new XML("menus",A_ScriptDir "\Lib\Menus.xml"),Gui(),DefaultRCM(),CheckLayout(),Allowed(),SetTimer("RemoveXMLBackups",-1000),CheckOpen()
SetTimer("SplashDestroy",-1000)
SetTimer("MenuIcons",-1)
if(v.RefreshColors)
	RefreshThemes(1)
return
MenuIcons:
All:=Menus.SN("//*[@icon]")
while(aa:=All.Item[A_Index-1],ea:=XML.EA(aa),pea:=XML.EA(aa.ParentNode)){
	Parent:=pea.Name?pea.Name:MenuName,ConvertedHotkey:=ea.Hotkey?Convert_Hotkey(ea.Hotkey):"",Hotkey:=ea.Hotkey?"`t" Convert_Hotkey(ea.Hotkey):""
	Menu,%Parent%,Icon,% ea.Name hotkey,% ea.filename,% ea.icon
}
return
SplashDestroy:
Gui,Splash:Destroy
return
/*
	Highlight Code Indicators 9-19
*/
/*
	Hotkey,End,EndThing,On
*/
 
return
/*
	EndThing:
	sc:=CSC()
	if(sc.2102)
		sc.2101()
	Send,{%A_ThisHotkey%}
*/
return
/*
 	Add in #Include brings up a list of items in your library
	Debugging Joe Glines{
		have the option to have the Variable Browser dockable to the side of debug window.
	}
	Darth_diggler{
		Right Click and Edit from Explorer not selecting the proper file when opening new files
		Downloading plugins does not work in compiled version.
	}
	Run1e{
		studio bugs:
		I think theres a massive memory leak somewhere.. studio slows down to a halt after a while
	}
	CUSTOM COMMANDS{
		needs fixed, when changing things from Auto-indent to another area it didn't save
	}
	MISC NOT WORKING:
	Joe_Glines{
		Check Edited Files On Focus
		have it so that it asks first to replace the text rather than automatically
	}Misc Ideas:
	When you edit/Add a line with an include:{
		have it scan that line (Add a thing in the Scan_Line() for it)
	}
*/
#IfWinActive
#IfWinActive,AHK Studio
About(){
	about=
(
If you wish to use this software, great.

If you wish to use AHK-Studio or any of its code as a part of your project I require payment.

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
	Setup(11),Hotkeys(11,{"Esc":"11Close"}), Version:=1.005.19
	Gui,Margin,0,0
	sc:=new s(11,{pos:"x0 y0 w700 h500"}),CSC({hwnd:sc})
	Gui,Add,Button,gdonate,Donate
	Gui,Add,Button,x+M gsite,Website
	Gui,Show,w700 h550,AHK Studio Help Version: %version%
	sc.2181(0,about),sc.2025(0),sc.2268(1)
	return
	11Close:
	11GuiClose:
	11GuiEscape:
	HWND({rem:11})
	return
	site:
	Run,https://github.com/maestrith/AHK-Studio
	return
}
Activate(a,b,c,d*){
	if(A_Gui=1&&a=1){
		if(a&&v.Options.Check_For_Edited_Files_On_Focus=1)
			Check_For_Edited()
		sc:=CSC()
		if(sc.sc=v.Debug.sc||sc.sc=MainWin.tnsc.sc)
			sc:=CSC({last:1})
		sc.2400
	}Sleep,20
	return 0
}
Add_Selected_To_Personal_Variables(){
	sc:=CSC()
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
Add_Tracked_Folder(){
	if(!MainWin.Gui.SSN("//*[@type='Tracked Notes']"))
		return m("Tracked notes is not visible")
	NewFolder:=RegExReplace(InputBox(HWND(1),"New Folder","Enter the name of the Folder you wish to add (all [^a-zA-Z0-9 \(\)] will be removed)"),"([^a-zA-Z0-9 \(\)])")
	if(!NewFolder)
		return
	TNotes.XML.Transform(2)
	Node:=TNotes.XML.SSN("//*[@tv='" TVC.Selection(3) "']"),Text:=""
	if(!SSN(Node,"*"))
		Text:=Node.Text,Node.Text:=""
	New:=TNotes.XML.Under(Node,"file",{name:NewFolder,last:1},Text),TNotes.Populate(),TNotes.SetText()
	MainWin.tnsc.2400()
}
AddBookmark(line,search){
	sc:=CSC(),end:=sc.2136(line),start:=sc.2128(line),name:=(Settings.SSN("//bookmark").text),name:=name?name:SubStr(StrSplit(Current(2).file,"\").pop(),1,-4)
	for a,b in {"$file":SubStr(StrSplit(Current(3).file,"\").pop(),1,-4),"$project":SubStr(StrSplit(Current(2).file,"\").pop(),1,-4)}
		name:=RegExReplace(name,"i)\Q" a "\E",b)
	if(RegExMatch(name,"UO)\[(.*)\]",time)){
		FormatTime,currenttime,%A_Now%,% time.1
		name:=RegExReplace(name,"\Q[" time.1 "]\E",currenttime)
	}sc.2003(end," " Chr(59) search.1 "[" name "]"),sc.2160(end+4,end+4+StrPut(name,utf-8)-1)
	return name
}
AddInclude(FileName:="",text:="",pos:="",Show:=1){
	static new
	file:=FileOpen(FileName,"RW","UTF-8"),File.Write(text),File.Length(File.Position),rel:=RelativePath(Current(2).file,FileName),sc:=CSC()
	Current:=Current(4)
	SplitPath,FileName,FN,Dir,Ext,NNE,Drive
	FileGetTime,Time,%FileName%
	if(v.Options.Includes_In_Place){
		line:=sc.2166(sc.2008)
		if(Trim(RegExReplace(sc.GetLine(line),"\R"))){
			sc.2003(sc.2136(line),"`n#Include " rel)
			if(v.Options.Full_Auto_Indentation)
				NewIndent()
		}else
			sc.2003(sc.2008,"#Include " rel)
	}else{
		if(SSN(Current,"@file").text=Current(3).file)
			sc.2003(sc.2006,"`n#Include " rel)
		else
			Update({file:Current(2).file,text:Update({get:Current(2).file}) "`n#Include " rel}),Current.RemoveAttribute("sc")
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
			if(!Node:=CEXML.Find(Parent,"folder/@path",build))
				Node:=CEXML.Under(Parent,"folder",{path:build,tv:(TV:=TVC.Add(1,b,TV,"Sort"))})
			else
				TV:=SSN(Node,"@tv").text
	}}else
		TV:=SSN(Current,"@tv").text
	Current:=SSN(Current(),"ancestor::main/file")
	new:=CEXML.Under(Current,"file",{id:(ID:=GetID()),encoding:"UTF-8",type:"File",lower:Format("{:L}",FileName),file:FileName,include:"#Include " rel,inside:SSN(Current,"@file").text,dir:Dir,filename:fn,github:fn,nne:NNE,time:Time,encoding:"UTF-8",ext:Ext,tv:TVC.Add(1,fn,TV,"Sort"),lang:LanguageFromFileExt(Ext)})
	/*
		add:=Current(7).AppendChild(new.CloneNode(1))
	*/
	add.SetAttribute("type","File")
	Update({file:FileName,text:text,encoding:"UTF-8",node:Current})
	ScanFile.Scan(New,1)
	/*
		ScanFiles()
	*/
	TVC.Default(1)
	if(Show)
		tv(SSN(new,"@tv").text,pos)
}
Additional_Library_Folders(){
	static NewWin,Changed
	NewWin:=new GUIKeep("Additional_Library_Folders")
	NewWin.Add("ListView,w400 h200 vALFLV,Additional Library Folders","Button,gALFAdd Default,&Add","Button,x+m gALFRemove,&Delete"),NewWin.Show("Additional Library Folders")
	Goto,ALFPopulate
	return
	ALFAdd:
	FileSelectFolder,Folder,% "*" A_ScriptDir,,Select a folder to add to your library
	if(ErrorLevel)
		return
	Settings.Add("OtherLib/Folder",,Folder,1),SetTimer("ALFPopulate")
	return
	ALFRemove:
	NewWin.Default("ALFLV"),LV_GetText(Dir,LV_GetNext()),Rem:=Settings.SSN("//OtherLib/Folder[text()='" Dir "']"),Rem.ParentNode.RemoveChild(Rem),SetTimer("ALFPopulate")
	ALFPopulate:
	All:=Settings.SN("//OtherLib/Folder"),NewWin.Default("ALFLV"),LV_Delete()
	while(aa:=All.Item[A_Index-1])
		LV_Add("",aa.text)
	return
	Additional_Library_FoldersEscape:
	Additional_Library_FoldersClose:
	Index_Lib_Files(),NewWin.Exit()
	return
}
AddMissing(){
	all:=SN(Current(5),"descendant::*[not(@cetv)]")
	while(aa:=all.item[A_Index-1]),ea:=XML.EA(aa){
		if(!header:=SSN(aa.ParentNode,"@cetv").text)
			header:=Header(ea.type)
		aa.SetAttribute("cetv",TVC.Add(2,ea.text,header,(ea.type~="Method|Property"=0?"Sort":"")))
	}
}
Allowed(){
	All:=Settings.SN("//replacements/descendant::*")
	while(aa:=All.Item[A_Index-1],ea:=XML.EA(aa))
		Allowed.=RegExReplace(ea.Replace,"[^\W]")
	for a,b in StrSplit(Allowed)
		Total.=b "|"
	v.Allowed:=Total "\w"
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
	while(LV_GetNext())
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
	sc:=CSC(),line:=sc.2166(sc.2008),text:=sc.TextRange(sc.2128(line),sc.2008)
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
	sc:=CSC()
	if(sc.2007(sc.2008-1)~="40|123")
		return
	Command:=RegExReplace(Context(1).Word,"#")
	if((v.Word&&sc.2102=0&&v.Options.Auto_Complete)){
		if(List:=Keywords.GetXML(Current(3).Lang).SSN("//Context/" Command "/descendant-or-self::list[text()='" RegExReplace(v.Word,"#") "']/@list").text){
			Insert:=v.Options.Auto_Space_After_Comma?", ":","
			if(sc.2007(sc.2008-StrLen(Insert))!=44)
				sc.2003(sc.2008,Insert),sc.2025(sc.2008+StrLen(Insert))
			sc.2100(0,FirstText List),v.Word:=""
	}}return
}
Backspace(sub:=1){
	ControlGetFocus,Focus,A
	Send:=sub?"Backspace":"Delete",sc:=CSC(),Start:=sc.2166(sc.2008),SetTimer("UpPos","-100")
	if(!v.LineEdited[Start])
		SetScan(Start)
	if(!InStr(Focus,"Scintilla")){
		ControlGet,HWND,HWND,,%Focus%,A
		if(HWND=TVC.GetHWND(3))
			return RemoveTrackedFile()
		Send,{%A_ThisHotkey%}
		return
	}if(!v.Options.Smart_Delete){
		Send,{%Send%}
		LineStatus.DelayAdd(sc.2166(sc.2008),1),Update({sc:sc.2357})
		if(!Current(3).Edited)
			return Edited()
		return Edited()
	}if(sc.2570=1){
		CPos:=(opos:=sc.2585(0))-sub,chr:=Chr(sc.2007(CPos))
		if(chr~="\(|\)|\[|\]|\x22|<|>|'|\{|\}"=0){
			Send,{%Send%}
			return Edited(),Update({sc:sc.2357})
	}}if(sc.2102)
		sc.2101
	if(sc.2102){
		if(sub)
			Send,{Backspace}
		else
			sc.2101
		return Edited(),Update({sc:sc.2357})
	}sc.2078
	Loop,% sc.2570{
		index:=A_Index-1,CPos:=sc.2585(index)-sub,chr:=Chr(cc:=sc.2007(CPos)),style:=sc.2010(CPos),pos:=sc.2585(index),line:=sc.2166(CPos)
		if((start:=sc.2585(index))!=(end:=sc.2587(index))){
			sc.2645(start,end-start)
			Continue
		}if(BraceMatch:=v.BraceDelete[chr]){
			if(chr="{"){
				if((match:=sc.2353(CPos))>=0)
					sc.2645(match,1),sc.2645(CPos,1),(!v.Options.Disable_Match_Brace_Highlight_On_Delete?(sc.2584(index,CPos),sc.2586(index,match-1)):"")
			}else{
				if(chr="%"){
					if(Chr(sc.2007(CPos-1))="%")
						sc.2645(CPos-1,2)
					else
						sc.2645(CPos,1)
				}else
					(Chr(sc.2007(CPos+1))=BraceMatch)?sc.2645(CPos,2):GotoPos(index,CPos+(sub?0:1))
		}}else if(BraceMatch:=v.DeleteBrace[chr]){
			if(bracematch=Chr(sc.2007(CPos-1)))
				sc.2645(CPos-1,2)
			else if(chr~="(\}|\)|\>|\])")
				if((sc.2353(CPos)<0))
					sc.2645(CPos,1)
			else
				GotoPos(index,CPos)
		}else{
			if(cc<0){
				if(Send="Delete")
					sc.2645(CPos,2)
				if(Send="Backspace")
					sc.2645(CPos-1,2)
			}else
				sc.2645(CPos,1)
	}}sc.2079(),Update({sc:sc.2357})
}
BookEnd(add,hotkey){
	if(!(add&&hotkey))
		return
	sc:=CSC(),sc.2078,add:=add?add:v.match[hotkey]
	Loop,% sc.2570
		start:=sc.2585(A_Index-1),end:=sc.2587(A_Index-1),sc.2686(end,end),sc.2194(1,add),sc.2686(start,start),sc.2194(1,hotkey),sc.2584(A_Index-1,start+1),sc.2586(A_Index-1,end+1)
	sc.2079
}
BraceHighlight(){
	static LastBackground:=0
	sc:=CSC()
	if(sc.2353(sc.2008-1)>0)
		sc.2351(v.BraceStart:=sc.2008-1,v.BraceEnd:=sc.2353(sc.2008-1)),v.HighLight:=1
	else if(sc.2353(sc.2008)>0)
		sc.2351(v.BraceStart:=sc.2008,v.BraceEnd:=sc.2353(sc.2008)),v.HighLight:=1
	else if v.HighLight
		v.BraceStart:=v.BraceEnd:="",sc.2351(-1,-1),v.HighLight:=0
	if(v.HighLight&&v.Options.Brace_Match_Background_Match){
		Style:=sc.2010(v.BraceStart),xx:=Keywords.GetXML(Current(3).Lang),nn:=xx.SSN("//Styles/*[@style='" Style "']").NodeName,Background:=Settings.SSN("//theme/" nn "/@background").text,Background:=Background?Background:Settings.SSN("//theme/default/@background").text
		if(Background!=LastBackground)
			sc.2052(34,Background),LastBackground:=Background
		return
	}
}
BraceSetup(Win:=1){
	static setup:={"<":">",(Chr(34)):Chr(34),"'":"'","(":")","%":"%","{":"}","[":"]","<^>{":"}","<^>[":"]"},keep:=[]
	v.AutoAdd:=[],v.BraceMatch:=[],v.MatchBrace:=[],v.BraceDelete:=[],v.DeleteBrace:=[],list:=Settings.SSN("//autoadd/@altgr").text?{"<^>[":"]","<^>{":"}"}:{"{":"}","[":"]"}
	/*
		make this list editable at some point.
	*/
	Hotkey,IfWinActive,% HWND([win])
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
	if(!InStr(focus,"Scintilla")){
		Send,{%A_ThisHotkey%}
		return
	}sc:=CSC(),Hotkey:=SubStr(A_ThisHotkey,0),line:=sc.2166(sc.2008),Language:=GetLanguage(sc)
	if(sc.2102)
		sc.2101
	if(sc.2008!=sc.2009)
		return BookEnd(v.BraceMatch[Hotkey],Hotkey)
	if(!v.AutoAdd[Hotkey]){
		Loop,% sc.2570{
			CPos:=sc.2585(A_Index-1)
			if(Chr(sc.2007(CPos))=Hotkey)
				GotoPos(A_Index-1,CPos+1)
			else
				sc.2686(CPos,CPos),sc.2194(1,Hotkey),GotoPos(A_Index-1,CPos+1)
		}
		if(A_ThisHotkey=">"&&Language="xml"){
			Sleep,100
			Match:=sc.2353(CPos)
			Line:=sc.2166(sc.2008)
			MatchLine:=sc.2166(Match)
			if(MatchLine=Line){
				if((Start:=sc.2266(Match+1,1))!=(End:=sc.2267(Match+1,1)))
					if(Word:=sc.TextRange(sc.2266(Match+1,1),sc.2267(Match+1,1)))
						sc.2003(sc.2008,"</" Word ">")
			}
		}
		return
	}if(hotkey="}"&&v.Options.Full_Auto_Indentation){
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
			CPos:=sc.2585(A_Index-1)
			if(sc.2007(CPos)=34)
				sc.2584(A_Index-1,CPos+1),sc.2586(A_Index-1,CPos+1)
			else
				bad:=sc.2010(CPos)=13,sc.2686(CPos,CPos),sc.2194(bad?1:2,(bad?Chr(34):Chr(34) Chr(34))),sc.2584(A_Index-1,CPos+1),sc.2586(A_Index-1,CPos+1)
		}return sc.2079
	}else if(Hotkey="'"){
		sc.2078
		loop,% sc.2570{
			CPos:=sc.2585(A_Index-1)
			if(sc.2007(CPos)=39)
				sc.2584(A_Index-1,CPos+1),sc.2586(A_Index-1,CPos+1)
			else
				one:=sc.2267(CPos-1,1)=CPos,sc.2686(CPos,CPos),sc.2194(one?1:2,(one?"'":"''")),sc.2584(A_Index-1,CPos+1),sc.2586(A_Index-1,CPos+1)
		}return sc.2079
	}if(sc.2102&&v.Options.Disable_Auto_Insert_Complete!=1&&(Hotkey~="\(|\{")){
		word:=sc.GetWord()
		VarSetCapacity(text,sc.2610),sc.2610(0,&text),word:=StrGet(&text,"UTF-8") Hotkey v.BraceMatch[Hotkey]
		loop,% sc.2570
			pos:=sc.2585(A_Index-1),start:=sc.2266(pos,1),end:=sc.2267(pos,1),sc.2686(start,end),sc.2194((len:=StrPut(word,"UTF-8")-1),[word]),GotoPos(A_Index-1,start+len-1),sc.2101()
		return
	}
	if(A_ThisHotkey=">"&&Language="xml")
		m("WOOT!")
	Loop,% sc.2570{
		index:=A_Index-1,CPos:=sc.2585(index),line:=sc.2166(CPos)
		if(Chr(sc.2007(CPos))=Hotkey&&!v.Options.Disable_Auto_Advance){
			sc.2584(index,CPos+1),sc.2586(index,CPos+1)
			Continue
		}
		if(Hotkey="{"&&v.AutoAdd[Hotkey]){
			sc.2078(),ind:=sc.2127(line),tab:=Settings.Get("//tab",5)
			if(sc.2128(line)=sc.2136(line)){
				prev:=sc.GetLine(line-1)
				if(RegExMatch(prev,"iA)(}|\s)*#?\b(" Keywords.IndentRegex[Current(3).ext] ")\b"))
					if(SubStr(RegExReplace(prev,"\s+" Chr(59) ".*"),0,1)!="{")
						if(sc.2127(line)>sc.2127(line-1))
							sc.2126(line,sc.2127(line)-tab),GotoPos(index,(CPos:=sc.2128(line)))
				if(v.Options.Inline_Brace)
					sc.2686(CPos,CPos),sc.2194(4,"{`t`n}"),ind:=sc.2127(line),sc.2126(line+1,ind),sc.2584(index,sc.2136(line)),sc.2586(index,sc.2136(line)),sc.2399
				else
					sc.2686(CPos,CPos),sc.2194(4,"{`n`n}"),ind:=sc.2127(line),sc.2126(line+1,ind+tab),sc.2126(line+2,ind),sc.2584(index,sc.2128(line+1)),sc.2586(index,sc.2128(line+1)),sc.2399
			}else if(sc.2128(line)=CPos)
				end:=sc.2136(line),sc.2686(end,end),sc.2194(2,"`n}"),sc.2686(CPos,CPos),sc.2194(2,"{`n"),ind:=sc.2127(line),sc.2126(line+1,ind+tab),sc.2126(line+2,ind),sc.2584(index,sc.2128(line+1)),sc.2586(index,sc.2128(line+1)),sc.2399
			else
				sc.2686(CPos,CPos),sc.2194(2,hotkey v.AutoAdd[Hotkey]),sc.2584(index,CPos+1),sc.2586(index,CPos+1)
			sc.2079
		}else if(v.AutoAdd[Hotkey])
			sc.2686(CPos,CPos),sc.2194(2,hotkey v.AutoAdd[Hotkey]),sc.2584(index,CPos+1),sc.2586(index,CPos+1)
		else
			sc.2686(CPos,CPos),sc.2194(1,hotkey),sc.2584(index,CPos+1),sc.2586(index,CPos+1)
	}
	return SetStatus("Last Entered Character: " hotkey " Code:" Asc(hotkey),2)
	if(Hotkey="}"){
		FixBrace:
		sc:=CSC(),line:=sc.2166(sc.2008),sc.2078
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
Camel(){
	sc:=CSC(),Line:=sc.2166(sc.2008),sc.2008!=sc.2009?(Text:=sc.GetSelText(Line)):(Text:=sc.GetLine(Line),sc.2160(sc.2128(Line),sc.2136(Line))),Pos:=1
	while(RegExMatch(Text,"O)([a-zA-Z]+)(_|\W*)?",Found,Pos),Pos:=Found.Pos(1)+Found.Len(1)){
		if(!Found.Len(1))
			Break
		Out.=Format("{:T}",Found.1) Found.2
	}sc.2170(0,[Trim(Out,"`n")])
}
Center(win){
	Gui,%win%:Show,Hide
	WinGetPos,x,y,w,h,% HWND([1])
	WinGetPos,xx,yy,ww,hh,% HWND([win])
	centerx:=(Abs(w-ww)/2),centery:=Abs(h-hh)/2
	return "x" x+centerx " y" y+centery
}
CenterSel(){
	sc:=CSC(),sc.2169
	if(v.Options.Center_Caret!=1){
		sc.2402(0x04|0x8,0),sc.2403(0x04|0x8,0)
		Sleep,1
		sc.2169(),sc.2402(0x08,0),sc.2403(0x08,0)
	}
}
Check_For_Edited(){
	static ea,sc
	All:=CEXML.SN("//file"),sc:=CSC()
	while(aa:=All.Item[A_Index-1],ea:=XML.EA(aa)){
		FileGetTime,Time,% ea.File
		if(Time!=ea.Time&&ea.Note!=1){
			List.=ea.FileName ",",aa.SetAttribute("time",Time),q:=FileOpen(ea.File,"R")
			if(q.Encoding="CP1252"){
				if(RegExMatch((Text:=q.Read()),"OU)([^\x00-\x7F])",Found))
					q:=FileOpen(ea.File,"R","UTF-8"),Text:=q.Read(),Encoding:="UTF-8"
				else
					Encoding:=q.Encoding
			}else
				Encoding:=q.Encoding,Text:=q.Read()
			q.Close(),sc.Enable(0)
			Text:=RegExReplace(Text,"\r\n|\r","`n"),Encode(Text,tt,Encoding)
			if(ea.sc=sc.2357){
				Node:=GetPos(),sc.2181(0,&tt)
				ea:=XML.EA(Node)
				for a,b in StrSplit(ea.Fold,",")
					sc.2231(b)
				if(ea.Start&&ea.End)
					sc.2160(ea.Start,ea.End),sc.2399
				if(ea.Scroll!="")
					SetTimer,SetScrollPos2,-1
			}else if(ea.sc&&ea.sc!=sc.2357)
				sc.2377(ea.sc),aa.RemoveAttribute("sc")
			Update({File:ea.File,Text:Text}),SetPos(),sc.Enable(1)
	}}if(List)
		SetStatus("Files Updated:" Trim(List,","),3)
	return 1
	SetScrollPos2:
	if(ea.Scroll!="")
		sc.2613(ea.Scroll),sc.2400()
	MarginWidth()
	return
}
Check_For_Update(startup:=""){
	static NewWin,master,Beta,DownloadURL:="https://raw.githubusercontent.com/maestrith/AHK-Studio/$1/AHK-Studio.ahk",URL:="https://api.github.com/repos/maestrith/AHK-Studio/commits/$1"
	Run,RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 8
	Auto:=Settings.EA("//autoupdate"), Branch:="master"
	if(startup=1){
		if(v.Options.Auto_Check_For_Update_On_Startup!=1)
			return
		if(Auto.Reset>A_Now)
			return
	}
	Version:=1.005.19
	NewWin:=new GUIKeep("CFU"),NewWin.Add("Edit,w400 h400 ReadOnly,No New Version,wh"
								  ,"Radio,gSwitchBranch Checked vmaster,Master Branch,y"
								  ,"Radio,x+M gSwitchBranch vBeta,Beta Branch,y"
								  ,"Button,xm gautoupdate,&Update,y"
								  ,"Button,x+5 gcurrentinfo,&Current ChangeLog,y"
								  ,"Button,x+5 gextrainfo,ChangeLog &History,y"),NewWin.Show("AHK Studio Version: " Version)
	if(!Branch)
		Branch:="master"
	GuiControl,,%Branch%,1
	Check_For_Update_Get_Info(Startup,Branch,NewWin.ID)
	return
	AutoUpdate: ;testing
	Master:=NewWin[].Master,Branch:=(Master?"master":"Beta")
	URL:=RegExReplace(DownloadURL,"\$1",Branch)
	Save(),Settings.Save(1),menus.Save(1),Studio:=URLDownloadToVar(URL)
	if(!InStr(Studio,";download complete"))
		URL:=RegExReplace(DownloadURL,"\$1","master"),Studio:=URLDownloadToVar(URL)
	if(!InStr(Studio,";download complete"))
		return m("There was an error. Please contact maestrith@gmail.com if this error continues")
	SplitPath,A_ScriptFullPath,,,ext,NNE
	if(!FileExist(A_ScriptDir "\Older Versions"))
		FileCreateDir,%A_ScriptDir%\Older Versions
	FileMove,%NNE%.ahk,%A_ScriptDir%\Older Versions\%NNE% - %Version%.ahk,1
	File:=FileOpen(NNE ".ahk","RW"),File.Seek(0),File.Write(Studio),File.Length(File.Position)
	Loop,%A_ScriptDir%\*.ico
		icon:=A_LoopFileFullPath
	if(icon)
		add=/icon "%icon%"
	if(ext="exe"){
		SplashTextOn,200,50,Compiling,Please Wait...
		FileMove,%A_ScriptFullPath%,%NNE% - %Version%.exe,1
		SplitPath,A_AhkPath,file,dirr
		Loop,%dirr%\Ahk2Exe.exe,1,1
			file:=A_LoopFileLongPath
		RunWait,%file% /in "%A_ScriptDir%\%NNE%.ahk" /out "%A_ScriptDir%\%NNE%.exe" %add% /bin "%dirr%\Compiler\Unicode 32-bit.bin"
	}Settings.Save(1),TNotes.XML.Save(1),Positions.Save(1)
	Reload
	ExitApp
	return
	CurrentInfo:
	Master:=NewWin[].Master,Branch:=(Master?"master":"Beta")
	File:=FileOpen("Lib\" Branch " ChangeLog.txt","rw")
	if(!File.Length)
		Check_For_Update_Get_Info(0,Branch,NewWin.ID),File:=FileOpen("Lib\" Branch " ChangeLog.txt","rw")
	File.Seek(0),Text:=File.Read(File.Length),File.Close()
	ControlSetText,Edit1,%Text%
	return
	ExtraInfo:
	Run,https://github.com/maestrith/AHK-Studio/wiki/Version-Update-History
	return
	CFUGuiClose:
	CFUGuiEscape:
	NewWin.Destroy()
	return
	SwitchBranch:
	ControlSetText,Edit1,% Check_For_Update_Get_Info(0,Branch:=A_GuiControl="Master"?"master":"Beta",NewWin.ID),%ID%
	return
}
Check_For_Update_Get_Info(Startup,Branch,ID){
	static VersionTextURL:="https://raw.githubusercontent.com/maestrith/AHK-Studio/$1/AHK-Studio.text",URL:="https://api.github.com/repos/maestrith/AHK-Studio/commits/$1"
	ControlSetText,Edit1,Getting Update Info`r`n`r`nPlease Wait...,%ID%
	sub:=A_NowUTC
	sub-=A_Now,hh
	FileGetTime,Time,%A_ScriptFullPath%
	Time+=sub,hh
	ea:=Settings.EA("//github"),token:=ea.token?"?access_token=" ea.token:"",http:=ComObjCreate("WinHttp.WinHttpRequest.5.1"),http.Open("GET",RegExReplace(URL,"\$1",Branch) "?refresh=" A_Now token)
	if(proxy:=Settings.SSN("//proxy").text)
		http.SetProxy(2,proxy)
	http.Send(),RegExMatch(http.ResponseText,"iUO)\x22date\x22:\x22(.*)\x22",found),Date:=RegExReplace(found.1,"\D")
	if(Startup="1"){
		if(Reset:=http.GetResponseHeader("X-RateLimit-Reset")){
			Seventy:=19700101000000
			for a,b in {s:Reset,h:-sub}
				EnvAdd,Seventy,%b%,%a%
			Settings.Add("autoupdate",{Reset:Seventy})
			if(Time>Date)
				return
		}else
			return
	}File:=FileOpen("Lib\" Branch " ChangeLog.txt","rw"),File.Seek(0),File.Write(Update:=RegExReplace(RegExReplace(URLDownloadToVar(RegExReplace(VersionTextURL,"\$1",Branch) "?refresh=" A_Now),"\R","`r`n"),Chr(127),"`r`n")),File.Length(File.Position),File.Close()
	if(Time<Date)
		Update:=Update
	else
		Update:="No New Updates"
	if(!found.1)
		Update:=http.ResponseText
	ControlSetText,Edit1,%Update%,%ID%
	return RegExReplace(Update,"\R","`r`n")
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
CheckOpen(){
	All:=Settings.SN("//open/*")
	while(aa:=All.Item[A_Index-1],ea:=XML.EA(aa)){
		if(!CEXML.Find("//main/@file",aa.Text))
			Open(aa.Text,1)
	}
}
class Code_Explorer{
	static explore:=[]
	Add(type,found,Node:=""){
		return
		if(type="Class")
			CEXML.Under(Current(5),"info",{type:type,text:found.2,upper:Upper(found.2),cetv:TVC.Add(2,found.2,Header(type),"Sort")})
		else{
			new:=CEXML.Under((Node?Node:Current(5)),"info",{type:type,text:found.1,upper:Upper(found.1),cetv:TVC.Add(2,found.1,Header(type),"Sort")}),Default("SysTreeView322"),TV_GetText(text,Header(type))
			if(type~="Function|Method")
				new.SetAttribute("args",found.3)
			if(type="Instance")
				new.SetAttribute("class",found.2)
			if(type="Breakpoint")
				new.SetAttribute("filename",Current(6).file)
	}}AutoCList(Node:=0){
		static List:=[]
		/*
			MAKE A WAY TO ONLY DO THIS WHEN UPDATES ARE DONE OR ON FIRST RUN!!!!
		*/
		if(!List[(Parent:=Current(2).File)]&&!Node)
			Node:=1
		if(Node=1){
			all:=CEXML.SN("//Libraries"),Add:=""
			while(aa:=all.item[A_Index-1]),mea:=XML.EA(aa){
				CF:=SN(aa,"descendant::*[@type='Class' or @type='Function' or @type='Instance']")
				while(cc:=CF.item[A_Index-1]),ea:=XML.EA(cc){
					if(SSN(cc,"ancestor::Libraries"))
						v.keywords[SubStr(ea.text,1,1)].=" " ea.text
					Add.=ea.text " "
			}}
		}if(Node){
			if(!Obj:=IsObject(List[parent]))
				Obj:=List[parent]:=[]
			LL:=List[Parent].List,all:=SN((Node=1?Current(1):Node.ParentNode),"descendant::*[@type='Class' or @type='Function' or @type='Instance']")
			while(aa:=all.item[A_Index-1]),ea:=XML.EA(aa)
				LL.=ea.text " "
			return Add Trim(LL)
		}else{
			return List[Current(2).file].List
	}}CEGO(){
		static last
		CEGO:
		static BreakBook:={Breakpoint:";\*\[$1\]",Bookmark:";#\[$1\]"}
		if((Node:=CEXML.SSN("//*[@cetv='" A_EventInfo "']"))&&(A_GuiEvent="S"||A_GuiEvent="Normal")){
			Type:=SSN(Node,"@type").text
			if(Type="Header")
				return
			if(Type~="\b(Bookmark|Breakpoint)"&&Node.NodeName="info"){
				tv:=Files.SSN("//file[@id='" SSN(Node,"ancestor::file/@id").text "']/@tv").text,Item:=XML.EA(Node)
				if(tv!=TVC.Selection(1))
					tv(tv),Sleep(200)
				sc:=CSC(),Text:=sc.GetUNI(),pre:=SN(Node,"preceding-sibling::*[@type='" item.type "' and @text='" item.text "']").Length,Pos:=0,Search:=RegExReplace(BreakBook[Item.Type],"\$1",Item.Text)
				Loop,% 1+pre
					Pos:=RegExMatch(Text,Search,,Pos+1)
				line:=sc.2166(StrPut(SubStr(Text,1,Pos),"UTF-8")-1),sc.2160(sc.2128(line),sc.2136(line)),HWND({rem:20}),CenterSel()
			}else{
				if(Node.NodeName="info"){
					SelectText(Node,1),CenterSel()
				}
			}
		}
		return
	}Populate(){
		Code_Explorer.Refresh_Code_Explorer()
	}Refresh_Code_Explorer(){
		if(v.opening)
			return
		if(!MainWin.Gui.SSN("//*[@type='Code Explorer']"))
			return
		SplashTextOff
		TVC.Disable(2),TVC.Delete(2,0),rem:=CEXML.SN("//*[@cetv]")
		while(rr:=rem.item[A_Index-1])
			rr.RemoveAttribute("cetv")
		rem:=CEXML.SN("//header")
		while(rr:=rem.item[A_Index-1])
			rr.ParentNode.RemoveChild(rr)
		for a,fz in [CEXML.SN("//files/main"),CEXML.SN("//Libraries/main")]{
			if(A_Index=2){
				if(v.Options.Hide_Library_Files_In_Code_Explorer)
					Continue
				LibHeader:=CEXML.SSN("//Libraries"),LibHeader.SetAttribute("cetv",TV_Add("Libraries"))
			}while(fn:=fz.Item[A_Index-1]){
				LibTV:=SSN(fn,"ancestor::Libraries/@cetv").text
				Exempt:=Keywords.CodeExplorerExempt[Settings.SSN("//Extensions/Extension[text()='" Format("{:L}",SSN(fn,"file/@ext").text) "']/@language").text],things:=SN(fn,"descendant::info"),filename:=SSN(fn,"@file").text
				SplitPath,filename,file
				if(LibFile)
					m("Lib")
				TVC.Default(2),fn.SetAttribute("cetv",(main:=TVC.Add(2,file,(LibTV?LibTV:0),"Sort")))
				while(tt:=things.Item[A_Index-1],ea:=XML.EA(tt)){
					if(v.Options.Hide_Library_Files_In_Code_Explorer&&SSN(tt,"ancestor::Libraries"))
						Continue
					if(!top:=SSN(fn,"descendant::header[@type='" ea.type "']"))
						if(ea.type~="(" Exempt ")"=0)
							top:=CEXML.Under(fn,"header",{type:ea.type,cetv:TVC.Add(2,ea.type,SSN(fn,"@cetv").text,"Sort" (SSN(tt,"ancestor::main[@file='Libraries']")?"":" Vis"))})
					if(ea.type~="(" Exempt ")")
						tt.SetAttribute("cetv",TVC.Add(2,ea.text,((tv:=SSN(tt.ParentNode,"@cetv").text)?tv:SSN(top,"@cetv").text),"Sort"))
					else
						last:=tt,tt.SetAttribute("cetv",TVC.Add(2,ea.text,((tv:=SSN(tt.ParentNode,"@cetv").text)?tv:SSN(top,"@cetv").text),(ea.type="Class"?"Sort":"Sort")))
		}}}TVC.Modify(2,,CEXML.SSN("//Libraries/@cetv").text,"-Expand"),TVC.Enable(2)
	}RemoveTV(nodes){
		type:=SSN(nodes.item[0],"@type").text
		while(nn:=nodes.item[A_Index-1]),ea:=XML.EA(nn){
			if(ea.cetv)
				TVC.Delete(2,ea.cetv)
			nn.ParentNode.RemoveChild(nn)
		}if(!SSN((Parent:=Current(7)),"descendant::info[@type='" type "']")){
			Node:=SSN(Parent,"descendant::header[@type='" type "']")
			if(tv:=SSN(Node,"@cetv").text)
				TVC.Delete(2,tv)
			Node.ParentNode.RemoveChild(Node)
}}}
parseJson(jsonStr){
	static SC
	if(!IsObject(SC)){
		Try
			SC:=ComObjCreate("ScriptControl")
	}SC.Language:="JScript",jsCode:="function arrangeForAhkTraversing(obj){if(obj instanceof Array){for(var i=0;i<obj.length;++i)obj[i]=arrangeForAhkTraversing(obj[i]);return ['array',obj];}else if(obj instanceof Object){var keys=[],values=[];for(var key in obj){keys.push(key);values.push(arrangeForAhkTraversing(obj[key]));}return ['object',[keys,values]];}else return [typeof obj,obj];}",SC.ExecuteStatement(jsCode ";obj=" jsonStr)
	return AHK(SC.Eval("arrangeForAhkTraversing(obj)"))
}
AHK(jsObj){
	if(jsObj.0="Object"){
		Obj:=[],Keys:=jsObj.1.0,Values:=jsObj.1.1
		for a,b in Keys{
			Key:=Keys[A_Index-1],Value:=Values[A_Index-1]
			if(!IsObject(Value.1))
				Obj[Key]:=(Value.0="Boolean"?(Value.1?"true":"false"):Value.1)
			else
				Obj[Key]:=AHK(Value)
		}
		return Obj
	}else if(jsObj.0="Array"){
		Array:=[]
		while(A_Index<=jsObj[1].length)
			Array.Insert(AHK(jsObj[1][A_INDEX-1]))
		return Array
	}else
		return (jsObj.0="Boolean"?(jsObj.1?"true":"false"):jsObj.1)
}
Class CommitClass{
	Commit(){
		Git:=new GitHub(NewWin)
		;~ !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		;~ !!!!!!!!!                 Now                  !!!!!!!!!!
		;~ !!!!!!!!!            Save All Files            !!!!!!!!!!
		;~ !!!!!!!!!       Compile the verison info       !!!!!!!!!!
		;~ !!!!!!!!! See if it needs to be a Single File  !!!!!!!!!!
		;~ !!!!!!!!!          Publish If Needed           !!!!!!!!!!
		;~ !!!!!!!!!            Do The Commit             !!!!!!!!!!
		;~ !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		if(!git.repo)
			return m("Please setup a repo name in the GUI by clicking Repository Name:")
		if(!VersionNode:=SSN((HeadNode:=Git.Node()),"descendant::*[@select]/ancestor-or-self::version"))
			return m("Please Select A Version")
		
		/*
			Branch:=SSN(VersionNode,"ancestor::branch/@name").text
		*/
		/*
			m(Git.BaseURL "git/refs")
		*/
		/*
			GET /repos/:owner/:repo/releases/:id
		*/
		/*
			
		*/
		/*
			m(SSN(VersionNode,"@name").text)
		*/
		Current:=main:=file:=Current(2).File,ea:=Settings.EA("//github"),Delete:=[],Path:=A_ScriptDir "\Github\" git.repo,Version:=SSN(VersionNode,"@name").text,All:=SN(VersionNode,"descendant-or-self::*"),Info:=""
		while(aa:=All.Item[A_Index-1],MEA:=XML.EA(aa)){
			if(aa.NodeName="Version")
				CommitMsg.=(CommitMsg?":`r`n":"") MEA.Name ":"
			else
				CommitMsg.=(CommitMsg?"`r`n":"") (MEA.Type?MEA.Type ":":"") (MEA.Action?" " MEA.Action " by " MEA.User:"") (MEA.Issue?" " MEA.Issue:"") (MEA.Type?"`r`n":"") RegExReplace(aa.Text,Chr(127),"`r`n")
		}if(!CommitMsg)
			return m("Please select a commit message from the list of versions, or enter a commit message in the space provided")
		if(!(ea.name&&ea.email&&ea.token&&ea.owner))
			return m("Please make sure that you have set your Github information")
		if(!FileExist(A_ScriptDir "\GitHub"))
			FileCreateDir,% A_ScriptDir "\GitHub"
		TempXML:=new XML("temp"),TempXML.XML.LoadXML(CEXML.Find("//main/@file",Current).xml)
		MainFile:=Current,Branch:=SSN(VersionNode,"ancestor-or-self::branch/@name").text,Uploads:=[]
		list:=SN(Git.Node(),"descendant::*[@select]/ancestor-or-self::branch/descendant::files/*")
		if(!Branch)
			return m("Please select the branch you wish to update.")
		DXML:=new XML(Git.Repo,A_ScriptDir "\GitHub\" Git.Repo ".xml")
		if(!Top:=DXML.Find("//branch/@name",Branch))
			Top:=DXML.Under(DXML.SSN("//*"),"branch",{name:Branch})
		DeleteList:=[],Node:=SSN(VersionNode,"ancestor::branch"),AllFiles:=SN(Node,"descendant::files/file")
		while(aa:=AllFiles.item[A_Index-1],ea:=XML.EA(aa))
			if(ea.sha)
				DeleteList[ea.File]:={node:aa,ea:ea}
		all:=SN(Top,"descendant::file")
		while(aa:=all.item[A_Index-1],ea:=XML.EA(aa))
			if(ea.sha)
				DeleteList[ea.File]:={node:aa,ea:ea}
		SplitPath,Current,FileName,,,NNE
		if(!FileExist(Path))
			FileCreateDir,%Path%
		if(SSN(Version_Tracker.GetNode(),"ancestor-or-self::branch/@onefile")){
			OOF:=FileOpen(Path "\" FileName,"RW",ea.encoding),text:=OOF.Read(OOF.Length),PublishText:=Publish(1),Version_Tracker.NewWin.Default("VT"),Node:=VVersion.SSN("//*[@tv='" TV_GetSelection() "']" (VersionNode=1?"ancestor-or-self::version":VersionNode?VersionNode:""))
			if(!(PublishText==text))
				Uploads[FileName]:={text:PublishText,time:time,local:Path "\" Filename}
		}else{
			all:=TempXML.SN("//file")
			while(aa:=all.item[A_Index-1],ea:=XML.EA(aa)){
				fn:=ea.file,GitHubFile:=ea.github?ea.github:ea.filename
				SplitPath,fn,FileName
				if(!ii:=DXML.Find(Top,"descendant::file/@file",GithubFile))
					ii:=DXML.Under(Top,"file",{file:GithubFile})
				FileGetTime,time,%fn%
				DeleteList.Delete(GithubFile)
				if(SSN(ii,"@time").text!=time)
					file:=FileOpen(fn,"RW",ea.encoding),file.Seek(0),text:=file.Read(file.Length),file.Close(),Uploads[RegExReplace(GithubFile,"\\","/")]:={text:text,time:time,node:ii,local:ea.file}
		}}Version_Tracker.GetVersionInfo:=1,SetTimer("VersionCompileCurrent",-1),Sleep(100),VersionText:=Version_Tracker.GetVersionInfo
		while(aa:=AllFiles.item[A_Index-1],ea:=XML.EA(aa)){
			fn:=ea.FilePath
			FileGetTime,time,%fn%
			DeleteList.Delete(ea.filepath)
			/*
				make sure to add in the folder before the DeleteList[filename] to make sure it is unique
			*/
			if(ea.time!=time||!ea.sha){
				branch:=(name:=SSN(aa,"ancestor-or-self::branch/@name").text)?name:"master"
				SplitPath,fn,filename
				Uploads[(ea.folder?ea.folder "/":"") ea.file]:=EncodeFile(fn,time,aa,branch)
		}}for a,b in Uploads
			DeleteList.Delete(a),Finish:=1
		VTObject:=FileOpen(Path "\" NNE ".text","RW"),CheckVersionText:=VTObject.Read(VTObject.Length)
		if(VersionText==CheckVersionText=0){
			VTObject.Seek(0),VTObject.Write(VersionText),VTObject.Length(VTObject.Position)
			Uploads[NNE ".text"]:={text:VersionText}
			Vea:=XML.EA(VersionNode)
			if(!SSN(VersionNode,"@id").text){
				VersionNode.SetAttribute("id",parseJson(Git.Send("GET",Git.RepoURL("releases/tags/" Vea.Name))).ID)
				Vea:=XML.EA(VersionNode)
			}if(!ReleaseID:=SSN(VersionNode,"@id").text){
				Obj:=parseJson(Foo:=Git.Send("POST",Git.RepoURL("releases"),{tag_name:Vea.Name,target_commitish:Branch,name:Vea.Name,body:Git.UTF8(VersionText),draft:"false",prerelease:"true"}))
				VersionNode.SetAttribute("id",Obj.ID)
			}else{
				Obj:=parseJson(Foo:=Git.Send("PATCH",Git.RepoURL("releases/" Vea.ID),{tag_name:Vea.Name,target_commitish:Branch,name:Vea.Name,body:Git.UTF8(VersionText),draft:"false",prerelease:"true"}))
				if(!Obj.ID)
					return m("Foo")
			}
		}VTObject.Close()
		if(!Finish){
			if(IsObject(OOF))
				OOF.Close()
			return m("Nothing to upload"),VTObject.Close()
		}if(!Current_Commit:=git.GetRef()){
			m("No Commit, Please Try Again In A Short Time (GitHub may be down)")
			Exit
		}Store:=[],Upload:=[]
		for a,b in Uploads{
			WinSetTitle,% NewWin.ID,,Uploading: %a%
			NewText:=b.text?b.text:";Blank File"
			if((blob:=Store[a])=""||b.force){
				Store[a]:=blob:=git.Blob(git.repo,RegExReplace(NewText,Chr(59) "github_version",version),b.skip)
				if(!blob)
					return m("Error occured while uploading " text.local)
				Sleep,250
			}
			Upload[a]:=blob
		}Tree:=Git.Tree(Git.Repo,Current_Commit,Upload),Commit:=Git.Commit(Git.Repo,Tree,Current_Commit,CommitMsg,Git.Name,Git.EMail),Info:=Git.Ref(Git.Repo,Commit)
		if(Info=200){
			Top:=DXML.Find("//branch/@name",Branch)
			for a,b in Uploads{
				if(b.Node)
					b.Node.SetAttribute("time",b.Time),b.Node.SetAttribute("sha",Upload[a])
			}if(IsObject(OOF))
				OOF.Seek(0),OOF.Write(PublishText),OOF.Length(OOF.Position),OOF.Close()
			DeleteExtraFiles(DeleteList,DXML),DXML.Save(1),PluginClass.TrayTip("GitHub Update Complete")
		}else
			m("An Error Occured",commit)
		WinSetTitle,% NewWin.ID,,Github Repository
		DXML.Save(1)
		return
	}
}
Class ConvertStyle Extends CommitClass{
	ConvertStyle(){
		static
		xx:=VVersion
		All:=xx.SN("//version[text()]"),Headings:=[],Users:=[]
		while(aa:=All.Item[A_Index-1]){
			if(InStr(aa.Text,"`n"))
				aa.Text:=RegExReplace(aa.Text,"\R",Chr(127))
			for a,Text in StrSplit(aa.Text,Chr(127)){
				Pos:=LastPos:=1
				while(RegExMatch(Text,"Oim`n)^\s*(?<Text>(\w|[^\x00-\x7F])+):(.*)$",Found),Pos:=Found.Pos("Text")+Found.Len("Text")){
					if(Pos=LastPos),LastPos:=Pos
						Break
					RegExMatch(Found.0,"Oi)by(.*)",User)
					Headings[Found.Text]:=1
					if(UserName:=Trim(RegExReplace(User.1,"(\s*#.*)")))
						Users[UserName]:=1
			}}
		}
		ListCon:=new GUIKeep("ListCon")
		ListCon.Add("Text,,Press:`nDelete to remove an item`nEnter to edit an item","ListView,w300 h500 vSysListView321,Headings","ListView,x+M w300 h500 vSysListView322,Users","Button,xm gSaveVersionHeaders,&Save Information")
		ListCon.Show("Confirm Headings And Users")
		Hotkey,IfWinActive,% ListCon.ID
		for a,b in {Delete:"PreVersionDelete",Enter:"PreVersionChange"}
			Hotkey,%a%,%b%
		Gui,ListCon:ListView,SysListView321
		for a in Headings
			LV_Add("",a)
		LV_Modify(1,"Select Vis Focus")
		Gui,ListCon:ListView,SysListView322
		for a in Users
			LV_Add("",a)
		LV_Modify(1,"Select Vis Focus")
		return
		PreVersionChange:
		ControlGetFocus,Focus,% ListCon.ID
		ListCon.Default(Focus)
		if(Next:=LV_GetNext()){
			LV_GetText(ItemText,Next),Value:=InputBox(ListCon.HWND,"Replace","Replace this text",ItemText)
			if(Value)
				LV_Modify(Next,"",Value)
		}else
			return m("Select an item to change")
		return
		PreVersionDelete:
		ControlGetFocus,Focus,% ListCon.ID
		Gui,ListCon:Default
		Gui,ListCon:ListView,%Focus%
		if(Next:=LV_GetNext())
			LV_Delete(Next)
		return
		SaveVersionHeaders:
		xx:=VVersion
		Default("SysListView321","ListCon"),Next:=1,HeadingsList:=""
		Loop,% LV_GetCount()
		{
			LV_GetText(Text,A_Index)
			if(!Text)
				Break
			HeadingsList.=Text "|"
		}Find:=Trim(HeadingsList,"|")
		Default("SysListView322","ListCon"),Next:=1
		Loop,% LV_GetCount()
		{
			LV_GetText(Text,A_Index)
			if(!Text)
				Break
		}Find:=Trim(HeadingsList,"|"),All:=xx.SN("//version[text()]")
		while(aa:=All.Item[A_Index-1]){
			OXML:=aa.xml,Text:=aa.Text,LastPos:=Pos:=1,Fixed:=0,aa.Text:=""
			while(RegExMatch(Text,"OUi)\b(" Find ")\b:\s*(.*)(\b(" Find ")\b:|$)",Found,Pos),Pos:=Found.Pos(1)+Found.Len(1)){
				Fixed:=1
				if(Pos=LastPos),LastPos:=Pos
					Break
				User:="",NewText:="",CheckUser:=StrSplit(Found.2,Chr(127)).1
				if(InStr(CheckUser,"#")){
					if(RegExMatch(CheckUser,"OUi)^((.*)by(.*)(#\d+)\b)",User))
						NewText:=Trim(RegExReplace(Found.2,"\Q" User.0 "\E"),Chr(127))
				}else if(RegExMatch(CheckUser,"OUi)^((.*)\bby\b(.*))$",User)){
					NewText:=Trim(RegExReplace(Found.2,"\Q" User.0 "\E"),Chr(127))
				}else{
					New:=xx.Under(aa,"info",{type:Found.1,action:"",issue:"",user:""},NewText:=Trim(RegExReplace(Found.2,"\Q" User.0 "\E"),Chr(127)))
					Continue
				}
				for a,b in UserSub{
					Replace:=""
					if(InStr(Found.0,b)){
						Replace:=b
						Break
					}
				}
				xx.Under(aa,"info",{type:Found.1,action:Trim(User.2),issue:User.4,user:trim(RegExReplace(User.3,"(#.*)"))},(NewText?NewText:Trim(Trim(Found.2,Chr(127)))))
			}if(!Fixed){
				New:=xx.Under(aa,"info",{type:"",action:"",issue:"",user:""},Text)
			}
		}xx.Transform(2),ListCon.Close()
		return new Version_Tracker()
	}
}
class Debug{
	static Socket
	__New(){
		if(this.Socket){
			Debug.Send("stop")
			Sleep,500
			this.Disconnect()
		}Debug.XML:=new XML("Debug"),sock:=-1
		if(!v.Debug.sc)
			MainWin.DebugWindow()
		DllCall("LoadLibrary","str","ws2_32","ptr"),VarSetCapacity(wsadata,394+A_PtrSize),DllCall("ws2_32\WSAStartup","ushort",0,"ptr",&wsadata),DllCall("ws2_32\WSAStartup","ushort",NumGet(wsadata,2,"ushort"),"ptr",&wsadata),OnMessage(0x9987,Debug.sock),Socket:=sock,next:=Debug.AddrInfo(),sockaddrlen:=NumGet(next+0,16,"uint"),sockaddr:=NumGet(next+0,16+(2*A_PtrSize),"ptr"),Socket:=DllCall("ws2_32\socket","int",NumGet(next+0,4,"int"),"int",1,"int",6,"ptr")
		if(DllCall("ws2_32\bind","ptr",Socket,"ptr",sockaddr,"uint",sockaddrlen,"int")!=0)
			return m(DllCall("ws2_32\WSAGetLastError"))
		DllCall("ws2_32\freeaddrinfo","ptr",next),DllCall("ws2_32\WSAAsyncSelect","ptr",Socket,"ptr",A_ScriptHwnd,"uint",0x9987,"uint",0x29),ss:=DllCall("ws2_32\listen","ptr",Socket,"int",32),Debug.Socket:=Socket,Debug.filename:=Current(2).file,Debug.id:=Current(2).id,Debug.Hotkeys(1),Debug.Breakpoints:=[]
	}Accept(){
		if((sock:=DllCall("ws2_32\accept","ptr",Debug.Socket,"ptr",0,"int",0,"ptr"))!=-1)
			Debug.Socket:=sock,Debug.Register()
		Else
			Debug.Disconnect()
	}AddrInfo(){
		VarSetCapacity(hints,8*A_PtrSize,0),DllCall("ws2_32\getaddrinfo",astr,"127.0.0.1",astr,"9000","uptr",hints,"ptr*",results)
		return results
	}Caret(state){
		color:=state=1?Settings.Get("//theme/caret/@Debug",0x0000ff):Settings.Get("//theme/caret/@color",0xFFFFFF),width:=state=1?3:Settings.Get("//theme/caret/@width",1)
		for a,b in s.ctrl
			b.2069(color),b.2188(width)
	}Decode(string){ ;original http://www.autohotkey.com/forum/viewtopic.php?p=238120#238120
		if(string="")
			return
		DllCall("Crypt32.dll\CryptStringToBinary","ptr",&string,"uint",StrLen(string),"uint",1,"ptr",0,"uint*",cp:=0,"ptr",0,"ptr",0),VarSetCapacity(bin,cp),DllCall("Crypt32.dll\CryptStringToBinary","ptr",&string,"uint",StrLen(string),"uint",1,"ptr",&bin,"uint*",cp,"ptr",0,"ptr",0)
		return StrGet(&bin,cp,"UTF-8")
	}Disconnect(){
		Debug.Send("stop")
		Sleep,200
		DllCall("ws2_32\WSAAsyncSelect","uint",Debug.Socket,"ptr",A_ScriptHwnd,"uint",0,"uint",0),DllCall("ws2_32\closesocket","uint",Debug.Socket,"int"),DllCall("ws2_32\WSACleanup"),Debug.Socket:="",Debug.Off(),CSC().2264(10000000)
		v.DebugHighlight:=[],DebugHighlight(),Debug.Hotkeys(0),Debug.Caret(0)
	}Encode(text){
		IfEqual,text,,return
		cp:=0,VarSetCapacity(rawdata,StrPut(text,"UTF-8")),sz:=StrPut(text,&rawdata,"UTF-8")-1,DllCall("Crypt32.dll\CryptBinaryToString","ptr",&rawdata,"uint",sz,"uint",0x40000001,"ptr",0,"uint*",cp),VarSetCapacity(str,cp*(A_IsUnicode?2:1)),DllCall("Crypt32.dll\CryptBinaryToString","ptr",&rawdata,"uint",sz,"uint",0x40000001,"str",str,"uint*",cp)
		return str
	}Focus(){
		if(!v.Options.Focus_Studio_On_Debug_Breakpoint)
			WinActivate,% HWND([1])
	}Hotkeys(State){
		state:=state?"On":"Off"
		if(v.Options.Global_Debug_Hotkeys){
			Hotkey,IfWinActive
			for a,b in ["Stop_Debugger","Run_Program","Step_Into","Step_Out","Step_Over","List_Variables"]{
				if(key:=menus.SSN("//*[@clean='" b "']/@hotkey").text)
					Hotkey,%key%,HotkeyLabel,%state%
	}}}Run(filename){
		static pid
		Debug.filename:=filename
		SetTimer,runn,-1
		return
		runn:
		filename:=Debug.filename
		SplitPath,filename,,dir
		if(FileExist(A_ScriptDir "\AutoHotkey.exe"))
			Run,%A_ScriptDir%\AutoHotkey.exe /Debug "%filename%",%dir%,,pid
		else
			Run,"%A_AhkPath%" /Debug "%filename%",%dir%,,pid
		sc:=v.Debug
		while(!WinExist("ahk_pid" pid)){
			Sleep,100
			if(A_Index=5){
				return m("Debugger failed, Please close all instances of " SplitPath(Debug.filename).filename " and try again")
		}}sc.2004(),sc.2003(0,"Initializing Debugger, Please Wait...`n"),CSC().2264(500)
		if(v.Options.Auto_Variable_Browser)
			VarBrowser()
		SetTimer,cee,-600
		return
		cee:
		if(WinExist("ahk_pid" pid)){
			ControlGetText,text,Static1,% "ahk_pid" pid
			sc:=CSC(),info:=StripError(text,Debug.filename) ;IMPORTANT
			if(info.line&&info.file)
				SetPos({file:info.file,line:info.line}),v.Debug.2003(v.Debug.2006,"`n" text)
		}return
	}Receive(){
		static last
		;Thank you Lexikos and fincs http://ahkscript.org/download/tools/DBGP.ahk
		Socket:=Debug.Socket
		while(DllCall("ws2_32\recv","ptr",Socket,"char*",c,"int",1,"int",0)){
			if(c=0)
				break
			length.=Chr(c)
		}if(length<=0)
			return Debug.wait:=0
		VarSetCapacity(packet,++length,0),recd:=0
		While(r<length){
			index:=A_Index,rr:=r,r:=DllCall("ws2_32\recv","ptr",Socket,"ptr",&packet,"int",length,"int",0x2)
			if(!Debug.Socket)
				m("Socket Disconnected, Debugging has stopped")
			if(r<1)
				error:=DllCall("GetLastError"),t(r,Socket,length,received,"An error occured",error,"Possible reasons for the error:","1.  Sending OutputDebug faster than 1ms per message","2.  Max_Depth or Max_Children value too large","time:2")
			if(r<length)
				Sleep,5
			if(A_Index>10){
				crap:=1
				break
		}}DllCall("ws2_32\recv","ptr",Socket,"ptr",&packet,"int",length,"int",0),Debug.wait:=0
		if(!IsObject(v.DisplayMsg))
			v.DisplayMsg:=[]
		if(info:=StrGet(&packet,length-1,"UTF-8")){
			v.DisplayMsg.Push(info)
			SetTimer,Display,-10
		}if(crap){
			last.=r "!=" length "`n"
			SetTimer,crap,-100
		}else
			t()
		return
		crap:
		Debug.Receive()
		return
	}Register(){
		DllCall("ws2_32\WSAAsyncSelect","ptr",Debug.Socket,"ptr",A_ScriptHwnd,"uint",0x9987,"uint",0x29)
	}Send(message){
		mm:=message,message.=Chr(0),len:=StrPut(message,"UTF-8"),VarSetCapacity(buffer,len),ll:=StrPut(message,&buffer,"UTF-8")
		if(!Debug.Socket){
			t("Debugger not functioning: " Debug.Socket,"time:1")
			if(message="stop")
				return
			else
				Exit
		}Debug.wait:=1,sent:=DllCall("ws2_32\send","ptr",Debug.Socket,uptr,&buffer,"int",ll,"int",0,"cdecl")
		if(sent&&mm!="stop"){
			sendwait:
			Sleep,20
			if(Debug.Socket<=0)
				return t("Debugging has stopped")
			While(Debug.wait){
				Sleep,10
				if(Debug.Socket<1)
					return
				if(A_Index>20){
					Debug.wait:=0,v.ready:=1,Debug.Receive(),InsertDebugMessage()
					Break
		}}}return
	}Sock(info*){
		if(info.2=0x9987){
			if(info.1=1)
				Debug.Receive()
			if(info.1&0xffff=8)
				Debug.Accept()
			if(info.1&0xFFFF=32)
				Debug.Disconnect()
	}}TopXML(){
		return Debug.XML.SSN("//main")
	}
}
Debug_Current_Script(){
	Scan_Line(),Save()
	if(Debug.Socket){
		sc:=v.Debug,sc.2003(sc.2006,"`nKilling Current Process"),Debug.Send("stop")
		Sleep,200
		if(Debug.Socket){
			Debug.Send("stop")
			Sleep,200
	}}new Debug()
	if(Debug.VarBrowser)
		Default("SysTreeView321",98),TV_Delete()
	if(Current(2).file=A_ScriptFullPath)
		return m("Can not Debug AHK Studio using AHK Studio.")
	/*
		All:=SN(Current(7),"descendant::*[@type='Breakpoint']"),Nodes:=[]
		while(aa:=All.Item[A_Index-1],ea:=XML.EA(aa))
			Nodes.Push(DebugFile:=SSN(aa,"ancestor::file"))
		for a,b in Nodes
			ScanFile.Scan(b,1)
	*/
	All:=SN(Current(7),"descendant::*[@type='Breakpoint']"),Debug.Run(Current(2).file)
	Sleep,500
	while(aa:=All.Item[A_Index-1],ea:=XML.EA(aa)){
		DebugFile:=SSN(aa,"ancestor::file/@file").text,Text:=Update({Get:DebugFile}),Pos:=1,LastPos:=""
		while(RegExMatch(Text,"Oi)(;*\[" ea.Text "\])",Found,Pos),Pos:=Found.Pos(1)+Found.Len(1)){
			if(Pos=LastPos),LastPos:=Pos
				Break
			RegExReplace(SubStr(Text,1,Found.Pos(1)),"\R",,Line),debug.Send("breakpoint_set -t line -f " DebugFile " -n " Line+1 " -i " SSN(aa,"@id").text "|" Line)
		}
	}
}
class EasyView{
	Register(Control,HWND,Label,win:=1,ID:=""){
		WinGetClass,class,ahk_id%HWND%
		obj:=this.Controls[Control]:=[],obj.Label:=Label,obj.HWND:=HWND,obj.type:=InStr(class,"TreeView")?"TreeView":"ListView",this.win:=win,this.HWND[HWND]:=ID
	}Add(Control,text,parentopt:=0,options:=""){
		this.Default(Control),this.Controls[Control].type="TreeView"?(value:=TV_Add(text,parentopt,options)):(IsObject(text)?(value:=LV_Add(parentopt,text*)):value:=LV_Add(parentopt,text))
		return value
	}Default(Control){
		if(A_DefaultGUI!=this.win)
			Gui,% this.win ":Default"
		Gui,% this.win ":" this.Controls[Control].type,% this.Controls[Control].HWND
	}Delete(Control,Item:=0){
		this.Default(Control),(this.Controls[Control].type="TreeView")?TV_Delete(item):LV_Delete(item)
	}Disable(Control){
		this.Default(Control)
		GuiControl,% this.win ":-Redraw",% this.Controls[Control].HWND
		GuiControl,% this.win ":+g",% this.Controls[Control].HWND
	}Enable(Control){
		this.Default(Control)
		GuiControl,% this.win ":+Redraw",% this.Controls[Control].HWND
		GuiControl,% this.win ":+g" this.Controls[Control].Label,% this.Controls[Control].HWND
	}Get(Control,TV,Value:="Expand"){
		this.Default(Control)
		return TV_Get(TV,Value)
	}GetHWND(Control){
		return this.Controls[Control].HWND
	}Modify(Control,text:="",Item:="",Options:=""){
		this.Default(Control),this.Controls[Control].type="TreeView"?(text?TV_Modify(Item,Options,text):TV_Modify(Item,Options)):(LV_Modify(Item,Options,(IsObject(text)?text*:text)))
	}Redraw(Control,State:=1){
		this.Default(Control)
		GuiControl,% this.win ":" (State?"+":"-") "Redraw",% this.Controls[Control].HWND
	}Selection(Control){
		dg:=A_DefaultGui,this.Default(Control),tv:=TV_GetSelection()
		Gui,%dg%:Default
		return tv
	}
}
Class ExtraScintilla{
	static ctrl:=[],main:=[],temp:=[],hidden:=[]
	__New(window,info:="{Notify:Pos}"){ ;keep adding valid things in the Default
		Notify:=info.Notify,win:=window?window:1,pos:=info.pos?info.pos:"x0 y0 w0 h0"
		Notify:=Notify?Notify:"Spoons"
		Gui,%win%:Add,custom,%pos% classScintilla +%mask% hwndsc g%Notify% ;g%Notify% ; +1387331584
		for a,b in {fn:2184,ptr:2185}
			this[a]:=DllCall("SendMessageA",UInt,sc,int,b,int,0,int,0)
		this.sc:=sc+0
		return this
	}__Get(x*){
		return DllCall(this.fn,"Ptr",this.ptr,"UInt",x.1,int,0,int,0,"Cdecl")
	}__Call(code,lparam=0,wparam=0,extra=""){
		wp:=(wparam+0)!=""?"Int":"AStr",lp:=(lparam+0)!=""?"Int":"AStr"
		if(wparam.1!="")
			wp:="AStr",wparam:=wparam.1
		wparam:=wparam=""?0:wparam,lparam:=lparam=""?0:lparam
		if(wparam=""||lparam="")
			return
		return DllCall(this.fn,"Ptr",this.ptr,"UInt",code,lp,lparam,wp,wparam,"Cdecl")
}}
Spoons(a*){
	Info:=A_EventInfo,Code:=NumGet(Info+8)
	if((ctrl:=NumGet(Info+0))=v.debug.sc&&v.debug.sc){
		sc:=v.debug
		if(Code=2027){
			style:=sc.2010(sc.2008)
			if(style=-106)
				Run_Program()
			else if(style=-105)
				List_Variables()
		}return
	}
	if(Code=2028)
		SetTimer("LButton",-50)
}
UpdateBranches(a*){
	m("HERE! UpdateBranches umm... Coming Soon?")
	/*
		;~ this downloads all the branch info so keep it
		;~ BUT MAKE SURE TO NOT OVERWRITE ANY VERSIONS THAT ALREADY EXIST!!!!!!!!!!!!!
		UpdateBranches(){
			root:=this.DXML.SSN("//*"),pos:=1,node:=Node()
			info:=git.Send("GET",git.RepoURL("git/refs/heads")),List:=[]
			while(RegExMatch(info,"OUi)\x22ref\x22:\x22(.*)\x22",Found,pos),pos:=Found.Pos(1)+Found.len(1)){
				List[(item:=StrSplit(Found.1,"/").Pop())]:=1
				if(!this.DXML.Find("//branch/@name",item))
					this.DXML.Under(root,"branch",{name:item})
				if(!new:=vversion.Find(node,"branch/@name",item))
					new:=vversion.Under(node,"branch",{name:item,onefile:1})
				if(item="master"&&SSN((before:=SSN(node,"branch")),"@name").text!="master")
					node.InsertBefore(new,before)
			}blist:=this.DXML.SN("//branch")
			while(bl:=blist.item[A_Index-1],ea:=XML.EA(bl))
				if(!List[ea.name])
					bl.ParentNode.RemoveChild(bl)
			all:=SN(node,"branch")
			while(aa:=all.item[A_Index-1],ea:=XML.EA(aa))
				if(!List[ea.name])
					aa.ParentNode.RemoveChild(aa)
			pos:=1,info:=git.Send("GET",git.RepoURL("releases"))
			while(pos:=RegExMatch(info,"{\x22url\x22:",,pos)){
				commit:=[]
				for a,b in {id:",",target_commitish:",",name:",",draft:",",prerelease:",",body:"\}"}
					RegExMatch(info,"OUi)\x22" a "\x22:(.*)" b,Found,pos),commit[a]:=Trim(Found.1,Chr(34))
				if(!top:=vversion.Find(node,"branch/@name",commit.target_commitish))
					top:=vversion.Under(node,"branch",{name:commit.target_commitish})
				if(!version:=vversion.Find(top,"version/@name",commit.name))
					version:=this.DXML.Under(top,"version",{name:commit.name})
				for a,b in commit{
					if(a!="body")
						version.SetAttribute(a,b)
					else
						version.text:=RegExReplace(b,"\R|\\n|\\r",Chr(127))
				}
				pos:=found.Pos(1)+found.Len(1)
			}for a in list{
				if(!SSN((top:=vversion.Find(node,"branch/@name",a)),"version"))
					vversion.Under(top,"version",{name:1})
			}PopVer()
		}
	*/
}
Class Github{
	static url:="https://api.github.com",HTTP:=[]
	__New(NewWin){
		ea:=Settings.EA("//github")
		if(!(ea.owner&&ea.token))
			return m("Please setup your Github info"),Update_Github_Info()
		this.HTTP:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
		if(proxy:=Settings.SSN("//proxy").text)
			HTTP.setProxy(2,proxy)
		for a,b in Settings.EA("//github")
			this[a]:=b
		this.NewWin:=NewWin,Node:=this.Node(),this.BaseURL:=this.url "/repos/" this.owner "/" this.repo "/",this.repo:=SSN(Node,"ancestor-or-self::info/@repo").text,this.Token:="?access_token=" ea.token,this.Refresh()
		return this
	}Blob(repo,text,skip:=""){
		if(!skip)
			text:=this.EncodeGF(text)
		json={"content":"%text%","encoding":"base64"}
		return this.Sha(this.Send("POST",this.url "/repos/" this.owner "/" repo "/git/blobs" this.Token,json))
	}Branch(){
		return SSN(Version_Tracker.GetNode("ancestor-or-self::branch"),"@name").text
	}Commit(repo,tree,parent,message:="Updated the file",name:="placeholder",email:="placeholder@gmail.com"){
		message:=this.UTF8(message),parent:=this.cmtsha,url:=this.url "/repos/" this.owner "/" repo "/git/commits" this.Token
		json={"message":"%message%","author":{"name": "%name%","email": "%email%"},"parents":["%parent%"],"tree":"%tree%"}
		sha:=this.Sha(info:=this.Send("POST",url,json))
		return sha
	}CreateFile(repo,filefullpath,text,commit="First Commit",realname="Testing",email="Testing"){
		SplitPath,filefullpath,filename
		url:=this.url "/repos/" this.owner "/" repo "/contents/" filename this.Token,file:=this.utf8(text)
		json={"message":"%commit%","committer":{"name":"%realname%","email":"%email%"},"content": "%file%"}
		this.HTTP.Open("PUT",url),this.HTTP.send(json),RegExMatch(this.HTTP.ResponseText,"U)"Chr(34) "sha" Chr(34) ":(.*),",found)
	}CreateRepo(name,description="",homepage="",private="false",issues="true",wiki="true",downloads="true"){
		url:=this.url "/user/repos" this.Token
		for a,b in {homepage:this.UTF8(homepage),description:this.UTF8(description)}
			if(b!=""){
				aa="%a%":"%b%",
				add.=aa
			}
		/*
			json={"name":"%name%",%add% "private":%private%,"has_issues":%issues%,"has_wiki":%wiki%,"has_downloads":%downloads%,"auto_init":true}
		*/
		return this.Send("POST",url,this.json({name:name,private:private,has_issues:issues,has_wiki:wiki,has_downloads:Downloads,auto_init:"true",homepage:this.UTF8(homepage),description:this.UTF8(description)}))
	}Delete(filenames){
		node:=this.DXML.Find("//branch/@name",this.Branch())
		if(SN(node,"*[@sha]").length!=SN(node,"*").length)
			this.TreeSha()
		for c,d in filenames{
			StringReplace,cc,c,\,/,All
			url:=this.url "/repos/" this.owner "/" this.repo "/contents/" cc this.Token,sha:=SSN(node,"descendant::*[@file='" c "']/@sha").text
			if(!sha)
				Continue
			this.HTTP.Open("DELETE",url),this.HTTP.send(this.json({"message":"Deleted","sha":sha,"branch":this.Branch()}))
			d.ParentNode.RemoveChild(d)
			return this.HTTP
	}}EncodeGF(text){
		if(text="")
			return
		cp:=0,VarSetCapacity(rawdata,StrPut(text,"UTF-8")),sz:=StrPut(text,&rawdata,"UTF-8")-1,DllCall("Crypt32.dll\CryptBinaryToString","ptr",&rawdata,"uint",sz,"uint",0x40000001,"ptr",0,"uint*",cp),VarSetCapacity(str,cp*(A_IsUnicode?2:1)),DllCall("Crypt32.dll\CryptBinaryToString","ptr",&rawdata,"uint",sz,"uint",0x40000001,"str",str,"uint*",cp)
		return str
	}Find(search,text){
		RegExMatch(text,"UOi)\x22" search "\x22\s*:\s*(.*)[,|\}]",found)
		return Trim(found.1,Chr(34))
	}GetRef(){
		this.cmtsha:=this.Sha(info:=this.Send("GET",this.RepoURL("git/refs/heads/" this.Branch())))
		if(!this.cmtsha){
			if((RepoList:=this.Send("GET",this.RepoURL("branches")))~="\x22message\x22:\x22Not Found\x22")
				this.CreateRepo(this.Repo),RepoList:=this.Send("GET",this.RepoURL("branches"))
			Pos:=LastPos:=1,RepoObj:=[]
			while(RegExMatch(RepoList,"OUi)\x22name\x22:\x22(.*)\x22.*\x22sha\x22:\x22(.*)\x22",Found,Pos),Pos:=Found.Pos(1)+Found.Len(1)){
				if(Pos=LastPos),LastPos:=Pos
					Break
				RepoObj.Push({Repo:Found.1,Sha:Found.2})
			}if(RepoObj.MaxIndex()>1){
				Selections:=[],ShowList:="There are multiple Repositories to create a branch from`nPlease Enter The NUMBER from this list to create the new branch from`n`n"
				for a,b in RepoObj
					ShowList.=A_Index ": " b.Repo "`n",Selections[A_Index]:=b
				RegExReplace(ShowList,"\R",,Count)
				InputBox,Number,Choose A Branch,%ShowList%,,,% (Count*15)+150
				if(!Obj:=Selections[Number]){
					m(Number " was not one of the options. Exiting.")
					Exit
				}
			}else
				Obj:=RepoObj.1
			WinGetTitle,Title,% this.NewWin.ID
			this.SetTitle("Creating Branch: " this.Branch())
			this.Send("POST",this.RepoURL("git/refs"),this.json({ref:"refs/heads/" this.Branch(),sha:Obj.Sha}))
			this.SetTitle("Getting Branch: " this.Branch() " sha")
			this.cmtsha:=this.Sha(info:=this.Send("GET",this.RepoURL("git/refs/heads/" this.Branch())))
			this.SetTitle(Title)
		}
		RegExMatch(this.Send("GET",this.RepoURL("commits/" this.cmtsha)),"U)tree.:\{.sha.:.(.*)" Chr(34),found)
		return found1
	}GetTree(value:=""){
		info:=this.Send("GET",this.url "/repos/" this.owner "/" this.repo "/git/trees/" this.GetRef() this.Token)
		if(value){
			temp:=new XML("tree"),top:=temp.SSN("//tree"),info:=SubStr(info,InStr(info,Chr(34) "tree" Chr(34))),pos:=1
			while,RegExMatch(info,"OU){(.*)}",found,pos){
				new:=temp.under(top,"node")
				for a,b in StrSplit(found.1,",")
					in:=StrSplit(b,":",Chr(34)),new.SetAttribute(in.1,in.2)
				pos:=found.pos(1)+found.len(1)
			}temp.Transform(2)
		}return temp
	}json(info){
		for a,b in info
			json.=Chr(34) a Chr(34) ":" (b="true"?"true":b="false"?"false":Chr(34) b Chr(34)) ","
		return "{" Trim(json,",") "}"
	}Limit(){
		url:=this.url "/rate_limit" this.Token,this.HTTP.Open("GET",url),this.HTTP.Send()
		m(this.HTTP.ResponseText)
	}Node(){
		if(!node:=vversion.SSN("//info[@file='" Current(2).file "']"))
			node:=vversion.Under(vversion.SSN("//*"),"info"),node.SetAttribute("file",Current(2).file)
		this.repo:=SSN(Node,"ancestor-or-self::info/@repo").text
		if(this.repo){
			if(!SSN(node,"descendant::branch[@name='master']"))
				UpdateBranches()
		}
		return node
	}Ref(repo,sha){
		url:=this.url "/repos/" this.owner "/" repo "/git/refs/heads/" this.Branch() this.Token,this.HTTP.Open("PATCH",url)
		json={"sha":"%sha%","force":true}
		this.HTTP.Send(json)
		SplashTextOff
		return this.HTTP.Status
	}Refresh(){
		this.repo:=SSN(this.Node(),"@repo").text
		if(this.repo){
			if(!FileExist(A_ScriptDir "\Github"))
				FileCreateDir,% A_ScriptDir "\Github"
			this.DXML:=new XML(this.repo,A_ScriptDir "\Github\" this.repo ".xml")
			branch:=SSN(this.Node(),"@branch").text
			this.DXML.Save(1)
		}
	}RepoURL(Path:="",Extra:=""){
		return this.BaseURL:=this.url "/repos/" this.owner "/" this.repo (Path?"/" Path:"") this.Token Extra
	}Send(verb,url,data=""){
		this.HTTP.Open(verb,url)
		/*
			m("Verb: " Verb,"URL: " URL,"Data: " IsObject(data)?this.json(data):data)
		*/
		this.HTTP.Send(IsObject(data)?this.json(data):data)
		SB_SetText("Remaining API Calls: " this.remain:=this.HTTP.GetResponseHeader("X-RateLimit-Remaining"))
		return this.HTTP.ResponseText
	}SetTitle(Text:="Github Version Tracker"){
		WinSetTitle,% this.NewWin.ID,,%Text%
	}Sha(text){
		RegExMatch(this.HTTP.ResponseText,"U)\x22sha\x22:(.*),",found)
		return Trim(found1,Chr(34))
	}Tree(repo,parent,blobs){
		url:=this.url "/repos/" this.owner "/" repo "/git/trees" this.Token,open:="{"
		if(parent)
			json=%open% "base_tree":"%parent%","tree":[
		else
			json=%open% "tree":[
		for a,blob in blobs{
			add={"path":"%a%","mode":"100644","type":"blob","sha":"%blob%"},
			json.=add
		}
		return this.Sha(info:=this.Send("POST",url,Trim(json,",") "]}"))
	}TreeSha(){
		node:=this.DXML.Find("//branch/@name",this.Branch()),url:=this.url "/repos/" this.owner "/" this.repo "/commits/" this.Branch() this.Token,tree:=this.Sha(this.Send("GET",url)),url:=this.url "/repos/" this.owner "/" this.repo "/git/trees/" tree this.Token "&recursive=1",info:=this.Send("GET",url),info:=SubStr(info,InStr(info,"tree" Chr(34)))
		for a,b in StrSplit(info,"{")
			if(path:=this.Find("path",b)){
				if(this.Find("mode",b)!="100644"||path="readme.md"||path=".gitignore")
					Continue
				StringReplace,path,path,/,\,All
				if(!nn:=SSN(node,"descendant::*[@file='" path "']"))
					nn:=this.DXML.Under(node,"file",{file:path})
				nn.SetAttribute("sha",this.Find("sha",b))
	}}UTF8(info){
		info:=RegExReplace(info,"([" Chr(34) "\\])","\$1")
		for a,b in {"`n":"\n","`t":"\t","`r":"\r"}
			StringReplace,info,info,%a%,%b%,All
		return info
	}
}
Class Icon_Browser{
	static start:="",keep:=[]
	__New(obj,hwnd,win,pos:="xy",min:=300,Function:="",Reload:=""){
		this.hwnd:=hwnd,this.win:=win,this.min:=min
		if(min)
			obj.Add("Button,xs gloadfile,Load File," pos,"Button,x+M gloaddefault,Default Icons," pos,"Button,x+M gIBWidth,Width," pos)
		Icon_Browser.keep[win]:=this,this.Reload:=Reload=1?Function:Reload,this.Function:=Function,this.file:=Settings.Get("//icons/@last","Shell32.dll"),this.start:=0,this.Populate()
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
		this:=icon_browser.keep[A_Gui],this.file:=file,this.start:=0,this.Populate(),Settings.Add("icons",{"last":this.file})
		return
		LoadDefault:
		this:=icon_browser.keep[A_Gui],this.file:="Shell32.dll",this.start:=0,this.Populate(),Settings.Add("icons",{"last":this.file})
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
	static XML:=new XML("LineStatus"),stored:=[],state:={1:21,2:20}
	Add(line,state){
		sc:=CSC()
		if(sc.sc=MainWin.tnsc.sc||sc.sc=v.Debug.sc)
			return
		if(mask:=sc.2046(line))
			sc.2044(line,21),sc.2044(line,20)
		if(sc.2046(line)&2**this.state[state]=0)
			sc.2043(line,this.state[state])
		if(!node:=this.XML.SSN("//*[@id='" (id:=Current(8)) "']"))
			node:=this.XML.Add("state",{id:id},,1)
		node.SetAttribute("state",state)
	}Delete(start,end){
		add:=start+1=end?0:1,sc:=CSC()
		Loop,% end+add-start
			sc.2044(end+2-A_Index,-1)
	}Clear(){
		sc:=CSC(),node:=this.XML.SSN("//*[@id='" Current(8) "']").SetAttribute("state",0),next:=0
		while((next:=sc.2047(next,2**20+2**21))>=0)
			this.RemoveStatus(next)
		node.ParentNode.RemoveChild(node)
	}Save(id){
		this.XML.SSN("//*[@id='" id "']").SetAttribute("state",1)
	}tv(){
		sc:=CSC(),state:=SSN(node:=this.XML.SSN("//*[@id='" Current(8) "']"),"@state").text
		if(state=1){
			next:=0
			while((next:=sc.2047(next,2**20+2**21))>=0)
				this.RemoveStatus(next),sc.2043(next,this.state[state]),next++
		}node.SetAttribute("state",1)
	}UpdateRange(){
		sc:=CSC()
		for a,b in this.stored
			this.Add(a,b)
		this.stored:=[]
	}RemoveStatus(line){
		sc:=CSC(),mask:=sc.2046(line)
		if(mask&2**20)
			sc.2044(line,20)
		if(mask&2**21)
			sc.2044(line,21)		
	}StoreEdited(start,end,add){
		sc:=CSC()
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
ShowMainWindow(){
	WinActivate,% Mainwin.ID
}
ShowWindowSpy(){
	SplitPath,A_AhkPath,,Dir
	if(FileExist(Dir "\WindowSpy.ahk"))
		Run,%Dir%\WindowSpy.ahk
	else
		Run,%Dir%\AU3_Spy.exe	
}
ReloadStudio(){
	Exit(1)
}
ExitStudio(){
	Exit()
}
Class MainWindowClass{
	static keep:=[]
	__New(){
		/*
			Menu,Tray,NoStandard
		*/
		if(FileExist(A_ScriptDir "\AHKStudio.ico"))
			Menu,Tray,Icon,AHKStudio.ico
		if(v.Options.Hide_Tray_Icon)
			Menu,Tray,NoIcon
		Menu,Tray,Add,Show AHK Studio,ShowMainWindow
		Menu,Tray,Add,Window Spy,ShowWindowSpy
		Menu,Tray,Add,Reload,ReloadStudio
		Menu,Tray,Add,E&xit,ExitStudio
		Menu,Tray,Default,Show AHK Studio
		Gui,+Resize +LabelMainWindowClass. +hwndmain +MinSize400x400 -DPIScale
		Gui,Add,TreeView,x0 y0 w0 h0 hwndpe +0x400000
		Gui,Add,TreeView,x0 y0 w0 h0 hwndce +0x400000 AltSubmit
		Gui,Add,TreeView,hwndtn x0 y0 w0 h0 +0x400000 ;AltSubmit
		Gui,Color,% RGB(ea.Background),% RGB(ea.Background)
		v.SaveThis:=tn
		HWND(1,main),this.QuickFind(),this.hwnd:=main,TVC.Register(1,pe,"tv",,"projectexplorer"),TVC.Register(2,ce,"CEGO",,"codeexplorer"),TVC.Register(3,tn,"tn",,"trackednotestv"),TV_Add("Tracked Notes Here"),TNotes:=new Tracked_Notes(),this.tnsc:=new s(1,{pos:"x0 y0 w0 h0"}),this.tnsc.4006(0,"ahk"),Color(this.tnsc,"ahk"),this.tn:=tn+0,this.win:=1,this.ID:="ahk_id" main,TVC.Add(2,"Right Click to Refresh")
		Gui,Color,0,0
		this.pe:=pe+0,this.peid:="ahk_id" pe,this.ce:=ce+0,this.ceid:="ahk_id" ce
		Gui,Add,StatusBar,hwndsb,Testing
		Gui,Color,0xAAAAAA,0xAAAAAA
		Gui,Menu,% Menu("main")
		ControlGetPos,,,,h,,ahk_id%sb%
		this.Gui:=new XML("gui",A_ScriptDir "\lib\Gui.xml"),this.main:=main,this.ID:="ahk_id" main,this.sb:=h,OnMessage(0xA0,MainWindowClass.ChangePointer),OnMessage(0xA1,MainWindowClass.Resize),OnMessage(0x232,MainWindowClass.ExitSizeMove),OnMessage(0x0211,MainWindowClass.EnterOff),OnMessage(0x0212,MainWindowClass.EnterOn),OnMessage(6,"Activate")
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
			}if(ri.left||ri.top)
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
		if(this.Gui.SSN("//win[@win=1]/descendant::*[@type='Debug']"))
			return
		ControlGetFocus,Focus,% HWND([1])
		ControlGet,hwnd,hwnd,,%Focus%,% HWND([1])
		if(!Focus){
			sc:=v.LastSC
		}else if(!sc:=s.Ctrl[hwnd+0])
			sc:=CSC()
		Color(sc,"ahk")
		if(sc.sc=MainWin.tnsc.sc){
			for a,b in s.Ctrl
				if(a!=MainWin.TNSC.sc){
					sc:=CSC({hwnd:a})
					Break
		}}ControlGetPos,x,y,w,h,,% "ahk_id" sc.sc
		this.NewCtrlPos:=[],this.NewCtrlPos.y:=Round((y+h)*.75),this.NewCtrlPos.ctrl:=sc.sc,this.Split("Below","Debug",sc),this.DebugSC:=sc
	}Delete(Supress:=0){
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
		/*
			m(ONode.xml)
		*/
		/*
			HWND:=SSN(ONode,"@hwnd").text,All:=SN(ONode,"ancestor::win/descendant::*[@node()='" HWND "' and @hwnd!='" HWND "']")
			while(aa:=All.Item[A_Index-1],ea:=XML.EA(aa)){
				NN:=SSN(aa,"@node()[.='" HWND "']")
				if(Replace:=SSN(ONode,"@" NN.NodeName).text)
					aa.SetAttribute(NN.NodeName,Replace) ;,m(NN.NodeName,Replace,ONode.xml)
			}
			
			onode.ParentNode.RemoveChild(onode)
			;~ this.Attach()
			this.Size(1)
			if(oea.type~="Project Explorer|Code Explorer"){
				this.SetWinPos(oea.hwnd,0,0,0,0,ea)
			}else if(oea.type~="Scintilla|Debug"){
				s.Hidden.Push(oea.hwnd):=1,this.SetWinPos(oea.hwnd,0,0,0,0)
				if(oea.type="Debug"){
					v.debug:=""
					if(!Supress)
						debug.Send("stop")
			}}else if(oea.type="Tracked Notes")
				this.SetWinPos(this.tnsc.sc,0,0,0,0,ea),this.SetWinPos(this.tn,0,0,0,0,ea),Redraw()
			else
				DllCall("DestroyWindow",uptr,oea.hwnd)
			if(oea.type="Tracked Notes")
				rem:=this.GUI.SSN("//win[@win='Tracked_Notes']"),rem.ParentNode.RemoveChild(rem)
			
			
			;~ get all that have the hwnd as a ba
			
			return
		*/
		if(xx.SSN("//" top "*[@x=" oea.x+oea.w " and @y=" oea.y "]")&&xx.SSN("//" top "*[@x=" oea.x+oea.w " and @y+@h=" oea.y+oea.h "]")){
			/*
				m("Here1")
			*/
			list:=xx.SN("//" top "*[@x=" oea.x+oea.w " and ((@y=" oea.y ")or(@y>" oea.y " and @y+@h<" oea.y+oea.h ")or(@y+@h=" oea.y+oea.h "))]")
			while(ll:=list.item[A_Index-1]),ea:=XML.EA(ll)
				ll.SetAttribute("x",oea.x),ll.SetAttribute("w",oea.w+ea.w),nope:=0,this.SetWinPos(XML.EA(ll))
		}else if(xx.SSN("//" top "*[@x+@w=" oea.x " and @y=" oea.y "]")&&xx.SSN("//" top "*[@x+@w=" oea.x " and @y+@h=" oea.y+oea.h "]")){
			/*
				m("Here2")
			*/
			list:=xx.SN("//" top "*[@x+@w=" oea.x " and ((@y=" oea.y ")or(@y>" oea.y " and @y+@h<" oea.y+oea.h ")or(@y+@h=" oea.y+oea.h "))]")
			while(ll:=list.item[A_Index-1]),ea:=XML.EA(ll)
				ll.SetAttribute("w",oea.w+ea.w),nope:=0,this.SetWinPos(XML.EA(ll))
		}else if(xx.SSN("//" top "*[@y+@h=" oea.y " and @x=" oea.x "]")&&xx.SSN("//" top "*[@y+@h=" oea.y " and @x+@w=" oea.x+oea.w "]")){
			/*
				m("Here3")
			*/
			/*
				DebugWindow("FLAN!")
			*/
			list:=xx.SN("//" top "*[@y+@h=" oea.y " and ((@x=" oea.x ")or(@x>" oea.x " and @x+@w<" oea.x+oea.w ")or(@x+@w=" oea.x+oea.w "))]")
			while(ll:=list.item[A_Index-1]),ea:=XML.EA(ll){
				ll.SetAttribute("h",oea.h+ea.h),nope:=0,this.SetWinPos(XML.EA(ll))
		}}else if(xx.SSN("//" top "*[@y=" oea.y+oea.h " and @x=" oea.x "]")&&xx.SSN("//" top "*[@y=" oea.y+oea.h " and @x+@w=" oea.x+oea.w "]")){
			/*
				m("Here4")
			*/
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
				s.Hidden.Push(oea.hwnd):=1,this.SetWinPos(oea.hwnd,0,0,0,0)
				if(oea.type="Debug"){
					v.debug:=""
					if(!Supress)
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
		ControlFocus,,% "ahk_id" CSC(2).sc
		return
	}DropFiles(filelist,c*){
		for a,b in filelist{
			if(CEXML.Find("//main/@file",b))
				m("File: " b " is Already open")
			Open(b),last:=b
		}tv(SSN(CEXML.Find("//main/@file",last),"file/@tv").text)
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
					if(tv:=SSN(CEXML.Find("//file/@file",ea.file),"@tv").text)
						tv(tv,{sc:sc.sc})
					else
						tv(CEXML.SSN("//main/descendant::*/@tv").text,{sc:sc.sc})
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
				sc:=new ExtraScintilla(1,{pos:"x" ea.x " y" ea.y " w" ea.w " h" ea.h}),hwnd:=sc.sc+0,v.debug:=sc,Color(sc)
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
		xx:=this.XML,all:=this.XML.SN("//win[@win=1]/descendant::control"),win:=this.WinPos()
		while(aa:=all.item[A_Index-1]),ea:=XML.EA(aa){
			if(ea.x>0&&!ea.lp)
				aa.SetAttribute("lp",Round(ea.x/win.w,6))
			if(ea.y>0&&!ea.tp)
				aa.SetAttribute("tp",Round(ea.y/win.h,6))
		}pos:=xx.SSN("//*[@win=1]/@pos").text,pos:=pos?pos:info.pos
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
	}Split(direction:=0,type:="Scintilla",Focus:=""){
		space:=[],np:=this.NewCtrlPos,hwnd:=np.ctrl,add:=0
		win:=this.WinPos()
		if(!Node:=this.GUI.SSN("//*[@hwnd='" hwnd "']"))
			if(!node:=this.GUI.SSN("//*[@hwnd='" hwnd+0 "']"))
				return m("Something went Terribly wrong. Split")
		ea:=XML.EA(node),npos:=this.WinPos(ea.hwnd),x-=this.Border+npos.x
		if(direction="Above")
			this.SetWinPos(hwnd,ea.x,np.y+add,ea.w,ea.h-(np.y-ea.y),ea,,1),space:={x:ea.x,y:ea.y+add,w:ea.w,h:np.y-ea.y}
		if(direction="Below")
			this.SetWinPos(hwnd,ea.x,ea.y+add,ea.w,np.y-ea.y,ea,,1),space:={x:ea.x,y:np.y+add,w:ea.w,h:ea.h-(np.y-ea.y)}
		if(direction="Left")
			this.SetWinPos(hwnd,np.x,ea.y+add,ea.w-(np.x-ea.x),ea.h,ea,,1),space:={x:ea.x,y:ea.y+add,w:np.x-ea.x,h:ea.h}
		if(direction="Right")
			this.SetWinPos(hwnd,ea.x,ea.y,np.x-ea.x,ea.h,ea,,1),space:={x:np.x,y:ea.y+add,w:ea.w-(np.x-ea.x),h:ea.h}
		if(type="Scintilla"){
			sc:=new s(1,{pos:"x0 y0 w0 h0"}),Redraw()
			node:=this.Add(sc.sc,type),Color(sc,"",A_ThisFunc " Class Mainwin"),sc.2277(v.Options.End_Document_At_Last_Line)
		}else if(type="Debug"){
			v.Debug:=sc:=new ExtraScintilla(1,{pos:"x0 y0 w0 h0"}),Redraw()
			node:=this.Add(sc.sc,type),sc.2277(v.Options.End_Document_At_Last_Line)
			if(type="Debug"){
				Loop,4
					sc.2242(A_Index-1,0)
				Color(sc,Current(3).Lang),sc.2403(0x08,0)
			}
		}else if(type="Search"){
			node:=this.Add(this.NewCtrlPos.hwnd,"Search")
		}else if(type="Code Explorer"){
			node:=this.Add(this.ce,type)
		}else if(type="Project Explorer"){
			node:=this.Add(this.pe,type)
		}else if(type="Tracked Notes")
			this.Tracked_Notes(),node:=this.Add(this.tn,type),TNotes.SetNode()
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
		if(Focus.SC)
			ControlFocus,,% "ahk_id" Focus.SC
		if(type="Scintilla"){
			tv:=Current(3).tv
			ControlFocus,,% "ahk_id" sc.sc
			tv(tv)
		}return
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
			this.Hidden.push(ea.hwnd),s.ctrl[ea.hwnd].Hidden:=1,this.SetWinPos(ea.hwnd,0,0,0,0,ea),CSC(2)
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
	static prefix:={"@":"Menu","^":"File"} ;,"%":"Variable",")":"Clipboard"
	__New(){
		this.Menus()
		return this
	}Menus(){
		this.MenuList:=[],List:=menus.SN("//menu"),Top:=CEXML.ReCreate("//menu","menu")
		while(mm:=List.item[A_Index-1],ea:=XML.EA(mm)){
			if(SSN(mm,"*").NodeName="Menu")
				Continue
			Clean:=RegExReplace(ea.Clean,"_"," "),Launch:=IsFunc(ea.Clean)?"func":IsLabel(ea.Clean)?"label":v.Options.HasKey(ea.Clean)?"option":""
			if(Launch=""&&ea.Plugin=""&&!v.Options.HasKey(ea.Clean))
				Continue
			CEXML.Under(Top,"item",{launch:Launch?Launch:ea.Plugin,text:Clean,type:"Menu",sort:Clean,additional1:(ea.Hotkey?Convert_Hotkey(ea.Hotkey):""),order:"text,type,additional1",clean:ea.Clean})
		}
}}
Class OutPutDebugPane{
	__New(){
		return this
	}Show(){
		if(!v.Debug.SC)
			MainWin.DebugWindow()
	}Print(Text){
		if(!v.Debug.SC)
			MainWin.DebugWindow()
		sc:=v.Debug,sc.2003(sc.2006,Text),sc.2025(sc.2006)
	}Clear(){
		v.Debug.2004()
	}Hide(){
		Close_Debug_Window()
	}
}
Class PluginClass{
	__Call(x*){
		;~ m(x)
	}__New(){
		return this
	}Activate(){
		WinActivate(HWND([1]))
	}AllCtrl(code,lp,wp){
		for a,b in s.ctrl
			b[code](lp,wp)
	}AutoClose(script){
		if(!this.Close[script])
			this.Close[script]:=1
	}Call(Info*){
		;this can cause major errors
		if(IsFunc(Info.1)&&Info.1~="i)(Fix_Indent|newindent)"=0){
			func:=Info.1,Info.Remove(1)
			return %func%(Info*)
		}SetTimer,% Info.1,-100
	}CallTip(text){
		sc:=CSC(),sc.2200(sc.2128(sc.2166(sc.2008)),text)
	}Color(con){
		v.con:=con
		SetTimer,Color,-1
		Sleep,10
		v.con:=""
	}CSC(obj,hwnd){
		CSC({plugin:obj,hwnd:hwnd})
	}Current(x:=""){
		return Current(x)
	}DebugWindow(Text,Clear:=0,LineBreak:=0,Sleep:=0,AutoHide:=0,MsgBox:=0){
		sc:=v.Debug
		if(!sc.sc)
			MainWin.DebugWindow(),sc:=v.Debug
		if(Clear)
			sc.2004()
		if(LineBreak&&sc.2006)
			sc.2003(sc.2006,"`n")
		if(Sleep)
			Sleep,%Sleep%
		sc.2003(sc.2006,Text),sc.2025(sc.2006)
		if(MsgBox)
			m(MsgBox=1?"Pause":MsgBox)
		if(AutoHide)
			Timer:=AutoHide?Abs(Autohide):5000,SetTimer("DebugShrinkSize",-Timer)
		MarginWidth(sc)
		return
		DebugShrinkSize:
		np:=MainWin.NewCtrlPos:=[],np.Ctrl:=v.Debug.sc+0,np.Win:=MainWin.HWND,MainWin.Delete(1)
		return
	}DynaRun(script){
		return DynaRun(script)
	}EnableSC(x:=0){
		sc:=CSC()
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
		ControlFocus,Scintilla1,% HWND([1])
		GuiControl,+Redraw,Scintilla1
		TVC.Default(1),SetPos(TV_GetSelection()),CSC(1)
	}Get(name){
		return _:=%name%
	}GetTV(Control,Window){
		Default(Control,Window)
		return TV_GetSelection()
	}GetDebugPane(){
		return new OutPutDebugPane()
	}GuiControl(Info*){
		GuiControl,% Info.1,% Info.2,% Info.3
	}Hotkey(win:=1,key:="",label:="",on:=1){
		if(!(win,key,label))
			return m("Unable to set hotkey")
		Hotkey,IfWinActive,% HWND([win])
		Hotkey,%key%,%label%,% _:=on?"On":"Off"
	}HotStrings(Text,String,end:=""){
		sc:=CSC(),CPos:=sc.2008,TextLength:=StrPut(Text,"UTF-8")-1,StringLength:=StrPut(String,"UTF-8")-1,sc.2686(CPos-TextLength,CPos),sc.2194(StringLength,[String]),sc.2025((!end?CPos+StringLength-TextLength:CPos+end))
	}HWND(win:=1){
		return HWND(win)
	}InsertText(text){
		Encode(text,return),sc:=CSC(),sc.2003(sc.2008,&return)
		if(end=0)
			sc.2025(sc.2008+StrPut(text,"UTF-8")-1)
		else if(end)
			sc.2025(sc.2008+end)
	}m(Info*){
		m(Info*)
	}MoveStudio(){
		Version:=1.005.19
		SplitPath,A_ScriptFullPath,,,,name
		FileMove,%A_ScriptFullPath%,%name%-%version%.ahk,1
	}Open(Info){
		tv:=Open(Info),tv(tv),WinActivate(HWND([1]))
	}Path(){
		return A_ScriptDir
	}Plugin(action,hwnd){
		SetTimer,%action%,-10
	}Publish(Info:=1){
		return,Publish(Info,Branch:="",Version:="")
	}ReplaceSelected(text){
		Encode(text,return),CSC().2170(0,&return)
	}Save(){
		Save()
	}sc(){
		return CSC()
	}SetText(contents){
		length:=VarSetCapacity(text,strput(contents,"utf-8")),StrPut(contents,&text,length,"utf-8"),CSC().2181(0,&text)
	}SetTimer(timer,period:=-10){
		if(!IsFunc(timer)&&!IsLabel(timer))
			return
		period:=period>0?-period:period
		SetTimer,%timer%,%period%
	}Show(){
		sc:=CSC()
		WinActivate(HWND([1]))
		GuiControl,+Redraw,% sc.sc
		SetPos(sc.2357),sc.2400
	}SSN(Node,XPath){
		return Node.SelectSingleNode(XPath)
	}StudioPath(){
		return A_ScriptFullPath
	}Style(){
		return ea:=Settings.EA(Settings.SSN("//theme/default")),ea.Color:=RGB(ea.Color),ea.Background:=RGB(ea.Background)
	}TrayTip(Info){
		TrayTip,AHK Studio,%Info%,2
	}tv(tv){
		if(tv~="\D"=0)
			return tv(tv)
		else
			return tv(SSN(CEXML.Find("//file/@file",tv),"@tv").text)
	}Update(filename,text){
		Update({file:filename,text:text})
	}Version(){
		Version:=1.005.19
		return version
	}
}
class ScanFile{
	static All:=[]
	__New(Refresh:=0){
		return this
	}GetAll(ea){
		if(!ea.ID)
			return
		return ScanFile.All[ea.ID]
	}GetCEXML(ea){
		static obj:=[]
		if(!Node:=obj[ea.File]){
			all:=CEXML.SN("//file")
			while(aa:=all.item[A_Index-1],eea:=XML.EA(aa))
				obj[eea.File]:={Node:aa,Parent:aa.ParentNode}
			Node:=obj[ea.File]
		}return Node
	}RemoveComments(ea,Language:=0,SetCurrentPos:=0){
		xx:=ScanFile.XML,ScanFile.Before:=Text:=ea.File?Update({get:ea.file}):ea,Tick:=A_TickCount,Search:=[]
		if(SetCurrentPos)
			sc:=CSC(),Split:=sc.TextRange(0,sc.2008),Text:=SubStr(Text,1,StrLen(Split)) Chr(127) SubStr(Text,StrLen(Split)+1)
		for a,b in Keywords.Comments[Language?Language:(ea.Lang?ea.Lang:Language)]
			String:=b,Add:="(\x7F\s)?",String:=(Pos:=InStr(String,"^"))?SubStr(String,1,Pos) Add SubStr(String,Pos+1):Add String,Search[a]:=RegExReplace(String,"\x60n","`n")
		if(Search.Open){
			while(RegExMatch(Text,Search.Open,Start)){
				if(!RegExMatch(Text,Search.Close,End))
					Break
				While((RegExMatch(Text,Search.Close,End))<Start.Pos(0)){
					if(!End)
						Break,2
					Text:=SubStr(Text,1,End.Pos(0)-1) SubStr(Text,End.Pos(0)+End.Len(0)),RegExMatch(Text,Search.Open,Start)
				}Text:=SubStr(Text,1,Start.Pos(0)-1) SubStr(Text,End.Pos(0)+End.Len(0))
			}if(Search.Line)
				Text:=RegExReplace(Text,Search.Line)
			Text:=RegExReplace(Text,"(\R\s*)","`n"),Text:=RegExReplace(Text,"\R\R"),ScanFile.CurrentText:=Text
		}ScanFile.CurrentText:=Text
		if(Language)
			return Text
		if(!ea.ID)
			return
		rem:=xx.SSN("//file[@id='" ea.ID "']")
		if(!Language)
			rem.ParentNode.RemoveChild(rem),Top:=xx.Add("file",{id:ea.ID,filename:ea.FileName},,1)
		else{
			Top:=Rem,all:=SN(Top,"comment")
			while(aa:=all.item[A_Index-1],ea:=XML.EA(aa))
				aa.ParentNode.RemoveChild(aa)
		}LastPos:=0
		return Top
	}Scan(Node,Refresh:=0){
		if(Refresh){
			All:=SN(Node,"descendant::info")
			while(aa:=All.Item[A_Index-1])
				aa.ParentNode.RemoveChild(aa)
		}this.ScanText(Node)
	}ScanText(Node){
		static ScanTextXML:=new XML("ScanFile")
		Oea:=ea:=XML.EA(Node),this.RemoveComments(ea),Before:=ScanFile.Before,OText:=ScanFile.CurrentText,All:=SN(Node,"info")
		while(aa:=All.item[A_Index-1])
			aa.ParentNode.RemoveChild(aa)
		Omni:=GetOmniOrder(ea.Ext),ScanTextXML.XML.LoadXML("<ScanFile/>"),No:=ScanTextXML.SSN("//*")
		for c,d in Omni{
			for a,b in d{
				LastPos:="",Text:=b.Before?Before:OText
				if(InStr(a,Chr(127))){
					Obj:=StrSplit(a,Chr(127)),Pos:=1
					while(RegExMatch(Text,b.Regex,FUnder,Pos),Pos:=FUnder.Pos(1)+FUnder.Len(1)){
						if(FUnder.Text~="i)\b(" b.exclude ")\b"!=0&&FUnder.Text)
							Continue
						Start:=FUnder.Pos(1),NNList:=SN(No,"descendant::*[@start<'" Start "' and @end>'" Start "']")
						if(NNList.Length)
							NN:=NNList.item[NNList.Length-1],UnderHere:=SSN(Node,"descendant::*[@text='" SSN(NN,"@text").text "' and @type='" Obj.1 "']"),Spam:=CEXML.Under(UnderHere,"info",{type:Obj.2,att:FUnder.Att,pos:Start,text:FUnder.Text,upper:Upper(FUnder.Text)}),NN.AppendChild(Spam.CloneNode(0))
				}}else{
					Pos:=1
					while(RegExMatch(Text,b.Regex,Found,Pos),Pos:=Found.Pos(0)+Found.Len(0)){
						if(Pos=LastPos)
							Break
						if(b.Open){
							Search:=b.Open,Pos1:=Found.Pos(1),Open:=0,LastPos1:=0,Bounds:=b.Bounds,Start:=Found.Pos(1)
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
									Open+=FIS="Open"?+Count:-Count,SavedPos:=Pos1
									if(Open<=0)
										Break
								}if(Pos1=LastPos1)
									Break
								LastPos1:=Pos1
							}Atts:=Combine({start:Found.Pos(1),end:SavedPos,type:a,upper:Upper(Found.Text)},Found),Start:=Found.Pos(1),Spam:=((Deepest:=SN(Node,"descendant::*[@start<'" Start "' and @end>'" Start "']")).length)?CEXML.Under(Deepest.item[Deepest.Length-1],"info",Atts):CEXML.Under(Node,"info",Atts),New:=No.AppendChild(Spam.CloneNode(0))
							if((GoUnder:=SN(No,"descendant::*[@start<'" Start "' and @end>'" End "']")).Length)
								GoUnder.item[GoUnder.Length-1].AppendChild(New)
							else
								No.AppendChild(New)
						}else{
							if(b.Exclude){
								if(Found.Text~="i)\b(" b.exclude ")\b"=0&&Found.Text){
									Start:=Found.Pos(1)
									if(!SSN(No,"descendant::*[@start<'" Start "' and @end>'" Start "']"))
										Spam:=CEXML.Under(Node,"info",{type:a,att:Found.Att,pos:Start,text:Found.Text,upper:Upper(Found.Text)}),No.AppendChild(Spam.CloneNode(0))
							}}else if(Found.Text){
								Start:=Found.Pos(1)
								if(!SSN(No,"descendant::*[@start<'" Start "' and @end>'" Start "']")){
									Atts:=[]
									Loop,% Found.Count(){
										if(NNN:=Found.Name(A_Index)){
											if(VVV:=Found[NNN]){
												Atts[Format("{:L}",NNN)]:=VVV
									}}}for q,r in {type:a,upper:Upper(Found.Text)}
										Atts[q]:=r
									Spam:=CEXML.Under(Node,"info",Atts),No.AppendChild(Spam.CloneNode(0))
						}}}LastPos:=Pos
}}}}}}
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
			sc:=CSC(),CPos:=lparam?lparam:sc.2008
			return sc.TextRange(sc.2266(CPos,1),sc.2267(CPos,1))
		}else if(code="GetSelText"){
			VarSetCapacity(text,this.2161),length:=this.2161(0,&text)
			return StrGet(&text,length,"UTF-8")
		}else if(code="TextRange"){
			cap:=VarSetCapacity(text,Abs(lparam-wparam)),VarSetCapacity(TextRange,12,0),NumPut(lparam,TextRange,0),NumPut(wparam,TextRange,4),NumPut(&text,TextRange,8),this.2162(0,&TextRange)
			return StrGet(&text,cap,"UTF-8")
		}else if(code="GetLine"&&lparam!=""){
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
		if(Code=2181){
			GuiControl,1:-Redraw,% this.sc
			GuiControl,1:+g,% this.sc
		}Return:=DllCall(this.fn,"Ptr",this.ptr,"UInt",code,lp,lparam,wp,wparam,"Cdecl")
		if(Code=2181){
			GuiControl,1:+Redraw,% this.sc
			GuiControl,1:+gnotify,% this.sc
		}return Return
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
			if(m("Remove This Toolbar,This Can NOT be undone.  Are you sure?","btn:ync","def:2")="Yes"){
				rebar.hw.1.hide(removeid)
				for a,b in [Settings.SSN("//rebar/band[@id='" removeid "']"),Settings.SSN("//toolbar/bar[@id='" removeid "']")]
					if(b.xml)
						b.ParentNode.RemoveChild(b)
			}
			return
		}if(GetKeyState("Ctrl","P")&&button){
			Toolbar_Editor({hwnd:this.tb,id:this.id,button:NumGet(A_EventInfo+12)})
		}else if(!button.runfile){
			func:=button.func
			if(IsFunc(func)&&!GetKeyState("Shift","P"))
				%func%()
			else if(IsLabel(func))
				SetTimer,%func%,-10
			else if(FileExist((plugin:=menus.SSN("//*[@clean='" func "']/@plugin").text))){
				info:=menus.EA("//*[@clean='" func "']")
				Run,% Chr(34) A_ScriptDir "\" info.plugin Chr(34) " " Chr(34) info.option Chr(34)
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
	while(ss:=sep.item[A_Index-1])
		ss.ParentNode.RemoveChild(ss)
	all:=SN(top,"descendant::button")
	while(aa:=all.item[A_Index-1])
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
	Keep:=[]
	__Get(x=""){
		return this.XML.xml
	}__New(Param*){
		if(!FileExist(A_ScriptDir "\Lib"))
			FileCreateDir,%A_ScriptDir%\Lib
		Root:=Param.1,File:=Param.2,File:=File?File:Root ".xml",New:=ComObjCreate("MSXML2.DOMDocument"),New.SetProperty("SelectionLanguage","XPath"),this.XML:=New,this.File:=File,XML.Keep[Root]:=this
		/*
			if(Param.3)
				New.PreserveWhiteSpace:=1
		*/
		if(FileExist(File)&&!Param.3){
			FileObj:=FileOpen(File,"R","UTF-8"),Info:=FileObj.Read(FileObj.Length),FileObj.Close(),this.XML.LoadXML(Info)
			if(!this.XML.XML&&Info){
				SplitPath,File,,,,NNE
				NewFile:=((Folder:=A_ScriptDir "\Lib\XML Backup\"  NNE) "\" NNE " " A_Now ".xml")
				if(!FileExist(Folder))
					FileCreateDir,%Folder%
				FileMove,%File%,%NewFile%
				this.XML:=ComObjCreate("MSXML2.DOMDocument"),this.XML.SetProperty("SelectionLanguage","XPath"),this.XML:=this.CreateElement(New,Root)
			}else
				New.LoadXML(Info),this.XML:=New
		}else
			this.XML:=this.CreateElement(New,Root)
		if(Param.3)
			this.XML.LoadXML(Param.3)
		this.OriginalText:=Info
		SplitPath,File,,dir
		if(!FileExist(dir))
			FileCreateDir,%dir%
	}Add(XPath,ATT:="",Text:="",Dup:=0){
		p:="/",Add:=(Next:=this.SSN("//" XPath))?1:0,Last:=SubStr(XPath,InStr(XPath,"/",0,0)+1)
		if(!Next.xml){
			Next:=this.SSN("//*")
			for a,b in StrSplit(XPath,"/")
				p.="/" b,Next:=(x:=this.SSN(p))?x:Next.AppendChild(this.XML.CreateElement(b))
		}if(Dup&&Add)
			Next:=Next.ParentNode.AppendChild(this.XML.CreateElement(Last))
		for a,b in ATT
			Next.SetAttribute(a,b)
		if(Text!="")
			Next.Text:=Text
		return Next
	}Clear(XPath){
		Node:=this.SSN(XPath),All:=SN(Node,"descendant::*")
		while(aa:=All.Item[A_Index-1])
			aa.ParentNode.RemoveChild(aa)
		return Node
	}CreateElement(Doc,Root){
		return Doc.AppendChild(this.XML.CreateElement(Root)).ParentNode
	}EA(XPath,Att:=""){
		List:=[]
		if(Att)
			return XPath.NodeName?SSN(XPath,"@" Att).Text:this.SSN(XPath "/@" Att).Text
		Nodes:=XPath.NodeName?XPath.SelectNodes("@*"):Nodes:=this.SN(XPath "/@*")
		while(nn:=Nodes.Item[A_Index-1])
			List[nn.NodeName]:=nn.Text
		return List
	}Find(Info*){
		static Last:=[]
		Doc:=Info.1.NodeName?Info.1:this.XML
		if(Info.1.NodeName)
			Node:=Info.2,Find:=Info.3,Return:=Info.4!=""?"SelectNodes":"SelectSingleNode",Search:=Info.4
		else
			Node:=Info.1,Find:=Info.2,Return:=Info.3!=""?"SelectNodes":"SelectSingleNode",Search:=Info.3
		if(InStr(Info.2,"descendant"))
			Last.1:=Info.1,Last.2:=Info.2,Last.3:=Info.3,Last.4:=Info.4
		if(InStr(Find,"'"))
			return Doc[Return](Node "[.=concat('" RegExReplace(Find,"'","'," Chr(34) "'" Chr(34) ",'") "')]/.." (Search?"/" Search:""))
		else
			return Doc[Return](Node "[.='" Find "']/.." (Search?"/" Search:""))
	}Get(XPath,Default){
		Text:=this.SSN(XPath).Text
		return Text?Text:Default
	}Lang(Info){
		this.XML.SetProperty("SelectionLanguage",(Info=""?"XPath":"XSLPattern"))
	}ReCreate(XPath,New){
		if(IsObject(XPath)){
			NodeName:=XPath.NodeName,Parent:=XPath.ParentNode,XPath.ParentNode.RemoveChild(XPath),New:=this.XML.Under(Parent,NodeName)
			if(Next:=XPath.NextSibling)
				Parent.InsertBefore(New,Next)
		}else{
			Rem:=this.SSN(XPath),Next:=Rem.NextSibling,Rem.ParentNode.RemoveChild(Rem),New:=this.Add(New)
			if(Next)
				New.ParentNode.InsertBefore(New,Next)
		}
		return New
	}Save(x*){
		if(x.1=1)
			this.Transform()
		FileName:=this.File?this.File:x.1.1,Text:=this.OriginalText
		if(!this[])
			return m("Error saving the " this.File " XML.  Please get in touch with maestrith if this happens often")
		if(InStr(this.File,"CEXML.xml")){
			All:=CEXML.SN("//*[@id]")
			while(aa:=All.Item[A_Index-1])
				aa.SetAttribute("id",A_Index)
		}else if(InStr(this.File,"gui.xml")){
			All:=this.SN("//win[@win=1]/descendant::*/@hwnd"),RepList:=[]
			while(aa:=All.Item[A_Index-1])
				RepList.Push(aa.Text)
			for a,b in RepList{
				All:=this.SN("//@node()[.='" b "']"),Index:=A_Index+1
				while(aa:=All.Item[A_Index-1]){
					aa.Text:=Index
					Total.=aa.xml "`n"
				}
			}
		}
		if(this[]~="\btv=\x22"){
			All:=this.SN("//*[@tv]")
			while(aa:=All.item[A_Index-1])
				aa.RemoveAttribute("tv")
		}
		if(text!=this[]){
			SplitPath,FileName,,,,NNE
			File:=((Folder:=A_ScriptDir "\Lib\XML Backup\"  NNE) "\" NNE " " A_Now ".xml")
			if(!FileExist(Folder))
				FileCreateDir,%Folder%
			FileMove,%FileName%,%File%
			File:=FileOpen(FileName,"W","UTF-8"),File.Write(this[]),File.Length(File.Position),File.Close()
		}else{
			/*
				if(InStr(this.File,"Settings.xml")||InStr(this.File,"CEXML.xml")){
					m("DIDN'T CHANGE!!!!: " this.File,SubStr(text,1,500),"","",SubStr(this[],1,500),"time:3")
				}
			*/
		}
	}SSN(XPath){
		return this.XML.SelectSingleNode(XPath)
	}SN(XPath){
		return this.XML.SelectNodes(XPath)
	}Transform(Loop:=1){
		static
		if(!IsObject(XSL))
			XSL:=ComObjCreate("MSXML2.DOMDocument"),XSL.LoadXML("<xsl:stylesheet version=""1.0"" xmlns:xsl=""http://www.w3.org/1999/XSL/Transform""><xsl:output method=""xml"" indent=""yes"" encoding=""UTF-8""/><xsl:template match=""@*|node()""><xsl:copy>`n<xsl:apply-templates select=""@*|node()""/><xsl:for-each select=""@*""><xsl:text></xsl:text></xsl:for-each></xsl:copy>`n</xsl:template>`n</xsl:stylesheet>"),Style:=null
		Loop,%Loop%
			this.XML.TransformNodeToObject(XSL,this.XML)
	}Under(Under,Node,att:="",text:="",list:=""){
		for a,b in Obj:=StrSplit(Node,"/"){
			if(a<Obj.MaxIndex()){
				if(!Next:=SSN(Under,b))
					Next:=this.XML.CreateElement(b)
				Under:=Under.AppendChild(Next)
			}else
				Under:=Under.AppendChild(this.XML.CreateElement(b))
		}
		if(Text)
			Under.text:=text
		for a,b in att
			Under.SetAttribute(a,b)
		for a,b in StrSplit(list,",")
			Under.SetAttribute(b,att[b])
		return Under
	}
}
SSN(Node,XPath){
	return Node.SelectSingleNode(XPath)
}
SN(Node,XPath){
	return Node.SelectNodes(XPath)
}
Clean_Position_Data(){
	All:=Positions.SN("//*"),Total:=0,Dups:=0,Remove:=[]
	while(aa:=All.Item[A_Index-1],ea:=XML.EA(aa)){
		if(!FileExist(ea.File)&&ea.File)
			aa.ParentNode.RemoveChild(aa),Total++
		for Key,Value in ["main","file"]{
			RemoveDup:=Positions.SN("//" Value "[@file='" ea.File "']")
			if(RemoveDup.Length>1)
				while(Dup:=RemoveDup.Item[A_Index])
					Remove[Dup]:=Dup,Dups+=1
		}
		Index:=A_Index
	}
	for a,b in Remove
		b.ParentNode.RemoveChild(b)
	Remove:=[]
	m("Removed: " Total " old position data","Removed: " Dups " duplicates")
}
Clean(Clean,tab=""){
	if(tab=1)
		return RegExReplace(Clean,"[^\w ]")
	if(tab=2)
		return RegExReplace(Clean,"_"," ")
	if(Tab=3)
		return RegExReplace(RegExReplace(Clean,"\s","-"),"[^a-zA-Z-_0-9]")
	Clean:=RegExReplace(RegExReplace(Clean,"&")," ","_")
	if(InStr(Clean,"`t"))
		Clean:=SubStr(Clean,1,InStr(Clean,"`t")-1)
	return Clean
}
Clear_History(){
	History.XML.XML.LoadXML("<History/>"),sc:=CSC(),History.Add(CEXML.EA("//*[@sc='" sc.2357 "']"),sc,1)
}
Clear_Line_Status(){
	LineStatus.Clear()
}
Clear_Selected_Highlight(){
	Selections:=[],sc:=CSC()
	Loop,% sc.2570
		Selections.Push({Start:sc.2585(A_Index-1),End:sc.2587(A_Index-1)})
	for a,b in Selections{
		Loop,10
			sc.2500(A_Index+8),sc.2505(b.Start,b.End-b.Start)
	}
	
}
Close_Debug_Window(){
	MainWin.NewCtrlPos:={ctrl:v.Debug.sc,win:HWND(1)},MainWin.Delete(),debug.Disconnect(),Redraw()
}
Close(x:=1,all:="",Redraw:=1){
	Parent:=Current(1),pea:=XML.EA(Parent),Nodes:=all?CEXML.SN("//main[@file!='Libraries']"):CEXML.SN("//main[@id='" pea.id "']")
	Loop,2
		TVC.Disable(A_Index)
	if(x.length)
		Nodes:=x
	Save(),Update:=Update("Get").1,RemoveFileList:=[]
	while(nn:=Nodes.item[A_Index-1]),pea:=XML.EA(nn){
		Fea:=XML.EA(SSN(nn,"descendant::file"))
		if(Fea.Dir=A_ScriptDir "\Untitled"&&SubStr(Fea.FileName,1,8)="Untitled"),Untitled:=0
			Untitled:=1
		RemoveFile:=nn.NodeName="main"?SSN(nn,"file/@file").text:pea.File,RemoveFileList.Push(RemoveFile)
		if((!Node:=Settings.Find("//previous_scripts/script/text()",pea.file))&&!Untitled)
			Node:=Settings.Add("previous_scripts/script",,pea.file,1)
		Top:=Settings.SSN("//previous_scripts/script")
		if(Top.xml!=Node.xml)
			Top.ParentNode.InsertBefore(Node,Top)
		all:=SN(nn,"descendant-or-self::*[@tv or @cetv]"),Store:=[]
		while(aa:=all.item[A_Index-1]),ea:=XML.EA(aa){
			if(ea.tv){
				if(!Store.1)
					Store.1:=ea.tv
				TVC.Delete(1,ea.tv)
			}if(ea.cetv){
				if(!Store.2)
					Store.2:=ea.cetv
				TVC.Delete(2,ea.cetv)
			}History.Remove(ea)
		}for a,b in Store
			TVC.Delete(a,b)
		rem:=Settings.Find("//open/file/text()",pea.file),rem.ParentNode.RemoveChild(rem)
		for a,b in [CEXML.SSN("//main[@id='" pea.id "']"),CEXML.SSN("//main[@id='" pea.id "']")]
			b.ParentNode.RemoveChild(b)
		if(Untitled)
			FileDelete,% Fea.File
	}for a,b in RemoveFileList{
		if(!CEXML.Find("//file/@file",b))
			if(Update.HasKey(b))
				Update.Delete(b)
	}TNotes.Populate()
	Loop,2
		TVC.Enable(A_Index)
	TVC.Default(1),TV_Modify(TV_GetChild(0),"Select Vis Focus")
	if(tv:=CEXML.SSN("//main[@file!='Libraries']/file/@tv").text)
		CSC({set:1}).2400(),tv(tv)
	else
		New()
}
Close_All(){
	Close(1,1)
}
CloseSingleUntitled(){
	count:=CEXML.SN("//main[@file!='Libraries']")
	if(count.length=1&&SSN(count.item[0],"@untitled").text){
		template:=GetTemplate(),text:=Update({get:(SSN(count.item[0],"@file").text)})
		if(template=text)
			CloseID:=SSN(count.item[0],"descendant::*/@id").text
	}
	return CloseID
}
Color(con:="",Language:="",FromFunc:=""){
	/*
		m(Language)
	*/
	static Options:={Show_EOL:2356,Show_Caret_Line:2096},list:={Font:2056,Size:2055,Color:2051,Background:2052,Bold:2053,Italic:2054,Underline:2059},kwind:={Personal:0,indent:1,Directives:2,Commands:3,builtin:4,keywords:5,functions:6,flow:7,KeyNames:8}
	con:=con?con:v.con,con.Enable()
	if(!con.sc)
		return v.con:=""
	ConBackup:=con,OldPath:="//fonts"
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
	while(nn:=nodes.item(A_Index-1),ea:=Settings.EA(nn)){
		if(nn.NodeName="indentguide"){
			con.2051(37,ea.color)
			Continue
		}else if(nn.NodeName="caret"){
			for a,b in {2069:ea.Color,2098:ea.LineBack,2188:ea.Width}
				con[a](b)
			Continue
		}else if(nn.NodeName~="i)(default|bracematch)")
			Continue
		for a,b in ["bold","italic","underline"]
			con[list[b]](ea.style,0)
		if(ea.code=2082){
			con.2082(7,ea.color),con.2498(1,7)
			Continue
		}if(nn.NodeName="linenumbers"){
			for a,b in [2290,2291]
				con[b](1,(Background:=ea.Background?ea.Background:Default.Background))
			con.2052(33,Background),ea.style:=33
		}if(ea.style=""){
			if(nn.NodeName!="keyword")
				ea.style:=MainXML.SSN("//Styles/" nn.NodeName "/@style").text
			else
				ea.style:=MainXML.SSN("//Styles/descendant::*[@set='" ea.set "']/@style").text
			if(ea.style=34)
				con.2498(0,7)
			if(nn.NodeName="linenumbers")
				m(ea.style,nn.xml)
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
	}for a,b in Options
		if(v.Options[a])
			con[b](b)
	if(node:=Settings.SSN("//theme/fold")){
		ea:=XML.EA(node)
		Loop,7
			con.2041(24+A_Index,ea.color!=""?ea.color:"0"),con.2042(24+A_Index,ea.background!=""?ea.Background:"0xAAAAAA")
	}con.2680(3,6),con.2242(4,1),con.2240(4,5),con.2110(1)
	for a,b in [[2051,151,Settings.Get("//debug/continuecolor",0xFF8080)],[2523,6,Settings.Get("//DuplicateIndicator/@trans",50)],[2558,6,Settings.Get("//DuplicateIndicator/@bordertrans",50)],[2051,35,0xff00ff],[2080,2,8],[2080,3,14],[2080,6,Settings.Get("//DuplicateIndicator/@style",14)],[2080,7,6],[2080,8,1],[2082,2,0xff00ff],[2082,6,Settings.Get("//DuplicateIndicator/@color",0xC08080)],[2082,8,0xff00ff],[2212,5],[2371,0],[2373,Settings.Get("//gui/@zoom",0)],[2458,2],[2516,1],[2636,1],[2680,3,6]]
		con[b.1](b.2,b.3)
	if(!v.Options.Match_Any_Word)
		con.2198(0x2)
	if(debug.socket)
		debug.Caret(1)
	Lexer:=con.4002(),con.4001(0),con.4001(Lexer)
	for a,b in {20:Settings.Get("//theme/editedmarkers/@edited",0x0000ff),21:Settings.Get("//theme/editedmarkers/@saved",0x00ff00)}
		con.2040(a,27),con.2042(a,b)
	con.4004("fold",[1]),MarginWidth(con)
	
	All:=Settings.SN("//Highlight/Color")
	while(aa:=All.Item[A_Index-1],ea:=XML.EA(aa)){
		con.2082(ea.Index+8,ea.Color),con.2080(ea.Index+8,7),con.2523(ea.Index+8,100)
	}
	/*
		con.2082(9,0xff00ff)
		con.2080(9,7)
		con.2523(9,100)
	*/
	
	Keywords.BuildList(Language)
	for a,b in Keywords.GetList(Language)
		con.4005(a,b)
	return con.Enable(1)
}
Combine(Atts,Found){
	Loop,% Found.Count(){
		if(Name:=Found.Name(A_Index))
			if(Value:=Found[Name])
				Atts[Format("{:L}",Name)]:=Value
	}return Atts
}
Command_Help(){
	static stuff,Last,hwnd,ifurl:={between:"commands/IfBetween.htm",in:"commands/IfIn.htm",contains:"commands/IfIn.htm",is:"commands/IfIs.htm"}
	if((Language:=Current(3).Lang)!="ahk")
		return m("Sorry but I can only help with AutoHotkey at the moment")
	RegRead,outdir,HKEY_LOCAL_MACHINE,SOFTWARE\AutoHotkey,InstallDir
	if(!outdir)
		SplitPath,A_AhkPath,,outdir
	CurrentWord:=sc.GetWord()
	sc:=CSC(),info:=Context(1),line:=sc.GetLine((LineNo:=sc.2166(sc.2008))),found1:=info.word
	if(word:=sc.GetSelText())
		found1:=word
	if(!found1)
		RegExMatch(line,"[\s+]?(\w+)",found)
	xx:=Keywords.GetXML(Language)
	CommandHelpLoop:
	Base:=url:="mk:@MSITStore:" outdir "/AutoHotkey.chm::/docs/"
	if(Text:=xx.SSN("//*[contains(translate(text(),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'" Format("{:L}",Found1) "')]").text){
		RegExMatch(Text,"Oi)(" Found1 ")",Find)
		if(Find.1)
			FoundWord:=Find.1
	}if(RegExMatch(line,"O)^;*\s*;*#(\w*)",found))
		OpenHelpFile("mk:@MSITStore:C:\Program%20Files\AutoHotkey\AutoHotkey.chm::/docs/commands/_" found.1 ".htm")
	else if(RegExMatch(CurrentWord,"Oi)A_(\w*)",found))
		OpenHelpFile(url "Variables.htm#" found.1)
	else if(found1~="i)\b(loop|gui)\b")
		OpenHelpFile(url "commands/" found1 ".htm")
	else if(FoundWord){
		found1:=FoundWord
		if(RegExMatch(found1,"i)Set(Caps|Num|Scroll)LockState"))
			url.="commands/SetNumScrollCapsLockState.htm"
		else if(found1~="i)\b(FileExist|GetKeyState|InStr|SubStr|StrLen|StrSplit|WinActive|WinExist|Asc|Chr|GetKeyName|IsByRef|IsFunc|IsLabel|IsObject|NumGet|NumPut|StrGet|StrPut|RegisterCallback|Trim|Abs|Ceil|Exp|Floor|Log|Ln|Mod|Round|Sqrt|Sin|ASin|ACos|ATan)\b"){
			url.="Functions.htm#" found1
		}else if(found1~="i)^if"){
			if(found1~="i)\b(IfEqual|IfNotEqual|IfLess|IfLessOrEqual|IfGreater|IfGreaterOrEqual)\b")
				url.="commands/IfEqual.htm"
			else if(Found1~="i)\b(IfExist|IfNotExist)\b")
				url.="commands/IfExist.htm"
			else if(Found1~="i)\b(IfInString|IfNotInString)\b")
				url.="commands/IfInString.htm"
			else if(Found1~="\b(IfWinActive|IfWinNotActive)\b")
				url.="commands/WinActive.htm"
			else if(Found1~="\b(IfWinExist|IfWinNotExist)\b")
				url.="commands/WinExist.htm"
			else if(Found1~="i)\b(IfMsgBox)\b")
				url.="commands/" Found1 ".htm"
			else
				url.=ifurl[info.last]?ifurl[info.last]:"commands/IfExpression.htm"
		}else{
			url.="commands/" found1:=RegExReplace(found1,"#","_") ".htm"
		}
	}
	else{
		if(!Settings.SSN("//HelpNag").text)
			if(m("The word: " Chr(34) found1 Chr(34) " was found and was not handled by AHK Studio.","If this is a command please let maestrith know.","btn:ync","Opening the help file","","Show again?")="No")
				Settings.Add("HelpNag",,1)
		OpenHelpFile("mk:@MSITStore:C:\Program%20Files%20(x86)\AutoHotkey\AutoHotkey.chm::/docs/AutoHotkey.htm")
	}OpenHelpFile(url)
	while(Stuff:=GetWebBrowser()){
		if(A_Index=10)
			Break
		Sleep,50
	}if(InStr(stuff.document.body.innerhtml,"//ieframe.dll/dnserrordiagoff.htm#")){
		if(Last){
			Last:=""
			return Stuff.Navigate("mk:@MSITStore:D:\Program%20Files\AutoHotkey\AutoHotkey.chm::/docs/AutoHotkey.htm")
		}url.="Functions.htm#" found1
		if(found1="object")
			url.="Objects.htm#Usage_Associative_Arrays"
		else if(found1="_ltrim")
			url.="Scripts.htm#LTrim"
		else
			url.="Functions.htm#" found1
		Last:=1,OpenHelpFile(url),RegExMatch(Line,"OU)^\s*\b(\w+)\b",fff),Found1:=fff.1
		Goto,CommandHelpLoop
	}Last:=""
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
Compile_Using_U32(){
	CompileUsing(32)
}Compile_Using_U64(){
	CompileUsing(64)
}
CompileUsing(Version){
	Save()
	main:=Current(2).file
	SplitPath,main,,dir,,name
	SplitPath,A_AhkPath,file,dirr
	Loop,%dirr%\Ahk2Exe.exe,1,1
		file:=A_LoopFileFullPath
	SplashTextOn,200,100,Compiling,Please wait.
	Loop,%dir%\*.ico
	{
		icon:=A_LoopFileFullPath
		Break
	}
	if(icon)
		add=/icon "%icon%"
	RunWait,%file% /in "%main%" /out "%dir%\%name%.exe" %add% /bin "%dirr%\Compiler\Unicode %Version%-bit.bin"
	If(FileExist("upx.exe")){
		SplashTextOn,,50,Compressing EXE,Please wait...
		RunWait,upx.exe -9 "%dir%\%name%.exe",,Hide
	}
	SplashTextOff
	Run,%dir%
}
Compile(Main=""){
	Main:=SSN(Current(1),"@file").Text,v.Compiling:=1
	SplitPath,Main,,dir,,name
	RegRead,dirr,HKLM,Software\AutoHotkey,InstallDir
	if(ErrorLevel||dirr="")
		SplitPath,A_AhkPath,,dirr
	Loop,%dirr%\Compile_AHK.exe,1,1
		compile:=A_LoopFileFullPath
	if(FileExist(compile)&&v.Options.Disable_Compile_AHK!=1){
		Run:=Current(2).File
		Run,%compile% "%Run%"
		return
	}
	Loop,%dirr%\Ahk2Exe.exe,1,1
		File:=A_LoopFileFullPath
	if(!FileExist(A_ScriptDir "\temp"))
		FileCreateDir,%A_ScriptDir%\temp
	FileDelete,%A_ScriptDir%\temp\temp.upload
	FileAppend,% Publish(1),%A_ScriptDir%\temp\temp.upload
	SplashTextOn,200,100,Compiling,Please wait.
	if(!FileExist((Icon:=dir "\" name ".ico"))){
		Loop,%dir%\*.ico
		{
			Icon:=A_LoopFileFullPath
			Break
		}
		Icon:=FileExist(Icon)?Icon:""
	}if(Icon)
		add=/Icon "%Icon%"
	RunWait,%File% /in "%Main%" /out "%dir%\%name%.exe" %add%
	if(FileExist("upx.exe")){
		SplashTextOn,,50,Compressing EXE,Please wait...
		RunWait,upx.exe -9 "%dir%\%name%.exe" ;,,Hide
	}FileDelete,temp\temp.upload
	SplashTextOff
	v.Compiling:=0
}
CompileFont(XMLObject,RGB:=1){
	ea:=XML.EA(XMLObject),style:=[],name:=ea.name,styletext:="norm",Default:=Settings.EA("//theme/default")
	for a,b in ea
		Default[a]:=b
	for a,b in {bold:"",color:"c",italic:"",size:"s",strikeout:"",underline:""}{
		Value:=Trim(Default[a])
		if(a="color"&&Value!=""&&Value!=0)
			styletext.=" c" (RGB?RGB(Value):Value)
		else if(Value!=""&&Value!=0)
			styletext.=" " (b?b Value:a)
	}return styletext
}
Context(return=""){
	static FindFirst:="O)^[\s|}]*((\w|[^\x00-\x7F])+)",ColorShow:=0
	if(v.ShowTT)
		t("It is getting here","time:1",v.ShowTT.="Context,")
	ControlGetFocus,Focus,% HWND([1])
	if(!InStr(Focus,"Scintilla"))
		return
	Tick:=A_TickCount,sc:=CSC(),cp:=sc.2008,Line:=sc.2166(cp),LineIndent:=Start:=sc.2128(Line)
	SetWords(3),ColorCode:=sc.GetWord(cp),SetWords()
	if(SubStr(ColorCode,1,1)="#"||SubStr(ColorCode,1,2)="0x")
		Code:=SubStr(ColorCode,1,1)="#"?SubStr(ColorCode,2):SubStr(ColorCode,1,2)="0x"?SubStr(ColorCode,3):""
	if(Code){
		if(!Code)
			return
		Start:=End:=cp,ColorShow:=1
		if(sc.2202)
			sc.2201
		return sc.2207(RGB("0x" Code)),sc.2200(Start,"Color: " ColorCode),sc.2204(7,7+StrLen("0x" Code)),sc.2205(0)
	}if(ColorShow)
		ColorShow:=0,sc.2206(0xAAAAAA),sc.2205(0xFFFFFF)
	if(cp<=LineIndent)
		return sc.2201
	PFL:=sc.2167(Line),OLineText:=LineText:=sc.GetLine(Line),NewString:=Trim(SubStr(LineText,1,cp-PFL) Chr(127) SubStr(LineText,cp-PFL+1)),Language:=Current(3).Lang,Delimiter:=Keywords.Delimiter[Language]
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
			while(Pos:=RegExMatch(NewString,Regex,Found)){
				if(Pos=LastPos),LastPos:=Pos
					Break
				StringReplace,NewString,NewString,% Found.0,% (InStr(Found.0,Chr(127))?Chr(127):"")
		}}if(Regex:=Delimiter.Preserve){
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
			}Process:=SubStr(NewString,Pos),Total.=LastCondition="Preserve"?Process:RegExReplace(Process,Delimiter.Delimiter),NewString:=Total
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
			}if(!Word&&Pos>0){
				Pos--
				Continue
			}
			String:=SubStr(String,(Pos=1?1:Pos+1)),PositionInString:=Pos
			Break
		}Pos--
	}
	if(!Word)
		if(RegExMatch(String,FindFirst,Found))
			Word:=Found.1
	if(!Word)
		return SetStatus("Context Stopped @ " A_Now A_MSec)
	if(Return)
		return {word:word,last:last}
	Matches:=[],Split:=[]
	if(Pos>1){
		String2:=SubStr(Trim(LineText),1,Pos)
		Pos1:=Pos
		while((Pos1--)>0){
			Letter:=SubStr(String2,Pos1,1)
			if(Letter~="(\s|\W)")
				Break
			dorW:=Letter dorW
		}for a,b in Keywords.Special[Language]{
			if(b.this=dorW){
				Search:=RegExReplace(b.to,"\$word",Upper(Word))
				Replace:=b.Replace
				if(Value:=SSN(Node:=SSN(Current(7),Search),"descendant::*[@type='" b.RepType "' and @upper='" b.Upper "']")){
					for c,d in {Found:dorW,Word:Word,Value:SSN(Value,"@att").text}
						Replace:=RegExReplace(Replace,"\$" c,d)
					Replace:=RegExReplace(Replace," ","_"),Matches.Push({att:Value,ea:XML.EA(SSN(Node,"descendant::*[@type='" b.Type "']")),search:RegExReplace(Replace,"\$Syntax"),syntax:RegExReplace(Replace,"(.*\$Syntax)"),type:b.Type,file:SSN(Node,"ancestor::file/@filename").text})
	}}}}if(Matches.1){
	}else if((ea:=scintilla.EA("//scintilla/commands/item[@code='" StrSplit(word,".").Pop() "']")).syntax){
		Syntax:=ea.Syntax "`n" ea.Name,Matches.Push({att:Syntax,ea:ea,search:Syntax,Syntax:Word Syntax,Type:"Scintilla"}),Split["."]:=1
	}else{
		Omni:=GetOmni(Language)
		for a,b in Omni{
			if(InStr(Word,b.Delimiter)&&b.Delimiter){
				Obj:=StrSplit(Word,b.Delimiter),Max:=Obj.MaxIndex(),Pre:=SSN(Current(7),"descendant::*[@type='" a "' and @upper='" Upper(Obj[Max-1]) "']"),Parent:=SSN(Current(7),"descendant::*[@type='" b.Associate "' and @upper='" Upper(SSN(Pre,"@" Format("{:L}",b.Associate)).text) "']"),Node:=SSN(Parent,"descendant::*[@type='" b.Add "' and @upper='" Upper(Obj[Max]) "']"),Syntax:="(" (Things:=SSN(Node,"@att").text) ")"
				if(Node.NodeName)
					FoundThings:=1,Matches.Push({att:Syntax,ea:XML.EA(Node),search:Syntax,syntax:Word Syntax,type:a,file:SSN(Node,"ancestor::file/@filename").text}),Split[b.Delimiter]:=1
		}}if(!FoundThings){
			Index:=1,Syntax:="",List:=[],Reverse:=[]
			for a,all in [SN(Current(7),"descendant::*[@upper='" Upper(Word) "']"),CEXML.SN("//Libraries/descendant::*[@upper='" Upper(Word) "']")]{
				while(aa:=all.item[A_Index-1],ea:=XML.EA(aa)){
					if(WordSplit:=Omni[ea.Type].WordSplit)
						if(!InStr(Word,WordSplit))
							Continue
					Matches.Push({att:ea.att,ea:ea,syntax:Word (ea.att?"(" ea.att ")":""),type:ea.type,file:SSN(aa,"ancestor::file/@filename").text})
			}}RegExMatch(Word,"O)(\W)",Delim)
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
				Del:=(DD:=SSN(Top,"@delimiter").text)?DD:Delimiter.Delimiter,list:=SN(top,"list"),Build:=WW Del,Pos:=LastPos:=1,SearchWord:=WW
				while(RegExMatch(String,"OUi)\b(" RegExReplace(SSN(Top,"*[text()='" SearchWord "']/@list").text," ","|") ")\b",Found,Pos),Pos:=Found.Pos(1)+Found.Len(1)){
					if(Pos=LastPos),LastPos:=Pos
						Break
					Build.=Found.1 Del,SearchWord:=Found.1
				}Pos:=LastPos:=1
				while(RegExMatch(Build,"O)(\w+)",Found,Pos),Pos:=Found.Pos(1)+Found.Len(1)){
					LastWord:=Found.1
					if(Pos=LastPos),LastPos:=Pos
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
				if(b~="\w+\b\*\W*$"){
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
	sc:=CSC(),SetupEnter()
	for a,b in ["RCM","toolbars"]
		Menu,%b%,DeleteAll
	ctrl:=MainWin.NewCtrlPos.ctrl
	MouseGetPos,,,win,ctrl,2
	parent:=DllCall("GetParent",ptr,ctrl)
	if(ctrl+0=MainWin.tnsc.sc)
		Node:=MainWin.Gui.SSN("//*[@type='Tracked Notes']")
	else if(!Node:=MainWin.Gui.SSN("//*[@hwnd='" ctrl+0 "']")){
		if(!Node:=MainWin.Gui.SSN("//*[@toolbar='" ctrl+0 "']")){
			xx:=MainWin.Gui
			Menu,RCM,Add,% "Move to " (Settings.SSN("//options/@Top_Find").text?"Bottom":"Top"),MoveFind
			Menu,RCM,Show
			Menu,RCM,DeleteAll
			return
			MoveFind:
			Options("Top_Find")
			return
	}}ONode:=Node,oea:=XML.EA(ONode)
	if(InStr(Node.ParentNode.xml,"Tracked_Notes"))
		Node:=RCMXML.SSN("//main[@name='Tracked Notes']"),type:="Tracked Notes"
	else
		Node:=RCMXML.SSN("//main[@name='" (type:=SSN(Node,"@type").text) "']")
	if(oea.type="Project Explorer"){
		MouseClick,Left
		current:=Current(3).file
		SplitPath,current,filename
		Menu,RCM,Add,%filename%,deadend
		Menu,RCM,Add
		Menu,RCM,Disable,%filename%
	}all:=SN(Node,"descendant::*"),track:=[],count:=MainWin.Gui.SN("//win[@win=1]/descendant::control[@type='Scintilla']").length
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
			if(((code:=UnRedo[ea.name])&&!sc[code])||(sc.2008=sc.2009&&(ea.name="Copy"||ea.name="Cut"||ea.name="Delete"))||Clipboard=""&&ea.name="Paste"||sc.2143=0&&sc.2145=sc.2006&&ea.name="Select All"||(ea.name="Open Folder"&&Current(2).untitled||!Current(2).file))
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
			Kill:="ahk_id" ID
			Break
		}else{
			for a,b in v.Running{
				WinGet,PID,PID,% "ahk_pid" b.ProcessID
				if(PID,b.ProcessID){
					Menu,RCM,Add,Kill Current Script,KillCurrentScript
					Kill:=b
					Break,2
	}}}}ControlFocus,,% "ahk_id" CSC().sc
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
	if(IsObject(Kill))
		Kill.Terminate()
	else
		PostMessage,0x111,65405,0,,%Kill%
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
	Clean:=Clean(A_ThisMenuItem)
	if(IsLabel(clean)||IsFunc(clean))
		SetTimer,%clean%,-1
	else if(v.Options.HasKey(clean))
		Options(clean)
	else if(A_ThisMenuItem="Close Debug Window")
		MainWin.Delete(),debug.Disconnect(),Redraw()
	else if(A_ThisMenuItem="Switch Orientation"){
		ea:=XML.EA(Node:=MainWin.Gui.SSN("//win[@win=1]/descendant::*[@type='Tracked Notes']"))
		if(ea.vertical)
			Node.RemoveAttribute("vertical")
		else
			Node.SetAttribute("vertical",1)
		MainWin.Size(1),Redraw()
	}else if(A_ThisMenuItem="Edit Toolbar"){
		Toolbar_Editor(MainWin.Gui.SSN("//*[@hwnd='" MainWin.NewCtrlPos.ctrl "']"))
	}else if(A_ThisMenuItem="Track File"){
		TNotes.Track()
	}else if(RegExMatch(A_ThisMenuItem,"iO)Copy (.*) Path",found)){
		if(found.1="File")
			Clipboard:=Current(3).file
		if(found.1="Folder")
			Clipboard:=Current(3).dir
	}else if(A_ThisMenuItem="Close Project")
		Close()
	else if(A_ThisMenuItem="Backup Notes"){
		if(!FileExist((Folder:=A_ScriptDir "\Lib\Tracked Notes Backups")))
			FileCreateDir,%Folder%
		FileAppend,% TNotes.XML[],%Folder%\Tracked Notes %A_Now%.xml
	}else if(A_ThisMenuItem="Remove Tracked File"){
		RemoveTrackedFile()
	}else if(A_ThisMenuItem="Contract All"){
		MainWin.tnsc.2662(0)
	}else if(A_ThisMenuItem="Expand All"){
		MainWin.tnsc.2662(1)
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
	}else if(A_ThisMenuItem="Add Folder"){
		NewFolder:=RegExReplace(InputBox(HWND(1),"New Folder","Enter the name of the Folder you wish to add (all [^a-zA-Z0-9 \(\)] will be removed)"),"([^a-zA-Z0-9 \(\)])")
		if(!NewFolder)
			return
		TNotes.XML.Transform(2)
		Node:=TNotes.XML.SSN("//*[@tv='" TVC.Selection(3) "']"),Text:=""
		if(!SSN(Node,"*"))
			Text:=Node.Text,Node.Text:=""
		New:=TNotes.XML.Under(Node,"file",{name:NewFolder,last:1},Text),TNotes.Populate(),TNotes.SetText()
		return
	}else if(A_ThisMenuItem="Select All")
		Send,^a
	else if(Clean="Open_Folder")
		Show_Folder_In_Explorer()
	else
		m("Coming soon:",A_ThisMenu,A_ThisMenuItem)
	ControlFocus,,% "ahk_id" CSC().sc
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
Copy_Folder_Path(){
	Clipboard:=Current(3).Dir
}
Copy_File_Path(){
	Clipboard:=Current(3).File
}
Copy(){
	ControlGetFocus,Focus,% HWND([1])
	ControlGet,hwnd,hwnd,,%Focus%,% HWND([1])
	sc:=CSC()
	if(sc.sc!=hwnd){
		SendMessage,0x301,0,0,%Focus%,% HWND([1])
		return
	}CSC().2178(),Clipboard:=RegExReplace(Clipboard,"\R","`r`n")
}
Create_Comment(){
	static
	if(!CommentChar:=Settings.SSN("//comment").text)
		CommentChar:=KeyWords.GetXML((Lang:=Current(3).Lang)).SSN("//Comments/@Single").text
	NewWin:=new GuiKeep("Create_Comment"),sc:=CSC(),IndentWidth:=Settings.Get("//tab",5)
	NewWin.Add("Text,,Comment","Edit,w500 h200 vComment -Wrap","Text,,Comment Width","Edit,w500 vWidth,100","Text,,Fill Character","Edit,w500 vFill,-","Button,gCreateComment,Create C&omment","Button,x+M gDeleteSelectedComment,&Replace Selected Comment"),NewWin.Show("Create Comment")
	for a,b in Obj:=Settings.EA("//Create_Comment")
		NewWin.SetValue(a,b)
	if(Text:=sc.GetSelText()){
		Text:=RegExReplace(Text,"\Q" Obj.Fill "\E"),Text:=RegExReplace(Text,"\Q" CommentChar "\E"),AddText:=""
		for a,b in StrSplit(Text,"`n")
			if(NewLine:=Trim(b))
				AddText.=NewLine "`r`n"
		NewWin.SetValue("Comment",Trim(AddText,"`r`n"))
	}else
		GuiControl,Create_Comment:Hide,% NewWin.XML.SSN("//*[@label='DeleteSelectedComment']/@hwnd").text
	return
	DeleteSelectedComment:
	if(sc.2008!=sc.2009)
		sc.2326()
	CreateComment:
	Values:=NewWin[],Comment:=Values.Comment,Fill:=Values.Fill,Indent:=sc.2127(sc.2166(sc.2008)),Width:=Values.Width,AddTabs:=Floor(Indent/IndentWidth)
	if(!Comment){
		Total:=CommentChar
		Loop,% Width-StrLen(Comment)
			Total.=Fill
		return sc.2003(sc.2008,Total),sc.2025(sc.2008+StrPut(Total,"UTF-8")-1),NewWin.Exit()
	}Max:=[]
	for a,b in StrSplit(Comment,"`n")
		Max[StrLen(b)+2]:=1
	Max:=Mod(Max.MaxIndex(),2)?Max.MaxIndex()+1:Max.MaxIndex(),Width:=Max>Width?Max+20:Width,RegExReplace(Comment,"\R",,Count)
	if(Count=0){
		Total:=CommentChar
		Loop,% ((Width-StrLen(Comment)-StrLen(CommentChar))/2)
			Total.=Fill
		Total.=" " Comment " "
		Loop,% Width-StrLen(Total)
			Total.=Fill
		Total.="`n"
		Loop,%AddTabs%
			Total.="`t"
		sc.2003(sc.2008,Total),sc.2025(sc.2008+StrPut(Total,"UTF-8")-1)
	}else{
		Total:=CommentChar
		Loop,% Width-StrLen(CommentChar)
			Total.=Fill
		Total.="`n"
		Loop,%AddTabs%
			Total.="`t"
		for a,b in StrSplit(Comment,"`n"){
			LineWidth:=Width-StrLen(CommentChar),CurrentLine:=CommentChar
			Loop,% Floor((LineWidth-Max)/2)
				CurrentLine.=Fill
			Loop,% Floor((Max-(Mod(StrLen(b),2)?StrLen(b)+1:StrLen(b)))/2)
				CurrentLine.=" "
			CurrentLine.=b
			Loop,% Ceil((Max-(Mod(StrLen(b),2)?StrLen(b)-1:StrLen(b)))/2)
				CurrentLine.=" "
			Loop,% Width-StrLen(CurrentLine)
				CurrentLine.=Fill
			Total.=CurrentLine,Total.="`n"
			Loop,%AddTabs%
				Total.="`t"
		}Total.=CommentChar
		Loop,% Width-StrLen(CommentChar)
			Total.=Fill
		Total.="`n"
		Loop,%AddTabs%
			Total.="`t"
		sc.2003(sc.2008,Total),sc.2025(sc.2008+StrPut(Total,"UTF-8")-1)
	}
	if(A_ThisLabel="DeleteSelectedComment")
		NewWin.Close()
	return
	Create_CommentClose:
	Create_CommentEscape:
	Node:=Settings.Add("Create_Comment")
	for a,b in NewWin[]
		if(a!="Comment")
			Node.SetAttribute(a,b)
	NewWin.Exit()
	return
}
Create_Function_From_Selected(){
	sc:=CSC(),Start:=sc.2167((Line:=sc.2166(sc.2143))),End:=sc.2136(sc.2166(sc.2145)),Text:=sc.TextRange(Start,End)
	if(Start=End){
		m("Select some text first")
		ExitApp
	}sc.2160(Start,End),Indent:=Settings.Get("//tab",5),Width:=sc.2127(Line)
	Add:=Floor(Width/Indent)
	Function:=InputBox(sc.sc,"Enter Function Name","Enter the name of the function you want to create")
	if(ErrorLevel||!Function)
		return
	Loop,%Add%
		Total.="`t"
	Total.=Function "(){`n"
	for a,b in StrSplit(Text,"`n"){
		Total.="`t" b "`n"
	}Loop,%Add%
		Total.="`t"
	Total.="}`n"
	Loop,%Add%
		Total.="`t"
	Encode(Total,return),CSC().2170(0,&return),sc.2025(sc.2128(Line)+StrPut(Function,"UTF-8"))
	SetTimer("CFFSFocus","-100")
	return
	CFFSFocus:
	WinActivate,% HWND([1])
	sc.2400()
	return
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
CSC(set:=0){
	static Current,last
	if(!Set&&!Current)
		return Current:=s.ctrl[s.MinIndex()]
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
		WinSetTitle(1,ea:=CEXML.EA("//*[@sc='" Current.2357 "']"))
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
	Node:=CEXML.SSN("//*[@tv='" TVC.Selection(1) "']"),id:=SSN(Node,"@id").text,ParentNode:=SSN(Node,"ancestor-or-self::main"),pid:=SSN(ParentNode,"@id").text
	if(Parent=1)
		return ParentNode
	else if(Parent=2)
		return XML.EA(ParentNode)
	else if(Parent=3)
		return XML.EA(Node)
	else if(Parent=4)
		return SSN(Node,"ancestor-or-self::main/file")
	else if(Parent=5)
		return CEXML.SSN("//main[@id='" pid "']/descendant::file[@id='" id "']")
	else if(Parent=6)
		return CEXML.EA("//main[@id='" pid "']/descendant::file[@id='" id "']")
	else if(Parent=7)
		return SSN(CEXML.SSN("//main[@id='" pid "']/descendant::file[@id='" id "']"),"ancestor-or-self::main")
	else if(Parent=8)
		return id
	else if(Parent=9)
		return SSN(CEXML.SSN("//main[@id='" pid "']/descendant::file[@id='" id "']"),"ancestor::main/@id").text
	return Node
}
Custom_Indent(){
	static
	NewWin:=new GUIKeep("Custom_Indent"),Language:=Current(3).Lang
	NewWin.Add("ListView,w200 h300,Indent Word,wh","Edit,w200 vIndent,,wy","Button,gAddIndentWord Default,&Add Word,y","Button,gDeleteIndentWord,&Delete Selected,y","Button,gAddIndentDefault,Restore Defaults,y"),NewWin.Show("Custom Indent")
	Goto,CIPopulate
	return
	CIPopulate:
	Default("SysListView321","Custom_Indent")
	LV_Delete()
	for a,b in StrSplit(Keywords.IndentRegex[Language],"|")
		LV_Add("",b)
	return
	AddIndentDefault:
	Lang:=Keywords.GetXML(Language),Keywords.IndentRegex[Language]:=RegExReplace(Lang.SSN("//Indent").text," ","|")
	Goto,CIPopulate
	return
	AddIndentWord:
	Default("SysListView321","Custom_Indent")
	if(!Indent:=NewWin[].Indent)
		return m("Add a word in the edit box to add to the list")
	LV_Add("",Indent)
	GuiControl,Custom_Indent:,Edit1
	return
	DeleteIndentWord:
	Default("SysListView321","Custom_Indent")
	while(Next:=LV_GetNext())
		LV_Delete(Next)
	return
	Custom_IndentEscape:
	Custom_IndentClose:
	Default("SysListView321","Custom_Indent")
	Next:=0,Total:=""
	Loop,% LV_GetCount(){
		LV_GetText(Item,A_Index)
		Total.=Item "|"
	}if(!Node:=Settings.SSN("//CustomIndent/Language[@language='" Language "']"))
		Node:=Settings.Add("CustomIndent/Language",{language:Language},,1)
	Keywords.IndentRegex[Language]:=Node.Text:=Trim(Total,"|"),NewWin.Exit()
	return
}
Custom_Version(){
	change:=Settings.SSN("//auto_version").text?Settings.SSN("//auto_version").text:"Version:=" Chr(34) "$v" Chr(34),cc:=InputBox(CSC().sc,"Custom auto_version","Enter your custom" Chr(59) "auto_version in the form of Version:=$v",change)
	if(cc)
		Settings.Add("auto_version").text:=cc
}
Cut(){
	;ControlGetFocus,Focus,% HWND([1])
	;SendMessage,0x300,0,0,%Focus%,% HWND([1])
	SendMessage,0x300,0,0,,% "ahk_id" CSC().sc
	Update({sc:sc.2357}),Edited()
	if(v.Options.Clipboard_History){
		for a,b in v.Clipboard
			if(b=Clipboard)
				return
		v.Clipboard.push(Clipboard)
}}
DebugHighlight(){
	sc:=CSC(),sc.2045(2),sc.2045(3)
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
	sc:=CSC()
	if(v.Options.Select_Current_Debug_Line)
		sc.2160(sc.2167(line),sc.2136(line))
	else
		first:=sc.2152,lines:=sc.2370,half:=Floor(lines/2),NewLine:=((((line)-half)>0)?(line)-half:0),sc.2613(NewLine)
}
Default_Project_Folder(){
	Dir:=Settings.SSN("//directory").text
	if(!FileExist(Dir)||!Dir){
		Dir:=A_ScriptDir "\Projects"
		if(!FileExist(Dir))
			FileCreateDir,%Dir%
	}
	FileSelectFolder,directory,% "*" Dir,3,% "Current Default Folder: " Settings.SSN("//directory").text
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
DefaultRCM(Return:=0){
	static All:={Scintilla:"Undo,Redo,Copy,Cut,Paste,Select All,Close,Delete,Open,Open Folder,Omni Search"
		    ,"Tracked Notes":"Track File,Add Folder,Backup Notes,Contract All,Expand All,Switch Orientation,Remove Tracked File"
		    ,"Project Explorer":"New,Close,Open,Rename Current Include,Remove Include,Copy File Path,Copy Folder Path,Open Folder,Hide/Show Icons,File Icon,Folder Icon,Hide/Show File Extensions,Refresh Project Explorer"
		    ,"Code Explorer":"Refresh Code Explorer,Collapse All"
		    ,Toolbar:"Small Icons"
		    ,Debug:"Close Debug Window"}
	if(Return)
		Return All
	if(RCMXML.SSN("//main"))
		return
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
	sc:=CSC(),line:=sc.2166(sc.2008),pos:=sc.2128(line),diff:=sc.2008-pos,sc.2338(),start:=sc.2128(line),end:=sc.2136(line),sc.2025(diff<=end-start?start+diff:end)
}
Delete_Matching_Brace(){
	sc:=CSC(),value:=[],CPos:=sc.2008
	GuiControl,1:+g,% sc.sc
	if((Match:=sc.2353(CPos-1))>=0)
		value[Match]:=1,value[CPos-1]:=1
	else if((Match:=sc.2353(CPos))>=0)
		value[Match]:=1,value[CPos]:=1
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
	all:=SN(CEXML.Find("//main/@file",Current(2).file),"descendant-or-self::info[@type='" type "']/@text"),sc:=CSC(),word:=sc.getword(),sc.2634(1)
	while(aa:=all.item[A_Index-1])
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
	all:=menus.SN("//*[@hotkey!='']"),NewWin:=new GUIKeep("hotkeys"),NewWin.Add("ListView,w400 h600,Action|Hotkey,wh")
	while(aa:=all.item[A_Index-1]),ea:=XML.EA(aa)
		LV_Add("",ea.clean,Convert_Hotkey(ea.hotkey))
	Loop,2
		LV_ModifyCol(A_Index,"AutoHDR")
	NewWin.Show("Hotkeys"),LV_ModifyCol(1,"Sort")
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
			Debug.Send("breakpoint_get -i " receive.SSN("//*[@transaction_id]/@transaction_id").text " -d " receive.SSN("//*[@id]/@id").text)
			if(rea.state="enabled"&&debug.AfterDebug)
				split:=StrSplit(rea.transaction_id,"|"),debug.Breakpoints[split.1]:={line:split.2,id:rea.id},sc:=v.debug,sc.2003(sc.2006,"Breakpoint Added for file: " CEXML.SSN("//*[@id='" split.1 "']/@filename").text " on line: " split.2 "`n"),sc.2025(sc.2006)
		}if(rea.command="breakpoint_remove"){
			sc:=v.debug,sc.2003(sc.2006,"Breakpoint Removed`n"),sc.2025(sc.2006)
		}if(info.NodeName="init"){
			v.afterbug:=[]
			ad:=["stdout -c 1","stderr -c 1","feature_set -n max_depth -v 0","feature_set -n max_children -v 0"]
			bp:=CEXML.SN("//*[@id='" debug.id "']/descendant::info[@type='Breakpoint']")
			while(bb:=bp.item[A_Index-1],bpea:=XML.EA(bb)){
				/*
					m("breakpoint_set -t line -f " Chr(34) SSN(bb,"ancestor-or-self::file/@file").text Chr(34) " -n" bpea.line+1 " -i " SSN(bb,"ancestor::file/@id").text "|" bpea.line,bb.xml)
				*/
				/*
					breakpoint_set -t line -f "D:\AHK\Projects\Games\Graveyard Keeper\Graveyard Keeper.ahk" -n -i 383|
				*/
				/*
					m(bb.xml,"","","breakpoint_set -t line -f " Chr(34) SSN(bb,"ancestor-or-self::file/@file").text Chr(34) " -n" bpea.line+1 " -i " SSN(bb,"ancestor::file/@id").text "|" bpea.line)
				*/
				while(bb:=bb.ParentNode){
					if(bb.NodeName="File")
						Break
				}
				Index:=A_Index,FN:=SSN(bb,"@file").text,Pos:=1,FText:=Update({Get:FN})
				while(RegExMatch(FText,"OU)(\x3B\*\[.*\])",Found,Pos),Pos:=Found.Pos(1)+Found.Len(1))
					RegExReplace(SubStr(FText,1,Pos),"\R",,Count),ad.Insert("breakpoint_set -t line -f " FN " -n" Count " -i " Index)
			}
			for a,b in ad
				v.afterbug.Insert(b)
			SetTimer,AfterDebug,-300
		}if(rea.status="stopped"){
			sc:=CSC(),sc.2045(2),sc.2045(3),sc:=v.debug,sc.2003(sc.2006,"Execution Complete"),sc.2025(sc.2006),debug.Caret(0)
			SetTimer,VarBrowserStop,-1
			return
		}if(rea.status="break"){
			debug.Send("stack_get")
			SetTimer,InsertDebugMessage,-200
		}if(rea.command="stack_get"){
			sc:=CSC(),stack:=receive.SN("//stack"),exist:=0,v.DebugHighlight:=[]
			while(ss:=stack.item[A_Index-1]),ea:=XML.EA(ss){
				filename:=RegExReplace(RegExReplace(URIDecode(ea.filename),"file:\/\/\/"),"\/","\")
				if(!IsObject(obj:=v.DebugHighlight[filename]))
					obj:=v.DebugHighlight[filename]:=[]
				obj.push(ea.lineno-1)
				if(FileExist(filename)&&exist=0){
					if(filename!=Current(3).file)
						tv(SSN(CEXML.Find("//file/@file",filename),"@tv").text)
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
								if(Node:=CEXML.SSN("//*[@lower='" Format("{:L}",Filename) "']")){
									if((tv:=SSN(Node,"@tv").text)&&tv!=TV_GetSelection())
										tv(tv)
								}
								/*								
									* The Default() call above is resetting the Default Gui/ListView, 
									* so the upcoming LV_Add() and LV_ModifyCol() calls will fail, 
									* unless we update the Default Gui with the following line
								*/
								Default("SysListView321",98)
							}
							/* 
								* 1) The filename variable used previously is not updated as we travel down the call stack.
								*    This quick fix just converts the stackframe's file url to a file path 
								* 2) Removed the pipe characters surrounding the filename. 
								*    The pipe characters should only be needed for the `Gui, Add, ListView` command 
							*/
							stack_filename:=RegExReplace(RegExReplace(URIDecode(ea.filename),"file:\/\/\/"),"\/","\")
							LV_Add("",ea.where,stack_filename,ea.lineno)
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
	while(info:=v.afterbug.Pop()){
		debug.Send(Info)
		Sleep,20
	}
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
	Active:=DllCall("GetActiveWindow")
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
	WinActivate,ahk_id%Active%
	return Color
}
DLG_FileSave(HWND:=0,DefaultFilter=0,DialogTitle="Select file to open",DefaultFile:="",Flags:=0x00000002,ForceFile:=0){
	Filter:=GetExtensionList(Current(3).Lang?Current(3).Lang:"ahk"),VarSetCapacity(lpstrFileTitle,0xFFFF,0),VarSetCapacity(lpstrFile,0xFFFF,0),VarSetCapacity(lpstrFilter,0xFFFF,0),VarSetCapacity(lpstrCustomFilter,0xFF,0),VarSetCapacity(OFName,90,0),VarSetCapacity(lpstrTitle,255,0),Address:=&lpstrFilter
	for a,b in StrSplit(Filter,"|"){
		for c,d in StrSplit(b)
			Address:=NumPut(Asc(d),Address+0,"UChar")
		Address:=NumPut(0,Address+0,"UChar"),RegExMatch(b,"OU)\((.*)\)",Found)
		for c,d in StrSplit(Found.1)
			Address:=NumPut(Asc(d),Address+0,"UChar")
		Address:=NumPut(0,Address+0,"UChar")
	}NumPut(0,Address+0,"UChar"),StrPut(DialogTitle,&lpstrTitle,"UTF-8")
	;Structure https://msdn.microsoft.com/en-us/library/windows/desktop/ms646839(v=vs.85).aspx
	Address:=&OFName
	SplitPath,DefaultFile,FileName,Initial,Ext,NNE
	if((InStr(NNE,"Untitled")||!FileExist(DefaultFile))&&!ForceFile)
		SplitPath,DefaultFile,FileName,Initial,Ext,NNE
	if(FileExist(Initial)!="D")
		FileCreateDir,%Initial%
	if(Initial=A_ScriptDir "\Untitled"&&SubStr(NNE,1,8)="Untitled"){
		if(DefPro:=Settings.SSN("//directory").text){
			if(!FileExist(DefPro))
				DefPro:=""
		}if(!DefPro)
			DefPro:=A_ScriptDir "\Projects"
		if(!FileExist(DefPro))
			FileCreateDir,%DefPro%
		DefaultFile:=Trim(DefPro,"\") "\" FileName
	}
	Initial:=DefaultFile?DefaultFile:Initial "\"
	SplitPath,Initial,,InitialPath
	VarSetCapacity(lpstrInitialDir,0XFFFF,0),StrPut(InitialPath,&lpstrInitialDir,"UTF-8")
	if(!InStr(FileExist(DefaultFile),"D"))
		VarSetCapacity(lpstrFile,0XFF,0),StrPut(FileName,&lpstrFile,"UTF-8")
	RegExReplace(SubStr(Filter,1,InStr(Filter,Settings.SSN("//Languages/" Current(3).Lang "/@name").text " (")),"\|","",Count),DefaultFilter:=DefaultFilter?DefaultFilter:Count+1
	for a,b in [76,HWND,0,&lpstrFilter,&lpstrCustomFilter,255,DefaultFilter,&lpstrFile,0xFFFF,&lpstrFileTitle,0xFFFF,&lpstrInitialDir,&lpstrTitle,Flags,0,&lpstrDefExt]
		Address:=NumPut(b,Address+0,"UInt")
	if(!DllCall("comdlg32\GetSaveFileNameA","Uint",&OFName))
		Exit
	FileName:=""
	while(Char:=NumGet(lpstrFile,A_Index-1,"UChar"))
		FileName.=Chr(Char)
	SplitPath,FileName,,Dir
	Settings.Add("SaveAs").Text:=Dir
	WinActivate,% hwnd([1])
	return FileName
}
Dlg_Font(Node,DefaultNode:="//theme/default",window="",Attribute:="color",Effects=1){
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
	Color:=NumGet(ChooseFont,24),Style:={size:((Size:=NumGet(ChooseFont,16)//10)>4?Size:4),font:StrGet(&LogFont+28,"CP0"),(Attribute):color,bold:NumGet(LogFont,16)>=700?1:0}
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
	if(!FileExist(A_ScriptDir "\plugins"))
		FileCreateDir,%A_ScriptDir%\Plugins
	SplashTextOn,,,Downloading Plugin List,Please Wait...
	plug:=new xml("plugins"),plug.XML.LoadXML(URLDownloadToVar("https://raw.githubusercontent.com/maestrith/AHK-Studio-Plugins/master/Index.xml?refresh=" A_Now))
	SplashTextOff
	if(!plug[])
		return m("There was an error downloading the plugin list.  Please try again later")
	NewWin:=new GUIKeep(35)
	Gui,35:Margin,0,0
	NewWin.Add("ListView,w500 h300 Checked,Name|Author|Description|Installed,wh","Button,gdpdl,&Download Checked,y","Button,x+0 gdpsa,Select &All,y","Button,x+0 gdprem,Remove Checked,y"),NewWin.show("Download Plugins")
	Goto,dppop
	return
	dprem:
	Gui,35:Default
	Gui,35:ListView,SysListView321
	while(next:=LV_GetNext(0,"C")){
		if(next=lastnext)
			Break
		LV_Modify(next,"Col4 -check","No"),LV_GetText(plugin,next)
		FileDelete,Plugins\%plugin%.ahk
		lastnext:=next
	}
	MenuWipe(),Menu("main")
	Goto,dppop
	return
	dpsa:
	Loop,% LV_GetCount()
		LV_Modify(A_Index,"Check")
	return
	dpdl:
	pluglist:=""
	while(num:=LV_GetNext(0,"C")){
		LV_GetText(name,num),pos:=1,text:=RegExReplace(URLDownloadToVar("https://raw.githubusercontent.com/maestrith/AHK-Studio-Plugins/master/" name ".ahk"),"\R","`r`n"),list:=""
		date:=plug.SSN("//*[@name='" name "']/@date").text,pos:=1
		while(pos:=RegExMatch(text,"Oim)^\s*\;menu\s*(.*)\R",found,pos))
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
	Goto,dppop
	return
	35GuiEscape:
	35GuiClose:
	HWND({rem:35})
	return
	dppop:
	Gui,35:Default
	LV_Delete(),pgn:=plug.SN("//plugin")
	while(pp:=pgn.item[A_Index-1],ea:=XML.EA(pp)){
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
	sc:=CSC(),Info:=[]
	Loop,% sc.2570
	{
		Info.Push({StartLine:(Start:=sc.2166(sc.2585(A_Index-1))),EndLine:(End:=sc.2166(sc.2587(A_Index-1)))})
		if(Start!=End)
			Complicated:=1
	}
	if(Complicated){
		Order:=[],Lines:=[],Reverse:=[],sc.2078
		for a,b in Info
			Order[b.StartLine]:=b,Lines[b.StartLine]:=1
		for a in Lines
			Reverse.InsertAt(1,Order[a])
		for a,b in Reverse
			Text:=sc.TextRange(sc.2167(b.StartLine),(LineEnd:=sc.2136(b.EndLine))),sc.2003(LineEnd,"`n" Text)
		sc.2079
	}else
		sc.2404
}
Duplicates(){
	Sleep,300
	sc:=CSC(),sc.2500(3),sc.2505(0,sc.2006),Search:=sc.TextRange((Start:=sc.2143),(End:=sc.2145)),v.LastSearch:=Search
	if(End-Start<2)
		return
	sc.2686(0,sc.2006),sc.2500(3),sc.2198(v.Options.Match_Any_Word?0:0x2),Len:=StrPut(Search,"UTF-8")-1,Obj:=v.DuplicateSelect[sc.2357]:=[],Count:=0
	while(Found:=sc.2197(Len,[Search]))>=0
		sc.2686(Found+1,sc.2006),Obj[Found]:=Len,Count++
	if(Count>1)
		for a,b in Obj
			sc.2504(a,Len),List.=a  " - " Len "`n"
}
DynaRun(Script,Wait:=true,name:="Untitled"){
	static exec,started,filename
	if(!IsObject(v.Running))
		v.Running:=[]
	filename:=name,MainWin.Size(),exec.Terminate()
	if(Script~="i)m(.*)\{"=0)
		Script.="`n" "m(x*){`nfor a,b in x`nlist.=b Chr(10)`nMsgBox,,AHK Studio,% list`n}"
	if(Script~="i)t(.*)\{"=0)
		Script.="`n" "t(x*){`nfor a,b in x`nlist.=b Chr(10)`nToolTip,% list`n}"
	shell:=ComObjCreate("WScript.Shell"),exec:=shell.Exec("AutoHotkey.exe /ErrorStdOut *"),exec.StdIn.Write(Script),exec.StdIn.Close(),started:=A_Now
	v.Running[Name]:=exec
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
Edit_Highlight_Colors(){
	static NewWin
	NewWin:=new GUIKeep("Edit_Highlight_Colors")
	NewWin.Add("ListView,w250 r10 gShowHighlightColor AltSubmit,Highlight Index|Highlight Color"
			,"Progress,w250 h100 vProgress,100"
			,"Button,gSetHighlightColor Default,Set Highlight Color")
	All:=Settings.SN("//Highlight/Color")
	while(aa:=All.Item[A_Index-1],ea:=XML.EA(aa))
		LV_Add("",ea.Index,ea.Color)
	LV_Modify(1,"Select Vis Focus"),NewWin.Show("Edit Highlight Colors")
	return
	SetHighlightColor:
	NewWin.Default("Progress"),Node:=Settings.SSN("//Highlight/Color[@index='" LV_GetNext() "']"),Dlg_Color(Node,"",NewWin.HWND),Node.SetAttribute("color",(Color:=RGB(RGB(SSN(Node,"@color").text)))),LV_Modify(LV_GetNext(),"Col2",Color),RefreshThemes(1)
	return
	ShowHighlightColor:
	NewWin.Default("ShowHighlightColor"),LV_GetText(Color,LV_GetNext(),2)
	GuiControl,% "Edit_Highlight_Colors:+c" RGB(Color),% NewWin.GetCtrlXML("Progress","hwnd"),100
	return
}
Edit_Hotkeys(ret:=""){
	static NewWin,Attributes:=[]
	if(ret.NodeName)
		return ea:=XML.EA(ret),Default("SysTreeView321","Edit_Hotkeys"),TV_Modify(TV_GetSelection(),"",RegExReplace(ea.clean,"_"," ")(ea.hotkey?" - " Convert_Hotkey(ea.hotkey):""))
	NewWin:=new GUIKeep("Edit_Hotkeys")
	NewWin.Add("Edit,w400 gEHFind vfind -Multi,Search For Menu Item {Enter to find next},w","TreeView,w400 h400,,wh","Button,gehgo,C&hange Hotkey,y","Button,x+M Default gEHNext,&Next Found,y"),all:=menus.SN("//main/descendant::*")
	Attributes:=[]
	Default("SysTreeView321","Edit_Hotkeys")
	while(aa:=all.item[A_Index-1],ea:=XML.EA(aa))
		if(aa.NodeName="menu"){
			for a,b in ea
				Attributes[a]:=1
			aa.SetAttribute("tv",TV_Add(RegExReplace(ea.Clean,"_"," ") (ea.Hotkey?" - Hotkey - " Convert_Hotkey(ea.Hotkey):""),SSN(aa.ParentNode,"@tv").text))
		}
	GuiControl,Edit_Hotkeys:,ComboBox1,%list%
	NewWin.Show("Edit Hotkeys"),TV_Modify(TV_GetChild(0),"Select Vis Focus")
	GuiControl,Edit_hotkeys:ChooseString,ComboBox1,Search
	Gui,1:+Disabled
	return
	EHFind:
	Value:=NewWin[].find
	GuiControl,Edit_Hotkeys:-Redraw,SysTreeView321
	if(Node:=menus.SSN("//*[" XMLSearchText(Attributes,Value) "]"))
		TV_Modify(SSN(Node,"@tv").text,"Select Vis Focus")
	GuiControl,Edit_Hotkeys:+Redraw,SysTreeView321
	return
	Edit_HotkeysEscape:
	Edit_HotkeysClose:
	all:=menus.SN("//menu/@tv")
	while(aa:=all.item[A_Index-1])
		aa.RemoveAttribute("tv")
	HWND({rem:"Edit_Hotkeys"}),Hotkeys()
	SetTimer,RefreshMenu,-1
	return
	ehgo:
	node:=menus.SSN("//*[@tv='" TV_GetSelection() "']")
	if(node.HasChildNodes())
		return m("Please select a menu item not a parent menu")
	EditHotkey(node,"Edit_Hotkeys")
	return
	EHNext:
	All:=menus.SN("//*[" XMLSearchText(Attributes,NewWin[].Find) "]"),Default("SysTreeView321","Edit_Hotkeys"),TV:=TV_GetSelection(),Found:=0
	if(All.Length=1)
		return TV_Modify(SSN(All.Item[0],"@tv").text,"Select Vis Focus"),m("Only One","time:1")
	else if(!All.Length)
		return m("None")
	while(aa:=All.item[A_Index-1],ea:=XML.EA(aa)){
		if(Found){
			TV_Modify(ea.TV,"Select Vis Focus")
			Break
		}if(ea.tv=TV){
			if(A_Index=All.length)
				TV_Modify(SSN(All.Item[0],"@tv").text,"Select Vis Focus")
			Found:=1
	}}
	return
}
XMLSearchText(Attributes,Search){
	Search:=Format("{:L}",Search)
	for a in Attributes
		SearchText.="contains(translate(translate(@" a ", 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'),'\&','') , '" Search "') or "
	return SearchText "contains(translate(translate(text(), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'),'\&','') , '" Search "')"
}
EditHotkey(node,window){
	static nw,EditNode,Win,Control
	MenuWipe(),EditNode:=node,Win:=window,nw:=new GUIKeep("Edit_Hotkey"),nw.Add("Hotkey,w240 vhotkey gEditHotkey","Edit,w240 vedit gCustomHotkey","ListView,w240 h220,Duplicate Hotkey Definitions","Button,gEHSet Default,&Set Hotkey,y"),nw.Show("Edit Hotkey")
	GuiControl,Edit_Hotkey:,msctls_hotkey321,% SSN(node,"@hotkey").text
	return
	EditHotkey:
	info:=nw[],hotkey:=info.hotkey,edit:=info.edit,LV_Delete()
	StringUpper,uhotkey,hotkey
	if(dup:=menus.SN("//*[(@hotkey='" hotkey "' or @hotkey='" uhotkey "')and(@clean!='" SSN(EditNode,"@clean").text "')]"))
		while(dd:=dup.item[A_Index-1],ea:=XML.EA(dd))
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
		return HWND({rem:"Edit_Hotkey"}),EditNode.RemoveAttribute("hotkey"),%Win%(EditNode),WinActivate(HWND([Win]))
	dup:=menus.SN("//*[(@hotkey='" hotkey "' or @hotkey='" uhotkey "')and(@clean!='" SSN(EditNode,"@clean").text "')]")
	if(dup.length){
		list:=""
		while(dd:=dup.item[A_Index-1],ea:=XML.EA(dd))
			list.=ea.clean "`n"
		if(m("This hotkey already exists for:" list "Replace?","btn:ync")="yes"){
			while(dd:=dup.item[A_Index-1])
				dd.RemoveAttribute("hotkey")
		}else
			return
	}EditNode.SetAttribute("hotkey",uhotkey)
	Edit_HotkeyEscape:
	Edit_HotkeyClose:
	KeyWait,Escape,U
	HWND({rem:"Edit_Hotkey"}),Hotkeys(1),%Win%(EditNode),WinActivate(HWND([Win]))
	return
}
Edit_Plugin(){
	static NewWin,List
	NewWin:=new GUIKeep("Edit_Plugin"),NewWin.Add("TreeView,w500 h500,,wh","Button,gEditPluginGo Default,Edit Plugin,y"),NewWin.Show("Edit Plugin")
	Populate:
	Default("SysTreeView321","Edit_Plugin"),TV_Delete(),List:=[]
	Loop,Files,Plugins\*.*
		List[TV_Add(A_LoopFileName)]:=A_LoopFileLongPath
	return
	EditPluginGo:
	Default(,"Edit_Plugin"),Open((OpenFile:=List[TV_GetSelection()])),tv(SSN(CEXML.Find("//main/file/@file",OpenFile),"@tv").text),NewWin.Exit()
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
	current:=current?current:Current(),sc:=CSC()
	if(MainWin.tnsc.sc=sc.sc)
		return TNotes.Write(MainWin.tnsc)
	if(!CEXML.SSN("//*[@sc='" sc.2357 "']"))
		return
	if(!SSN(current,"@edited")){
		current.SetAttribute("edited",1),ea:=XML.EA(current),all:=CEXML.SN("//*[@id='" ea.id "']"),WinSetTitle(1,ea)
		while(aa:=all.item[A_Index-1]),nea:=XML.EA(aa)
			TVC.Modify(1,(v.Options.Hide_File_Extensions?"*" nea.nne:"*" nea.filename),nea.tv)
	}list:=CEXML.SN("//*[@edited]"),items:="",WinSetTitle()
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
	return Len-1
}
Enter(){
	static map:=new XML("map"),NotIndent:={IfEqual:1,IfNotEqual:1,IfGreater:1,IfGreaterOrEqual:1,IfLess:1,IfLessOrEqual:1,IfInString:1}
	ControlGetFocus,Focus,% HWND([1])
	checkqf:
	sc:=CSC(),fixlines:=[],Ind:=Settings.Get("//tab",5),ShowOSD(GetKeyState("Shift","P")?"Shift+Enter":"Enter")
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
			CPos:=sc.2585(A_Index-1),Line:=sc.2166(CPos),End:=sc.2587(A_Index-1),LineStatus.Add(Line,2)
			if(CPos!=End)
				sc.2645(CPos,End-CPos)
			if(A_Index>1&&(Line+1!=last&&Line-1!=last))
				group++
			start:=sc.2128(Line),skip:=0
			if(CPos=sc.2136(Line)||sc.2007(CPos-1)=123)
				skip:=0
			else{
				sc.2686(CPos,sc.2128(Line))
				if((brace:=sc.2197(1,"{"))>=0)
					skip:=sc.2166(sc.2353(brace))!=Line?0:1
				else
					skip:=1
			}new:=map.Add("line",{skip:skip,line:Line,between:sc.2007(CPos)=125&&sc.2007(CPos-1)=123,group:group,pos:CPos,caret:A_Index-1},"",1),order[Line]:=new,last:=Line
		}rev:=[]
		for a,b in order
			rev.InsertAt(1,b)
		for a,b in rev
			root.AppendChild(b)
		all:=map.SN("descendant::*[@line]"),add:=0,state:=GetKeyState("Shift","P"),IndentRegex:=Keywords.IndentRegex[Current(3).ext]
		while(aa:=all.item[A_Index-1],ea:=XML.EA(aa)){
			if(!state){
				if(ea.between)
					InsertMultiple(ea.caret,ea.pos,"`n`n",ea.pos+1),Indent:=sc.2127(ea.Line),sc.2126(ea.Line+1,Indent+Ind),sc.2126(ea.Line+2,Indent),GotoPos(ea.caret,sc.2128(ea.Line+1))
				else{
					InsertMultiple(ea.caret,ea.pos,"`n",ea.pos+1),OIndent:=Indent:=sc.2127(ea.Line),PrevText:=RemoveComment(sc.GetLine(ea.Line-1)),Text:=RemoveComment(sc.GetLine(ea.Line))
					if(SubStr(Text,0,1)="{"||sc.2223(ea.Line)&0x2000)
						Indent+=Ind
					else if(RegExMatch(Text,"iA)(}|\s)*#?\b(" IndentRegex ")\b",String)&&IndentRegex!=""){
						if(NotIndent[string2])
							Indent:=Indent
						else
							Indent+=Ind
					}else if(RegExMatch(PrevText,"iA)(}|\s)*#?\b(" IndentRegex ")\b",String)&&SubStr(PrevText,0,1)!="{"&&IndentRegex!=""){
						Indent:=sc.2127(ea.Line-1)
					}if(ea.skip)
						Indent:=OIndent
					sc.2126(ea.Line+1,Indent),GotoPos(ea.caret,sc.2128(ea.Line+1))
			}}else if(state){
				if(ea.group!=lastgroup&&lastgroup!=""){
					sea:=map.EA("//*[@fix]")
					FixLines(sc.2166(sea.pos),sc.2166(sc.2353(sea.pos-1))-sc.2166(sea.pos))
					map.SSN("//*[@fix]").RemoveAttribute("fix")
				}if(ea.between){
					lea:=XML.EA(map.SSN("//*[@group='" ea.group "']")),NextLine:=SSN(map.SSN("//*[@group='" ea.group "']"),"@line").Text+1<=sc.2154?1:0,sc.2645(ea.pos,1),End:=sc.2136(lea.Line+NextLine)
					if(sc.2007(End-1)=123){
						End:=sc.2353(End-1)+1
						if(sc.GetLine(sc.2166(End))~="i)(\}|\s)*(else|if)")
							End:=sc.2128(sc.2166(End)),InsertMultiple(ea.caret,End,"}",ea.pos)
						else
							End:=sc.2128(sc.2166(End)),InsertMultiple(ea.caret,End,"}",ea.pos)
					}else if(sc.GetLine(sc.2166(End)+1)~="i)(\}|\s)*(else|if)")
						End:=sc.2128(sc.2166(End)+1),InsertMultiple(ea.caret,End,"}",ea.pos)
					else
						InsertMultiple(ea.caret,End,"`n}",ea.pos)
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
	sc:=CSC(),ShowOSD("Escape")
	ControlGetFocus,Focus,% HWND([1])
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
	}Line:=sc.2166(sc.2008)
	if(v.DisableContext=Line)
		v.DisableContext:="",SetTimer("Context",-100)
	else
		v.DisableContext:=Line,sc.2201
	if(v.Options.Auto_Set_Area_On_Quick_Find)
		SetTimer,Clear_Selection,-1
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
			if(Info.Line!=""){
				v.exec.Terminate(),sc:=CSC(),Line:=
				if(info.file!=Current(2).file)
					tv(SSN(CEXML.Find(Current(1),"descendant::file/@file",info.file),"@tv").text)
				sc.2160(sc.2128(Info.Line),sc.2136(Info.Line))
				if(!v.Debug)
					MainWin.DebugWindow()
				dd:=v.Debug,dd.2003(dd.2006,(dd.2006?"`n" Text:Text)),sc.2160(sc.2128(Info.Line),sc.2136(Info.Line)),dd.2025(dd.2006),MarginWidth(dd)
				return
	}}}else if(text:=v.exec.StdERR.ReadAll()){
		if(InStr(text,"cannot be opened"))
			return m(text,"","If the script file is located in the same directory as the main Project try adding #Include %A_ScriptDir% to the main Project file.")
		exec.Terminate(),sc:=CSC(),info:=StripError(text,"*"),tv(SSN(CEXML.Find(Current(1),"descendant::file/@file",info.file),"@tv").text),line:=Info.Line
		Sleep,100
		if(!v.Debug)
			MainWin.DebugWindow()
		dd:=v.Debug,dd.2003(dd.2006,(dd.2006?"`n" Text:Text)),sc.2160(sc.2128(line),sc.2136(line)),dd.2025(dd.2006),MarginWidth(dd)
	}
}
Exit(ExitApp:=0){
	GuiClose:
	Save(3)
	Node:=MainWin.Gui.SSN("//win[@win=1]"),fn:=MainWin.Gui.SN("//win[@win=1]/descendant::*[@type='Scintilla']")
	if((List:=CEXML.SN("//file[@dir='" A_ScriptDir "\Untitled']")).Length){
		Template:=GetTemplate(),All:=Settings.SN("//open/file")
		while(ll:=List.Item[A_Index-1],ea:=XML.EA(ll)){
			Dir:=A_ScriptDir "\Untitled",Text:=Update({Get:ea.File})
			if(!FileExist(Dir))
				FileCreateDir,%Dir%
			if(Text=""||Text=Template){
				if(FileExist(ea.File))
					FileDelete,% ea.File
				while(aa:=All.Item[A_Index-1]){
					if(aa.text=ea.file)
						aa.ParentNode.RemoveChild(aa)
				}
				Parent:=ll
				while(Parent.NodeName!="Main"&&Parent.NodeName){
					Parent:=Parent.ParentNode
					if(!Parent.ParentNode)
						Continue,2
				}Parent.ParentNode.RemoveChild(Parent)
				Continue
			}
			FileObj:=FileOpen(ea.File,"RW","UTF-8"),FileObj.Write(Text),FileObj.Length(FileObj.Position),FileObj.Close()
	}}while(ff:=fn.item[A_Index-1]),ea:=XML.EA(ff){
		sc:=s.ctrl[ea.hwnd],doc:=sc.2357
		if(filename:=CEXML.SSN("//*[@sc='" doc "']/@file").text)
			if(filename!="untitled.ahk")
				ff.SetAttribute("file",filename)
	}sc:=CSC(),open:=CEXML.SN("//files/main"),Top:=Settings.Clear("//open")
	while(oo:=open.item[A_Index-1]),ea:=XML.EA(oo)
		if(!ea.untitled)
			Settings.Under(top,"file",,ea.file)
	if(!GNode:=Settings.SSN("//gui"))
		GNode:=Settings.Add("gui")
	GNode.SetAttribute("zoom",sc.2374)
	WinGet,mm,MinMax,% MainWin.ID
	if(mm=1)
		Node.SetAttribute("max",1)
	else
		Node.RemoveAttribute("max")
	list:=TNotes.XML.SN("//master|//main|//global|//file"),temp:=new XML("Tracked_Notes",A_ScriptDir "\lib\Tracked Notes.xml")
	while(ll:=list.item[A_Index-1]),ea:=XML.EA(ll){
		if(!ll.text&&temp.SSN("//*[@id='" ea.id "']").text){
			FileCopy,lib\Tracked Notes.xml,lib\Tracked Notes %A_Now%.xml
			Break
	}}last:=MainWin.Gui.SN("//*[@last]")
	WinGet,max,MinMax,% HWND([1])
	if(max!=1){
		pos:=MainWin.WinPos().text
		if(!InStr(pos,"-32000"))
			Node.SetAttribute("pos",pos)
	}while(ll:=last.item[A_Index-1])
		ll.RemoveAttribute("last")
	RCMXML.Save(1),MainWin.Gui.SSN("//*[@hwnd='" CSC().sc "']").SetAttribute("last",1),MainWin.Gui.Save(1),menus.Save(1),GetPos(),Positions.Save(1),TNotes.GetPos(),TNotes.SaveState(),TNotes.XML.Save(1)
	if(debug.socket)
		debug.Send("stop")
	All:=CEXML.SN("//*[@file='']")
	while(aa:=All.Item[A_Index-1])
		aa.ParentNode.RemoveChild(aa)
	Top:=Settings.ReCreate("//open","open")
	all:=CEXML.SN("//files/main")
	while(aa:=All.Item[A_Index-1],ea:=XML.EA(aa))
		Settings.Under(Top,"file",,ea.File)
	Settings.Save(1),Rem:=CEXML.SSN("//menu"),Rem.ParentNode.RemoveChild(Rem),All:=menus.SN("//*[@tv]")
	while(aa:=All.item[A_Index-1])
		aa.RemoveAttribute("tv")
	if(All.Length)
		menus.Save(1)
	vversion.Save(1)
	if(0)
		m("Disabled Saving ScanFile.xml","time:.5")
	else{
		all:=CEXML.SN("//*[@tv or @cetv or @sc]")
		while(aa:=all.item[A_Index-1],ea:=XML.EA(aa))
			aa.RemoveAttribute("sc"),aa.RemoveAttribute("tv"),aa.RemoveAttribute("cetv")
		CEXML.Save(1)
	}if(ExitApp)
		Reload
	CEXML.Save(1)
	ExitApp
	return
}
Export(){
	indir:=Settings.Find("//export/file/@file",SSN(Current(1),"@file").text),warn:=v.Options.Warn_Overwrite_On_Export?"S16":"S"
	Text:=Publish(1)
	if(RegExMatch(Text,"\x3bauto_branch")){
		Branch:=InputBox(CSC().sc+0,"Branch","Enter the branch you wish to use for this Export","Beta")
		Text:=RegExReplace(Text,"(\x3bauto_branch)","Branch:=" Chr(34) Branch Chr(34))
	}
	FileSelectFile,filename,%warn%,% indir.text,Export Compiled AHK,*.ahk
	SplitPath,filename,,outdir
	filename:=InStr(filename,".ahk")?filename:filename ".ahk"
	FileDelete,%filename%
	file:=FileOpen(filename,"rw","UTF-8"),file.Seek(0),file.Write(Text),file.Length(file.length)
	if(!indir)
		indir:=Settings.Add("export/file",{file:SSN(Current(1),"@file").text},,1)
	if(outdir)
		indir.text:=filename
}
Extract(Main){
	static ;,ADODB:=ComObjCreate("ADODB.Stream")
	FileList:=[],Pool:=[],All:=SN(Main,"file")
	while(aa:=All.Item[A_Index-1])
		aa.ParentNode.RemoveChild(aa)
	MainFile:=SSN(Main,"@file").text,File:=MainFile
	SplitPath,MainFile,MFN,MainDir,Ext,mnne
	SplitPath,A_AhkPath,,ahkdir
	Pool[MainDir]:=1,Pool[ahkdir]:=1,out:=SplitPath(MainFile),Language:=LanguageFromFileExt(Ext)
	if(!node:=CEXML.Find(main,"descendant::file/@file",file))
		node:=CEXML.Under(main,"file",{file:file,dir:MainDir,filename:MFN,id:GetID(),nne:mnne,scan:1,lower:Format("{:L}",file),ext:Ext,lang:Language,type:"File"})
	if(Ext="ahk"&&!SSN(Main,"ancestor-or-self::Libraries")){
		if(Extra:=ES(MainFile)){
			for a,b in StrSplit(Extra,"`n","`r`n"){
				IncludeFile:=RegExReplace(b,"i)(#Include.*\b\s+)")
				if(!InStr(FileExist(IncludeFile),"D")&&FileExist(IncludeFile)&&IncludeFile){
					SplitPath,IncludeFile,FileName,Dir,Ext,NNE
					Language:=LanguageFromFileExt(Ext),obj.ext:=Ext,obj.lang:=Language,New:=CEXML.Under(CEXML.Find(node,"descendant-or-self::file/@file",MainFile),"file",obj)
					Relative:=RelativePath(MainFile,IncludeFile)
					for a,b in {file:IncludeFile,type:"File",id:GetID(),filename:FileName,dir:Dir,nne:NNE,github:(MainDir=dir?FileName:!InStr(Relative,"..")?Relative:"lib\" filename),scan:1,lower:Format("{:L}",FileName),nocompile:1}
						New.SetAttribute(a,b)
				}
			}
	}}
	ExtractNext:
	id:=GetID(),q:=FileOpen(file,"R")
	if(q.Encoding="CP1252"){
		if(RegExMatch((Text:=q.Read()),"OU)([^\x00-\x7F])",Found)){
			q:=FileOpen(File,"W","UTF-8"),q.Write(Text),q.Close(),Encoding:="UTF-8"
		}else
			Encoding:=q.Encoding
	}else
		Encoding:=q.Encoding,Text:=q.Read()
	q.Close(),dir:=Trim(dir,"\")
	if(nnnn:=CEXML.Find("//*/@file",file)){
		if(SSN(nnnn,"@time"))
			id:=SSN(nnnn,"@id").text
	}
	FileGetTime,time,%file%
	SplitPath,file,filename,dir,Ext,nne
	Language:=LanguageFromFileExt(Ext),set:=CEXML.Find(node,"descendant-or-self::file/@file",file),set.SetAttribute("time",time),set.SetAttribute("encoding",encoding),pos:=1
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
			Pool[Trim(info,"\")]:=1
		if(InStr(info,"%")){
			if(InStr(info,"%A_LineFile%")){
				Loop,Files,% RegExReplace(info,"i)\%A_LineFile\%",file)
					FileList[A_LoopFileLongPath]:={file:A_LoopFileLongPath,include:found.0,inside:file},added:=1
			}if(InStr(info,"%A_ScriptDir%")){
				for a in Pool
					if(FileExist(check:=RegExReplace(info,"i)%A_ScriptDir%",a))~="D"&&!Pool[check]){
						Pool[check]:=1 ;,CEXML.Under(Main,"remove",{text:Info})
						Break
			}}if(InStr(info,"%A_AppData%")){
				check:=RegExReplace(info,"i)%A_AppData%",A_AppData)
				if(FileExist(check)="D"&&!Pool[check])
					Pool[check]:=1
			}if(InStr(info,"%A_AppDataCommon%")){
				check:=RegExReplace(info,"i)%A_AppDataCommon%",A_AppDataCommon)
				if(FileExist(check)="D"&&!Pool[check])
					Pool[check]:=1
			}if(FileExist(check)="A"){
				FileList[check]:={file:check,include:found.0,inside:file},added:=1
				Continue
			}info:=check
		}if(InStr(info,"<")){
			info:=RegExReplace(info,"\<|\>")
			for a in Pool{
				if(FileExist(fn:=a "\lib\" info ".ahk")){
					FileList[fn]:={file:fn,include:found.0,inside:file},libfile:=1,added:=1
					break
				}
			}if(FileExist(fn:=A_MyDocuments "\AutoHotkey\lib\" info ".ahk")&&!libfile){
				FileList[fn]:={file:fn,include:found.0,inside:file},added:=1
			}libfile:=0
		}for a in Pool{
			exist:=FileExist(a "\" info)
			if(exist!="D"&&exist!=""){
				FileList[a "\" info]:={file:a "\" info,include:found.0,inside:file},added:=1
				Break
		}}if(!added&&FileExist(orig))
			FileList[orig]:={file:orig,include:found.0,inside:file},added:=1
	}LastFile:=""
	for fn,obj in FileList{
		if(InStr(fn,"..")){
			Loop,Files,%fn%,F
				obj.file:=A_LoopFileLongPath
		}FileList.Delete(fn),file:=obj.file:=Trim(obj.file)
		if(!CEXML.Find(Node,"descendant::file/@file",file)){
			SplitPath,File,FileName,Dir,Ext,NNE
			Language:=LanguageFromFileExt(Ext),obj.ext:=Ext,obj.lang:=Language,new:=CEXML.Under(CEXML.Find(node,"descendant-or-self::file/@file",obj.inside),"file",obj)
			Relative:=RelativePath(MainFile,File)
			for a,b in {file:file,type:"File",filename:FileName,dir:Dir,nne:NNE,github:(MainDir=dir?filename:!InStr(Relative,"..")?Relative:"lib\" FileName),scan:1,lower:Format("{:L}",filename)}
				new.SetAttribute(a,b)
			qea:=XML.EA(new)
		}else
			Continue
		Goto,ExtractNext
	}
	if(v.Options.Include_All_Lib_Files||0){
		Top:=CEXML.Find("//main/@file",MainFile),AllFiles:=[]
		All:=SN(Top,"descendant::file")
		while(aa:=All.Item[A_Index-1],ea:=XML.EA(aa))
			AllFiles[ea.File]:=1
		Loop,Files,%MainDir%\Lib\*.ahk
		{
			if(!AllFiles[A_LoopFileLongPath]){
				SplitPath,A_LoopFileLongPath,FileName,dir,Ext,nne
				Obj:=[],Language:=LanguageFromFileExt(Ext),Obj.ext:=Ext,Obj.lang:=Language,new:=CEXML.Under(Top,"file",Obj),Relative:=RelativePath(MainFile,A_LoopFileLongPath)
				for a,b in {file:A_LoopFileLongPath,type:"File",id:GetID(),filename:filename,dir:dir,nne:nne,github:(MainDir=dir?filename:!InStr(Relative,"..")?Relative:"lib\" filename),scan:1,lower:Format("{:L}",filename)}
					new.SetAttribute(a,b)
			}
		}
	}
}
FEAdd(value,parent:=0,options:=""){
	if(v.Options.Hide_File_Extensions){
		SplitPath,value,,,ext,name
		value:=ext="ahk"?name:value
	}TVC.Default(1)
	return TV_Add(value,parent,options)
}
FEUpdate(Redraw:=0){
	if(Redraw){
		all:=CEXML.SN("//*[@tv]"),oid:=Current(8)
		while(aa:=all.item[A_Index-1]),ea:=XML.EA(aa)
			aa.RemoveAttribute("tv")
		TVC.Delete(1,0),Libraries:=""
	}Master:=CEXML.Add("files"),mea:=XML.EA(Master)
	TVC.Enable(1)
	if(!mea.tv)
		Master.SetAttribute("tv",TVC.Add(1,"Projects"))
	projects:=SSN(Master,"@tv").text,all:=CEXML.SN("descendant::file[not(@tv)]|descendant::main")
	while(aa:=all.item[A_Index-1]),ea:=XML.EA(aa){
		if(aa.NodeName="folder"){
			aa.ParentNode.RemoveChild(aa)
			Continue
		}if(aa.NodeName="files"){
			Continue
		}if(aa.NodeName="main"){
			main:=aa,ea:=XML.EA(main),id:=ea.id,file:=ea.file
			if(!root:=CEXML.SSN("//*[@id='" ea.id "']")){
				root:=CEXML.SSN("//*").AppendChild(main.CloneNode(0)),add:=1
			}else
				add:=0
			Continue
		}if(aa.ParentNode.NodeName="main"){
			if(Lib:=SSN(aa,"ancestor::Libraries")){
				if(!SSN(Lib,"@tv"))
					Lib.SetAttribute("tv",Libraries:=TVC.Add(1,"Libraries",0))
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
									CEXML.Under(main,"folder",{path:build,tv:(tv:=TVC.Add(1,b,A_Index=1?SSN(main,"file/@tv").text:SSN(main,"descendant::folder[@path='" lastbuild "']/@tv").text,"vis"))})
							}lastbuild:=build
					}}aa.SetAttribute("tv",TVC.Add(1,v.Options.Hide_File_Extensions?ea.nne:ea.filename,tv,"Sort"))
				}else
					aa.SetAttribute("tv",TVC.Add(1,v.Options.Hide_File_Extensions?ea.nne:ea.filename,SSN(aa.ParentNode,"@tv").text,"Sort"))
			}else
				aa.SetAttribute("tv",TVC.Add(1,v.Options.Hide_File_Extensions?ea.nne:ea.filename,SSN(aa.ParentNode,"@tv").text,"Sort"))
			if(add)
				new:=root.AppendChild(aa.CloneNode(0)),new.SetAttribute("type","File")
	}}if(Redraw){
		tv(CEXML.SSN("//*[@id='" oid "']/@tv").text)
		TVC.Enable(1)
	}
}
FileCheck(file:=""){
	static base:="https://raw.githubusercontent.com/maestrith/AHK-Studio/master/"
	,scidate:=20180209111407,XMLFiles:={menus:[20180904082556,"lib/menus.xml","lib\Menus.xml"]}
	,OtherFiles:={scilexer:{date:20180104080414,loc:"SciLexer.dll",url:"SciLexer.dll",type:1},icon:{date:20150914131604,loc:"AHKStudio.ico",url:"AHKStudio.ico",type:1},Studio:{date:20170906124736,loc:A_MyDocuments "\Autohotkey\Lib\Studio.ahk",url:"lib/Studio.ahk",type:1}}
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
			UrlDownloadToFile,% base b.2 "?refresh=" A_Now,% b.3
		}SplashTextOff
		new:=%a%:=new XML(a,b.3)
		if(!new.SSN("//date"))
			new.Add("date",,b.1),new.Save(1)
		if(new.SSN("//date").text!=b.1){
			SplashTextOn,200,100,% "Downloading " b.2,Please Wait...
			if(a="menus"){
				temp:=new XML("temp"),temp.XML.LoadXML(URLDownloadToVar(base b.2 "?refresh=" A_Now)),all:=temp.SN("//*[@clean]")
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
				UrlDownloadToFile,% base b.2 "?refresh=" A_Now,% b.3
				new:=%a%:=new XML(a,b.3),new.Add("date",,b.1),new.Save(1)
			}Options("Startup")
	}}for a,b in OtherFiles{
		FileGetTime,time,% b.loc
		if(time<b.date){
			SplashTextOn,200,100,% "Downloading " b.url,"Please Wait..."
			FileMove,% b.loc,% b.loc "bak"
			URLDownloadToFile,% base b.url "?refresh=" A_Now,% b.loc "new"
			FileDelete,% b.loc "bak"
			FileMove,% b.loc "new",% b.loc
			SplashTextOff
	}}RegRead,value,HKCU,Software\Classes\AHK-Studio
	(!value)?RegisterID("{DBD5A90A-A85C-11E4-B0C7-43449580656B}","AHK-Studio"):""
	if(FileExist("lib\Scintilla.xml"))
		Scintilla()
	LibDir:=A_MyDocuments "\Autohotkey\Lib\"
	FileGetTime,Time,%LibDir%DebugWindow.ahk
	if(Time<20171109092013){
		DebugWindow:="DebugWindow(Text,Clear:=0,LineBreak:=0,Sleep:=0,AutoHide:=0,MsgBox:=0){`r`n`tx:=ComObjActive(""{DBD5A90A-A85C-11E4-B0C7-43449580656B}""),x.DebugWindow(Text,Clear,LineBreak,Sleep,AutoHide,MsgBox)`r`n}"
		if(!FileExist(LibDir))
			FileCreateDir,%LibDir%
		File:=FileOpen(LibDir "DebugWindow.AHK","RW","UTF-8"),File.Write(DebugWindow),File.Length(File.Position),File.Close
	}FileGetTime,time,SciLexer.dll
	if(!FileExist("SciLexer.dll")||time<scidate){
		FileMove,SciLexer.dll,SciLexer.Bak,1
		SplashTextOn,200,100,Downloading SciLexer.dll,Please Wait....
		UrlDownloadToFile,% base "/SciLexer.dll?refresh=" A_Now,SciLexer.dll
	}FileGetSize,SciSize,SciLexer.dll
	if(SciSize=0){
		FileDelete,SciLexer.dll
		m("Unable to download SciLexer.dll","Please re-load AHK Studio")
		ExitApp
	}SplashTextOff
	if(!Settings.SSN("//Highlight")){
		Top:=Settings.Add("Highlight")
		Loop,10
		{
			Random,Color,0xAAAAAA,0xFFFFFF
			Settings.Under(Top,"Color",{index:A_Index,color:RGB(Color)})
		}v.RefreshColors:=1
	}
}
Find_Replace(){
	static
	LastSC:=CSC()
	infopos:=positions.Find("//*/@file",Current(3).file),last:=SSN(infopos,"@findreplace").text,ea:=Settings.EA("//findreplace"),nw:=new GUIKeep(30),value:=[]
	for a,b in ea
		value[a]:=b?"Checked":""
	nw.Add("Text,,Find","Edit,w200 vfind","Text,,Replace","Edit,w200 vreplace","Checkbox,vregex " value.regex ",Regex","Checkbox,vcs " value.cs ",Case Sensitive","Checkbox,vgreed " value.greed ",Greed","Checkbox,vml " value.ml ",Multi-Line","Checkbox,xm vInclude " value.Include ",Current Include Only","Checkbox,xm vcurrentsel hwndcs gcurrentsel " value.currentsel ",In Current Selection","Button,gfrfind Default,&Find","Button,x+5 gfrreplace,&Replace","Button,x+5 gfrall,Replace &All"),nw.Show("Find & Replace"),sc:=CSC(),order:=[],order[sc.2585(0)]:=1,order[sc.2587(0)]:=1,last:=(order.MinIndex()!=order.MaxIndex())?sc.TextRange(order.MinIndex(),order.MaxIndex()):last,Hotkeys(30,{"!e":"frregex"})
	if(ea.regex&&order.MinIndex()!=order.MaxIndex())
		for a,b in StrSplit("\.*?+[{|()^$")
			if(!InStr(last,"\" b))
				StringReplace,last,last,%b%,\%b%,All
	if(!value.currentsel)
		ControlSetText,Edit1,%last%,% HWND([30])
	else
		Gosub,checksel
	ControlSend,Edit1,^a,% HWND([30])
	Gui,1:-Disabled
	return
	checksel:
	sc:=CSC()
	if(sc.2008=sc.2009)
		GuiControl,30:,In Current Selection,0
	else
		Gosub,currentsel
	return
	frregex:
	Send,{!e,up}
	ControlGet,check,Checked,,Button1,% HWND([30])
	check:=!check
	GuiControl,30:,Button1,%check%
	return
	30Close:
	30Escape:
	info:=nw[],fr:=Settings.Add("findreplace")
	for a,b in {regex:info.regex,cs:info.cs,greed:info.greed,ml:info.ml,Include:info.Include,currentsel:info.currentsel}
		fr.SetAttribute(a,b)
	fr:=positions.Find("//*/@file",Current(3).file),fr.SetAttribute("findreplace",info.find),nw.SavePos(),HWND({rem:30})
	if(start!=""&&end!="")
		sc.2160(start,end),start:=end:="",sc.2500(2),sc.2505(0,sc.2006)
	return
	currentsel:
	ControlGet,check,Checked,,In Current Selection,% HWND([30])
	sc:=CSC(),sc.2500(2),sc.2505(0,sc.2006)
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
	info:=nw[],startsearch:=0,sc:=CSC(),stop:=Current(3).file,looped:=0,current:=Current(1),pos:=sc.2008,pre:="O",find:="",find:=info.regex?info.find:"\Q" RegExReplace(info.find, "\\E", "\E\\E\Q") "\E",pre.=info.greed?"":"U",pre.=info.cs?"":"i",pre.=info.ml?"":"m`n",find:=pre ")" find ""
	if(info.currentsel){
		end:=sc.2509(2,start),text:=SubStr(Update({Get:Current(3).File}),start+1,end-start+1),greater:=sc.2008>sc.2009?sc.2008:sc.2009,pos:=greater>start?greater-start:1
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
	if(RegExMatch(text:=Update({Get:Current(3).File}),find,found,sc.2008+1))
		return sc.2160(start:=StrPut(SubStr(text,1,found.Pos(0)),"utf-8")-2,start+StrPut(found.0,"utf-8")-1)
	list:=info.Include?SN(Current(),"self::*"):SN(Current(1),"descendant::file")
	while(current:=list.Item[A_Index-1],ea:=XML.EA(current)){
		if(ea.file!=stop&&startsearch=0)
			continue
		startsearch:=1
		text:=Update({get:ea.file})
		if(pos:=RegExMatch(text,find,found,pos))
			return np:=StrPut(SubStr(text,1,pos-1),"utf-8")-1,tv(CEXML.SSN("//file[@id='" ea.id "']/@tv").text,{start:np,end:np+StrPut(found.0,"utf-8")-1}),WinActivate(nw.id)
		if(ea.file=stop&&looped=1)
			return m("No Matches Found")
		pos:=1
	}current:=Current(1).firstchild,looped:=1
	Goto,frrestart
	return
	FRReplace:
	info:=nw[],sc.2170(0,[NewLines(info.replace)]),Update({sc:sc.2357})
	Goto,frfind
	return
	frall:
	info:=nw[],sc:=CSC(),stop:=Current(3).file,looped:=0,current:=Current(),pos:=sc.2008,pre:="O",find:="",find:=info.regex?info.find:"\Q" RegExReplace(info.find, "\\E", "\E\\E\Q") "\E",pre.=info.greed?"":"U",pre.=info.cs?"":"i",pre.=info.ml?"":"m`n",find:=pre ")" find ""
	if(info.currentsel)
		return pos:=1,end:=sc.2509(2,start),text:=SubStr(Update({Get:Current(3).file}),start+1,end-start),text:=RegExReplace(text,find,info.replace),sc.2190(start),sc.2192(end),sc.2194(StrPut(text,"utf-8")-1,[text]),sc.2500(2),sc.2505(0,sc.2006),sc.2504(start,len:=StrPut(text,"utf-8")-1),end:=start+len
	if(info.Include)
		Goto,frseg
	list:=SN(Current(1),"descendant::file"),All:=Update("get").1,info:=nw[],replace:=NewLines(info.replace)
	while(ll:=list.Item[A_Index-1]){
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
	info:=nw[],sc:=CSC(),pre:="O",find:="",find:=info.regex?info.find:"\Q" RegExReplace(info.find, "\\E", "\E\\E\Q") "\E",pre.=info.greed?"":"U",pre.=info.cs?"":"i",pre.=info.ml?"":"m`n",find:=pre ")" find "",replace:=NewLines(info.replace),sc.2181(0,[RegExReplace(sc.GetText(),find,replace)]),SetPos(SSN(Current(),"@tv").text)
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
		MainWin.NewCtrlPos:={ctrl:nw.hwnd+0,win:HWND(1)}
		MainWin.Delete()
	*/
	return
}
Find(){
	static
	/*
		re-write this to be like Debug in that it pops up from the bottom of this window (or whatever window is current so long as it is a normal edit window)
	*/
	File:=Current(2).File
	if(!FindXML)
		FindXML:=new XML("find"),FindXML.Add("top")
	if(!infopos:=Positions.Find("//main/@file",File))
		infopos:=Positions.Add("main",{file:File},,1)
	last:=SSN(infopos,"@search").text,search:=last?last:"Type in your query here",ea:=Settings.EA("//search/find"),NewWin:=new GUIKeep(5),sc:=CSC(),order:=[]
	value:=[],order[sc.2585(0)]:=1,order[sc.2587(0)]:=1,last:=(order.MinIndex()!=order.MaxIndex())?sc.TextRange(order.MinIndex(),order.MaxIndex()):last
	for a,b in ea
		Value[a]:=b?"Checked":""
	NewWin.Add("Edit,gfindcheck w400 vfind r1,,w","TreeView,w400 h200 AltSubmit gstate,,wh","Checkbox,vregex gfindfocus " value.regex ",&Regex Search,y","Checkbox,vgr x+10 gfindfocus " value.gr ",&Greed,y","Checkbox,xm vcs gfindfocus " value.cs ",&Case Sensitive,y","Checkbox,vsort gfsort " value.sort ",Sort by &Include,y","Checkbox,vallfiles gfindfocus " value.allfiles ",Search in &All Files,y","Checkbox,vacdc gfindfocus " value.acdc ",Auto Close on &Double Click,y","Checkbox,vdaioc " value.daioc ",Disable Auto Insert On Copy,y","Checkbox,vAuto_Show " Value.Auto_Show ",A&uto Show Selected,y","Button,gSearch Default,   Search   ,y","Button,gcomment,Toggle Comment,y"),NewWin.Show("Search"),Hotkeys(5,{"^Backspace":"FindBack"})
	Hotkeys(5,{Up:"FindUp",Down:"FindDown",F1:"FindShowXML",Left:"FindLeft",Right:"FindRight"})
	if(value.regex&&order.MinIndex()!=order.MaxIndex())
		for a,b in StrSplit("\.*?+[{|()^$")
			StringReplace,last,last,%b%,\%b%,All
	ControlSetText,Edit1,%last%,% HWND([5])
	ControlSend,Edit1,^a,% HWND([5])
	Gui,1:-Disabled
	return
	OnClipboardChange:
	if(HWND(5)||HWND(30)){
		win:=HWND(5)?HWND([5]):HWND([30])
		if(win=HWND([5])&&NewWin[].daioc=0)
			ControlSetText,Edit1,%Clipboard%,%win%
		if(WinActive(HWND([30]))&&HWND(30))
			ControlSetText,Edit1,%Clipboard%,%win%
	}return
	FindBack:
	GuiControl,5:-Redraw,Edit1
	ControlSend,Edit1,^+{Left}{Backspace},% HWND([5])
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
		list:=info.allfiles?CEXML.SN("//file"):SN(Current(1),"descendant::file"),TV_Delete()
		pre:="m`nO",pre.=info.cs?"":"i",pre.=info.greed?"":"U",parent:=0,ff:=info.regex?find:"\Q" find "\E"
		while(l:=list.item(A_Index-1),ea:=XML.EA(l)){
			out:=Update({get:ea.File}),pos:=1,r:=0,fn:=ea.File
			SplitPath,fn,File,,,nne
			while(RegExMatch(out,pre ")(.*(" ff ").*$)",Found,pos),pos:=Found.pos(2)+Found.len(2)){
				if(info.Sort&&!FindXML.SSN("//file[@id='" ea.ID "']"))
					PP:=FindXML.Under(Top,"file",{text:fn,id:ea.ID},,1),DoSort:=1
				RegExReplace((str:=SubStr(out,1,Found.Pos(2))),"\R","",count)
				Next:=FindXML.Under((DoSort?PP:top),"info",Obj:={id:ea.ID,text:(Found.2=info.Find?Found.1:Found.2),length:StrPut(Found.2,"UTF-8")-1,found:Found.1,pos:(StartPos:=StrPut(str,"UTF-8")-2),end:StartPos+StrPut(Found.1,"UTF-8")-1,file:ea.File,line:Round(count)+1,filetv:ea.tv})
				for a,b in ["File","Line","Pos","Found"]
					FindXML.Under(Next,"moreinfo",{text:Obj[b],name:b})
				lastl:=fn
			}DoSort:=0
		}WinSetTitle(5,"Find: " FindXML.SN("//info").Length)
		if(TV_GetCount())
			ControlFocus,SysTreeView321
		GuiControl,5:+Redraw,SysTreeView321
		SetTimer("FindLabel",-200)
		GuiControl,5:+gState,SysTreeView321
		all:=FindXML.SN("//*")
		while(aa:=all.item[A_Index-1],ea:=XML.EA(aa)){
			if(ea.text)
				aa.SetAttribute("tv",TV_Add((ea.Name?ea.Name " = ":"") ea.Text,SSN(aa.ParentNode,"@tv").text))
		}Default("SysTreeView321",5)
		if(!Current:=FindXML.SSN("//info[@id='" (ID:=Current(3).ID) "' and @pos<='" sc.2008 "' and @end>='" sc.2008 "']")){
			if(!Current:=FindXML.SSN("//info[@id='" ID "' and @pos>'" sc.2008 "']"))
				if(!Current:=FindXML.SSN("//info[@id='" ID "']"))
					if(!Current:=FindXML.SSN("//info[@id>'" ID "']"))
						Current:=FindXML.SSN("//info")
		}TV_Modify(SSN(Current,"@tv").text,"Select Vis Focus Expand"),Current.SetAttribute("expand",1),Current.ParentNode.SetAttribute("expand",1)
	}else if(Button="jump"){
		ea:=FindXML.EA("//*[@tv='" TV_GetSelection() "']/ancestor-or-self::info"),Default("SysTreeView321",5),tv(ea.filetv),sc.2160(ea.pos,ea.pos+ea.Length),xpos:=sc.2164(0,ea.pos),ypos:=sc.2165(0,ea.pos)
		WinGetPos,xx,yy,ww,hh,% NewWin.ahkid
		WinGetPos,px,py,,,% "ahk_id" sc.sc
		WinGet,trans,Transparent,% NewWin.ahkid
		cxpos:=px+xpos,cypos:=py+ypos
		if(cxpos>xx&&cxpos<xx+ww&&cypos>yy&&cypos<yy+hh)
			WinSet,Transparent,50,% NewWin.ahkid
		else if(trans=50)
			WinSet,Transparent,255,% NewWin.ahk
		SetTimer("CenterSel",-10)
		if(v.Options.Auto_Close_Find)
			return HWND({rem:5})
		WinActivate(HWND([5]))
	}else
		sel:=TV_GetSelection(),TV_Modify(sel,ec:=TV_Get(sel,"E")?"-Expand":"Expand"),SetTimer("FindLabel",-200)
	return
	state:
	if(A_GuiEvent="DoubleClick"){
		Default("SysTreeView321",5)
		if(Node:=FindXML.SSN("//*[@tv='" TV_GetSelection() "']")){
			info:=NewWin[],ea:=XML.EA(Node)
			if(!ea.File)
				return
			if(Current(3).ID!=ea.ID){
				tv(CEXML.SSN("//file[@id='" ea.ID "']/@tv").text)
				WinActivate,% NewWin.ID
				Sleep,200
			}ea:=XML.EA(Node),sc:=CSC(),sc.2160(ea.Pos,ea.Pos+ea.Length)
			if(info.acdc)
				Goto,5Close
			return
	}}else if(Node:=FindXML.SSN("//*[@tv='" A_EventInfo "']")){
		TV_Modify(A_EventInfo,"Select Vis Focus")
	}
	return SetTimer("FindLabel",-200),SetTimer("FindCurrent",-10)
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
	if(Node.NodeName="File")
		return TV_Modify(SSN(Node,"*/@tv").text,"Select Vis Focus")
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
	}}}SetTimer("State",-10)
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
	Default("SysTreeView321",5),sel:=TV_GetSelection()
	Node:=FindXML.SSN("//*[@tv='" sel "']")
	if(!TV_GetCount())
		Buttontext:="Search"
	else if(Node.NodeName="File")
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
				tv(CEXML.SSN("//file[@id='" ea.ID "']/@tv").text)
				WinActivate,% NewWin.ID
				Sleep,200
			}
			CSC().2160(ea.Pos,ea.Pos+ea.Length)
		}
	}
	return
	fsort:
	ControlSetText,,Search,% "ahk_id" NewWin.XML.SSN("//*[@label='Search']/@hwnd").text
	Goto,search
	return
	5Escape:
	5Close:
	ea:=NewWin[],Settings.Add("search/find",{daioc:ea.daioc,acdc:ea.acdc,Auto_Show:ea.Auto_Show,regex:ea.regex,cs:ea.cs,sort:ea.sort,gr:ea.gr,allfiles:ea.allfiles}),foundinfo:="",infopos.SetAttribute("search",ea.find)
	NewWin.SavePos(),HWND({rem:5})
	return
	Comment:
	sc:=CSC()
	Toggle_Comment_Line()
	return
	FindFocus:
	ControlFocus,Edit1,% HWND([5])
	return
}
Fix_Case_In_Current_Include(){
	new Fix_Case_Class()
}Class Fix_Case_Class{
	__New(){
		sc:=CSC(),Words:=sc.GetUni(),AllWords:=Fix_Case_Class.AllWords:=[],Fix_Case_Class.Words:=Words,Pos:=1,NewWin:=Fix_Case_Class.NewWin:=new GUIKeep("Fix_Case_In_Current_Include")
		while(RegExMatch(Words,"OU)\b(\w{2,})\b",Found,Pos),Pos:=Found.Pos(1)+Found.Len(1)){
			if(Found.1~="[A-Za-z]"=0)
				Continue
			if(Pos=LastPos),LastPos:=Pos
				Break
			if(!IsObject(AllWords[Found.1]))
				AllWords[Found.1]:=[]
			if(!RegExMatch(BigList,"\b" Found.1 "\b"))
				AllWords[Found.1].Push(Found.1),BigList.=Found.1 ","
		}NewWin.Add("ListView,w220 h200 vFCFoundWords gFCFoundWords AltSubmit -Multi,Words Found","ListView,x+M w220 h200 vFCDuplicates -Multi,Cases","Edit,xm w440"),NewWin.Default("FCFoundWords")
		NewWin.Add("Button,xm gFCAllDup,All D&uplicates","Button,x+M gFCPopulate,&Only Multiple-Cased Duplicates (Default)","Button,xm gFCSelect,Select &All Selected In Document","Button,xm gFCNext,&Next Selected","Button,x+M gFCDrop,&Drop Current Selection","Button,xm gFCReplace,&Replace"),Fix_Case_Class.Populate(),NewWin.Show("Fix Case In Current Include")
		return
		FCReplace:
		NewWin:=(Fix_Case_Class.NewWin).Default("FCDuplicates"),LV_GetText(Text,LV_GetNext()),sc:=CSC()
		ControlGetText,Value,Edit1,% NewWin.ID
		Text:=Value?Value:LV_GetNext()?Text:""
		if(!Text)
			if(m("There is no replacement Selected. Replace with nothing?","ico:!","btn:ync","def:2")!="Yes")
				return
		Clip:=Clipboard,Clipboard:=Text,sc.2614(1),sc.2179,Clipboard:=Clip
		ControlSetText,Edit1,,% NewWin.ID
		ControlFocus,SysListView321,% NewWin.ID
		return
		FCDrop:
		sc:=CSC(),sc.2671(sc.2575),sc.2606(),sc.2169
		return
		FCNext:
		sc:=CSC(),sc.2606(),sc.2169
		return
		FCSelect:
		Fix_Case_Class.NewWin.Default("FCFoundWords"),LV_GetText(Text,LV_GetNext()),sc:=CSC()
		if(!LV_GetNext())
			return Studio.m("Select a Word to Select")
		Pos:=1,LastPos:=1,Length:=StrPut(Text,"UTF-8")-1
		while(RegExMatch((Words:=Fix_Case_Class.Words),"OUi)\b(" Text ")\b",Found,Pos),Pos:=Found.Pos(1)+Found.Len(1)){
			if(Pos=LastPos),LastPos:=Pos
				Break
			Start:=StrPut(SubStr(Words,1,Found.Pos),"UTF-8")-2
			if(A_Index=1)
				sc.2160(Start,Start+Length)
			else
				sc.2573(Start,Start+Length)
		}return
		FCPopulate:
		Fix_Case_Class.Populate()
		return
		FCFoundWords:
		static LastWord
		if(A_GuiEvent="I"){
			return SetTimer("FCUpdateCurrentList",-50)
			FCUpdateCurrentList:
			Fix_Case_Class.NewWin.Default("FCFoundWords"),LV_GetText(Word,LV_GetNext()),Fix_Case_Class.NewWin.Default("FCDuplicates"),LV_Delete()
			for a,b in Fix_Case_Class.AllWords[Word]
				LV_Add("",b)
			return
		}return
		FCAllDup:
		Fix_Case_Class.Populate(0)
		return
	}Populate(OnlyDifferent:=1){
		this.NewWin.Default("FCFoundWords"),LV_Delete()
		for a,b in Fix_Case_Class.AllWords{
			if(OnlyDifferent){
				if(b.MaxIndex()>1)
					LV_Add("",a)
			}else
				LV_Add("",a)
		}Sleep(100),this.NewWin.Default("FCFoundWords"),LV_Modify(1,"Select Vis Focus")
}}
Fix_Indent(){
	sc:=CSC()
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
	sc:=CSC(),find:=line:=sc.2166(sc.2008)
	if(sc.2225(line)>=0){
		while((find:=sc.2225(find))>=0)
			line:=find
		FixLines(line,sc.2224(line,-1)-line),sc.Enable(1)
	}else{
		start:=line
		while((above:=sc.2225(--start))<0){
			if(start<=0)
				Break
		}
		StartLine:=(sl:=sc.2224(above,-1))>=0?sl:0,start:=line,lastline:=sc.2154-1
		while((below:=sc.2225(++start))<0)
			if(start>=lastline)
				Break
		below:=below>0?below:lastline,FixLines(StartLine,below-StartLine,0),sc.Enable(1)
	}
}
FixLines(line,total,base:=""){
	tick:=A_TickCount,sc:=CSC(),ind:=Settings.Get("//tab",5),startpos:=sc.2008,code:=StrSplit((codetext:=sc.GetUNI()),"`n"),sc.Enable(),chr:="K",indentation:=sc.2121,lock:=[],block:=[],aaobj:=[],code:=StrSplit(codetext,"`n"),specialbrace:=skipcompile:=aa:=ab:=braces:=0,end:=total+line,SpecialIndent:=0
	if(base="")
		base:=Round(sc.2127(line)/ind)
	IndentRegex:=Keywords.IndentRegex[Current(3).ext],IndentRegex:=IndentRegex?IndentRegex:"if|else|for|while"
	if(Current(3).ext="xml")
		return
	Loop,% code.MaxIndex(){
		if(A_Index-1>total)
			Break
		OText:=Text:=RegExReplace(Trim(code[(a:=line+A_Index)],"`t "),"U)(\x22.*\x22)")
		if(Text~="i)\Q* * * Compile_AH" Chr "\E"){
			skipcompile:=skipcompile?0:1
			Continue
		}if(skipcompile)
			Continue
		FirstTwo:=SubStr(Text,1,2)
		if(SubStr(Text,1,1)=";"&&(FirstTwo!=";{"||FirstTwo!=";}")&&v.Options.Auto_Indent_Comment_Lines!=1)
			Continue
		si:=SpecialIndent
		if(Pos:=Instr(OText,";}")){
			SpecialText:=SubStr(OText,Pos+1)
			while((Char:=SubStr(SpecialText,A_Index,1))~="(\s|\})"){
				if(Char="}"&&SpecialIndent>0)
					SpecialIndent--
			}
		}if(InStr(Text,Chr(59))){
			if(Pos:=Text~="(\s+\x3B|^\x3B)")
				Text:=Trim(SubStr(Text,1,Pos-1))
		}first:=SubStr(Text,1,1),last:=SubStr(Text,0,1),ss:=(Text~="i)^\s*(&&|\bOR\b|\bAND\b|\.|\,|\|\||:|\?)\s*"),indentcheck:=(RegExMatch(Text,"iA)}*\s*[^#]?\b(" IndentRegex ")\b",string)&&IndentRegex)
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
		if(!(ss&&v.Options.Manual_Continuation_Line)&&sc.2127(a-1)!=tind+(base*ind)+Round(SpecialIndent*Ind)){
			sc.2126(a-1,tind+base*ind+Round(SpecialIndent*Ind)),Updated:=1
		}
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
		aaobj[cur]:=aa,special:=0
		if(Pos:=InStr(OText,";{")){
			SpecialText:=SubStr(OText,Pos+1)
			while((Char:=SubStr(SpecialText,A_Index,1))~="(\s|\{)")
				if(Char="{")
					SpecialIndent++
		}
	}
	if(Updated)
		Update({sc:sc.2357}),Edited()
	SetStatus(A_ThisFunc " Process Time: " A_TickCount-tick "ms @ " A_TickCount " lines: " total,3)
}
/*
	Focus(a*){
		if(a.1=0){
			sc:=CSC()
			if(sc.sc=MainWin.tnsc.sc)
				CSC(2),t("TOP! HERE!")
		}
		if(a.1=1&&A_Gui=1){
			CSC().2400
			t("HERE!","time:1")
			if(a&&v.Options.Check_For_Edited_Files_On_Focus=1)
				Check_For_Edited()
			return 0
		}
	}
*/
Fold_All(){
	CSC().2662
}
UnFold_All(){
	CSC().2662(1)
}
Toggle_Fold_All(){
	CSC().2662(2)
}
Toggle_Fold_Current_Block(){
	sc:=CSC(),Line:=sc.2166(sc.2008)
	if(!sc.2230(Line))
		sc.2231(Line)
	else if((Parent:=sc.2225(Line))>=0){
		sc.2231(Parent),sc.2025(sc.2136(Parent))
	}else
		sc.2231(Line)
}
Fold_Current_Level(){
	sc:=CSC(),level:=sc.2223(sc.2166(sc.2008))&0xff,level:=level-1>=0?level-1:level,Fold_Level_X(Level)
}
Unfold_Current_Level(){
	sc:=CSC(),level:=sc.2223(sc.2166(sc.2008))&0xff,Unfold_Level_X(Level)
}
Fold_Level_X(Level=""){
	sc:=CSC()
	if(level="")
		level:=InputBox(sc.sc,"Fold Levels","Enter a level to fold`n0-100")
	current:=0
	while((current<sc.2154)){
		fold:=sc.2223(current)
		if (fold&0xff=level)
			sc.2237(current,0),current:=sc.2224(current,fold)
		current+=1
	}
}
Toggle_Fold(){
	sc:=CSC(),sc.2231(sc.2166(sc.2008))
}
Unfold_Level_X(Level=""){
	sc:=CSC()
	if(level="")
		level:=InputBox(sc.sc,"Fold Levels","Enter a level to Un-fold`n0-100")
	if(ErrorLevel)
		return
	fold=0
	while(sc.2618(fold)>=0,fold:=sc.2618(fold)){
		lev:=sc.2223(fold)
		if(lev&0xff=level)
			sc.2237(fold,1)
		fold++
	}
}
FoldParent(){
	sc:=CSC(),line:=find:=sc.2166(sc.2008)
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
Full_Backup(Remove:=0){
	SplashTextOn,300,100,Backing up...,Please wait, This may take some time if it has been a while since your last full backup.
	Save(),sc:=CSC(),Current:=Current(2).File,Dir:=SplitPath(Current).Dir
	if(Remove){
		Loop,%Dir%\AHK-Studio Backup\*.*,2
			FileRemoveDir,%A_LoopFileFullPath%,1
	}Backup:=Dir "\AHK-Studio Backup\Full Backup " A_Now
	FileCreateDir,%Backup%
	if(v.Options.Full_Backup_All_Files){
		Loop,%Dir%\*.*,0,1
		{
			if(InStr(A_LoopFileName,".exe")||InStr(A_LoopFileName,".dll")||InStr(A_LoopFileDir,Dir "\AHK-Studio Backup"))
				Continue
			File:=Trim(RegExReplace(A_LoopFileFullPath,"i)\Q" Dir "\E"),"\")
			SplitPath,File,Filename,DDir
			if(!FileExist(Backup "\" DDir))
				FileCreateDir,% Backup "\" DDir
			NDir:=DDir?Backup "\" DDir:Backup
			FileCopy,%A_LoopFileFullPath%,%NDir%\%Filename%
		}
	}else{
		AllFiles:=SN(Current(1),"descendant::file/@file")
		while(af:=AllFiles.Item[A_Index-1]){
			File:=Trim(RegExReplace(af.Text,"i)\Q" Dir "\E"),"\")
			SplitPath,File,Filename,DDir
			if(!FileExist(Backup "\" DDir))
				FileCreateDir,% Backup "\" DDir
			NDir:=DDir?Backup "\" DDir:Backup
			FileCopy,% af.Text,%NDir%\%Filename%
	}}Loop,%Dir%\AHK-Studio Backup\*.*,2
		if(!RegExMatch(A_LoopFileFullPath,"Full Backup \d{14}"))
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
GetClass(class,current:=""){
	current:=current?current:Current(5),root:=SSN(current,"info[@type='Class' and @text='" class.baseclass "']")
	if(class.baseclass!=class.inside)
		nest:=SSN(current,"descendant::info[@type='Class' and @text='" class.inside "']")
	return nest?nest:root
}
GetClassText(EA,SearchText,Type:="Class",ReturnClass:=0){
	FileText:=Update({Get:EA.File})
	SearchText:=Regex:=GetSearchRegex(v.OmniFind[EA.Lang][Type].Regex,SearchText)
	if(RegExMatch(FileText,SearchText,found,IsObject(search)?Search.Pos(0):1)){
		start:=Pos:=Found.Pos(1)
		while(RegExMatch(FileText,"OUm`n)((?<SkipClose>^\s*\Q*/\E)|(?<SkipOpen>^\s*\Q/*\E)|(?<Close>^\s*}.*((\{)\s*(;.*)*)*)$)|((?<Open>.*\{)(\s+;.*|\t\w?\d?.*)*(\s*)*$)",found,Pos)),Pos:=found.Pos(0)+found.len(0){
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
			return {start:start,length:(alt?found.Pos(1):found.Pos(0)+found.len(0))-(start-1)}
		if(brace>0)
			return SubStr(FileText,start)
		return SubStr(FileText,start,(alt?found.Pos(1):found.Pos(0)+found.len(0))-(start-1))
	}
}
GetControl(ctrl){
	if(!node:=MainWin.gui.SSN("//*[@hwnd='" ctrl "']"))
		node:=MainWin.gui.SSN("//*[@hwnd='" ctrl+0 "']")
	return node
}
GetCurrentClass(){
	ScanFile.RemoveComments(Current(3),,1),Text:=ScanFile.CurrentText,b:=v.OmniFind[Current(3).Lang].Class,Pos:=LastPos:=1
	if(!InStr(Text,Chr(127))||!b.Open)
		return
	while(RegExMatch(Text,b.regex,Found,Pos),Pos:=Found.Pos(0)+Found.Len(0)){
		if(Pos=LastPos)
			Break
		LastPos:=Pos,b.Text:=Text,Text1:=SearchFor(b,Found.Pos(1)).Text
		if(InStr(Text1,Chr(127))){
			Text:=Text1,Pos:=1,Outer:=Found.1,b.Text:=Text
			while(RegExMatch(Text,b.regex,Found,Pos),Pos:=Found.Pos(1)+Found.Len(1))
				if(InStr(SearchFor(b,Found.Pos(1)).Text,Chr(127)))
					return Found.1
			return Outer
}}}
GetExtensionList(Language){
	Language:=Format("{:L}",Language),all:=Settings.SN("//Extensions/Extension"),Ext:=[]
	while(aa:=all.item[A_Index-1],ea:=XML.EA(aa))
		Lang:=ea.Language?Settings.SSN("//Languages/" ea.Language "/@name").text:"",Ext[Lang?Lang:"Personal File Extensions"].="*." aa.text "; "
	for a,b in Ext
		b:=Trim(b,"; "),(a="Language")?First:=a " (" b ")|":List.=a " (" b ")" "|"
	return First List "Text Files (*.txt)|All Files (*.*)"
}
GetFileNode(Node,Att:=""){
	List:=SN(Node,"ancestor-or-self::file"),Node:=List.Item[List.Length-1]
	return Att?SSN(Node,"@" Att).Text:Node
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
GetID(Clear:=0){
	static ID
	if(Clear)
		return ID:=0
	if(!ID)
		ID:=Round(CEXML.SSN("//*/@id[not(.<//*/@id)][1]").text)
	return ++ID
}
GetInclude(){
	main:=Current(2).file,sc:=CSC()
	SplitPath,main,,dir
	FileSelectFile,filename,,%dir%,Select a file to include,*.ahk
	if(ErrorLevel||filename="")
		return
	newfile:=filename~="\.ahk$"?filename:filename ".ahk"
	Relative:=RelativePath(SSN(Current(),"@file").text,newfile)
	Encode(" " Relative,return),sc.2003(sc.2008,&return)
	TVC.Default(1)
	if(!FileExist(newfile)){
		SplitPath,newfile,,dir
		if(!FileExist(dir))
			FileCreateDir,%dir%
		FileAppend,,%newfile%,UTF-8
	}Save(),Extract(GetMainNode(main)),ScanFiles(),FEUpdate(1)
}
GetLanguage(sc:=""){
	sc:=sc?sc:CSC(),VarSetCapacity(Language,4),sc.4012(0,&Language)
	return StrGet(&Language,"UTF-8")
}
GetMainNode(File,Parent:=""){
	if(Parent){
		if(!Node:=CEXML.Find(Parent,"descendant::main/file/@file",File))
			Node:=CEXML.Under(Parent,"main",{file:File,id:GetID()})
	}else{
		if(!Node:=CEXML.Find("//files/main/@file",File))
			Node:=CEXML.Under(CEXML.Add("files"),"main",{file:File,id:GetID()})
	}
	return Node
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
GetOTB(search){
	sc:=CSC(),FileText:=sc.GetUNI(),find:=v.OmniFindText.Class,searchtext:=find.1 (IsObject(search)?search.2:search) find.2
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
	sc:=CSC(),cf:=Current(3).file
	if(!CEXML.SSN("//*[@sc='" sc.2357 "']"))
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
	Rem:=SSN(Node,"Highlight"),Rem.ParentNode.RemoveChild(Rem)
	End:=sc.2006,List:="",Last:=""
	Loop,10
	{
		Pos:=-1,Indicator:=A_Index+8
		while(Pos:=sc.2509(Indicator,Pos+1)){
			if(LastPos=Pos),LastPos:=Pos
				Break
			if(Mod(A_Index,2))
				Start:=Pos
			else
				Positions.Under(Node,"Highlight/Highlight",{index:Indicator,start:Start,len:Abs(Pos-Start)})
		}
	}
	return Node
}
GetRange(start,otext){
	start:=start-3>=0?start-3:0
	Loop,6
		text.=otext[start+(A_Index-1)]
	return text
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
			if(Open<=0){
				End:=A_Index
				Regex:=SubStr(FindSearch,1,Start) Text SubStr(FindSearch,End)
				Break
	}}}if(!Regex){
		m("No Text found in the regex")
		Exit
	}Return Regex
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
	sc:=CSC()
	value:=InputBox(sc.sc,"Go To Line","Enter the Line Number you want to go to max = " sc.2154,sc.2166(sc.2008)+1)
	if(RegExMatch(value,"\D")||value="")
		return m("Please enter a line number")
	sc.2025(sc.2128(value-1))
}
Google_Search_Selected(){
	sc:=CSC(),Text:=sc.GetSelText()
	if(!Text)
		return m("Please select some Text to search for")
	if(Text~="i)^http(s)?://")
		Run,%Text%
	else
		Run,https://www.google.com/search?q=%Text%
}
Goto(){
	Goto:
	sc:=CSC(),InsertAll(",",1),list:=SN(CEXML.Find("//file/@file",Current(3).file),"descendant::info[@type='Label']"),labels:=""
	while(ll:=list.item[A_Index-1])
		labels.=CEXML.EA(ll).text " "
	Sort,labels,D%A_Space%
	if(Trim(Labels))
		sc.2100(0,Trim(labels))
	return
}
GotoPos(caret,pos){
	sc:=CSC(),sc.2584(caret,pos),sc.2586(caret,pos)
}
Gui(){
	v.startup:=1,this:=MainWin:=New MainWindowClass(1),ea:=Settings.EA("//theme/descendant::*[@style=32]"),win:=1,Plug()
	Gui,Splash:Destroy
	Gui,Splash:Default
	Gui,Color,0x000001,0x000001
	Gui,-Caption +hwndSplash
	Gui,Add,Picture,w100 h100,ahkstudio.ico
	Gui,Show
	WinSet,TransColor,0x000001,ahk_id%Splash%
	Gui,1:Default
	if(!this.Gui.SSN("//control"))
		Gui,1:Show,Hide
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
	if((All:=CEXML.SN("//file")).Length){
		Opened:=1
	}else{
		while(oo:=open.item[A_Index-1])
			t("Opening: " oo.Text,"Please Wait"),Extract(GetMainNode(oo.Text)),Opened:=1
	}t(),FEUpdate()
	if(!Opened)
		New("","",0),FocusNew:=1
	Code_Explorer.Refresh_Code_Explorer(),FEList:=CEXML.SN("//main"),Hotkeys(),SetTimer("ScanFiles",-400)
	if((list:=this.Gui.SN("//win[@win='" win "']/descendant::control")).length){
		this.Rebuild(list),ea:=this.gui.EA("//*[@type='Tracked Notes']"),this.SetWinPos(ea.hwnd,ea.x,ea.y,ea.w,ea.h,ea),this.Theme(),all:=MainWin.gui.SN("//*[@type='Scintilla' and @file]")
		while(aa:=all.item[A_Index-1]),ea:=XML.EA(aa){
			CEXML.Find("//file/@file",ea.file).SetAttribute("sc",s.ctrl[ea.hwnd].2357)
			if(ea.file){
				pea:=XML.EA(nn:=positions.Find("//file/@file",ea.file))
				if(pea.start=""||pea.end="")
					SetPos({scroll:0,start:0,end:0,sc:ea.hwnd})
				else
					SetPos({scroll:pea.scroll,start:pea.start,end:pea.end,sc:ea.hwnd})
		}}if(last:=this.Gui.SSN("//*[@last]/@hwnd").text)
			s.ctrl[last].2400
		ObjRegisterActive(PluginClass)
		SetTimer,SetTN,-600
		TVC.Modify(1,"",TVC.Selection(1),"Vis")
		/*
			m(TVC.Selection(1))
		*/
		if(FocusNew)
			SetTimer,FocusNew,-100
		if(Node:=CEXML.Find("//file/@file",v.OpenFile))
			tv(SSN(Node,"@tv").text)
		return this
	}if(Node:=CEXML.Find("//file/@file",v.OpenFile))
		tv(SSN(Node,"@tv").text)
	this.qfhwnd:=this.QuickFind(),sc:=new s(1,{pos:"x0 y0 w100 h100"}),this.Add(sc.sc,"Scintilla"),sc.2277(v.Options.End_Document_At_Last_Line),this.test:=sc.sc,this.Pos(),Redraw(),ObjRegisterActive(PluginClass)
	/*
		if(FocusNew)
			tv(CEXML.SSN("//*[@untitled]/@tv").text)
	*/
	SetTimer,SetTN,-600
	return
	FocusNew:
	tv(CEXML.SSN("//*[@untitled]").text)
	return
	SetTN:
	/*
		ControlGetFocus,focus,% HWND([1])
		ControlGet,hwnd,hwnd,,%focus%,% HWND([1])
	*/
	TNotes.Populate(),TNotes.SetNode(),TNotes.SetText(),TVC.Enable(3)
	MarginWidth(),VVersion:=new XML("versions",(FileExist("lib\Github.xml")?A_ScriptDir "\lib\Github.xml":A_ScriptDir "\lib\Versions.xml"))
	SetTimer,ScanWID,-10
	SetupEnter(1),CSC({Set:1})
	MainWin.Size(1)
	all:=menus.SN("//*[@startup]")
	while(aa:=all.item[A_Index-1],ea:=XML.EA(aa)){
		if(FileExist(A_ScriptDir "\" ea.plugin))
			Run,% Chr(34) A_ScriptDir "\" ea.plugin Chr(34)
		else
			aa.ParentNode.RemoveChild(aa)
	}
	return
}
Exit:
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
		this.XML:=new XML("gui"),this.XML.Add("window",{name:win}),this.gui:=[],this.sc:=[],this.hwnd:=hwnd,this.con:=[],this.AHKID:=this.id:="ahk_id" hwnd,this.win:=win,this.Table[win]:=this,this.var:=[],this.classcount:=[]
		for a,b in {border:A_OSVersion~="^10"?3:0,caption:DllCall("GetSystemMetrics",int,4,"int")}
			this[a]:=b
		Gui,%win%:+LabelGUIKeep.
		Gui,%win%:Default
	}Add(info*){
		static
		if(!info.1){
			var:=[]
			Gui,% this.Win ":Submit",Nohide
			for a,b in this.var{
				if(b.Type="s")
					Var[a]:=b.sc.GetUNI()
				else
					var[a]:=%a%
			}return var
		}for a,b in info{
			i:=StrSplit(b,","),newpos:=""
			if(i.1="ComboBox")
				WinGet,ControlList,ControlList,% this.ID
			if(i.1="s"){
				Pos:=RegExReplace(i.2,"OU)\s*\b(v.+)\b")
				sc:=new s(1,{Pos:Pos}),hwnd:=sc.sc
			}else
				Gui,% this.win ":Add",% i.1,% i.2 " hwndhwnd",% i.3
			if(RegExMatch(i.2,"U)\bg(.*)\b",Label))
				Label:=Label1
			if(RegExMatch(i.2,"U)\bv(.*)\b",var))
				this.var[var1]:={hwnd:HWND,type:i.1,sc:sc,label:Label},Var:=var1
			this.con[hwnd]:=[]
			if(i.4!="")
				this.con[hwnd,"pos"]:=i.4,this.resize:=1
			if(i.5)
				this.Static.Push(hwnd)
			Name:=Var1?Var1:Label
			if(i.1="ListView"||i.1="TreeView")
				this.All[Name]:={HWND:HWND,Name:Name,Type:i.1,label:Label,ID:"ahk_id" HWND}
			if(i.1="ComboBox"){
				WinGet,ControlList2,ControlList,% this.ID
				Obj:=StrSplit(ControlList2,"`n"),LeftOver:=[]
				for a,b in Obj
					LeftOver[b]:=1
				for a,b in Obj2:=StrSplit(ControlList,"`n")
					LeftOver.Delete(b)
				for a in LeftOver{
					if(!InStr(a,"ComboBox")){
						ControlGet,Married,HWND,,%a%,% this.ID
						this.XML.Add("Control",{hwnd:Married,label:Label,id:"ahk_id" Married+0,name:Name,type:"Edit"},,1)
					}
				}
				
			}
			New:=this.XML.Add("Control",{hwnd:HWND,id:"ahk_id" HWND,name:Name,type:i.1,label:Label},,1)
			/*
				m("Name: " Name,"Var1: " Var1,"Label: " Label,"HERE!","",New.xml)
			*/
	}}Close(a:=""){
		this:=GUIKeep.table[A_Gui]
		if(IsFunc(func:=A_Gui "Close"))
			return %func%()
		else if(IsLabel(label:=A_Gui "Close")){
			SetTimer,%label%,-1
		}else
			this.SavePos(),this.Exit()
	}Current(XPath,Number){
		Node:=Settings.SSN(XPath)
		all:=SN(Node.ParentNode,"*")
		while(aa:=all.item[A_Index-1])
			(A_Index=Number?aa.SetAttribute("last",1):aa.RemoveAttribute("last"))
	}Default(Name:=""){
		Gui,% this.Win ":Default"
		ea:=this.XML.EA("//Control[@name='" Name "']")
		if(ea.Type~="TreeView|ListView")
			Gui,% this.Win ":" ea.Type,% ea.HWND
	}Disable(Label,Disable:=1){
		ea:=XML.EA(Node:=this.XML.SSN("//*[@label='" Label "']"))
		if(Disable)
			GuiControl,% this.Win ":Disable",% ea.HWND
		else
			GuiControl,% this.Win ":Enable",% ea.HWND
	}DropFiles(filelist,ctrl,x,y){
		df:="DropFiles"
		if(IsFunc(df))
			%df%(filelist,ctrl,x,y)
	}Enable(Label,Enable:=1){
		ea:=XML.EA(Node:=this.XML.SSN("//*[@label='" Label "']"))
		if(Enable)
			GuiControl,% this.Win ":+g" Label,% ea.HWND
		else
			GuiControl,% this.Win ":+g",% ea.HWND
	}Escape(){
		this:=GUIKeep.table[A_Gui]
		KeyWait,Escape,U
		if(IsFunc(func:=A_Gui "Escape"))
			return %func%()
		else if(IsLabel(label:=A_Gui "Escape"))
			SetTimer,%label%,-1
		else
			this.SavePos(),this.Exit()
	}Exit(){
		this.SavePos(),hwnd({rem:this.win})
	}GetCtrl(Name,Value:="hwnd"){
		return this.All[Name]
	}GetCtrlXML(Name,Value:="hwnd"){
		return Info:=this.XML.SSN("//*[@name='" Name "']/@" Value).text
	}GetDisplays(){
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
	}GetPos(){
		Gui,% this.win ":Show",AutoSize Hide NA
		WinGet,cl,ControlListHWND,% this.ahkid
		pos:=this.WinPos(),ww:=pos.w,wh:=pos.h,flip:={x:"ww",y:"wh"}
		for index,hwnd in StrSplit(cl,"`n"){
			obj:=this.Gui[hwnd]:=[]
			ControlGetPos,x,y,w,h,,ahk_id%hwnd%
			for c,d in StrSplit(this.con[hwnd].pos)
				d~="w|h"?(obj[d]:=%d%-w%d%):d~="x|y"?(obj[d]:=%d%-(d="y"?wh+this.Caption+this.Border:ww+this.Border))
		}
		Gui,% this.win ":+MinSize"
	}Hotkeys(Info){
		Hotkey,IfWinActive,% this.ID
		for a,b in Info
			Try
				Hotkey,%a%,%b%,On
	}SavePos(){
		if(!top:=Settings.SSN("//gui/position[@window='" this.win "']"))
			top:=Settings.Add("gui/position",,,1),top.SetAttribute("window",this.win)
		top.text:=this.WinPos().text
	}SetText(Control,Text:=""){
		if((sc:=this.Var[Control].sc).sc){
			Len:=VarSetCapacity(tt,StrPut(Text,"UTF-8")-1)
			StrPut(Text,&tt,Len,"UTF-8")
			sc.2181(0,&tt)
		}else{
			GuiControl,% this.Win ":",% this.GetCtrlXML(Control),%Text%
		}
	}SetValue(Control,Value){
		GuiControl,% this.Win ":",% this.XML.SSN("//*[@var='" Control "']/@hwnd").text,%Value%
	}SetWinPos(){
		DllCall("SetWindowPos",int,ctrl,int,0,int,x,int,y,int,w,int,h,uint,(ea.type~="Project Explorer|Code Explorer|QF")?0x0004|0x0010|0x0020:0x0008|0x0004|0x0010|0x0020),DllCall("RedrawWindow",int,ctrl,int,0,int,0,uint,0x401|0x2)
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
		while(this:=GUIKeep.Showlist.pop()){
			position:=(node:=Settings.SSN("//gui/position[@window='" this.win "']")).text,position:=position?position:defpos,win:=[]
			for a,b in ["x","y","w","h"]
				RegExMatch(position,"Oi)" b "(-?\d*)\b",found),win[b]:=found.1
			if(!Displays.SSN("//*[(@l<" win.x " or @l<" win.x+win.w ") and @r>" win.x " and (@t<=" win.y " or @t<=" win.y+win.h ") and @b>" win.y "]")){
				position:="xCenter yCenter"
				if(win.w)
					position.=" w" win.w
				if(win.h)
					position.=" h" win.h
			}Mon:=Monitors()
			if(Win.x<Mon.Left.MinIndex()||Win.y<Mon.Top.MinIndex()){
				Position:="xCenter yCenter"
			}NA:=this.NA?"NA":""
			Gui,% this.win ":Show",% position " " pos " " NA,% this.name
			if(sel)
				SendMessage,0xB1,%sel%,%sel%,Edit1,% this.id
			if(this.resize!=1)
				Gui,% this.win ":Show",AutoSize NA
			this.Size()
			if(!NA)
				WinActivate,% this.id
		}return
	}Size(){
		if(!this.Gui)
			this:=GUIKeep.table[A_Gui]
		pos:=this.WinPos()
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
		CEXML.Under(node,"header",{cetv:(header:=TVC.Add(2,type,SSN(node,"@cetv").text,"Sort")),type:type})
	return header
}
Highlight_Selected_Area(){
	static
	NewWin:=new GUIKeep("Highlight_Selected_Area")
	if(!Settings.SSN("//Highlight")){
		Top:=Settings.Add("Highlight")
		Loop,10
		{
			Random,Color,0xAAAAAA,0xFFFFFF
			Settings.Under(Top,"Color",{index:A_Index,color:RGB(Color)})
	}}NewWin.Add("ListView,w250 r10 gShowHighlightColor1 AltSubmit,Highlight Index|Highlight Color"
			,"Progress,w250 h100 vProgress,100"
			,"Button,gSetHighlightColor1 Default,Set Highlight Color")
	All:=Settings.SN("//Highlight/Color")
	while(aa:=All.Item[A_Index-1],ea:=XML.EA(aa))
		LV_Add("",ea.Index,ea.Color)
	return LV_Modify(1,"Select Vis Focus"),NewWin.Show("Highlight Selected Area")
	ShowHighlightColor1:
	NewWin.Default("ShowHighlightColor"),LV_GetText(Color,LV_GetNext(),2)
	GuiControl,% "Highlight_Selected_Area:+c" RGB(Color),% NewWin.GetCtrlXML("Progress","hwnd"),100
	return
	SetHighlightColor1:
	NewWin.Default("Progress"),Index:=Settings.SSN("//Highlight/Color[@index='" LV_GetNext() "']/@index").text,Selections:=[],sc:=CSC()
	Loop,% sc.2570
		Selections.Push({Start:sc.2585(A_Index-1),End:sc.2587(A_Index-1)})
	for a,b in Selections
		if((Length:=b.End-b.Start)>0)
			sc.2500(Index+8),sc.2504(b.Start,b.End-b.Start)
	return
}
Highlight_to_Matching_Brace(){
	sc:=CSC()
	if((start:=sc.2353(sc.2008-1))>0)
		return sc.2160(start,sc.2008)
	Else if((start:=sc.2353(sc.2008))>0)
		sc.2160(start+1,sc.2008)
}
class HistoryClass{
	__New(){
		this.XML:=new XML("History")
		return this
	}Add(ea,sc){
		if(!ea.ID)
			return
		if(!ea.sc)
			return
		if(!Top:=this.XML.SSN("//sc[@sc='" sc.sc "']"))
			Top:=this.XML.Add("sc",{sc:sc.sc},,1)
		Back:=History.GetBack(Top),Forward:=History.GetForward(Top),Forward.ParentNode.RemoveChild(Forward)
		if(!HistoryItem:=SSN(Top,"descendant::item[@id='" ea.ID "' and @start='" sc.2143 "' and @end='" sc.2145 "' and @scroll='" sc.2152 "']"))
			this.XML.Under(Back,"item",{id:ea.ID,start:sc.2143,end:sc.2145,scroll:sc.2152,time:A_Now A_MSec})
	}ForwardBack(){
		Back:
		Forward:
		Direction:=A_ThisLabel="Back"?"back":"forward",sc:=CSC(),Top:=History.XML.SSN("//sc[@sc='" sc.sc "']"),ea:=Current(3),Under:=History["Get" (A_ThisLabel="Back"?"Forward":"Back")](Top)
		if(!Node:=SSN(Top,Direction "/item[last()]"))
			return
		if(!HistoryItem:=SSN(Top,"descendant::item[@id='" ea.ID "' and @start='" sc.2143 "' and @end='" sc.2145 "' and @scroll='" sc.2152 "']")){
			New:=History.XML.Under(Under,"item",{id:ea.ID,start:sc.2143,end:sc.2145,scroll:sc.2152,time:A_Now A_MSec}),Under.AppendChild(Node)
			if(Direction="forward")
				Node.ParentNode.InsertBefore(Node,New),Node:=SSN(Top,Direction "/item[last()]")
			nea:=XML.EA(Node)
		}else{
			if(SSN(HistoryItem,"ancestor::" Direction))
				Under.AppendChild(HistoryItem),Node:=SSN(Top,Direction "/item[last()]"),Under.AppendChild(Node)
			Under.AppendChild(Node),nea:=XML.EA(Node)
		}if(Node.xml)
			tv(CEXML.SSN("//*[@id='" nea.ID "']/@tv").text,"NoTrack"),Sleep(100),sc.2613(nea.scroll),sc.2160(nea.Start,nea.End)
		return
	}ForwardBackFile(){
		File_History_Forward:
		File_History_Back:
		sc:=CSC(),ea:=Current(3),Top:=History.XML.SSN("//sc[@sc='" sc.sc "']")
		if(!HistoryItem:=SSN(Top,"descendant::item[@id='" ea.ID "' and @start='" sc.2143 "' and @end='" sc.2145 "' and @scroll='" sc.2152 "']"))
			New:=History.XML.Under(Under,"item",{id:ea.ID,start:sc.2143,end:sc.2145,scroll:sc.2152,time:A_Now A_MSec}),Under.AppendChild(Node)
		Current:=History["Get" (A_ThisLabel="File_History_Back"?"Back":"Forward")](Top),Under:=History["Get" (A_ThisLabel="File_History_Back"?"Forward":"Back")](Top),Last:=SSN(Current,"item[last()]"),Order:=[],OID:=ID:=SSN(Last,"@id").text,Track:=A_ThisLabel="File_History_Back"?"Back":"Forward"
		if(!SN(Current,"item").length)
			return m("Nothing to go " Track " to.")
		if((List:=SN(Last,"preceding-sibling::*[@id!='" ID "']")).Length){
			Node:=List.Item[List.Length-1],MoveID:=SSN(Node,"@id").text
			While(ll:=List.Item[List.Length-A_Index],ea:=XML.EA(ll)){
				if(ea.ID!=MoveID)
					Break
				First:=ll
			}if(Track="Forward")
				Node:=First
			while(First)
				Order.InsertAt(1,First),First:=First.NextSibling
		}else if(Last)
			Under.AppendChild(Last),Node:=Last
		else
			m("Nothing to go " Track " to.")
		for a,b in Order
			Under.AppendChild(b)
		nea:=XML.EA(Node)
		if(Node.xml)
			tv(CEXML.SSN("//*[@id='" nea.ID "']/@tv").text,"NoTrack"),Sleep(100),sc.2613(nea.scroll),sc.2160(nea.Start,nea.End)
		return
	}GetBack(Top){
		if(!Back:=SSN(Top,"descendant::back"))
			Back:=this.XML.Under(Top,"back")
		return Back
	}GetForward(Top){
		if(!Forward:=SSN(Top,"forward"))
			Forward:=History.XML.Under(Top,"forward")
		return Forward
	}Remove(ea){
		while(hh:=History.XML.SSN("//*[@id='" ea.ID "']"))
			hh.ParentNode.RemoveChild(hh)
	}
}
HltLine(){
	static ranges:=[]
	if(!v.Options.Highlight_Current_Area)
		return
	sc:=CSC(),line:=sc.2166(sc.2008)
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
	Hotkey,IfWinActive,% HWND([win])
	for a in LastHotkeys[win]
		Hotkey,%a%,HotkeyLabel,Off
	LastHotkeys.Delete(win)
	if(!keys){
		Hotkeys:=Menus.SN("//@hotkey")
		while(hh:=Hotkeys.item[A_Index-1]),ea:=XML.EA(hh){
			if(hh.text="!f")
				SetHot:=1
			if(hh.text)
				Try{
					Hotkey,% hh.text,HotkeyLabel,On
					LastHotkeys[win,hh.text]:=1
				}
		}
		if(!SetHot)
			Hotkey,!f,ShowFileMenu,On
		for a,b in {Delete:"Delete",Backspace:"Backspace","~Escape":"Escape","^a":"SelectAll","^v":"Paste",WheelLeft:"ScrollWheel",WheelRight:"ScrollWheel","~Ctrl":"ToggleDuplicate"}{
			Try
				Hotkey,%a%,%b%,On
	}}else{
		for a,b in keys{
			Try{
				if(!a)
					Continue
				Hotkey,%a%,Associate,On
				LastHotkeys[win,a]:=1,Associate[HWND(win),a]:=b
	}}}
	for a,b in ["^R","^E"]{
		if(!menus.SSN("//*[@hotkey='" b "']"))
			Try
				Hotkey,%b%,DeadEnd,On
	}
	Hotkey,RButton,RButton,On
	Hotkey,IfWinActive
	return
	ShowFileMenu:
	KeyWait,Alt,U
	PostMessage,0x112,0xF100,0x46,,A
	return
	Associate:
	action:=Associate[WinExist("A"),A_ThisHotkey]
	SetTimer,%action%,-1
	return
	HotkeyLabel:
	clean:=menus.SSN("//*[@hotkey='" A_ThisHotkey "']/@clean").text
	if(IsFunc(clean)||IsLabel(clean))
		SetTimer,%clean%,-1
	else if(v.AllOptions[clean])
		Options(clean)
	else if(plugin:=menus.EA("//*[@clean='" clean "']")){
		if(!FileExist(A_ScriptDir "\" plugin.plugin))
			MissingPlugin(plugin.plugin,clean)
		Try
			Run,% Chr(34) A_ScriptDir "\" plugin.plugin " " Chr(34) (plugin.option?Chr(34) plugin.option Chr(34):"")
	}else
		m("Not yet....Soon....","time:1",clean,menus.SSN("//*[@clean='" clean "']").xml)
	ShowOSD(clean)
	return
	DeadEnd:
	return
}
HWND(Win,HWND=""){
	static Window:=[]
	if(Win="get")
		return Window
	if(Win.rem){
		MainWindowClass.Save(Win.rem)
		Gui,1:-Disabled
		if(!Window[Win.rem])
			Gui,% Win.rem ":Destroy"
		else
			DllCall("DestroyWindow",uptr,Window[Win.rem])
		Window[Win.rem]:=""
	}
	if(IsObject(Win))
		return "ahk_id" Window[Win.1]
	if(!HWND)
		return Window[Win]
	Window[Win]:=HWND
}
Icons(il,icons,file,icon){
	if(file=""&&icon="")
		return 0
	if((ricon:=icons[file,icon])="")
		ricon:=icons[file,icon]:=IL_Add(il,file,icon)
	return ricon
}
Create_Include_From_Selection(){
	pos:=PosInfo(),sc:=CSC()
	if(pos.start=pos.end)
		return m("Please select some text to create a new Include from")
	text:=sc.GetSelText(),RegExMatch(text,"^(\w+)",Include)
	if(Include1="Class")
		RegExMatch(Text,"^(\w+\s+\w+)",Include)
	MainFile:=Current(2).File
	SplitPath,MainFile,,Dir
	Filename:=SelectFile(Dir "\" RegExReplace(Include1,"_"," ") "." Current(3).Ext,"New Include Filename",Current(3).Ext)
	if(FileExist(Filename))
		return m("Include name already exists. Please choose another")
	if(CEXML.Find(Current(1),"//@file",Filename))
		return m("This file is already included in this Project")
	sc.2326(),AddInclude(Filename,text,{start:StrPut(Include1 "(","UTF-8")-1,end:StrPut(Include1 "(","UTF-8")-1},0)
}
Include(MainFile,File){
	Relative:=RelativePath(MainFile,file)
	return "#Include " (SubStr(Relative,1,InStr(Relative,"\",0,0,1))="lib\"?"<" SplitPath(file).nne ">":relative)
}
Increment(){
	crement([9,1])
}Decrement(){
	crement([0,-1])
}crement(Add){
	sc:=CSC(),sc.2078(),sc.Enable()
	while(a_Index<=sc.2570){
		Start:=sc.2585(A_Index-1),End:=sc.2587(A_Index-1),End:=End=Start?End+1:End,begin:=0,conclude:=0,text:=sc.TextRange(Start,End)
		if(text~="(\d)"){
			while(Chr(sc.2007(Start))=Add.1)
				Start--
			text:=sc.TextRange(Start,End)
			if(RegExReplace(text,"-")~="\D")
				Start++,text:=sc.TextRange(Start,End)
			sc.2686(Start,End),sc.2194(StrLen(text+Add.2),[text+Add.2]),sc.2584(A_Index-1,Start),sc.2586(A_Index-1,End+(StrLen(text+Add.2)-StrLen(text)))
	}}return sc.Enable(1),sc.2079()
}Increment_Selected(){
	crement_Selected()
}Decrement_Selected(){
	crement_Selected(0)
}crement_Selected(Add:=1){
	sc:=CSC(),Text:=sc.GetSelText()
	if(!Text)
		return m("Please select some text")
	Pos:=1,LastPos:=1,Start:=sc.2143
	while(RegExMatch(Text,"O)(-?\d+)",Found,Pos),Pos:=Found.Pos(1)+Found.Len(1)){
		Out.=SubStr(Text,LastPos,Found.Pos(1)-LastPos) (Add?Found.1+1:Found.1-1),LastPos:=Pos
	}
	Out.=SubStr(Text,LastPos)
	sc.2170(0,Out),sc.2160(Start,Start+StrPut(Out,"UTF-8")-1)
}
Indent_Selected_Area(){
	sc:=CSC(),TopLine:=sc.2166(sc.2143),BottomLine:=sc.2166(sc.2145)
	if(TopLine=BottomLine)
		return m("You must select at least 2 lines")
	sc.2078(),Ind:=Settings.Get("//tab",5),Indent:=Floor(sc.2127(TopLine)/Ind),TopEnd:=sc.2136(TopLine),BottomEnd:=sc.2136(BottomLine),sc.2003(BottomEnd,"`t;}"),sc.2003(TopEnd,"`t;{"),FixLines(TopLine,BottomLine-TopLine,Indent),sc.Enable(1),sc.2079
}
IndentFrom(line){
	sc:=CSC()
	begin:=sc.2127(line)
	FileText:=sc.TextRange(sc.2167(line),sc.2006)
	;m("Start at line: " line,"Indentation: " begin,"Text:",FileText)
}
Index_Lib_Files(Index:=""){
	SplitPath,A_AhkPath,,AhkDir
	AhkDir.="\lib\",Rem:=CEXML.SSN("//Libraries"),Rem.ParentNode.RemoveChild(Rem),Main:=CEXML.Add("Libraries"),Lib:=[],All:=Settings.SN("//OtherLib/Folder")
	while(aa:=All.Item[A_Index-1])
		Lib.Push(aa.Text "\")
	for a,b in [A_MyDocuments "\AutoHotkey\Lib\",AhkDir]
		Lib.Push(b)
	for a,b in Lib{
		Loop,%b%*.ahk
		{
			File:=A_LoopFileLongPath
			SplitPath,File,FileName,Dir,Ext,NNE
			if(FileName="Studio.ahk")
				Continue
			FileGetTime,Time,%file%
			/*
				CHECK THE TIME TOO!!!!!!
			*/
			if(!CEXML.Find(Main,"descendant::main/file/@file",File))
				Extract(nn:=GetMainNode(File,Main))
			StringReplace,Text,Text,`r`n,`n,All
			Update({file:File,text:Text,load:1,encoding:Encoding})
		}
	}if(!Index){
		GetPos()
		SplashTextOn,200,110,Indexing Lib Folders,Please Wait...
		Scanfile.Once:=0,FileName:=Current(3).File,ScanFiles(1),Code_Explorer.Refresh_Code_Explorer(),FEUpdate(1),TV(SSN(CEXML.Find("//file/@file",FileName),"@tv").Text)
		SplashTextOff
	}
}
InputBox(Parent,Title,Prompt,Default=""){
	sc:=CSC(),Width:=sc.2276(33,"a"),Max:=[]
	Active:=DllCall("GetActiveWindow")
	OnMessage(6,"")
	WinGetPos,x,y,,,% "ahk_id" (Parent?Parent:sc.sc+0)
	for a,b in StrSplit(Prompt,"`n")
		Max[StrSplit(b).MaxIndex()]:=1,Count:=A_Index
	Width:=Max.MaxIndex()*Width,height:=(20*Count)+100,y:=((CPos:=sc.2165(0,sc.2008))<height)?y+CPos+sc.2279(sc.2166(sc.2008))+5:y,Prompt:=RegExReplace(Prompt,"\x60t","`t")
	InputBox,var,%Title%,%Prompt%,,%Width%,%height%,%x%,%y%,,,%Default%
	KeyWait,Escape,U
	if(ErrorLevel){
		sc.Enable(1)
		WinActivate,ahk_id%Active%
		Exit
	}
	if(!WinActive("ahk_id" Active)){
		;~ WinActivate,% HWND([1])
		flan:=DllCall("User32\SetActiveWindow","UPtr",HWND(1))
		;~ m(Flan,HWND(1))
	}
	WinWaitActive,ahk_id%Active%,,1
	OnMessage(6,"Activate")
	return var
}
Insert_Current_Time(){
	sc:=CSC(),sc.2003(sc.2008,[A_Now]),sc.2025(sc.2008+StrLen(A_Now))
}
InsertAll(text,add){
	sc:=CSC(),sc.2078
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
InsertMultiple(Caret,CPos,Text,End){
	sc:=CSC(),sc.2686(CPos,CPos),sc.2194(StrPut(Text,"UTF-8")-1,Text),sc.2584(Caret,End),sc.2586(Caret,End)
}
Jump_To_First_Available(){
	sc:=CSC(),line:=sc.GetLine(sc.2166(sc.2008)),v.jtfa:=[]
	if(RegExMatch(line,"Oi)^\s*\x23include\s*(.*)(\s*;.*)?$",found))
		Jump_To_Include()
	else{
		word:=Upper(sc.GetWord()),Root:=Current(7)
		if(SubStr(word,1,1)="g"&&node:=SSN(Root,"descendant::*[@upper='" Upper(SubStr(word,2)) "']"))
			return SelectText(node,1)
		all:=SN(Root,"descendant::*[@upper='" Word "']")
		if(all.length=1)
			SelectText(all.item[0],1)
		else{
			all:=CEXML.SN("//*[@upper='" Word "']")
			while(aa:=all.item[A_Index-1],ea:=XML.EA(aa))
				total.=(info:=A_Index ". " ea.Type " " StrSplit(SSN(GetFileNode(aa),"@file").text,"\").Pop()) "|",v.jtfa[info]:=aa
			sc.2106(124),sc.2117(6,Trim(total,"|")),sc.2106(32)
			if(!InStr(total,"|"))
				sc.2104
}}}Jump_To(Type){
	sc:=CSC(),line:=sc.GetLine(sc.2166(sc.2008)),word:=Upper(sc.GetWord())
	if(node:=SSN(Current(7),"descendant::*[@type='" Type "' and @upper='" word "']"))
		SelectText(node)
}Jump_To_Function(){
	Jump_To("Function")
}Jump_To_Include(){
	sc:=CSC(),line:=sc.GetLine(sc.2166(sc.2008)),tv(SSN(CEXML.Find(Current(1),"descendant::file/@include",Trim(line,"`t`n ")),"@tv").text)
}Jump_To_Label(){
	Jump_To("Label")
}Jump_To_Method(){
	Jump_To("Method")
}Jump_To_Class(){
	Jump_To("Class")
}Jump_To_Project(){
	Omni_Search("^")
}Jump_To_Matching_Brace(){
	sc:=CSC(),CPos:=sc.2008
	if((pos:=sc.2353(CPos))>=0)
		sc.2025(pos)
	else if((pos:=sc.2353(CPos-1))>=0)
		sc.2025(pos+1)
}
Class Keywords{
	__New(){
		static Dates:={ahk:"20180118110322",xml:"20171201061116",html:"20171201061319"},BaseURL:="https://raw.githubusercontent.com/maestrith/AHK-Studio/master/lib/Languages/",BaseDir:=A_ScriptDir "\Lib\Languages\"
		for a,b in StrSplit("IndentRegex,KeywordList,Suggestions,Languages,Comments,OmniOrder,CodeExplorerExempt,Words,FirstChar,Delimiter,ReplaceFirst,SearchTrigger",",")
			Keywords[b]:=[]
		if(!IsObject(v.OmniFind))
			v.OmniFind:=[],v.OmniFindText2:=[]
		if(!FileExist(A_ScriptDir "\Lib\Languages"))
			FileCreateDir,%A_ScriptDir%\Lib\Languages
		FileList:=[]
		for a,b in Dates
			FileList[BaseDir a ".xml"]:=1
		Loop,Files,%A_ScriptDir%\Lib\Languages\*.xml
			FileList[A_LoopFileLongPath]:=1
		for a in FileList
		{
			SplitPath,a,,,,NNE
			xx:=new XML(NNE,a)
			if((Date:=Dates[NNE]),URL:=BaseURL Format("{:L}",NNE) ".xml?refresh=" A_Now){
				if(!FileExist(a)){
					Data:=URLDownloadToVar(URL)
					while(SubStr(Data,1,1)!="<")
						Data:=SubStr(Data,2)
					xx:=new XML(NNE,a,Data,URL)
				}if(!Node:=xx.SSN("//date"))
					Node:=xx.Add("date")
				else if(xx.SSN("//date").text!=Date){
					SplashTextOn,200,100,Downloading %NNE%.xml,Please Wait...
					Data:=URLDownloadToVar(Url)
					while(SubStr(Data,1,1)!="<")
						Data:=SubStr(Data,2)
					TempXML:=new XML(Language:=Format("{:L}",NNE)),TempXML.XML.LoadXML(Data)
					if(TempXML[])
						xx:=TempXML,xx.File:=a
				}if(!NoUpdate),NoUpdate:=0
					Node.text:=Date,xx.Save(1)
				SplashTextOff
			}LEA:=XML.EA(Lexer:=xx.SSN("//FileTypes")),Keywords.Languages[(Language:=Format("{:L}",LEA.Language))]:=xx
			for _,Ext in StrSplit(Lexer.text," "){
				if(!Settings.SSN("//Extensions/Extension[@language='" Format("{:L}",Language) "' and text()='" Ext "']"))
					Settings.Add("Extensions/Extension",{language:Format("{:L}",Language)},Ext,1)
			}FileGetTime,Date,%a%
			if(!Node:=Settings.SSN("//Languages/" Language))
				Node:=Settings.Add("Languages/" Language)
			if(SSN(Node,"@date").text!=Date)
				Node:=KeyWords.Refresh(Language),Node:=Settings.SSN("//Languages/" Language),Node.SetAttribute("date",Date),Node.SetAttribute("name",LEA.Name)
			if(!SSN(Node,"@name").text)
				Node.SetAttribute("name",LEA.Name)
			all:=xx.SN("//Code/*"),Find:=v.OmniFind[Language]:=[],Order:=Keywords.OmniOrder[Language]:=[],Index:=0,ExemptList:=""
			while(aa:=all.item[A_Index-1],ea:=XML.EA(aa)){
				Index++,Keywords.FirstChar[Language,ea.FirstChar].=aa.NodeName "|"
				for a,b in ea{
					Find[aa.NodeName,a]:=(Value:=RegExReplace(b,"\x60n","`n")),Order[Index,aa.NodeName,a]:=Value
					if(a="Regex")
						Find[aa.NodeName,"Find"]:=GetFind(Value)
				}Under:=SN(aa,"*")
				if(Under.Length)
					Index++
				while(UU:=Under.item[A_Index-1],ea:=XML.EA(UU)){
					ExemptList.=UU.NodeName "|",Keywords.FirstChar[Language,ea.FirstChar].=UU.NodeName "|"
					for a,b in ea{
						Find[UU.NodeName,"Inside"]:=aa.NodeName,Find[UU.NodeName,a]:=(Value:=RegExReplace(b,"\x60n","`n")),Order[Index,aa.NodeName Chr(127) UU.NodeName,a]:=Value
						if(a="Regex")
							Find[UU.NodeName,"Find"]:=GetFind(Value)
			}}}Keywords.CodeExplorerExempt[Language]:=Trim(ExemptList,"|")
			for a,b in Keywords.FirstChar[Language]
				Keywords.FirstChar[Language,a]:=Trim(b,"|")
			for a,b in xx.EA("//Comments")
				KeyWords.Comments[Language,a]:=b
			Delimiter:=Keywords.Delimiter[Language]:=[]
			for a,b in xx.EA("//Delimiter"){
				Delimiter[a]:=b
				if(a="Replace"){
					if(b~="(\\|\.|\*|\?|\+|\[|\{|\||\(|\)|\^|\$)")
						Add:="\"
					Delimiter.ReplaceRegex:=Add b,Add:=""
				}
			}if(Node:=xx.SSN("//ReplaceFirst"))
				Keywords.ReplaceFirst[Language]:=XML.EA(Node)
			if((All:=xx.SN("//Special/Context/*")).length){
				Special:=Keywords.Special[Language]:=[]
				while(aa:=All.item[A_Index-1],ea:=XML.EA(aa))
					Special.Push(ea)
			}Keywords.SearchTrigger[Language]:=xx.SSN("//SearchTrigger").text,Keywords.SetPrefix(Language,xx)
		}KeyWords.RefreshPersonal()
	}BuildList(Language,Refresh:=0){
		if(IsObject(Keywords.KeywordList[Language])&&!Refresh)
			return
		if(!IsObject(Obj:=Keywords.Obj))
			Obj:=Keywords.Obj:=[]
		Obj[Language]:=[],Lang:=this.GetXML(Language),Keywords.IndentRegex[Language]:=RegExReplace(Lang.SSN("//Indent").text," ","|")
		if(Optional:=Settings.SSN("//CustomIndent/Language[@language='" Language "']").Text)
			Keywords.IndentRegex[Language]:=Optional
		else if(Keywords.IndentRegex[Language]){
			Key:=Keywords.IndentRegex[Language]
			Sort,Key,UD|
			Keywords.IndentRegex[Language]:=Key
		}
		Obj:=Keywords.KeywordList[Language]:=[],MainXML:=Keywords.GetXML(Language),Suggestions:=Keywords.Suggestions[Language]:=[],KeywordXML:=MainXML.SN("//Styles/keyword")
		while(kk:=KeywordXML.item[A_Index-1],ea:=XML.EA(kk)){
			KeywordList:=kk.text
			if(ea.add)
				KeywordList.=" " MainXML.SSN(ea.add).text,KeywordList:=Trim(KeywordList)
			Sort,KeywordList,UD%A_Space%
			CamelKeywordList:=KeywordList
			StringLower,KeywordList,KeywordList
			Obj[ea.Set]:=RegExReplace(KeywordList,"#")
			for a,b in StrSplit(CamelKeywordList," ")
				Suggestions[SubStr(b,1,2)].=b " ",Keywords.Words[Language,b]:=b
	}}GetList(Language){
		return Keywords.KeywordList[Language]
	}SetPrefix(Language,xx){
		all:=xx.SN("//Code/descendant::*"),Prefix:=[]
		for a,b in Omni_Search_Class.Prefix
			Prefix.Push({Prefix:a,Type:b})
		while(aa:=all.item[A_Index-1],ea:=XML.EA(aa))
			Prefix.Push({Prefix:ea.Prefix,Type:aa.NodeName})
		Keywords.Prefix[Language]:=Prefix
	}GetOmni(Language){
		
	}GetSuggestions(Language,FirstTwo){
		return Keywords.Suggestions[Language,FirstTwo]
	}GetXML(Language){
		return Keywords.Languages[Language]
	}Refresh(Language){
		Lang:=this.GetXML(Language),all:=Lang.SN("//Styles/font"),Default:=DefaultFont(1)
		while(aa:=all.item[A_Index-1],ea:=XML.EA(aa)){
			if(Color:=Default.SSN("//font[@style='" ea.style "']/@color").text)
				ea.Color:=Color
			if(!Settings.SSN("//Languages/" Format("{:L}",Language) "/font[@style='" ea.Style "']"))
				ea.Delete("ex"),Settings.Add("Languages/" Format("{:L}",Language) "/font",ea,,1)
	}}RefreshPersonal(){
		Keywords.Personal:=Settings.SSN("//Variables").text
	}
}
Kill_Process(){
	WinGet,AList,List,ahk_class AutoHotkey
	if(Current(3).Dir=A_ScriptDir "\Untitled"){
		Exec:=v.Running[Current(2).File]
		return Exec.Terminate()
	}Loop,%AList%{
		ID:=AList%A_Index%
		WinGetTitle,ATitle,ahk_id%ID%
		if(Trim(SubStr(ATitle,1,InStr(ATitle,"-",0,0,1)-1))=Current(2).file){
			PostMessage,0x111,65405,0,,ahk_id%ID%
			WinGet,PID,PID,ahk_id%ID%
			Sleep,200
			Process,Exist,%PID%
			if(ErrorLevel)
				WinKill,ahk_id%ID%
			Process,Exist,%PID%
			if(ErrorLevel){
				Run,TaskMgr
				m("Unable to kill this Process. Please kill this task in the Task Manager")
			}
			Break
		}
	}
}
LanguageFromFileExt(Ext){
	static Languages:=[]
	return (Languages[Ext]:=Languages[Ext]?Languages[Ext]:Settings.SSN("//Extensions/Extension[text()='" Format("{:L}",Ext) "']/@language").text)
}
LastFiles(){
	rem:=Settings.SSN("//last"),rem.ParentNode.RemoveChild(rem)
	for a,b in s.main{
		file:=CEXML.SSN("//*[@sc='" b.2357 "']/@file").text
		if(file)
			Settings.Add("last/file",,file,1)
	}
}
LButton(a*){
	Loop,2
		MouseClick,Left,,,,,U
	if(WinExist(HWND([20])))
		HWND({rem:20})
	return 0
}
List_Variables(){
	if(!debug.socket)
		return m("Currently no file being debugged","time:1"),debug.off()
	VarBrowser(),debug.Send("stack_get")
}
Make_One_Line(){
	sc:=CSC(),Text:=sc.GetSelText()
	if(Text~="\R"=0)
		return m("Select at least 2 lines of text to combine")
	Text:=RegExReplace(Text,"\n",","),Text:=RegExReplace(Text,"\t"),sc.2170(0,[Text])
}
Manage_File_Types(){
	new SettingsClass("Manage File Types")
}
Margin_Left(set:=0){
	sc:=CSC()
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
	sc:=sc?sc:CSC(),sc.2242(0,sc.2276(33,"a" sc.2154()))
}
Menu_Help(){
	static help,NewWin
	help:=new XML("help","lib\Help Menu.xml"),CurrentMenu:=new XML("current"),CurrentMenu.XML.LoadXML(x.get("menus"))
	NewWin:=new GUIKeep("Menu_Help"),NewWin.Add("TreeView,w300 h300 gMHSelect,,h","Edit,x+M w300 h300,,wh","Button,xm gUpdateHelp,Update Help File,y")
	if(!FileExist("lib\Help Menu.xml"))
		Gosub,UpdateHelp
	NewWin.Show("Menu Help")
	Goto,MHPopulate
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
	Goto,MHPopulate
	return
	MHPopulate:
	Default("SysTreeView321","Menu_Help"),TV_Delete(),all:=help.SN("//main/descendant::*")
	while(aa:=all.item[A_Index-1],ea:=XML.EA(aa))
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
Menu(MenuName:="main"){
	v.Available:=[],Menu:=menus.SN("//" MenuName "/descendant::*"),topmenu:=menus.SN("//" MenuName "/*")Ttrack:=[],Exist:=[],Exist[MenuName]:=1
	if(!top:=v.hkxml.SSN("//win[@hwnd='" HWND(1) "']"))
		top:=v.hkxml.Add("win",{hwnd:HWND(1)},,1)
	Disable:=[]
	Menu,%MenuName%,UseErrorLevel,On
	MenuWipe(1)
	while(mm:=topmenu.Item[A_Index-1],ea:=XML.EA(mm))
		if(mm.HasChildNodes())
			Menu,% ea.Name,DeleteAll
	Menu,%MenuName%,DeleteAll
	CXMLTop:=CEXML.ReCreate("//menu","menu"),Track:=[]
	while(aa:=Menu.Item[A_Index-1],ea:=XML.EA(aa),pea:=XML.EA(aa.ParentNode)){
		Parent:=pea.Name?pea.Name:MenuName,ConvertedHotkey:=ea.Hotkey?Convert_Hotkey(ea.Hotkey):""
		if(ea.Hide)
			Continue
		Foo:=A_TickCount
		if(!aa.HasChildNodes()){
			if(aa.NodeName="Separator"){
				Menu,%parent%,Add
				Continue
			}if((!IsFunc(ea.Clean)&&!IsLabel(ea.Clean))&&!ea.Plugin&&!v.Options.HasKey(ea.Clean)){
				Disable[parent,ea.Name (ea.Hotkey?"`t" ConvertedHotkey:"")]:=1,aa.SetAttribute("no",1),aa.SetAttribute("delete",1)
				Continue
			}if(ea.no)
				aa.RemoveAttribute("no")
			Clean:=RegExReplace(ea.Clean,"_"," "),Launch:=IsFunc(ea.Clean)?"func":IsLabel(ea.Clean)?"label":v.Options.HasKey(ea.Clean)?"option":""
			CEXML.Under(CXMLTop,"Item",{launch:(Launch?Launch:ea.Plugin),text:Clean,type:"Menu",sort:Clean,additional1:ConvertedHotkey,order:"text,type,additional1",clean:ea.Clean})
			Exist[parent]:=1
		}v.Available[ea.Clean]:=1,(aa.HasChildNodes())?(Track.Push({name:ea.Name,parent:parent,clean:ea.Clean}),route:="deadend",aa.SetAttribute("top",1)):(route:="MenuRoute")
		if(ea.Hotkey)
			v.hkxml.Under(top,"hotkey",{hotkey:ea.Hotkey,action:ea.Clean})
		Hotkey:=ea.Hotkey?"`t" Convert_Hotkey(ea.Hotkey):""
		Menu,%parent%,Add,% ea.Name Hotkey,MenuRoute
		if(Disable[parent,ea.Name Hotkey]){
			Menu,%parent%,Icon,% ea.Name hotkey,Shell32.dll,23
			Menu,%parent%,Disable,% ea.Name hotkey
		}
		if(value:=Settings.SSN("//options/@" ea.Clean).text){
			v.Options[ea.Clean]:=value
			Menu,%parent%,ToggleCheck,% ea.Name hotkey
		}
		/*
			if(ea.icon!=""&&ea.filename)
				Menu,%Parent%,Icon,% ea.Name hotkey,% ea.filename,% ea.icon
		*/
	}
	for a,b in Track{
		if(!Exist[b.name])
			Menu,% b.parent,Delete,% b.name
		Tick:=A_TickCount
		Menu,% b.parent,Add,% b.name,% ":" b.name
	}
	Gui,1:Menu,%MenuName%
	return MenuName
	MenuRoute:
	Item:=Clean(A_ThisMenuItem),ea:=menus.EA("//*[@clean='" Item "']"),plugin:=ea.Plugin,option:=ea.option
	ShowOSD(Item)
	if(IsFunc(Item)||IsLabel(Item))
		SetTimer,%Item%,-1
	else if(plugin){
		if(!FileExist(plugin))
			MissingPlugin(plugin,A_ThisMenuItem)
		Run,% Chr(34) A_ScriptDir "\" plugin Chr(34) " " (option?option:Item)
	}else if(v.Options.HasKey(Item)){
		Options(Item)
	}else
		m("nope, add it :(",Item)
	ShowOSD(Item)
	/*
		if(plugin){
			if(!FileExist(plugin))
				MissingPlugin(plugin,Item)
			else
				SplitPath,plugin,,dir
			dir:=(dir="plugins")?"":dir
			Run,%A_ScriptDir%\"%plugin%" %option%,%dir%
		}
		return
		}else if(IsFunc(Item)||IsLabel(Item))
			SetTimer,%Item%,-1
		else
			Options(Item)
	*/
	return
	show:
	/*
		WinActivate(HWND([1]))
	*/
	return
}
MenuActions(){
	static SMM
	SWAction:
	Default("SysListView323","Settings"),LV_GetText(text,LV_GetNext())
	if(action:=SettingsWindow.CommandList[text].2)
		Goto,%action%
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
	while(aa:=all.item[A_Index-1],ea:=XML.EA(aa)){
		parent:=SSN(aa.ParentNode,"@name").text,hotkey:=SSN(aa,"@hotkey").text,hotkey:=hotkey?"`t" Convert_Hotkey(hotkey):"",current:=SSN(aa,"@name").text
		Menu,%parent%,Delete,% current hotkey
	}while(aa:=all.item[A_Index-1],ea:=XML.EA(aa))
		if(SSN(aa,"descendant::*"))
			Menu,main,Delete,% ea.name
	Sleep,100
}
MissingPlugin(file,menuname){
	SplitPath,file,filename,dir
	if(dir="plugins"&&!FileExist(file)){
		if(m("This requires a plugin that has not been downloaded yet, Download it now?","btn:yn")="yes"){
			UrlDownloadToFile,https://raw.githubusercontent.com/maestrith/AHK-Studio-Plugins/master/%filename%,%file%
			Option:=menus.SSN("//*[@clean='" RegExReplace(menuname," ","_") "']/@option").text,Refresh_Plugins()
			Run,"%A_ScriptDir%\%file%" "%Option%"
		}else{
			m("Unable to run this option.")
			Exit
		}
	}
}
Monitors(){
	SysGet,Count,MonitorCount
	Coords:=[]
	Loop,%Count%{
		SysGet,Monitor,Monitor,%A_Index%
		for c,d in {Left:MonitorLeft,Right:MonitorRight,Top:MonitorTop,Bottom:MonitorBottom}
			Coords[c,d]:=1
	}
	return Coords
}
Move_Matching_Brace(){
	Move_Matching_Brace_Left:
	Move_Matching_Brace_Right:
	sc:=CSC()
	if(v.HighLight){
		if(sc.2166(v.BraceStart)!=sc.2166(v.BraceEnd))
			return m("Matching items must be in the same line")
		Pos:=[],Pos[v.BraceStart]:=1
		Pos[v.BraceEnd]:=1
		Char:=sc.2007(Pos.MaxIndex())
		StylePos:=Pos.MaxIndex()
		Move:=sc.2008>=StylePos
		Line:=sc.2166(StylePos)
		if(A_ThisLabel="Move_Matching_Brace_Left"){
			Style:=sc.2010(StylePos-1)
			if(v.BraceStart=v.BraceEnd-1)
				return m("The Matching Brace is already next to it")
			while((--StylePos)>=Pos.MinIndex()){
				if(sc.2010(StylePos)!=Style)
					Break
			}if(StylePos<=Pos.MinIndex())
				StylePos:=Pos.MinIndex()+1
			sc.2078
			sc.2645(Pos.MaxIndex(),1),sc.2003(StylePos,Chr(Char))
			if(Move)
				sc.2025(StylePos)
			sc.2079
		}else{
			Style:=sc.2010(StylePos+1)
			while(sc.2166(++StylePos)=Line){
				if(sc.2010(StylePos)!=Style)
					Break
			}if(sc.2166(StylePos)!=Line)
				StylePos--
			if(StylePos-1=Pos.MaxIndex())
				return m("Already at the end of the line")
			sc.2078
			sc.2645(Pos.MaxIndex(),1),sc.2003(StylePos-1,Chr(Char))
			if(Move)
				sc.2025(StylePos-1)
			sc.2079
		}return
	}else
		m("Your Caret needs to be next to a brace of some sort ({<[]>})")
}
Move_Selected_Lines_Down(){
	sc:=CSC()
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
	sc.2078(),start:=sc.2166(sc.2143),end:=sc.2166(sc.2145-1),LineStatus.StoreEdited(start,end,1),Edited(),sc.2621()
	if(v.Options.Full_Auto_Indentation)
		FixIndentArea()
	sc.Enable(1),LineStatus.UpdateRange(),sc.2079
	return
}
Move_Selected_Lines_Up(){
	sc:=CSC(),OLine:=line:=sc.2166(sc.2143)
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
MoveSelectedWord(Add){
	sc:=CSC(),sc.2078
	Loop,% sc.2570{
		Index:=A_Index-1,Start:=sc.2585(Index),End:=sc.2587(Index)
		if(Start!=End)
			VarSetCapacity(Text,End-Start),sc.2686(Start,End),sc.2687(0,&Text),Text:=StrGet(&Text,End-Start,"UTF-8"),sc.2645(Start,End-Start),sc.2686(Start+Add,Start+Add),sc.2194(StrPut(Text,"UTF-8")-1,[Text]),sc.2584(Index,Start+Add),sc.2586(Index,End+Add)
	}sc.2079
}
m(x*){
	static list:={btn:{oc:1,ari:2,ync:3,yn:4,rc:5,ctc:6},ico:{"x":16,"?":32,"!":48,"i":64}},msg:=[]
	static Title
	list.title:="AHK Studio",list.def:=0,list.time:=0,value:=0,txt:=""
	WinGetTitle,Title,A
	for a,b in x
		obj:=StrSplit(b,":"),(vv:=List[obj.1,obj.2])?(value+=vv):(list[obj.1]!="")?(List[obj.1]:=obj.2):txt.=b "`n"
	msg:={option:value+262144+(list.def?(list.def-1)*256:0),title:list.title,time:list.time,txt:txt}
	Sleep,120
	MsgBox,% msg.option,% msg.title,% msg.txt,% msg.time
	SetTimer("ActivateAfterm","-150")
	for a,b in {OK:value?"OK":"",Yes:"YES",No:"NO",Cancel:"CANCEL",Retry:"RETRY"}
		IfMsgBox,%a%
			return b
	return
	ActivateAfterm:
	if(InStr(Title,"Omni-Search")||!Title){
		Loop,20
		{
			WinGetActiveTitle,ATitle
			if(InStr(ATitle,"AHK Studio"))
				Break
			WinActivate,% HWND([1])
			if(WinActive("A")=HWND(1))
				Break
			Sleep,50
		}
		CSC().2400
	}else{
		WinActivate,%Title%
	}
	return
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
	sc:=CSC(),CPos:=sc.2008,line:=sc.2166(CPos),column:=sc.2129(CPos),new:=sc.2456(line+add,column)
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
	NewWin:=new GUIKeep(28),NewWin.Add("Edit,w500 r30,,wh","Button,gNFTDefault,Default Template,y","Button,gNFTClose Default,Save,y"),NewWin.show("New File Template")
	if(template:=Settings.SSN("//template").text)
		ControlSetText,Edit1,% RegExReplace(template,"\R","`r`n"),% HWND([28])
	else
		Goto,nftdefault
	return
	NFTClose:
	ControlGetText,edit,Edit1,% HWND([28])
	Settings.Add("template",,RegExReplace(edit,"\R","`n"))
	28Escape:
	28Close:
	HWND({rem:28})
	return
	NFTDefault:
	FileRead,template,c:\windows\shellnew\template.ahk
	ControlSetText,Edit1,%template%,% HWND([28])
	rem:=Settings.SSN("//template"),rem.ParentNode.RemoveChild(rem)
	return
}
New_Include(){
	if((ea:=Current(3)).Dir=A_ScriptDir "\Untitled"&&SubStr(ea.FileName,1,8)="Untitled")
		return m("You can not add Includes to Untitled documents.  Please save this project before attempting to add Includes to it.")
	sc:=CSC(),Parent:=Current(2).File,FileName:=SelectFile("","New Include Name"),AddSpace:=v.Options.New_Include_Add_Space?" ":""
	Function:=Clean((NNE:=SplitPath(FileName).NNE)),text:=(Function~="i)^class_")?(m("Create Class called " (RegExReplace(SubStr(NNE,InStr(NNE," ")+1)," ","_")) "?","btn:ync")="Yes"?"Class " (RegExReplace(SubStr(NNE,InStr(NNE," ")+1)," ","_")) AddSpace "{`n`t`n}":"",pos:=StrPut(NNE AddSpace "{`t","UTF-8")):(m("Create Function called " Function "?","btn:ync")="Yes"?Function "()" AddSpace "{`n`t`n}":"",pos:=StrPut(Function "(","UTF-8")-1)
	AddInclude(FileName,text,{start:pos,end:pos})
}
NewIndent(indentwidth:=""){
	Critical
	static IncludeOpen
	tick:=A_TickCount
	filename:=Current(3).file
	SplitPath,filename,,,ext
	sc:=CSC(),sc.Enable(),skipcompile:=0,chr:="K",codetext:=sc.GetUni(),indentation:=sc.2121,line:=sc.2166(sc.2008),posinline:=sc.2008-sc.2128(line),selpos:=PosInfo(),lock:=[],block:=[],aa:=ab:=braces:=0,code:=StrSplit(codetext,"`n"),aaobj:=[],specialbrace:=0,totalcount:=0
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
			while(((found:=SubStr(text,A_Index,1))~="(}|\s)")){
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
		WinSetTitle(1,CEXML.EA("//*[@sc='" sc.2357 "']"),1),IncludeOpen:=1
	else if(!braces&&IncludeOpen)
		WinSetTitle(1,CEXML.EA("//*[@sc='" sc.2357 "']")),IncludeOpen:=0
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
New_Plugin(){
	PluginName:=InputBox(HWND(1),"New Plugin Name","This will be the FileName and also the Default Menu name")
	if(FileExist((File:=A_ScriptDir "\Plugins\" PluginName ".ahk")))
		return m("File Already Exists.")
	FileAppend,% "#SingleInstance,Force`n;menu " PluginName "`n;Your Plugin Code`nExitApp "";Always Exit Your App",%File%
	Open(File,1)
}
New(FileName:="",text:="",Select:=1){
	template:=GetTemplate()
	if(v.Options.New_File_Dialog&&!FileName){
		FileName:=DLG_FileSave(hwnd(1))
		if(!FileName)
			return
		
		file:=FileOpen(FileName,"RW"),file.Seek(0),file.Write(template),file.Length(file.Position),file.Close()
		if(FileExist(FileName))
			return tv(Open(FileName))
	}else{
		Number:=1
		while(CEXML.SSN("//file[@file='" A_ScriptDir "\Untitled\Untitled" A_Index ".ahk']"))
			Number:=A_Index+1
		FileName:=A_ScriptDir "\Untitled\Untitled" Number ".ahk",Untitled:=1
		/*
			FileName:=(list:=CEXML.SN("//main[@untitled]").length)?"Untitled" list ".ahk":"Untitled.ahk",Untitled:=1
		*/
	}
	Update({file:FileName,text:template,load:1,encoding:"UTF-8"})
	main:=CEXML.Under(CEXML.SSN("//files"),"main",{file:FileName,id:(id:=GetID())})
	SplitPath,FileName,mfn,maindir,Ext,mnne
	node:=CEXML.Under(main,"file",{ext:Ext,file:FileName,type:"File",dir:maindir,filename:mfn,id:id,nne:mnne,scan:1,lang:"ahk"})
	if(Untitled)
		main.SetAttribute("untitled",1),node.SetAttribute("untitled",1)
	FEUpdate(),ScanFiles()
	if(Select)
		tv(CEXML.SSN("//*[@id='" id "']/@tv").text)
	return new
}
New_Include_From_Current_Word(){
	sc:=CSC(),Word:=sc.GetWord(),file:=Current(2).file
	if(!Word)
		return m("Either select a word or place your caret within a word")
	if(Context(1).Word="gui"){
		Word:=InputBox(HWND(1),"Possible g-label detected","Confirm the new Function and File to be created",Word)
		if(ErrorLevel||Word="")
			return
	}SplitPath,file,,Dir
	FileName:=SelectFile(Dir "\" RegExReplace(Word,"_"," ") "." Current(3).Ext,"FileName for " Word,Current(3).Ext,,1)
	if(ErrorLevel)
		return
	if(CEXML.Find(Current(1),"//@file",FileName))
		return m("A file with this name is already included in this Project")
	AddInclude(FileName,Word "(){`r`n`t`r`n}",{start:StrPut(Word "(","UTF-8")-1,end:StrPut(Word "(","UTF-8")-1})
}
NewLines(text){
	for a,b in {"``n":"`n","``r":"`n","``t":"`t","\r":"`n","\t":"`t","\n":"`n"}
		StringReplace,text,text,%a%,%b%,All
	return text
}
Next_File(){
	TVC.Default(1),TV_Modify(TV_GetNext(TV_GetSelection(),"F"),"Select Vis Focus")
}
Next_Found(){
	sc:=CSC(),sc.2606,sc.2169,CenterSel()
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
		if(Settings.SSN("//Extensions/Extension[text()='" (Text:=Format("{:L}",Text)) "']"))
			return m("File Type already exists")
		if(!Text)
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
			Options(text),t(Text,"time:1 ")
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
		}StyleNode:=ThemeXML.SSN("//Styles/descendant::*[@style='" Style "']")
		if(!Node:=Settings.SSN("//theme/" StyleNode.NodeName))
			Node:=Settings.SSN("//Languages/" Settings.Language "/descendant::*[@style='" Style "']")
		if(StyleNode.NodeName="keyword")
			Node:=Settings.SSN("//theme/keyword[@set='" SSN(StyleNode,"@set").text "']")
		if(GetKeyState("Ctrl","P"))
			Dlg_Font(Node,,SettingsClass.HWND)
		else
			Dlg_Color(Node,,SettingsClass.HWND,(GetKeyState("Alt","P")?"background":"color"))
		this.Color(),RefreshThemes(1)
		WinActivate,% "ahk_id" SettingsClass.HWND
		return ;m(Style,ThemeXML.SSN("//Styles/descendant::*[@style='" Style "']").xml,"Here!--->") ;here
		
		/*
			for whatever reason when you click on the keywords colors (maybe others)
				the default color picked is the orange in the corner.
			Bad Unicode{
				I think when I read the file I need to see if it isn't UTF-8
				if it isn't and RegExMatch() characters outside of 0-255
					just force UTF-8
				but they have force UTF-8 on....{
					so not sure what is up.
				}
			}
		*/
		
		
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
	static values:={0:"Obj",2:"Code",3:"position",4:"ch",5:"mod",6:"ModType",7:"text",8:"length",9:"linesadded",10:"msg",11:"wparam",12:"lparam",13:"line",14:"fold",15:"prevfold",17:"ListType",22:"updated",23:"Method"}
	static codeget:={2001:{ch:4},2005:{ch:4,mod:5},2006:{position:3,mod:5},2007:{updated:22},2008:{position:3,ModType:6,text:7,length:8,linesadded:9,line:13,fold:14,prevfold:15},2010:{position:3,margin:16},2011:{position:3},2014:{position:3,ch:4,text:7,ListType:17,Method:23},2016:{x:18,y:19},2019:{position:3,mod:5},2021:{position:3},2022:{position:3,ch:4,text:7,method:23},2027:{position:3,mod:5}}
	static poskeep,Mem:=[],FocusPos:=[]
	Notify:
	static last,lastline,lastpos:=[],focus:=[],dwellfold:="",text
	if(csc.1=0)
		return lastpos:=[]
	fn:=[],Info:=A_EventInfo,Code:=NumGet(Info+8)
	if(!Code)
		return 0
	if(Code=2013)
		return
	sc:=CSC({hwnd:(Ctrl:=NumGet(A_EventInfo+0))})
	if(Code=2004&&Ctrl=MainWin.tnsc.sc)
		return t("You can not edit Parent Folders.  Please select the most bottom level to edit","time:2")
	if(Code=2016){
		pos:=sc.2023(fn.x,fn.y),word:=sc.TextRange(sc.2266(pos,1),sc.2267(pos,1)),List:=debug.XML.SN("//property[@name='" word "']"),info:=""
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
		if((Msg:=NumGet(Info+88))&2)
			SetTimer("UpPos",-31)
		if((Msg&4||Msg&8)&&sc.2102)
			sc.2101
		if((Msg&4||Msg&8)&&sc.2202)
			sc.2201
		return 0,SetTimers("BraceHighlight,-10")
	}else if(Code=2028){
		if(s.ctrl[Ctrl])
			sc:=CSC({hwnd:hwnd})
		if(sc.sc=MainWin.tnsc.sc)
			WinSetTitle(1,"Tracked Notes")
		else
			WinSetTitle(1,ea:=CEXML.EA("//*[@sc='" sc.2357 "']"))
		MouseGetPos,,,win
		if(win=HWND(1))
			SetTimer("LButton",-50)
		TVC.Disable(1)
		if(ea.tv)
			TV_Modify(ea.tv,"Select Vis Focus")
		TVC.Enable(1)
		if(CheckLayout())
			Hotkeys()
		return 0
	}else if(Code=2029){
		v.LastSC:=CSC()
		return 0
	}if(Code=2008&&(!v.LineEdited[(Line:=sc.2166(sc.2008))])&&sc.2008!="")
		SetScan(Line)
	if Code not in 2007,2001,2006,2008,2010,2014,2022,2016,2019
		return 0
	fn:=[],fn.Code:=Code,fn.Ctrl:=NumGet(A_EventInfo+0)
	for a,b in CodeGet[Code]{
		if(a="Text")
			fn.Text:=StrGet(NumGet(Info+(A_PtrSize*b)),"UTF-8")
		else
			fn[a]:=NumGet(Info+(A_PtrSize*b))
	}if(fn.Code)
		Mem.Push(fn)
	SetTimer("ReadLater",-50)
	return 0
	ReadLater:
	Edited:=[]
	while(fn:=Mem.RemoveAt(1)){
		sc:=CSC({hwnd:fn.Ctrl}),tn:=0,Code:=fn.Code
		if(MainWin.tnsc.sc=fn.Ctrl){
			tn:=1
		}if(fn.Code=2001){
			SetWords(1),CPos:=sc.2008,Start:=sc.2266(CPos,1),end:=sc.2267(CPos,1),word:=sc.TextRange(Start,CPos),SetWords()
			if(sc.2007(Start-1)=46){
				if(Show_Class_Methods(pre:=sc.TextRange(sc.2266(Start-2,1),sc.2267(Start-2,1)),word))
					return
			}if((StrLen(word)>1&&sc.2102=0&&v.Options.Auto_Complete))
				SetTimer("ShowAutoComplete",-15)
			style:=sc.2010(CPos-2)
			if(v.Options.Context_Sensitive_Help)
				SetTimer("Context",-150)
			c:=fn.ch
			if(c~="44|32")
				Replace()
			if(c=44&&v.Options.Auto_Space_Before_Comma){
				sc.2003(CPos-1," "),sc.2025(++CPos)
				if(v.Options.Auto_Space_After_Comma)
					sc.2003(CPos," ") ,sc.2025(CPos+1)
			}if(c=44&&v.Options.Auto_Space_After_Comma)
				sc.2003(CPos," "),sc.2025(CPos+1)
			ch:=c?c:sc.2007(sc.2008),SetStatus("Last Entered Character: " Chr(ch) " Code:" ch,2)
			if(c=125){
				SetTimer("FixBrace",-10)
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
				Char:=sc.2007((npos:=sc.2266(pos)-1))
				for c,d in StrSplit(Settings.Get("//StartSelect","#") "#"){
					if(d=Chr(Char)){
						sc.2160(npos,sc.2267(pos))
						Break
					}
				}
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
							RegExReplace(text,"\R",,count),LineStatus.DelayAdd(line,count)
					}else{
						if(MainWin.tnsc.sc!=ctrl)
							SetScan(Line)
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
				Start:=sc.2166(fn.position),end:=sc.2166(fn.position+fn.length)
				if(!v.LineEdited[Start]){
					if(MainWin.tnsc.sc!=ctrl)
						SetScan(Start)
					if(v.Options.Disable_Line_Status!=1)
						LineStatus.Add(Start,2)
				}
			}if(fn.ModType&0x02&&(fn.ModType&0x20=0&&fn.ModType&0x40=0)){
				if(fn.linesadded)
					MarginWidth(sc)
			}SetTimer("UpPos",-10)
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
			margin:=fn.Margin,line:=sc.2166(fn.position)
			if(margin=3)
				sc.2231(line)
			if(margin=1){
				line:=sc.2166(fn.position),shift:=GetKeyState("Shift","P"),ShiftBP:=v.Options.Shift_Breakpoint,text:=Trim(sc.GetLine(line)),search:=(shift&&ShiftBP||!shift&&!ShiftBP)?["*","UO)(\s*;\*\[(.*)\])","Breakpoint",";*[","]"]:["#","UO)(\s*;#\[(.*)\])","Bookmark",";#[","]"]
				if(pos:=RegExMatch(text,search.2,found)){
					Start:=sc.2128(line),sc.2645(Start+pos-1,StrPut(found.1,"UTF-8")-1)
					if(ShiftBP&&shift||!shift&&!ShiftBP)
						if(debug.Socket>0){
							if(node:=CEXML.SSN("//*[@id='" debug.id "']/descendant::*[@sc='" sc.2357 "']")){
								dea:=XML.EA(node)
								if(dobj:=debug.Breakpoints[dea.id])
									debug.Send("breakpoint_remove -d " dobj.id)
				}}}else{
					if(ShiftBP&&shift||!shift&&!ShiftBP)
						if(debug.Socket>0){
							if(node:=CEXML.SSN("//*[@id='" debug.id "']/descendant::*[@sc='" sc.2357 "']"))
								debug.Send("breakpoint_set -t line -f " SSN(node,"@file").text " -n" line+1 " -i " SSN(node,"@id").text "|" line)
						}
					name:=AddBookmark(line,search)
		}}}else if(Code=2018){
			MarginWidth(sc)
			Continue
		}else if(fn.Code=2014){
			if(fn.ListType=1){
				if(!IsObject(scintilla))
					scintilla:=new xml("scintilla",A_ScriptDir "\lib\scintilla.xml")
				command:=fn.Text,info:=scintilla.SSN("//commands/item[@name='" command "']"),ea:=XML.EA(info),Start:=sc.2266(sc.2008,1),end:=sc.2267(sc.2008,1),syn:=ea.syntax?ea.Code "()":ea.Code,sc.2160(Start,end),sc.2170(0,[syn])
				if(ea.syntax)
					sc.2025(sc.2008-1),sc.2200(Start,ea.Code ea.syntax)
			}else if(fn.ListType=2){
				/*
					look up what sc.2117() uses 2 as the thing
					add one that uses the vault stuff
				*/
				vv:=fn.Text,Start:=sc.2266(sc.2008,1),end:=sc.2267(sc.2008,1),sc.2645(Start,end-Start),sc.2003(sc.2008,vault.SSN("//*[@name='" vv "']").text)
				if(v.Options.Full_Auto_Indentation)
					SetTimer("NewIndent",-1)
			}else if(fn.ListType=3){
				text:=fn.Text
				loop,% sc.2570
					CPos:=sc.2585(A_Index-1),add:=sc.2007(CPos)=40?"":"()",Start:=sc.2266(CPos,1),end:=sc.2267(CPos,1),sc.2686(Start,end),send:=(reptext:=RegExReplace(text,"(\(|\))")) add,len:=StrPut(send,"UTF-8")-1,sc.2194(len,send),len:=StrPut(reptext,"UTF-8"),GotoPos(A_Index-1,CPos:=sc.2585(A_Index-1)+len)
			}else if(fn.ListType=4)
				text:=fn.Text,Start:=sc.2266(sc.2008,1),end:=sc.2267(sc.2008,1),sc.2645(Start,end-Start),sc.2003(sc.2008,text "."),sc.2025(sc.2008+StrLen(text ".")),Show_Class_Methods(text)
			else if(fn.ListType=5){
				text:=fn.Text,Start:=sc.2266(sc.2008,1),end:=sc.2267(sc.2008,1),add:=sc.2007(end)=40?"":"()",sc.2645(Start,end-Start),sc.2003(sc.2008,text add),sc.2025(sc.2008+StrLen(text "."))
				SetTimer("Context",-10)
			}else if(fn.ListType=6){
				text:=fn.Text,list:=v.firstlist
				SetTimer("NJT",-50)
				Continue
				NJT:
				ll:=v.jtfa[text],SelectText(ll,1)
				return
			}else if(fn.ListType=7){
				text:=fn.Text,s.ctrl[v.jts[text]].2400()
			}else if(fn.ListType=8){
				static methods
				text:=fn.Text,Start:=sc.2266(sc.2008,1),end:=sc.2267(sc.2008,1),sc.2645(Start,end-Start),sc.2003(sc.2008,text (sc.2007(sc.2008)=46?"":".")),sc.2025(sc.2008+StrLen(text ".")),methods:="",node:=CEXML.Find("//main/@file",Current(2).file,"descendant::info[@type='Class' and @upper='" Upper(text) "']/*[@type='Method']")
				while(nn:=node.item[A_Index-1]),ea:=XML.EA(nn)
					methods.=ea.text " "
				SetTimer("ShowMethod",-10)
				Continue
				ShowMethod:
				KeyWait,Enter,U
				sc.2117(5,Trim(methods))
				return
			}else if(fn.ListType=9){
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
			}else if(fn.ListType=10){
				name:=fn.Text,sc.2645(fn.Position,Abs(fn.Position-sc.2008)),RegExMatch(name,"O)\|\s+(.*)",Found),sc.2025(fn.Position),sc.2003(fn.Position,Found.1)
				if(pos:=fn.Position+StrPut(Found.1,"UTF-8")-1)
					sc.2025(pos)
			}else if(fn.ListType=11){
				ea:=Settings.EA(Node:=Settings.SSN("//ReplaceRegex/Replace[@name='" fn.Text "']")),sc.2078(),In:=ea.In,Out:=ea.Out
				Loop,% sc.2570
					Start:=sc.2585(A_Index-1),End:=sc.2587(A_Index-1),Text:=sc.TextRange(Start,End),sc.2190(Start),sc.2192(End),Text:=RegExReplace(Text,In,Out),sc.2194(StrPut(Text,"UTF-8")-1,Text)
				sc.2079(),Parent:=Node.ParentNode
				if(SN(Parent,"*").length>1&&Node.PreviousSibling)
					Parent.InsertBefore(Node,SSN(Parent,"*"))
			}
		}else if(fn.Code=2022){
			v.Word:=fn.Text,List:=""
			for a,b in fn
				List.=a " = " b "`n"
			if(v.Options.Autocomplete_Enter_Newline){
				SetTimer("Enter",-1)
			}Else{
				v.word:=fn.Text
				if(A_ThisHotkey="("){
					SetTimer("NotifyText",-1)
					return
					NotifyText:
					Loop,% sc.2570{
						CPos:=sc.2585(A_Index-1)
						if(Chr(sc.2007(CPos))="(")
							GotoPos(A_Index-1,CPos+1)
						else
							InsertMultiple(A_Index-1,CPos,"()",CPos+1)
					}
					Continue
				}
				if(v.word="#Include"&&v.Options.Disable_Include_Dialog!=1)
					SetTimer("GetInclude",-200)
				else if(v.word~="i)\b(Goto|Gosub)\b")
					SetTimer("Goto",-100)
				else if(v.word="SetTimer")
					SetTimer("ShowLabels",-80)
				else if(Syntax:=Keywords.GetXML(Current(3).Lang).SSN("//*[text()='" v.word "']/@syntax").text){
					if(SubStr(syntax,1,1)="(")
						SetTimer("AutoParen",-40)
					else
						SetTimer("AutoMenu",-50)
					Continue
					AutoParen:
					Loop,% sc.2570{
						CPos:=sc.2585(A_Index-1)
						if(sc.2007(CPos-1)!=40&&sc.2007(CPos)!=40)
							InsertMultiple(A_Index-1,CPos,"()",CPos+1)
						if(sc.2007(CPos)=40)
							GotoPos(A_Index-1,CPos+1)
						if(!Context(1))
							GotoPos(A_Index-1,CPos+1)
					}Context()
					Continue
				}else if(node:=CEXML.SSN("//main[@id='" Current(2).ID "']/descendant::*[@text='" v.word "']")){
					Type:=SSN(node,"@type").text
					if(Type~="Class|Instance")
						SetTimer("AutoClass",-100)
					else if(Add:=Keywords.GetXML(Current(3).Lang).SSN("//Code/descendant::" Type "/@autoadd").text){
						if(Add="(")
							SetTimer("AutoParen",-40)
				}}else
					SetTimer("AutoMenu",-50)
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
	static NewWin,Select:=[],Pre,Sort,Search,Running
	if(HWND(20))
		return
	sc:=CSC()
	if(sc.notes)
		CSC({hwnd:gui.SSN("//*[@type='Scintilla']/@hwnd").text}),sc:=CSC(),sc.2400
	Update({sc:sc.2357}),Code_Explorer.AutoCList(1)
	NewWin:=new GUIKeep(20),NewWin.Add("Edit,goss w600 vsearch,,w","ListView,w600 h200 -hdr -Multi gosgo,Menu C|A|1|2|R|I,wh")
	Gui,1:-Disabled
	GuiControl,20:,Edit1,%start%
	Hotkey,IfWinActive,% NewWin.ID
	for a,b in {up:"OmniKey",down:"OmniKey",PgUp:"OmniKey",PgDn:"OmniKey","^Backspace":"deleteback",Enter:"OSGo",NumpadEnter:"OSGo"}{
		Try
			Hotkey,%a%,%b%,On
		Catch,e
			m(e.message,a,b)
	}NewWin.Show("Omni-Search: Fuzzy Search find Check For Update by typing @CFU",,,StrLen(start)),Sleep(400) ;,NewWin.Size()
	oss:
	Break:=1,Running:=1
	SetTimer,OmniSearch,-10
	return
	OmniSearch:
	Gui,20:Default
	GuiControl,20:-Redraw,SysListView321
	Language:=Current(3).Lang
	FileSearch:=OSearch:=Search:=NewWin[].Search,SearchString:="",Select:=[],LV_Delete(),Sort:=[],stext:=[],fsearch:=Search="^"?1:0,NewWin.Instructions:=0
	if(InStr(Search,")")){
		if(!v.Options.Clipboard_History){
			Options("Clipboard_History")
			m("Clipboard History was off. Turning it on now")
			return Running:=0
		}LV_Delete()
		for a in v.Clipboard
			b:=v.Clipboard[v.Clipboard.MaxIndex()-(A_Index-1)],Sort[LV_Add("",b)]:=b
		LV_ModifyCol(1,"AutoHDR")
		GuiControl,20:+Redraw,SysListView321
		return Running:=0
	}
	if(InStr(Search,"?")||Search=""){
		LV_Delete(),NewWin.Instructions:=1
		for a,b in Keywords.Prefix[Language]
			LV_Add("Sort",b.Prefix,b.Type,Convert_Hotkey(menus.SSN("//*[@clean='" b.Type "_Search']/@hotkey").text))
		GuiControl,20:+Redraw,SysListView321
		Loop,4
			LV_ModifyCol(A_Index,"AutoHDR")
		return LV_Modify(1,"Select Vis Focus"),Running:=0
	}else if(Search="^"){
		LV_Delete()
		all:=CEXML.SN("//files/main"),MainFile:=Current(2).File,FileList:=[]
		while(aa:=all.Item[A_Index-1],ea:=XML.EA(aa)){
			Split:=SplitPath(ea.File),(ea.File=MainFile?FileList.InsertAt(1,[Split.FileName,"File",Split.Dir,aa]):FileList.Push([Split.FileName,"File",Split.Dir,aa]))
		}for a,b in FileList
			LV_Add("",b.1,b.2,b.3),Select[A_Index]:=SSN(b.4,"file")
		GuiControl,20:+Redraw,SysListView321
		Loop,3
			LV_ModifyCol(A_Index,"AutoHDR")
		return LV_Modify(1,"Select Vis Focus"),Running:=0
	}else if(Search~="\W"){
		PreFixList:=[],Types:=[]
		if(!IsObject(Keywords.Prefix[Language])){
			for a,b in {"^":"File","@":"Menu"}{
				Search:=RegExReplace(Search,"\Q" a "\E",,Count)
				if(Count)
					SearchString.="@type='" b "' or ",PreFixList.Push(b),Types[b]:=1
		}}else
			for a,b in Keywords.Prefix[Language]{
				Search:=RegExReplace(Search,"\Q" b.Prefix "\E",,Count)
				if(Count)
					SearchString.="@type='" b.Type "' or ",PreFixList.Push(b.Type),Types[b.Type]:=1
	}}else
		find:="//files/descendant::*|//Libraries/descendant::*|//menu/descendant::*"
	SearchString:=Trim(SearchString," or ")
	for a,b in searchobj:=StrSplit(Search)
		b:=b~="(\\|\.|\*|\?|\+|\[|\{|\||\(|\)|\^|\$)"?"\" b:b,stext[b]:=stext[b]=""?1:stext[b]+1
	Search:=Trim(Search)
	if(Search){
		Contains:="",SearchLetter:=[]
		for a,b in StrSplit("clean,text,filename",","){
			Contains.=" or (",Line:=""
			for c,d in StrSplit(Format("{:L}",Search)){
				if(!SearchLetter[d]),SearchLetter[d]:=1
					Line.="contains(translate(@" b ", 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'),'" d "') and "
			}
			Contains.=Trim(Line," and ") ")",SearchLetter:=[]
		}
		if(SearchString)
			List:=CEXML.SN("//*[(" SearchString ") and (" Trim(Contains," or ") ")]")
		else
			List:=CEXML.SN("//*[" Trim(Contains," or ") "]")
	}else
		List:=CEXML.SN("//*[" SearchString "]"),Break:=0,CurrentParent:=Current(2).File
	RegExMatch(OSearch,"OU)(\w+\.)",FileFind),Index:=0,CurrentProject:=Current(2).File,FileFind:=FileFind.1
	while(ll:=List.Item[A_Index-1],b:=XML.EA(ll)){
		if(b.Type="Menu"){
			Clean:=b.Clean
			if Clean in Menu_Search,Add_Function_Call,Function_Search,Bookmark_Search,Variable_Search,Hotkey_Search,Property_Search,Instance_Search,Method_Search,Class_Search,File_Search,Omni_Search
				Continue
		}
		if(Break),Break:=0
			Break
		Order:=ll.NodeName="file"?"filename,type,dir":b.Type="Menu"?"text,type,additional1":"text,type,file,args",info:=StrSplit(Order,","),text:=b[info.1],Rating:=0
		if(!b.id)
			IDS:=SN(ll,"ancestor::file"),b.ID:=SSN(IDS.Item[IDS.Length-1],"@id").text
		if(b.Type="File")
			Rating+=500/InStr(b.File,".")
		if(!b.File)
			b.File:=SSN(ll,"file[@id='" b.id "']/@file").text
		if(!b.FileName)
			b.FileName:=SplitPath(b.File).FileName
		if(v.Options.HasKey(b.clean))
			b.Type:=(v.Options[b.clean]?"Enabled":"Disabled")
		if(CurrentProject=SSN(ll,"ancestor::main/@file").text)
			Rating+=1000
		else if(Types[b.Type])
			Rating+=555
		if(Search){
			TotalThings:=""
			for c,d in StrSplit(Search){
				RegExReplace(text,"i)" d,"",count)
				if(Count<stext[d])
					Continue,2
				if(Pos:=RegExMatch(text,Upper(d)))
					Rating+=400/A_Index
			}spos:=1
			for c,d in searchobj
				if(Pos:=RegExMatch(text,"iO)(\b" d ")",Found,spos),spos:=Found.Pos(1)+Found.Len(1))
					Rating+=100/Pos
			for c,d in StrSplit(FileSearch," "){
				if(text~="i)\b" d)
					Rating+=200
			}if(FPos:=InStr(Text,Search))
				Rating+=500/FPos
			if(InStr(Text,FileFind)&&FileFind)
				Rating+=200
			if(Pos:=InStr(Text,"."))
				Rating+=200/Pos
		}if(b[info.1])
			LV_Add("",b[info.1],b[info.2],(ll.ParentNode.NodeName="info"?": " SSN(ll.ParentNode,"@text").text:"") (info.3="file"?Trim(StrSplit(b[info.3],"\").Pop(),".ahk"):b[info.3]),b[info.4],Rating,++Index),Select[Index]:=ll
	}Running:=0
	Loops:=v.Options.Omni_Search_Stats?[5,[6]]:[4,[5,6]]
	Loop,% Loops.1
		LV_ModifyCol(A_Index,"AutoHDR")
	for a,b in Loops.2
		LV_ModifyCol(b,0)
	LV_ModifyCol(5,"Logical SortDesc"),LV_Modify(1,"Select Vis Focus")
	GuiControl,20:+Redraw,SysListView321
	return
	20Escape:
	20Close:
	NewWin.Exit()
	return
	OSGo:
	if(Running)
		return m("here?")
	Gui,20:Default
	LV_GetText(num,LV_GetNext(),6),Num:=Num?Num:LV_GetNext(),item:=XML.EA(Node:=Select[num]),Search:=NewWin[].Search,Pre:=SubStr(Search,1,1),LV_GetText(LV_Text,LV_GetNext())
	if(!num){
		LV_GetText(item,LV_GetNext())
		ControlGetText,text,Edit1,% HWND([20])
		if(InStr(text,"?")){
			ControlSetText,Edit1,% RegExReplace(text,"\?"),% HWND([20])
			Send,{End}
		}ControlFocus,Edit1,% HWND([20])
		Send,{%item%}
	}if(SubStr(Search,1,1)=")"){
		text:=Sort[LV_GetNext()]
		return Clipboard:=text,m("Clipboard now contains:",text,"time:1")
	}if(NewWin.Instructions){
		LV_GetText(Pre,LV_GetNext())
		ControlSetText,Edit1,%Pre%,% NewWin.id
		ControlSend,Edit1,^{End},% NewWin.id
		return
	}else if(Type:=item.launch){
		text:=Clean(item.text),NewWin.Exit()
		if(Type="label"||Type="func")
			SetTimer,%text%,-1
		else if(Type="option"){
			Options(text)
		}else{
			if(!FileExist(Type))
				MissingPlugin(Type,item.Sort)
			else{
				option:=menus.SSN("//*[@clean='" RegExReplace(item.Sort," ","_") "']/@option").text
				Run,%Type% "%option%"
		}}
	}else if(Pre="+"){
		NewWin.Exit(),args:=item.args,sc:=CSC(),args:=RegExReplace(args,"U)=?" chr(34) "(.*)" chr(34)),build:=item.text "("
		for a,b in StrSplit(args,",")
			comma:=A_Index>1?",":"",value:=InputBox(sc.sc,"Add Function Call","Insert a value for : " b " :`n" item.text "(" item.args ")`n" build ")",""),value:=value?value:Chr(34) Chr(34),build.=comma value
		build.=")"
		;~ Does this work?
		sc.2003(sc.2008,build)
	}else if(item.Type="file"||Node.NodeName="file")
		NewWin.Exit(),tv(CEXML.SSN("//*[@id='" SSN(Node,"ancestor-or-self::main/@id").text "']/descendant::*[@id='" item.id "']/@tv").text)
	else if(item.Type!="gui"){
		NewWin.Exit(),xx:=Keywords.GetXML(SSN((FileNode:=GetFileNode(Node)),"@lang").text)
		TypeInfo:=XML.EA(xx.SSN("//Code/descendant::" item.Type))
		if(TypeInfo.Multiple){
			if((tv:=SSN(FileNode,"@tv").text)!=TVC.Selection(1))
				tv(tv),Sleep(400)
			Search:=RegExReplace(TypeInfo.Regex,"\x60n","`n"),sc:=CSC(),Text:=sc.GetUNI(),Pre:=SN(Node,"preceding-sibling::*[@type='" item.Type "' and @text='" item.text "']").Length,Pos:=0
			Loop,% 1+Pre
				Pos:=RegExMatch(Text,Search,,Pos+1)
			if(TypeInfo.SelectLine){
				line:=sc.2166(StrPut(SubStr(Text,1,Pos),"UTF-8")-1),sc.2160(sc.2128(line),sc.2136(line))
			}else
				sc.2160(Pos,StrPut(Item.Text,"UTF-8")-1+Pos+Round(TypeInfo.AddSelect))
			CenterSel()
		}else
			SelectText(Node)
		return 
	}else if(item.Type="gui"){
		NewWin.Exit(),tv(CEXML.SSN("//*[@id='" item.id "']/@tv").text)
		Sleep,200
		CSC().2160(item.Pos,item.Pos+StrLen(item.text)),CenterSel()
		text:=Update({get:item.File})
		if(Search~=">.*>")
			m("Edit this GUI",SubStr(text,item.start,item.end-item.start))
		else
			m("Go to " item.text,SubStr(text,item.start,item.end-item.start))
	}else if(!item.text&&!item.Type){
		return
	}else
		m("Omni-Search",item.text,item.Type,"Broken :(") ;leave this until I figure things out.
	return
	OmniKey:
	ControlSend,SysListView321,{%A_ThisHotkey%},% NewWin.ahkid
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
	RunWait,% comspec " /C RD /S /Q " Chr(34) dir "\AHK-Studio Backup" Chr(34),,Hide
	Full_Backup()
}
Online_Help(){
	Run,https://github.com/maestrith/AHK-Studio/wiki
}
Show_Folder_In_Explorer(){
	sc:=CSC()
	file:=Current(3).file
	SplitPath,file,,dir
	if(!dir){
		file:=Current(2).file
		SplitPath,file,,dir
	}if(!dir){
		for a,b in s.ctrl{
			if(File:=CEXML.SSN("//*[@sc='" b.2357 "']/@file").text){
				SplitPath,File,,Dir
				Break
			}
		}
	}Run,%dir%
}Open_Folder(){
	Show_Folder_In_Explorer()
}
Open(FileList="",Show="",Redraw:=1){
	static root,top
	for a,b in [19,14,3,11]{
		if(HWND(b)){
			WinGetTitle,title,% HWND([b])
			return m("Please close the " title " window before proceeding")
		}
	}
	if(!FileList){
		OpenFile:=Current(2).file
		SplitPath,OpenFile,,dir
		Gui,1:+OwnDialogs
		List:=Settings.SN("//Extensions/Extension"),EXTList:=""
		while(ll:=List.item[A_Index-1]),ea:=XML.EA(ll)
			EXTList.="*." ll.text "; "
		CloseID:=CloseSingleUntitled()
		FileSelectFile,FileName,,%dir%,,% SubStr(EXTList,1,-2)
		if(ErrorLevel)
			return
		if(!FileExist(FileName))
			return m("File does not exist. Create a new file with File/New")
		SplitPath,FileName,,,ext
		if(!Settings.SSN("//Extensions/Extension[text()='" ext "']")){
			EXTList:=""
			List:=Settings.SN("//Extensions/Extension")
			while(ll:=List.item[A_Index-1]),ea:=XML.EA(ll)
				EXTList.=ll.text "`n"
			if(m("AHK Studio by default can only open these file types:","",EXTList,"","While " ext " files may be a text based file I had to add these restrictions to prevent opening media or other types of files","Would you like to add this to the List of acceptable extensions?","ico:!","btn:ync")="Yes")
				Settings.Under(Settings.SSN("//Extensions"),"Extension",,ext)
			else
				return
		}
		if(ff:=CEXML.Find("//main/@file",FileName))
			return tv(SSN(ff,"descendant::file/@tv").text)
		fff:=FileOpen(FileName,"RW","utf-8"),file1:=file:=fff.Read(fff.length)
		Gosub,addfile
		if(CloseID)
			Close(CEXML.SN("//*[@id='" CloseID "']"),,0),CloseID:=""
		TVC.Default(1)
		FileList:=SN(CEXML.Find("//main/@file",FileName),"descendant::file"),tv(SSN(CEXML.Find("//main/@file",FileName),"file/@tv").text)
		ScanFiles(),Code_Explorer.Refresh_Code_Explorer(),PERefresh(),v.TNGui.Populate(),Settings.Add("open/file",,FileName,1),TNotes.Populate()
	}else{
		CloseSingleUntitled()
		for a,b in StrSplit(FileList,"`n"){
			SplitPath,b,,,ext
			if(Ext="lnk"){
				FileGetShortcut,%b%,b
				SplitPath,b,,,Ext
			}if(Ext~="i)\b(txt|ini)"){
			}else if(!Settings.SSN("//Extensions/Extension[text()='" Format("{:L}",Ext) "']")){
				if(m("Files with the extension: " Ext " are not permitted by AHK Studio.","","Would you like to associate this file type with AHK Studio?","","Keep in mind that if you open anything other than text files it will crash AHK Studio.","btn:ync","ico:?","def:2")="Yes"){
					Settings.Add("Extensions/Extension",,Format("{:L}",Ext),1)
				}else
					Exit
			}if(CEXML.Find("//main/@file",b))
				Continue
			fff:=FileOpen(b,"RW","utf-8"),file1:=file:=fff.Read(fff.Length),FileName:=b
			Gosub,addfile
		}
		SetTimer,ScanFiles,-1000
		tv:=SSN(CEXML.Find("//main/@file",StrSplit(FileList,"`n").1),"descendant::file/@tv").text,PERefresh(),v.TNGui.Populate(),Settings.Add("open/file",,FileName,1)
		if(Show)
			tv(tv)
		TNotes.Populate()
		return tv
	}
	return root
	AutoExpand:
	TVC.Default(1),current:=TV_GetSelection(),next:=0,TVState()
	all:=CEXML.SN("//main/descendant::*")
	while(aa:=all.item[A_Index-1]),ea:=XML.EA(aa)
		if(SSN(aa,"descendant::*"))
			TV_Modify(ea.tv,"+Expand")
	TVState(1),TV_Modify(current,"Select Vis Focus")
	return
	addfile:
	Gui,1:Default
	SplitPath,FileName,fn,dir,,nne
	FileGetTime,time,%FileName%
	TVC.Disable(1)
	Extract(GetMainNode(FileName)),FEUpdate()
	/*
		if(!Settings.SSN("//open/file[text()='" FileName "']"))
			Settings.Add("open/file",,FileName,1)
	*/
	Gui,1:Default
	if(Redraw)
		TVC.Redraw(1)
	if(!v.Opening)
		TVC.Enable(1)
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
		disable:="Center_Caret|Disable_Autosave|Disable_Backup|Disable_Exemption_Handling|Disable_Line_Status|Disable_Match_Brace_Highlight_On_Delete|Disable_Variable_List|End_Document_At_Last_Line|Hide_File_Extensions|Hide_Horizontal_Scrollbars|Hide_Indentation_Guides|Hide_Vertical_Scrollbars|Remove_Directory_Slash|Run_As_Admin|Show_Caret_Line|Show_EOL|Show_WhiteSpace|Virtual_Space|Warn_Overwrite_On_Export|Word_Wrap_Indicators"
		options:="Add_Margins_To_Windows|Add_Space_After_Includes_On_Publish|Auto_Check_For_Update_On_Startup|Auto_Close_Find|Auto_Complete|Auto_Complete_In_Quotes|Auto_Complete_While_Tips_Are_Visible|Auto_Expand_Includes|Auto_Indent_Comment_Lines|Auto_Set_Area_On_Quick_Find|Auto_Space_After_Comma|Auto_Variable_Browser|Autocomplete_Enter_Newline|Brace_Match_Background_Match|Build_Comment|Case_Sensitive|Center_Caret|Check_For_Edited_Files_On_Focus|Clipboard_History|Context_Sensitive_Help|Copy_Selected_Text_on_Quick_Find|Current_Area|Disable_Auto_Advance|Disable_Auto_Complete|Disable_Auto_Delete|Disable_Auto_Indent_For_Non_Ahk_Files|Disable_Auto_Insert_Complete|Disable_Autosave|Disable_Backup|Disable_Compile_AHK|Disable_Folders_In_Project_Explorer|Disable_Include_Dialog|Disable_Line_Status|Disable_Variable_List|Enable_Close_On_Save|End_Document_At_Last_Line|Focus_Studio_On_Debug_Breakpoint|Full_Auto_Indentation|Full_Backup_All_Files|Full_Tree|Global_Debug_Hotkeys|Greed|Hide_File_Extensions|Hide_Indentation_Guides|Highlight_Current_Area|Includes_In_Place|Inline_Brace|Manual_Continuation_Line|Multi_Line|New_File_Dialog|New_Include_Add_Space|Omni_Search_Stats|OSD|Publish_Indent|Regex|Remove_Directory_Slash|Require_Enter_For_Search|Run_As_Admin|Select_Current_Debug_Line|Shift_Breakpoint|Show_Caret_Line|Show_EOL|Show_WhiteSpace|Small_Icons|Smart_Delete|Top_Find|Verbose_Debug_Window|Warn_Overwrite_On_Export|Word_Border"
		other:="Auto_Space_After_Comma|Auto_Space_Before_Comma|Autocomplete_Enter_Newline|Disable_Auto_Delete|Disable_Auto_Insert_Complete|Disable_Folders_In_Project_Explorer|Disable_Include_Dialog|Enable_Close_On_Save|Force_UTF-8|Full_Tree|Hide_Library_Files_In_Code_Explorer|Hide_Tray_Icon|Highlight_Current_Area|Manual_Continuation_Line|Match_Any_Word|Small_Icons|Top_Find"
		special:="Word_Wrap"
		alloptions.=disable "|" options "|" other "|" special
		Sort,alloptions,UD|
		for a,b in StrSplit(alloptions,"|")
			v.Options[b]:=0,v.AllOptions[b]:=1
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
		sc:=CSC(),OnOff:=Settings.SSN("//options/@" x).text?0:1,att:=[],att[x]:=OnOff,Settings.Add("options",att),v.Options[x]:=OnOff,ToggleMenu(x),sc[list[x]](OnOff),ea:=Settings.EA("//options")
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
			fl:=CEXML.SN("//file")
			TVC.Redraw(1,0)
			while(ff:=fl.item[A_Index-1]),ea:=XML.EA(ff)
				TVC.Modify(1,(ea.edited?"*":"")(v.Options.Hide_File_Extensions?ea.nne:ea.filename),ea.tv)
			TVC.Redraw(1)
		}if(x="Remove_Directory_Slash")
			FEUpdate(1)
		if(x="margin_left")
			CSC().2155(0,6)
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
				sc:=CSC(),sc.2045(2),sc.2045(3)
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
	static List:=new XML("OSD"),top,Win:="OSD",MenuXML
	if(!v.Options.OSD)
		return
	if(!IsObject(MenuXML)){
		if(!FileExist(A_ScriptDir "\Lib\Base Menu.xml"))
			URLDownloadToFile,https://raw.githubusercontent.com/maestrith/AHK-Studio/master/lib/menus.xml,%A_ScriptDir%\Lib\Base Menu.xml
		MenuXML:=new XML("menus",A_ScriptDir "\Lib\Base Menu.xml")
	}if(!HWND(Win)){
		rem:=List.SSN("//list"),rem.ParentNode.RemoveChild(rem)
		Gui,Win:Destroy
		Gui,Win:Default
		Gui,Color,0x111111,0x111111
		Gui,+hwndhwnd +Owner1 -DPIScale
		Gui,Margin,0,0
		HWND(Win,hwnd)
		Gui,Font,s12 c0xff00ff,Consolas
		Gui,Add,ListView,w500 h300 -Hdr,info|x
		Gui,Show,x0 y0 w0 h0 Hide NA,OSD
		WinGetPos,x,y,w,h,% HWND([1])
		Gui,-Caption
		Gui,Win:Show,% "x" (x+w-MainWin.Border)-(500) " y" y+h-(300+MainWin.Border) " NA AutoSize",OSD
		top:=List.Add("list")
	}show:=RegExReplace(show,"_"," ")
	Gui,Win:Default
	Gui,Win:ListView,SysListView321
	if((ea:=XML.EA(Node:=List.SSN("//list").LastChild())).name=show)
		Node.SetAttribute("count",ea.count+1)
	else
		Node:=List.Under(top,"item",{name:show,count:1})
	LV_Delete()
	all:=List.SN("//item")
	while(aa:=all.item[A_Index-1],ea:=XML.EA(aa))
		LV_Add("",ea.name " " Convert_Hotkey(MenuXML.SSN("//*[@clean='" Clean(ea.Name) "']/@hotkey").text),ea.count)
	Loop,2
		LV_ModifyCol(A_Index,"AutoHDR")
	SetTimer,KillOSD,-2000
	return
	KillOSD:
	HWND({rem:Win,na:1}),rem:=List.SSN("//list"),rem.ParentNode.RemoveAttribute(rem)
	return
}
Paste(){
	ControlGetFocus,Focus,% MainWin.ID
	if(Focus="Edit1"){
		SendMessage,0x302,0,0,Edit1,% MainWin.ID
		return
	}sc:=CSC(),Line:=sc.2166(sc.2008),sc.2078(),sc.2179(),MarginWidth(sc),Edited(),RegExReplace(Clipboard,"\n",,Count)
	Loop,% Count+1
		LineStatus.Add(Line+(A_Index-1),2)
	sc.2079
	sc.2078
	if(v.Options.Full_Auto_Indentation&&Current(3).Lang="ahk")
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
	TVC.Redraw(1)
}
Personal_Variable_List(){
	static
	NewWin:=new GUIKeep(6),NewWin.Add("ListView,w200 h400,Variables,wh","Edit,w200 vvariable,,yw","Button,gaddvar Default,&Add,y","Button,x+10 gvdelete,&Delete Selected,y")
	NewWin.Show("Variables",1),vars:=Settings.SN("//Variables/*")
	ControlFocus,Edit1,% HWND([6])
	while(vv:=vars.item(A_Index-1))
		LV_Add("",vv.text)
	ControlFocus,Edit1,% HWND([6])
	return
	vdelete:
	while(LV_GetNext()){
		LV_GetText(String,LV_GetNext()),Rem:=Settings.SSN("//Variable[text()='" String "']")
		Rem.ParentNode.RemoveChild(Rem),LV_Delete(LV_GetNext())
	}GuiControl,6:,Edit1,%String%
	return
	addvar:
	if(!variable:=NewWin[].variable)
		return
	if(!Settings.SSN("//Variables/Variable[text()='" variable "']"))
		Settings.Add("Variables/Variable",,variable,1),LV_Add("",variable)
	Settings.Transform()
	ControlSetText,Edit1,,% HWND([6])
	return
	6Close:
	6Escape:
	Keywords.RefreshPersonal(),NewWin.SavePos(),HWND({Rem:6})
	return
}
Plug(Refresh:=0){
	if(!FileExist(A_ScriptDir "\Plugins"))
		FileCreateDir,%A_ScriptDir%\Plugins
	plHks:=[]
	if(Refresh){
		list:=Menus.SN("//main/menu[@clean='Plugin']/menu")
		while(ll:=list.item[A_Index-1],ea:=XML.EA(ll))
			ll.ParentNode.RemoveChild(ll)
	}
	if(!Plugin:=Menus.SSN("//menu[@clean='Plugin']"))
		Plugin:=Menus.Add("menu",{clean:"Plugin",name:"P&lugin"},,1)
	Loop,Files,Plugins\*.ahk
	{
		FileRead,plg,%A_LoopFileFullPath%
		Pos:=LastPos:=1
		while(RegExMatch(plg,"Oim)^\s*\;menu\s+(.*)\R",Found,Pos),Pos:=Found.Pos(1)+1){
			if(Pos=LastPos),LastPos:=Pos
				Break
			item:=StrSplit(Found.1,","),item.1:=Trim(item.1,"`r|`r`n|`n")
			if(!ii:=Menus.SSN("//*[@clean='" Clean(Trim(item.1)) "']"))
				ii:=Menus.Under(Plugin,"menu",{name:Trim(item.1),clean:Clean(item.1),plugin:A_LoopFileFullPath,option:item.2,hotkey:plHks[item.1]}),Refresh:=1
			else
				ii.SetAttribute("Plugin",A_LoopFileFullPath),ii.SetAttribute("option",item.2)
			Pos:=Found.Pos(1)+1
		}if(RegExMatch(plg,";Startup"))
			ii.SetAttribute("startup",1)
	}if(Refresh){
		Menus.Transform()
		SetTimer,RefreshMenu,-300
	}
	return
	RefreshMenu:
	Gui,1:Default
	MenuWipe()
	Gui,1:Menu,% Menu("main")
	return
}
PosInfo(){
	sc:=CSC(),current:=sc.2008,line:=sc.2166(current),ind:=sc.2128(line),lineend:=sc.2136(line)
	if(sc.2008!=sc.2009)
		startline:=sc.2166(sc.2143),endline:=sc.2166(sc.2145-(sc.2007(sc.2145-1)=10?1:0))
	else
		startline:=endline:=sc.2166(sc.2143)
	return {current:current,line:line,ind:ind,lineend:lineend,start:sc.2143,end:sc.2145,startline:startline,endline:endline}
}
Previous_File(){
	TVC.Default(1),prev:=0,tv:=TV_GetSelection()
	while(tv!=prev:=TV_GetNext(prev,"F"))
		newtv:=prev
	TV_Modify(newtv,"Select Vis Focus")
}
Previous_Found(){
	sc:=CSC(),current:=sc.2575,total:=sc.2570-1,(current=0)?sc.2574(total):sc.2574(--current),CenterSel()
}
Previous_Project(){
	current:=Current(1)
	next:=current.previousSibling?current.previousSibling:current.ParentNode.LastChild
	if(SSN(next,"@file").text="Libraries")
		next:=next.previousSibling
	tv(SSN(next,"descendant::*/@tv").text)
}
Previous_Scripts(FileName=""){
	static nw
	nw:=new GUIKeep("Previous_Scripts"),nw.Add("Edit,w430 gPSSort vSort,,w","ListView,w430 h400,File|Date,wh","Button,xm gPSOpen Default,&Open Selected,y","Button,x+M gPSRemove,&Remove Selected,y","Button,x+M gPSClean,&Clean Up Deleted Projects,y"),nw.show("Previous Scripts"),Hotkeys("Previous_Scripts",{up:"pskey",down:"pskey",PgUp:"pskey",PgDn:"pskey","+up":"pskey","+down":"pskey"})
	Gosub,populateps
	return
	PSSort:
	PSBreak:=1
	Sleep,20
	PSBreak:=0
	Goto,populateps
	return
	PSClean:
	scripts:=Settings.SN("//previous_scripts/*"),filelist:=[]
	while(ss:=scripts.item[A_Index-1],ea:=XML.EA(ss))
		if(!FileExist(ss.text))
			filelist.push(ss)
	for a,b in filelist
		b.ParentNode.RemoveChild(b)
	m("Removed " Round(filelist.MaxIndex()) " file" (filelist.MaxIndex()=1?"":"s")),WinActivate(HWND([nw.win]))
	Goto,PopulatePS
	return
	PSRemove:
	filelist:=[]
	while(next:=LV_GetNext())
		LV_GetText(file,next),filelist[file]:=1,LV_Modify(next,"-Select")
	scripts:=Settings.SN("//previous_scripts/*")
	while(scr:=scripts.item[A_Index-1])
		if(filelist[scr.text])
			scr.ParentNode.RemoveChild(scr)
	Goto,populateps
	return
	pskey:
	key:=RegExReplace(A_ThisHotkey,"\+",,count),shift:=count?"+":""
	ControlSend,SysListView321,%shift%{%key%},% HWND([nw.win])
	return
	Previous_ScriptsClose:
	Previous_ScriptsEscape:
	nw.Exit()
	return
	PSOpen:
	Default("SysListView321","Previous_Scripts"),OpenList:=""
	while(next:=LV_GetNext())
		LV_GetText(file,next),OpenList.=file "`n",LV_Modify(next,"-Select")
	Open(Trim(OpenList,"`n")),tv(SSN(CEXML.Find("//file/@file",StrSplit(OpenList,"`n").1),"@tv").text),nw.Exit()
	return
	PopulatePS:
	Gui,Previous_Scripts:Default
	Gui,Previous_Scripts:ListView,SysListView321
	scripts:=Settings.SN("//previous_scripts/*")
	LV_Delete(),Sort:=nw[].Sort
	while(scr:=scripts.item[A_Index-1]){
		if(PSBreak)
			Break
		Info:=scr.text
		SplitPath,Info,FileName
		if(!FileExist(Info)){
			LV_Add("",FileName,"File No Longer Exists, Please click Clean Up Deleted Projects")
			Continue
		}
		FileGetTime,Time,%Info%
		FormatTime,Time,%Time%,yyyy-MM-dd HH:mm:ss
		if(InStr(FileName,Sort))
			LV_Add("",Info,Time)
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
Project_Properties(){
	static NewWin
	if(!Settings.SSN("//ExeList")){
		Top:=Settings.Add("ExeList")
		SplitPath,A_AhkPath,,Dir
		Loop,Files,%Dir%\*.exe,FR
		{
			if(InStr(A_LoopFileName,"AutoHotkey")||InStr(A_LoopFileName,"ahk2exe")){
				FileGetVersion,Version,%A_LoopFileLongPath%
				Settings.Under(Top,"Exe",{exe:A_LoopFileFullPath,ver:Version})
	}}}
	NewWin:=new GuiKeep("Project_Properties")
	NewWin.Add("Text,,Project: " SplitPath(Current(2).File).NNE
			,"ListView,w500 h200 vPPLV,Execute With|Version"
			,"Text,,Command Line Parameters:"
			,"Edit,vPPCLP w500"
			,"Button,gPPAE,Add Exe to the list"
			,"Button,gPPSet,Set"
			,"Button,x+M gPPDelete,Delete Association")
	NewWin.Show("Project Properties")
	Gosub,PPPopulate
	return
	PPAE:
	FileSelectFile,File,,,Launch Projects With...,*.exe
	if(ErrorLevel||!FileExist(File))
		return
	if(!Settings.Find("//ExeList/Exe/@exe",File)){
		FileGetVersion,Ver,%File%
		Top:=Settings.Add("ExeList")
		New:=Settings.Under(Top,"Exe",{exe:File,ver:Ver},,1),SetTimer("PPPopulate","-1")
	}
	return
	PPSet:
	NewWin.Default("PPLV"),LV_GetText(Exe,LV_GetNext()),Obj:=NewWin[]
	if(!LV_GetNext())
		return m("Please select an EXE to run this Project with")
	if(!Node:=Settings.Find("//ExecProject/Exec/@project",(Project:=Current(2).File)))
		Node:=Settings.Add("ExecProject/Exec",{project:Project})
	Node.SetAttribute("exe",Exe),Node.SetAttribute("cmd",Obj.PPCLP)
	return NewWin.Close()
	PPPopulate:
	Node:=Settings.Find("//ExecProject/Exec/@project",(Project:=Current(2).File))
	GuiControl,Project_Properties:,Edit1,% SSN(Node,"@cmd").text
	Def:=SSN(Node,"@exe").text
	NewWin.Default("PPLV"),LV_Delete()
	All:=Settings.SN("//ExeList/Exe")
	while(aa:=All.Item[A_Index-1],ea:=XML.EA(aa)){
		LV_Add((ea.Exe=Def?"Select Vis Focus":""),ea.Exe,ea.Ver)
	}Loop,% LV_GetCount("Column")
		LV_ModifyCol(A_Index,"AutoHDR")
	return
	PPDelete:
	if(Node:=Settings.Find("//ExecProject/Exec/@project",(Project:=Current(2).File)))
		Node.ParentNode.RemoveChild(Node),m("Assocation Removed")
	else
		m("No Assocation found.")
	return
}
Project_Specific_AutoComplete(){
	static
	if(!Node:=Settings.Find("//autocomplete/project/@file",Current(2).file))
		Node:=Settings.Add("autocomplete/project",{file:Current(2).file},,1)
	NewWin:=new GuiKeep("Project_Specific_AutoComplete")
	NewWin.Add("ListView,w300 h300,Word List,wh","Button,gPSAAdd Default,&Add,y","Button,x+M gPSADelete,Delete Selected (Delete),y"),NewWin.Show("Project Specific AutoComplete")
	Hotkeys("Project_Specific_AutoComplete",{Delete:"PSADelete"})
	Goto,PSAPopulate
	return
	PSAPopulate:
	Default("SysListView321","Project_Specific_AutoComplete"),LV_Delete()
	for a,b in StrSplit(Node.text," ")
		LV_Add("",b)
	return
	PSAAdd:
	text:=InputBox(HWND("Project_Specific_AutoComplete"),"Add Words","Add a list of Space Delimited Words")
	for a,b in StrSplit(text," ")
		if(!RegExMatch(Node.text,"\b\Q" b "\E\b"))
			Node.text:=Node.text " " b
	Goto,PSAPopulate
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
	HWND({rem:"Project_Specific_AutoComplete"})
	return
}
Add_Selected_To_Project_Specific_AutoComplete(){
	text:=CSC().getseltext()
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
Publish(Return="",Branch:="",Version:=""){
	static Init
	sc:=CSC(),Text:=Update("get").1,Save(),MainFile:=Current(2).file,Publish:=Update({Get:MainFile}),includes:=SN(Current(1),"descendant::*/@include[not(@nocompile)]/.."),ea:=XML.EA(Keywords.GetXML((Language:=Current(3).Lang)).SSN("//AutoReplace"))
	while(ii:=Includes.item[A_Index-1]){
		if(v.Options.Add_Space_After_Includes_On_Publish){
			Pos:=LastPos:=1
			while(Pos:=InStr(Publish,SSN(ii,"@include").Text,0,Pos)){
				Split:=StrSplit(Publish,"`n")
				if(Pos=LastPos),LastPos:=Pos
					Break
				RegExReplace(SubStr(Publish,1,Pos),"\R",,Count)
				Replace:=Update({Get:SSN(ii,"@file").Text})
				if(Trim(Split[Count])&&v.Options.Add_Space_After_Includes_On_Publish)
					Replace:="`n" Replace
				if(Trim(Split[Count+2])&&v.Options.Add_Space_After_Includes_On_Publish)
					Replace.="`n"
				StringReplace,Publish,Publish,% SSN(ii,"@include").Text,%Replace%
				Pos++
		}}else{
			if(InStr(Publish,SSN(ii,"@include").Text)){
				StringReplace,Publish,Publish,% SSN(ii,"@include").Text,% Update({Get:SSN(ii,"@file").Text}) (v.Options.Add_Space_After_Includes_On_Publish?"`n":""),All
	}}}rem:=SN(Current(1),"descendant::remove")
	while(rr:=rem.Item[A_Index-1])
		Publish:=RegExReplace(Publish,"m)^\Q" SSN(rr,"@inc").Text "\E$")
	Publish:=RegExReplace(Publish,"\R","`r`n")
	if(RegExMatch(Publish,ea.Version)&&ea.Version){
		if(!Version)
			if(!Version:=SSN(VVersion.Find("//info/@file",Current(2).File),"descendant::*[@select]/ancestor-or-self::version/@name").text)
				return m("Version not set or selected for this Project.","Please select the version in the window that is about to show in order for this to work"),new Version_Tracker()
		Change:=Settings.SSN("//auto_version").Text?Settings.SSN("//auto_version").Text:"Version:=""" Version """"
		if(InStr(Change,"$v"))
			Publish:=RegExReplace(Publish,ea.Version,RegExReplace(Change,"\Q$v\E",Version))
		else
			Publish:=RegExReplace(Publish,ea.Version,Version)
	}if(RegExMatch(Publish,ea.Branch)&&ea.Branch){
		if(!Branch)
			if(!Branch:=SSN(VVersion.Find("//info/@file",Current(2).File),"descendant::*[@select]/ancestor::branch/@name").text)
				return m("Branch not set for this Project."),new Version_Tracker()
		Change:=(AutoBranch:=Settings.SSN("//auto_branch").Text)?AutoBranch:"Branch:=""" Branch """"
		if(InStr(Change,"$v"))
			Publish:=RegExReplace(Publish,ea.Branch,(Change:=RegExReplace(Change,"\Q$v\E",Branch)))
		else
			Publish:=RegExReplace(Publish,ea.Branch,"Branch:=""" Branch """")
	}Publish:=RegExReplace(Publish,"U)^\s*(;\{.*\R|;\}.*\R)","`n")
	Publish:=RegExReplace(Publish,"Uim`n)^\s*\x23Include(.*)(\R|$)")
	if(!Publish)
		return sc.GetEnc()
	if(Language="ahk"){
		Pos:=1
		while(RegExMatch(Publish,"Oim`n)(\x23Include(.*)[$|\R]?)",Found,Pos),Pos:=Found.Pos(1)+Found.Len(1)){
			if(Pos=LastPos),LastPos:=Pos
				Break
			if(RegExMatch(Found.2,"O)<(.*)>",FF)){
				if(FileExist((Load:=Current(3).Dir "\Lib\" FF.1 ".ahk"))){
					FileRead,FileText,%Load%
					Publish:=RegExReplace(Publish,Found.1,FileText)
				}else if(FileExist((Load:=A_MyDocuments "\AutoHotkey\Lib\" FF.1 ".ahk"))){
					FileRead,FileText,%Load%
					Publish:=RegExReplace(Publish,Found.1,FileText)
	}}}}
	OtherInc:=ES(Chr(34) MainFile Chr(34)),OtherInc:=Trim(RegExReplace(OtherInc,"i)" Chr(35) "include(again)?\s+"),"`n")
	for a,b in StrSplit(OtherInc,"`n","`r"){
		if(FileExist(b)!="D"){
			FileRead,Contents,%b%
			if(!InStr(Publish,Contents))
				Publish.="`n" (v.Options.Add_Space_After_Includes_On_Publish?"`n":"") Contents
	}}
	if(v.Options.Publish_Indent)
		Publish:=PublishIndent(Publish)
	if(Return)
		return Publish
	Clipboard:=Publish ;v.Options.Full_Auto_Indentation?PublishIndent(Publish):Publish
	TrayTip,AHK Studio,Code copied to your clipboard
	return
}
ES(Script,Wait:=true){
	SplitPath,Script,,Dir
	Shell:=ComObjCreate("WScript.Shell"),Shell.CurrentDirectory:=Trim(Dir,Chr(34)),Exec:=Shell.Exec(A_AhkPath " /ilib * " Chr(34) RegExReplace(script,"\x22") Chr(34)),Exec.StdIn.Close()
	if(Wait){
		Return:=Exec.StdOut.ReadAll(),Shell.CurrentDirectory:=A_ScriptDir
		return Return
	}Shell.CurrentDirectory:=A_ScriptDir
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
			while(((Found:=SubStr(Text,A_Index,1))~="}|\s")){
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
	/*
		if(Braces)
			throw Exception("Include Open! You have " braces " open braces")
	*/
	return SubStr(Out,StrLen(Newline)+1)
}
QF(x:=0){
	static QuickFind:=[],Find,LastFind:=[],Break,Select,MinMax:=new XML("MinMax"),Search
	qf:
	if(v.Options.Require_Enter_For_Search&&x!="Enter")
		return
	if(x=1)
		LastFind:=[]
	sc:=CSC(),Break:=1
	ControlGetText,Find,,% "ahk_id" MainWin.QFEdit
	if(Find=LastFind&&sc.2570>1){
		if(GetKeyState("Shift","P"))
			return Current:=sc.2575,sc.2574((Current=0)?sc.2570-1:Current-1),CenterSel()
		return sc.2606(),CenterSel()
	}pre:="O",Find1:="",Find1:=v.Options.Regex?Find:"\Q" RegExReplace(Find,"\\E","\E\\E\Q") "\E",pre.=v.Options.greed?"":"U",pre.=v.Options.case_sensitive?"":"i",pre.=v.Options.multi_line?"m`n":"",Find1:=pre ")" (v.Options.Word_Border?"\b":"") Find1 (v.Options.Word_Border?"\b":"")
	if(Find=""||Find="."||Find=".*"||Find="\")
		return sc.2571
	sc.Enable(),OPos:=Select.OPos,Select:=[],Select.OPos:=OPos?OPos:sc.2008,Select.Items:=[],Text:=sc.GetUNI()
	if(sc.2508(0,Start:=QuickFind[sc.2357]+1)!=""){
		End:=sc.2509(0,Start)
		if(End)
			Text:=SubStr(Text,1,End)
	}Pos:=Start?Start:1,Pos:=Pos=0?1:Pos,Break:=0,Start:=1,Rem:=MinMax.SSN("//list"),Rem.ParentNode.RemoveChild(Rem),Top:=MinMax.Add("list")
	while(Start<sc.2006){
		Min:=sc.2508(2,Start),Max:=sc.2509(2,Start)
		if((Min!=0||Max!=0)&&sc.2507(2,Min))
			MinMax.Under(Top,"sel",{min:Min,max:Max})
		if(Min=0&&Max=0){
			MinMax.Under(Top,"sel",{min:0,max:sc.2006})
			Break
		}if(Min||Max)
			Start:=Max
	}if(v.Options.Current_Area){
		if((Parent:=sc.2225(sc.2166(sc.2008)))>=0){
			MinMax.XML.LoadXML("<MinMax/>"),Top:=MinMax.Add("list"),Last:=sc.2224(Parent,-1),MinMax.Under(Top,"sel",{min:sc.2167(Parent),max:sc.2167(Last)})
	}}Search:=sc.GetText(),Ignore:=Settings.SSN("//QuickFind/Language[@language='" Current(3).Lang "']").Text,Pos:=1,LastPos:=0
	while(RegExMatch(Search,Find1,Found,Pos)){
		if(LastPos=Found.Pos(0)),LastPos:=Found.Pos(0)
			Break
		if(Found.Len(1)=0)
			Break
		if(Break){
			Break:=0
			Break
		}if(Found.Count()){
			if(!Found.Len(A_Index))
				Break
			Loop,% Found.Count(){
				Pos:=Found.Pos(A_Index)+Found.Len(A_Index),NS:=StrPut(SubStr(Search,1,Found.Pos(A_Index)),"UTF-8")-2
				if(Ignore)
					if(sc.2010(NS+1)~="(" Ignore ")")
						Continue,2
				if(MinMax.SSN("//*[@min<='" NS "' and @max>='" NS "']"))
					Select.Items.Push({Start:NS,End:NS+StrPut(Found[A_Index],"UTF-8")-1})
		}}else{
			Pos:=Found.Pos(0)+Found.Len(0)
			if(Found.Len=0)
				Break
			NS:=StrPut(SubStr(Search,1,Found.Pos(0)),"UTF-8")-2
			if(Ignore)
				if(sc.2010(NS+1)~="(" Ignore ")")
					Continue
			if(MinMax.SSN("//*[@min<='" NS "' and @max>='" NS "']"))
				Select.Items.InsertAt(1,{Start:NS,End:NS+StrPut(Found[0],"UTF-8")-1})
	}}LastFind:=Find
	if(Select.Items.MaxIndex()=1)
		Obj:=Select.Items.1,sc.2160(Obj.Start,Obj.End)
	else{
		Num:=-1
		while(Obj:=Select.Items.Pop()){
			if(Break)
				Break
			sc[A_Index=1?2160:2573](A_Index=1?Obj.Start:Obj.End,A_Index=1?Obj.End:Obj.Start),Num:=(Obj.End>Select.OPos&&Num<0)?A_Index-1:Num
		}if(Num>=0)
			sc.2574(Num)
	}Select:=[],sc.Enable(1),CenterSel()
	return
	Next:
	sc:=CSC(),sc.2606(),sc.2169()
	return
	Clear_Selection:
	sc:=CSC(),sc.2500(2),sc.2505(0,sc.2006),QuickFind.Remove(sc.2357)
	return
	Set_Selection:
	sc:=CSC(),sc.2505(0,sc.2006),sc.2500(2)
	if(sc.2008=sc.2009)
		Goto,Clear_Selection
	SetSel:=[]
	Loop,% sc.2570
		O:=[],O[sc.2577(A_Index-1)]:=1,O[sc.2579(A_Index-1)]:=1,SetSel.Insert({min:O.MinIndex(),Max:O.MaxIndex()})
	for a,b in SetSel
		sc.2504(b.min,b.Max-b.min)
	return
	Quick_Find:
	sc:=CSC()
	if(v.Options.Copy_Selected_Text_on_Quick_Find)
		if(Text:=sc.TextRange(sc.2143,sc.2145))
			ControlSetText,Edit1,%Text%,% HWND([1])
	if(v.Options.Auto_Set_Area_On_Quick_Find)
		Gosub,Set_Selection
	ControlFocus,,% "ahk_id" MainWin.QFEdit
	ControlSend,Edit1,^A,% HWND([1])
	LastFind:=""
	return
	Case_Sensitive:
	Regex:
	Multi_Line:
	Greed:
	Word_Border:
	Current_Area:
	Options(A_ThisLabel),LastFind:=""
	ControlGetText,Text,,% "ahk_id" MainWin.QFEdit
	if(Text)
		Goto,qf
	return
	QFText:
	SetTimer,qf,-300
	return
}
Quick_Find_Ignore(){
	static sc,Ignore
	NewWin:=new GUIKeep("SetStyles")
	Gui,+hwndSS
	Hotkey,IfWinActive,ahk_id%SS%
	Hotkey,Escape,SetStylesGuiClose,On
	sc:=new ExtraScintilla("SetStyles",{Pos:"w500 h600"})
	Color(sc,(Language:=Current(3).Lang)),v.TestingSC:=sc,sc.4006(0,Language),xx:=Keywords.GetXML(Language),all:=xx.SN("//Styles/*[@ex]")
	while(aa:=all.item[A_Index-1],ea:=XML.EA(aa)){
		if(sc.2007(sc.2006-1)!=10&&A_Index>1)
			AddText(["`n"],sc)
		AddText(["Style " ea.Style " = ",5],sc),ex:=RegExReplace(RegExReplace(ea.ex,"\\n","`n"),"\\t","`t")
		if(aa.NodeName="keyword"&&ea.ex="Personal Variables")
			AddText(["Personal Variables = " Settings.SSN("//Variables").text "`n",ea.style],sc)
		else if(aa.NodeName="keyword"&&ea.ex!="Personal Variables"){
			if(ea.Add)
				Add:=ControlFile.SSN(ea.Add).text
			AddText([ea.ex " = " aa.text " " Add "`n",ea.style],sc)
		}else if(RegExMatch(ex,"\[\d+\]")){
			pos:=1
			while(RegExMatch(ex,"OU)\[(\d+)\](.+)((\[\d+\])|$)",Found,pos),pos:=Found.Pos(1)+Found.Len(1))
				AddText([Found.2,Found.1],sc)
		}else
			AddText([ex,ea.style],sc)
	}Loop,4
		sc.2242(A_Index-1,0)
	Gui,SetStyles:Add,Text,,Enter a | Delimited list of Styles you want Quick Find to Ignore
	Gui,Add,Edit,w500 vIgnore gEditIgnore,% Settings.SSN("//QuickFind/Language[@language='" Language "']").text
	Gui,Show,,Edit Ignored Colors
	ControlFocus,Edit1,% NewWin.ID
	ControlSend,Edit1,^A,% NewWin.ID
	sc.2025(0)
	return
	SetStylesGuiEscape:
	SetStylesGuiClose:
	Gui,SetStyles:Destroy
	Settings.Save(1)
	return
	EditIgnore:
	Gui,SetStyles:Submit,Nohide
	Language:=Current(3).Lang
	if(!Node:=Settings.SSN("//QuickFind/Language[@language='" Language "']"))
		Node:=Settings.Add("QuickFind/Language",{language:Language})
	Node.text:=Trim(RegExReplace(RegExReplace(Ignore,"\D","|"),"\|+","|"),"|")
	return
}AddText(Text,sc){
	VarSetCapacity(var,(len:=StrPut(Text.1,"UTF-8"))),StrPut(Text.1,&var,len,"UTF-8"),sc.2003((start:=sc.2006()),&var),sc.ThemeTextText.=Text.1,sc.2032(start),sc.2033(len,Text.2)
}
Quick_Options(){
	new SettingsClass("Options")
}
Quick_Scintilla_Code_Lookup(){
	sc:=CSC(),word:=Upper(sc.TextRange(start:=sc.2266(sc.2008,1),end:=sc.2267(sc.2008,1))),Scintilla()
	ea:=scintilla.EA("//commands/item[@name='" word "']")
	if(ea.code){
		syn:=ea.syntax?ea.code "()":ea.code,sc.2160(start,end),sc.2170(0,[syn])
		if(ea.syntax)
			sc.2025(sc.2008-1),Context()
		return
	}
	slist:=scintilla.SN("//commands/item[contains(@name,'" word "')]"),ll:="",count:=0
	while(sl:=slist.item[A_Index-1])
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
	CSC().2011
}
Redraw(){
	WinSet,Redraw,,% MainWin.ID
}
Refresh_Code_Explorer(Project:=0){
	static NewWin
	NewWin:=new GUIKeep("Refresh_Code_Explorer")
	NewWin.Add("Text,,Re-Index the Current Project"
			,"Button,gRCECP Default,Current Project (Hit Enter)"
			,"Text,,Re-Index all of the open Projects"
			,"Button,gRCEP,&Projects"
			,"Text,,Re-Index the Library files"
			,"Button,gRCEL,&Libraries"
			,"Text,,Re-Index Both"
			,"Button,gRCEA,&Both")
	NewWin.Show("Refresh " (Project=1?"Project":"Code") " Explorer")
	return
	RCECP:
	Refresh_Current_Project(),NewWin.Exit()
	return
	RCEL:
	RCEP:
	RCEA:
	SplashTextOn,200,100,Refreshing Files,Please Wait....
	NewWin.Close(),GetPos(),Before:=SSN(Current(1).NextSibling,"@file").text,CurrentFile:=Current(2).File,FileName:=Current(3).File,Save(),Scanfile.Once:=0,TVC.Delete(1,0),TVC.Delete(2,0),TVC.Add(2,"Please Wait..."),TVC.Add(1,"Please Wait..."),sc:=CSC(),sc.2358(0,0),sc.2181(0,"Reloading, Please Wait..."),All:=CEXML.SN("//*[@sc]")
	while(aa:=All.item[A_Index-1],ea:=XML.EA(aa))
		sc.2377(0,ea.sc),aa.RemoveAttribute("sc")
	if(A_ThisLabel="RCEL"||A_ThisLabel="RCEA"){
		Rem:=CEXML.SSN("//Libraries"),Rem.ParentNode.RemoveChild(Rem)
		Index_Lib_Files(1),Code_Explorer.Refresh_Code_Explorer()
	}else if(A_ThisLabel="RCEP"||A_ThisLabel="RCEA"){
		Rem:=CEXML.SSN("//files"),Rem.ParentNode.RemoveChild(Rem)
		All:=Settings.SN("//open/file")
		while(aa:=All.item[A_Index-1])
			Extract(GetMainNode(aa.Text))
	}ScanFiles(1),Code_Explorer.Refresh_Code_Explorer(),FEUpdate(1),TV(SSN(CEXML.Find("//file/@file",FileName),"@tv").Text)
	SplashTextOff
	return
}Refresh_Project_Explorer(){
	Refresh_Code_Explorer(1)
}
Refresh_Current_File(){
	Refresh(CEXML.SN("//*[@id='" Current(3).ID "']"))
}Refresh_Current_Project(){
	Save(),GetPos(),sc:=CSC(),sc.2358(0,0),sc.2181(0,"Reloading, Please Wait..."),File:=Current(3).File,Main:=Current(2).File,Before:=(Rem:=Current(1)).NextSibling,Rem.ParentNode.RemoveChild(Rem),Open(Main)
	if(Before)
		Node:=CEXML.Find("//main/@file",Main),Node.ParentNode.InsertBefore(Node,Before)
	FEUpdate(1),tv(SSN(CEXML.Find(CEXML.Find("//main/@file",Main),"descendant::file/@file",File),"@tv").text)
}Refresh(All){
	while(aa:=All.item[A_Index-1],ea:=XML.EA(aa)){
		WinSetTitle(1,"Scanning: " ea.FileName)
		ScanFile.Scan(aa,1)
	}Code_Explorer.Refresh_Code_Explorer(),WinSetTitle()
	return
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
	ea:=Settings.EA("//theme/default"),default:=ea.Clone(),tf:=v.Options.Top_Find,cea:=Settings.EA("//theme/find"),bcolor:=(cea.tb!=""&&tf)?cea.tb:(cea.bb!=""&&!tf)?cea.bb:ea.Background,fcolor:=(cea.tf!=""&&tf)?cea.tf:(cea.bf!=""&&!tf)?cea.bf:ea.Color
	for win,b in HWND("get"){
		WinGet,ControlList,ControlList,% "ahk_id" b
		Gui,%win%:Default
		Gui,Color,% RGB(bcolor),% RGB(cea.qfb!=""?cea.qfb:bcolor)
		for a,b in StrSplit(ControlList,"`n"){
			List.=b "`n"
			if((b~="i)Static1|Button|Edit1")&&win=1){
				GuiControl,% "1:+background" RGB(bcolor) " c" RGB(fcolor),%b%
			}else{
				ControlGet,HWND,HWND,,%b%,% HWND([win])
				if(win=1&&(NodeName:=TVC.HWND[HWND])){
					if(Node:=Settings.SSN("//theme/" NodeName))
						text:=CompileFont(Node),ea:=XML.EA(Node)
					else
						text:=CompileFont(Settings.SSN("//theme/default")),ea:=Default
				}if(b="msctls_statusbar321")
					Text:=CompileFont(Statusbar),ea:=XML.EA(Statusbar)
				Gui,%win%:font,%text%,% (ea.font?ea.font:Settings.EA("//theme/default/@font").text)
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
Regex_Replace_Selected_Dialog(){
	static
	Gui,Regex:Destroy
	Gui,Regex:Default
	sc:=CSC(),Text:=sc.TextRange(sc.2585(0),sc.2587(0))
	NewWin:=new GUIKeep("Regex"),NewWin.Add("Edit,vText w500,,w","ListView,w500 r5 AltSubmit gLVRegexReplace,Name|In|Out,wh","Edit,gGoRegEx w250 vIn,Regex String,y","Edit,x+0 gGoRegEx w250 vOut,Regex Replace,wy","Edit,xm w500 h200,,wy","Button,gReplaceRegexGo,&Replace Selected,y","Button,x+M gSaveReplaceRegex,&Save,y","Button,x+M gReplaceRegexDelete,&Delete,y")
	GuiControl,Regex:,Edit1,%Text%
	NewWin.Show("Regex Replace")
	Gosub,PopulateReplaceRegex
	ControlFocus,Edit2,% NewWin.ID
	ControlSend,Edit2,^a,% NewWin.ID
	GoRegEx:
	Info:=NewWin[],Text:=RegExReplace(Info.Text,Info.In,Info.Out)
	GuiControl,Regex:,Edit4,%Text%
	return
	ReplaceRegexDelete:
	Next:=0,Default("SysListView321","Regex"),List:=[]
	while(Next:=LV_GetNext(Next)){
		LV_GetText(In,Next,2),LV_GetText(Out,Next,3)
		if(Node:=Settings.SSN("//ReplaceRegex/Replace[@in='" In "' and @out='" Out "']"))
			List.Push(Node)
	}for a,b in List
		b.ParentNode.RemoveChild(b)
	Goto,PopulateReplaceRegex
	return
	SaveReplaceRegex:
	Info:=NewWin[]
	if(!Node:=Settings.SSN("//ReplaceRegex/descendant::*[@in='" Info.In "' and @out='" Info.Out "']"))
		Name:=InputBox(NewWin.hwnd,"Name This Regex","Name for this regex"),Settings.Add("ReplaceRegex/Replace",{name:Name,in:Info.In,out:Info.Out},,1)
	else
		return m("Already exists as: " SSN(Node,"@name").text)
	PopulateReplaceRegex:
	Default("SysListView321","Regex"),LV_Delete(),all:=Settings.SN("//ReplaceRegex/Replace")
	while(aa:=all.item[A_Index-1],ea:=XML.EA(aa))
		LV_Add("",ea.Name,ea.In,ea.Out)
	Loop,% LV_GetCount("Column")
		LV_ModifyCol(A_Index,"AutoHDR")
	return
	LVRegexReplace:
	if(!LV_GetNext())
		return
	Loop,2
	{
		Default("SysListView321","Regex"),LV_GetText(II,LV_GetNext(),A_Index+1)
		GuiControl,Regex:,% "Edit" A_Index+1,%II%
	}
	return
	RegexGuiEscape:
	RegexGuiClose:
	Gui,Regex:Destroy
	return
	ReplaceRegexGo:
	sc.2078()
	Loop,% sc.2570
		Start:=sc.2585(A_Index-1),End:=sc.2587(A_Index-1),Text:=sc.TextRange(Start,End),sc.2190(Start),sc.2192(End),Text:=RegExReplace(Text,Info.In,Info.Out),sc.2194(StrPut(Text,"UTF-8")-1,Text)
	sc.2079()
	return
}
Regex_Replace_Selected(){
	sc:=CSC()
	if(sc.2008=sc.2009)
		return m("Please select some text first")
	all:=Settings.SN("//ReplaceRegex/Replace/@name")
	if(all.Length=0)
		return Regex_Replace_Selected_Dialog()
	while(aa:=all.item[A_Index-1])
		List.=aa.text "|"
	sc.2106(124),Order:=sc.2661(),sc.2660(2),sc.2117(11,Trim(List,"|")),sc.2106(32),sc.2660(1)
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
	sc:=CSC(),main:=sc.2575,sc.2671(main),sc.2606,sc.2169
}
Remove_Include(){
	current:=Current(),mainnode:=Current(1),Parent:=Current(1)
	if(Current(3).file=Current(2).file)
		return m("Can not remove the main Project")
	if(m("Are you sure you want to remove this Include?","btn:yn","def:2")="no")
		return
	MainTV:=CEXML.SSN("//main[@id='" Current(2).ID "']/file/@tv").text,HistoryEA:=Current(3)
	all:=CEXML.SN("//main[@id='" Current(2).ID "']/descendant::file"),contents:=Update("get").1,inc:=Current(3).include
	while(aa:=all.item[A_Index-1],ea:=XML.EA(aa)){
		text:=contents[ea.file]
		if(InStr(text,inc)){
			if(m("Permanently delete this file?","btn:yn","def:2")="Yes")
				FileDelete,% HistoryEA.file
			Update({file:ea.file,text:RegExReplace(text,"\R?\Q" inc "\E\R?","`n")})
			CEXML.SSN("//main[@id='" Current(2).ID "']/file").RemoveAttribute("sc")
			if(tv:=HistoryEA.tv)
				TVC.Default(1),TV_Delete(tv)
			all:=CEXML.SN("//*[@id='" HistoryEA.ID "']")
			while(aa:=all.item[A_Index-1])
				aa.ParentNode.RemoveChild(aa)
			node:=CEXML.SSN("//file[@id='" HistoryEA.ID "']"),node.ParentNode.RemoveChild(node)
			tv(MainTV),History.Remove(HistoryEA),Edited(Current(1)),WinSetTitle(1,Current(3))
			return
		}
	}
}
Remove_Scintilla_Window(){
	this:=MainWin,sc:=CSC(),pos:=this.WinPos(sc.sc),this.NewCtrlPos:={x:pos.x,y:pos.y,win:MainWin.hwnd,ctrl:sc.sc},this.Delete()
}
Remove_Spaces_From_Selected(){
	sc:=CSC()
	if(!text:=sc.GetSelText())
		return m("Select some text first")
	sc.2170(0,[RegExReplace(text,"\s")])
}
RemoveComment(text){
	text:=Trim(text,"`n")
	if(InStr(text,Chr(59)))
		text:=RegExReplace(text,"\s+" Chr(59) ".*")
	return text
}
RemoveTrackedFile(){
	if(TNotes.Node.NodeName="master")
		return m("Can not remove the Global Notes"),SetupEnter(1)
	Node:=TNotes.Node.NodeName="global"?TNotes.Node.ParentNode:TNotes.Node,extra:=Node.NodeName="main"?"`n`nThis will also delete all of the notes for this project!":"",ea:=XML.EA(Node)
	if(m("This can not be undone!"," Are you sure you want to delete the notes for " (ea.Name?ea.Name:ea.File) "?" extra,"btn:ync","ico:!","def:2")="Yes"){
		if(Next:=Node.NextSibling?Node.NextSibling:Node.PreviousSibling){
			All:=TNotes.XML.SN("//*[@last]")
			while(aa:=All.Item[A_Index-1])
				aa.RemoveAttribute("last")
			Next.SetAttribute("last",1)
		}
		Node.ParentNode.RemoveChild(Node),TNotes.Populate()
	}
}
RemoveXMLBackups(){
	static FSO:=ComObjCreate("Scripting.FileSystemObject")
	Max:=5
	Loop,Files,Lib\XML Backup\*.,DR
	{
		Folder:=FSO.GetFolder(A_LoopFileFullPath)
		while(Folder.Files.Count>Max){
			for a in Folder.Files{
				FileDelete,% a.Path
				Break
}}}}
Rename_Current_Include(current:=""){
	if(!current.xml)
		current:=Current()
	ea:=XML.EA(current)
	if(ea.file=Current(2).file)
		return m("You can not rename the main Project using this function.")
	FileSelectFile,Rename,,% ea.file,Rename Current Include,*.ahk
	if(ErrorLevel)
		return
	rename:=rename
	Loop,Files,%rename%,F
		rnme:=A_LoopFileLongPath
	rename:=rnme?rnme:rename
	if(ErrorLevel)
		return
	if(CEXML.Find(Current(1),"descendant-or-self::file/@file",rename))
		return m("You can not rename this the same as another #Include in the same project")
	Rename:=Rename,Code_Explorer.RemoveTV(SN((root:=CEXML.Find("//file/@file",ea.file)),"descendant-or-self::*")),MainFile:=SSN(current.ParentNode,"@file").text,sc:=CSC(),RootFile:=Current(2).file,Include:=Include(RootFile,Rename),text:=RegExReplace(Update({get:MainFile}),"\Q" ea.include "\E",Include),current.ParentNode.RemoveAttribute("sc"),current.SetAttribute("scan",1),Update({file:MainFile,text:text})
	if(tv:=SSN(current,"@tv").text)
		TVC.Default(1),TV_Delete(tv)
	current.ParentNode.RemoveChild(current),tv(SSN(CEXML.Find("//file/@file",MainFile),"@tv").text),Edited(current.ParentNode)
	FileMove,% ea.file,%Rename%,1
	SplashTextOn,,100,Indexing Files,Please Wait....
	Update({remove:ea.file}),Save(),Extract(GetMainNode(RootFile)),FEUpdate(RootFile),id:=SSN((main:=CEXML.Find("//file/@file",rename)),"@id").text
	if(!root:=CEXML.SSN("//*[@id='" ea.id "']"))
		root:=CEXML.SSN("//*").AppendChild(main.CloneNode(0)),root.SetAttribute("type","File")
	ScanFiles(),node:=CEXML.Find("//@file",ea.file),node.ParentNode.RemoveChild(node),Code_Explorer.Refresh_Code_Explorer()
	SplashTextOff
}
Replace_Selected(){
	sc:=CSC(),TotalReplaced:=sc.2570,replace:=InputBox(sc.sc,"Replace Selected","Input text to replace what is selected"),clip:=Clipboard
	if(ErrorLevel)
		return
	for a,b in StrSplit("``r,``n,``r``n,\r,\n,\r\n",",")
		replace:=RegExReplace(replace,"i)\Q" b "\E","`n")
	Clipboard:=replace,sc.2614(1),sc.2179,Clipboard:=clip
	SetStatus("Total Replaced: " TotalReplaced,3)
}
Replace(){
	sc:=CSC(),CP:=sc.2008,Indent:=sc.2128(Line:=sc.2166(CP))
	if(CP<Indent)
		return
	while((CP--)>Indent){
		if(Chr(Char:=sc.2007(CP))~="(" v.Allowed ")"=0&&A_Index>1)
			if(FirstSpace),FirstSpace:=1
				Break
		Word:=Chr(Char) Word,Index:=A_Index
	}if(!Rep:=Settings.SSN("//replacements/*[@replace='" Trim(Trim(Word),",") "']").text)
		while(Word){
			if(SubStr(Word,1,1)~="\w")
				Break
			Word:=SubStr(Word,2),Index--
			if(Rep:=Settings.SSN("//replacements/*[@replace='" Trim(Trim(Word),",") "']").text)
				Break
		}
	if(!Rep)
		return
	sc.2078(),CP:=sc.2008,Len:=StrPut(Word,"UTF-8")-1,sc.2025((Start:=CP-Len)),sc.2645(CP-Len,Len),Indent:=sc.2127(Line),Tab:=Settings.Get("//tab",5),EOL:=1,List:=[],Pos:=1
	while(RegExMatch(Rep,"OU)(\$\[.*\]|\$\w+\b)",Found,Pos),Pos:=Found.Pos(1)+Found.Len(1)){
		Found:=Trim(Found.1,"`n")
		if(Found="$|"||Found=="$E")
			Continue
		List[Found]:=1
	}
	for a in List{
		if(!Value:=InputBox(sc.sc+0,"Enter Replacement","Enter the replacement for: " a "`n`n" RegExReplace(Rep,Chr(127),"`n")))
			Exit
		Rep:=RegExReplace(Rep,"\Q" a "\E",Value)
	}for a,b in (Obj:=StrSplit(Rep,Chr(127))){
		if(Pos:=InStr(b,"$|"))
			Pos--,SetPos:=StrPut(SubStr(b,1,Pos),"UTF-8")-1,b:=RegExReplace(b,"\$\|"),EOL:=0
		else if(InStr(b,"$E"))
			b:=RegExReplace(b,"\$E"),LineEnd:=1,EOL:=0
		b:=RegExReplace(b,"\x60t","`t"),RegExReplace(b,"^(\t)",,AddExtraTabs)
		if(A_Index=1)
			sc.2003((CurrentPos:=CP-Len),b (a!=Obj.MaxIndex()?"`n":""))
		else
			sc.2003(sc.2128(Line+(A_Index-1)),b (a!=Obj.MaxIndex()?"`n":"")),sc.2126(Line+(A_Index-1),Indent+Round(AddExtraTabs*Tab)),CurrentPos:=sc.2128(Line+(A_Index-1))
		if(SetPos)
			sc.2025(CurrentPos+SetPos),SetPos:=0
		else if(LineEnd)
			sc.2025(sc.2136(Line+(A_Index-1))),LineEnd:=0
		if(A_Index>1)
			Overall+=Round(AddExtraTabs)+Round(Indent/Tab)
	}if(EOL)
		sc.2025(StrPut(Rep,"UTF-8")-1+Start+Round(Overall))
	if(v.Options.Auto_Space_After_Comma)
		sc.2003(sc.2008," "),sc.2025(sc.2008+1)
	v.Word:=Rep?Rep:Word
	SetTimer,AutoMenu,-80
	sc.2079(),sc.Enable(1)
	return
}
ReplaceText(start,end,text){
	sc:=CSC(),sc.2686(start,end),sc.2194(StrPut(text,"UTF-8")-1,text)
}
Report_Bugs(){
	if(m("Do you have a Github account?","btn:yn")="Yes")
		Run,https://github.com/maestrith/AHK-Studio/issues
	else
		Run,https://gitreports.com/issue/maestrith/AHK-Studio
}
Reset_Zoom(){
	CSC().2373(0),Settings.SSN("//gui/zoom").text:=0,CenterSel(),MarginWidth()
}
Restore_Current_File(){
	static
	NewWin:=new GUIKeep("Restore_Current_File")
	NewWin.Add("TreeView,w350 h480 altsubmit grestore,,h","Edit,x+10 w550 h480 -Wrap,,wh","Edit,xm w550 vFormat,MM-dd-yyyy HH:mm:ss,wy","Button,x+10 grcfr,Refresh Folder List,xy","Button,xm gRestoreFile Default,R&estore selected file,y")
	CurrentFile:=Current(3).File,MainFile:=Current(2).File
	SplitPath,MainFile,,Folder
	BackupFolder:=Folder "\AHK-Studio Backup\" SanitizePath(RelativePath(MainFile,CurrentFile))
	NewWin.Show("Restore Current File")
	PopulateRestore:
	Default("SysTreeView321","Restore_Current_File"),Format:=NewWin[].Format,TV_Delete(),AllFiles:=[]
	FileName:=SplitPath(CurrentFile).FileName
	Loop,Files,% BackupFolder "\" FileName,FR
		if(RegExMatch(A_LoopFileFullPath,"OU)(.*)(\d{14})",Found))
			AllFiles[Found.2]:=({File:A_LoopFileFullPath,Text:FormatTime(Format,Found.2)})
	Loop,Files,%Folder%\AHK-Studio Backup\Full Backup*.*,DR
		if(RegExMatch(A_LoopFileName,"OU)(.*)(\d{14})",Found)){
			Loop,Files,%A_LoopFileFullPath%\%FileName%,RF
				AllFiles[Found.2]:=({File:A_LoopFileFullPath,Text:"Full Backup " FormatTime(Format,Found.2)})
		}
	Reverse:=[]
	for a,b in AllFiles
		Reverse.InsertAt(1,b)
	for a,b in Reverse
		AllFiles[TV_Add(b.Text)]:=b.File
	Default(,"Restore_Current_File"),TV_Modify(TV_GetChild(0),"Select Vis Focus")
	Sleep,500
	Goto,Restore
	return
	RestoreFile:
	Default(,"Restore_Current_File"),TV:=TV_GetSelection()
	if(FileExist(File:=AllFiles[TV]))
		File:=FileOpen(File,"R","UTF-8"),tt:=File.Read(),Len:=Encode(tt,Text,"UTF-8"),CSC().2181(0,&Text),File.Close(),NewWin.Escape()
	return
	rcfr:
	Goto,PopulateRestore
	return
	Restore:
	Default(,"Restore_Current_File"),TV:=TV_GetSelection()
	if(TV=LastTV)
		return
	if(FileExist(File:=AllFiles[TV])){
		File:=FileOpen(File,"R","UTF-8")
		GuiControl,Restore_Current_File:,Edit1,% File.Read()
		File.Close()
	}LastTV:=TV
	return
}
RGB(c){
	return Format("0x{:06X}",(c&255)<<16|c&65280|c>>16)
}
Right_Click_Menu_Editor(menu){
	static TVRCM:=new EasyView(),nw,node,lastevent,find:=[]
	nw:=new GUIKeep("RCMEditor"),node:=RCMXML.SSN("//main[@name='" menu "']")
	nw.Add("ListView,w300 h150 vl1 AltSubmit,Menus","TreeView,x+M w300 h400 vt1,,wh","ComboBox,x+M w300 gRCMF vfind,,x","TreeView,w300 h377 vt2,,xh","ListView,xm y150 w300 h250 gRCMEGo vl2,Commands|Hotkey,h")
	for a,b in [["l1","SysListView321","RCME"],["l2","SysListView322"],["t1","SysTreeView321"],["t2","SysTreeView322"]]
		TVRCM.Register(b.1,nw.XML.SSN("//*[@name='" b.1 "']/@hwnd").text,b.3,"RCMEditor")
	all:=RCMXML.SN("//main")
	while(aa:=all.item[A_Index-1]),ea:=XML.EA(aa){
		value:=TVRCM.Add("l1",ea.name),item:=ea.name=menu?value:item
	}
	all:=menus.SN("//main/descendant::*"),
	while(aa:=all.item[A_Index-1]),ea:=XML.EA(aa){
		if(aa.NodeName="Separator")
			Continue
		aa.SetAttribute("tv",(tv:=TVRCM.Add("t2",(add:=Clean(ea.name,1)),SSN(aa.ParentNode,"@tv").text))),list.=add "|",find[add]:=tv
	}GuiControl,RCMEditor:,ComboBox1,% Trim(list,"|")
	Hotkey,IfWinActive,% nw.id
	for a,b in [["Remove Selected","RCMRS","!r"],["Add Selected","RCMAS","!a"],["Remove Selected","RCMRS","Delete"],["Remove Selected","RCMRS","Backspace"],["Add Seaparator","RCMAddS","^a"],["Move Selected Item Up","RCMMU","!Up"],["Move Selected Item Down","RCMMD","!Down"],["Restore Defaults","RCMRD","^!d"]]{
		TVRCM.Add("l2",[b.1,Convert_Hotkey(b.3)])
		Hotkey,% b.3,% b.2
	}Loop,2
		LV_ModifyCol(A_Index,"AutoHDR")
	TVRCM.Enable("l1")
	startup:=1
	LV_Modify(item,"Select Vis Focus")
	startup:=0
	nw.Show("Right Click Menu Editor")
	return
	RCMEGo:
	Default("SysListView322","RCMEditor"),LV_GetText(Item,LV_GetNext())
	if(Item="Restore Defaults")
		Goto,RCMRD
	else
		m("Item")
	return
	RCMF:
	if(tv:=find[nw[].find])
		TVRCM.Modify("t2",,tv,"Select Vis Focus")
	return
	RCMRD:
	All:=DefaultRCM(1),Default("SysListView321","RCMEditor")
	Default("SysTreeView321","RCMEditor"),LV_GetText(Item,LV_GetNext())
	Main:=RCMXML.SSN("//main[@name='" Item "']")
	for a,b in StrSplit(All[Item],","){
		if(!SSN(Main,"descendant::menu[@name='" b "']"))
			RCMXML.Under(Main,"menu",{name:b}),Update:=1
	}Goto,RCME
	return
	RCMMD:
	RCMMU:
	Default("SysTreeView321","RCMEditor")
	if(!Node:=RCMXML.SSN("//*[@tv='" TV_GetSelection() "']"))
		return m("Select A Menu Item To Move")
	Direction:=A_ThisLabel="RCMMD"?"Down":"Up"
	if(Next:=Direction="Down"?Node.NextSibling.NextSibling:Node.PreviousSibling){
		Node.ParentNode.InsertBefore(Node,Next)
		Update:=1
		Node.SetAttribute("select",1)
		Goto,RCME
	}
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
	RCMAddS:
	Default("SysTreeView321","RCMEditor")
	if(!Node:=RCMXML.SSN("//*[@tv='" TV_GetSelection() "']"))
		return m("Select A Menu Item To Insert A Separator Before")
	New:=RCMXML.Add("separator",{clean:"<Separator>"},,1),Node.ParentNode.InsertBefore(New,Node)
	Update:=1
	Goto,RCME
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
		}lastevent:=A_EventInfo,update:=0,all:=RCMXML.SN("//*[@last]")
		while(aa:=all.item[A_Index-1]),ea:=XML.EA(aa)
			TVRCM.Modify("t1","",ea.tv,"Select Vis Focus"),aa.RemoveAttribute("last")
		if(Select:=RCMXML.SSN("//*[@select]"))
			TV_Modify(SSN(Select,"@tv").text,"Select Vis Focus"),Select.RemoveAttribute("select")
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
	sc:=CSC(),tab:=sc.2121,Line:=sc.2166(sc.2008),sc.2045(2),sc.2045(3)
	if (sc.2127(Line)>0){
		Up:=Down:=Line
		ss:=sc.2127(Line)-tab
		while(sc.2127(--Line)!=ss)
			Up:=Line
		while(sc.2127(++Line)!=ss)
			Down:=Line
	}Dynarun(sc.TextRange(sc.2128(Up),sc.2136(Down)))
}
Run_Program(){
	if(!debug.socket)
		return Run()
	debug.Send("run")
}
Run_Selected_Text(){
	sc:=CSC()
	if(sc.2570=1)
		text:=sc.GetSelText()
	else
		Loop,% sc.2570
			tt:=sc.TextRange(sc.2585(A_Index-1),sc.2587(A_Index-1)),text.=tt "`n"
	DynaRun(text)
}
Foo(Script,Wait:=true){
	static Shell2:=ComObjCreate("WScript.Shell"),Exec2
	SplitPath,Script,,Dir
	Exec2.Terminate()
	Shell:=ComObjCreate("WScript.Shell")
	/*
		Shell.CurrentDirectory:=Trim(Dir,Chr(34))
	*/
	/*
		Shell.CurrentDirectory:="N:\Scintilla\Win32\"
	*/
	Shell.CurrentDirectory:="N:\MinGW\bin"
	Exec:=Shell.Exec(Script)
	Exec.StdIn.Close()
	Run="%A_AhkPath%" "N:\Scintilla\bin\Testing.ahk"
	while(!Exec.Status)
		Sleep,100
	Exec2:=Shell2.Exec(Run)
	Exec2.StdIn.Close()
	if(Wait)
		return Exec.StdOut.ReadAll()
}
Run(){
	if(v.opening)
		return
	KeyWait,Alt,U
	sc:=csc(),Save(4),file:=Current(2).file
	Fyle:="N:\Scintilla\bin\Cmd.bat"
	if(InStr(file,"LexAHK.cxx")&&FileExist(Fyle)){
		if(FileExist(Fyle))
			m(Foo(Fyle))
		return
	}
	if(Node:=Settings.Find("//ExecProject/Exec/@project",(Project:=Current(2).File))){
		if(Project=A_ScriptFullPath)
			Save(1),Settings.Save(1)
		Exe:=SSN(Node,"@exe").text,CMD:=SSN(Node,"@cmd").text
		Run,"%Exe%" "%Project%" %CMD%
		if(Project=A_ScriptFullPath){
			ExitApp
		}
		return
	}
	if(file=A_ScriptFullPath){
		Run,%A_ScriptFullPath%
		Exit(1)
	}SetStatus("Run Script: " SplitPath(Current(2).file).Filename " @ " FormatTime("hh:mm:ss",A_Now),3)
	if(Current(3).Dir=A_ScriptDir "\Untitled")
		return DynaRun(Update({Get:Current(3).file}),1,Current(2).File)
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
	admin:=v.Options.Run_As_Admin?"*RunAs ":""
	if(!v.Options.Run_As_Admin&&!v.Options.Disable_Exemption_Handling)
		ExecScript()
	else
		Run,%admin%%run%,%dir%,,pid
	if(!IsObject(v.runpid))
		v.runpid:=[]
	v.runpid[Current(2).file]:=pid
	if(file=A_ScriptFullPath){
		sc:=csc()
		for a,b in s.ctrl{
			node:=gui.SSN("//*[@hwnd='" b.sc+0 "']"),node.SetAttribute("file",CEXML.SSN("//*[@sc='" b.2357 "']/@file").text)
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
SanitizePath(File){
	return RegExReplace(File,"(\\|\/|:|\*|\?|<|>|\|)","_")
}
Save_As(){
	Send,{Alt Up}
	Current:=Current(1),CurrentFile:=Current(2).file
	if(!NewFile:=DLG_FileSave(HWND(1),0,"Save File As...",CurrentFile))
		return
	SplitPath,CurrentFile,,dir
	SplitPath,NewFile,NewFN,NewDir,Ext,NNE
	all:=SN(Current,"descendant-or-self::*[@untitled]")
	while(aa:=all.item[A_Index-1])
		aa.RemoveAttribute("untitled")
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
	Open(NewFile),Close(CEXML.SN("//main[@id='" Current(2).ID "']")),tv(SSN(CEXML.Find("//file/@file",NewFile),"@tv").text)
}
Save(option=""){
	sc:=CSC(),Update({sc:sc.2357}),info:=Update("get"),Now:=A_Now
	SavedFiles:=[],saveas:=[],all:=CEXML.SN("//*[@edited]")
	while(aa:=all.item[A_Index-1]),ea:=XML.EA(aa){
		SavedFiles.Push(1),text:=RegExReplace(info.1[ea.file],"\R","`r`n"),SetStatus("Saving " ea.FileName,3),updirty:=CEXML.SN("//*[@id='" ea.id "']")
		if(ea.Dir=A_ScriptDir "\Untitled"&&SubStr(ea.FileName,1,8)="Untitled"&&Option!=3)
			Continue
		while(uu:=updirty.item[A_Index-1]),dea:=XML.EA(uu)
			TVC.Modify(1,(v.Options.Hide_File_Extensions?dea.nne:dea.FileName),dea.tv)
		if(!SplitPath(ea.file).dir)
			Continue
		if(ea.untitled)
			Continue
		if(!v.Options.Disable_Backup){
			parent:=SSN(aa,"ancestor::main/@file").text
			SplitPath,parent,,Dir
			FilePath:=SanitizePath(RelativePath(Current(2).File,ea.File))
			FilePath:=Dir "\AHK-Studio Backup\" FilePath "\" Now
			/*
				if(!FileExist(dir "\AHK-Studio Backup"))
					FileCreateDir,% dir "\AHK-Studio Backup"
				if(!FileExist(dir "\AHK-Studio Backup\" now))
					FileCreateDir,% dir "\AHK-Studio Backup\" now
			*/
			if(!FileExist(FilePath))
				FileCreateDir,%FilePath%
			/*
				FileCopy,% ea.file,% dir "\AHK-Studio Backup\" now "\" ea.FileName,1 ;change this to FileOpen()
			*/
			FileCopy,% ea.file,% FilePath "\" ea.FileName,1 ;change this to FileOpen()
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
	LineStatus.Save(),LineStatus.tv(),SaveGUI(),LastFiles()
}
SaveGUI(win:=1){
	WinGet,max,MinMax,% HWND([win])
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
		Current:=Current(3),Orig:=b,Tick:=A_TickCount
		Parent:=Current(5)
		/*
			I NEED TO MAKE IT SO THAT IT REMOVES ITEMS RIGHT AWAY WHEN YOU DELETE
			A LINE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
			Delete Line{
				Delete should ONLY consern the line it is removing and not the next line
				it should also mark it somehow as a delete
				that way it doesn't compare to anything else
			}
			if it is just deleting letters and not whole lines
				do the normal thing with the 2 lines
		*/
		AfterText1:=SetScan(b.Line,1)
		if(Orig.LineText=AfterText1)
			return SetStatus("Scan_Line() " A_TickCount-Tick "ms No New Results",3)
		AfterText:=RegExReplace(Orig.LineText,Chr(127)),AfterText1:=RegExReplace(AfterText1,Chr(127)),Parent:=Current(5)
		/*
			for c,d in {Breakpoint:"OUm`n)(\s+|^);\*\[(?<Text>.*)\]",Bookmark:"OUm`n)(\s+|^);#\[(?<Text>.*)\]"}{
				LastPos:=Pos:=1
				while(RegExMatch(AfterText,d,Found,Pos),Pos:=Found.Pos(1)+Found.Len("Text")){
					if(Pos=LastPos),LastPos:=Pos
						Break
					Rem:=SSN(Parent,"descendant::*[@type='" c "' and @upper='" Upper(Found.text) "']")
					if(tv:=SSN(Rem,"@cetv").text)
						TVC.Disable(2),TVC.Delete(2,tv),TVC.Enable(2)
					Rem.ParentNode.RemoveChild(Rem)
				}LastPos:=Pos:=1
				while(RegExMatch(AfterText1,d,Found,Pos),Pos:=Found.Pos(1)+Found.Len("Text")){
					if(Pos=LastPos),LastPos:=Pos
						Break
					Total:=Combine({upper:Upper(Found.text),type:c,cetv:TVC.Add(2,Found.Text,Header(c),"Vis Sort")},Found),New:=CEXML.Under(Parent,"info",Total)
			}}
		*/
		
		Found:="",Pos:=Pos1:=1
		/*
			!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
			!!!!REDO THE Words_In_Document() STUFF HERE!!!!
			!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		*/
		
		/*
			Text:=Update({get:Current.File}),Pos1:=InStr(Text,"`n",0,1,b.Line),NewText:=(SubStr(Text,1,Pos1) Chr(127) " " SubStr(Text,Pos1+1)),NewText:=ScanFile.RemoveComments(NewText,Current.Lang),Obj:=StrSplit(NewText,Chr(127)),AfterText1:=SubStr(Obj.2,1,InStr(Obj.2,"`n",0,1,2)-1),Document:=CSC().2357
		*/
		if(!IsObject(WordsObj:=v.WordsObj[(Document:=CSC().2357)]))
			WordsObj:=v.WordsObj[Document]:=[]
		Wordz:=[]
		for a,b in {AfterText:AfterText,AfterText1:AfterText1}
			Wordz[a]:=RegExReplace(RegExReplace(RegExReplace(b,"(\b\d+\b|\b(\w{1,2})\b)",""),"x)([^\w])"," "),"\s{2,}"," ")
		for a,b in StrSplit(Wordz.AfterText," ")
			FirstTwo:=SubStr(b,1,2),CWords:=WordsObj[FirstTwo],WordsObj[FirstTwo]:=RegExReplace(RegExReplace(CWords,"\b(" b ")\b"),"\s{2,}"," ")
		for a,b in StrSplit(Wordz.AfterText1," ")
			FirstTwo:=SubStr(b,1,2),CWords:=WordsObj[FirstTwo],WordsObj[FirstTwo].=CWords?" " b:b
		/*
			IF IT IS IN BOTH NEW AND OLD TEXT
				REMOVE IT FROM PROCESSING!!!!!!!!!!!!!!!!!!!!!!!!
		*/
		/*
			This could be put into a timer and lowered priority
		*/
		OmniOrder:=Keywords.OmniOrder[Current.Lang],AddItems:=[]
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
							IPos:=LastIPos:=1,Parent:=SSN(Current(5),"descendant::*[@type='" Obj.1 "' and @text='" SSN(ParentNode,"@text").text "']"),Total:=Combine({type:Obj.2,upper:Upper(FindIt.Text),cetv:TVC.Add(2,FindIt.Text,SSN(Parent,"@cetv").text,"Vis Sort")},FindIt),AddItems.Push({obj:Total,parent:Parent})
							StringReplace,AfterText1,AfterText1,% FindIt.0
						}else
							Pos2:=FindIt.Pos(1)+FindIt.Len(1)
					}if(ParentItem:=AddItems.1){
						while(RegExMatch(AfterText,d.Regex,Old,IPos),IPos:=Old.Pos(1)+Old.Len(1)){
							StringReplace,AfterText,AfterText,% Old.Text
							if(IPos=LastIPos),LastIPos:=IPos
								Break
							RemoveNode:=SSN(ParentItem.Parent,"descendant::*[@type='" Obj.2 "' and @text='" Old.Text "']")
							if(tv:=SSN(RemoveNode,"@cetv").text)
								TVC.Delete(2,tv)
							RemoveNode.ParentNode.RemoveChild(RemoveNode)
					}}while(Item:=AddItems.Pop())
						CEXML.Under(Item.Parent,"info",Item.Obj)
					Continue
				}Parent:=Current(5) ;might be able to get rid of this one
				while(RegExMatch(AfterText,d.Regex,Found)){
					StringReplace,AfterText,AfterText,% Found.Text
					if(A_Index>20){
						t("This may cause problems First!: " A_TickCount,"time:1",AfterText,LastAfterText)
						Sleep,300
					}if(AfterText=LastAfterText),LastAfterText:=AfterText
						Break
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
					}if(AfterText1=LastAfterText),LastAfterText:=AfterText1
						Break
					if(RegExMatch(Found.Text,"(" d.Exclude ")"))
						Continue
					Total:=Combine({upper:Upper(Found.text),type:c,cetv:TVC.Add(2,Found.Text,Header(c),"Vis Sort")},Found),New:=CEXML.Under(Parent,"info",Total)
	}}}}SetStatus("Scan_Line() " A_TickCount-Tick "ms Tick: " A_TickCount,3)
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
ScanFiles(Refresh:=0){
	List:=CEXML.SN("//*[@scan]")
	if(!List.Length)
		return v.Startup:=0
	if(Visible:=MainWin.Gui.SSN("//*[@win='1']/descendant::control[@type='Code Explorer']"))
		TVC.Delete(2,0),TVC.Add(2,"Updating Information, Please Wait...")
	Tick:=A_TickCount
	while(ll:=List.item[A_Index-1])
		WinSetTitle(1,"AHK Studio: Scanning " SSN(ll,"@file").text " Please Wait..."),ScanFile.Scan(ll,Refresh),ll.RemoveAttribute("scan")
	SetStatus("File Scan " A_TickCount-Tick "ms",2)
	if(Visible)
		Code_Explorer.Refresh_Code_Explorer()
	Sleep,100
	WinSetTitle(1,CEXML.EA("//*[@sc='" CSC().2357 "']"))
	if(v.Options.Auto_Expand_Includes)
		SetTimer,AutoExpand,-200
	v.Startup:=0,Words_In_Document(1),Code_Explorer.AutoCList(1),CSC({last:1})
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
Scintilla_Code_Lookup(){
	static slist,cs,NewWin
	Scintilla(),slist:=scintilla.SN("//commands/item")
	NewWin:=new GUIKeep(8),NewWin.Add("Edit,Uppercase w500 gCodeSort vcs,,w","ListView,w720 h500 -Multi,Name|Code|Syntax,wh","Radio,xm Checked gCodeSort,&Commands,y","Radio,x+5 gCodeSort,C&onstants,y","Radio,x+5 gCodeSort,&Notifications,y","Button,xm ginsert Default,Insert code into script,y","Button,gdocsite,Goto Scintilla Document Site,y")
	while(sl:=slist.item(A_Index-1))
		LV_Add("",SSN(sl,"@name").text,SSN(sl,"@code").text,SSN(sl,"@syntax").text)
	NewWin.Show("Scintilla Code Lookup")
	Loop,3
		LV_ModifyCol(A_Index,"AutoHDR")
	Hotkeys(8,{up:"page",down:"page",PgDn:"page",PgUp:"page"})
	return
	page:
	ControlSend,SysListView321,{%A_ThisHotkey%},% NewWin.ahkid
	return
	docsite:
	Run,http://www.scintilla.org/ScintillaDoc.html
	return
	CodeSort:
	cs:=NewWin[].cs
	Gui,8:Default
	GuiControl,1:-Redraw,SysListView321
	LV_Delete()
	for a,b in {1:"commands",2:"constants",3:"notifications"}{
		ControlGet,check,Checked,,Button%a%,% HWND([8])
		value:=b
		if(Check)
			break
	}
	slist:=scintilla.SN("//" value "/*[contains(@name,'" cs "')]")
	while((sl:=XML.EA(slist.item(A_Index-1))).name)
		LV_Add("",sl.name,sl.code,sl.syntax)
	LV_Modify(1,"Select Vis Focus")
	Loop,3
		LV_ModifyCol(A_Index,"AutoHDR")
	GuiControl,1:+Redraw,SysListView321
	return
	Insert:
	LV_GetText(code,LV_GetNext(),2),HWND({rem:8}),sc:=CSC(),sc.2003(sc.2008,[code]),npos:=sc.2008+StrLen(code),sc.2025(npos)
	return
	lookupud:
	Gui,8:Default
	count:=A_ThisHotkey="up"?-1:+1,pos:=LV_GetNext()+count<1?1:LV_GetNext()+count,LV_Modify(pos,"Select Focus Vis")
	return
	8Close:
	8Escape:
	NewWin.SavePos(),HWND({rem:8})
	return
}
Scintilla_Control(){
	sc:=CSC(),test:=MainWin.Gui.SN("//*[@type='Scintilla']"),list:="",v.jts:=[]
	while(ss:=test.item[A_Index-1],ea:=XML.EA(ss))
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
	if(!IsObject(scintilla))
		Scintilla:=new XML("scintilla",A_ScriptDir "\lib\scintilla.xml")
}
Scratch_Pad(){
	if(!FileExist(A_ScriptDir "\Scratch Pad\Scratch Pad.ahk"))
		FileAppend,% GetTemplate(),% A_ScriptDir "\Scratch Pad\Scratch Pad.ahk"
	Open(A_ScriptDir "\Scratch Pad\Scratch Pad.ahk",1)
}
ScrollWheel(){
	scrollwheel:
	if(A_ThisHotkey="WheelLeft")
		CSC().2168(-5)
	else
		CSC().2168(5)
	return
}
Search_Label(){
	Omni_Search(":")
}
SearchFor(b,Pos1){
	Start:=Pos1,Open:=0,Text:=b.Text
	Loop
	{
		RegExMatch(Text,b.Open,OpenObj,Pos1),RegExMatch(Text,b.Close,Close,Pos1),OP:=OpenObj.Pos(1),CP:=Close.Pos(1)
		if(!OP&&!CP)
			Break
		if(CP&&OP){
			if(CP<OP)
				Pos1:=CP+Close.Len(1),FoundSearch:=Close.0,FIS:="Close"
			else
				Pos1:=OP+OpenObj.Len(1),FoundSearch:=OpenObj.0,FIS:="Open"
		}else if(CP&&!OP)
			Pos1:=CP+Close.Len(1),FoundSearch:=Close.0,FIS:="Close"
		else if(OP&&!CP)
			Pos1:=OP+OpenObj.Len(1),FoundSearch:=OpenObj.0,FIS:="Open"
		RegExReplace(FoundSearch,"(" b.Bounds ")",,Count)
		if(Count){
			Open+=FIS="Open"?+Count:-Count
			SavedPos:=Pos1
			if(Open<=0)
				Break
		}if(Pos1=LastPos1)
			Break
		LastPos1:=Pos1
	}return {Text:SubStr(Text,Start,SavedPos-Start),SavedPos:SavedPos,Pos1:Pos1}
}
Select_Current_Word(){
	sc:=CSC(),sc.2160(sc.2266(sc.2008),sc.2267(sc.2008))
}
Select_Next_Duplicate(){
	sc:=CSC(),xx:=sc.2577(sc.2575())
	for a,b in v.duplicateselect[sc.2357]{
		if(xx<a){
			sc.2573(a+b,a),sc.2169()
			break
}}}
SelectAll(){
	SelectAll:
	ControlGetFocus,Focus,% HWND([1])
	ControlGet,hwnd,hwnd,,%Focus%,% HWND([1])
	if(v.Debug.SC=hwnd)
		return v.Debug.2013
	if(!InStr(Focus,"Scintilla")){
		Send,^A
		return
	}
	sc:=CSC(),count:=Abs(sc.2008-sc.2009)
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
	}ShowOSD("Select All Ctrl+A")
	return
}
SelectFile(FileName:="",Title:="New File",Ext:="",Options:="S16",Force:=0){
	MainFile:=Current(2).file,Ext:=Ext?Ext:Current(3).Ext,Top:=Settings.SSN("//DefaultFolder"),Dir:=SplitPath(MainFile).Dir,BackupFileName:=SplitPath(FileName).FileName
	if(Node:=Settings.Find(Top,"descendant::Folder/@file",MainFile))
		Folder:=SSN(Node,"@folder").text
	else
		Folder:=SSN(Top,"@folder").text
	Dir:=Trim(Dir "\" Folder,"\")
	FileName:=FileName?FileName:Dir "\" BackupFileName
	/*
		if(!FileExist(Dir))
			FileCreateDir,%Dir%
	*/
	FileName:=DLG_FileSave(HWND(1),,Title,FileName,,Force)
	if(ErrorLevel)
		Exit
	return FileName
}
SelectText(Item,Node:=0){
	sc:=CSC(),Node:=Item?Item:Node,FileNode:=GetFileNode(Node),ea:=XML.EA(Node),FNEA:=XML.EA(FileNode)
	if(TVC.Selection(1)!=SSN(FileNode,"@tv").text)
		tv(SSN(FileNode,"@tv").text),Sleep(200)
	else
		History.Add(Current(3),sc)
	FoundInstance:=Round(SN(Item,"preceding-sibling::*[@upper='" ea.Upper "']").Length)+1
	Regex:=GetSearchRegex(v.OmniFind[FNEA.Lang][ea.Type].Regex,ea.Text),Text:=Update({Get:SSN(FileNode,"@file").text}),Pos:=1,FoundPos:=[]
	while(RegExMatch(Text,Regex,Found,Pos),Pos:=Found.Pos(1)+Found.Len(1)){
		if(Pos=LastPos),LastPos:=Pos
			Break
		FoundPos.Push(StrPut(SubStr(Text,1,Found.Pos(1)),"UTF-8")-2)
	}if(FoundPos.MaxIndex()=1){
		sc.2160(FoundPos.1,StrPut(ea.Text,"UTF-8")-1+FoundPos.1)
	}else{
		Obj:=GetClassText(XML.EA(FileNode),SSN(Node.ParentNode,"@text").text,"Class",1)
		if(SSN(Node.ParentNode,"@type").text!="File"){
			for a,b in FoundPos
				if(b>Obj.Start&&b<Obj.Start+Obj.Length){
					sc.2160(b,b+StrPut(ea.Text,"UTF-8")-1)
					Break
				}
		}else if((b:=FoundPos[FoundInstance])!=""){
			sc.2160(b,b+StrPut(ea.Text,"UTF-8")-1)
		}else{
			for a,b in FoundPos{
				if(!(b>Obj.Start&&b<Obj.Start+Obj.Length)){
					sc.2160(b,b+StrPut(ea.Text,"UTF-8")-1)
					Break
}}}}}
Set_As_Default_Editor(){
	RegRead,current,HKCU,SOFTWARE\Classes\AutoHotkeyScript\Shell\Edit\Command
	SplitPath,A_ScriptFullPath,,,ext
	if(!InStr(Current,A_ScriptName)){
		Settings.Add("DefaultEditor",,Current)
		q:=Chr(34),p:=Chr(37)
		if(ext="exe")
			New_Editor:=q A_ScriptFullPath q A_Space q p 1 q
		else if(ext="ahk")
			New_Editor:=q A_AhkPath q A_Space q A_ScriptFullPath q A_Space q p 1 q
		if(InStr(current,A_ScriptFullPath))
			New_Editor:=q A_WinDir "\Notepad.exe" q A_Space q p 1 q
	}else{
		New_Editor:=Settings.SSN("//DefaultEditor").text
	}
	RegWrite,REG_SZ,HKCU,SOFTWARE\Classes\AutoHotkeyScript\Shell\Edit\Command,,%New_Editor%
	RegRead,output,HKCU,SOFTWARE\Classes\AutoHotkeyScript\Shell\Edit\Command
	if(InStr(output,A_ScriptName))
		m("AHK Studio is now your default editor for .ahk file")
	else if(Output=New_Editor){
		RegExMatch(Output,"OU)\x22(.*)\x22",Found),File:=Found.1
		SplitPath,File,,,,NNE
		m(NNE " is now your default editor")
	}else
		m("Something went wrong :( Please restart Studio and try again.")
}
Set_New_Include_File_Default_Folder(){
	static
	Top:=Settings.Add("DefaultFolder"),Node:=Settings.Find(Top,"descendant::Folder/@file",(MainFile:=Current(2).File)),NewWin:=new GUIKeep("SetNewFile"),NewWin.Add("Text,,Global Default:","Edit,w500 vGlobal gSNFDFG," SSN(Top,"@folder").text,"Text,,Current Project: " SplitPath(MainFile).FileName,"Edit,w500 vCurrent gSNFDFCF," SSN(Node,"@folder").text),NewWin.Show("Set New Include File Default Folder")
	return
	SNFDFCF:
	Info:=NewWin[].Current
	if(!Node:=Settings.Find(Top,"descendant::Folder/@file",(MainFile:=Current(2).File)))
		Node:=Settings.Under(Top,"Folder",{folder:Info,file:MainFile})
	Node.SetAttribute("folder",Info)
	return
	SNFDFG:
	Top.SetAttribute("folder",NewWin[].Global)
	return
}
SetPos(oea:=""){
	static
	SetTimer,HighlightCode,-20
	if(IsObject(oea)){
		if(oea.file&&oea.line!=""){
			sc:=CSC()
			tv(SSN(CEXML.Find("//file/@file",oea.file),"@tv").text)
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
			sc:=CSC()
		return
	}
	delay:=(WinActive("A")=HWND(1))?1:200
	if(delay=1)
		Goto,spnext
	SetTimer,spnext,-%delay%
	return
	spnext:
	sc:=CSC(),sc.2397(0),node:=CEXML.SSN("//*[@sc='" sc.2357 "']"),file:=SSN(node,"@file").text,parent:=SSN(node,"ancestor::main/@file").text,posinfo:=positions.Find(positions.Find("//main/@file",parent),"descendant::file/@file",file),doc:=SSN(node,"@sc").text,ea:=XML.EA(posinfo),fold:=ea.fold
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
	HighlightCode:
	Current:=Current(3).File
	if(!Node:=Positions.Find("//*/@file",Current))
		return
	if((All:=SN(Node,"Highlight/Highlight")).Length){
		sc:=CSC()
		while(aa:=All.Item[A_Index-1],ea:=XML.EA(aa))
			sc.2500(ea.Index),sc.2504(ea.Start,ea.Len)
	}	
	return
}
SetScan(Line,Return:=0){
	Text:=Update({get:(Current:=Current(3)).File}),EndLine:=StartLine:=Line+1,Obj:=StrSplit(Text,"`n")
	while(qq:=Obj[StartLine]){
		if(Trim(qq,"`t"))
			Break
		StartLine--
	}while(qq:=Obj[++EndLine]){
		if(Trim(qq,"`t"))
			Break
	}Text:=Obj[StartLine] Chr(127) "`n" Obj[EndLine],Text:=ScanFile.RemoveComments(Text,Current.Lang)
	if(InStr(Text,Chr(127)))
		RegExMatch(Text,"Om`n)(.*" Chr(127) ".*\R?.*)\R?",Found)
	if(Return)
		return Found.1
	v.LineEdited[Line]:={text:NewText,Line:Line,LineText:Found.1}
	return Found.1
}
SetStatus(text,part=""){
	static widths:=[],width
	if(IsObject(text)){
		WinSet,Redraw,,% HWND([1])
		ControlGetPos,,,,h,,% "ahk_id" v.statushwnd
		v.status:=h,ea:=XML.EA(text)
		return sc:=CSC(),sc.2056(99,ea.font),sc.2055(99,ea.size),width:=sc.2276(99,"a")+1
	}
	Gui,1:Default
	widths[part]:=width*StrLen(text 1),SB_SetParts(widths.1,widths.2,widths.3),SB_SetText(text,part)
}
SetTimer(timer,Duration:="-10"){
	SetTimer,%timer%,%Duration%
}
SetTimers(Timers*){
	for a,b in Timers{
		Obj:=StrSplit(b,",")
		SetTimer,% Obj.1,% Obj.2
	}
}
Class SettingsClass{
	static pos:=[],Controls:=[],Sizes:=[],Node:=[],Types:=[],scc:=[],Current:=[],DefaultStyle:={"default":1,"inlinecomment":1,"numbers":1,"punctuation":1,"multilinecomment":1,"completequote":1,"incompletequote":1,"backtick":1,"linenumbers":1,"indentguide":1,"hex":1,"hexerror":1}
	__New(Tab:=""){
		for a,b in {HotkeyXML:new XML("hotkeys"),TempXML:new XML("temp"),SavedThemes:new XML("SavedThemes",A_ScriptDir "\Themes\SavedThemes.xml")}
			SettingsClass[a]:=b
		SettingsClass.Hotkeys:=[["Move Selected Item Up","^Up","MSIU"],["Move Selected Item Down","^Down","MSID"],["Move Checked Selected Menu","!M","MCTSM"],["Move Checked Items Up","!Up","MCIU"],["Move Checked Items Down","!Down","MCID"],["Insert Menu","!I","IM"],["Change Hotkey","Enter","CH"],["Insert Separator","!S","IS"],["Remove/Hide Menu Item","Delete","Delete"],["Clear Checks","!C","CC"],["Removed Checked Icons","^!I","RCI"],["Check All Child Menu Items","^A","CACMI"],["Random Icons","^!R","Random"]],Parent:=HWND(1),SettingsClass.SavedThemes:=new XML("themes",A_ScriptDir "\Themes\SavedThemes.xml")
		if(!FileExist(A_ScriptDir "\Themes"))
			FileCreateDir,%A_ScriptDir%\Themes
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
		this.Add("TreeView,xm ym w300 h800 AltSubmit gNotifications vTesting,,MainTV,h-" sbh),this.Add("Tab,x0 y0 w0 h0 Buttons," Trim(tabs,"|")),this.SetTab(SettingsClass.Tabs.Options),this.Add("ListView,x300 ym Checked AltSubmit gNotifications vOptions,Option,Options,w-300|h-" sbh)
		Gui,Settings:Default
		for a,b in v.Options
			LV_Add((Settings.SSN("//options/@" a).text?"Check":""),RegExReplace(a,"_"," "))
		this.SetTab(SettingsClass.Tabs.Auto_Insert),this.Add("ListView,x300 ym vAI gNotifications AltSubmit,Type|Insert,AutoInsert,w-300|h-150","Text,x302,Typed Key:,TK,y-" sbh+125,"Edit,x300,,trigger,y-" sbh+105,"Text,x302,Inserted Text:,IT,y-" sbh+80,"Edit,x300,,Add,y-" sbh+60,"Button,x300 vAddButton gNotifications,&Add,AddButton,y-" sbh+30,"Button,x+M vRemoveButton gNotifications,&Remove,RemoveButton,y-" sbh+30),this.SetTab(SettingsClass.Tabs.Edit_Replacements),this.Add("ListView,x300 h240 ym vER gNotifications AltSubmit,Input|Replacement,ERLV,w-300","Text,x302 yp+240,Input:,ERI","Edit,x300 yp+15 vERInsert gNotifications,,ERInsert","Text,x302 yp+23,Replacement:,ERR","Edit,x300 yp+15 Multi +WantReturn vERReplace gNotifications,,ERReplace,w-300|h-350","Button,x300 vERAdd gNotifications,&Add,ERAdd,y-" sbh+30,"Button,x+M vERRemove gNotifications,&Remove,ERRemove,y-" sbh+30),this.SetTab(SettingsClass.Tabs.Manage_File_Types),this.Add("ListView,x300 ym,Extension|Language,FileType,w-300|h-100","Text,,FileType:,FTT,y-" sbh+75,"Edit,w200,,FTEdit,y-" sbh+60,"Button,vFTAdd gNotifications,&Add,FTAdd,y-" sbh+35,"Button,x+M vFTRemove gNotifications,&Remove,FTRemoe,y-" sbh+35),this.SetTab(SettingsClass.Tabs.Menus),this.Add("ComboBox,x300 ym gNotifications vComboBox,,ComboBox,w-600","TreeView,x300 y+M Checked vMenuTV gNotifications AltSubmit,,MenuTV,w-600|h-323","ListView,h277 Icon vIcon gSelectIcon AltSubmit,Icon,Icon,w-300|y-" sbh+277,"Button,w110 gLoadDefault,&Default Icons,FButton,x-200|y-328","Button,w90 gLoadFile,&Load Icons,SButton,x-90|y-328","Listview,ym w300,Description|Hotkey,Hotkeys,x-300|h-328"),TV_Add("Please Wait..."),this.ILAdd("init"),ib:=new Icon_Browser("",SettingsClass.Controls.Icon,"Settings",,,"Notifications"),SettingsClass.IconID:="ahk_id" SettingsClass.Controls.Icon,this.SetTab(SettingsClass.Tabs.Theme)
		Gui,Settings:Add,Custom,x300 ym classScintilla hwndsc gNotifications
		this.SC({register:sc}),obj:=SettingsClass,obj.Controls.Scintilla:=sc,obj.pos["Scintilla"]:={h:-sbh,w:-300}
		if(!node:=Settings.SSN("//gui/position[@window='Settings']"))
			node:=Settings.Add("gui/position"),node.SetAttribute("window","Settings")
		SettingsClass.Node:=node
		for a,b in [[2052,32,0],[2050],[2051,5,0xFFFFFF],[2051,11,0x00AA00],[2171,1]]
			this[b.1](b.2,b.3)
		for a,b in this.WindowList
			xx.Add("item",{name:b},,1)
		parent:=xx.Under((theme:=xx.SSN("//*[@name='Theme']")),"top",{name:"Color"}),this.Default()
		for a,b in [{"Brace Match":"Indicator Reset"},{"Duplicate Indicator":"Indicator Style,Indicator Color,Indicator Transparency,Indicator Border Transparency"},{"Caret":"Caret,Caret Line Background,Debug Caret Color,Multiple Indicator Color,Width"},{"Code Explorer":"Background,Default Background,Text Style,Default Style"},{Default:"Background Color,Font Style,Reset To Default"},{"":"Indent Guide"},{"Main Selection":"Foreground,Remove Forground"},{"Multiple Selection":"Foreground,Remove Forground"},{"Project Explorer":"Background,Default Background,Text Style,Default Style"},{"Quick Find":"Bottom Background,Bottom Forground,Quick Find Clear,Quick Find Edit Background,Top Background,Top Forground"},{"":"StatusBar Text Style"}]{
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
		this.2409(0,0),LV_ModifyCol(),this.Show(),this.2188(1),TV_Modify(this.tvxml.SSN("//*[@name='" Tab "']/@tv").text,"Select Vis Focus"),ib.Populate()
		Hotkey,IfWinActive,% this.ID
		for a,b in SettingsClass.Hotkeys{
			Hotkey,% b.2,SettingsHotkeys,On
			SettingsClass.HotkeyXML.Add("Hotkey",{d:b.1,k:b.2,a:b.3},,1)
		}Hotkey,IfWinActive,% "ahk_id" this.hwnd
		Hotkey,F1,SettingsTest,On
		SettingsClass.Current:=this,this.SetHighlight()
		return this
		SettingsTest:
		this:=SettingsClass.Current,this.ThemeText(),SettingsClass.keep:=this,this.Color(),this.UpdateSavedThemes(),this.PopulateER(),this.PopulateAI(),this.PopulateMFT(),this.Default("Hotkeys")
		return
		SettingsClose:
		Gui,Settings:Destroy
		SettingsClass.SavedThemes.Save(1),Allowed()
		return
		Settings:
		new SettingsClass("Auto Insert")
		return
	}__Call(info*){
		if(info.1+0){
			(info.2?((a:=info.2+0?"int":"str")(b:=info.2)):(a:="int",b:=0)),scc:=SettingsClass.scc,(info.3?((c:=info.3+0?"int":"str")(d:=info.3)):(c:="int",d:=0))
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
				for c,d in StrSplit(i.5,"|")
					RegExMatch(d,"(.)(.*)",found),SettingsClass.pos[i.4,found1]:=found2
			}SettingsClass.Types[hwnd]:=i.1,SettingsClass.Types[i.4]:=i.1
	}}AddText(text*){
		static var
		Obj:=[]
		for a,b in text{
			VarSetCapacity(var,(len:=StrPut(b.1,"UTF-8"))),StrPut(b.1,&var,len,"UTF-8"),this.2003((start:=this.2006()),&var),this.ThemeTextText.=b.1,this.2032(start),this.2033(len,b.2),Obj.Push({start:Start,len:Len-1})
			if(b.2=255)
				SettingsClass.OpenBrace:=this.2006()-2
		}return Obj
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
		/*
			2523() 2558() ;here
		*/
		for a,b in [[2080,7,6],[2523,6,Settings.Get("//DuplicateIndicator/@trans",50)],[2558,6,Settings.Get("//DuplicateIndicator/@bordertrans",50)],[2242,1,20],[2080,6,Settings.Get("//DuplicateIndicator/@style",14)],[2082,6,Settings.Get("//DuplicateIndicator/@color",0xC08080)],[2082,8,0xff00ff],[2080,8,1],[2080,6,14],[2080,2,8],[2082,2,0xff00ff],[2082,6,0xC08080],[2080,3,14],[2680,3,6],[2516,1]]
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
		Color(this,Language,A_ThisFunc " Settings"),ea:=Settings.EA("//theme/bracematch"),ea.Style:=255
		if(ea.code=2082)
			this.2082(7,ea.color),this.2498(1,7),this.2351(SettingsClass.OpenBrace,SettingsClass.OpenBrace+1)
		else{
			for a,b in ea{
				if((st:=list[a]))
					this[st](ea.Style,b)
				if(ea.code&&ea.value!="")
					this[ea.code](ea.value)
				else if(ea.code&&ea.bool!=1)
					this[ea.code](ea.color,0)
				else if(ea.code&&ea.bool)
					this[ea.code](ea.bool,ea.color)
		}}this.2246(0,1),this.2409(0,0)
		GuiControl,Settings:+Redraw,Scintilla1
		return RefreshThemes(1),MarginWidth(this)
	}ContextMenu(a*){
		for a,b in Keywords.Languages
			list.=a "`n"
		this:=SettingsClass.Current,this.ThemeText(),SettingsClass.keep:=this,this.Color(),this.UpdateSavedThemes(),this.PopulateER(),this.PopulateAI(),this.PopulateMFT(),this.Default("Hotkeys"),m("Language List: ",list,"Please ask maestrith to finish this...he got distracted","It's called Context Menu and it is in the Settings window")
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
		while(aa:=all.item[A_Index-1],ea:=XML.EA(aa))
			LV_Add("",ea.clean)
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
		SettingsClass.Default("MenuTV"),node:=menus.SSN("//*[@tv='" TV_GetSelection() "']")
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
		SettingsClass.SavedThemes.Save(1),Allowed()
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
		this.Default("MenuTV"),SettingsClass.PopulatedMenu:=1,SettingsClass.MenuSearch:=[],all:=Menus.SN("//*/descendant::*"),TV_Delete()
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
		while(aa:=all.item[A_Index-1],ea:=XML.EA(aa))
			LV_Add("",aa.text,ea.Language)
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
					node:=menus.SSN("//*[@tv='" TV_GetSelection() "']"),node.SetAttribute("last",1),parent:=node.ParentNode,all:=SN(parent,"descendant::*")
					while(aa:=all.item[A_Index-1],ea:=XML.EA(aa)){
						if(ea.check){
							if(SN(aa,"preceding-sibling::*[@check]").length+1!=A_Index)
								aa.ParentNode.InsertBefore(aa,aa.previousSibling)
						}TV_Delete(ea.tv)
				}}else{
					node:=menus.SSN("//*[@tv='" TV_GetSelection() "']"),node.SetAttribute("last",1),parent:=node.ParentNode,all:=SN(parent,"descendant::*")
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
				tv:=TV_Add(NewMenu,SSN(node.ParentNode,"@tv").text,SSN(node,"@tv").text),new:=menus.Add("menu",{clean:RegExReplace(RegExReplace(NewMenu,"\s","_"),"&"),name:NewMenu,tv:tv,user:1},,1),(above:=node.nextSibling)?node.ParentNode.InsertBefore(new,above):node.ParentNode.AppendChild(new)
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
				tv:=TV_GetPrev(ea.tv)?TV_GetPrev(ea.tv):"First",new:=menus.Add("separator",{clean:"<Separator>",tv:(tv:=TV_Add("<Separator>",SSN(node.ParentNode,"@tv").text,tv))},,1),node.ParentNode.InsertBefore(new,node)
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
			}else
				m("Item Coming Soon: " action)
		}
		return
	}Show(){
		Position:=SettingsClass.Node.text,Mon:=Monitors()
		for a,b in ["x","y","w","h"]
			RegExMatch(position,"Oi)" b "(-?\d*)\b",found),win[b]:=found.1
		if(Win.x<Mon.Left.MinIndex()||Win.y<Mon.Top.MinIndex())
			Position:="xCenter yCenter"
		Gui,Settings:Show,% (Position?Position:"w" A_ScreenWidth-200 " h" A_ScreenHeight-200),Settings
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
		}}else if(RegExMatch(parent,"(\w+) Explorer",found)){
			node.text:="",NodeName:=found1="Project"?"projectexplorer":"codeexplorer",Node:=Settings.Add("theme/" NodeName),Default:=Settings.SSN("//default")
			if(item="Default Background")
				Node.RemoveAttribute("background")
			else if(item="Background")
				Dlg_Color(Node,Default,SettingsClass.hwnd,"background")
			else if(item="Text Style")
				Dlg_Font(Node,Default,SettingsClass.hwnd)
			else if(item="Default Style")
				Node.ParentNode.RemoveChild(Node)
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
		}else if(parent="Duplicate Indicator"){
			if(Item="Indicator Style"){
				/*
					Dlg_Color(Settings.SSN("//DuplicateIndicator"),,SettingsClass.hwnd,"style")
				*/
				Style:=InputBox(SettingsClass.hwnd,"Duplicate Indicator Style","Enter the number of the style you want this indicator to be 0-16 (Default 14)",Settings.Get("//DuplicateIndicator/@style",14))
				if(Style<=16&&Style>=0)
					Settings.Add("DuplicateIndicator").SetAttribute("style",Style)
			}else if(Item="Indicator Color"){
				Dlg_Color(Settings.Add("DuplicateIndicator"),,SettingsClass.hwnd,"color") ;here
			}else if(Item="Indicator Transparency"){
				;add in the Transparency for the border and background into both here and the Color() 2523() 2558()
				Style:=InputBox(SettingsClass.hwnd,"Duplicate Transparency","Enter the Transparency value for the Background 0-255 (0=Opaque)",Settings.Get("//DuplicateIndicator/@trans",50)) ;here2
				if(Style<=255&&Style>=0)
					Settings.Add("DuplicateIndicator").SetAttribute("trans",Style)
			}else if(Item="Indicator Border Transparency"){
				Style:=InputBox(SettingsClass.hwnd,"Duplicate Indicator Border Transparency","Enter the Transparency value for the Border 0-255 (0=Opaque)",Settings.Get("//DuplicateIndicator/@bordertrans",50))
				if(Style<=255&&Style>=0)
					Settings.Add("DuplicateIndicator").SetAttribute("bordertrans",Style)
			}
			/*
				Indicator Style,Indicator Color
			*/
		}else if(parent="Brace Match"){
			if(item="Indicator Reset"){
				node:=Settings.SSN("//theme/bracematch"),node.ParentNode.RemoveChild(node)
		}}else if(item="Export Theme"){
			name:=Settings.SSN("//theme/name").text,temp:=new XML("temp","Themes\" name ".xml"),font:=Settings.SSN("//theme"),temp.xml.LoadXML(font.xml),temp.Save(1),m("Exported to:",A_ScriptDir "\Themes\" name ".xml")
		}else if(item="Import Theme"){
			FileSelectFile,tt,,,,*.xml
			if(ErrorLevel)
				return
			file:=FileOpen(tt,"R","UTF-8"),tt:=file.Read(file.Length),file.Close(),temp:=new XML("temp"),temp.xml.LoadXML(tt)
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
			Settings.SSN("//*").AppendChild(nn.CloneNode(1)),ConvertTheme(),this.ThemeText()
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
		this.2171(0),this.2004(),this.ThemeTextText:="",Header:=((name:=Settings.SSN("//theme/name").text)?header:=name "`n":"")((author:=Settings.SSN("//theme/author").text)?"Theme by " author "`n":"") "Instructions at the bottom:`n",this.AddText([header,0],["Main Selection",253],[" - ",0],["Multiple Selection",254],[" <---- Additional Options in the TreeView to the Left with Main Selection * and Multiple Selection *`n`n",""]),this.AddText(["Matching Brace Style ",0],["()",255],["`n`n",0]),EditedMarker:=this.EditedMarker:=[]
		for a,b in {edited:"<----Edited Marker (Click to change)`n",saved:"<----Saved Line`n`n"}
			EditedMarker[(Line:=this.2154()-1)]:=a,this.AddText([b,0]),this.2043(Line,(a="Edited"?20:21))
		this.EditedMarkerStartLine:=this.2166(this.2006())
		if(!ControlFile:=Keywords.GetXML(Current(3).Lang))
			ControlFile:=new XML("","lib\Languages\ahk.xml")
		all:=ControlFile.SN("//Styles/*[@ex]")
		Obj:=this.AddText(["Duplicate Indicator <----In Treeview under Duplicate Indicator`n`n",0])
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
		this.2080(6,14),this.2082(6,0xff00ff),this.2500(6),this.2504(Obj.1.Start,Obj.1.Len)
		GuiControl,Settings:+Redraw,Scintilla1
	}TVName(node){
		return RegExReplace(RegExReplace((ea:=xml.EA(node)).clean,"_"," "),"&") (ea.hotkey?"  :  " Convert_Hotkey(ea.hotkey):"") (ea.hide?"  :  Hidden":"")
	}TVOptions(node){
		return opt:=((ea:=xml.EA(node)).check?"Check":"") " Icon" SettingsClass.ILAdd(ea.filename,ea.icon)
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
	WinGet,ExStyle,ExStyle,% HWND([1])
	if(ExStyle&0x8)
		Gui,%window%:+AlwaysOnTop
	Gui,Color,%Background%,%Background%
	Gui,Font,% "s" size " c" color " bold",%font%
	Gui,%window%:Default
	v.window[window]:=1,HWND(window,hwnd)
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
		CSC().2077(0,"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ#-_1234567890")
	else if(hyphen=2)
		CSC().2077(0,"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ#-_1234567890*[];")
	else if(hyphen=3)
		CSC().2077(0,"0123456789abcdefABCDEF#x")
	else
		CSC().2444
}
Show_Class_Methods(object,search:=""){
	static list
	sc:=CSC()
	if(object="this")
		class:=GetCurrentClass(),Node:=SSN(Current(7),"descendant::*[@upper='" Upper(Class) "' and @type='Class']"),list:=SN(Node,"*[@type='Method']")
	else if(class:=SSN((parent:=Current(7)),"descendant::*[@type='Instance' and @upper='" Upper(object) "']/@class").text)
		list:=SN(parent,"descendant::*[@type='Class' and @upper='" Upper(Class) "']/*[@type='Method']")
	else if(parent:=SSN(Current(7),"descendant::*[@type='Class' and @upper='" Upper(object) "']"))
		list:=SN(parent,"*[@type='Method']")
	while(ll:=list.item[A_Index-1],ea:=XML.EA(ll))
		if(RegExMatch(ea.text,"i)\b" search))
			Total.=ea.text " "
	if(Total:=Trim(Total))
		sc.2117(3,Total)
	return sc.2102?1:0
}
Show_Scintilla_Code_In_Line(){
	Scintilla(),sc:=CSC()
   	text:=sc.TextRange(sc.2128(sc.2166(sc.2008)),sc.2136(sc.2166(sc.2008))),pos:=1
	while(RegExMatch(text,"O)(\d\d\d\d)",found,pos),pos:=found.pos(1)+found.len(1)){
		codes:=scintilla.SN("//*[@code='" found.1 "']"),list.="Code : " found.1 " = "
		while(c:=codes.item(A_Index-1))
			list.=A_Index>1?" - " SSN(c,"@name").text:SSN(c,"@name").text
		list.="`n"
	}
	if(list)
		sc.2200(sc.2128(sc.2166(sc.2008)),Trim(list,"`n"))
}
ShowAutoComplete(){
	sc:=CSC(),CPos:=sc.2008,SetWords(1),start:=sc.2266(CPos,1),end:=sc.2267(CPos,1),Word:=sc.TextRange(start,CPos),SetWords(),Word:=LTrim(Word,"-")
	if((sc.2202&&!v.Options.Auto_Complete_While_Tips_Are_Visible)||(sc.2010(CPos)~="\b(13|1|11|3)\b"=1&&!v.Options.Auto_Complete_In_Quotes)){
	}else{
		Word:=RegExReplace(Word,"^\d*"),List:=Trim(Keywords.GetSuggestions((Language:=GetLanguage(sc)),FirstTwo:=SubStr(Word,1,2)))
		if(WordList:=v.WordsObj[sc.2357,FirstTwo])
			List.=" " WordList
		for a,b in v.WordsObj[sc.2357]
			Total:=A_Index
		List.=" " Code_Explorer.AutoCList(1)
		if(node:=Settings.Find("//autocomplete/project/@file",Current(2).file))
			List.=" " node.text
		List.=" " Keywords.Personal " ",List.=" " Keywords.Suggestions[Language,FirstTwo] " " v.KeyWords[SubStr(Word,1,1)],List:=Trim(List)
		Sort,List,CUD%A_Space%
		if((List&&InStr(List,Word)&&Word))
			sc.2100(StrLen(Word),Trim(List))
	}
}
ShowLabels(x:=0){
	Code_Explorer.Scan(Current()),all:=CEXML.SN("//main[@id='" Current(2).ID "']/descendant::info[@type='Function' or @type='Label']/@text")
	sc:=CSC(),sc.2634(1),dup:=[]
	if(x!="nocomma")
		Loop,% sc.2570
			CPos:=sc.2585(A_Index-1),InsertMultiple(A_Index-1,CPos,",",CPos+1)
	while(aa:=all.item[A_Index-1])
		if(!dup[aa.text])
			list.=aa.text " ",dup[aa.Text]:=1
	Sort,list,list,D%A_Space%
	if(List)
		sc.2100(0,Trim(list))
}
Sleep(Time:="-10"){
	Sleep,%Time%
}
Add_Space_Before_And_After_Commas(){
	Spaces("baa")
}Add_Space_After_Commas(){
	Spaces("ac")
}Add_Space_Before_Commas(){
	Spaces("bc")
}RemoveSpacesFromAroundCommas(){
	Spaces("rsfac")
}Remove_Spaces_From_Around_Commas(){
	Spaces("rsfac")
}Spaces(Info){
	sc:=CSC()
	if(!Sel:=sc.GetSelText())
		sc.2160(sc.2128(line:=sc.2166(sc.2008)),sc.2136(line)),Sel:=sc.GetSelText()
	Replace:={ac:[["U),(\S)",", $1"]],bc:[["U)(\S),","$1 ,"]],baa:[["U),(\S)",", $1"],["U)(\S),","$1 ,"]]}
	if(Replace[Info])
		sc.2170(0,ProcessText(Sel,Replace[Info]))
	else
		sc.2170(0,RegExReplace(Sel,"\s*,\s*",","))
}ProcessText(text,process){
	for c,d in process{
		while,text:=RegExReplace(text,d.1,d.2,count){
			if(!count)
				break
		}
	}
	return text
}
Split_Line_By_Comma(){
	sc:=CSC(),Line:=sc.2166(sc.2008),oStart:=Start:=sc.2128(Line),End:=sc.2136(Line),Indent:=sc.2127(Line),Tab:=sc.2121
	while(A_Index<=Floor(Indent/Tab))
		Add.="`t"
	while(Start<=End){
		if((Chr:=sc.2007(Start))=44&&sc.2010(Start)=4)
			Out.="`n" Add
		else
			Out.=Chr(Chr)
		Start++
	}sc.2160(oStart,End),sc.2170(0,[Trim(Out,"`n")])
}
SplitPath(File){
	SplitPath,File,FileName,Dir,Ext,NNE,Drive
	return {File:File,FileName:FileName,Dir:Dir,Ext:Ext,NNE:NNE,Drive:Drive}
}
Start_Select_Character(){
	StartSelect:=InputBox(HWND(1),"Start Select Character","Enter a list of characters you want to add to the DoubleClick selection",Settings.SSN("//StartSelect").text)
	Settings.Add("StartSelect").text:=StartSelect
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
		ControlGetFocus,focus,% HWND([1])
		ControlGet,hwnd,hwnd,,%focus%,% HWND([1])
	*/
	hwnd:=DllCall("GetFocus")
	hwnd:=hwnd=MainWin.tnsc.sc?MainWin.tnsc.sc+0:hwnd+0,sc:=CSC(),test:=MainWin.Gui.SN("//*[@type='Scintilla']"),list:="",v.jts:=[]
	if(hwnd!=MainWin.tnsc.sc)
		list:="Tracked Notes,",v.jts["Tracked Notes"]:=MainWin.tnsc.sc
	while(ss:=test.item[A_Index-1],ea:=XML.EA(ss)){
		if(hwnd=ea.hwnd)
			Continue
		if(ea.type="scintilla"){
			/*
				if(MainWin.tnsc.sc=ea.hwnd)
					list.="Tracked Notes,",v.jts["Tracked Notes"]:=MainWin.tnsc.sc
				else
			*/
			doc:=s.ctrl[ea.hwnd].2357,file:=StrSplit(CEXML.SSN("//*[@sc='" doc "']/@file").text,"\").pop()
			if(file)
				list.=file ",",v.jts[file]:=ea.hwnd
		}
	}list:=Trim(list,",")
	if(!InStr(list,","))
		return s.ctrl[v.jts[list]].2400()
	sc.2106(44),sc.2117(7,Trim(list,",")),sc.2106(32)
}
Tab_To_Next_Comma(){
	sc:=CSC()
	Loop,% sc.2570{
		line:=sc.2166(start:=sc.2585(A_Index-1))
		sc.2686(start,sc.2136(line))
		if((pos:=sc.2197(1,","))>=0)
			GotoPos(A_Index-1,pos+1)
		else
			sc.2136(line)
	}
}
Tab_To_Previous_Comma(){
	sc:=CSC()
	Loop,% sc.2570{
		line:=sc.2166(start:=sc.2585(A_Index-1))
		sc.2686(start-1,sc.2167(line))
		if((pos:=sc.2197(1,","))>=0){
			GotoPos(A_Index-1,pos+1)
		}else
			GotoPos(A_Index-1,sc.2167(line))
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
	HWND({rem:23})
	return
	tabwidth:
	Gui,Submit,Nohide
	tabwidth:=tabwidth?tabwidth:5,CSC().2036(tabwidth),Settings.Add("tab").text:=tabwidth
	return
}
Test_Plugin(){
	Exit(1)
}
Testing(){
	return m("Testing")
	/*
		
		InputBox,Out,Forward?,Forward?,,,,,,,,1
		return SetTimer(Out?"File_History_Forward":"File_History_Back",-1)
	*/
	/*
		return Project_Properties()
		return Insert_Color_Code()
	*/
	Selections:=[],sc:=CSC()
	
	Loop,% sc.2570
		Selections.Push({Start:sc.2585(A_Index-1),End:sc.2587(A_Index-1)})
	sc.2082(9,0xff00ff)
	sc.2080(9,7)
	sc.2523(9,100)
	/*
		for a,b in Selections{
			sc.2500(9),sc.2505(b.Start,b.End-b.Start)
			m(b.Start,b.End)
		}
	*/
	for a,b in Selections{
		if((Length:=b.End-b.Start)>0){
			Added:=1
			sc.2500(9),sc.2504(b.Start,b.End-b.Start)
		}
	}
	return
	
	
	Current:=Current(3).File
	if(!Node:=Positions.Find("//*/@file",Current))
		Node:=Positions.Add("file",{file:Current})
	sc.2082(9,0xff00ff)
	sc.2080(9,7)
	sc.2523(9,100)
	Loop,% sc.2570
		Selections.Push({Start:sc.2585(A_Index-1),End:sc.2587(A_Index-1)})
	if(sc.2570=1&&Selections.1.Start=Selections.1.End){
		CPos:=sc.2008
		Pos:=0,End:=sc.2006
		while((Pos:=sc.2509(9,Pos))<End){
			if(Pos=Last)
				Break
			if(Mod(A_Index,2))
				LastPos:=Pos
			else if(LastPos<CPos&&Pos>CPos){
				sc.2500(9),sc.2505(LastPos,Pos-LastPos)
				ExitApp
			}
			Last:=Pos
		}
	}
	for a,b in Selections{
		if((Length:=b.End-b.Start)>0){
			Added:=1
			sc.2500(9),sc.2504(b.Start,b.End-b.Start)
		}
	}
	return
	if(A_UserName!="maest")
		return m("Testing")
	return m("I'm sleepy.")
}
Insert_Color_Code(){
	static
	Static Code:=Color:=0xFF00FF
	NewWin:=new GUIKeep("Insert_Color_Code",HWND(1))
	NewWin.Add("Text,w200,Text"
			,"Button,gICCCFD,Choose From Dialog"
			,"Button,gICCCFS,Choose From Mouse Position"
			,"Button,gIIC,Insert &Into Code"
			,"Radio,gICCCTH vICCCTH Checked,RGB Hex"
			,"Radio,gICCCTH vICCCTD,RGB Decimal"
			,"Radio,gICCCTB vICCCTBGRH,BGR Hex"
			,"Radio,gICCCTB vICCCTB,BGR Decimal"
			,"Radio,gICCCTB vICCCTWR,#RGB (Web)"
			,"Radio,gICCCTB vICCCTWB,#BGR (Web)")
	NewWin.Show("Insert Color Code")
	DisplayColorCode:
	ICCCTH:
	ICCCTD:
	ICCCTB:
	ICCCTBGRH:
	info:=NewWin[]
	Gui,Insert_Color_Code:Submit,Nohide
	if(Info.ICCCTH)
		Code:=RGB(Color)
	else if(Info.ICCCTBGRH)
		Code:=RGB(RGB(Color))
	else if(Info.ICCCTD)
		Code:=Color
	else if(Info.ICCCTB)
		Code:=RGB(Color)+0
	else if(Info.ICCCTWR)
		Code:="#" SubStr(RGB(Color),3)
	else if(Info.ICCCTWB)
		Code:="#" SubStr(RGB(RGB(Color)),3)
	Gui,Insert_Color_Code:Font,% "c" RGB(Color)
	GuiControl,Insert_Color_Code:Font,Static1
	ControlSetText,Static1,%Code%,% NewWin.ID
	return
	ICCCFS:
	while(!GetKeyState("F1","P")){
		t("Press and hold F1 until this message goes away to keep this color")
		MouseGetPos,x,y
		PixelGetColor,Color,%x%,%y%,RGB
		Color:=RGB(Color)+0
		Gosub,DisplayColorCode
		Sleep,300
	}t()
	WinActivate,% NewWin.ID
	return
	Goto,DisplayColorCode	
	return
	IIC:
	sc:=CSC(),sc.2003(sc.2008,[Code])
	
	NewWin.Exit()
	return
	ICCCFD:
	Color:=Choose_Color(Color,hwnd(1))
	WinActivate,% NewWin.ID
	Goto,DisplayColorCode
	return
}
Choose_Color(Color,hwnd:=""){
	static
	VarSetCapacity(Custom,16*4,0),size:=VarSetCapacity(ChooseColor,9*4,0)
	for a,b in Settings.EA("//CustomColors")
		NumPut(Round(b),Custom,(A_Index-1)*4,"UInt")
	NumPut(size,ChooseColor,0,"UInt"),NumPut(hwnd,ChooseColor,4,"UPtr"),NumPut(Color,ChooseColor,3*4,"UInt"),NumPut(3,ChooseColor,5*4,"UInt"),NumPut(&Custom,ChooseColor,4*4,"UPtr"),ret:=DllCall("comdlg32\ChooseColorW","UPtr",&ChooseColor,"UInt")
	CustomColors:=Settings.Add("CustomColors")
	if(!ret)
		Exit
	return NumGet(ChooseColor,3*4,"UInt")
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
Theme(){
	new SettingsClass("Theme")
}
Toggle_Comment_Line(){
	sc:=CSC(),sc.2078,PI:=PosInfo(),sl:=sc.2166(PI.Start),el:=sc.2166((End:=PI.End)),Single:=sl=el?1:0,Replace:=RegExReplace(Settings.Get("//comment",";"),"%a_space%"," "),Comment:=[],SelectionEnd:=PI.End,LineComment:=[],AllComment:=1,Len:=StrPut(Replace,"UTF-8")-1
	for a,b in StrSplit(Replace)
		Comment.Push(Asc(b))
	while((Line:=sl+(A_Index-1))<=el){
		LineStart:=sc.2128(Line),LineComment[Line]:=1
		for a,b in Comment{
			if(sc.2007(LineStart+(A_Index-1))!=b){
				LineComment[Line]:=0,AllComment:=0
				Break
	}}}for a,b in LineComment{
		LineStart:=sc.2128(a)
		if((b&&AllComment)||(b&&!v.Options.Build_Comment))
			sc.2645(LineStart,Len),SelectionEnd-=Len
		else
			sc.2003(LineStart,Replace),SelectionEnd+=Len
	}(Single?"":sc.2160(PI.Start,SelectionEnd))
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
	sc:=CSC(),TopStyle:=sc.2010(sc.2143),BottomStyle:=sc.2010(sc.2145),CommentStyle:=Keywords.GetXML(Current(3).ext).SSN("//Styles/multilinecomment/@style").text
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
	}if(v.Options.Disable_Line_Status!=1)
		Loop,% ELine-SLine+1
			LineStatus.Add(SLine+(A_Index-1),2)
	sc.2079(),sc.Enable(1),Edited(),sc.2025(sc.2128(top+AddLine)),sc.2399
}
ToggleDuplicate(){
	MouseGetPos,x,y,,Control,2
	if(!sc:=s.ctrl[Control+0])
		return
	ControlGetPos,wx,wy,,,,% "ahk_id" sc.sc
	Pos:=sc.2022(x-wx,y-wy) ;,main:=Selection.GetMain()
	Select:=[]
	for a,b in v.DuplicateSelect[sc.2357]
		if(a<Pos&&a+b>Pos){
			Select:={Start:a,end:a+b}
			Break
		}
	if(!Select.end)
		return,Duplicates()
	Loop,% sc.2570{
		if(sc.2585(A_Index-1)=Select.Start)
			return sc.2671(A_Index-1),Duplicates()
	}sc.2573(Select.end,Select.Start),Duplicates()
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
	ControlGet,hwnd,hwnd,,SysListView322,% HWND(["Toolbar_Editor"])
	new Icon_Browser(nw,hwnd,"Toolbar_Editor","xy",300,"Toolbar_Editor","Toolbar_Editor"),nw.Add("Button,xm gTEHighlight,Toolbar Selection Highlight Color,y","Button,x+M gNextChecked,&Next Button,y","Button,x+M gAddExternal,Add &External Program,y"),nw.show("Toolbar Editor"),total:="",cross:=[],Default("SysTreeView321","Toolbar_Editor"),all:=menus.SN("//main/descendant::*")
	while(aa:=all.item[A_Index-1],ea:=XML.EA(aa)){
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
	Goto,TESelect
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
	while(rr:=remtv.item[A_Index-1],ea:=XML.EA(rr))
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
		this.XML:=new XML("Tracked_Notes",A_ScriptDir "\lib\Tracked Notes.XML")
		if(!this.XML.SSN("//master"))
			this.XML.Under(this.XML.Add("master",{file:"Global Notes",id:1}),"global")
		All:=this.XML.SN("//main")
		while(aa:=All.Item[A_Index-1],ea:=XML.EA(aa)){
			if(!SSN(aa,"descendant::global")){
				if(aa.Text)
					Text:=aa.Text,aa.Text:="",New:=this.XML.Under(aa,"global",,Text)
		}}list:=this.XML.SN("//Tracked_Notes/descendant::*[not(@id)]")
		while(ll:=list.item[A_Index-1]),ea:=XML.EA(ll){
			id:=1
			while(this.XML.SSN("//*[@id='" ++id "']")){
			}ll.SetAttribute("id",id)
		}this.Populate()
		return this
	}GetPos(){
		sc:=MainWin.tnsc,fold:=0,Node:=this.Node,Node.RemoveAttribute("fold")
		for a,b in {start:sc.2008,end:sc.2009,scroll:sc.2152}
			Node.SetAttribute(a,b)
		while(sc.2618(fold)>=0,fold:=sc.2618(fold))
			list.=fold ",",fold++
		if(list)
			Node.SetAttribute("fold",list)
	}Populate(){
		TVC.Default(3),this.XML.SSN("//*[@tv='" TV_GetSelection() "']").SetAttribute("last",1),all:=this.XML.SN("//*"),TVC.Delete(3,0)
		while(aa:=all.item[A_Index-1],ea:=XML.EA(aa)){
			ClosedFile:=0
			if(aa.NodeName="main"){
				if(!CEXML.Find("//main/@file",ea.File)){
					if(!Closed),ClosedFile:=1
						Closed:=TVC.Add(3,"Closed Files")
			}}if(aa.NodeName="global")
				Continue
			if(aa.NodeName="master"||aa.NodeName="file"||aa.NodeName="main"||aa.NodeName="folder")
				TVC.Default(3),aa.SetAttribute("tv",TV_Add(ea.Name?ea.Name:SubStr(text:=StrSplit(ea.file,"\").Pop(),1,(InStr(text,".")?InStr(text,".")-1:StrLen(text))),ClosedFile?Closed:SSN(aa.ParentNode,"@tv").text,ea.last?"Select Vis Focus":""))
			if(ea.last)
				aa.RemoveAttribute("last"),First:=SSN(aa,"@tv").text
		}All:=this.XML.SN("//*[@expand]")
		while(aa:=All.Item[A_Index-1],ea:=XML.EA(aa))
			TVC.Modify(3,,ea.TV,"Expand")
		if(First)
			TVC.Modify(3,"",First,"Select Vis Focus")
	}Register(sc){
		this.sc:=sc
	}SaveState(){
		All:=TNotes.XML.SN("//*[@tv]")
		while(aa:=All.Item[A_Index-1],ea:=XML.EA(aa))
			TVC.Get(3,ea.TV)?aa.SetAttribute("expand",1):aa.RemoveAttribute("expand")
		TNotes.XML.SSN("//*[@tv='" TVC.Selection(3) "']").SetAttribute("last",1)
	}SetNode(){
		if(!MainWin.Gui.SSN("//*[@type='Tracked Notes']"))
			return
		if(!TVC.Selection(3)){
			TVC.Modify(3,"",TV_GetChild(0),"Select Vis Focus")
		}
		Node:=TNotes.XML.SSN("//*[@tv='" TVC.Selection(3) "']")
		if(Node.NodeName="Main"||Node.NodeName="Master"){
			if(!Node:=SSN(Node,"global"))
				Node:=TNotes.XML.Under(Node,"global")
		}TNotes.Node:=Node
	}SetText(){
		static Node
		sc:=MainWin.tnsc,last:=CSC().sc
		if(this.Node.XML!=Node.XML&&this.Node.XML){
			if(sc.2140)
				sc.2171(0)
			if(SSN(this.Node,"*"))
				Lock:=1 ;,t("Found?",SubStr(this.Node.xml,1,200))
			this.SetNode()
			All:=SN(this.Node,"descendant-or-self::*"),Text:=""
			while(aa:=All.Item[A_Index-1],ea:=XML.EA(aa)){
				if(!SSN(aa,"*").NodeName)
					Text.=(All.Length=1?"":RegExReplace(ea.Name,"\s","_") ":`n") aa.Text "`n"
				else if(A_Index>1)
					Text.=RegExReplace(ea.Name,"\s","_") ":`n"
			}Encode(RegExReplace(Trim(Text,"`n"),Chr(127),"`n"),txt),sc.2181(0,&txt)
			if(Lock)
				sc.2171(1),Lock:=0
			ea:=XML.EA(this.Node),sc.2160(Round(ea.start),Round(ea.end))
			Sleep,10
			for a,b in StrSplit(ea.fold,",")
				sc.2237(b,0)
			sc.2613(Round(ea.scroll)),sc.2352(-1)
			MarginWidth(sc)
		}
		Node:=this.Node,CSC({hwnd:last})
	}tn(){
		tn:
		if(A_GuiEvent="S"||A_GuiEvent="Normal"){
			if(Node:=TNotes.XML.SSN("//*[@tv='" A_EventInfo "']")){
				TNotes.GetPos(),sc:=TNotes.tnsc,TNotes.SetNode(),Node:=TNotes.Node
				if(Node.NodeName!="master"){
					if(tv:=SSN(CEXML.Find("//file/@file",SSN(Node,"@file").text),"@tv").text)
						tv(tv)
					else{
						if((ea:=CEXML.EA("//file[translate(@file, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')='" Format("{:L}",SSN(Node,"@file").text) "']")).tv)
							tv(ea.TV)
					}
				}else
					TNotes.SetText()
				/*
					if(TNotes.Node.NodeName="main"){
						if(!Node:=SSN(TNotes.Node,"global"))
							Node:=TNotes.XML.Under(TNotes.Node,"global")
						TNotes.Node:=Node
						if(sc.2140)
							sc.2171(0)
					}
				*/
				if(SSN(Node,"*").NodeName)
					sc.2171(1),Value:=1
				else if(sc.2140)
					sc.2171(0),Value:=2
				else
					Value:=3
				TNotes.SetText()
		}}return
	}Track(){
		Project:=Current(2).file,file:=Current(3).file,id:=0
		if(Node:=this.XML.Find("//*/@file",file))
			return m("File already being tracked",Node.xml,"","",file)
		if(!Project||!file)
			return
		if(!Master:=this.XML.Find("//main/@file",Project))
			Master:=this.XML.Add("main",{file:Project},,1),this.XML.Under(Master,"global")
		if(!Node:=this.XML.Find(Master,"descendant::file/@file",file))
			Node:=this.XML.Under(Master,"file",{file:file,last:1})
		if(!SSN(Node,"@id"))
			while(this.XML.SSN("//*[@id='" ++id "']")){
			}Node.SetAttribute("id",id)
		this.XML.Transform(2)
		Node:=this.XML.SSN("//*[@last]")
		this.Node:=Node,this.Populate()
	}Write(sc){
		if(SSN(this.Node,"*"))
			sc.2171(1),t(SubStr(this.Node,1,200),"Tracked_Notes.Write()")
		else{
			if(sc.2140)
				sc.2171(0)
			this.Node.text:=RegExReplace(sc.GetUni(),"\R",Chr(127))
		}
		
	}
}
tv(tv*){
	static lasttv,LastExt:=[],Last
	TVC.Default(1),ctv:=TV_GetSelection()
	/*
		Scan_Line()
	*/
	if(!sel:=CEXML.SSN("//*[@tv='" tv.1 "']/@tv").text)
		sel:=CEXML.SSN("//*[@tv='" tv.3 "']/@tv").text
	if(CEXML.SSN("//*[@tv='" sel "']").NodeName="files")
		return
	if(IsObject(tv.1))
		sel:=tv.1.1
	lasttv:=sel
	if(tv.2!="NoTrack")
		sc:=CSC(),History.Add(CEXML.EA("//*[@sc='" sc.2357 "']"),sc,1)
	if(!tv.2.sc)
		sc:=CSC()
	else
		sc:=CSC({hwnd:tv.2.sc})
	if(sc.sc=MainWin.tnsc.sc||sc.sc=v.debug.sc)
		sc:=CSC(1)
	if(sc.sc=MainWin.tnsc.sc)
		sc:=CSC({set:1})
	if(tv.1="Split")
		sel:=Current(3).tv
	if(sel){
		sc:=CSC()
		if((filename:=CEXML.SSN("//*[@sc='" sc.2357 "']/@file").text)){
			if(Node:=positions.Find("//file/@file",Filename))
				GetPos(Node)
			else
				GetPos(positions.Under(positions.SSN("//*"),"file",{file:filename}))
		}onode:=Node:=CEXML.SSN("//*[@tv='" sel "']"),ea:=XML.EA(Node)
		if(Node.NodeName!="file")
			return
		v.DisableContext:="",TV_Modify(sel,"Vis"),Update({sc:sc.2357}),sc.2045(2),sc.2045(3)
		if(Node.NodeName="folder"||ea.folder=1)
			return
		sc.Enable()
		if(!ea.sc){
			if((nodes:=CEXML.SN("//*[@id='" ea.id "']")).length>1){
				while(nn:=nodes.item[A_Index-1]),fea:=XML.EA(nn){
					if(fea.sc){
						Node.SetAttribute("sc",fea.sc),ea:=XML.EA(Node)
						Break
		}}}}if(ea.sc){
			TVState(),TVC.Disable(1),TVC.Modify(1,"",ea.tv,"Select Vis Focus"),TVC.Enable(1),sc.2358(0,ea.sc),TVState(1),Color(sc,GetLanguage(sc)),sc.Enable(1)
		}else if(ea.sc!=sc.2357){
			if(!ea.sc){
				sc.2358(0,0)
				Sleep,80
				doc:=sc.2357,sc.2376(0,doc),Node.SetAttribute("sc",doc),tt:=Update({Get:ea.file}),encoding:=ea.encoding,Encoding:=Encoding?Encoding:"UTF-8",sc.2037(65001),Encode(tt,Text,Encoding),sc.Enable(),sc.2181(0,&text),sc.2175(),Language:=Settings.SSN("//Extensions/Extension[text()='" ea.ext "']/@language").text,Language:=Language?Language:"ahk",sc.4006(0,Language),Color(sc,GetLanguage(sc))
				Sleep,50
				sc.Enable(1)
			}else
				m("The current document is not the right document. If this continues to happen please let maestrith know."),tv(CEXML.SSN("//main/file/@tv").text)
		}TVC.Disable(1),TVC.Modify(1,"",sel,"Select Vis Focus"),TVC.Enable(1)
		if(IsObject(tv.2)&&tv.2.start!=""){
			if(pos.fold!="")
				for a,b in StrSplit(pos.fold,",")
					sc.2237(b,0)
			sc.2160(tv.2.start,tv.2.end),CenterSel()
			v.tvpos:=pos:=XML.EA(positions.Find("//file/@file",SSN(Node,"@file").text))
		}else{
			pos:=positions.EA(positions.Find("//file/@file",SSN(Node,"@file").text))
			if(pos.fold!="")
				for a,b in StrSplit(pos.fold,",")
					sc.2237(b,0)
			(pos.start||pos.end)?sc.2160(pos.end,pos.start):"",(pos.scroll!="")?sc.2613(pos.scroll):"" ; FIXED - scroll pos after switching file by smarq8
		}sc.Enable(1),Node:=gui.SSN("//*[@hwnd='" sc.sc+0 "']"),Node.SetAttribute("file",ea.file)
	}else if(tv.2.end!="")
		pos:=tv.2,sc.2160(pos.start,pos.end),CenterSel()
	else{
		SetTimer,ScanWID,-200
		TVC.Default(1),TV_Modify(A_EventInfo,(TV_Get(A_EventInfo,"Expand")?"-":"") "Expand")
		return
	}
	/*
		if(SplitPath(ea.file).ext="cxx"){
			for a,b in ["fold","foldComment","foldCommentMultiline","foldSyntaxBased","foldCommentExplicit","foldExplicitAnywhere","foldPreprocessorAtElse","foldPreprocessor","foldCompact","foldAtElse",""]
				sc.4004(b,["1"])
			sc.4004("foldExplicitStart","//{")
			sc.4004("foldExplicitEnd","//}")
			sc.2056(11,"Consolas")
			sc.2051(11,0xFFFFFF)
			text=auto array bool break case char class complex ComplexInf ComplexNaN const continue default delete do double else enum export extern float for foreach Goto if Inf inline int long namespace NaN new NULL private public register restrict return short signed sizeof static string_t struct switch this typedef union unsigned using void volatile wchar_t while __declspec
			Loop,10
				sc.4005(A_Index-1,text)
		}
	*/
	SetTimer,ScanWID,-200
	sc.2400(),WinSetTitle(1,ea),DebugHighlight(),LineStatus.tv()
	SetTimer,HighlightCode,-20
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
	if(x)
		TVC.Enable(1)
	else
		TVC.Disable(1)
}
UnderlineDuplicateWords(){
	sc:=CSC(),sc.2500(6),sc.2505(0,sc.2006)
	if(sc.2507(6,sc.2008))
		return
	Word:=sc.GetWord(),Length:=StrPut(Word,"UTF-8")-1
	if(Length<=1)
		return
	Dup:=[],sc.2686(0,sc.2006),sc.2500(6)
	if(!Word)
		return
	while(Found:=sc.2197(Length,[Word]))>=0
		Dup.Insert(Found),sc.2686(++Found,sc.2006)
	if(Dup.MaxIndex()>1){
		for a,b in Dup
			sc.2500(6),sc.2504(b,Length)
}}
Undo(){
	CSC().2176
}
UnSaved(){
	un:=CEXML.SN("//main[@untitled]"),ts:=Settings.SSN("//template").text,file:=FileOpen("c:\windows\shellnew\template.ahk",0),td:=file.Read(file.length),file.Close(),template:=ts?ts:td
	while(uu:=un.item[A_Index-1],ea:=XML.EA(uu.FirstChild)){
		text:=Update({Get:ea.file})
		if(text=template)
			Continue
		if(m(ea.file,"This is an untitled document meaning there is no file created to the HDD/SSD yet.","Would you like to save it?","Contents:",SubStr(text,1,200) (StrLen(text)>200?"...":""),b,"btn:ync")="Yes"){
			NewFile:=DLG_FileSave(HWND(1),,"Save Untitled File")
			if(ErrorLevel||NewFile="")
				Continue
			if(FileExist(NewFile)){
				SplitPath,NewFile,,dir,ext,nne
				FileMove,%NewFile%,%dir%\%nne%-%A_Now%.%ext%,1
			}NewFile:=SubStr(NewFile,-3)!=".ahk"?NewFile ".ahk":NewFile,file:=FileOpen(NewFile,"RW","UTF-8"),file.seek(0),file.write(RegExReplace(text,"\R","`r`n")),file.length(file.position),file.Close()
			if(!Settings.SSN("//open/file[text()='" NewFile "']")&&NewFile)
				Settings.Add("open/file",,NewFile)
			Settings.Add("last/file",,NewFile),uu.RemoveChild(uu.FirstChild)
	}}v.unsaved:=1
}
Update_Github_Info(){
	static
	info:=Settings.EA("//github"),Setup(36)
	controls:={owner:"Owner (GitHub Username)",email:"Email",name:"Your Full Name"}
	for a,b in {owner:100,email:200,name:100}{
		Gui,Add,Text,xm,% controls[a] ":"
		Gui,Add,Edit,x+M yp-3 w%b% gUpdateGithubInfo v%a%,% info[a]
	}
	Gui,Add,Text,xm hwndGTText,Github Token:
	Gui,Add,Edit,x+M w300 yp-3 Password hwndPassword gUpdateGithubInfo vtoken,% info.token
	ControlGetPos,x,y,w,h,,ahk_id%Password%
	ControlGetPos,tx,,,,,ahk_id%GTText%
	Gui,Add,Button,% "xm w" x+w-tx " ggettoken",Get A Token
	Gui,Show,,Github Information
	return
	UpdateGithubInfo:
	Gui,36:Submit,NoHide
	if !hub:=Settings.SSN("//github")
		hub:=Settings.Add("github")
	for a,b in {owner:owner,email:email,name:name,token:token}
		hub.SetAttribute(a,b)
	return
	36GuiEscape:
	36GuiClose:
	HWND({rem:36})
	if WinExist(HWND([10]))
		WinActivate,% HWND([10])
	return
	gettoken:
	Run,https://github.com/maestrith/AHK-Studio/wiki/Github-API-Key
	return
}
Update(Info){
	/*
		need to remove the Updated stuff alltogether
	*/
	static Update:=[],Updated:=[],Encoding:=[]
	if(Info.Delete)
		return Update.Delete(Info.Delete),Updated.Delete(Info.Delete)
	else if(Info.sc){
		return Update[CEXML.SSN("//*[@sc='" Info.sc "']/@file").text]:=CSC().GetUNI()
	}else if(Info.remove)
		return Update.Delete(Info.remove),Updated.Delete(Info.remove)
	else if(Info="Updated")
		return Updated
	else if(Info.edited)
		return Updated[Info.edited]:=1
	else if(Info="ClearUpdated")
		return Updated:=[]
	else if(Info="Get")
		return [Update,Updated]
	else if(Info.File){
		if(Info.Text)
			Update[Info.File]:=Info.Text
		if(!Info.Load)
			Edited(Info.node)
		if(Info.Encoding)
			Encoding[Info.File]:=Info.Encoding
		return
	}else if(Info.Get){
		if(!Text:=Update[Info.Get]){
			q:=FileOpen(Info.Get,"R")
			if(q.Encoding="CP1252"){
				if(RegExMatch((Text:=q.Read()),"OU)([^\x00-\x7F])",Found)){
					q:=FileOpen(Info.Get,"R","UTF-8"),Text:=q.Read()
					Encoding:="UTF-8"
				}else
					Encoding:=q.Encoding
			}else
				Encoding:=q.Encoding,Text:=q.Read()
			q.Close(),Text:=Update[Info.Get]:=RegExReplace(Text,"\R","`n"),Encoding[Info.Get]:=Encoding
		}
		return Text
	}else if(Info.encoded){
		if(!Update[Info.encoded])
			return
		Encode(Update[Info.encoded],tt,Encoding[Info.encoded])
		return StrGet(&tt,"utf-8")
	}
	else if(Info.Encoding)
		return Encoding[Info.File]:=Info.Encoding
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
	sc:=CSC(),CPos:=sc.2008,EPos:=sc.2009,Line:=sc.2166(CPos),Length:=sc.2006
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
	}if(v.LineEdited.MinIndex()!=""&&!v.LineEdited.HasKey(Line)&&Line!="")
		Scan_Line()
	SetStatus(Text,1),LastLine:=Line
	if(CPos=EPos&&LastPos!=CPos)
		SetTimer,UnderlineDuplicateWords,-500
	else if(CPos!=EPos)
		sc.2500(6),sc.2505(0,Length)
	LastPos:=CPos
	if(!NoContext){
		if(v.ShowTT)
			t("UpPos Here","time:1",v.ShowTT.="UpPos,")
		SetTimer,Context,-500
	}
	BraceHighlight()
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
	return (http.Status=200?http.ResponseText:"Error")
}
VarBrowser(){
	static NewWin,treeview
	if(!debug.VarBrowser){
		debugwin:=NewWin:=new GUIKeep(98),NewWin.Add("TreeView,w450 h200 gvalue vtreeview AltSubmit hwndtreeview,,wh","ListView,w450 r4 AltSubmit gVBGoto,Stack|File|Line,wy","Text,w200 Section,Debug Controls:,y"
			,"Button,gRun_Program,&Run,y","Button,x+M gStep_Into,Step &Into,y","Button,x+M gStep_Out,Step &Out,y"
			,"Button,x+M gStep_Over,Step O&ver,y","Button,x+M gVarBrowserRefresh,R&efresh Variables,y","Button,x+M gStop_Debugger,&Stop,y"),NewWin.show("Variable Browser"),hwnd:=NewWin.XML.SSN("//*/@hwnd").text,debug.VarBrowser:=1
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
		return ;#[Flan]
	}
	debug.Send("stack_get") ;#[VarBrowser]
	return
	98Close:
	98Escape:
	debug.XML:=new XML("debug"),debug.XML.Add("local"),debug.XML.Add("global"),debug.VarBrowser:=0,NewWin.Exit()
	return
	VBGoto:
	if(A_GuiEvent~="Normal|I"){
		Default("SysListView321",98),LV_GetText(file,LV_GetNext(),2),LV_GetText(line,LV_GetNext(),3)
		if(tv:=SSN(CEXML.Find("//file/@file",file),"@tv").text){
			tv(tv),sc:=CSC()
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
	if(WinExist(NewWin.id)){
		wait:=debug.XML.SN("//wait")
		while(ww:=wait.item[A_Index-1]),ea:=XML.EA(ww)
			Default("SysTreeView321",98),TV_Modify(ea.tv,,"Information Unavailable, Debugging has stopped")
	}
	return
}
Version_Tracker(){
	new Version_Tracker()
}
DeleteExtraFiles(FileList,DD){
	static DXML
	for a,b in FileList
		Total.=a "`n"
	DXML:=DD
	if(Total)
		m("These Files May Need Deleted On GitHub:",Total)
	return
	;~ !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	;~ !!!!!!!!!!!!!!!!!!!!!!!!!!!! make a GUI to allow you to remove them !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	;~ !!!!!!!!!!!!!!!!!!!!!!!!!!!!         and maybe checkboxes?          !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	;~ !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	
	;~ !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	;~ !!!!!!    this throws the files here that need deleted or at the very least for review    !!!!!!!
	;~ !!!!!! you can get the DXML and the files will be there. Maybe push DXML here so that it  !!!!!!!
	;~ !!!!!!                                     will be ok                                     !!!!!!!
	;~ !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	
	;~ !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	;~ !!!!!!!!!!!!!!!!!!!!!!!!!!!                 OH YEA!                  !!!!!!!!!!!!!!!!!!!!!!!!!!!!
	;~ !!!!!!!!!!!!!!!!!!!!!!!!!!! Doing a push without re-starting Studio  !!!!!!!!!!!!!!!!!!!!!!!!!!!!
	;~ !!!!!!!!!!!!!!!!!!!!!!!!!!!     Throws an error, with no message     !!!!!!!!!!!!!!!!!!!!!!!!!!!!
	;~ !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	
}
EncodeFile(fn,time,nn,branch){
	FileRead,bin,*c %fn%
	FileGetSize,size,%fn%
	DllCall("Crypt32.dll\CryptBinaryToStringW",Ptr,&bin,UInt,size,UInt,1,UInt,0,UIntP,Bytes),VarSetCapacity(out,Bytes*2),DllCall("Crypt32.dll\CryptBinaryToStringW",Ptr,&bin,UInt,size,UInt,1,Str,out,UIntP,Bytes)
	StringReplace,out,out,`r`n,,All
	if(SubStr(Out,1,4)="77u/")
		Out:=SubStr(Out,5)
	return {text:out,encoding:"UTF-8",time:time,skip:1,node:nn,branch:branch}
}
Class Version_Tracker Extends ConvertStyle{
	__New(){
		if(!IsObject(VVersion))
			VVersion:=new XML("versions",(FileExist("lib\Github.xml")?"lib\Github.xml":"lib\Versions.xml"))
		xx:=VVersion
		if((All:=xx.SN("//version[text()]")).Length)
			return this.ConvertStyle()
		this.VersionWindow()
	}GetNode(VersionNode:=""){
		Version_Tracker.NewWin.Default("VT")
		Node:=VVersion.SSN("//*[@tv='" TV_GetSelection() "']" (VersionNode=1?"ancestor-or-self::version":VersionNode?VersionNode:""))
		return Node
	}GetRoot(){
		xx:=VVersion
		if(!Root:=Version_Tracker.GetNode("ancestor::info"))
			Root:=xx.Find("//info/@file",Current(2).File)
		return Root
	}VersionWindow(){
		static
		xx:=VVersion
		if(!Root:=xx.Find("//info/@file",Current(2).File))
			Info:=xx.Under(xx.Under((Branch:=xx.Under((Root:=xx.Add("info",{file:Current(2).File},,1)),"branch",{name:"master"})),"version",{name:"1",draft:"false",prerelease:"true",target_commitish:"master"}),"info",{type:"",action:"",issue:"",user:"",select:1}),Select:=Info
		VersionGUI:
		NewWin:=new GUIKeep("Version"),Version_Tracker.NewWin:=NewWin
		NewWin.Add("TreeView,w350 h250 vVT gVersionShowVersion vTVVersion AltSubmit,,h"
			,"Edit,x+M w500 h500 gVerEdit vEdit,,wh","ListView,xm w350 y250 h250 NoSortHdr,Directory|File,y"
			,"Button,xm gCommitProject,Co&mmit Project,y","Checkbox,x+M gVersionOneFile vCommitAsOne,Commit As &One File,y")
		NewWin.Show((Settings.SSN("//github")?"Github ":"")"Version Tracker")
		NewWin.Hotkeys({Delete:"VerDelete","!a":"VersionAddAction",F1:"VersionCompileCurrent","!Up":"VersionMove"
					,"!Down":"VersionMove",Enter:"VersionEdit","!n":"NewVersionBranch"
					,"^Up":"AddNewVersion","^Down":"AddNewVersion"})
		if(Select:=SSN(Root,"descendant::*[@select]"))
			return Version_Tracker.Select(Select)
		return Version_Tracker.Select(SSN(Root,"descendant::info"))
		VersionCompileCurrent:
		NewWin.Default("VT"),Node:=Version_Tracker.GetNode(1)
		if(!Node)
			Version_Tracker.NewWin.Default("VT"),Node:=VVersion.SSN("//*[@tv='" TV_GetSelection() "']"),All:=SN(Node,"descendant::*"),Info:=""
		else
			All:=SN(Node,"descendant-or-self::*"),Info:=""
		while(aa:=All.Item[A_Index-1],ea:=XML.EA(aa)){
			if(aa.NodeName="Version")
				Info.=(Info?":`r`n":"") ea.Name
			else
				Info.=(Info?"`r`n":"") (ea.Type?ea.Type ":":"") (ea.Action?" " ea.Action " by " ea.User:"") (ea.Issue?" " ea.Issue:"") (ea.Type?"`r`n":"") RegExReplace(aa.Text,Chr(127),"`r`n")
		}
		if(Version_Tracker.GetVersionInfo)
			return Version_Tracker.GetVersionInfo:=Info
		m("Information has been added to your Clipboard:","",Clipboard:=Info)
		return
		VersionOneFile:
		if(!Node:=Version_Tracker.GetNode("ancestor-or-self::branch")){
			m("Please select a version to apply this to")
			GuiControl,Version:,% NewWin.XML.SSN("//*[@var='CommitAsOne']/@hwnd").text,0
			return
		}
		if(NewWin[].CommitAsOne)
			Node.SetAttribute("onefile",1)
		else
			Node.RemoveAttribute("onefile")
		return
		CommitProject:
		Version_Tracker.Commit()
		/*
			Save()
			Run,"D:\AHK\AHK-Studio\Projects\GitHub\GitHub Test.ahk"
		*/
		return
		;~ !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		;~ !!!! MAKE SURE TO NOT REMOVE ANYTHING IF/WHEN THE USER RE-DOWNLOADS EVERYTHING FROM GITHUB  !!!!!
		;~ !!!!                         RUN IT THROUGH HERE AFTER DOWNLOADING                          !!!!!
		;~ !!!!                           Have it go through ConvertStyle()                            !!!!!
		;~ !!!!                                                                                        !!!!!
		;~ !!!!                                         Need:                                          !!!!!
		;~ !!!!                                       Drag/Drop:                                       !!!!!
		;~ !!!!                             -Make it like Github basically                             !!!!!
		;~ !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		AddNewVersion:
		Direction:=SubStr(A_ThisHotkey,2)
		Node:=Version_Tracker.GetNode(1)
		if(Direction="Down"){
			NewWin.Default("VT")
			Name:=SSN(Node,"@name").text
			if(RegExMatch(Name,"OU)(.*\.)(-?\d+)$",Found)){
				Name:=Found.1 Format("{:0" StrLen(Found.2) "}",(Found.2>=0?Found.2-1:Found.2+-1))
			}else if(RegExMatch(Name,"OU)(.*)(-?\d+)$",Found))
				Name:=Found.1 Format("{:0" StrLen(Found.2) "}",(Found.2>=0?Found.2-1:Found.2+-1))
			else
				Name:=Name " 0"
			m(Name)
			TV_Modify(SSN(Node,"@tv").text,"-Expand")
			New:=VVersion.Under((Parent:=VVersion.Under(Node.ParentNode,"version",{name:Name,draft:"false",prerelease:"false",target_commitish:SSN(Node,"ancestor::branch/@name").text})),"info",{action:"",issue:"",type:"",user:""})
			if(Next:=Node.NextSibling)
				Node.ParentNode.InsertBefore(Parent,Next)
			Version_Tracker.Select(New)
		}else{
			Name:=SSN(Node,"@name").text
			if(RegExMatch(Name,"OU)(.*\.)(\d+)$",Found)){
				Name:=Found.1 Format("{:0" StrLen(Found.2) "}",Found.2+1)
			}else if(RegExMatch(Name,"OU)(.*)(\d+)$",Found))
				Name:=Found.1 Format("{:0" StrLen(Found.2) "}",Found.2+1)
			else
				Name:=Name " 1"
			TV_Modify(SSN(Node,"@tv").text,"-Expand")
			New:=VVersion.Under((Parent:=VVersion.Under(Node.ParentNode,"version",{name:Name,draft:"false",prerelease:"false",target_commitish:SSN(Node,"ancestor::branch/@name").text})),"info",{action:"",issue:"",type:"",user:""})
			Node.ParentNode.InsertBefore(Parent,Node)
			Version_Tracker.Select(New)
		}
		return
		NewVersionBranch:
		Node:=Version_Tracker.GetNode()
		Root:=SSN(Node,"ancestor::info")
		Branch:=InputBox(NewWin.HWND,"New Branch","Enter the name for this new branch`nSpaces will be replaced with -`nAnything other than [A-Za-z0-9_-] will be removed")
		Branch:=RegExReplace(RegExReplace(Branch,"\s","-"),"[^a-zA-Z-_]")
		if(SSN(Root,"//branch[@name='" Branch "']"))
			return m("Branch already exists")
		New:=VVersion.Under(Root,"branch",{name:Branch}),OneMore:=VVersion.Under(New,"version",{draft:"false",name:"1",prerelease:"true",target_commitish:Branch}),Last:=VVersion.Under(OneMore,"info",{action:"",issue:"",type:"",user:""}),Version_Tracker.Select(Last)
		return
		VersionEdit:
		ControlGetFocus,Focus,% NewWin.ID
		if(Focus="SysTreeView321"){
			if((Node:=Version_Tracker.GetNode()).NodeName="Version"){
				Number:=InputBox(NewWin.HWND,"Edit Version Number","Enter A New Version Number",SSN(Node,"@name").text)
				if(!Number)
					return m("A Version Number Needs To Be Assigned")
				if(SSN(Node.ParentNode,"descendant::*[@name='" Number "']"))
					return m("Version already exists")
				Node.SetAttribute("name",Number),Version_Tracker.Populate(1)
				return
			}else if(SSN(Node,"ancestor-or-self::Github")){
				Select:=Node,Key:=Node.NodeName,Node:=Settings.SSN("//github")
				if(Key="Repo"){
					Root:=Version_Tracker.GetRoot()
					if(Value:=InputBox(NewWin.ID,"Enter A New Value","Enter A New Value For: Repository (Most Non-Word Characters will be replaced)",SSN(Root,"@repo").text)){
						Value:=Clean(Value,3)
						;~ !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
						;~ !!!!!!!!!!!!!!! MAKE SURE THAT !!!!!!!!!!!!!!!!
						;~ !!!!!!!!!!!!!!!    you edit    !!!!!!!!!!!!!!!!
						;~ !!!!!!!!!!!!!!!    the name    !!!!!!!!!!!!!!!!
						;~ !!!!!!!!!!!!!!!    of this     !!!!!!!!!!!!!!!!
						;~ !!!!!!!!!!!!!!!      REPO      !!!!!!!!!!!!!!!!
						;~ !!!!!!!!!!!!!!!   On GitHub    !!!!!!!!!!!!!!!!
						;~ !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
						Root.SetAttribute("repo",Value),Version_Tracker.Select(Select)
						if(m("Refresh This Repo?","btn:ync","def:2")="Yes"){
							;here
						}
						return
				}}else if(Value:=InputBox(NewWin.ID,"Enter A New Value","Enter A New Value For: " Format("{:T}",Key),SSN(Node,"@" Key).text))
					Node.SetAttribute(Key,Value)
				Version_Tracker.Select(Select)
				return
			}
			return Version_Tracker.VersionAddAction()
		}
		Send,{Enter}
		return
		VersionMove:
		Direction:=SubStr(A_ThisHotkey,2),Node:=Version_Tracker.GetNode()
		if(Next:=Direction="Down"?Node.NextSibling.NextSibling:Node.PreviousSibling){
			Node.ParentNode.InsertBefore(Node,Next),All:=SN(Version_Tracker.GetNode("ancestor::info"),"descendant::*[@select]")
			while(aa:=All.Item[A_Index-1])
				aa.RemoveAttribute("select")
			Node.SetAttribute("select",1)
			Version_Tracker.Populate()
		}else if(Direction="Down"){
			Node.ParentNode.AppendChild(Node)
			Version_Tracker.Populate()
		}
		return
		VerEdit:
		Edit:=NewWin[].Edit
		NewWin.Default("VT"),Node:=xx.SSN("//*[@tv='" TV_GetSelection() "']")
		Node.Text:=RegExReplace(Edit,"\R",Chr(127))
		return
		VersionShowVersion:
		if(A_GuiEvent="S"){
			NewWin.Default("TVVersion")
			Node:=VVersion.SSN("//*[@tv='" TV_GetSelection() "']")
			if(!SSN(Node,"*")){
				GuiControl,Version:,Edit1,% RegExReplace(Node.Text,Chr(127),"`r`n")
				NewWin.Disable("VerEdit",0)
			}else if(Node.NodeName="Version"){
				All:=SN(Node,"descendant::*"),Info:=""
				while(aa:=All.Item[A_Index-1],ea:=XML.EA(aa)){
					Info.=(Info?"`r`n":"") ea.Type ":" (ea.Action?" " ea.Action " by " ea.User:"") "`r`n" RegExReplace(aa.Text,Chr(127),"`r`n")
				}GuiControl,Version:,Edit1,%Info%
				NewWin.Disable("VerEdit")
			}else if(Node.NodeName="Branch"){
				All:=SN(Node,"descendant::version"),VersionList:=""
				while(aa:=All.Item[A_Index-1],ea:=XML.EA(aa))
					VersionList.=ea.Name "`n",Count:=A_Index
				GuiControl,Version:,Edit1,% (Count=1?"Version":"Versions") ":`r`n`r`n" VersionList
				NewWin.Disable("VerEdit")
			}else
				NewWin.Disable("VerEdit")
			FileNode:=SSN(Node,"ancestor-or-self::branch")
			if(FileNode.xml!=LastFileNode.xml){
				LastFileNode:=FileNode,LV_Delete()
				All:=SN(Node,"ancestor-or-self::branch/descendant::files/file")
				while(aa:=All.Item[A_Index-1],ea:=XML.EA(aa))
					LV_Add("",ea.Folder,ea.File)
				Loop,% LV_GetCount("Column")
					LV_ModifyCol(A_Index,"AutoHDR")
				LV_Modify(1,"Select Vis Focus")
			}
			GuiControl,Version:,% NewWin.XML.SSN("//*[@var='CommitAsOne']/@hwnd").text,% SSN(Node,"ancestor-or-self::branch/@onefile")?1:0
		}
		return
		VersionEscape:
		VersionClose:
		Version_Tracker.Populate(1)
		if(!Version_Tracker.GetNode())
			return NewWin.Exit()
		xx:=VVersion
		/*
			if(!Root:=Version_Tracker.GetNode("ancestor::info")),NewWin:=Version_Tracker.NewWin,xx:=VVersion
				Root:=xx.Find("//info/@file",Current(2).File)
			All:=SN(Root,"descendant::*[@select]|//GitHub/descendant::*[@select]")
			while(aa:=All.Item[A_Index-1])
				aa.RemoveAttribute("select")
		*/
		NewWin.Default("VT"),Node:=xx.SSN("//*[@tv='" TV_GetSelection() "']"),Node.SetAttribute("select",1),Version_Tracker.TVState(),NewWin.Exit(),All:=VVersion.SN("//*[@tv]")
		while(aa:=All.Item[A_Index-1])
			aa.RemoveAttribute("tv")
		VVersion.Transform()
		return
	}VersionAddAction(){
		static
		EditNode:=Version_Tracker.GetNode()
		VersionAddAction:
		NewWin:=Version_Tracker.NewWin,xx:=VVersion
		Node:=Version_Tracker.GetNode(1)
		if(Node.NodeName!="Version")
			return m("Please Select A Version")
		All:=SN(Version_Tracker.GetNode("ancestor::info"),"descendant::info"),Actions:={"":1},Users:={"":1},Type:={"":1},Issues:={"":1}
		while(aa:=All.Item[A_Index-1],ea:=XML.EA(aa))
			Actions[ea.Action]:=1,Users[ea.User]:=1,Type[ea.Type]:=1,Issues[ea.Issue]:=1
		AddWin:=new GUIKeep("AddWin")
		AddWin.Add("ListView,w300 h200 vType -Multi,Type (Added Removed Changed Etc)","ListView,x+M w300 h200 vAction -Multi,Action (Requested Reported Etc)","ListView,x+M w300 h200 vUser -Multi,User (If Action Is Set)","ListView,x+M w300 h200 vIssue -Multi,Issue #"
			,"Edit,xm w300 vEdit1","Edit,x+M w300 vEdit2","Edit,x+M w300 vEdit3","Edit,x+M w300 vEdit4","Button,xm gVersionHelp,&Help"),AddWin.Show("Add Action")
		ControlGetPos,x,y,w,h,SysListView324,% AddWin.ID
		if(v.Options.Add_Margins_To_Windows){
			ControlGetPos,x1,,,,SysListView321,% AddWin.ID
			GuiControl,AddWin:Move,Button1,% "w" x+w-x1
		}else
			GuiControl,AddWin:Move,Button1,% "w" x+w-3
		AddWin.Hotkeys({Enter:"AddWinEnter",Delete:"AddWinDelete","!t":"VersionSelect","!a":"VersionSelect","!u":"VersionSelect","!i":"VersionSelect"})
		for c,d in {Type:Type,Action:Actions,User:Users,Issue:Issues}{
			AddWin.Default(c),Match:=Select:=""
			if(EditNode)
				Match:=SSN(EditNode,"@" Format("{:L}",c)).text
			for a in d
				Index:=LV_Add((Match=a?"Select Vis Focus":""),a),Select:=(Match=a?Index:Select)
			LV_Modify((Select?Select:1),"Select Vis Focus"),Select:=""
		}if(EditNode)
			if(!Node:=SSN(EditNode,"ancestor::info/descendant::*[@action!='' or @issue!='' or @type!='' or @user!='']"))
				ControlFocus,Edit1,% AddWin.ID
		return
		VersionHelp:
		m("Alt+T/A/U/I will focus on the items below their ListViews")
		return
		VersionSelect:
		static Order:={"!t":1,"!a":2,"!u":3,"!i":4}
		ControlFocus,% "Edit" Order[A_ThisHotkey],% AddWin.ID
		return
		AddWinEnter:
		NewWin.Default("VT"),Node:=Version_Tracker.GetNode(1)
		if(Node.NodeName!="Version")
			return m("Please Select A Version")
		Info:=[],Values:=AddWin[]
		for a,b in ["type","action","user","issue"]{
			Gui,AddWin:Default
			Gui,AddWin:ListView,% "SysListView32" A_Index
			Value:=Info[b]:=Values["Edit" A_Index]
			if(!Info[b])
				LV_GetText(Value,LV_GetNext())Info[b]:=Value
			else if(!Info[b]&&A_Index=1)
				return m("Please Select or Enter an Entry Type")
			else if(!Info.User&&Info.Action&&A_Index=3)
				return m("Please Enter a User who prompted this Action")
			else if(Info.User&&!Info.Action&&A_Index=3)
				return m("Please enter an Action that " Info.User " requested")
			if(A_Index=4)
				Info[b]:=(SubStr(Value,1,1)="#"?Value:"#" Value)
		}if(Info.Issue="#")
			Info.Issue:=""
		WinActivate,% NewWin.ID
		if(EditNode){
			for a,b in Info
				EditNode.SetAttribute(a,b)
			return Version_Tracker.Populate(1),AddWin.Exit(),EditNode:=""
		}
		New:=xx.Under(Node,"info",Info)
		All:=SN(Version_Tracker.GetNode("ancestor::info"),"descendant::*[@select]")
		while(aa:=All.Item[A_Index-1])
			aa.RemoveAttribute("select")
		New.SetAttribute("select",1)
		Version_Tracker.Populate(),AddWin.Exit()
		return
		AddWinEscape:
		AddWinClose:
		HWND({Rem:"AddWin"}),EditNode:=""
		WinActivate,% NewWin.ID
		return
		AddWinDelete:
		ControlGetFocus,Focus,% AddWin.ID
		m(Focus " Is focused, Delete something within it.")
		return
		VerDelete:
		NewWin:=Version_Tracker.NewWin
		ControlGetFocus,Focus,% NewWin.ID
		if(Focus="SysTreeView321"){
			Node:=Version_Tracker.GetNode()
			if(SSN(Node,"@id")){
				Repo:=Version_Tracker.GetNode("ancestor::info/@repo").text
				Res:=m("Tags on GitHub can not be deleted through the API","","","Select:","-Yes to remove the tag from your local version after doing No","-No to go to GitHub and delete the tag","-Cancel to cancel","btn:ync","def:2")
				if(Res="No")
					Run,% "https://github.com/" Settings.SSN("//github/@owner").text "/" Repo "/releases/tag/" SSN(Node,"@name").text
				else if(Res="Yes"){
					if(m("Are you sure? This Can Not Be Undone!","btn:ync","ico:!","def:2")="Yes")
						Next:=Node.NextSibling?Node.NextSibling:Node.PreviousSibling?Node.PreviousSibling:Node.ParentNode,Node.ParentNode.RemoveChild(Node),Version_Tracker.Select(Next)
				}
				return
			}if(Node.NodeName="Branch"){
				if(SSN(Node,"@name").text="master")
					return m("Can not delete the master.")
				if(Repo:=Version_Tracker.GetNode("ancestor::info/@repo").text){
					Res:=m("This Can Not Be Undone!","This will only remove the local branch.","","To remove the cached branch from GitHub you will need to press No and it will take you to Github.com and you can manage your Branches there.","btn:ync","def:3")
					if(Res="No")
						Run,% "https://github.com/" Settings.EA("//github").Owner "/" Repo "/branches"
					else if(Res="Yes"){
						if(m("Are you sure? This Can NOT Be Undone!","btn:ync","def:2")="Yes")
							Next:=Node.NextSibling?Node.NextSibling:Node.PreviousSibling?Node.PreviousSibling:Node.ParentNode,Node.ParentNode.RemoveChild(Node),Version_Tracker.Select(Next)
					}
					return
				}if(m("This can not be undone. Are you sure?","ico:!","btn:ync","def:2")="Yes")
					Next:=Node.NextSibling?Node.NextSibling:Node.PreviousSibling?Node.PreviousSibling:Node.ParentNode,Node.ParentNode.RemoveChild(Node),Version_Tracker.Select(Next)
				return
			}
			if(Node.NodeName~="i)\b(version|info)"=0){
				if(!Node)
					return new Version_Tracker()
				return m("You can only delete Versions or Actions currently")
			}if(m("Are you sure you want to delete this?","btn:ync","def:2")="Yes"){
				Next:=Node.NextSibling?Node.NextSibling:Node.PreviousSibling?Node.PreviousSibling:Node.ParentNode,All:=SN(Version_Tracker.GetNode("ancestor::info"),"descendant::*[@select]")
				while(aa:=All.Item[A_Index-1])
					aa.RemoveAttribute("select")
				Next.SetAttribute("select",1),Node.ParentNode.RemoveChild(Node),Version_Tracker.Populate()
			}
		}else if(Focus="SysListView321"){
			Node:=Version_Tracker.GetNode("ancestor::branch/files")
			Gui,Version:Default
			Rem:=SSN(Node,"*[" LV_GetNext() "]"),Rem.ParentNode.RemoveChild(Rem),Version_Tracker.Populate()
		}else
			Send,{Delete}
		return
	}SetSelected(){
		if(!Root:=Version_Tracker.GetNode("ancestor::info")),NewWin:=Version_Tracker.NewWin,xx:=VVersion
			Root:=xx.Find("//info/@file",Current(2).File)
		Node:=Version_Tracker.GetNode(),All:=SN(Root,"descendant::*[@select]")
		while(aa:=All.Item[A_Index-1])
			aa.RemoveAttribute("select")
		Node.SetAttribute("select",1)
	}Populate(SetCurrent:=0){
		if(!Root:=Version_Tracker.GetNode("ancestor::info")),NewWin:=Version_Tracker.NewWin,xx:=VVersion
			Root:=xx.Find("//info/@file",Current(2).File)
		if(SetCurrent){
			Node:=Version_Tracker.GetNode(),All:=SN(Root,"//Github/descendant::*[@select]|descendant::*[@select]")
			while(aa:=All.Item[A_Index-1])
				aa.RemoveAttribute("select")
			Node.SetAttribute("select",1)
		}GuiControl,Version:-Redraw,SysTreeView321
		NewWin.Default("VT"),TV_Delete(),All:=SN(Root,"descendant::*"),FileRoot:="",LV_Delete()
		while(aa:=All.Item[A_Index-1],ea:=XML.EA(aa)){
			if(SSN(aa,"ancestor-or-self::files"))
				Continue
			if(aa.NodeName="Users")
				Break
			aa.SetAttribute("tv",TV_Add((aa.NodeName~="i)\b(branch|version)\b"?ea.Name:aa.NodeName="info"?(ea.Type?ea.Type (ea.Action?" - " ea.Action " by " ea.User:"")(ea.Issue?" " ea.Issue:""):"(Enter to change this)"):aa.xml),SSN(aa.ParentNode,"@tv").text))
		}for a,b in Settings.EA("//github"){
			if(A_Index=1)
				VVersion.Add("Github").SetAttribute("tv",TVRoot:=TV_Add("Github")),AddRepoName:=1
			VVersion.Add("Github/" a).SetAttribute("tv",TV_Add(Format("{:T}",a) ": " (a!="token"?b:"Entered"),TVRoot,"Vis"))
		}if(AddRepoName){
			VVersion.Add("Github/Repo").SetAttribute("tv",TV_Add("Repository: " SSN(Root,"@repo").text,TVRoot,"Vis"))
		}Instructions:=TV_Add("Instructions")
		for a,b in ["Delete will delete a version","Alt+A Will Add An Action","Enter Will Edit Whatever Is Selected","F1 Will Compile The Current Version/Branch","Alt+N To Create A New Branch"]
			TV_Add(b,Instructions,"Vis")
		All:=xx.SN("//*[@expand]")
		while(aa:=All.Item[A_Index-1],ea:=XML.EA(aa))
			TV_Modify(ea.tv,"Expand")
		if(tv:=SSN(Root,"descendant::*[@select]/@tv|//Github/descendant::*[@select]/@tv").text)
			TV_Modify(tv,"Select Vis Focus")
		GuiControl,Version:+Redraw,SysTreeView321
	}Select(Node){
		Version_Tracker.TVState()
		if(!Root:=Version_Tracker.GetNode("ancestor::info")),NewWin:=Version_Tracker.NewWin,xx:=VVersion
			Root:=xx.Find("//info/@file",Current(2).File)
		All:=SN(Root,"descendant::*[@select]|//Github/descendant::*[@select]")
		while(aa:=All.Item[A_Index-1])
			aa.RemoveAttribute("select")
		Node.SetAttribute("select",1),Version_Tracker.Populate()
	}TVState(){
		Version_Tracker.NewWin.Default("VT"),All:=VVersion.SN("//*[@tv]")
		while(aa:=All.Item[A_Index-1],ea:=XML.EA(aa)){
			if(TV_Get(ea.TV,"Expand"))
				aa.SetAttribute("expand",1)
			else if(ea.Expand)
				aa.RemoveAttribute("expand")
		}
	}
}
VersionDropFiles(FileList,Ctrl,x,y,Object){
	Gui,Version:Default
	Node:=VVersion.SSN("//*[@tv='" TV_GetSelection() "']/ancestor-or-self::branch")
	if(!Node)
		return m("Please Re-Launch this window (Sorry)")
	for a,b in FileList{
		Folder:=SplitPath(RelativePath(Current(2).File,b)).Dir
		if(InStr(Folder,".."))
			Folder:="lib"
		Folder:=RegExReplace(Folder,"\\","/")
		if(!VVersion.Find(Node,"files/file/@file",b)){
			if(!Top:=SSN(Node,"files"))
				Top:=VVersion.Under(Node,"files")
			VVersion.Under(Top,"file",{file:SplitPath(b).FileName,filepath:b,folder:Folder})
	}}Version_Tracker.Populate(1)
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
		WinSetTitle,% HWND([win]),,% (open?"Include Open!  -  ":"") "AHK Studio - " (Current(3).edited?"*":"") (Title.dir "\" (v.Options.Hide_File_Extensions?Title.nne:Title.filename))
	}else if(Title!="AHK Studio"){
		WinSetTitle,% HWND([win]),,%Title%
	}else{
		Info:=Current(3)
		WinSetTitle,% HWND([win]),,% (open?"Include Open!  -  ":"") "AHK Studio - " (Info.edited?"*":"") (Info.dir "\" (v.Options.Hide_File_Extensions?Info.nne:Info.filename))
	}
}
Words_In_Document(NoDisplay:=0,Text:="",Remove:="",AllowLastWord:=0){
	Current:=Current(3),Text:=Update({Get:Current.File}),Words:=Trim(RegExReplace(RegExReplace(RegExReplace(Text,"(\b\d+\b|\b(\w{1,2})\b)"),"x)([^\w])"," "),"\s{2,}"," "))
	sc:=CSC(),CurrentWord:=sc.GetWord()
	if(Text~="i)" CurrentWord "\w+")
		Words:=RegExReplace(Words,"\b" CurrentWord "\b")
	Obj:=v.WordsObj[(Document:=Current.sc)]:=[]
	for a,b in StrSplit(Words," ")
		FirstTwo:=SubStr(b,1,2),Obj[FirstTwo].=(Obj[FirstTwo]?" " b:b)
	if(!NoDisplay){
		Words:=Trim(Words)
		Sort,Words,CUD%A_Space%
		sc.2100(StrLen(sc.GetWord()),Words)
	}
}
Wrap_Word_In_Quotes(){
	sc:=CSC(),sc.2078,CPos:=sc.2008,start:=sc.2266(sc.2008,1),end:=sc.2267(sc.2008,1),sc.2003(start,Chr(34)),sc.2003(end+1,Chr(34)),sc.2025(CPos+1),sc.2079
}
DebugWindow(x*){

}