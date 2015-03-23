#SingleInstance,Off
;download complete
/*
	TODO LIST:
	Make a plugin downloader
	-Current Segment, Current Project, All Files
	bkid{
		Scratch Pad is blinky on resize
	}
	samardac{
		Rename include files from within Studio
	}
	tidy up script:
	Toolbars
	-Make it work on xml natively
	-Add the ability to add more toolbars.
	hotkey for adding selected words to a word list for the program
	-make windows show up inititally inside of the main window. centered.
	Change the version script to add tags for <changed> and <fixed> and so on.
	windows_to_replace{
		Themes
		Code Vault
		Split Code
		Scratch Pad
	}
	video{
		Omni-Search (Files,Menu items,...etc)
		Multiple Segments (discuss how segments work and show them)
		Quick Find
	}
	hoppfrosch{
		changing #includes manually causes issues with the file explorer
		-Create a "Refresh Project Explorer" option.
	}
	Don_Corleon{
		Multiple Scintilla windows over/under rather than side by side.
	}
	Suggested_by_bgm{
		Code_Vault{
			Add an area for comments for snippets
		}
	}
*/
DetectHiddenWindows,On
file=%1%
ComObjError(0),openfile:=file
if x:=ComObjActive("AHK-Studio"){
	x.open(file),x.scanfiles(),x.activate()
	ExitApp
}
ComObjError(1)
SetWorkingDir,%A_ScriptDir%
global v:=[],settings,files,menus,commands,positions,vversion,access_token,vault,preset,cexp,scintilla,bookmarks,cexml
settings:=new xml("settings","lib\settings.xml"),files:=new xml("files"),menus:=new xml("menus","lib\menus.xml"),commands:=new xml("commands","lib\commands.xml"),cexp:=new xml("code_explorer"),bookmarks:=new xml("bookmarks","lib\bookmarks.xml")
positions:=new xml("positions","lib\positions.xml"),vversion:=new xml("version","lib\version.xml"),access_token:=settings.ssn("//access_token").text
cexml:=new xml("code_explorer"),v.filescan:=[]
if !settings.ssn("//Auto_Indent")
	settings.Add2("Auto_Indent",{Full_Auto:1})
vault:=new xml("vault","lib\vault.xml"),v.color:=[],preset:=new xml("preset","lib\preset.xml")
if (A_PtrSize=8&&A_IsCompiled=""){
	SplitPath,A_AhkPath,,dir
	if !FileExist(correct:=dir "\AutoHotkeyU32.exe"){
		m("Requires AutoHotkey 1.1 to run")
		ExitApp
	}
	run,"%correct%" "%A_ScriptName%",%A_ScriptDir%
	ExitApp
	return
}
filecheck(),v.quick:=[]
Menu,Tray,Icon,AHKStudio.ico
keywords(),plugins(),gui(),ObjRegisterActive(pluginclass)
if(openfile){
	v.openfile:=openfile
	if !files.ssn("//*[@file='" openfile "']")
		open(openfile,1)
	SetTimer,selectfile,-200
}
return
selectfile:
tv(files.ssn("//*[@file='" v.openfile "']/@tv").text)
return
GuiDropFiles:
v.wait:=1
open(A_GuiEvent,1),openfile:=StrSplit(A_GuiEvent,"`n").1,main:=files.ssn("//main[@file='" openfile "']")
while,(v.wait)
	Sleep,20
