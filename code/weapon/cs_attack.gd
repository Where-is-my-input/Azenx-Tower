extends CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var spr_swipe: Sprite2D = $sprSwipe

func _ready() -> void:
	spr_swipe.visible = false

func swipe():
	animation_player.play("swipe")
