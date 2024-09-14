extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape_2d: CollisionShape2D = $hitbox/CollisionShape2D

@export var weaponName = "Axe"
@export var atk = 5

func attack():
	animation_player.play("atk")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	Global.nextTurn.emit()


func _on_hitbox_body_entered(body) -> void:
	if body.is_in_group("Enemy"):
		body.getHit(atk)
		collision_shape_2d.set_deferred("disabled", true)