tv(ssn(main.firstchild,"@tv").text)
return
#Include %A_ScriptDir%
#Include about.ahk
#Include add bookmark.ahk
#Include Add Function Call.ahk
#Include Add Selected To Personal Variables.ahk
#Include Add Spaces After Commas.ahk
#Include add spaces before and after commas.ahk
#Include Add Spaces Before Commas.ahk
#Include addbutton.ahk
#Include arrows.ahk
#Include auto insert.ahk
#Include Auto_Update.ahk
#Include automenu.ahk
#Include Back.ahk
#Include brace.ahk
#Include bracesetup.ahk
#Include case settings.ahk
#Include center.ahk
#Include cgp.ahk
#Include changehotkey.ahk
#Include Check For Update.ahk
#Include check id.ahk
#Include Class Code Explorer.ahk
#Include class ftp.ahk
#Include class github.ahk
#Include class icon browser.ahk
#Include Class Omni_search_class.ahk
#Include Class PluginClass.ahk
#Include class rebar.ahk
#Include class s.ahk
#Include class search.ahk
#Include class toolbar.ahk
#Include class versionkeep.ahk
#Include class windowtracker.ahk
#Include class xml.ahk
#Include clean.ahk
#Include Clear Line Status.ahk
#Include close.ahk
#Include Code Vault.ahk
#Include color.ahk
#Include commit.ahk
#Include Compare.ahk
#Include compile main gist.ahk
#Include compile.ahk
#Include compilebox.ahk
#Include connect.ahk
#Include context.ahk
#Include convert hotkey.ahk
#Include copy.ahk
#Include create launcher.ahk
#Include Create Segment From Selection.ahk
#Include csc.ahk
#Include current.ahk
#Include cut.ahk
#Include deadend.ahk
#Include Debug Current Script.ahk
#Include debug settings.ahk
#Include debug.ahk
#Include Default Project Folder.ahk
#Include Default.ahk
#Include defaultfont.ahk
#Include Delete Bookmark.ahk
#Include delete matching brace.ahk
#Include detach.ahk
#Include display.ahk
#Include Dlg Color.ahk
#Include Dlg Font.ahk
#Include Donate.ahk
#Include Duplicate Line.ahk
#Include duplicates.ahk
#Include dupsel.ahk
#Include DynaRun.ahk
#Include edit replacements.ahk
#Include eol.ahk
#Include exit.ahk
#Include Export.ahk
#Include extract.ahk
#Include FEAdd.ahk
#Include file search.ahk
#Include filecheck.ahk
#Include Find Nearest Brace.ahk
#Include find.ahk
#Include Find_Replace.ahk
#Include fix after.ahk
#Include fix indent.ahk
#Include focus.ahk
#Include fold.ahk
#Include Forward.ahk
#Include ftp servers.ahk
#Include full backup.ahk
#Include function search.ahk
#Include get access.ahk
#Include Get_Include.ahk
#Include getpos.ahk
#Include GetWebBrowser.ahk
#Include Github Repository.ahk
#Include global.ahk
#Include Go To Line.ahk
#Include google search selected.ahk
#Include Goto.ahk
#Include gui.ahk
#Include help.ahk
#Include helpfile.ahk
#Include Highlight to Matching Brace.ahk
#Include History.ahk
#Include hk.ahk
#Include hltline.ahk
#Include Hotkey Search.ahk
#Include hotkeys.ahk
#Include hwnd.ahk
#Include inputbox.ahk
#Include Insert Code Vault.ahk
#Include json.ahk
#Include Jump To Next Bookmark.ahk
#Include jump to project.ahk
#Include Jump to Segment.ahk
#Include Jump To.ahk
#Include keywords.ahk
#Include lastfiles.ahk
#Include listvars.ahk
#Include local.ahk
#Include LV Select.ahk
#Include m.ahk
#Include Manage Bookmarks.ahk
#Include marginwidth.ahk
#Include menu editor.ahk
#Include menu search.ahk
#Include menu.ahk
#Include Menu_Editor_Icon.ahk
#Include Method Search.ahk
#Include move selected lines down.ahk
#Include move selected lines up.ahk
#Include Msgbox Creator.ahk
#Include multisel.ahk
#Include New File Template.ahk
#Include New Scintilla Window.ahk
#Include new segment.ahk
#Include new.ahk
#Include NewFile.ahk
#Include Next Found.ahk
#Include next-prev file.ahk
#Include notify.ahk
#Include omni search.ahk
#Include open folder.ahk
#Include open.ahk
#Include options.ahk
#Include paste.ahk
#Include Personal Variable List.ahk
#Include Plugins.ahk
#Include popftp.ahk
#Include posinfo.ahk
#Include post all in one gist.ahk
#Include Post Multiple Segment Gist.ahk
#Include previous found.ahk
#Include Previous Scripts.ahk
#Include ProjectFolder.ahk
#Include Proxy Settings.ahk
#Include publish.ahk
#Include qf.ahk
#Include Quick Scintilla Code Lookup.ahk
#Include redo.ahk
#Include Refresh Code Explorer.ahk
#Include Refresh Variable List.ahk
#Include refresh.ahk
#Include refreshthemes.ahk
#Include RegisterIDs.ahk
#Include RegisterObject.ahk
#Include Relative Path.ahk
#Include Remove Current Selection.ahk
#Include Remove Scintilla Window.ahk
#Include Remove Segment.ahk
#Include Remove Spaces From Selected.ahk
#Include replace selected.ahk
#Include replace.ahk
#Include Reset Zoom.ahk
#Include resize.ahk
#Include restore current file.ahk
#Include rgb.ahk
#Include Run As.ahk
#Include Run Comment Block.ahk
#Include run program.ahk
#Include run selected text.ahk
#Include run.ahk
#Include runfile.ahk
#Include runit.ahk
#Include Save As.ahk
#Include save.ahk
#Include savegui.ahk
#Include scintilla code lookup.ahk
#Include scintilla.ahk
#Include Scratch Pad.ahk
#Include ScrollWheel.ahk
#Include Search Label.ahk
#Include Select Next Duplicate.ahk
#Include selectall.ahk
#Include set as default editor.ahk
#Include set.ahk
#Include setpos.ahk
#Include setup.ahk
#Include show scintilla code in line.ahk
#Include show.ahk
#Include sn.ahk
#Include social.ahk
#Include SocketEvent.ahk
#Include Sort Selected.ahk
#Include split code.ahk
#Include ssn.ahk
#Include Step Over.ahk
#Include step.ahk
#Include stop.ahk
#Include striperror.ahk
#Include t.ahk
#Include Tab To Next Comma.ahk
#Include Tab To Previous Comma.ahk
#Include tab width.ahk
#Include testing.ahk
#Include Theme.ahk
#Include themetext.ahk
#Include toggle comment line.ahk
#Include Toggle Multiple Line Comment.ahk
#Include togglemenu.ahk
#Include traymenu.ahk
#Include tv.ahk
#Include ubp.ahk
#Include undo.ahk
#Include update github info.ahk
#Include update.ahk
#Include upload.ahk
#Include Upper.ahk
#Include uppos.ahk
#Include URLDownloadToVar.ahk
#Include varbrowser.ahk
#Include Widths.ahk
#Include window.ahk
#Include Words In Document.ahk