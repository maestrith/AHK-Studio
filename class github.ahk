class github{
	static url:="https://api.github.com",http:=[]
	__New(){
		ea:=settings.ea("//github")
		if !(ea.owner&&ea.token)
			return m("Please setup your Github info")
		this.http:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
		if proxy:=settings.ssn("//proxy").text
			http.setProxy(2,proxy)
		for a,b in settings.ea("//github")
			this[a]:=b
		this.token:="?access_token=" ea.token,this.owner:=ea.owner,this.tok:="&access_token=" ea.token,this.repo:=vversion.ssn("//info[@file='" current(2).file "']/@repo").text
		return this
	}
	delete(repo,filenames){
		url:=this.url "/repos/" this.owner "/" repo "/commits" this.token,tree:=this.sha(this.Send("GET",url)),url:=this.url "/repos/" this.owner "/" repo "/git/trees/" tree "?recursive=1" this.tok,info:=this.Send("GET",url),fz:=[],info:=SubStr(info,InStr(info,"tree" Chr(34)))
		for a,b in strsplit(info,"{"){
			if path:=this.find("path",b)
				fz[path]:=this.find("sha",b)
		}
		for c in filenames{
			StringReplace,cc,c,\,/,All
			url:=this.url "/repos/" this.owner "/" repo "/contents/" cc this.token,sha:=fz[cc]
			json={"message":"Deleted","sha":"%sha%"},this.http.Open("DELETE",url)
			this.http.send(json)
			if(this.http.status!=200)
				m("Error deleting " c,this.http.ResponseText)
			FileDelete,github\%repo%\%c%
		}
	}
	find(search,text){
		RegExMatch(text,"U)" Chr(34) search Chr(34) ":(.*),",found)
		return Trim(found1,Chr(34))
	}
	sha(text){
		RegExMatch(this.http.ResponseText,"U)" Chr(34) "sha" Chr(34) ":(.*),",found)
		return Trim(found1,Chr(34))
	}
	gettree(value:=""){
		info:=this.send("GET",this.url "/repos/" this.owner "/" this.repo "/git/trees/" this.getref(this.repo) this.token)
		if(value){
			temp:=new xml("tree")
			top:=temp.ssn("//tree")
			info:=SubStr(info,InStr(info,Chr(34) "tree" Chr(34))),pos:=1
			while,RegExMatch(info,"OU){(.*)}",found,pos){
				new:=temp.under(top,"node")
				for a,b in StrSplit(found.1,","){
					in:=StrSplit(b,":",Chr(34))
					new.SetAttribute(in.1,in.2)
				}
				pos:=found.pos(1)+found.len(1)
			}
			temp.Transform(2)
		}
		return temp
	}
	getref(repo){
		url:=this.url "/repos/" this.owner "/" repo "/git/refs/heads/master" this.token,this.cmtsha:=this.sha(this.Send("GET",url)),url:=this.url "/repos/" this.owner "/" repo "/commits/" this.cmtsha this.token,RegExMatch(this.Send("GET",url),"U)tree.:\{.sha.:.(.*)" Chr(34),found)
		return found1
	}
	blob(repo,text){
		url:=this.url "/repos/" this.owner "/" repo "/git/blobs" this.token,text:=debug.encode(text)
		json={"content":"%text%","encoding":"base64"}
		return this.sha(this.oops:=this.Send("POST",url,json))
	}
	send(verb,url,data=""){
		this.http.Open(verb,url),this.http.send(data)
		return this.http.ResponseText
	}
	tree(repo,parent,blobs){
		url:=this.url "/repos/" this.owner "/" repo "/git/trees" this.token
		if(parent)
			json={"base_tree":"%parent%","tree":[
		else
			json={"tree":[
		for a,blob in blobs{
			add={"path":"%a%","mode":"100644","type":"blob","sha":"%blob%"},
			json.=add
		}
		return this.sha(this.Send("POST",url,Trim(json,",") "]}"))
	}
	commit(repo,tree,parent,message="Updated the file",name="placeholder",email="placeholder@gmail.com"){
		message:=this.utf8(message),parent:=this.cmtsha,url:=this.url "/repos/" this.owner "/" repo "/git/commits" this.token
		json={"message":"%message%","author":{"name": "%name%","email": "%email%"},"parents":["%parent%"],"tree":"%tree%"}
		return this.sha(this.Send("POST",url,json))
	}
	ref(repo,sha){
		url:=this.url "/repos/" this.owner "/" repo "/git/refs/heads/master" this.token,this.http.Open("PATCH",url)
		json={"sha":"%sha%","force":true}
		this.http.send(json)
		SplashTextOff
		return this.http.status
	}
	Limit(){
		url:=this.url "/rate_limit" this.token,this.http.Open("GET",url),this.http.Send()
		m(this.http.ResponseText)
	}
	CreateRepo(name,description="",homepage="",private="false",issues="true",wiki="true",downloads="true"){
		url:=this.url "/user/repos" this.token
		for a,b in {homepage:this.utf8(homepage),description:this.utf8(description)}
			if(b!=""){
				aa="%a%":"%b%",
				add.=aa
			}
		json={"name":"%name%",%add%"private":%private%,"has_issues":%issues%,"has_wiki":%wiki%,"has_downloads":%downloads%,"auto_init":true}
		this.Send("POST",url,json)
	}
	CreateFile(repo,filefullpath,text,commit="First Commit",realname="Testing",email="Testing"){
		SplitPath,filefullpath,filename
		url:=this.url "/repos/" this.owner "/" repo "/contents/" filename this.token,file:=this.utf8(text)
		json={"message":"%commit%","committer":{"name":"%realname%","email":"%email%"},"content": "%file%"}
		this.http.Open("PUT",url),this.http.send(json),RegExMatch(this.http.ResponseText,"U)"Chr(34) "sha" Chr(34) ":(.*),",found)
	}
	utf8(info){
		info:=RegExReplace(info,"([" Chr(34) "\\])","\$1")
		for a,b in {"`n":"\n","`t":"\t","`r":"\r"}
			StringReplace,info,info,%a%,%b%,All
		return info
	}
}