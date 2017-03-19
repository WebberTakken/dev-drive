'
' File:        unzip.vbs
'
' Description: Extracting a zip file from command line using Microsoft Windows native unzip library
' Author:      Webber
' License:     MIT
'

' Quit on insufficient parameters
Set Args = Wscript.Arguments
If (Args.Count < 1 OR Args.Count > 2) Then
  WScript.Echo(_
    "unzip.vbs: Insufficient arguments, Usage:" & chr(10) & _
    chr(10) & _
    "cscript unzip.vbs path\to\file.ext path\to\dest" _
  )
  WScript.Quit 1
End If

' Create Objects
Set Shell      = CreateObject("Shell.Application")
Set FileSystem = CreateObject("Scripting.FileSystemObject")

' Determine current path
ScriptPath = FileSystem.GetAbsolutePathName(".") & "\"

' Process Source File
SourceFile = ScriptPath & Args(0)
If (Not FileSystem.FileExists(SourceFile)) Then
  WScript.Echo (_
    "unzip.vbs: Error opening (" & SourceFile & ")" & chr(10) & _
    chr(10) & _
    "File not found." _
  )
  WScript.Quit 1
End If
Set SourceContents = Shell.NameSpace(SourceFile).Items()

' Process Destination Folder
If (Args.Count = 1) Then
  Answer = MsgBox (_
    "Are you sure you want to extract the contents of this file into its own directory?",_
    vbYesNo + vbQuestion,_
    "Extract here?"_
  )
  if(Answer = vbNo) Then
    WScript.Quit 1
  End If
  DestinationPath = ScriptPath
ElseIf (Args.Count = 2) Then
  DestinationPath = ScriptPath & Args(1)
End If
Function TrimTrailingBackslashes(String)
  If(InStrRev(String,"\") = Len(String)) Then
    String = Left(String, Len(String)-1)
    String = TrimTrailingBackslashes(String)
  End If
  TrimTrailingBackslashes = String
End Function
DestinationPath = TrimTrailingBackslashes(DestinationPath) & "\"
if (Not FileSystem.FolderExists(DestinationPath)) Then
  FileSystem.CreateFolder(DestinationPath)
  if (Not FileSystem.FolderExists(DestinationPath)) Then
    WScript.Echo (_
      "unzip.vbs: Error creating directory (" & DestinationPath & ")" & chr(10) & _
      chr(10) & _
      "Invalid destination path." _
    )
    WScript.Quit 1
  End If
End If
Set Destination    = Shell.NameSpace(DestinationPath)

' Extract Files
' See: https://msdn.microsoft.com/en-us/library/windows/desktop/bb787866(v=vs.85).aspx
WScript.Echo (_
  "unzip.vbs: Extracting ZIP File" & chr(10) & _
  "Source:       " & SourceFile & chr(10) & _
  "Destination:  " & DestinationPath _
)
Destination.CopyHere SourceContents, 2832
WScript.Echo "Done."