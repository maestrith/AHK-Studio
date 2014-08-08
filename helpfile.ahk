command_help(){
	static stuff,hwnd
	sc:=csc(),found1:=context(1)
	if !found1
		RegExMatch(sc.getline(sc.2166(sc.2008)),"[\s+]?(\w+)",found)
	if InStr(commands.ssn("//Commands/Commands").text,found1){
		SplitPath,A_AhkPath,,outdir
		WinGetPos,x,y,w,h,% hwnd([1])
		Gui,45:Destroy
		Gui,45:+Resize -Caption +hwndmain
		Gui,45:Add,ActiveX,% "w" w-20 " h" h-40 " vstuff hwndhwnd",explorer
		WinGet,max,MinMax,% hwnd([1])
		Gui,45:show,% Resize("get")
		if max
			WinMaximize,ahk_id%main%
		if (found1~="(FileExist|GetKeyState|InStr|SubStr|StrLen|StrSplit|WinActive|WinExist|Asc|Chr|GetKeyName|IsByRef|IsFunc|IsLabel|IsObject|NumGet|NumPut|StrGet|StrPut|RegisterCallback|Trim|Abs|Ceil|Exp|Floor|Log|Ln|Mod|Round|Sqrt|Sin|ASin|ACos|ATan)"){
			url:="mk:@MSITStore:" outdir "/AutoHotkey.chm::/docs/Functions.htm#" found1
			stuff.navigate(url)
		}Else{
			url:="mk:@MSITStore:" outdir "/AutoHotkey.chm::/docs/commands/" found1:=RegExReplace(found1,"#","_") ".htm"
			stuff.navigate(url)
			if InStr(stuff.document.body.innerhtml,"//ieframe.dll/dnserrordiagoff.htm#"){
				url:="mk:@MSITStore:" outdir "/AutoHotkey.chm::/docs/Functions.htm#" found1
				if (found1="object")
					url:="mk:@MSITStore:" outdir "/AutoHotkey.chm::/docs/Objects.htm#Usage_Associative_Arrays"
				Else if (found1="_ltrim")
					url:="mk:@MSITStore:" outdir "/AutoHotkey.chm::/docs/Scripts.htm#LTrim"
				Else
					url:="mk:@MSITStore:" outdir "/AutoHotkey.chm::/docs/Functions.htm#" found1
				stuff.navigate(url)
			}
		}
	}
	ControlFocus,Internet Explorer_Server1,% hwnd([45])
	return
	45GuiEscape:
	Gui,45:Destroy
	Return
	45GuiSize:
	WinMove,ahk_id%hwnd%,,0,0,% A_GuiWidth,% A_GuiHeight-4
	Return
}