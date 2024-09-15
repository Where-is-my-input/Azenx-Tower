extends Node2D
@onready var tile_map_layer: TileMapLayer = $TileMapLayer

func setBorder(size):
	tile_map_layer.clear()
	tile_map_layer.set_cell(Vector2i(-2, -2), 0, Vector2i(0,0))
	for x in size.x + 3:
		tile_map_layer.set_cell(Vector2i(x - 1, -1), 0, Vector2i(0,0))
		tile_map_layer.set_cell(Vector2i(x - 1, size.y), 0, Vector2i(0,0))
		
		tile_map_layer.set_cell(Vector2i(x - 1, -2), 0, Vector2i(0,0))
		tile_map_layer.set_cell(Vector2i(x - 1, size.y + 1), 0, Vector2i(0,0))
	for y in size.y + 3:
		tile_map_layer.set_cell(Vector2i(-1 , y - 1), 0, Vector2i(0,0))
		tile_map_layer.set_cell(Vector2i(size.x, y - 1), 0, Vector2i(0,0))
		
		tile_map_layer.set_cell(Vector2i(-2, y - 1), 0, Vector2i(0,0))
		tile_map_layer.set_cell(Vector2i(size.x + 1, y - 1), 0, Vector2i(0,0))
	
