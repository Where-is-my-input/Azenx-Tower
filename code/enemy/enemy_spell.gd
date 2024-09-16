extends Node2D

@export var direction:Vector2 = Vector2(1,0)
@export var speed:Vector2 = Vector2(32, 32)
@export var damage:int = 1
@export var spellName = "Fireball"

func _physics_process(delta: float) -> void:
	global_position += direction * speed

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if body.getHit(damage):
			get_parent().getXP(body.xp)
	if !body.is_in_group("Enemy"):
		queue_free()
