extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var cs_attack: CollisionShape2D = $hitbox/csAttack

@export var weaponName = "Axe"
@export var atk = 5

func attack():
	animation_player.play("atk")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	Global.nextTurn.emit()


func _on_hitbox_body_entered(body) -> void:
	if body.is_in_group("Enemy"):
		get_parent().passiveManaRegen()
		if body.getHit(atk + get_parent().atk):
			get_parent().getXP(body.xp)
		cs_attack.set_deferred("disabled", true)
