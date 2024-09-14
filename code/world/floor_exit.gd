extends Node2D


func _on_a_2d_exit_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Exiting floor")
		Global.floor += 1
		get_tree().change_scene_to_file("res://code/debug/debug.tscn")
