if WScript.Arguments.Count < 2 then
    WScript.Echo "Missing parameters"
end if

url = WScript.Arguments(0)
file = WScript.Arguments(1)

Set objHTTP = CreateObject( "WinHttp.WinHttpRequest.5.1" )
objHTTP.Open "GET", url, False
objHTTP.Send
Set objFSO = CreateObject("Scripting.FileSystemObject")
  If objFSO.FileExists(file) Then
    objFSO.DeleteFile(file)
  End If
  If objHTTP.Status = 200 Then
    Dim objStream
    Set objStream = CreateObject("ADODB.Stream")
    With objStream
      .Type = 1 'adTypeBinary
      .Open
      .Write objHTTP.ResponseBody
      .SaveToFile file
    .Close
  End With
  Set objStream = Nothing
End If
' If objFSO.FileExists(file) Then
  ' WScript.Echo "Download `" & file & "` completed successfuly."
' End If