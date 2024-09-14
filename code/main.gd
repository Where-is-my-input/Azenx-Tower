extends Control

@onready var button_2: Button = $Container/HBoxContainer/Button2

func _ready() -> void:
	button_2.grab_focus()

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://code/player/player.tscn")


func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://code/debug/debug.tscn")
