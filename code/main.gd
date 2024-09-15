extends Control
@onready var text_edit: TextEdit = $Container/HBoxContainer/TextEdit

@onready var button_2: Button = $Container/HBoxContainer/Button2

func _ready() -> void:
	text_edit.text = Global.seed
	button_2.grab_focus()

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://code/player/player.tscn")


func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://code/debug/debug.tscn")


func _on_button_3_pressed() -> void:
	get_tree().change_scene_to_file("res://code/debug/debug.tscn")


func _on_text_edit_text_changed() -> void:
	Global.seed = text_edit.text


func _on_button_4_pressed() -> void:
	get_tree().change_scene_to_file("res://code/world/camp_fire.tscn")
