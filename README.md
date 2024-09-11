# DystinctLocations

DystinctLocations is a World of Warcraft addon that records subzone location changes and experience gain events to aggregate discovery coordinates. This addon was designed for crowd sourcing aggregation of discoverable subzone locations that provide experience to route optimal pathing for quick leveling of Earthen race characters.

## Earthen Leveling Speedrun

The Skyward Ascent Community has been collaborating to optimize the Earthen skyriding leveling strategy and this addon is a part of these efforts. Check out the [Skyward Ascent Discord](https://discord.gg/E3W8pDfYxT) for more information and to contribute or view the status of the project by visiting the [project spreadsheet](https://docs.google.com/spreadsheets/d/182tqNcNqsEkWI--_8R4HZERZvrFq4U8b7V7y_OciDL8/).

## Features

- Records zone changes and experience gain events
- Tracks player coordinates for each event
- Compatible with TomTom for waypoint creation
- Customizable settings through slash commands
- Automatic disabling at level 70 (can be overridden)

## Installation

1. Download the latest version of DystinctLocations from the releases page.
2. Extract the contents of the zip file into your World of Warcraft `_retail_\Interface\AddOns` directory.
3. Ensure the folder is named `DystinctLocations`.
4. Launch World of Warcraft and enable the addon in the character selection screen.

## Usage

DystinctLocations works automatically once installed and enabled. It will begin tracking your zone changes and experience gains as you play.

### Slash Commands

Use the following slash commands to control the addon:

- `/dystinctlocations` or `/dysloc` - Shows the help menu
- `/dysloc toggle` - Toggles the addon on/off
- `/dysloc enable` - Enables the addon
- `/dysloc disable` - Disables the addon
- `/dysloc tomtom` - Toggles TomTom integration
- `/dysloc reset` - Resets all addon data (requires confirmation)

### TomTom Integration

If you have TomTom installed and enabled, DystinctLocations can automatically create waypoints at locations where you gain experience. This feature can be toggled on/off using the `/dysloc tomtom` command.

## Data Storage

DystinctLocations stores its data in your WoW saved variables. You can find this data in:

`World of Warcraft\_retail_\WTF\Account\YOUR_ACCOUNT\SavedVariables\DystinctLocations.lua`

## Submissions

I can be reached to receive submissions on Discord directly (@explicated) or can be found in the [Skyward Ascent Discord](https://discord.gg/E3W8pDfYxT).

## Contributing

Contributions to DystinctLocations are welcome! Please feel free to submit pull requests or create issues for bugs and feature requests.

## License

DystinctLocations is released under the [MIT License](LICENSE).

## Author

Created by Jordan Ella/Dysperse-Illidan

## Acknowledgements

Special thanks to Linaaa and the Skyward Ascent community for all their hard work in this project. I'd also like to thank the creators of TomTom for their painless compatibility.
