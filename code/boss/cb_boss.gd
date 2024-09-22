extends CharacterBody2D

enum attacks { FIREHELL, BOMBSHELLING, ONEHUNDREDSWINGS}
@onready var as_boss: AnimatedSprite2D = $asBoss
@onready var pb_hp: ProgressBar = $pbHp
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"

@export var xp = 50
@export var maxHP = 50
@export var atk = 5
var hp = maxHP
@onready var level = Global.floor - sqrt(Global.floor) * 2 + 1

var turnsStandBy = 2

var odds:Array = [3, 6, 9]
var nextAttack:attacks = attacks.FIREHELL

var attacking = false

func levelScale():
	atk = atk + level
	hp = hp + (level * 2)
	xp = xp + sqrt(xp) * level

func _ready() -> void:
	pb_hp.max_value = maxHP
	pb_hp.value = hp
	Global.connect("nextTurn", playTurn)
	prepareAttack()
	as_boss.play("down")

func prepareAttack():
	if attacking: return
	var nextMove = randi_range(1,9)
	if nextMove <= odds[0]:
		nextAttack = attacks.FIREHELL
	elif nextMove <= odds[1]:
		nextAttack = attacks.BOMBSHELLING
	elif nextMove <= odds[2]:
		nextAttack = attacks.ONEHUNDREDSWINGS

func playTurn():
	turnsStandBy -= 1
	Global.enemyTurn.emit()
	if turnsStandBy > 0: return
	attacking = true
	match nextAttack:
		attacks.FIREHELL:
			get_parent().spawnFirehell()
		attacks.BOMBSHELLING:
			get_parent().bombShelling()
		_:
			get_parent().oneHundredSwings()
	turnsStandBy = 2

func getHit(damage = 1):
	hp -= damage
	pb_hp.value = hp
	animation_player.play("getHit")
	Global.damageAnimLog.emit(0, damage, global_position)
	Global.damageLog.emit("Cecilia was hit for " + str(damage) + " damage")
	if hp <= 0:
		queue_free()
		get_parent().floorOver()
		return true
	return false
