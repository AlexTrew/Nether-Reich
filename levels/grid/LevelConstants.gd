class_name LevelConstants


# size of a grid-space cell in world-space, i.e. how many godot distance units per abstract grid cell
const CELL_SIZE = 30

enum CellPositionInTile {
	ORIGIN = -1,
	CHILD0 = 0,
	CHILD1 = 1,
	CHILD2 = 2,
	CHILD3 = 3,
	CHILD4 = 4,
	CHILD5 = 5
}

enum GridDirections {
	NORTH = 0,
	EAST = 1,
	SOUTH = 2,
	WEST = 3
}

const direction_symbols = {
	0: "^ N",
	1: "> E",
	2: "v S",
	3: "< W"
}
