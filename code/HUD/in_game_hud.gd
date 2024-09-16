extends Control
@onready var progress_bar: ProgressBar = $CanvasLayer/topHUD/ProgressBar
@onready var door_coordinates: Label = $CanvasLayer/topHUD/doorCoordinates
@onready var lbl_floor_number: Label = $CanvasLayer/downHUD/lblFloorNumber
@onready var tp_teleport: TextureProgressBar = $CanvasLayer/downRightHUD/tpTeleport
@onready var lbl_hp: Label = $CanvasLayer/topHUD/ProgressBar/lblHP
@onready var lbl_current_atk: Label = $CanvasLayer/topLeftHUD/HBoxContainer/lblCurrentAtk
@onready var pb_xp: ProgressBar = $CanvasLayer/topLeftHUD/pbXP
@onready var pb_mana: ProgressBar = $CanvasLayer/topHUD/pbMana
@onready var lbl_mana: Label = $CanvasLayer/topHUD/pbMana/lblMana
@onready var tp_spell: TextureProgressBar = $CanvasLayer/downRightHUD/tpSpell
const LBL_LOG = preload("res://code/HUD/lbl_log.tscn")
@onready var top_right_hud: VBoxContainer = $CanvasLayer/topRightHUD
@onready var lbl_current_lvl: Label = $CanvasLayer/topLeftHUD/hbLevel/lblCurrentLvl
@onready var hb_weapon: HBoxContainer = $CanvasLayer/topLeftHUD/hbWeapon
@onready var hb_spell: HBoxContainer = $CanvasLayer/topLeftHUD/hbSpell

func _ready() -> void:
	Global.connect("updateHUD", update)
	Global.connect("updateHUDLevel", updateLevel)
	Global.connect("updateHUDxp", updateXp)
	Global.connect("setDoorCoordinates", setDoorCoordinates)
	Global.connect("nextTurn", nextTurn)
	Global.connect("teleported", teleported)
	Global.connect("damageLog", HUDlog)
	Global.connect("manaLog", timedLog)
	Global.connect("updateHUDResources", updateResources)
	door_coordinates.visible = false
	lbl_floor_number.text = str(Global.floor)

func timedLog(t):
	if top_right_hud.get_child_count() > 25: return
	var newLog = LBL_LOG.instantiate()
	newLog.text = t
	top_right_hud.add_child(newLog)
	newLog.startTimer(2)

func HUDlog(t):
	var newLog = LBL_LOG.instantiate()
	newLog.text = t
	top_right_hud.add_child(newLog)

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
	pb_mana.max_value = player.maxMana
	pb_xp.max_value = player.xpNeeded
	pb_xp.value = player.xp

func update(player):
	if player == null: return
	progress_bar.value = player.hp
	lbl_hp.text = str(player.hp)
	pb_mana.value = player.mana
	lbl_mana.text = str(player.mana)
	tp_teleport.value = 5 - player.teleportCooldown

func updateResources(player):
	hb_weapon.setResource(player.weapon.weaponName, player.weapon.atk)
	var spell = player.spell.instantiate()
	hb_spell.setResource(spell.spellName, spell.damage)

func setDoorCoordinates(v):
	door_coordinates.text = str(v)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("doorCoordinates"):
		door_coordinates.visible = !door_coordinates.visible
