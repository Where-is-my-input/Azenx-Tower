extends Node2D

var damage = 5

func _ready() -> void:
	damage = damage + randi_range(-4, sqrt(Global.floor))

func _on_a_spikes_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") || body.is_in_group("Enemy"):
		body.getHit(damage + randi_range(0, sqrt(damage)))
