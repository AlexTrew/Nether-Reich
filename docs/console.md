# Console
## Purpose
The in-game console lets us run commands in-game to do things that are helpful for testing, like unlocking doors and
[dumping the level grid](grid-viewer.md). 

## Usage
Press `/` in game. The console will appear at the top left. Click on it and start typing. Start by running `help`.

## Development
You can add new commands by creating a new scene with a script subclassing `AbstractCommand.gd`, and adding the scene to
`Console.tscn` as a child of `Commands`. It will automatically be picked up and added to the list of available commands.

