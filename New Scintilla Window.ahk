New_Scintilla_Window(file=""){
	sc:=csc(),getpos(),doc:=sc.2357,sc:=new s(1,{main:1,hide:1}),csc({hwnd:sc.sc})
	if file{
		newdoc:=files.ssn("//file[@file='" file "']")
		if tv:=ssn(newdoc,"@tv").text
			tv(tv,file)
	}else
		sc.2358(0,doc)
	sc.2400(),sc.show(),setpos(current(3).sc),resize("redraw")
}