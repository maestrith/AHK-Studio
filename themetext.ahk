themetext(theme=1){
	if name:=settings.ssn("//fonts/name").text
		header:=name "`r`n`r`n"
	if author:=settings.ssn("//fonts/author").text
		header.="Theme by " author "`r`n`r`n"
	out=%header%/*`r`nMulti-Line`r`ncomments`r`n*/`r`n`r`nSelect the text to change the colors`nThis is a sample of normal text`n`"incomplete quote`n"complete quote"`n`;comment`n0123456789`n()[]^&*()+~#\/!`,{`}``b``a``c``k``t``i``c``k`n
	out.="`nLabel: `;Label Color`nHotkey:: `;Hotkey Color`nFunction() `;Function/Method Color`nabs() `;Built-In Functions`n`n"
	out.="`%variable`% `%variable error`n`n"
	for a,b in v.color
		out.=a " = " b "`n"
	th:=theme=1?settings.sn("//custom/highlight/*"):theme
	while,tt:=th.item(A_Index-1)
		out.="Custom List " ssn(tt,"@list").text " = " tt.text "`n"
	out.="`nLeft Click to edit the fonts color`nControl+Click to edit the font style, size, italic...etc`nAlt+Click to change the Background color`nThis works for the Line Numbers as well"
	return out
}