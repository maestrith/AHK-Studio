class versionkeep{
	__New(){
		if !node:=vversion.ssn("//info[@file='" ssn(current(1),"@file").text "']")
			node:=vversion.Add2("info",{file:ssn(current(1),"@file").text},"",1)
		if !versions:=ssn(node,"versions"){
			if !FileExist("lib\version backup.xml")
				FileCopy,lib\version.xml,lib\version backup.xml,1
			info:=node.text,node.text:=""
			versions:=vversion.under(node,"versions"),vn:="",top:=""
			for a,b in StrSplit(info,"`n","`r`n"){
				if !RegExReplace(b,"(\d|\.)"){
					vn:=b
					top:=vversion.under(versions,"version",{number:b})
				}else{
					if !top
						top:=vversion.under(versions,"version",{number:"1.0"})
					top.text:=top.text "`r`n" b
				}
			}
		}
		if inc:=ssn(node,"@increment").text{
			ControlSetText,Edit1,% ssn(node,"@version").text "." inc,A
			node.removeattribute("increment")
		}
		this.node:=node
		return this
	}
	List(){
		node:=vversion.ssn("//info[@file='" ssn(current(1),"@file").text "']")
		return sn(node,"versions/*")
	}
	settext(cv,text){
		if !node:=vversion.ssn("//info[@file='" ssn(current(1),"@file").text "']/versions/version[@number='" cv "']")
			node:=this.Add(cv),ret:="update"
		node.text:=text
		return ret
	}
	Add(vers){
		node:=this.node
		if ssn(node,"versions/version[@number='" vers "']")
			return node
		cv:=RegExReplace(vers,"(\.|\D)"),list:=sn(node,"versions/version")
		root:=ssn(node,"versions"),node:=vversion.under(root,"version",{number:vers})
		while,ll:=list.item[A_Index-1]{
			vv:=RegExReplace(ssn(ll,"@number").Text,"(\.|\D)")
			if (cv>vv){
				root.insertbefore(node,ll)
				Break
			}
		}
		return node
	}
	getver(ver){
		text:=vversion.ssn("//info[@file='" ssn(current(1),"@file").text "']/versions/version[@number='" ver "']").text
		return RegExReplace(text,"\n","`r`n") _:=text?"`r`n":""
	}
	updown(win,control,direction){
		Gui,%win%:Default
		ControlGetText,start,%control%,% hwnd([win])
		ControlGetFocus,Focus,% hwnd([win])
		RegExMatch(start,"^(.*\D)?(\d*)$",ver)
		add:=InStr(direction,"up")?1:InStr(direction,"down")?-1:0
		start:=ver1 ver2+add
		ControlSetText,%control%,%start%,% hwnd([win])
		return start
	}
}