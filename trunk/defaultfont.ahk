defaultfont(){
	temp:=new xml("temp")
	info=
	(
<fonts>
	<author>joedf</author>
	<name>PlasticCodeWrap</name>
	<font background="0x1D160B" bold="0" color="0xF8F8F2" font="Consolas" size="10" style="5" italic="0" strikeout="0" underline="0"></font>
	<font background="0x36342E" style="33" color="0xECEEEE"></font>
	<font code="2069" color="0xFF8080"></font>
	<font style="13" color="0x2929EF" background="0x1D160B" bold="0"></font>
	<font style="3" color="0x39E455" bold="0"></font>
	<font style="1" color="0xE09A1E" font="Consolas" italic="1" bold="0"></font>
	<font style="2" color="0x833AFF" font="Consolas" italic="0" bold="0"></font>
	<font style="4" color="0x00AAFF"></font>
	<font style="15" background="0x272112" color="0x0080FF"></font>
	<font style="18" color="0x00AAFF"></font>
	<font style="19" background="0x272112" color="0x9A93EB" font="Consolas" italic="0"></font>
	<font style="22" color="0x54B4FF"></font>
	<font style="21" color="0x0080FF" italic="1"></font>
	<font style="11" color="0xE09A1E" bold="0" font="Consolas" italic="1" size="10" strikeout="0" underline="0"></font>
	<font style="17" color="0x00AAFF" italic="1"></font>
	<font bool="1" code="2068" color="0x3D2E16"></font>
	<font bool="1" code="2067" color="0xECE000"></font>
	<font code="2098" color="0x583F11"></font>
	<font style="20" color="0x0000FF" italic="1" background="0x272112"></font>
	<font style="23" color="0x00AAFF" italic="1"></font>
	<font style="24" color="0xFF00FF" background="0x272112"></font>
	<font style="9" color="0x4B9AFB"></font>
	<font style="8" color="0x00AAFF"></font>
	<font style="10" color="0x2929EF"></font>
	</fonts>
)
	top:=settings.ssn("//settings")
	temp.xml.loadxml(info)
	tt:=temp.ssn("//*")
	top.appendchild(tt)
}