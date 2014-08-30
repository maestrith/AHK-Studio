class versionkeep{
	__New(){
		if !node:=vversion.ssn("//info[@file='" ssn(current(1),"@file").text "']")
			node:=vversion.Add({path:"info",att:{file:ssn(current(1),"@file").text},dup:1})
		if !versions:=ssn(node,"versions"){
			if !FileExist("lib\version backup.xml")
				FileCopy,lib\version.xml,lib\version backup.xml,1
			info:=node.text,node.text:=""
			versions:=vversion.under({under:node,node:"versions"}),vn:="",top:=""
			for a,b in StrSplit(info,"`n","`r`n"){
				if !RegExReplace(b,"(\d|\.)"){
					vn:=b
					top:=vversion.under({under:versions,node:"version",att:{number:b}})
				}else{
					if !top
						top:=vversion.under({under:versions,node:"version",att:{number:"1.0"}})
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
		node:=vversion.ssn("//info[@file='" ssn(current(1),"@file").text "']/versions/version[@number='" cv "']")
		node.text:=text
	}
	Add(vers){
		node:=this.node
		if ssn(node,"versions/version[@number='" vers "']")
			return 0
		cv:=RegExReplace(vers,"(\.|\D)"),list:=sn(node,"versions/version")
		if ssn(node,"versions/version[@number='" vers "']")
			Return
		root:=ssn(node,"versions"),new:=vversion.under({under:root,node:"version",att:{number:vers}})
		while,ll:=list.item[A_Index-1]{
			vv:=RegExReplace(ssn(ll,"@number").Text,"(\.|\D)")
			if (cv>vv){
				root.insertbefore(new,ll)
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
		if (focus!=control){
			ControlSend,%Focus%,{%A_ThisHotkey%},% hwnd([win])
			Exit
		}
		RegExMatch(start,"^(.*\D)?(\d*)$",ver)
		add:=InStr(direction,"up")?1:InStr(direction,"down")?-1:0
		start:=ver1 ver2+add
		ControlSetText,%control%,%start%,% hwnd([win])
		return start
	}
}