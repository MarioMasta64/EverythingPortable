Dim Arg, download, file 
Set Arg = WScript.Arguments 
 
download = Arg(0) 
file = Arg(1) 
 
dim xHttp: Set xHttp = CreateObject("MSXML2.ServerXMLHTTP")
dim bStrm: Set bStrm = createobject("Adodb.Stream") 
xHttp.Open "GET", download, False 
xHttp.Send 
 
with bStrm 
    .type = 1 '//binary 
    .open 
    .write xHttp.responseBody 
    .savetofile file, 2 '//overwrite 
end with 
