extends Control
@onready var btn_arcade: Button = $BoxContainer/VBoxContainer/btnArcade
@onready var txt_seed: TextEdit = $BoxContainer/VBoxContainer/txtSeed

func _ready() -> void:
	Global.soundTrack.playMainMenu()
	btn_arcade.grab_focus()
	txt_seed.text = Global.seed
	if Global.floor > Global.endlessFloor:
		Global.endlessFloor = Global.floor

func _on_btn_arcade_pressed() -> void:
	Global.soundTrack.playRandom()
	Global.currentGameMode = Global.gameMode.ARCADE
	Global.floor = 0
	Global.resetIGT()
	Global.healPlayer()
	#Global.instantiatePlayer()
	get_tree().change_scene_to_file("res://code/debug/debug.tscn")

func _on_btn_endless_pressed() -> void:
	Global.soundTrack.playRandom()
	Global.healPlayer()
	Global.resetIGT()
	Global.currentGameMode = Global.gameMode.ENDLESS
	Global.floor = Global.endlessFloor
	#Global.instantiatePlayer()
	get_tree().change_scene_to_file("res://code/debug/debug.tscn")


func _on_txt_seed_text_changed() -> void:
	Global.seed = txt_seed.text
