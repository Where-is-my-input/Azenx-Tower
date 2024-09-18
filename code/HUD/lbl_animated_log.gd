extends Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var type = 0
var value = 1

func _ready() -> void:
	text = str(value)
	var anim = "damage"
	match type:
		0:
			modulate = Color.RED
		2:
			anim = "levelUp"
		3: #mana
			anim = "mana"
		4: #xp
			anim = "xp"
		_:
			modulate = Color.GREEN
			anim = "heal"
	animation_player.play(anim)

func setValues(t, v):
	type = t
	value = v

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
