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
#cs
githublink for complete source = https://github.com/mauer01/gui-for-5dchess-datainterface
#ce

#include <include\multiversechess.au3>
#include <include\datainterfaceFascade.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <ColorConstants.au3>
$ini = @ScriptDir & "\gui for datainterface.ini"

Func _myExit()
	_CloseAllDatainterfaces()
	exit
EndFunc
#Region ### START Koda GUI section ### Form=
$title = "GUI for Data Interface"
$Main = GUICreate($title, 420, 210, 625, 277)
$b_run_datainterface = GUICtrlCreateButton("run interface", 328, 40, 75, 25)
$i_file = GUICtrlCreateInput("", 16, 8, 305, 21)
$b_openfile = GUICtrlCreateButton("OPEN", 328, 8, 75, 25)
$b_load = GUICtrlCreateButton("Load File", 170, 40, 67, 25)
$b_loadclipboard = GUICtrlCreateButton("Clipboard", 170, 40, 67, 25)
GUICtrlSetState($b_run_datainterface, $GUI_DISABLE)
$b_addvariant = GUICtrlCreateButton("add variant", 160, 72, 155, 33)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$l_loaded = GUICtrlCreateLabel("unloaded", 248, 40, 67, 25)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
GUICtrlSetColor(-1, $COLOR_RED)
$c_turn = GUICtrlCreateCombo("-1", 56, 40, 57, 25)
$Label1 = GUICtrlCreateLabel("Move:", 8, 40, 46, 24)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
$b_datainterfaceSetup = GUICtrlCreateButton("Data Interface", 328, 65, 75, 25)
$b_json_edit = GUICtrlCreateButton("Edit Entry", 328, 90, 75, 25)
$b_record = GUICtrlCreateButton("Setup Recording Games", 16, 72, 139, 33)
If recordexists() Then GUICtrlSetData(-1, "Record Game")
;~ $b_clip = GUICtrlCreateButton("Copy to Clipboard", 16, 72, 139, 33)
$b_clip = GUICtrlCreateDummy()
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$r_black = GUICtrlCreateCheckbox("Black", 120, 40, 49, 17)

GUICtrlSetState($b_addvariant, $GUI_DISABLE)
GUICtrlSetState($r_black, $GUI_DISABLE)
GUICtrlSetState($b_clip, $GUI_DISABLE)
GUICtrlSetState($b_load, $GUI_DISABLE)
GUICtrlSetState($b_load, $GUI_HIDE)
GUICtrlSetState($b_loadclipboard, $GUI_ENABLE)
GUICtrlSetState($c_turn, $GUI_DISABLE)
GUICtrlSetState($b_addvariant, $GUI_DISABLE)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###


