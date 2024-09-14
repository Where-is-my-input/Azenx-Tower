extends Node2D
@onready var tile_map_layer: TileMapLayer = $TileMapLayer

func setBorder(size):
	tile_map_layer.clear()
	for x in size.x + 2:
		tile_map_layer.set_cell(Vector2i(x - 1,-1), 0, Vector2i(0,0))
		tile_map_layer.set_cell(Vector2i(x - 1,size.y), 0, Vector2i(0,0))
	for y in size.y + 1:
		tile_map_layer.set_cell(Vector2i(-1 , y), 0, Vector2i(0,0))
		tile_map_layer.set_cell(Vector2i(size.x, y), 0, Vector2i(0,0))
	
