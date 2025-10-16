#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
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


#cs
githublink for complete source = https://github.com/mauer01/gui-for-5dchess-datainterface
#ce
main()



Func main()
	Local $context = loadContext()
	Switch @error
		Case 1
	EndSwitch
EndFunc   ;==>main


Func loadContext()
	If Not FileExists("gui for datainterface.ini") Then
		Return SetError(1) ; force setting up datainterface
	EndIf
	Local $context[]
	$context["ini"] = IniReadSection("gui for datainterface.ini", "Data")

	Return $context
EndFunc   ;==>loadContext


