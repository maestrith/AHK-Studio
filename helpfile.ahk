command_help(){
	static stuff,hwnd
	sc:=csc(),found1:=context(1)
	SplitPath,A_AhkPath,,outdir
	if !found1
		RegExMatch(sc.getline(sc.2166(sc.2008)),"[\s+]?(\w+)",found)
	if InStr(commands.ssn("//Commands/Commands").text,found1){
		if (found1~="(FileExist|GetKeyState|InStr|SubStr|StrLen|StrSplit|WinActive|WinExist|Asc|Chr|GetKeyName|IsByRef|IsFunc|IsLabel|IsObject|NumGet|NumPut|StrGet|StrPut|RegisterCallback|Trim|Abs|Ceil|Exp|Floor|Log|Ln|Mod|Round|Sqrt|Sin|ASin|ACos|ATan)"){
			url:="mk:@MSITStore:" outdir "/AutoHotkey.chm::/docs/Functions.htm#" found1
		}Else{
			url:="mk:@MSITStore:" outdir "/AutoHotkey.chm::/docs/commands/" found1:=RegExReplace(found1,"#","_") ".htm"
			if InStr(stuff.document.body.innerhtml,"//ieframe.dll/dnserrordiagoff.htm#"){
				url:="mk:@MSITStore:" outdir "/AutoHotkey.chm::/docs/Functions.htm#" found1
				if (found1="object")
					url:="mk:@MSITStore:" outdir "/AutoHotkey.chm::/docs/Objects.htm#Usage_Associative_Arrays"
				Else if (found1="_ltrim")
					url:="mk:@MSITStore:" outdir "/AutoHotkey.chm::/docs/Scripts.htm#LTrim"
				Else
					url:="mk:@MSITStore:" outdir "/AutoHotkey.chm::/docs/Functions.htm#" found1
			}
		}
		if !help:=GetWebBrowser(){
			Run,hh.exe %url%
			return
		}
		help.navigate(url)
		WinActivate,AutoHotkey Help
	}
	return
}