extends Node

signal nextTurn
signal floorGenerated
signal spawnPlayer

var seed = "ikkisoad"
var floor = 0

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("reset"):
		get_tree().change_scene_to_file("res://code/main.tscn")
