extends Node
const PLAYER = preload("res://code/player/player.tscn")
signal nextTurn
signal floorGenerated
signal spawnPlayer
signal spawnEnemy
signal spawnExit
signal setDoorCoordinates

signal updateHUD

var godMode = false

var seed = "ikkisoad"
var floor = 0

var player = null

func _ready() -> void:
	instantiatePlayer()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("reset"):
		instantiatePlayer()
		get_tree().change_scene_to_file("res://code/main.tscn")

func changeFloor():
	get_tree().change_scene_to_file("res://code/debug/debug.tscn")

func instantiatePlayer():
	player = PLAYER.instantiate()
	#add_child(player)
