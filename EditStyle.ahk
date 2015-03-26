EditStyle(stylenumber){
	if !style:=settings.ssn("//fonts/font[@style='" stylenumber "']")
		style:=settings.add({path:"fonts/font",att:{style:stylenumber},dup:1})
	ea:=xml.ea(style)
	def:=settings.ea("//fonts/font[@style='5']")
	for a,b in ea
		def[a]:=b
	dlg_font(def,1,hwnd(1))
	for a,b in def
		style.SetAttribute(a,b)
}