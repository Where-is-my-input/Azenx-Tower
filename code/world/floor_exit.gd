extends Node2D


func _on_a_2d_exit_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.leaveFloor()
		Global.floor += 1
		Global.changeFloor()
