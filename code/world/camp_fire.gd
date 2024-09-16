extends Node2D

var player = null
@onready var tile_set: Node2D = $tileSet

func _ready():
	Global.player.get_child(0).global_position = Vector2(32,32) * 5
	add_child(Global.player)
	Global.player.enterFloor()
	tile_set.signalSize()

func _on_bonfire_body_entered(body: Node2D) -> void:
	player = body

func _process(delta: float) -> void:
	if player != null && player.is_in_group("Player"):
		player.heal(5)
		player.regenMana(5)

func _on_bonfire_body_exited(body: Node2D) -> void:
	player = null
