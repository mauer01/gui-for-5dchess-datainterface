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




Func main()
	Local $context = loadContext()
	Switch @error
		Case 1
			Return SetError(1, 0, $context)
	EndSwitch

	$run = _runDataInterface($context["data"])
	If @error Then
		_cleanexit($context.data)
		Return SetError(@error, @extended, $run)
	EndIf

	$main = _MainGui($context)
	If @error Then
		_cleanexit($context.data)
		Return SetError(@error, @extended, $main)
	EndIf


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
	If Not MapExists($context.ini.data, "Interface") Then Return SetError(1, 0, "force setting up datainterface")
	$context["data"] = _datainterfaceSetup($context["ini"]["data"]["Interface"])
	If @error = 1 Then
		Return SetError(1, 0, "force setting up datainterface")
	EndIf
	IniWrite($context["ini"]["path"], "Data", "Interface", $context["data"]["workingDir"])
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


