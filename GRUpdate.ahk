GRUpdate(url){
	verfile:=versionkeep.last,git:=new github()
	url:=url?url:git.url "/repos/" git.owner "/" git.repo "/releases" git.token
	info:=git.send("get",url),pos:=1
	while,RegExMatch(info,"Oi)\x22id\x22",found,Pos){
		out:=[]
		for a,b in {id:"\d*",prerelease:"\w*",draft:"\w*"}{
			RegExMatch(info,"Oi)\x22" a "\x22:(" b ")",found,pos)
			out[a]:=found.1
			RegExMatch(info,"OUi)\x22tag_name\x22:\x22(.*)\x22",found,pos)
			out["tag_name"]:=found.1
			pos++
		}
		pos:=RegExMatch(info,"Oi)\x22upload_url\x22",found,pos)
		if(out.tag_name){
			if node:=ssn(verfile.node,"descendant::*[@number='" out.tag_name "']")
				for a,b in {draft:out.draft,pre:out.prerelease,id:out.id}
					node.SetAttribute(a,b)
		}
	}
	SetTimer,relstatus,-10
}