extends Node2D
@onready var tile_map_layer: TileMapLayer = $TileMapLayer
@onready var tile_set: Node2D = $tileSet

@export var size = Vector2(50,50)
@export var noiseOctaves = 1
@export var noisePeriod = 3
@export var noisePersistence = 0.7
@export var noiseLacunarity = 0.4
@export var noiseThreshold = 0.3

#var min = 0
#var max = 0

var simplexNoise = FastNoiseLite.new()

#func _ready() -> void:
	#clear()
	#generate()
	#Global.floorGenerated.emit()

func clear():
	tile_map_layer.clear()

func generate():
	clear()
	size = Vector2(randi_range(5,50), randi_range(5,50))
	#size = Vector2(5,5)
	tile_set.setBorder(size)
	autoTile(0,0)
	Global.floorGenerated.emit()
	#tile_map_layer.tile_map_data.update_dirty_quadrants()

func autoTile(x, y):
	var seed = str(Global.floor) + Global.seed
	simplexNoise.seed = seed.hash()
	simplexNoise.fractal_octaves = noiseOctaves
	simplexNoise.fractal_lacunarity = noiseLacunarity
	
	simplexNoise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	simplexNoise.frequency = 0.25
	
	for cx in range(size.x):
		for cy in range(size.y):
			var noise = simplexNoise.get_noise_2d(cx, cy)
			#if noise < min:
				#min = noise
			#if noise > max:
				#max = noise
			if noise < noiseThreshold:
				tile_map_layer.set_cell(Vector2i(cx,cy), 0, Vector2i(1,0))
				if noise > -0.8 && noise < -0.6:
					Global.spawnPlayer.emit(Vector2(cx, cy))
				elif noise > -0.5 && noise < -0.4:
					Global.spawnEnemy.emit(Vector2(cx, cy))
				elif noise > -0.1 && noise < 0.0:
					Global.spawnExit.emit(Vector2(cx, cy))
			else:
				tile_map_layer.set_cell(Vector2i(cx,cy), 0, Vector2i(0,0))
