extends Node2D

@export var heal:int = 1

func _ready() -> void:
	scaleLevel()

func scaleLevel():
	heal = heal + Global.floor + sqrt(Global.floor)

func _on_a_collectible_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.heal(heal)
		queue_free()
