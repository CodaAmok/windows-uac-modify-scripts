Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objLogFile = objFSO.OpenTextFile("C:\uac.log",8,True)
objLogFile.Write(TIME() & " " & "Started" & vbCr)
Dim str, strOS, objShell

str = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\"

function regRead(strKey) 
	Set objShell = CreateObject("WScript.Shell")
	objLogFile.Write(TIME() & " " & "Checking EnableLUA value" & vbCr)
	regRead = objShell.RegRead(strKey)
end function

function regWrite()
	Set objShell = CreateObject("WScript.Shell")
	objLogFile.Write(TIME() & " " & "Starting write to reg" & vbCr)
	Call objShell.RegWrite(str + "ConsentPromptBehaviorAdmin", "5", "REG_DWORD")
	Call objShell.RegWrite(str + "ConsentPromptBehaviorUser", "3", "REG_DWORD")
	Call objShell.RegWrite(str + "EnableInstallerDetection", "1", "REG_DWORD")
	Call objShell.RegWrite(str + "EnableLUA", "1", "REG_DWORD")
	Call objShell.RegWrite(str + "EnableVirtualization", "1", "REG_DWORD")
	Call objShell.RegWrite(str + "PromptOnSecureDesktop", "1", "REG_DWORD")
	Call objShell.RegWrite(str + "ValidateAdminCodeSignatures", "0", "REG_DWORD")
	Call objShell.RegWrite(str + "FilterAdministratorToken", "0", "REG_DWORD")
	objLogFile.Write(TIME() & " " & "Finished writing to reg" & vbCr)
end function

function getOS()
	Set objWMIService = GetObject("winmgmts:" & "{impersonationLevel=impersonate}!\\.\root\cimv2")
	Set colOS = objWMIService.ExecQuery ("Select Caption from Win32_OperatingSystem")
	For Each objOS in colOS
	    getOS = objOS.Caption
	Next
	objLogFile.Write(TIME() & " " & "OS: " & getOS & vbCr)
end function

strOS = getOS()

Select Case True
	Case (InStr(strOS,"Windows 10") > 0)
		If regRead(str + "EnableLUA") = "0" Then
			objLogFile.Write(TIME() & " " & "UAC is disabled" & vbCr)
			Call regWrite()
		Else
			objLogFile.Write(TIME() & " " & "UAC is enabled, quitting" & vbCr)
		End If
	Case (InStr(strOS,"Windows 8") > 0)
		objLogFile.Write(TIME() & " " & "Found Win8, quitting" & vbCr)
	Case (InStr(strOS,"Windows 8.1") > 0)
		objLogFile.Write(TIME() & " " & "Found Win8.1, quitting" & vbCr)
	Case (InStr(strOS,"Windows 7") > 0)
		If regRead(str + "EnableLUA") = "0" Then
			objLogFile.Write(TIME() & " " & "UAC is disabled" & vbCr)
			Call regWrite()
		Else
			objLogFile.Write(TIME() & " " & "UAC is enabled, quitting" & vbCr)
		End If
	Case (InStr(strOS,"Windows XP") > 0)
		objLogFile.Write(TIME() & " " & "Found WinXP, quitting" & vbCr)
	Case Else
		objLogFile.Write(TIME() & " " & "Unknown OS, " & strOS & ", quitting" & vbCr)
End Select

set objShell = nothing
objLogFile.Write(TIME() & " " & "Finished" & vbCr)
objLogFile.Close()
