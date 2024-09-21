extends Control
@onready var timer: Timer = $Timer

func _input(event: InputEvent) -> void:
	if timer.is_stopped(): queue_free()
