extends Node2D
@onready var cb_2_player: CharacterBody2D = $cb2Player

func enterFloor():
	#cb_2_player.global_position = pos
	process_mode = Node.PROCESS_MODE_INHERIT
	Global.updateHUD.emit(cb_2_player)
