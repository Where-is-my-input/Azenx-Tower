extends Node2D
@onready var a_swings: Area2D = $aSwings

var turnsUntilAttack = 1
var damage = 1

func _ready() -> void:
	Global.connect("nextTurn", nextTurn)

func nextTurn():
	turnsUntilAttack -= 1
	if turnsUntilAttack > 0: return
	for c in a_swings.get_children():
		c.set_deferred("disabled", false)
		c.swipe()
	get_parent().spellFinished()
	await get_tree().create_timer(0.0167).timeout
	queue_free()


func _on_a_swings_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.getHit(damage)
