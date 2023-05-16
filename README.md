# AutoIt Chess PGN to Variant Converter

This AutoIt script allows you to convert Portable Game Notation (PGN) files into chess variants. It provides a graphical user interface (GUI) for loading PGN files, selecting specific moves, and automatically adding the variant to the JSON file.

## Features

- Load PGN files and extract move data.
- Choose the turn (white or black) for creating variants.
- Add chess variants to a JSON file or copy them to the clipboard.
- Delete variants from the JSON file.

## Prerequisites

- Steam game: `5Dchess with multiverse time travel`
- any 5d chess pgn reader or files.
- ghxx datainterface console to make something with the variants.

## Getting Started

1. Download the `PGN to Variant.exe` from Releases and start it.
2. A GUI will appear, allowing you to interact with the script's functionalities.
3. Use the `Open File` button to select a PGN file.
4. Choose the turn (white or black) using the drop-down menu, -1 is the complete game, The Checkbox "Black" will have 
6. Click the "Read File" button to extract move data from the PGN file.
7. Once the file is loaded, you can add the variant to the .json file or copy the variant to the clipboard.
8. once you selected the .json you wanna modify you can also delete existing variants from that .json File.

## Contributing

Contributions are welcome! If you encounter any issues or have suggestions for improvements, please open an issue or submit a pull request.

## Acknowledgments

The AutoIt Chess Variant Converter script was inspired by the need to automate the conversion process for PGN files into chess variants. 
Special thanks to:
  - the AutoIt community for their support and contributions.
  - GHXX Data Interface ("https://github.com/GHXX/FiveDChessDataInterface")
  - and the pgn recorders from various members of the 5d community:
    - Crazy: https://github.com/CrazyPenguin0111/5D-PGN-Recorder
    - Tesseract/Penteract: https://github.com/penteract/5D-PGN-Recorder
    - NKID00: https://github.com/NKID00/5DChessRecorderCrossplatform/
  


## Disclaimer

This script is provided as-is without any warranty. Use it at your own risk.
Currently there are issues with the FEN generation of the non standard boards in the pgn readers (all of them)
  - any board that has pieces within a row and not the full row will have slightly wrong starting positions which will cascate through the full game.
