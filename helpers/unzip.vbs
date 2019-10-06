if WScript.Arguments.Count < 2 then
    WScript.Echo "Missing parameters"
end if

ZipFile = WScript.Arguments(0)
ExtractTo = WScript.Arguments(1)

'If the extraction location does not exist create it.
Set fso = CreateObject("Scripting.FileSystemObject")
If NOT fso.FolderExists(ExtractTo) Then
   fso.CreateFolder(ExtractTo)
End If

'Extract the contants of the zip file.
set objShell = CreateObject("Shell.Application")
set FilesInZip=objShell.NameSpace(ZipFile).items
objShell.NameSpace(ExtractTo).CopyHere(FilesInZip)
Set fso = Nothing
Set objShell = Nothing