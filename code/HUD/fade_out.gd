extends Control

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_file("res://code/HUD/main_menu.tscn")
