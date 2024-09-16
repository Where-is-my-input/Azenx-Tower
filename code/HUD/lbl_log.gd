extends Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer

@export var turns = 2

func _ready() -> void:
	Global.connect("nextTurn", nextTurn)

func nextTurn():
	turns -= 1
	if turns <= 0:
		playAnimation("fadeOut")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()

func playAnimation(anim):
		animation_player.play(anim)

func startTimer(t):
	timer.start(t)

func _on_timer_timeout() -> void:
	playAnimation("fadeOut")
