class versionkeep{
	last:=""
	__New(newwin){
		this.win:=newwin.win
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
		newwin.Add(["Text,,Use Ctrl+Up/Down to increment the version`nDelete when Version Number is selected to remove it`nRight Click to edit version","Text,xs,Versions:","TreeView,w360 h100 guplv AltSubmit,,w","Text,xs,Version Information:","Edit,xm w360 h100 -Wrap gupadd vcm,,wh"])
		hotkeys([newwin.win],{"^up":"uup","^down":"udown","~Delete":"uldel","~Backspace":"uldel",F1:"compilever",F2:"clearver",F3:"wholelist"})
		if(sn(node,"versions/*").length=0)
			top:=ssn(node,"versions"),under:=vversion.under(top,"version",{number:1},"Initial Upload")
		if inc:=ssn(node,"@increment").text
			node.removeattribute("increment")
		this.populate(),this.node:=node,versionkeep.last:=this
		return this
	}
	node(){
		return vversion.ssn("//info[@file='" ssn(current(1),"@file").text "']")
	}
	default(){
		Gui,% this.win ":Default"
		Gui,% this.win ":TreeView",SysTreeView321
	}
	labels(){
		uldel:
		last:=versionkeep.last,last.Default()
		ControlGetFocus,focus,% hwnd([last.win])
		if(Focus="SysListView322"){
			Gui,% last.win ":Default"
			Gui,% last.win ":ListView",SysListView322
			next:=0
			while,next:=LV_GetNext(next)
				LV_GetText(file,next),LV_GetText(dd,next,2),rem:=ssn(last.node,"descendant::file[text()='" dd file "']"),rem.ParentNode.RemoveChild(rem)
			SetTimer,grpop,-100
		}else if(Focus="SysTreeView321")
			last.remver()
		return
		upadd:
		node:=versionkeep.node(),versionkeep.last.Default()
		Gui,%A_Gui%:Default
		TV_GetText(cv,TV_GetSelection())
		ControlGetText,text,Edit1,% hwnd([A_Gui])
		if !cv
			return
		set:=ssn(node,"descendant::*[@number='" cv "']"),set.text:=text
		return
		uplv:
		last:=versionkeep.last,last.Default()
		if(A_GuiEvent="rightclick"){
			MouseClick,Left
			return last.Edit(last.win)
		}
		if A_GuiEvent!=s
			return
		TV_GetText(ver,TV_GetSelection())
		ControlSetText,Edit1,% last.getver(ver),% hwnd([last.win])
		ControlSend,Edit1,^{End},% hwnd([last.win])
		return
		uup:
		udown:
		last:=versionkeep.last,last.Default()
		last.UpDown(last.win,"Edit1",A_ThisLabel)
		return
	}
	remver(){
		Gui,% this.win ":Default"
		node:=vversion.ssn("//info[@file='" current(2).file "']"),TV_GetText(ver,TV_GetSelection()),rem:=ssn(node,"versions/version[@number='" ver "']"),rem.ParentNode.RemoveChild(rem),TV_Delete(TV_GetSelection())
		return
	}
	populate(){
		this.Default()
		GuiControl,% this.win ":-Redraw",SysTreeView321
		list:=versionkeep.list(),TV_Delete(),value:=newwin[].version
		while,ll:=list.item[A_Index-1],ea:=xml.ea(ll)
			tv:=TV_Add(ea.number),tt:=ea.number=value?tv:tt
		GuiControl,% this.win ":+Redraw",SysTreeView321
		TV_Modify(_:=tt?tt:TV_GetChild(0),"Select Vis Focus")
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
		if(nn:=ssn(node,"descendant::version[@number='" vers "']"))
			return nn
		list:=sn(node,"versions/version")
		root:=ssn(node,"versions"),node:=vversion.under(root,"version",{number:vers})
		while,ll:=list.item[A_Index-1],ea:=xml.ea(ll){
			if(vers>ea.number){
				root.insertbefore(node,ll)
				Break
			}
		}
		return node
	}
	Edit(win){
		Gui,%win%:Default
		TV_GetText(num,TV_GetSelection())
		node:=ssn(this.node,"descendant::*[@number='" num "']")
		number:=InputBox(hwnd(win),"Enter A New Version Number","Enter the new version number for this version",num)
		if(ErrorLevel)
			return
		node.SetAttribute("number",number)
		this.populate()
	}
	getver(ver){
		text:=vversion.ssn("//info[@file='" ssn(current(1),"@file").text "']/versions/version[@number='" ver "']").text
		return RegExReplace(text,"\n","`r`n") _:=text?"`r`n":""
	}
	updown(win,control,direction){
		Gui,%win%:Default
		tv:=InStr(direction,"up")?TV_GetPrev(TV_GetSelection()):TV_GetNext(TV_GetSelection()),TV_GetText(text,tv),RegExMatch(text,"O)\.(\d*)$",found)
		if(!text){
			TV_GetText(text,TV_GetSelection()),RegExMatch(text,"O)(.*\.)(\d*)$",found),add:=InStr(direction,"up")?1:InStr(direction,"down")?-1:0
			if(found.2="")
				RegExMatch(text,"O)()?(\d*)$",found)
			if(found.2+add<=0)
				return m("Version numbers can not be 0 or negative")
			TV_Add(found.1 found.2+add,0,InStr(direction,"up")?"Select Vis First":"Select Vis Focus")
			node:=this.node
			root:=ssn(node,"versions")
			new:=vversion.under(root,"version",{number:found.1 found.2+add},"",1)
			if(InStr(direction,"up"))
				above:=root.firstchild,root.insertbefore(new,above)
		}else{
			TV_Modify(tv,"Select Vis Focus")
		}
		SetTimer,relstatus,-10
		ControlFocus,Edit1,% hwnd([win])
		return
		relstatus:
		this:=versionkeep.last
		Gui,% this.win ":Default"
		TV_GetText(text,TV_GetSelection())
		if(this.win=25){
			Gui,% this.win ":Default"
			Gui,% this.win ":ListView",SysListView321
			node:=this.node,status:=ssn(node,"descendant::*[@number='" text "']"),ea:=xml.ea(status)
			LV_Modify(v.releasestatus,"col2",flan:=ea.draft="true"?"Draft":ea.pre="true"?"Pre-Release":ea.draft="false"&&ea.pre="false"?"Full Release":"Unknown")
		}
		return
	}
}