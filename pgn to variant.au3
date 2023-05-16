#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=C:\Program Files (x86)\AutoIt3\Icons\au3.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <multiversechess.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ColorConstants.au3>
$ini = @ScriptDir & "\pgn to variant.ini"
#Region ### START Koda GUI section ### Form=
$Form1_1 = GUICreate("Variant from pgn", 418, 180, 625, 277)
$b_load = GUICtrlCreateButton("Load File", 248, 40, 67, 25)
$i_file = GUICtrlCreateInput("", 16, 8, 305, 21)
$b_openfile = GUICtrlCreateButton("OPEN", 328, 8, 75, 25)
$b_readfile = GUICtrlCreateButton("Read File", 170, 40, 67, 25)
$b_addvariant = GUICtrlCreateButton("add variant", 160, 72, 155, 33)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$l_loaded = GUICtrlCreateLabel("unloaded", 328, 40, 80, 25)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
Guictrlsetcolor(-1,$COLOR_RED)
$c_turn = GUICtrlCreateCombo("-1", 56, 40, 57, 25)
$Label1 = GUICtrlCreateLabel("Move:", 8, 40, 46, 24)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
$b_json = GUICtrlCreateButton("Variant Loader", 328, 72, 75, 25)
$b_clip = GUICtrlCreateButton("Copy to Clipboard", 16, 72, 139, 33)
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

#Region set resizing
GUICtrlSetResizing($b_load,BitOr($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($i_file,BitOr($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($b_openfile,BitOr($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($b_readfile,BitOr($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($l_loaded,BitOr($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($Label1,BitOr($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($b_clip,BitOr($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($b_json,BitOr($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
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
GUICtrlSetResizing($c_variants,BitOr($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($b_delvar,BitOr($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
GUICtrlSetResizing($Label2,BitOr($GUI_DOCKTOP, $GUI_DOCKLEFT, $GUI_DOCKSIZE))
#EndRegion
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
global $variantloader = 0,$l_time = 0,$f_variantloader
$variantnumber = 2
dim $lines
If FileExists($ini) Then
	$f_variantloader = IniRead($ini,"sdfgf","sdfg","")
	$variantloader = 1
Else
	WinMove($Form1_1,"",Default,Default,Default,136)
EndIf
if $variantloader = 1 Then
	ResizeGUI()
EndIf

While 1

	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit


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
			MsgBox(0,Guictrlread($i_file),"Automatically added as Variant number: " & $k)
			FileWriteLine($h_temp,$h_file[$i])

			FileClose($h_temp)
			FileMove(@TempDir & "\pgn to variant.txt",$f_variantloader,1)
			GUISetState(@SW_ENABLE)
		Case $c_turn
			GUICtrlSetState($b_clip,$GUI_DISABLE)
			Guictrlsetcolor($l_loaded,$COLOR_RED)
			GUICtrlSetState($b_addvariant,$GUI_DISABLE)
			GUICtrlSetData($l_loaded,"unloaded")
		Case $b_json
			$f_variantloader = FileOpenDialog("Select any File in the data interface folder",@WorkingDir,"Files (*.*)")
			$stringsplit = StringSplit($f_variantloader,"\",2)
			_ArrayDelete($stringsplit,UBound($stringsplit)-1)
			$f_variantloader = _ArrayToString($stringsplit,"\") & "\Resources\JsonVariants.json"
			If FileExists($f_variantloader) Then
				$variantloader = 1
				If GUICtrlGetState($b_clip) <> 144 Then GUICtrlSetState($b_addvariant,$GUI_ENABLE)
				IniWrite($ini,"sdfgf","sdfg",$f_variantloader)
				ResizeGUI()
			EndIf

		Case $b_clip
			ClipPut(_multiversetovariant($multiverse))

		Case $b_delvar
			local $h_file,$skip = 0,$string = ""

			$variantnumber = StringRegExp(GUICtrlRead($c_variants),"[1-9]+",3)[0]
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
			If $skip = 1 Then
				while ($string <> "" and StringRight($string,1) <> "}")
					$string = StringTrimRight($string,1)
				WEnd
				$string &= @LF & "]"
			EndIf
			FileWrite(@TempDir & "\pgn to variant.txt",$string)

			FileMove(@TempDir & "\pgn to variant.txt",$f_variantloader,1)
			GUISetState(@SW_ENABLE)


	EndSwitch

	If $variantloader = 1 Then

		$h_file = ""
		$string = ""
		$data = ""
		$data2 = ""
		$f_variantloader = IniRead($ini,"sdfgf","sdfg","")
		$c_time = _ArrayToString(FileGetTime($f_variantloader))
		if $c_time <> $l_time Then
			GUICtrlSetData($c_variants,"|")
			$data = _readvariants()
			$data2 = StringSplit($data,"|")
			If $nMsg = $b_delvar Then
				GUICtrlSetData($c_variants,$data,$data2[$variantnumber-1])
			Else
				GUICtrlSetData($c_variants,$data,$data2[1])
			EndIf

			if @error Then MsgBox(0,"",@error)
			$l_time = _ArrayToString(FileGetTime($f_variantloader))
		EndIf
	EndIf

WEnd

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
	If FileGetSize($file) > 0 Then
		_FileReadToArray($file,$lines)
		if $lines[1] = '[Mode "5D"]' Then
			local $string = "0|"
			Guictrlsetcolor($l_loaded,$COLOR_RED)
			GUICtrlSetData($l_loaded,"unloaded")
			GUICtrlSetState($b_load,$GUI_ENABLE)

			GUICtrlSetState($c_turn,$GUI_ENABLE)
			GUICtrlSetState($r_black,$GUI_ENABLE)
			For $i = 1 to StringRegExp($lines[$lines[0]],"[0-9]+",3)[0]
				$string &= $i & "|"
			Next
			GUICtrlSetData($c_turn,$string)
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
    Local $newWidth = 418
    Local $newHeight = 180
	Local $pos = WinGetPos($Form1_1)
    WinMove($Form1_1, "", Default, Default, $newWidth, $newHeight)


	Guictrlsetstate($c_variants,$GUI_SHOW)
	Guictrlsetstate($Label2,$GUI_SHOW)
	Guictrlsetstate($b_delvar,$GUI_SHOW)
EndFunc
