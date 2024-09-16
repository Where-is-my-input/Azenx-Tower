extends Node2D

@export var direction:Vector2 = Vector2(1,0)
@export var speed:Vector2 = Vector2(32, 32)
@export var damage:int = 5

var manaDamage = 0

func _physics_process(delta: float) -> void:
	global_position += direction * speed

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		if body.getHit(damage + manaDamage / 100):
			get_parent().getXP(body.xp)
	if !body.is_in_group("Player"):
		get_parent().spellFinished()
		queue_free()
