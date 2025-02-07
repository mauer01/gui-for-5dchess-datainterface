#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=C:\Program Files (x86)\AutoIt3\Icons\au3.ico
#AutoIt3Wrapper_Outfile=out\gui for 5d datainterface.exe
#AutoIt3Wrapper_Run_Before=rmdir /S/Q out
#AutoIt3Wrapper_Run_Before=mkdir out
#AutoIt3Wrapper_Run_After=copy "gui for datainterface.ini" "out/gui for datainterface.ini"
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <include\multiversechess.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ColorConstants.au3>
$ini = @ScriptDir & "\gui for datainterface.ini"
#Region ### START Koda GUI section ### Form=
$title = "GUI for Data Interface"
$Form1_1 = GUICreate($title, 420, 210, 625, 277)
$b_variantloader = GUICtrlCreateButton("run interface", 328, 40, 75, 25)
$i_file = GUICtrlCreateInput("", 16, 8, 305, 21)
$b_openfile = GUICtrlCreateButton("OPEN", 328, 8, 75, 25)
$b_load = GUICtrlCreateButton("Load File", 170, 40, 67, 25)
GUICtrlSetState($b_variantloader,$GUI_DISABLE)
$b_addvariant = GUICtrlCreateButton("add variant", 160, 72, 155, 33)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$l_loaded = GUICtrlCreateLabel("unloaded", 248, 40, 67, 25)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
Guictrlsetcolor(-1,$COLOR_RED)
$c_turn = GUICtrlCreateCombo("-1", 56, 40, 57, 25)
$Label1 = GUICtrlCreateLabel("Move:", 8, 40, 46, 24)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
$b_json = GUICtrlCreateButton("Data Interface", 328, 65, 75, 25)
$b_jsonentry = GUICtrlCreateButton("Edit Entry", 328, 90, 75, 25)
$b_record = GUICtrlCreateButton("Setup Recording Games", 16, 72, 139, 33)
if recordexists() Then GUICtrlSetData(-1,"Record Game")
;~ $b_clip = GUICtrlCreateButton("Copy to Clipboard", 16, 72, 139, 33)
$b_clip = GUICtrlCreateDummy()
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$r_black = GUICtrlCreateCheckbox("Black", 120, 40, 49, 17)

