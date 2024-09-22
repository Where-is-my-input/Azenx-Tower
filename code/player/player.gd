extends Node2D
@onready var cb_2_player: CharacterBody2D = $cb2Player
@onready var camera_2d: Camera2D = $cb2Player/Camera2D

func enterFloor():
	#cb_2_player.global_position = pos
	process_mode = Node.PROCESS_MODE_INHERIT
	Global.updateHUD.emit(cb_2_player)
	Global.updateHUDLevel.emit(cb_2_player)
	Global.updateHUDResources.emit(cb_2_player)
	cb_2_player.pos = cb_2_player.global_position
	Global.enemyTurn.emit()
	if cb_2_player != null:
		if cb_2_player.testOutsideBoundaries():
			cb_2_player.global_position = Vector2(32, 32)

func dead():
	get_parent().remove_child(self)
	Global.player = self

func fullHeal():
	if cb_2_player != null:
		cb_2_player.heal(cb_2_player.maxHP)

func setCameraOffset(v = 0):
	camera_2d.drag_vertical_offset = v
