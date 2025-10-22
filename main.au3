#AutoIt3Wrapper_Icon=C:\Program Files (x86)\AutoIt3\Icons\au3.ico
#AutoIt3Wrapper_Outfile=out\gui-for-5d-datainterface.exe
#AutoIt3Wrapper_Res_Comment=5D Chess Variant Manager - Open Source
#AutoIt3Wrapper_Res_Description=GUI for managing 5D Chess game variants
#AutoIt3Wrapper_Res_Fileversion=1.5.1.0
#AutoIt3Wrapper_Res_ProductName=5D Chess Data Interface GUI
#AutoIt3Wrapper_Res_ProductVersion=1.5.1.0
#AutoIt3Wrapper_Res_CompanyName=Mauer01
#AutoIt3Wrapper_Res_LegalCopyright=MIT License - Copyright (c) 2025 Mauer01
#AutoIt3Wrapper_Res_SaveSource=y
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#AutoIt3Wrapper_Run_Before=rmdir /S/Q out
#AutoIt3Wrapper_Run_Before=mkdir out
#AutoIt3Wrapper_Run_After=copy "gui for datainterface.ini" "out/gui for datainterface.ini"
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <gui For 5d datainterface.au3>
#include <include\datainterfaceService.au3>
#include <include\JSON.au3>
#include <include\moreArray.au3>

#cs
githublink for complete source = https://github.com/mauer01/gui-for-5dchess-datainterface
#ce
While 1
	$exit = main()
	$errorcode = @error
	$extended = @extended
	If $errorcode Then
		MsgBox(16, "Error", "An error occurred: " & @CRLF & "Code: " & $errorcode & @CRLF & "ErrorMessage: " & $exit)
		Exit $errorcode
	EndIf
	If $exit Then
		Exit
	EndIf
WEnd



Func main()
	Local $context = loadContext()
	$error = @error
	If $error = 1 Then
		Local $msg = "No valid configuration found." & _
				@CRLF & "5D data interface needs to be set up" & _
				@CRLF & "Do you want it to happen automatically by downloading" & _
				@CRLF & "the required files from the internet into" & _
				@CRLF & @LocalAppDataDir & "\GuiDataInterface"
		$res = MsgBox(3, "Setup Required", $msg)
		If $res = 6 Then
			$msg = _requestDatainterface()
			If @error Then Return SetError(@error, @extended, $msg)
		ElseIf $res = 7 Then
			$msg = FileSelectFolder("Select folder containing 5D Chess Data Interface", @WorkingDir)
			If @error Then Return SetError(1, 0, "folder selection Failed")
			$testLoad = _datainterfaceSetup($msg)
			If @error Then Return SetError(@error, 0, $testLoad)
		ElseIf $res = 2 Then
			Return True ; exit the program
		EndIf
		IniWrite("gui for datainterface.ini", "Data", "Interface", $msg)
		Return False ; restart main to load new config
	ElseIf $error Then
		Return SetError($error, @extended, $context)
	EndIf
	$run = _runDataInterface($context["data"])
	If @error Then
		_cleanexit($context.data)
		Return SetError(@error, @extended, $run)
	EndIf
	$msg = _cacheJsonUrls($context.data)
	If @error Then
		MsgBox(16, "Error", $msg)
	EndIf
	$main = _LoadMainGui($context)
	If @error Then
		_cleanexit($context.data)
		Return SetError(@error, @extended, $main)
	EndIf

	Do
		$msg = _frontController($context, $main)
		$error = @error
		If $error Then
			_cleanexit($context.data)
			Return SetError($error, @extended, $msg)
		EndIf
		If $msg == "exit" Then
			_cleanexit($context.data)
			Return True
		ElseIf $msg == "restart" Then
			_cleanexit($context.data)
			Return False
		EndIf
		_checkIsRunning($context.data)
	Until $error And Not $msg
	_cleanexit($context.data)
	Return SetError(2, 0, "Uncaught Exit")
EndFunc   ;==>main


Func loadContext()
	Local $context = _newMap()
	$context["ini"] = _newMap()
	$context["ini"]["path"] = "gui for datainterface.ini"
	If Not FileExists($context["ini"]["path"]) Then
		Return SetError(1, 0, "force setting up datainterface")
	EndIf
	IniReadSection("gui for datainterface.ini", "Data")
	$context["ini"]["data"] = _twodimarraytoMap(IniReadSection("gui for datainterface.ini", "Data"))
	If Not MapExists($context["ini"]["data"], "Interface") Then Return SetError(1, 0, "force setting up datainterface")
	$context["data"] = _datainterfaceSetup($context["ini"]["data"]["Interface"])
	If @error = 1 Then
		Return SetError(1, 0, "force setting up datainterface")
	EndIf
	If MapExists($context["ini"]["data"], "language") Then
		$context["labels"] = _loadLanguage($context["ini"]["data"]["language"])
		If @error Then
			MsgBox(16, "Error", "Language file for '" & $context["ini"]["data"]["language"] & "' not found. Reverting to English.")
		EndIf
	Else
		$context["labels"] = _loadLanguage()
	EndIf
	Return $context
EndFunc   ;==>loadContext
