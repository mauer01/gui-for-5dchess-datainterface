# 5D Chess Data Interface GUI (AutoIt)

Windows GUI to manage GHXX’s FiveDChessDataInterface and quickly turn PGN/FEN into playable variants. It includes editors for JSON variants and PGN metadata (tags, FENs, moves), plus utilities for timers, animations, and keeping the game running.

## What it Provides

- Start and control the Data Interface.
- Load PGN/FEN from clipboard or file and pick the exact last move to apply.
- Manage your own variant JSON files (a local library the GUI owns).
- Edit variant JSON directly in a modal editor.
- Edit PGN content (tags, FEN list, move list) in a modal editor.
- Configure timers and animation options.
- Optionally keep the 5D Chess game running (auto-restart on crash).

## JsonVariants.json policy

- The GUI maintains its own set of JSON variant files
- JsonVariants.json is used only as a bridge to the Data Interface.
- If an existing JsonVariants.json is detected and appears (atleast 2 variants written in it) to be in use, the GUI auto‑backs it up before messing with it.

## Requirements

- Windows | Linux (with ProtonHax: [http](https://github.com/CrazyPenguin0111/5D-Chess-Data-Interface-Linux/))
- 5D Chess With Multiverse Time Travel (Steam install)
- GHXX FiveDChessDataInterface
  - The GUI can auto-setup the Data Interface into: %LocalAppData%\GuiDataInterface\Datainterface

## Install and run

- From release: download the EXE and run it.
- From source:
  - Install AutoIt.
  - Open main.au3 and run or build (F5/F7).
  - Output goes to out\gui-for-5d-datainterface.exe (per AutoIt3Wrapper directives).

On first start:
1. The app loads config from “gui for datainterface.ini”.
2. If missing, choose:
   - Automatic setup (places the Data Interface Resources under %LocalAppData%\GuiDataInterface\Resources), or
   - Browse to an existing Resources folder.

Config keys: ()
- Interface: path to Data Interface Resources 
- gamelocation: path to the 5D Chess executable (should be able to autofetch when game is running)
- activeJsonFile: the currently selected variant JSON from the GUI’s library (persistancy only)

## Usage

- Data Interface
  - Run/stop the interface using the configured Resources folder.
  - Clocks are settable in seconds or in HH:MM:SS format
  - Undo Move locks the undo button so it cant deactivate after pressing it
  - Insert room Code auto inserts the discord private match code from the clipboard
  - Resume game will resume offline games if they concluded due to draw / checkmate
  - Keep Game On can relaunch the game if it closes.

- PGN / FEN workflow
  - Load from Clipboard or open a .txt in 5dpgn format (FEN on top, moves below).
  - You have to specify at what move the pgn loader should go and if blacks last move should be taken with
  - Add/Update creates or updates an entry in the GUI’s library, Pgns will be saved in a csv file in the same dir, with ; as the seperator (because,... it was easier).
  - When running via the Data Interface, the GUI emits a JsonVariants.json for the interface to consume (backing it up first if it has 2 or more variants in it).

- PGN Editor (modal)
  - Edit:
    - Tags: select and Set a value.
    - FENs: select, edit, Set.
    - Moves: select, edit, Set.
  - Lists update in-place and changes persist in the PGN map.

- JSON Editor (modal)
  - Edit the variant JSON as text.
  - Save parses and writes back to the GUI’s JSON library while preserving the old key.
  - Rename creates/updates under a new name while overwriting the old entry.

## Tips

- Variants from external designers (e.g., web tools) can be pasted and refined here.

## Contributing

Issues and PRs are welcome. You can also contact via Discord.

## Acknowledgments

- AutoIt community
- 5D Chess variant designers and tools
- GHXX Data Interface: https://github.com/GHXX/FiveDChessDataInterface
- Linux Version: [http](https://github.com/CrazyPenguin0111/5D-Chess-Data-Interface-Linux/)
- PGN recorders:
  - https://github.com/penteract/5D-PGN-Recorder
  - https://github.com/CrazyPenguin0111/5D-PGN-Recorder
  - https://github.com/NKID00/5DChessRecorderCrossplatform/
- Of course the lovely 5DChessCommunity: [http](https://5dchesswithmultiversetimetravel.com/discord)
  
## License

MIT
