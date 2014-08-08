getpos(){
	if !current(1).xml
		return
	code_explorer.scan(ssn(current(),"@file").text)
	sc:=csc(),current:=current(1)
	fix:=positions.unique({path:"main",att:{file:ssn(current,"@file").text},check:"file"})
	fix:=positions.unique({under:fix,path:"file",att:{start:sc.2008,end:sc.2009,scroll:sc.2152,file:ssn(current(),"@file").text},check:"file"})
	fold:=0,ff:=0,fix.removeattribute("fold")
	while,sc.2618(fold)>=0,fold:=sc.2618(fold)
		list.=fold ",",fold++
	if list
		fix.SetAttribute("fold",Trim(list,","))
	mark:=0,fix.removeattribute("breakpoint"),bpl:=""
	while,sc.2047(mark,1)>=0,mark:=sc.2047(mark,1)
		bpl.=mark ",",mark++
	if bpl
		fix.SetAttribute("breakpoint",Trim(bpl,","))
}