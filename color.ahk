color(con){
	static options:={show_eol:2356,Show_Caret_Line:2096}
	list:={Font:2056,Size:2055,Color:2051,Background:2052,Bold:2053,Italic:2054,Underline:2059}
	nodes:=settings.sn("//fonts/*")
	while,n:=nodes.item(A_Index-1){
		ea:=settings.ea(n)
		if (ea.code=2082){
			con.2082(7,ea.color)
			Continue
		}
		if (ea.style=33)
			for a,b in [2290,2291]
				con[b](1,ea.Background)
		ea.style:=ea.style=5?32:ea.style
		for a,b in ea{
			if list[a]&&ea.style!=""
				con[list[a]](ea.style,b)
			else if ea.code&&ea.bool!=1
				con[ea.code](ea.color,0)
			else if ea.code&&ea.bool
				con[ea.code](ea.bool,ea.color)
			if (ea.style=32)
				con.2050(),con.2052(30,0x0000ff),con.2052(31,0x00ff00),con.2052(48,0xff00ff)
		}
	}
	list:=[[2040,25,13],[2040,26,15],[2040,27,11],[2040,28,10],[2040,29,9],[2040,30,12],[2040,31,14],[2242,0,20],[2242,1,13],[2460,3],[2462,1],[2134,1],[2260,1],[2246,1,1],[2246,2,1],[2115,1],[2029,2],[2031,2],[2244,3,0xFE000000]
	,[2080,7,6],[2240,3,0],[2242,3,15],[2244,3,0xFE000000],[2246,1,1],[2246,3,1],[2244,2,3],[2040,0,0],[2040,1,2],[2041,0,0],[2042,0,0xff],[2115,1],[2056,38,"Tahoma"]
	,[2132,v.options.Hide_Indentation_Guides?0:1],[2077,0,"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ#_"],[2041,1,0],[4006,0,"ahk"]
	,[2042,1,0xff0000],[2040,2,22],[2042,2,0x444444],[2040,3,22],[2042,3,0x666666],[2040,4,31],[2042,4,0xff0000],[2037,65001]]
	con.2036(width:=settings.ssn("//tab").text?settings.ssn("//tab").text:5)
	con.2080(3,6),con.2082(3,0xFFFFFF)
	for a,b in list
		con[b.1](b.2,b.3)
	if !settings.ssn("//fonts/font[@code='2082']")
		con.2082(7,0xff00ff)
	con.2498(1,7),con.2212,con.2371
	con.2080(2,8),con.2082(2,0xff00ff),con.2636(1)
	if zoom:=settings.ssn("//gui/@zoom").text
		con.2373(zoom)
	for a,b in options
		if v.options[a]
			con[b](b)
	kwind:={Personal:0,indent:1,Directives:2,Commands:3,builtin:4,keywords:5,functions:6,flow:7,KeyNames:8}
	for a,b in v.color
		con.4005(kwind[a],RegExReplace(b,"#"))
}