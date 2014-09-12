getpos(){
	if !current(1).xml
		return
	sc:=csc(),current:=current(1)
	code_explorer.scan(current())
	fix:=positions.unique({path:"main",att:{file:ssn(current,"@file").text},check:"file"})
	fix:=positions.unique({under:fix,path:"file",att:{start:sc.2008,end:sc.2009,scroll:sc.2152,file:ssn(current(),"@file").text},check:"file"})
	fold:=0,ff:=0,fix.removeattribute("fold")
	while,sc.2618(fold)>=0,fold:=sc.2618(fold)
		list.=fold ",",fold++
	if list
		fix.SetAttribute("fold",Trim(list,","))
}