getpos(){
	if !current(1).xml
		return
	sc:=csc(),current:=current(2).file,code_explorer.scan(current()),cf:=current(3).file
	if(!top:=positions.ssn("//main[@file='" current "']"))
		top:=positions.add("main",{file:current},,1)
	if(!fix:=ssn(top,"descendant::file[@file='" cf "']"))
		fix:=settings.under(top,"file",{file:cf})
	for a,b in {start:sc.2008,end:sc.2009,scroll:sc.2152,file:ssn(current(),"@file").text}
		fix.SetAttribute(a,b)
	fold:=0,ff:=0,fix.removeattribute("fold")
	while,sc.2618(fold)>=0,fold:=sc.2618(fold)
		list.=fold ",",fold++
	if(list)
		fix.SetAttribute("fold",Trim(list,","))
	pos:=positions.ssn("//main[@file='" current(2).file "']/file[@file='" current(3).file "']"),line:=0,bp:=""
	while,sc.2047(line,1)>=0,line:=sc.2047(line,1)
		bp.=line ",",line++
	if(bp:=Trim(bp,","))
		pos.SetAttribute("breakpoint",bp)
	else
		pos.RemoveAttribute("breakpoint")
}