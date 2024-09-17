extends Node2D
@onready var cb_2_player: CharacterBody2D = $cb2Player

func enterFloor():
	#cb_2_player.global_position = pos
	process_mode = Node.PROCESS_MODE_INHERIT
	Global.updateHUD.emit(cb_2_player)
	Global.updateHUDLevel.emit(cb_2_player)
	Global.updateHUDResources.emit(cb_2_player)
	if cb_2_player != null:
		if cb_2_player.testOutsideBoundaries():
			print("Player out of bounds")
			cb_2_player.global_position = Vector2(32, 32)

func dead():
	get_parent().remove_child(self)
	Global.player = self

func fullHeal():
	if cb_2_player != null:
		cb_2_player.heal(cb_2_player.maxHP)
