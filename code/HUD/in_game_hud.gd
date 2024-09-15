extends Control
@onready var progress_bar: ProgressBar = $CanvasLayer/topHUD/ProgressBar
@onready var door_coordinates: Label = $CanvasLayer/topHUD/doorCoordinates
@onready var lbl_floor_number: Label = $CanvasLayer/downHUD/lblFloorNumber
@onready var tp_teleport: TextureProgressBar = $CanvasLayer/downRightHUD/tpTeleport
@onready var lbl_hp: Label = $CanvasLayer/topHUD/ProgressBar/lblHP
@onready var lbl_current_lvl: Label = $CanvasLayer/topLeftHUD/lblCurrentLvl
@onready var lbl_current_atk: Label = $CanvasLayer/topLeftHUD/HBoxContainer/lblCurrentAtk
@onready var pb_xp: ProgressBar = $CanvasLayer/topLeftHUD/pbXP

func _ready() -> void:
	Global.connect("updateHUD", update)
	Global.connect("updateHUDLevel", updateLevel)
	Global.connect("updateHUDxp", updateXp)
	Global.connect("setDoorCoordinates", setDoorCoordinates)
	Global.connect("nextTurn", nextTurn)
	Global.connect("teleported", teleported)
	door_coordinates.visible = false
	lbl_floor_number.text = str(Global.floor)

func teleported():
	tp_teleport.value = 0

func nextTurn():
	tp_teleport.value += 1

func updateXp(player):
	pb_xp.value = player.xp

func updateLevel(player):
	if player == null: return
	lbl_current_lvl.text = str(player.level)
	lbl_current_atk.text = str(player.atk)
	progress_bar.max_value = player.maxHP
	pb_xp.max_value = player.xpNeeded
	pb_xp.value = player.xp

func update(player):
	if player == null: return
	progress_bar.value = player.hp
	lbl_hp.text = str(player.hp)
	tp_teleport.value = 5 - player.teleportCooldown

func setDoorCoordinates(v):
	door_coordinates.text = str(v)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("doorCoordinates"):
		door_coordinates.visible = !door_coordinates.visible
