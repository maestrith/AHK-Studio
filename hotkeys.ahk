hotkeys(win,item=""){
	for a,b in item{
		key:=a,label:=clean(b)
		if IsFunc(label)
			launch:="function"
		if IsLabel(label)
			launch:=clean(label)
		if !(launch&&key)
			return
		for a,b in win{
			Hotkey,IfWinActive,% hwnd([b])
			Hotkey,%key%,%launch%,On
		}
	}
	Hotkey,IfWinActive
	return
	hotkey:
	ControlFocus,Edit1,% hwnd([1])
	return
	function:
	key:=menus.ssn("//*[@hotkey='" A_ThisHotkey "']")
	func:=clean(ssn(key,"@name").text)
	%func%()
	return
}