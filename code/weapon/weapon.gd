extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var cs_attack: CollisionShape2D = $hitbox/csAttack
@onready var hitbox: Area2D = $hitbox
@export var weaponName = "Axe"
@export var atk:int = 5
@onready var asp_weapon: AudioStreamPlayer2D = $aspWeapon
@export var weaponType:Global.weaponType = Global.weaponType.AXE

var level:int = 1

func _ready() -> void:
	level = Global.floor - sqrt(Global.floor)
	if level < 1: level = 1
	scaleLevel()

func scaleLevel():
	atk = atk + (level / (sqrt(atk)))
	if level > 25:
		weaponName = "Legendary " + weaponName

func attack():
	asp_weapon.play()
	animation_player.play("atk")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	Global.nextTurn.emit()

func disableHitbox(v = true):
	for c in hitbox.get_children():
		c.set_deferred("disabled", v)
		c.swipe()

func _on_hitbox_body_entered(body) -> void:
	if body.is_in_group("Enemy"):
		get_parent().passiveManaRegen()
		if body.getHit(randi_range(0, sqrt(atk)) + atk + get_parent().atk):
			get_parent().getXP(body.xp + randi_range(0, sqrt(body.xp)))
		cs_attack.set_deferred("disabled", true)

func flip(dir):
	match dir:
		Vector2(1,0):
			hitbox.rotation_degrees = 0
		Vector2(-1,0):
			hitbox.rotation_degrees = 180
		Vector2(0,-1):
			hitbox.rotation_degrees = -90
		Vector2(0,1):
			hitbox.rotation_degrees = 90
	#if flipped && dir.x != 0:
		#hitbox.rotation_degrees = 0
		#flipped = false
	#elif !flipped && dir.y != 0:
		#hitbox.rotation_degrees = 90 * dir.y
		#flipped = true
	#elif !flipped && dir.x == -1:
		#hitbox.rotation_degrees = 180
