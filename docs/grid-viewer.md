# Grid Viewer
## Purpose
To debug procedural generation or door related issues, it can be helpful to inspect the grid created by the level generator.

## Usage
### Console Commands
The grid can be saved at any time during gameplay using a [console command](/docs/console.md).

### Automatic Grid Dumps
Activating the `netherreich/logging/dump_grid_as_csv` project setting will result in the grid being saved every time a
level is generated.

### Viewing Grid Dumps
In both cases, the grid is saved as a CSV file in an OS-specific location, ` ~/.local/share/godot/app_userdata/Nether Reich Ii/grid_xxxxx.csv` on Linux.

The CSV file can be opened in any spreadsheet program, however it can be difficult to interpret without colour-coding the different cell types. A Google Sheet with pre-configured conditional formatting rules exists [here](https://docs.google.com/spreadsheets/d/1Uk_OSn4PTtN9dhPavdzCM8VdecXdXatBBYLeS619A88). 

To use it:
1. Select all of the cells in your local spreadsheet program, and copy.
2. Select all of the cells in the Google Sheet, and paste.
3. After a short delay, the new data will populate and the formatting rules will be applied.

Note that the grid will appear upside down compared to the populated level in-game. This is intentional, as the procedural generation algorithm generates the grid this way and the grid directions (N, S, E, W) reflect this.