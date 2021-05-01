Dim Arg, zipfile, folder 
Set Arg = WScript.Arguments 
 
zipfile = Arg(0) 
folder = Arg(1) 
 
'If the extraction location does not exist create it. 
Set fso = CreateObject("Scripting.FileSystemObject") 
If NOT fso.FolderExists(folder) Then 
   fso.CreateFolder(folder) 
End If 
 
'Extract the contants of the zip file. 
set objShell = CreateObject("Shell.Application") 
set FilesInZip=objShell.NameSpace(zipfile).items 
objShell.NameSpace(folder).CopyHere(FilesInZip) 
Set fso = Nothing 
Set objShell = Nothing 