#Region set resizing
GUICtrlSetResizing($b_load, BitOR($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($b_loadclipboard, BitOR($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($i_file, BitOR($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($b_openfile, BitOR($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($b_run_datainterface, BitOR($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($l_loaded, BitOR($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($Label1, BitOR($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($b_clip, BitOR($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($b_record, BitOR($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($b_datainterfaceSetup, BitOR($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($b_json_edit, BitOR($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($r_black, BitOR($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($c_turn, BitOR($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($b_addvariant, BitOR($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
#EndRegion set resizing
#Region bonus stuff
$c_variants = GUICtrlCreateCombo("", 56, 112, 249, 25, BitOR($WS_VSCROLL, $CBS_DROPDOWNLIST))
$b_delvar = GUICtrlCreateButton("Delete Variant", 328, 112, 75, 25)
$Label2 = GUICtrlCreateLabel("Variant:", 7, 112)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
GUICtrlSetState($c_variants, $GUI_HIDE)
GUICtrlSetState($b_delvar, $GUI_HIDE)
GUICtrlSetState($Label2, $GUI_HIDE)
GUICtrlSetState($b_json_edit, $GUI_HIDE)
GUICtrlSetResizing($c_variants, BitOR($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($b_delvar, BitOR($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($Label2, BitOR($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
#EndRegion bonus stuff
#Region DataInterfaceButtons
$b_run_variant = GUICtrlCreateButton("run variant", 46, 142, 60)
$b_datainterfaceChangeTimerL = GUICtrlCreateButton("long timer", 111, 142, 60)
$b_datainterfaceChangeTimerM = GUICtrlCreateButton("med timer", 176, 142, 60)
$b_datainterfaceChangeTimerS = GUICtrlCreateButton("short timer", 241, 142, 60)
$b_animation = GUICtrlCreateButton("travel animation", 306, 142, 85)
$b_close = GUICtrlCreateButton("close", 10, 142, 31)
$cb_keepgameon = GUICtrlCreateCheckbox("", 400, 142, 20, 20)
GUICtrlSetState($cb_keepgameon, $GUI_UNCHECKED)
GUICtrlSetState($b_close, $GUI_HIDE)
GUICtrlSetState($cb_keepgameon, $GUI_HIDE)
GUICtrlSetState($b_run_variant, $GUI_HIDE)
GUICtrlSetState($b_datainterfaceChangeTimerL, $GUI_HIDE)
GUICtrlSetState($b_datainterfaceChangeTimerM, $GUI_HIDE)
GUICtrlSetState($b_datainterfaceChangeTimerS, $GUI_HIDE)
GUICtrlSetState($b_animation, $GUI_HIDE)
GUICtrlSetResizing($b_animation, BitOR($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($cb_keepgameon, BitOR($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($b_datainterfaceChangeTimerS, BitOR($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($b_close, BitOR($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($b_datainterfaceChangeTimerL, BitOR($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($b_datainterfaceChangeTimerM, BitOR($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($b_run_variant, BitOR($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
#EndRegion DataInterfaceButtons
#Region Editbox
$e_json = GUICtrlCreateEdit("", 420, 0, 400, 160)
$b_e_close = GUICtrlCreateButton("Close", 420, 160, 75, 20)
$b_e_save = GUICtrlCreateButton("Save", 495, 160, 75, 20)
$b_e_add = GUICtrlCreateButton("Add", 570, 160, 75, 20)
GUICtrlSetResizing($e_json, BitOR($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($b_e_close, BitOR($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($b_e_save, BitOR($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($b_e_add, BitOR($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetState($b_e_close, $GUI_HIDE)
GUICtrlSetState($b_e_save, $GUI_HIDE)
GUICtrlSetState($e_json, $GUI_HIDE)
GUICtrlSetState($b_e_add, $GUI_HIDE)
#EndRegion Editbox
#Region Eventhandler for Inputbox
GUIRegisterMsg(0x0111, "MY_WM_COMMAND")
Func MY_WM_COMMAND($hWnd, $Msg, $wParam, $lParam)
	Local Static $oldinput = ""
	Local $nID
	$nID = BitAND($wParam, 0x0000FFFF)
	$newinput = GUICtrlRead($i_file)
	If $nID = $i_file and $oldinput <> $newinput Then
		If FileExists($newinput) Then
			if _readinput() then ResizeGUIInputBoxValidated(1)
		Else
			ResizeGUIInputBoxValidated(0)
		EndIf
	EndIf
	$hWnd = $hWnd
	$Msg = $Msg
	$lParam = $lParam
	$oldinput = $newinput
	Return $GUI_RUNDEFMSG
EndFunc   ;==>MY_WM_COMMAND
#EndRegion Eventhandler for Inputbox

Global $variantloader = 0, $log = "", $ini_Region = "Data", $value1 = "Interface", $value2 = "User", $fullJSON, $data[]
$data["configured"] = False 
$variantnumber = 2
$gamerecord = 0
$full = 0

If FileExists($ini) Then
	$data = _loadDataInterface(IniRead($ini, $ini_Region, $value1, ""))
	if @error = 1 Then
		MsgBox(16,"Inifile failed to Load","pls setup your datainterface again.")
	EndIf
	$user = IniRead($ini, $ini_Region, $value2, "")
Else
	WinMove($Main, "", Default, Default, Default, 136)
EndIf
If $data["configured"] Then
	ResizeGUIDatainterfaceSetupped()
EndIf
$processname = "5dchesswithmultiversetimetravel.exe"

While 1
;Region Stuff to regular Check on
	$__num2 = StringRegExp(GUICtrlRead($c_variants), "[0-9]+", 3)
	if IsArray($__num2) then $variantnumber = $__num2[0]

	If (ProcessExists($processname) And (Not IsDeclared("location"))) And GUICtrlRead($cb_keepgameon) = $GUI_CHECKED Then
		If IniRead($ini, $ini_Region, "restart", "false") = "true" Or MsgBox(4, "Restart game on crash", "Activating this will restart the game should it crash" & @LF & "It tries to get the filepath via the process first") = 6 Then
			$location = _ProcessGetLocation($processname)
			IniWrite($ini, $ini_Region, "restart", "true")
		Else
			GUICtrlSetState($cb_keepgameon, $GUI_UNCHECKED)
			GUICtrlSetState($cb_keepgameon, $GUI_DISABLE)
		EndIf
	ElseIf (ProcessExists($processname) = 0 And IsDeclared("location") <> 0 And GUICtrlRead($cb_keepgameon) = $GUI_CHECKED) Then
		If ($location = "") Then
			$location = FileOpenDialog("couldnt automatically fetch 5d chess.exe", "", "executable (*.exe)")
			If @error Then GUICtrlSetState($cb_keepgameon, $GUI_UNCHECKED)
		EndIf
		ShellExecute($location)
	EndIf
	If GUICtrlRead($b_record) = "Setup Recording Games" Then
		If recordexists() Then
			GUICtrlSetData($b_record, "Record Game")
		EndIf
	EndIf
	$nMsg = GUIGetMsg()
;Region Switch
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			_myExit()
			Case $b_loadclipboard
				$_pgn = ClipGet()
				if Not StringRegExp($_pgn, "(?s).*\[((?:[a-zA-Z\*\d]+\/){7}[a-zA-Z\*\d]+):(\d+):(\d+):([wb])\].*") Then
					MsgBox(16, "Error in format", "not valid PGN in clipboard." & @CRLF & "You probably forgot the board fens.")
					ContinueLoop
				EndIf
				$multiverse = _multiverse_create("pgn", $_pgn)
				$multiverse["Name"] = "from ClipBoard"
				ResizeGUIVariantIsInputbox()
				If $variantloader = 1 Then
					GUICtrlSetState($b_addvariant, $GUI_ENABLE)
				EndIf
;Region EditBox
		Case $b_e_close
			If MsgBox(4, "REALLY???", "Without Changing anything????") = 6 Then ResizeGUIEditBox(0)
		Case $b_e_add
			$input = GUICtrlRead($e_json)
			$newJSON = _JSON_Parse($input)
			$check = _checkVariant($newJSON)
			If IsString($check) Then
				MsgBox(16, "Error in Varant", $check)
				ContinueLoop
			EndIf
			If MsgBox(4, "This adds to the everything", "Confirm To add Variant") <> 6 Then ContinueLoop
			_ArrayAdd($fullJSON, $newJSON)
			updateJSONVariants($data, $fullJSON)
			GUISetState(@SW_ENABLE)
			ResizeGUIEditBox(0)
		Case $b_e_save
			$input = GUICtrlRead($e_json)
			$newJSON = _JSON_Parse($input)
			$check = _checkVariant($newJSON)
			If IsString($check) Then
				MsgBox(16, "Error in Variant", $check)
				ContinueLoop
			EndIf
			If MsgBox(4, "This changes the Original", "pressing yes here will remove the original variant and replaces it with the new one") <> 6 Then ContinueLoop
			$fullJSON[$variantnumber - 1] = $newJSON
			updateJSONVariants($data, $fullJSON)
			GUISetState(@SW_ENABLE)
			ResizeGUIEditBox(0)
		Case $b_json_edit
			$fullJSON = _JSONLoad()
			$entry = $fullJSON[$variantnumber - 1]
			GUICtrlSetData($e_json, _JSON_MYGenerate($entry))
			ResizeGUIEditBox()
;Region JSON Manipulations
		Case $b_record
			If Not recordexists() Then
				MsgBox(64, "Setup Recording Software", "you need my recorder+ and at best penteracts 5DPGNRecorderAndTimeReminder")
			ElseIf GUICtrlRead($b_record) = "Record Game" Then
				$gamerecord = Run("5d chess game recorder+.exe user" & $user, "", @SW_HIDE, BitOR($STDOUT_CHILD, $STDIN_CHILD))
				If @error Then
					MsgBox(16, "", "error in opening the recorder+.exe")
					ContinueCase
				EndIf
				GUICtrlSetData($b_record, "Stop Recording")
				WinSetTitle($Main, WinGetText($Main), $title & " - Recording")
			ElseIf GUICtrlRead($b_record) = "Stop Recording" Then
				ProcessClose($gamerecord)
				GUICtrlSetData($b_record, "Record Game")
			EndIf
		Case $b_load
			$pgn = GUICtrlRead($i_file)
			$multiverse = _multiverse_create("pgn", $pgn, GUICtrlRead($c_turn), _IsChecked($r_black))
			$name = StringSplit($pgn, "\")
			$multiverse["Name"]  = StringTrimRight($name[$name[0]], 4)
			ResizeGUIVariantIsInputbox()

		Case $b_openfile
			GUICtrlSetData($i_file, FileOpenDialog("choose a pgn", @WorkingDir, "Text (*.txt)"))
		Case $b_addvariant
			If not MapExists($multiverse,"Name") Then
				$name = InputBox("Name couldnt be autogenerated", "Please provide a name for", "Clipboard")
				If $name = "" Then
					$name = "failed to name"					
				EndIf
			Else
				$name = $multiverse["Name"]
			EndIf
			$variant = _JSON_MYGenerate(_multiversetovariant($multiverse, $name, "pgn to variant"))
			
			_addVariantToJson($data, $variant, $name)
			GUISetState(@SW_ENABLE)
		Case $c_turn
			ResizeGUIVariantIsInputbox(0)
		Case $r_black
			ResizeGUIVariantIsInputbox(0)
		Case $b_clip
			ClipPut(_JSON_MYGenerate(_multiversetovariant($multiverse, "5D Chess Game", "pgn to variant")))
		Case $b_delvar
			If MsgBox(4, "REALLY???", "REALLY REALLY????") = 6 Then
				_removeVariantFromJson($data, StringRegExp(GUICtrlRead($c_variants), "[0-9]+", 3)[0])
				
			EndIf
;Region ButtonsDatainterface
		Case $b_close
			_cleanExit($data)
		Case $b_datainterfaceSetup
			$folder = FileSelectFolder("Select The DataInterface Folder you want to use", @WorkingDir)
			If @error Then
				MsgBox(16, "closed out", "Folder Selection failed")
				ContinueLoop
			EndIf
			$data = _loadDataInterface($folder)
			If @error Then
				If not StringInStr($folder,"\Resources") Then
					MsgBox(16,"Wrong Folder","The chosen Folder doesnt contain the datainterface please Try Again")
					ContinueLoop
				EndIf
				$data = _loadDataInterface(StringTrimRight($folder,10))
				If @error Then 
					MsgBox(16,"Broken Datainterfacesetup", "Your given datainterface setup might be broken." & @CRLF & "Couldnt find Datainterfaceconsole.exe or jsonVariants.json")
				EndIf
			EndIf

		Case $b_run_datainterface
			_runDataInterface($data)
			if @error then MsgBox(0,"","")
			
			if $data["isRunning"] then ResizeGUIRunningDatainterface()
		Case $b_run_variant			
			_runVariant($data,$variantnumber)

		Case $b_datainterfaceChangeTimerL
			$stuff = _inputbox()
			$time = $stuff["time"]
			$delay = $stuff["delay"]
			If ($time And $delay) Then
				_settingOptions($data,6,$time)
				_waitForResponse($data,"Action executed. Returning to menu")
				_settingOptions($data,7,$delay)
			ElseIf $time Then
				_settingOptions($data,6,$time)
			ElseIf $delay Then
				_settingOptions($data,7,$time)
			EndIf
		Case $b_datainterfaceChangeTimerM
			$stuff = _inputbox()
			$time = $stuff["time"]
			$delay = $stuff["delay"]
			If ($time And $delay) Then
				_settingOptions($data,4,$time)
				_waitForResponse($data,"Action executed. Returning to menu")
				_settingOptions($data,5,$delay)
			ElseIf $time Then
				_settingOptions($data,4,$time)
			ElseIf $delay Then
				_settingOptions($data,5,$delay)
			EndIf
		Case $b_datainterfaceChangeTimerS
			$stuff = _inputbox()
			$time = $stuff["time"]
			$delay = $stuff["delay"]
			If ($time And $delay) Then
				_settingOptions($data,2,$time)
				_waitForResponse($data,"Action executed. Returning to menu")
				_settingOptions($data,3,$delay)
			ElseIf $time Then
				_settingOptions($data,2,$time)
			ElseIf $delay Then
				_settingOptions($data,3,$delay)
			EndIf
		Case $b_animation
			$animation = InputBox("Force timetravel animation", "force the way the game handles the time travel animation" & @LF & "1 or ignore" & @LF & "2 or always_on" & @LF & "3 or  always_off", 3)
			If (Not Number($animation)) Then
				Switch $animation
					Case "ignore"
						$animation = 1
					Case "always_on"
						$animation = 2
					Case "always_off"
						$animation = 3
					Case Else
						MsgBox(16, "no valid string", "No valid string put in,setting left unchanged")
						$animation = 0
				EndSwitch
			EndIf
			If ($animation < 4 And $animation) Then
				_settingOptions($data,1,$animation)
			ElseIf $animation <> 0 Then
				MsgBox(16, "no valid number", "No valid number got parsed, setting left unchanged")
			EndIf
;Region End AND ENDSWITCH
	EndSwitch
;Region looped that needs to be at the end
	_checkIsRunning($data)
	If $data["configured"] Then
		If (GUICtrlGetState($b_run_datainterface) = 144 And $data["isRunning"] = False) Then ResizeGUIRunningDatainterface(0)
		$variantsobj = _loadVariants($data)
		if $variantsobj["true"] Then
			$string = $variantsobj["string"]
			$array = $variantsobj["array"]
			GUICtrlSetData($c_variants, "|")			
			If $nMsg = $b_delvar Then
				If $variantnumber - 1 = 0 Then $variantnumber = 2
				GUICtrlSetData($c_variants, $string, $array[$variantnumber - 1])
			ElseIf $nMsg = $b_addvariant Or $nMsg = $b_e_add Then
				GUICtrlSetData($c_variants, $string, $array[UBound($array) - 1])
			ElseIf $nMsg = $b_e_save Then
				GUICtrlSetData($c_variants, $string, $array[$variantnumber])
			Else
				GUICtrlSetData($c_variants, $string, $array[1])
			EndIf
		EndIf
	EndIf

	If ProcessExists($gamerecord) Then
		$read = StdoutRead($gamerecord)
		If StringLen($read) Then
			GUICtrlSetData($i_file, $read)
			GUICtrlSetState($i_file, $GUI_ENABLE)
			GUICtrlSetData($b_record, "Record Game")
			GUICtrlSetState($b_openfile, $GUI_ENABLE)
			WinSetTitle($Main, WinGetText($Main), $title)
			StdinWrite($gamerecord, "next")
		EndIf
	EndIf

WEnd
;Region StartOfFunctions

Func _inputbox()
	GUISetState(@SW_DISABLE)
	$time = InputBox("Time for each player", "Set the time each player has in seconds (reset to reset)" & @LF & "Or use the 00:00:00 (hh:mm:ss) format")
	$delay = InputBox("Delay per active timeline", "set the delay in seconds (reset to reset)" & @LF & "Or use the 00:00:00 (hh:mm:ss) format")
	If StringInStr($time, ":") Then
		$string = StringSplit($time, ":", 2)
		$string[1] += $string[0] * 60
		$string[2] += $string[1] * 60
		$time = $string[2]
	EndIf
	If StringInStr($delay, ":") Then
		$string = StringSplit($delay, ":", 2)
		$string[1] += $string[0] * 60
		$string[2] += $string[1] * 60
		$delay = $string[2]
	EndIf
	If Number($delay) Then
		$delay = Execute($delay)
	EndIf
	If Number($time) Then
		$time = Execute($time)
	EndIf
	GUISetState(@SW_ENABLE)
	Local $stuff = []
	$stuff["time"] = $time
	$stuff["delay"] = $delay
	return $stuff

EndFunc   ;==>_inputbox
Func _JSONLoad()
	$fileContent = FileRead($data["jsonFile"])
	$temp = _JSON_Parse($fileContent)
	Return $temp
EndFunc   ;==>_JSONLoad


Func _readinput()
	$file = GUICtrlRead($i_file)
	local $lines
	GUICtrlSetData($c_turn, "")
	If FileGetSize($file) > 0 Then
		_FileReadToArray($file, $lines)
		If $lines[1] = '[Mode "5D"]' Then
			Local $string = "-1|0|"

			For $i = 1 To $lines[0]
				If StringRegExp(StringLeft($lines[$i], 1), "[0-9]") Then
					$string &= StringRegExp($lines[$i], "[0-9]+", 3)[0] & "|"
				EndIf
			Next
			GUICtrlSetData($c_turn, $string, "-1")
			return True
		EndIf
		return False
	EndIf
EndFunc   ;==>_readinput
Func _IsChecked($idControlID)
	Return BitAND(GUICtrlRead($idControlID), $GUI_CHECKED) = $GUI_CHECKED
EndFunc   ;==>_IsChecked
Func ResizeGUIDatainterfaceSetupped()
	Local $newHeight = 210
	Local $pos = WinGetPos($Main)
	WinMove($Main, "", Default, Default, $pos[2], $newHeight)
	GUICtrlSetState($c_variants, $GUI_SHOW)
	GUICtrlSetState($b_json_edit, $GUI_SHOW)
	GUICtrlSetState($Label2, $GUI_SHOW)
	GUICtrlSetState($b_delvar, $GUI_SHOW)
EndFunc   ;==>ResizeGUIDatainterfaceSetupped

Func ResizeGUIRunningDatainterface($b = 1)
	Local Const $newHeight = 210, $pos = WinGetPos($Main)
	If $b Then
		WinMove($Main, "", Default, Default, $pos[2], $newHeight)
		GUICtrlSetState($b_run_datainterface, $GUI_DISABLE)
		GUICtrlSetState($b_run_variant, $GUI_SHOW)
		GUICtrlSetState($b_datainterfaceChangeTimerL, $GUI_SHOW)
		GUICtrlSetState($b_datainterfaceChangeTimerM, $GUI_SHOW)
		GUICtrlSetState($b_datainterfaceChangeTimerS, $GUI_SHOW)
		GUICtrlSetState($b_animation, $GUI_SHOW)
		GUICtrlSetState($b_close, $GUI_SHOW)
		GUICtrlSetState($cb_keepgameon, $GUI_SHOW)
	Else
		WinMove($Main, "", Default, Default, $pos[2], $newHeight)
		GUICtrlSetState($b_run_datainterface, $GUI_ENABLE)
		GUICtrlSetState($b_run_variant, $GUI_HIDE)
		GUICtrlSetState($b_datainterfaceChangeTimerL, $GUI_HIDE)
		GUICtrlSetState($b_datainterfaceChangeTimerM, $GUI_HIDE)
		GUICtrlSetState($b_datainterfaceChangeTimerS, $GUI_HIDE)
		GUICtrlSetState($b_animation, $GUI_HIDE)
		GUICtrlSetState($b_close, $GUI_HIDE)
		GUICtrlSetState($cb_keepgameon, $GUI_HIDE)
	EndIf
EndFunc   ;==>ResizeGUIRunningDatainterface

Func ResizeGUIEditBox($b = 1)
	Local $newWidth, $pos = WinGetPos($Main)
	If $b Then

		$newWidth = 818
		WinMove($Main, "", Default, Default, $newWidth, $pos[3])
		GUICtrlSetState($e_json, $GUI_SHOW)
		GUICtrlSetState($b_e_close, $GUI_SHOW)
		GUICtrlSetState($b_e_save, $GUI_ENABLE)
		GUICtrlSetState($b_e_add, $GUI_ENABLE)
		GUICtrlSetState($b_e_save, $GUI_SHOW)
		GUICtrlSetState($b_e_add, $GUI_SHOW)
		GUICtrlSetState($b_json_edit, $GUI_DISABLE)
		GUICtrlSetState($c_variants, $GUI_DISABLE)
		GUICtrlSetState($b_delvar, $GUI_DISABLE)
	Else
		$newWidth = 420
		WinMove($Main, "", Default, Default, $newWidth, $pos[3])
		GUICtrlSetState($e_json, $GUI_HIDE)
		GUICtrlSetState($b_e_close, $GUI_HIDE)
		GUICtrlSetState($b_e_save, $GUI_HIDE)
		GUICtrlSetState($b_e_add, $GUI_HIDE)
		GUICtrlSetState($b_json_edit, $GUI_ENABLE)
		GUICtrlSetState($b_e_save, $GUI_DISABLE)
		GUICtrlSetState($b_e_add, $GUI_DISABLE)
		GUICtrlSetState($c_variants, $GUI_ENABLE)
		GUICtrlSetState($b_delvar, $GUI_ENABLE)
	EndIf


EndFunc   ;==>ResizeGUIEditBox

Func ResizeGUIInputBoxValidated($b = 1)
	if $b Then
		GUICtrlSetColor($l_loaded, $COLOR_RED)
		GUICtrlSetData($l_loaded, "unloaded")
		GUICtrlSetState($b_load, $GUI_ENABLE)
		GUICtrlSetState($b_load, $GUI_SHOW)
		GUICtrlSetState($b_loadclipboard, $GUI_DISABLE)
		GUICtrlSetState($b_loadclipboard, $GUI_HIDE)
		GUICtrlSetState($c_turn, $GUI_ENABLE)
		GUICtrlSetState($r_black, $GUI_ENABLE)
	Else
		GUICtrlSetData($c_turn, "")
		GUICtrlSetState($b_addvariant, $GUI_DISABLE)
		GUICtrlSetState($r_black, $GUI_DISABLE)
		GUICtrlSetState($b_clip, $GUI_DISABLE)
		GUICtrlSetState($b_load, $GUI_DISABLE)
		GUICtrlSetState($b_load, $GUI_HIDE)
		GUICtrlSetState($b_loadclipboard, $GUI_SHOW)
		GUICtrlSetState($b_loadclipboard, $GUI_ENABLE)
		GUICtrlSetState($c_turn, $GUI_DISABLE)
		GUICtrlSetColor($l_loaded, $COLOR_RED)
		GUICtrlSetData($l_loaded, "unloaded")
	EndIf
EndFunc

Func ResizeGUIVariantIsInputbox($b = 1)
	if $b Then
	GUICtrlSetColor($l_loaded, $COLOR_GREEN)
	GUICtrlSetData($l_loaded, "LOADED")
	GUICtrlSetState($b_clip, $GUI_ENABLE)
	If $data["configured"] Then
		GUICtrlSetState($b_addvariant, $GUI_ENABLE)
	EndIf
	Else
	GUICtrlSetState($b_clip, $GUI_DISABLE)
	GUICtrlSetColor($l_loaded, $COLOR_RED)
	GUICtrlSetState($b_addvariant, $GUI_DISABLE)
	GUICtrlSetData($l_loaded, "unloaded")
	EndIf
EndFunc

Func _ProcessGetLocation($sProc = @ScriptFullPath)
	Local $iPID = ProcessExists($sProc)
	If $iPID = 0 Then Return SetError(1, 0, -1)

	Local $aProc = DllCall('kernel32.dll', 'hwnd', 'OpenProcess', 'int', BitOR(0x0400, 0x0010), 'int', 0, 'int', $iPID)
	If $aProc[0] = 0 Then Return SetError(1, 0, -1)

	Local $vStruct = DllStructCreate('int[1024]')
	DllCall('psapi.dll', 'int', 'EnumProcessModules', 'hwnd', $aProc[0], 'ptr', DllStructGetPtr($vStruct), 'int', DllStructGetSize($vStruct), 'int*', 0)

	Local $aReturn = DllCall('psapi.dll', 'int', 'GetModuleFileNameEx', 'hwnd', $aProc[0], 'int', DllStructGetData($vStruct, 1), 'str', '', 'int', 2048)
	If StringLen($aReturn[3]) = 0 Then Return SetError(2, 0, '')
	Return $aReturn[3]
EndFunc   ;==>_ProcessGetLocation

Func recordexists()
	If Not FileExists("5d chess game recorder+.exe") Then Return False
	If Not FileExists("5DPGNRecorderAndTimeReminder.exe") Then Return False
	Return True
EndFunc   ;==>recordexists




Func _checkVariant($JSON)
	$initialKeys = MapKeys($JSON)
	If Not _arrayContains($initialKeys, "Name") Then Return "No Name"
	If Not _arrayContains($initialKeys, "Author") Then Return "No Author"
	If Not _arrayContains($initialKeys, "Timelines") Then Return "No Timelines"
	$timelines = MapKeys($JSON["Timelines"])
	$counting = 0
	For $line In $timelines
		If StringRegExp($line, "^([+-]?(0|[1-9]\d*))L$") Then
			$counting += 1
		EndIf
	Next
	If Not ($counting = UBound($timelines)) Then Return "Ungültige Zeitliniennamen"
	local $multiverse = _multiverse_create("variant", $JSON)
	$multiversum = $multiverse[1]
	For $i = 0 To UBound($multiversum) - 1
		For $j = 0 To UBound($multiversum, 2) - 1
			If Not IsArray($multiversum[$i][$j]) Then ContinueLoop
			$board = $multiversum[$i][$j]
			$boardheight = UBound($board)
			If $boardheight > 8 Then MsgBox(0, "", "")
			$boardwidth = UBound($board, 2)
			If Not IsDeclared("oldboardheight") Then $oldboardheight = $boardheight
			If $boardheight <> $boardwidth Then
				Return "Board at timeline " & $j & " and at position " & $i + 1 & " isnt a square"
			EndIf
			If $boardheight <> $oldboardheight Then
				Return "Board at timeline " & $j & " and at position " & $i + 1 & " has a different height"
			EndIf
			$oldboardheight = $boardheight
		Next
	Next
	Return True
EndFunc   ;==>_checkVariant

Func _arrayContains($array, $contains)
	$bool = False
	For $ele In $array
		If $ele = $contains Then $bool = True
	Next
	Return $bool
EndFunc   ;==>_arrayContains

