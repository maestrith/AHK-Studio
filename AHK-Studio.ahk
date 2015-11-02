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
global v:=[],settings:=new xml("settings","lib\Settings.xml"),files:=new xml("files"),menus,commands:=new xml("commands","lib\commands.xml"),positions:=new xml("positions","lib\positions.xml"),vversion,access_token,vault:=new xml("vault","lib\Vault.xml"),preset,scintilla,bookmarks,cexml:=new xml("code_explorer"),notesxml,language:=new xml("language","lib\en-us.xml"),vversion:=new xml("version","lib\version.xml"),Custom_Commands:=new XML("custom","lib\Custom Commands.xml")
scintilla:=new xml("scintilla","lib\scintilla.xml"),v.pluginversion:=1,menus:=new xml("menus","lib\menus.xml"),FileCheck(file)
if(FileExist("AHKStudio.ico"))
	Menu,Tray,Icon,AHKStudio.ico
new omni_search_class(),v.filelist:=[],v.options:=[],var(),keywords(),Gui(),v.match:={"{":"}","[":"]","<":">","(":")",Chr(34):Chr(34),"'":"'","%":"%"},v.filescan:=[]
ObjRegisterActive(pluginclass),preset:=new xml("preset","lib\preset.xml")
SetWorkingDir,%A_ScriptDir%
ea:=settings.ea("//options")
for a,b in ea
	v.options[a]:=b
v.options.full_auto:=settings.ssn("//Auto_Indent/@Full_Auto").text
return
SetTimer,Color
GuiDropFiles:
tv:=open(A_GuiEvent,1),openfile:=StrSplit(A_GuiEvent,"`n").1,main:=files.ssn("//main[@file='" openfile "']"),tv(tv)
return
selectfile:
tv(files.ssn("//*[@file='" v.openfile "']/@tv").text)
return
#Include %A_ScriptDir%
#Include About.ahk
#Include Activate.ahk
#Include AutoMenu.ahk
#Include BookEnd.ahk
#Include Brace.ahk
#Include BraceSetup.ahk
#Include Center.ahk
#Include CenterSel.ahk
#Include Check For Edited.ahk
#Include Class Code Explorer.ahk
#Include Class FTP.ahk
#Include Class Icon Browser.ahk
#Include Class Omni Search.ahk
#Include Class PluginClass.ahk
#Include Class Rebar.ahk
#Include Class Scintilla.ahk
#Include Class Toolbar.ahk
#Include Class XML.ahk
#Include Clean.ahk
#Include Clear Line Status.ahk
#Include Close.ahk
#Include Color.ahk
#Include Command Help.ahk
#Include Compile.ahk
#Include CompileFont.ahk
#Include Connect.ahk
#Include Context.ahk
#Include ContextMenu.ahk
#Include Convert Hotkey.ahk
#Include Copy.ahk
#Include CSC.ahk
#Include Current.ahk
#Include Debug Settings.ahk
#Include Default.ahk
#Include DefaultFont.ahk
#Include Delete Matching Brace.ahk
#Include Delete Project.ahk
#Include Display Functions.ahk
#Include Donate.ahk
#Include Download Plugins.ahk
#Include Duplicate Line.ahk
#Include Duplicates.ahk
#Include DynaRun.ahk
#Include Edit Replacements.ahk
#Include Encode.ahk
#Include Escape.ahk
#Include ExecScript.ahk
#Include Exit.ahk
#Include Export.ahk
#Include Extract.ahk
#Include FEAdd.ahk
#Include FileCheck.ahk
#Include Find Replace.ahk
#Include Find.ahk
#Include Fix Indent.ahk
#Include Fix Next.ahk
#Include Full Backup.ahk
#Include GetBrowser.ahk
#Include GetInclude.ahk
#Include GetPos.ahk
#Include Go To Line.ahk
#Include Google Search Selected.ahk
#Include Goto.ahk
#Include Gui.ahk
#Include GUIKeep.ahk
#Include Highlight To Matching Brace.ahk
#Include History.ahk
#Include HK.ahk
#Include HltLine.ahk
#Include Hotkeys.ahk
#Include HWND.ahk
#Include Index Current File.ahk
#Include Index Lib Files.ahk
#Include InputBox.ahk
#Include Insert Code Vault.ahk
#Include Jump To Segment.ahk
#Include Jump To.ahk
#Include Keywords.ahk
#Include LastFiles.ahk
#Include LButton.ahk
#Include ListVars.ahk
#Include LV Select.ahk
#Include Margin Left.ahk
#Include Margin Width.ahk
#Include Menu.ahk
#Include MenuWipe.ahk
#Include Move Selected Lines Down.ahk
#Include Move Selected Lines Up.ahk
#Include MsgBox.ahk
#Include New Caret.ahk
#Include New File Template.ahk
#Include New Scintilla Window.ahk
#Include New Segment.ahk
#Include New.ahk
#Include Next File.ahk
#Include Next Found.ahk
#Include Notes.ahk
#Include Notify.ahk
#Include ObjRegisterActive.ahk
#Include Omni Search.ahk
#Include One Backup.ahk
#Include Open Folder.ahk
#Include Open.ahk
#Include Options.ahk
#Include Paste.ahk
#Include PERefresh.ahk
#Include Personal Variable List.ahk
#Include Plugins.ahk
#Include PosInfo.ahk
#Include Previous File.ahk
#Include Previous Found.ahk
#Include Previous Scripts.ahk
#Include Project Folder.ahk
#Include Publish.ahk
#Include QF.ahk
#Include QFS.ahk
#Include Refresh Current Project.ahk
#Include Refresh Plugins.ahk
#Include Refresh Project Explorer.ahk
#Include Refresh Project Treeview.ahk
#Include Refresh.ahk
#Include RefreshThemes.ahk
#Include RegisterID.ahk
#Include RelativePath.ahk
#Include Remove Current Selection.ahk
#Include Remove Scintilla Window.ahk
#Include Remove Segment.ahk
#Include Rename Current Segment.ahk
#Include Replace Selected.ahk
#Include Replace.ahk
#Include Reset Zoom.ahk
#Include Resize.ahk
#Include RGB.ahk
#Include Run Program.ahk
#Include Run.ahk
#Include RunFile.ahk
#Include RunFunc.ahk
#Include Save As.ahk
#Include Save.ahk
#Include SaveGUI.ahk
#Include Scratch Pad.ahk
#Include ScrollWheel.ahk
#Include Search Label.ahk
#Include Search.ahk
#Include Segment From Selection.ahk
#Include Select Current Word.ahk
#Include Select Next Duplicate.ahk
#Include SelectAll.ahk
#Include Set As Default Editor.ahk
#Include Set.ahk
#Include SetMatch.ahk
#Include SetPos.ahk
#Include SetStatus.ahk
#Include Setup.ahk
#Include Show Class Methods.ahk
#Include Show Scintilla Code In Line.ahk
#Include ShowLabels.ahk
#Include Stop.ahk
#Include Test Plugin.ahk
#Include Testing.ahk
#Include Toggle Comment Line.ahk
#Include Toggle Menu.ahk
#Include Toggle Multiple Line Comment.ahk
#Include TV.ahk
#Include TVIcons.ahk
#Include Update.ahk
#Include Upper.ahk
#Include UpPos.ahk
#Include UrlDownloadToVar.ahk
#Include var.ahk
#Include Widths.ahk
#Include WinPos.ahk
#Include Words In Document.ahk
;plugin
#Include Quick Scintilla Code Lookup.ahk
#Include Scintilla Code Lookup.ahk
#Include Scintilla.ahk
;/plugin