extends Node2D
@onready var boss: Node2D = $boss
@onready var tile_set: Node2D = $tileSet

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	floorGenerated()
	tile_set.signalSize()
	Global.soundTrack.playBoss()

func floorGenerated():
	Global.player.get_child(0).global_position = Vector2(608, 544)
	Global.player.get_child(0).connect("dead", gameOver)
	Global.player.enterFloor()
	Global.player.setCameraOffset(-2)
	add_child(Global.player)

func gameOver():
	get_tree().change_scene_to_file("res://code/HUD/game_over.tscn")

func floorOver():
	Global.soundTrack.playRandom()
	for c in get_children():
		for cc in c.get_children():
			if cc.is_in_group("Player"):
				cc.leaveFloor()
	await get_tree().create_timer(1).timeout
	match Global.currentGameMode:
		Global.gameMode.ARCADE:
			get_tree().change_scene_to_file("res://code/HUD/you_win.tscn")
		_:
			Global.floor += 1
			Global.changeFloor()
