class github{
	static url:="https://api.github.com",http:=[]
	delete(repo,filenames){
		url:=this.url "/repos/" this.owner "/" repo "/commits" this.token ;get the tree sha
		tree:=this.sha(this.Send("GET",url))
		url:=this.url "/repos/" this.owner "/" repo "/git/trees/" tree "?recursive=1" this.tok ;full tree info
		info:=this.Send("GET",url)
		fz:=[]
		info:=SubStr(info,InStr(info,"tree" Chr(34)))
		for a,b in strsplit(info,"{"){
			if path:=this.find("path",b)
				fz[path]:=this.find("sha",b)
		}
		for c in filenames{
			StringReplace,cc,c,\,/,All
			url:=this.url "/repos/" this.owner "/" repo "/contents/" cc this.token
			sha:=fz[c]
			json={"message":"Deleted","sha":"%sha%"}
			this.http.Open("DELETE",url)
			this.http.send(json)
			if (this.http.status!=200)
				m("Error deleting " c,this.http.ResponseText)
			FileDelete,github\%repo%\%c%
		}
	}
	__New(owner,token){
		this.http:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
		this.token:="?access_token=" token
		this.owner:=owner
		this.tok:="&access_token=" token
		return this
	}
	find(search,text){
		RegExMatch(text,"U)" Chr(34) search Chr(34) ":(.*),",found)
		return Trim(found1,Chr(34))
	}
	sha(text){
		RegExMatch(this.http.ResponseText,"U)" Chr(34) "sha" Chr(34) ":(.*),",found)
		return Trim(found1,Chr(34))
	}
	getref(repo){
		;GET /repos/:owner/:repo/git/refs
		url:=this.url "/repos/" this.owner "/" repo "/git/refs" this.token
		return this.sha(this.Send("GET",url))
	}
	blob(repo,text){
		;POST /repos/:owner/:repo/git/blobs
		url:=this.url "/repos/" this.owner "/" repo "/git/blobs" this.token
		text:=this.utf8(text)
		json=
		(
		{"content":"%text%","encoding":"utf-8"}
		)
		return this.sha(this.Send("POST",url,json))
	}
	send(verb,url,data=""){
		this.http.Open(verb,url)
		this.http.send(data)
		return this.http.ResponseText
	}
	tree(repo,parent,blobs){
		;POST /repos/:owner/:repo/git/trees
		url:=this.url "/repos/" this.owner "/" repo "/git/trees" this.token
		json=
		(
		{"base_tree":"%parent%","tree":[
		)
		for a,blob in blobs{
			add={"path":"%a%","mode":"100644","type":"blob","sha":"%blob%"},
			json.=add
		}
		json:=Trim(json,",") "]}"
		return this.sha(this.Send("POST",url,json))
	}
	commit(repo,tree,parent,message="Updated the file",name="placeholder",email="placeholder@gmail.com"){
		url:=this.url "/repos/" this.owner "/" repo "/git/commits" this.token
		json=
		(
		{"message":"%message%","author":{"name": "%name%","email": "%email%"},"parents":["%parent%"],"tree":"%tree%"}
		)
		return this.sha(this.Send("POST",url,json))
	}
	ref(repo,sha){
		url:=this.url "/repos/" this.owner "/" repo "/git/refs/heads/master" this.token
		this.http.Open("PATCH",url)
		json=
		(
		{"sha":"%sha%","force":true}
		)
		this.http.send(json)
		SplashTextOff
		return this.http.status
	}
	Limit(){
		url:=this.url "/rate_limit" this.token
		this.http.Open("GET",url)
		this.http.Send()
		m(this.http.ResponseText)
	}
	CreateRepo(name,description="Created with AHK Studio",homepage="",private="false",issues="false",wiki="true",downloads="true"){
		url:=this.url "/user/repos" this.token
		this.http.Open("POST",url)
		json=
		(
		{"name":"%name%","description":"%description%","homepage":"http://www.maestrith.com","private":%private%,"has_issues":%issues%,"has_wiki":%wiki%,"has_downloads":%downloads%}
		)
		this.http.Send(json)
		FileDelete,create.txt
		FileAppend,% this.http.ResponseText,create.txt
	}
	CreateFile(repo,filefullpath,text,commit="First Commit",realname="Testing",email="Testing"){
		SplitPath,filefullpath,filename
		url:=this.url "/repos/" this.owner "/" repo "/contents/" filename this.token,file:=this.encode(text)
		json=
		(
		{"message":"%commit%","committer":{"name":"%realname%","email":"%email%"},"content": "%file%"}
		)
		this.http.Open("PUT",url)
		this.http.send(json)
		RegExMatch(this.http.ResponseText,"U)"Chr(34) "sha" Chr(34) ":(.*),",found)
		sha:=Trim(found1,Chr(34))
		if sha
			IniWrite,%sha%,files.ini,%filefullpath%,sha
	}
	utf8(info){
		info:=RegExReplace(info,"([" Chr(34) "\\])","\$1")
		for a,b in {"`n":"\n","`t":"\t","`r":""}
			StringReplace,info,info,%a%,%b%,All
		return info
	}
}