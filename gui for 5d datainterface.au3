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
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ColorConstants.au3>
$ini = @ScriptDir & "\gui for datainterface.ini"
$tempFile = @ScriptDir & "\temp-pgn to variant.txt"
#Region ### START Koda GUI section ### Form=
$title = "GUI for Data Interface"
$Form1_1 = GUICreate($title, 420, 210, 625, 277)
$b_variantloader = GUICtrlCreateButton("run interface", 328, 40, 75, 25)
$i_file = GUICtrlCreateInput("", 16, 8, 305, 21)
$b_openfile = GUICtrlCreateButton("OPEN", 328, 8, 75, 25)
$b_load = GUICtrlCreateButton("Load File", 170, 40, 67, 25)
$b_loadclipboard = GUICtrlCreateButton("Clipboard", 170, 40, 67, 25)
GUICtrlSetState($b_variantloader, $GUI_DISABLE)
$b_addvariant = GUICtrlCreateButton("add variant", 160, 72, 155, 33)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$l_loaded = GUICtrlCreateLabel("unloaded", 248, 40, 67, 25)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
GUICtrlSetColor(-1, $COLOR_RED)
$c_turn = GUICtrlCreateCombo("-1", 56, 40, 57, 25)
$Label1 = GUICtrlCreateLabel("Move:", 8, 40, 46, 24)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
$b_json = GUICtrlCreateButton("Data Interface", 328, 65, 75, 25)
$b_jsonentry = GUICtrlCreateButton("Edit Entry", 328, 90, 75, 25)
$b_clip = GUICtrlCreateButton("Copy to Clipboard", 16, 72, 139, 33)
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
$text = GUICtrlRead($i_file)
$time = ""
$delay = ""
#Region set resizing
GUICtrlSetResizing($b_load, BitOR($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($b_loadclipboard, BitOR($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($i_file, BitOR($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($b_openfile, BitOR($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($b_variantloader, BitOR($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($l_loaded, BitOR($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($Label1, BitOR($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($b_clip, BitOR($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($b_json, BitOR($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($b_jsonentry, BitOR($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
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
GUICtrlSetState($b_jsonentry, $GUI_HIDE)
GUICtrlSetResizing($c_variants, BitOR($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($b_delvar, BitOR($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($Label2, BitOR($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
#EndRegion bonus stuff
#Region DataInterfaceButtons
$b_run = GUICtrlCreateButton("run variant", 46, 142, 60)
$b_timerL = GUICtrlCreateButton("long timer", 111, 142, 60)
$b_timerM = GUICtrlCreateButton("med timer", 176, 142, 60)
$b_timerS = GUICtrlCreateButton("short timer", 241, 142, 60)
$b_animation = GUICtrlCreateButton("travel animation", 306, 142, 85)
$b_close = GUICtrlCreateButton("close", 10, 142, 31)
$cb_keepgameon = GUICtrlCreateCheckbox("", 400, 142, 20, 20)
GUICtrlSetState($cb_keepgameon, $GUI_UNCHECKED)
GUICtrlSetState($b_close, $GUI_HIDE)
GUICtrlSetState($cb_keepgameon, $GUI_HIDE)
GUICtrlSetState($b_run, $GUI_HIDE)
GUICtrlSetState($b_timerL, $GUI_HIDE)
GUICtrlSetState($b_timerM, $GUI_HIDE)
GUICtrlSetState($b_timerS, $GUI_HIDE)
GUICtrlSetState($b_animation, $GUI_HIDE)
GUICtrlSetResizing($b_animation, BitOR($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($cb_keepgameon, BitOR($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($b_timerS, BitOR($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($b_close, BitOR($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($b_timerL, BitOR($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($b_timerM, BitOR($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($b_run, BitOR($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
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
	Local $nID
	$nID = BitAND($wParam, 0x0000FFFF)
	If $nID = $i_file And GUICtrlRead($i_file) <> $text Then
		$text = GUICtrlRead($i_file)
		_readinput()
	EndIf
	Return $GUI_RUNDEFMSG
EndFunc   ;==>MY_WM_COMMAND
#EndRegion Eventhandler for Inputbox

Global $variantloader = 0, $log = "", $l_time = 0, $f_variantloader, $sleep = 100, $Region = "Data", $value1 = "Interface", $value2 = "User", $fullJSON
$variantnumber = 2
$run = 0
$running = 0
$full = 0
$undervalue = 1
Dim $lines

If FileExists($ini) Then
	$f_variantloader = IniRead($ini, $Region, $value1, "")
	$variantloader = 1
	$user = IniRead($ini, $Region, $value2, "")
Else
	WinMove($Form1_1, "", Default, Default, Default, 136)
EndIf
If $variantloader = 1 Then
	ResizeGUI()
EndIf
$processname = "5dchesswithmultiversetimetravel.exe"

While 1
	If (ProcessExists($processname) And (Not IsDeclared("location"))) And GUICtrlRead($cb_keepgameon) = $GUI_CHECKED Then
		If IniRead($ini, $Region, "restart", "false") = "true" Or MsgBox(4, "Restart game on crash", "Activating this will restart the game should it crash" & @LF & "It tries to get the filepath via the process first") = 6 Then
			$location = _ProcessGetLocation($processname)
			IniWrite($ini, $Region, "restart", "true")
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
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $b_loadclipboard
			Local $pgn = ClipGet()
			if Not StringRegExp($pgn, "(?s).*\[((?:[a-zA-Z\*\d]+\/){7}[a-zA-Z\*\d]+):(\d+):(\d+):([wb])\].*") Then
				MsgBox(16, "Error in format", "not valid PGN in clipboard." & @CRLF & "You probably forgot the board fens.")
				ContinueLoop
			EndIf
			$multiverse = _multiverse_create("pgn", $pgn)
			GUICtrlSetColor($l_loaded, $COLOR_GREEN)
			GUICtrlSetData($l_loaded, "LOADED")
			GUICtrlSetState($b_clip, $GUI_ENABLE)
			If $variantloader = 1 Then
				GUICtrlSetState($b_addvariant, $GUI_ENABLE)
			EndIf
		Case $b_e_close
			If MsgBox(4, "REALLY???", "Without Changing anything????") = 6 Then ResizeGUI3(0)
		Case $b_e_add
			$input = GUICtrlRead($e_json)
			$newJSON = _JSON_Parse($input)
			$check = _checkVariant($newJSON)
			If IsString($check) Then
				MsgBox(16, "Error in Variant", $check)
				ContinueLoop
			EndIf
			If MsgBox(4, "This adds to the everything", "Confirm To add Variant") <> 6 Then ContinueLoop
			Local $h_file
			_ArrayAdd($fullJSON, $newJSON)
			updateJSONVariants($fullJSON)
			GUISetState(@SW_ENABLE)
			ResizeGUI3(0)

		Case $b_e_save
			$input = GUICtrlRead($e_json)
			$newJSON = _JSON_Parse($input)
			$check = _checkVariant($newJSON)
			If IsString($check) Then
				MsgBox(16, "Error in Variant", $check)
				ContinueLoop
			EndIf
			If MsgBox(4, "This changes the Original", "pressing yes here will remove the original variant and replaces it with the new one") <> 6 Then ContinueLoop
			Local $h_file
			$variantnumber = StringRegExp(GUICtrlRead($c_variants), "[0-9]+", 3)[0]
			$fullJSON[$variantnumber - 1] = $newJSON
			updateJSONVariants($fullJSON)
			GUISetState(@SW_ENABLE)
			ResizeGUI3(0)
		Case $b_jsonentry

			Local $h_file, $skip = 0, $string[0]
			$variantnumber = StringRegExp(GUICtrlRead($c_variants), "[0-9]+", 3)[0]
			$fullJSON = _JSONLoad()
			$entry = $fullJSON[$variantnumber - 1]
			GUICtrlSetData($e_json, _JSON_MYGenerate($entry))
			ResizeGUI3()

		Case $GUI_EVENT_CLOSE
			Exit
		Case $b_close
			ProcessClose($run)
			$undervalue = 0
		Case $b_load

			Local $file = GUICtrlRead($i_file), $turn = GUICtrlRead($c_turn), $black = _IsChecked($r_black)
			$multiverse = _multiverse_create("pgn", $file, $turn, $black)
			GUICtrlSetColor($l_loaded, $COLOR_GREEN)
			GUICtrlSetData($l_loaded, "LOADED")
			GUICtrlSetState($b_clip, $GUI_ENABLE)
			If $variantloader = 1 Then
				GUICtrlSetState($b_addvariant, $GUI_ENABLE)
			EndIf
		Case $b_openfile
			GUICtrlSetData($i_file, FileOpenDialog("choose a pgn", @WorkingDir, "Text (*.txt)"))
		Case $b_addvariant
			$asdf = StringSplit(GUICtrlRead($i_file), "\")
			If $asdf[$asdf[0]] = "" Then $asdf[$asdf[0]] = "clipboard1234"
			$asdf = StringTrimRight($asdf[$asdf[0]], 4)
			Local $h_file, $input = _JSON_MYGenerate(_multiversetovariant($multiverse, $asdf, "pgn to variant"))
			_FileReadToArray($f_variantloader, $h_file)
			$h_temp = FileOpen($tempFile, 2)
			$k = 1
			GUISetState(@SW_DISABLE)
			For $i = 1 To $h_file[0] - 1
				If StringInStr($h_file[$i], "Name") > 0 Then
					$k += 1
				EndIf

				If $i = $h_file[0] - 1 Then
					FileWriteLine($h_temp, $h_file[$i] & ",")
				Else
					FileWriteLine($h_temp, $h_file[$i])
				EndIf

			Next
			$input = StringTrimRight($input, 2)
			FileWrite($h_temp, $input & @LF & "}" & @LF)
			FileWriteLine($h_temp, $h_file[$i])

			FileClose($h_temp)
			FileMove($tempFile, $f_variantloader, 1)
			GUISetState(@SW_ENABLE)
		Case $c_turn
			GUICtrlSetState($b_clip, $GUI_DISABLE)
			GUICtrlSetColor($l_loaded, $COLOR_RED)
			GUICtrlSetState($b_addvariant, $GUI_DISABLE)
			GUICtrlSetData($l_loaded, "unloaded")
		Case $r_black
			GUICtrlSetState($b_clip, $GUI_DISABLE)
			GUICtrlSetColor($l_loaded, $COLOR_RED)
			GUICtrlSetState($b_addvariant, $GUI_DISABLE)
			GUICtrlSetData($l_loaded, "unloaded")
		Case $b_json
			$f_variantloader = FileOpenDialog("Select any File in the data interface folder", @WorkingDir, "Files (*.*)")
			If @error <> 0 Then
				MsgBox(16, "closed out or not a file", "File selection failed pls try again")
			Else
				$stringsplit = StringSplit($f_variantloader, "\", 2)
				_ArrayDelete($stringsplit, UBound($stringsplit) - 1)
				$f_variantloader = _ArrayToString($stringsplit, "\") & "\Resources\JsonVariants.json"
				If FileExists($f_variantloader) Then
					$variantloader = 1
					If GUICtrlGetState($b_clip) <> 144 Then GUICtrlSetState($b_addvariant, $GUI_ENABLE)
					IniWrite($ini, $Region, $value1, $f_variantloader)
					ResizeGUI()
				Else
					MsgBox(16, "Wrong File", "I couldnt find the json file this data interface is using, pls try again")
				EndIf
			EndIf

		Case $b_clip
			ClipPut(_JSON_MYGenerate(_multiversetovariant($multiverse, "5D Chess Game", "pgn to variant")))

		Case $b_delvar
			If MsgBox(4, "REALLY???", "REALLY REALLY????") = 6 Then
				Local $h_file, $skip = 0, $string = ""

				$variantnumber = StringRegExp(GUICtrlRead($c_variants), "[0-9]+", 3)[0]
				_FileReadToArray($f_variantloader, $h_file)

				$k = 0
				GUISetState(@SW_DISABLE)
				For $i = 1 To $h_file[0] - 1
					If StringInStr($h_file[$i], "Name") > 0 Then
						$k += 1
					EndIf
					If $k = $variantnumber Then
						$skip = 1
					EndIf
					If $k = $variantnumber + 1 Then
						$skip = 0
					EndIf

					If $skip = 0 Then
						$string &= $h_file[$i] & @LF
					EndIf
				Next
				While ($string <> "" And StringRight($string, 1) <> "}")
					$string = StringTrimRight($string, 1)
				WEnd
				$string &= @LF & "]"
				FileWrite($tempFile, $string)

				FileMove($tempFile, $f_variantloader, 1)
				GUISetState(@SW_ENABLE)
			EndIf
		Case $b_variantloader
			$stringsplit = StringSplit($f_variantloader, "\", 2)
			_ArrayDelete($stringsplit, UBound($stringsplit) - 1)
			_ArrayDelete($stringsplit, UBound($stringsplit) - 1)
			$string = _ArrayToString($stringsplit, "\")
			$string2 = $string & "\DataInterfaceConsole.exe"
			ResizeGUI2()
			$run = Run($string2, $string, @SW_HIDE, BitOR($STDOUT_CHILD, $STDIN_CHILD, $STDERR_CHILD))
			If @error = 0 Then
				$running = 1
			EndIf
		Case $b_run
			StdinWrite($run, "1" & @LF)
			$stdinwrite = StringRegExp(GUICtrlRead($c_variants), "[0-9]+", 3)
			If IsArray($stdinwrite) Then StdinWrite($run, $stdinwrite[0] & @LF)
		Case $b_timerL
			_inputbox()
			If ($time And $delay) Then
				StdinWrite($run, "3" & @LF)
				Sleep($sleep)
				StdinWrite($run, "6" & @LF)
				Sleep($sleep)
				StdinWrite($run, $time & @LF)
				While Not StringInStr(StdoutRead($run), "Action executed. Returning to menu")
					Sleep(10)
				WEnd
				StdinWrite($run, "3" & @LF)
				Sleep($sleep)
				StdinWrite($run, "7" & @LF)
				Sleep($sleep)
				StdinWrite($run, $delay & @LF)
			ElseIf $time Then
				StdinWrite($run, "3" & @LF)
				Sleep($sleep)
				StdinWrite($run, "6" & @LF)
				Sleep($sleep)
				StdinWrite($run, $time & @LF)
			ElseIf $delay Then
				StdinWrite($run, "3" & @LF)
				Sleep($sleep)
				StdinWrite($run, "7" & @LF)
				Sleep($sleep)
				StdinWrite($run, $delay & @LF)
			EndIf

		Case $b_timerM
			_inputbox()
			If ($time And $delay) Then
				StdinWrite($run, "3" & @LF)
				Sleep($sleep)
				StdinWrite($run, "4" & @LF)
				Sleep($sleep)
				StdinWrite($run, $time & @LF)
				Sleep($sleep)
				StdinWrite($run, "3" & @LF)
				Sleep($sleep)
				StdinWrite($run, "5" & @LF)
				Sleep($sleep)
				StdinWrite($run, $delay & @LF)
			ElseIf $time Then
				StdinWrite($run, "3" & @LF)
				Sleep($sleep)
				StdinWrite($run, "4" & @LF)
				Sleep($sleep)
				StdinWrite($run, $time & @LF)
			ElseIf $delay Then
				StdinWrite($run, "3" & @LF)
				Sleep($sleep)
				StdinWrite($run, "5" & @LF)
				Sleep($sleep)
				StdinWrite($run, $delay & @LF)
			EndIf

		Case $b_timerS
			_inputbox()
			If ($time And $delay) Then
				StdinWrite($run, "3" & @LF)
				Sleep($sleep)
				StdinWrite($run, "2" & @LF)
				Sleep($sleep)
				StdinWrite($run, $time & @LF)
				Sleep($sleep)
				StdinWrite($run, "3" & @LF)
				Sleep($sleep)
				StdinWrite($run, "3" & @LF)
				Sleep($sleep)
				StdinWrite($run, $delay & @LF)
			ElseIf $time Then
				StdinWrite($run, "3" & @LF)
				Sleep($sleep)
				StdinWrite($run, "2" & @LF)
				Sleep($sleep)
				StdinWrite($run, $time & @LF)
			ElseIf $delay Then
				StdinWrite($run, "3" & @LF)
				Sleep($sleep)
				StdinWrite($run, "3" & @LF)
				Sleep($sleep)
				StdinWrite($run, $delay & @LF)
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
				StdinWrite($run, "3" & @LF)
				Sleep($sleep)
				StdinWrite($run, "1" & @LF)
				Sleep($sleep)
				StdinWrite($run, $animation & @LF)
			ElseIf $animation <> 0 Then
				MsgBox(16, "no valid number", "No valid number got parsed, setting left unchanged")
			EndIf
	EndSwitch
	If ((Not ProcessExists($run)) And $running) Then
		$running = 0
		If $undervalue Then
			MsgBox(16, "Variant Loader Closed", "something caused the Data Interface to exit, pls consult logfile")
			FileWrite(@ScriptDir & "\log.txt", StringRight($log,10000))
			$undervalue = 1
		EndIf
		GUICtrlSetState($b_variantloader, $GUI_ENABLE)
		GUICtrlSetState($b_json, $GUI_ENABLE)
	EndIf
	If ($running) Then
		$log &= StdoutRead($run)
		StringRight($log,10000)
	EndIf

	If ($running And $full = 0) Then
		GUICtrlSetState($b_variantloader, $GUI_DISABLE)
		GUICtrlSetState($b_json, $GUI_DISABLE)
		ResizeGUI2()
		$full = 1
	ElseIf ($running = 0 And $full) Then
		ResizeGUI2(0)
		$full = 0
	EndIf
	If $variantloader = 1 Then
		If (GUICtrlGetState($b_variantloader) = 144 And $running = 0) Then GUICtrlSetState($b_variantloader, $GUI_ENABLE)
		$h_file = ""
		$string = ""
		$data = ""
		$data2 = ""
		$f_variantloader = IniRead($ini, $Region, $value1, "")
		$c_time = _ArrayToString(FileGetTime($f_variantloader))
		If $c_time <> $l_time Then

			GUICtrlSetData($c_variants, "|")
			$data = _readvariants()
			$data2 = StringSplit($data, "|")
			If $nMsg = $b_delvar Then
				If $variantnumber - 1 = 0 Then $variantnumber = 2
				GUICtrlSetData($c_variants, $data, $data2[$variantnumber - 1])
			ElseIf $nMsg = $b_addvariant Or $nMsg = $b_e_add Then
				GUICtrlSetData($c_variants, $data, $data2[UBound($data2) - 1])
			ElseIf $nMsg = $b_e_save Then
				GUICtrlSetData($c_variants, $data, $data2[$variantnumber])
			Else
				GUICtrlSetData($c_variants, $data, $data2[1])
			EndIf

			If @error Then MsgBox(0, "", @error)
			$l_time = _ArrayToString(FileGetTime($f_variantloader))
		EndIf
	EndIf



WEnd

Func _JSON_MYGenerate($string)
	Return _JSON_Generate($string, "  ", @CRLF, "", " ", "  ", @CRLF)
EndFunc   ;==>_JSON_MYGenerate



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

EndFunc   ;==>_inputbox
Func _JSONLoad()
	$fileContent = FileRead($f_variantloader)
	$temp = _JSON_Parse($fileContent)
	Return $temp
EndFunc   ;==>_JSONLoad
Func _readvariants()

	$regexp = '\"Name": "[^"]+'
	$regexp2 = '\"Author": "[^"]+'
	$hnd_variantload = FileOpen($f_variantloader)
	$fileContent = FileRead($hnd_variantload)
	FileClose($hnd_variantload)
	$matches = StringRegExp($fileContent, $regexp, 3)
	$matches2 = StringRegExp($fileContent, $regexp2, 3)
	$string = ""

	For $i = 0 To UBound($matches) - 1
		$matches[$i] = StringTrimLeft($matches[$i], 9)
	Next

	For $i = 0 To UBound($matches2) - 1
		$matches2[$i] = StringTrimLeft($matches2[$i], 11)
		$string &= $i + 1 & ".  " & $matches[$i] & " by " & $matches2[$i] & "|"
	Next
	$string = StringTrimRight($string, 1)
	Return $string
EndFunc   ;==>_readvariants

Func _readinput()
	$file = GUICtrlRead($i_file)
	GUICtrlSetData($c_turn, "")
	If FileGetSize($file) > 0 Then
		_FileReadToArray($file, $lines)
		If $lines[1] = '[Mode "5D"]' Then
			Local $string = "-1|0|"

			#Region setstates
			GUICtrlSetColor($l_loaded, $COLOR_RED)
			GUICtrlSetData($l_loaded, "unloaded")
			GUICtrlSetState($b_load, $GUI_ENABLE)
			GUICtrlSetState($b_load, $GUI_SHOW)
			GUICtrlSetState($b_loadclipboard, $GUI_DISABLE)
			GUICtrlSetState($b_loadclipboard, $GUI_HIDE)
			GUICtrlSetState($c_turn, $GUI_ENABLE)
			GUICtrlSetState($r_black, $GUI_ENABLE)
			#EndRegion setstates

			For $i = 1 To $lines[0]
				If StringRegExp(StringLeft($lines[$i], 1), "[0-9]") Then
					$string &= StringRegExp($lines[$i], "[0-9]+", 3)[0] & "|"
				EndIf
			Next
			GUICtrlSetData($c_turn, $string, "-1")
		EndIf
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
EndFunc   ;==>_readinput
Func _IsChecked($idControlID)
	Return BitAND(GUICtrlRead($idControlID), $GUI_CHECKED) = $GUI_CHECKED
EndFunc   ;==>_IsChecked
Func ResizeGUI()
	Local $newHeight = 210
	Local $pos = WinGetPos($Form1_1)
	WinMove($Form1_1, "", Default, Default, $pos[2], $newHeight)
	GUICtrlSetState($c_variants, $GUI_SHOW)
	GUICtrlSetState($b_jsonentry, $GUI_SHOW)
	GUICtrlSetState($Label2, $GUI_SHOW)
	GUICtrlSetState($b_delvar, $GUI_SHOW)
EndFunc   ;==>ResizeGUI

Func ResizeGUI2($b = 1)
	If $b Then
		Local $newHeight = 210
		Local $pos = WinGetPos($Form1_1)
		WinMove($Form1_1, "", Default, Default, $pos[2], $newHeight)
		GUICtrlSetState($b_run, $GUI_SHOW)
		GUICtrlSetState($b_timerL, $GUI_SHOW)
		GUICtrlSetState($b_timerM, $GUI_SHOW)
		GUICtrlSetState($b_timerS, $GUI_SHOW)
		GUICtrlSetState($b_animation, $GUI_SHOW)
		GUICtrlSetState($b_close, $GUI_SHOW)
		GUICtrlSetState($cb_keepgameon, $GUI_SHOW)
	Else
		Local $newHeight = 210
		Local $pos = WinGetPos($Form1_1)
		WinMove($Form1_1, "", Default, Default, $pos[2], $newHeight)
		GUICtrlSetState($b_run, $GUI_HIDE)
		GUICtrlSetState($b_timerL, $GUI_HIDE)
		GUICtrlSetState($b_timerM, $GUI_HIDE)
		GUICtrlSetState($b_timerS, $GUI_HIDE)
		GUICtrlSetState($b_animation, $GUI_HIDE)
		GUICtrlSetState($b_close, $GUI_HIDE)
		GUICtrlSetState($cb_keepgameon, $GUI_HIDE)
	EndIf
EndFunc   ;==>ResizeGUI2

Func ResizeGUI3($b = 1)
	If $b Then

		Local $newWidth = 818
		Local $pos = WinGetPos($Form1_1)
		WinMove($Form1_1, "", Default, Default, $newWidth, $pos[3])
		GUICtrlSetState($e_json, $GUI_SHOW)
		GUICtrlSetState($b_e_close, $GUI_SHOW)
		GUICtrlSetState($b_e_save, $GUI_ENABLE)
		GUICtrlSetState($b_e_add, $GUI_ENABLE)
		GUICtrlSetState($b_e_save, $GUI_SHOW)
		GUICtrlSetState($b_e_add, $GUI_SHOW)
		GUICtrlSetState($c_variants, $GUI_DISABLE)
		GUICtrlSetState($b_delvar, $GUI_DISABLE)
	Else
		Local $newWidth = 420
		Local $pos = WinGetPos($Form1_1)
		WinMove($Form1_1, "", Default, Default, $newWidth, $pos[3])
		GUICtrlSetState($e_json, $GUI_HIDE)
		GUICtrlSetState($b_e_close, $GUI_HIDE)
		GUICtrlSetState($b_e_save, $GUI_HIDE)
		GUICtrlSetState($b_e_add, $GUI_HIDE)
		GUICtrlSetState($b_e_save, $GUI_DISABLE)
		GUICtrlSetState($b_e_add, $GUI_DISABLE)
		GUICtrlSetState($c_variants, $GUI_ENABLE)
		GUICtrlSetState($b_delvar, $GUI_ENABLE)
	EndIf


EndFunc   ;==>ResizeGUI3



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


Func updateJSONVariants($JSON)
	$h_temp = FileOpen($tempFile, 2)
	FileWrite($h_temp, _JSON_MYGenerate($JSON))
	FileClose($h_temp)
	FileMove($tempFile, $f_variantloader, 1)
EndFunc   ;==>updateJSONVariants


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
	$multiverse = _multiverse_create("variant", $JSON)
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