GUICtrlSetState($b_addvariant,$GUI_DISABLE)
GUICtrlSetState($r_black,$GUI_DISABLE)
GUICtrlSetState($b_clip,$GUI_DISABLE)
GUICtrlSetState($b_load,$GUI_DISABLE)
GUICtrlSetState($c_turn,$GUI_DISABLE)
GUICtrlSetState($b_addvariant,$GUI_DISABLE)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
$text = GUICtrlRead($i_file)
$time = ""
$delay = ""
#Region set resizing
GUICtrlSetResizing($b_load,BitOr($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($i_file,BitOr($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($b_openfile,BitOr($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($b_variantloader,BitOr($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($l_loaded,BitOr($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($Label1,BitOr($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($b_clip,BitOr($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($b_record,BitOr($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($b_json,BitOr($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($b_jsonentry,BitOr($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($r_black,BitOr($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($c_turn,BitOr($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($b_addvariant,BitOr($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
#EndRegion
#Region bonus stuff
$c_variants = GUICtrlCreateCombo("", 56, 112, 249, 25,BITOr($WS_VSCROLL,$CBS_DROPDOWNLIST))
$b_delvar = GUICtrlCreateButton("Delete Variant", 328, 112, 75, 25)
$Label2 = GUICtrlCreateLabel("Variant:", 7, 112)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
GUICtrlSetState($c_variants,$GUI_HIDE)
GUICtrlSetState($b_delvar,$GUI_HIDE)
GUICtrlSetState($Label2,$GUI_HIDE)
GUICtrlSetState($b_jsonentry,$GUI_HIDE)
GUICtrlSetResizing($c_variants,BitOr($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($b_delvar,BitOr($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($Label2,BitOr($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
#EndRegion
#Region DataInterfaceButtons
$b_run = GUICtrlCreateButton("run variant",46,142,60)
$b_timerL = GUICtrlCreateButton("long timer",111,142,60)
$b_timerM = GUICtrlCreateButton("med timer",176,142,60)
$b_timerS = GUICtrlCreateButton("short timer",241,142,60)
$b_animation = GUICtrlCreateButton("travel animation",306,142,85)
$b_close = GUICtrlCreateButton("close",10,142,31)
$cb_keepgameon = GUICtrlCreateCheckbox("",400,142,20,20)
GUICtrlSetState($cb_keepgameon,$GUI_UNCHECKED)
GUICtrlSetState($b_close,$GUI_HIDE)
GUICtrlSetState($cb_keepgameon,$GUI_HIDE)
GUICtrlSetState($b_run,$GUI_HIDE)
GUICtrlSetState($b_timerL,$GUI_HIDE)
GUICtrlSetState($b_timerM,$GUI_HIDE)
GUICtrlSetState($b_timerS,$GUI_HIDE)
GUICtrlSetState($b_animation,$GUI_HIDE)
GUICtrlSetResizing($b_animation,BitOr($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($cb_keepgameon,BitOr($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($b_timerS,BitOr($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($b_close,BitOr($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($b_timerL,BitOr($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($b_timerM,BitOr($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($b_run,BitOr($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
#EndRegion
#Region Editbox
	$e_json = GUICtrlCreateEdit("", 420, 0, 400, 160)
	$b_e_close = GUICtrlCreateButton("Close", 420, 160, 75, 20)
	$b_e_save = GUICtrlCreateButton("Save", 495, 160, 75, 20)
	GUICtrlSetResizing($e_json,BitOr($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
	GUICtrlSetResizing($b_e_close,BitOr($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
	GUICtrlSetResizing($b_e_save,BitOr($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
	GUICtrlSetState($b_e_close,$GUI_HIDE)
	GUICtrlSetState($b_e_save,$GUI_HIDE)
	GUICtrlSetState($e_json,$GUI_HIDE)
#EndRegion
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
EndFunc ;==>MY_WM_COMMAND
#EndRegion

global $variantloader = 0,$l_time = 0,$f_variantloader,$sleep=100, $Region = "Data", $value1 = "Interface", $value2 = "User"
$variantnumber = 2
$gamerecord = 0
$run = 0
$running = 0
$full = 0
$undervalue = 1
OnAutoItExitRegister("_exit")
dim $lines

If FileExists($ini) Then
	$f_variantloader = IniRead($ini,$Region,$value1,"")
	$variantloader = 1
	$user = IniRead($ini,$Region,$value2,"")
Else
	WinMove($Form1_1,"",Default,Default,Default,136)
EndIf
if $variantloader = 1 Then
	ResizeGUI()
EndIf
$processname = "5dchesswithmultiversetimetravel.exe"
While 1
	If (ProcessExists($processname) and (not IsDeclared("location"))) then
		$location = _ProcessGetLocation($processname)
	Elseif (ProcessExists($processname) = 0 and IsDeclared("location") <> 0 and GUICtrlRead($cb_keepgameon) = $GUI_CHECKED) Then
		ShellExecute($location)
	EndIf
	If GUICtrlRead($b_record) = "Setup Recording Games" Then
		If recordexists() Then
			GUICtrlSetData($b_record,"Record Game")
		EndIf
	EndIf
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $b_e_close
			if MsgBox(4,"REALLY???","Without Changing anything????") = 6 Then ResizeGUI3(0)
		Case $b_e_save
			if MsgBox(4,"This changes the Original","pressing yes here will remove the original variant and replace it with the edit") <> 6 Then ContinueCase
			local $h_file, $input = StringSplit(GUICtrlRead($e_json),"\r\n",3)
			$variantnumber = StringRegExp(GUICtrlRead($c_variants),"[0-9]+",3)[0]
			_FileReadToArray($f_variantloader,$h_file)
			$h_temp = FileOpen(@TempDir & "\pgn to variant.txt",2)
			$k = 0
			$skip = 0
			$editzaehler = 0
			GUISetState(@SW_DISABLE)
			local $string[0]
			For $i = 1 to Ubound($h_file)-1
				If StringInStr($h_file[$i],"Name") > 0 Then
					$k += 1
				EndIf
				If $k = $variantnumber Then
					$skip = 1
				EndIf
				If $skip = 0 Then
					_ArrayAdd($string,$h_file[$i])
				EndIf

				If $k = $variantnumber+1 or $i = UBound($h_file)-1 Then
					_ArrayDelete($string,UBound($string)-1)
					$editzaehler = $i
					ExitLoop
				EndIf
			Next
			$editzaehler -= 1
			For $line in $input
				_ArrayAdd($string,$line)
			Next
			for $i = $editzaehler to UBound($h_file)-1
				_ArrayAdd($string,$h_file[$i])
			Next

			_FileWriteFromArray($h_temp,$string)
			FileClose($h_temp)
			FileMove(@TempDir & "\pgn to variant.txt",$f_variantloader,1)
			GUISetState(@SW_ENABLE)

			ResizeGUI3(0)
		Case $b_jsonentry

			local $h_file,$skip = 0,$string = ""
			$variantnumber = StringRegExp(GUICtrlRead($c_variants),"[0-9]+",3)[0]
			_FileReadToArray($f_variantloader,$h_file)
			$k = 0
			For $i = 1 to $h_file[0]-1
				If StringInStr($h_file[$i],"Name") > 0 Then
					$k += 1
				EndIf
				If $k = $variantnumber Then
					$skip = 1
				EndIf
				If $k = $variantnumber+1 Then
					$skip = 0
				EndIf

				If $skip = 1 Then
					$string &= $h_file[$i] & "\r\n"
				EndIf
			Next
			$string = "  {\r\n" & $string
			$string = StringTrimRight($string,11)
			GUICtrlSetData($e_json,StringFormat($string))
			ResizeGUI3()

		Case $GUI_EVENT_CLOSE
			Exit
		Case $b_record
			If Not recordexists() Then
				MsgBox(64,"Setup Recording Software","you need my recorder+ and at best penteracts 5DPGNRecorderAndTimeReminder")
			ElseIf GUICtrlRead($b_record) = "Record Game" Then
				$gamerecord = Run("5d chess game recorder+.exe user" & $user,"",@SW_HIDE,BitOR($STDOUT_CHILD,$STDIN_CHILD))
				If @error then
					MsgBox(16,"","error in opening the recorder+.exe")
					ContinueCase
				EndIf
				GUICtrlSetData($b_record,"Stop Recording")
				WinSetTitle($Form1_1,WinGetText($Form1_1),$title & " - Recording")
			ElseIf GUICtrlRead($b_record) = "Stop Recording" Then
				ProcessClose($gamerecord)
				GUICtrlSetData($b_record,"Record Game")
			EndIf
		Case $b_close
			ProcessClose($run)
			$undervalue = 0
		Case $b_load
			local $file = GUICtrlRead($i_file),$turn = GUICtrlRead($c_turn),$black = _IsChecked($r_black)
			$multiverse = _multiverse_create("pgn",$file,$turn,$black)
			GUICtrlSetColor($l_loaded,$COLOR_GREEN)
			GUICtrlSetData($l_loaded,"LOADED")
			GUICtrlSetState($b_clip,$GUI_ENABLE)
			If $variantloader = 1 Then
				GUICtrlSetState($b_addvariant,$GUI_ENABLE)
			EndIf
		Case $b_openfile
			GUICtrlSetData($i_file,FileOpenDialog("choose a pgn",@WorkingDir,"Text (*.txt)"))
		Case $b_addvariant
			$asdf = StringSplit(GUICtrlRead($i_file),"\")
			$asdf = StringTrimRight($asdf[$asdf[0]],4)
			local $h_file, $input = _multiversetovariant($multiverse,$asdf,"pgn to variant")
			_FileReadToArray($f_variantloader,$h_file)
			$h_temp = FileOpen(@TempDir & "\pgn to variant.txt",2)
			$k = 1
			GUISetState(@SW_DISABLE)
			For $i = 1 to $h_file[0]-1
				If StringInStr($h_file[$i],"Name") > 0 Then
					$k+=1
				EndIf

				If $i = $h_file[0]-1 Then
					FileWriteLine($h_temp,$h_file[$i] & ",")
				Else
					FileWriteLine($h_temp,$h_file[$i])
				EndIf

			Next
			$input = StringTrimRight($input,2)
			FileWrite($h_temp,$input & @LF)
			FileWriteLine($h_temp,$h_file[$i])

			FileClose($h_temp)
			FileMove(@TempDir & "\pgn to variant.txt",$f_variantloader,1)
			GUISetState(@SW_ENABLE)
		Case $c_turn
			GUICtrlSetState($b_clip,$GUI_DISABLE)
			Guictrlsetcolor($l_loaded,$COLOR_RED)
			GUICtrlSetState($b_addvariant,$GUI_DISABLE)
			GUICtrlSetData($l_loaded,"unloaded")
		Case $r_black
			GUICtrlSetState($b_clip,$GUI_DISABLE)
			Guictrlsetcolor($l_loaded,$COLOR_RED)
			GUICtrlSetState($b_addvariant,$GUI_DISABLE)
			GUICtrlSetData($l_loaded,"unloaded")
		Case $b_json
			$f_variantloader = FileOpenDialog("Select any File in the data interface folder",@WorkingDir,"Files (*.*)")
			if @error <> 0 Then
				MsgBox(16,"closed out or not a file","File selection failed pls try again")
			Else
				$stringsplit = StringSplit($f_variantloader,"\",2)
				_ArrayDelete($stringsplit,UBound($stringsplit)-1)
				$f_variantloader = _ArrayToString($stringsplit,"\") & "\Resources\JsonVariants.json"
				If FileExists($f_variantloader) Then
					$variantloader = 1
					If GUICtrlGetState($b_clip) <> 144 Then GUICtrlSetState($b_addvariant,$GUI_ENABLE)
					IniWrite($ini,$Region,$value1,$f_variantloader)
					ResizeGUI()
				Else
					MsgBox(16,"Wrong File","I couldnt find the json file this data interface is using, pls try again")
				EndIf
			EndIf

		Case $b_clip
			ClipPut(_multiversetovariant($multiverse))

		Case $b_delvar
			if MsgBox(4,"REALLY???","REALLY REALLY????") = 6 Then
				local $h_file,$skip = 0,$string = ""

				$variantnumber = StringRegExp(GUICtrlRead($c_variants),"[0-9]+",3)[0]
				_FileReadToArray($f_variantloader,$h_file)

				$k = 0
				GUISetState(@SW_DISABLE)
				For $i = 1 to $h_file[0]-1
					If StringInStr($h_file[$i],"Name") > 0 Then
						$k += 1
					EndIf
					If $k = $variantnumber Then
						$skip = 1
					EndIf
					If $k = $variantnumber+1 Then
						$skip = 0
					EndIf

					If $skip = 0 Then
						$string &= $h_file[$i] & @LF
					EndIf
				Next
				while ($string <> "" and StringRight($string,1) <> "}")
						$string = StringTrimRight($string,1)
				WEnd
				$string &= @LF & "]"
				FileWrite(@TempDir & "\pgn to variant.txt",$string)

				FileMove(@TempDir & "\pgn to variant.txt",$f_variantloader,1)
				GUISetState(@SW_ENABLE)
			EndIf
		Case $b_variantloader
			$stringsplit = StringSplit($f_variantloader,"\",2)
			_ArrayDelete($stringsplit,UBound($stringsplit)-1)
			_ArrayDelete($stringsplit,UBound($stringsplit)-1)
			$string = _ArrayToString($stringsplit, "\")
			$string2 = $string & "\DataInterfaceConsole.exe"
			ResizeGUI2()
			$run = Run($string2,$string,@SW_HIDE,BitOR($STDOUT_CHILD,$STDIN_CHILD,$STDERR_CHILD))
			If @error = 0 Then
				$running = 1
			EndIf
		Case $b_run
			StdinWrite($run,"1" & @LF)
			$stdinwrite = StringRegExp(GUICtrlRead($c_variants),"[0-9]+",3)
			if IsArray($stdinwrite) Then StdinWrite($run, $stdinwrite[0] & @LF)
		Case $b_timerL
			_inputbox()
			if ($time and $delay) Then
				StdinWrite($run,"3" & @LF)
				sleep($sleep)
				StdinWrite($run,"6" & @LF)
				sleep($sleep)
				StdinWrite($run,$time & @LF)
				While not StringInStr(StdoutRead($run),"Action executed. Returning to menu")
					Sleep(10)
				WEnd
				StdinWrite($run,"3" & @LF)
				sleep($sleep)
				StdinWrite($run,"7" & @LF)
				sleep($sleep)
				StdinWrite($run, $delay & @LF)
			ElseIf $time Then
				StdinWrite($run,"3" & @LF)
				sleep($sleep)
				StdinWrite($run,"6" & @LF)
				sleep($sleep)
				StdinWrite($run,$time & @LF)
			ElseIf $delay Then
				StdinWrite($run,"3" & @LF)
				sleep($sleep)
				StdinWrite($run,"7" & @LF)
				sleep($sleep)
				StdinWrite($run, $delay & @LF)
			EndIf

		Case $b_timerM
			_inputbox()
			if ($time and $delay) Then
				StdinWrite($run,"3" & @LF)
				sleep($sleep)
				StdinWrite($run,"4" & @LF)
				sleep($sleep)
				StdinWrite($run,$time & @LF)
				sleep($sleep)
				StdinWrite($run,"3" & @LF)
				sleep($sleep)
				StdinWrite($run,"5" & @LF)
				sleep($sleep)
				StdinWrite($run, $delay & @LF)
			ElseIf $time Then
				StdinWrite($run,"3" & @LF)
				sleep($sleep)
				StdinWrite($run,"4" & @LF)
				sleep($sleep)
				StdinWrite($run,$time & @LF)
			ElseIf $delay Then
				StdinWrite($run,"3" & @LF)
				sleep($sleep)
				StdinWrite($run,"5" & @LF)
				sleep($sleep)
				StdinWrite($run, $delay & @LF)
			EndIf

		Case $b_timerS
			_inputbox()
			if ($time and $delay) Then
				StdinWrite($run,"3" & @LF)
				sleep($sleep)
				StdinWrite($run,"2" & @LF)
				sleep($sleep)
				StdinWrite($run,$time & @LF)
				sleep($sleep)
				StdinWrite($run,"3" & @LF)
				sleep($sleep)
				StdinWrite($run,"3" & @LF)
				sleep($sleep)
				StdinWrite($run, $delay & @LF)
			ElseIf $time Then
				StdinWrite($run,"3" & @LF)
				sleep($sleep)
				StdinWrite($run,"2" & @LF)
				sleep($sleep)
				StdinWrite($run,$time & @LF)
			ElseIf $delay Then
				StdinWrite($run,"3" & @LF)
				sleep($sleep)
				StdinWrite($run,"3" & @LF)
				sleep($sleep)
				StdinWrite($run, $delay & @LF)
			EndIf

		Case $b_animation
			$animation = InputBox("Force timetravel animation","force the way the game handles the time travel animation" & @LF & "1 or ignore" & @LF & "2 or always_on" & @LF &"3 or  always_off",3)
			If (not Number($animation)) Then
				Switch $animation
					Case "ignore"
						$animation = 1
					Case "always_on"
						$animation = 2
					Case "always_off"
						$animation = 3
					Case Else
						MsgBox(16,"no valid string","No valid string put in,setting left unchanged")
						$animation = 0
				EndSwitch
			EndIf
			if ($animation < 4 and $animation) Then
				StdinWrite($run,"3" & @LF)
				sleep($sleep)
				StdinWrite($run,"1" & @LF)
				sleep($sleep)
				StdinWrite($run,$animation & @LF)
			ElseIf $animation <> 0 Then
				MsgBox(16,"no valid number","No valid number got parsed, setting left unchanged")
			EndIf
	EndSwitch
	if ((Not ProcessExists($run)) and $running) Then
		$running = 0
		if $undervalue Then
			MsgBox(16,"Variant Loader Closed","something caused the Data Interface to exit")
			$undervalue = 1
		EndIf
		GUICtrlSetState($b_variantloader,$GUI_ENABLE)
		GUICtrlSetState($b_json,$GUI_ENABLE)
	EndIf
	if ($running And $full = 0) Then
		GUICtrlSetState($b_variantloader,$GUI_DISABLE)
		GUICtrlSetState($b_json,$GUI_DISABLE)
		ResizeGUI2()
		$full = 1
	ElseIf ($running = 0 And $full) Then
		ResizeGUI2(0)
		$full = 0
	EndIf
	If $variantloader = 1 Then
		if (GUICtrlGetState($b_variantloader) = 144 and $running = 0) Then GUICtrlSetState($b_variantloader,$GUI_ENABLE)
		$h_file = ""
		$string = ""
		$data = ""
		$data2 = ""
		$f_variantloader = IniRead($ini,$Region,$value1,"")
		$c_time = _ArrayToString(FileGetTime($f_variantloader))
		if $c_time <> $l_time Then
			GUICtrlSetData($c_variants,"|")
			$data = _readvariants()
			$data2 = StringSplit($data,"|")
			If $nMsg = $b_delvar Then
				if $variantnumber-1 = 0 then $variantnumber = 2
				GUICtrlSetData($c_variants,$data,$data2[$variantnumber-1])
			ElseIf $nMsg = $b_addvariant Then
				GUICtrlSetData($c_variants,$data,$data2[$k])
			Else
				GUICtrlSetData($c_variants,$data,$data2[1])
			EndIf

			if @error Then MsgBox(0,"",@error)
			$l_time = _ArrayToString(FileGetTime($f_variantloader))
		EndIf
	EndIf

	if ProcessExists($gamerecord) Then
		$read = StdoutRead($gamerecord)
		if StringLen($read) Then
			GUICtrlSetData($i_file,$read)
			GUICtrlSetState($i_file,$GUI_ENABLE)
			GUICtrlSetData($b_record,"Record Game")
			GUICtrlSetState($b_openfile,$GUI_ENABLE)
			WinSetTitle($Form1_1,WinGetText($Form1_1),$title)
			StdinWrite($gamerecord,"next")
		EndIf
	EndIf

WEnd


func _inputbox()
	$time = InputBox("Time for each player","Set the time each player has in seconds (reset to reset)" & @LF & "Or use the 00:00:00 (hh:mm:ss) format")
	$delay = InputBox("Delay per active timeline","set the delay in seconds (reset to reset)" & @LF & "Or use the 00:00:00 (hh:mm:ss) format")
	if StringInStr($time,":") Then
		$string = StringSplit($time,":",2)
		$string[1] += $string[0]*60
		$string[2] += $string[1]*60
		$time = $string[2]
	EndIf
	if StringInStr($delay,":") Then
		$string = StringSplit($delay,":",2)
		$string[1] += $string[0]*60
		$string[2] += $string[1]*60
		$delay = $string[2]
	EndIf
	if Number($delay) Then
		$delay = Execute($delay)
	EndIf
	If Number($time) Then
		$time = Execute($time)
	EndIf


EndFunc
Func _readvariants()

	$regexp = '\"Name": "[^"]+'
	$regexp2 = '\"Author": "[^"]+'
	$hnd_variantload = FileOpen($f_variantloader)
	$fileContent = FileRead($hnd_variantload)
	FileClose($hnd_variantload)
	$matches = StringRegExp($fileContent,$regexp, 3)
	$matches2 = StringRegExp($fileContent,$regexp2, 3)
	$string = ""

	For $i = 0 to UBound($matches)-1
		$matches[$i] = StringTrimLeft($matches[$i],9)
	Next

	For $i = 0 to UBound($matches2)-1
		$matches2[$i] = StringTrimLeft($matches2[$i],11)
		$string &= $i+1 & ".  " & $matches[$i] & " by " & $matches2[$i] & "|"
	Next
	$string = StringTrimRight($string,1)
	Return $string
EndFunc

Func _readinput()
	$file = GUICtrlRead($i_file)
	GUICtrlSetData($c_turn,"")
	If FileGetSize($file) > 0 Then
		_FileReadToArray($file,$lines)
		if $lines[1] = '[Mode "5D"]' Then
			local $string = "-1|0|"

			#region setstates
			Guictrlsetcolor($l_loaded,$COLOR_RED)
			GUICtrlSetData($l_loaded,"unloaded")
			GUICtrlSetState($b_load,$GUI_ENABLE)
			GUICtrlSetState($c_turn,$GUI_ENABLE)
			GUICtrlSetState($r_black,$GUI_ENABLE)
			#EndRegion

			For $i = 1 to $lines[0]
				if StringRegExp(StringLeft($lines[$i],1),"[0-9]") Then
					$string &= StringRegExp($lines[$i],"[0-9]+",3)[0] & "|"
				EndIf
			Next
			GUICtrlSetData($c_turn,$string,"-1")
		EndIf
	Else
		GUICtrlSetData($c_turn,"")
		GUICtrlSetState($b_addvariant,$GUI_DISABLE)
		GUICtrlSetState($r_black,$GUI_DISABLE)
		GUICtrlSetState($b_clip,$GUI_DISABLE)
		GUICtrlSetState($b_load,$GUI_DISABLE)
		GUICtrlSetState($c_turn,$GUI_DISABLE)
		Guictrlsetcolor($l_loaded,$COLOR_RED)
		GUICtrlSetData($l_loaded,"unloaded")
	EndIf
EndFunc
Func _IsChecked($idControlID)
	Return BitAND(GUICtrlRead($idControlID), $GUI_CHECKED) = $GUI_CHECKED
EndFunc   ;==>_IsChecked
Func ResizeGUI()
	Local $newHeight = 210
	Local $pos = WinGetPos($Form1_1)
	WinMove($Form1_1, "", Default, Default, $pos[2], $newHeight)
	Guictrlsetstate($c_variants,$GUI_SHOW)
	GUICtrlSetState($b_jsonentry,$GUI_SHOW)
	Guictrlsetstate($Label2,$GUI_SHOW)
	Guictrlsetstate($b_delvar,$GUI_SHOW)
EndFunc

Func ResizeGUI2($b = 1)
	if $b Then
		Local $newHeight = 210
		Local $pos = WinGetPos($Form1_1)
		WinMove($Form1_1, "", Default, Default, $pos[2], $newHeight)
		GUICtrlSetState($b_run,$GUI_SHOW)
		GUICtrlSetState($b_timerL,$GUI_SHOW)
		GUICtrlSetState($b_timerM,$GUI_SHOW)
		GUICtrlSetState($b_timerS,$GUI_SHOW)
		GUICtrlSetState($b_animation,$GUI_SHOW)
		GUICtrlSetState($b_close,$GUI_SHOW)
		GUICtrlSetState($cb_keepgameon,$GUI_SHOW)
	Else
		Local $newHeight = 210
		Local $pos = WinGetPos($Form1_1)
		WinMove($Form1_1, "", Default, Default, $pos[2], $newHeight)
		GUICtrlSetState($b_run,$GUI_HIDE)
		GUICtrlSetState($b_timerL,$GUI_HIDE)
		GUICtrlSetState($b_timerM,$GUI_HIDE)
		GUICtrlSetState($b_timerS,$GUI_HIDE)
		GUICtrlSetState($b_animation,$GUI_HIDE)
		GUICtrlSetState($b_close,$GUI_HIDE)
		GUICtrlSetState($cb_keepgameon,$GUI_HIDE)
	EndIf
EndFunc

Func ResizeGUI3($b = 1)
	If $b Then

		local $newWidth = 818
		Local $pos = WinGetPos($Form1_1)
		WinMove($Form1_1,"",Default,Default, $newWidth,$pos[3])
		GUICtrlSetState($e_json,$GUI_SHOW)
		GUICtrlSetState($b_e_close,$GUI_SHOW)
		GUICtrlSetState($b_e_save,$GUI_SHOW)
		GUICtrlSetState($c_variants,$GUI_DISABLE)
	Else
		local $newWidth = 420
		Local $pos = WinGetPos($Form1_1)
		WinMove($Form1_1,"",Default,Default, $newWidth,$pos[3])
		GUICtrlSetState($e_json,$GUI_SHOW)
		GUICtrlSetState($b_e_close,$GUI_SHOW)
		GUICtrlSetState($b_e_save,$GUI_SHOW)
		GUICtrlSetState($c_variants,$GUI_ENABLE)
	EndIf


EndFunc


Func _exit()
	ProcessClose($run)
	ProcessClose($gamerecord)
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
EndFunc

Func recordexists()
	If not FileExists("5d chess game recorder+.exe") then Return False
	If not FileExists("5DPGNRecorderAndTimeReminder.exe") then Return False
	Return True
EndFunc