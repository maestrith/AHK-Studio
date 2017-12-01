#SingleInstance,Off
#MaxHotkeysPerInterval,2000
#NoEnv
SetBatchLines,-1
SetWorkingDir,%A_ScriptDir%
SetControlDelay,-1
SetWinDelay,-1
DetectHiddenWindows,On
CoordMode,ToolTip,Screen
global v:=[],MainWin,Settings:=new XML("settings","lib\Settings.xml"),Positions:=new XML("positions","lib\Positions.xml"),cexml:=new XML("cexml","Lib\CEXML.xml"),History:=new XML("HistoryXML"),vversion,scintilla,TVC:=new EasyView(),RCMXML:=new XML("RCM","lib\RCM.xml"),TNotes,DebugWin,Selection:=new SelectionClass(),Menus,Vault:=new XML("vault","lib\Vault.xml")
v.WordsObj:=[],v.Tick:=A_TickCount,new ScanFile(),VVersion:=new XML("versions",(FileExist("lib\Github.xml")?"lib\Github.xml":"lib\Versions.xml")),History("Startup")
if(!settings[]){
	Run,lib\Settings.xml
	m("Oh boy...check the settings file to see what's up.")
}v.LineEdited:=[],v.LinesEdited:=[],v.RunObject,ComObjError(0),new Keywords(),FileCheck(%True%),Options("startup"),Menus:=new XML("menus","Lib\Menus.xml"),Gui(),DefaultRCM(),CheckLayout()
SetTimer("AllID",-100),Allowed()
return
AllID:
All:=cexml.SN("//*[@id]")
while(aa:=All.Item[A_Index-1],ea:=XML.EA(aa))
	aa.SetAttribute("id",A_Index)
GetID(1)
return
/*
	if((Folder:=Settings.SSN("//DefaultFolder")).text)
		Folder.SetAttribute("folder",Folder.text),Folder.text:=""
*/
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
 	Add in #Include brings up a list of items in your library
	Debugging Joe Glines{
		have the option to have the Variable browser dockable to the side of debug window.
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
		needs fixed, when changing things from auto-indent to another area it didn't save
	}
	MISC NOT WORKING:
	Joe_Glines{
		Check Edited Files On Focus:
		have it so that it asks first to replace the text rather than automatically
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





















































































































































































































































































































DebugWindow(Text,Clear:=0,LineBreak:=0,Sleep:=0,AutoHide:=0,MsgBox:=0){
	x:=ComObjActive("{DBD5A90A-A85C-11E4-B0C7-43449580656B}"),x.DebugWindow(Text,Clear,LineBreak,Sleep,AutoHide,MsgBox)
}