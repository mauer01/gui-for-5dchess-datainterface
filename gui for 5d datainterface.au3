#include-once
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <WindowsConstants.au3>
Func _MainGui($context)
	#Region ### START Koda GUI section ### Form=.\kodaForms\main.kxf
	Local $main = GUICreate("Gui for Datainterface", 604, 210, 1140, 268)
	Local $tab = GUICtrlCreateTab(0, 0, 601, 209)
	Local $tJsonLoader = GUICtrlCreateTabItem("JSON Loader")
	GUIStartGroup()
	Local $iJsonFileNewPath = GUICtrlCreateInput("", 8, 34, 225, 21)
	Local $bAddJsonFile = GUICtrlCreateButton("Add", 240, 32, 35, 25, $BS_PUSHLIKE)
	GUIStartGroup()
	GUIStartGroup()
	Local $cRemoteJsons = GUICtrlCreateCombo("", 8, 66, 225, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
	Local $bRemoteJsonDownload = GUICtrlCreateButton("Download", 240, 64, 67, 25)
	GUIStartGroup()
	GUIStartGroup()
	Local $cLocalJsonFiles = GUICtrlCreateCombo("", 8, 98, 225, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
	Local $bLocalJsonFileRemove = GUICtrlCreateButton("Remove", 240, 96, 50, 25)
	Local $bLocalJsonFileCopy = GUICtrlCreateButton("Copy", 294, 96, 50, 25)
	Local $bLocalJsonFileRename = GUICtrlCreateButton("Rename", 348, 96, 50, 25)
	Local $bLocalJsonFileBackup = GUICtrlCreateButton("Backup", 402, 96, 50, 25)
	Local $bOpenJsonFolder = GUICtrlCreateButton("Open Folder", 456, 96, 75, 25)
	GUIStartGroup()
	GUIStartGroup()
	Local $cListOfVariants = GUICtrlCreateCombo("", 8, 130, 225, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
	Local $bRunVariant = GUICtrlCreateButton("Run", 240, 128, 43, 25)
	Local $bVariantRemove = GUICtrlCreateButton("Remove", 288, 128, 59, 25)
	Local $bVariantEdit = GUICtrlCreateButton("Edit", 352, 128, 43, 25)
	GUIStartGroup()
	GUIStartGroup()
	Local $bAddVariantfromClip = GUICtrlCreateButton("Clipboard", 168, 160, 75, 25)
	Local $laddSpecifier = GUICtrlCreateLabel("Add new Variant via Methods:", 16, 165, 146, 17)
	Local $bAddVariantFromFile = GUICtrlCreateButton("Textfile", 248, 160, 59, 25)
	Local $baddVariantsFromJsonFile = GUICtrlCreateButton("Combine JsonFiles", 312, 160, 115, 25)
	GUIStartGroup()
	Local $tSettings = GUICtrlCreateTabItem("Settings")
	GUIStartGroup()
	Local $cClocks = GUICtrlCreateCombo("Clocks", 8, 32, 145, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "Long|Medium|Short")
	Local $iClockTime = GUICtrlCreateInput("Time", 8, 56, 65, 21)
	Local $iClockDelay = GUICtrlCreateInput("Delay", 88, 56, 65, 21)
	Local $bClockSet = GUICtrlCreateButton("Set ", 160, 56, 51, 25)
	Local $bClockReset = GUICtrlCreateButton("Reset to default", 160, 32, 91, 25)
	Local $Label1 = GUICtrlCreateLabel("+", 76, 58, 10, 17)
	GUIStartGroup()
	GUIStartGroup()
	Local $cbUndoMove = GUICtrlCreateCheckbox("Undo Move", 8, 96, 89, 17)
	Local $cbRestartGameOnCrash = GUICtrlCreateCheckbox("Restart Game on Crash", 8, 112, 129, 17)
	GUIStartGroup()
	GUIStartGroup()
	Local $lTravelAnimations = GUICtrlCreateLabel("Travel Animations:", 264, 96, 91, 17)
	Local $rAnimationsAlwaysOn = GUICtrlCreateRadio("Always On", 280, 112, 113, 17)
	Local $rAnimationsAlwaysOff = GUICtrlCreateRadio("Always Off", 280, 128, 113, 17)
	Local $rAnimationsIgnore = GUICtrlCreateRadio("Ignore", 280, 144, 113, 17)
	GUIStartGroup()
	GUIStartGroup()
	Local $bInsertCode = GUICtrlCreateButton("Insert Room Code", 144, 96, 107, 25)
	Local $bResumeGame = GUICtrlCreateButton("Resume Game", 144, 120, 107, 25)
	GUIStartGroup()
	Local $tPgnLoader = GUICtrlCreateTabItem("PGN Loader")
	GUICtrlSetState(-1, $GUI_SHOW)
	GUIStartGroup()
	Local $iPgnLoaderPath = GUICtrlCreateInput("", 8, 32, 217, 21)
	Local $bPgnAdd = GUICtrlCreateButton("Add", 232, 32, 51, 25)
	Local $bPgnOpenPath = GUICtrlCreateButton("Choose Path", 288, 32, 75, 25)
	GUIStartGroup()
	GUIStartGroup()
	Local $bPgnAddClipboard = GUICtrlCreateButton("Add from Clipboard", 8, 64, 107, 25)
	GUIStartGroup()
	GUIStartGroup()
	Local $cPgnList = GUICtrlCreateCombo("cPgnList", 8, 96, 217, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
	Local $bPgnRun = GUICtrlCreateButton("Run", 232, 96, 51, 25)
	Local $bPgnRemove = GUICtrlCreateButton("Remove", 288, 96, 51, 25)
	Local $bPgnEdit = GUICtrlCreateButton("Edit", 344, 96, 43, 25)
	GUIStartGroup()
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				Exit

			Case $main
			Case $tab
			Case $bAddJsonFile
			Case $cRemoteJsons
			Case $bRemoteJsonDownload
			Case $cLocalJsonFiles
			Case $bLocalJsonFileRemove
			Case $bLocalJsonFileCopy
			Case $bLocalJsonFileRename
			Case $bLocalJsonFileBackup
			Case $bOpenJsonFolder
			Case $bRunVariant
			Case $bVariantRemove
			Case $bVariantEdit
			Case $baddVariantsFromJsonFile
			Case $bClockSet
			Case $bClockReset
			Case $cbUndoMove
			Case $cbRestartGameOnCrash
			Case $rAnimationsAlwaysOn
			Case $rAnimationsAlwaysOff
			Case $rAnimationsIgnore
			Case $bInsertCode
			Case $bResumeGame
			Case $bPgnAdd
			Case $bPgnOpenPath
			Case $cPgnList
			Case $bPgnRun
			Case $bPgnRemove
		EndSwitch
	WEnd
EndFunc   ;==>_MainGui
