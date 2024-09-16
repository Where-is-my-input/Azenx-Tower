extends Control
@onready var btn_arcade: Button = $BoxContainer/VBoxContainer/btnArcade
@onready var txt_seed: TextEdit = $BoxContainer/VBoxContainer/txtSeed

func _ready() -> void:
	btn_arcade.grab_focus()
	txt_seed.text = Global.seed

func _on_btn_arcade_pressed() -> void:
	Global.currentGameMode = Global.gameMode.ARCADE
	Global.instantiatePlayer()
	get_tree().change_scene_to_file("res://code/debug/debug.tscn")

func _on_btn_endless_pressed() -> void:
	Global.currentGameMode = Global.gameMode.ENDLESS
	Global.instantiatePlayer()
	get_tree().change_scene_to_file("res://code/debug/debug.tscn")


func _on_txt_seed_text_changed() -> void:
	Global.seed = txt_seed.text
