#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=.\kodaForms\main.kxf
$main = GUICreate("Gui for Datainterface", 604, 210, 1140, 268)
$tab = GUICtrlCreateTab(0, 0, 601, 209)
$tJsonLoader = GUICtrlCreateTabItem("JSON Loader")
GUIStartGroup()
$iJsonFileNewPath = GUICtrlCreateInput("", 8, 34, 225, 21)
$bAddJsonFile = GUICtrlCreateButton("Add", 240, 32, 35, 25, $BS_PUSHLIKE)
GUIStartGroup()
GUIStartGroup()
$cRemoteJsons = GUICtrlCreateCombo("", 8, 66, 225, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
$bRemoteJsonDownload = GUICtrlCreateButton("Download", 240, 64, 67, 25)
GUIStartGroup()
GUIStartGroup()
$cLocalJsonFiles = GUICtrlCreateCombo("", 8, 98, 225, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
$bLocalJsonFileRemove = GUICtrlCreateButton("Remove", 240, 96, 50, 25)
$bLocalJsonFileCopy = GUICtrlCreateButton("Copy", 294, 96, 50, 25)
$bLocalJsonFileRename = GUICtrlCreateButton("Rename", 348, 96, 50, 25)
$bLocalJsonFileBackup = GUICtrlCreateButton("Backup", 402, 96, 50, 25)
$bOpenJsonFolder = GUICtrlCreateButton("Open Folder", 456, 96, 75, 25)
GUIStartGroup()
GUIStartGroup()
$cListOfVariants = GUICtrlCreateCombo("", 8, 130, 225, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
$bRunVariant = GUICtrlCreateButton("Run", 240, 128, 43, 25)
$bVariantRemove = GUICtrlCreateButton("Remove", 288, 128, 59, 25)
$bVariantEdit = GUICtrlCreateButton("Edit", 352, 128, 43, 25)
GUIStartGroup()
GUIStartGroup()
$bAddVariantfromClip = GUICtrlCreateButton("Clipboard", 168, 160, 75, 25)
$laddSpecifier = GUICtrlCreateLabel("Add new Variant via Methods:", 16, 165, 146, 17)
$bAddVariantFromFile = GUICtrlCreateButton("Textfile", 248, 160, 59, 25)
$baddVariantsFromJsonFile = GUICtrlCreateButton("Combine JsonFiles", 312, 160, 115, 25)
GUIStartGroup()
$tSettings = GUICtrlCreateTabItem("Settings")
GUIStartGroup()
$cClocks = GUICtrlCreateCombo("Clocks", 8, 32, 145, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "Long|Medium|Short")
$iClockTime = GUICtrlCreateInput("Time", 8, 56, 65, 21)
$iClockDelay = GUICtrlCreateInput("Delay", 88, 56, 65, 21)
$bClockSet = GUICtrlCreateButton("Set ", 160, 56, 51, 25)
$bClockReset = GUICtrlCreateButton("Reset to default", 160, 32, 91, 25)
$Label1 = GUICtrlCreateLabel("+", 76, 58, 10, 17)
GUIStartGroup()
GUIStartGroup()
$cbUndoMove = GUICtrlCreateCheckbox("Undo Move", 8, 96, 89, 17)
$cbRestartGameOnCrash = GUICtrlCreateCheckbox("Restart Game on Crash", 8, 112, 129, 17)
GUIStartGroup()
GUIStartGroup()
$lTravelAnimations = GUICtrlCreateLabel("Travel Animations:", 264, 96, 91, 17)
$rAnimationsAlwaysOn = GUICtrlCreateRadio("Always On", 280, 112, 113, 17)
$rAnimationsAlwaysOff = GUICtrlCreateRadio("Always Off", 280, 128, 113, 17)
$rAnimationsIgnore = GUICtrlCreateRadio("Ignore", 280, 144, 113, 17)
GUIStartGroup()
GUIStartGroup()
$bInsertCode = GUICtrlCreateButton("Insert Room Code", 144, 96, 107, 25)
$bResumeGame = GUICtrlCreateButton("Resume Game", 144, 120, 107, 25)
GUIStartGroup()
$tPgnLoader = GUICtrlCreateTabItem("PGN Loader")
GUICtrlSetState(-1, $GUI_SHOW)
GUIStartGroup()
$iPgnLoaderPath = GUICtrlCreateInput("", 8, 32, 217, 21)
$bPgnAdd = GUICtrlCreateButton("Add", 232, 32, 51, 25)
$bPgnOpenPath = GUICtrlCreateButton("Choose Path", 288, 32, 75, 25)
GUIStartGroup()
GUIStartGroup()
$bPgnAddClipboard = GUICtrlCreateButton("Add from Clipboard", 8, 64, 107, 25)
GUIStartGroup()
GUIStartGroup()
$cPgnList = GUICtrlCreateCombo("cPgnList", 8, 96, 217, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
$bPgnRun = GUICtrlCreateButton("Run", 232, 96, 51, 25)
$bPgnRemove = GUICtrlCreateButton("Remove", 288, 96, 51, 25)
$bPgnEdit = GUICtrlCreateButton("Edit", 344, 96, 43, 25)
GUIStartGroup()
GUIStartGroup()
GUIStartGroup()
GUIStartGroup()
GUIStartGroup()
GUICtrlCreateTabItem("")
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
