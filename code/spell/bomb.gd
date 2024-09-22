extends Node2D

@export var direction:Vector2 = Vector2(1,0)
@export var speed:Vector2 = Vector2(16, 16)
@export var damage:int = 5
@export var spellName = "Bomb"
@onready var as_bomb: AnimatedSprite2D = $asBomb

var directions = [Vector2(1,0), Vector2(-1,0), Vector2(0,1), Vector2(0,-1), Vector2(1,1), Vector2(-1,1), Vector2(1,-1), Vector2(-1,-1)]
var manaDamage = 0
var turnsLeft = 3
var finished = 8
const SPELL = preload("res://code/spell/spell.tscn")
const ENEMY_SPELL = preload("res://code/enemy/enemy_spell.tscn")

var parent = null
var exploded = false
var enemyBomb = false

func _ready() -> void:
	Global.connect("nextTurn", turnEnd)
	damage = damage
	parent = get_parent()
	var pParent = get_parent().get_parent()
	parent.spellFinished()
	parent.remove_child(self)
	pParent.add_sibling(self)
	global_position = parent.global_position

func turnEnd():
	turnsLeft -= 1
	match turnsLeft:
		1:
			as_bomb.play("1")
		0:
			as_bomb.play("2")
	if turnsLeft <= 0 && !exploded:
		as_bomb.visible = false
		exploded = true
		explode()

func explode():
	for c in finished:
		var explosion = SPELL.instantiate() if !enemyBomb else ENEMY_SPELL.instantiate()
		explosion.direction = directions[c]
		explosion.manaDamage = manaDamage
		explosion.damage = damage
		add_child(explosion)

func spellFinished():
	finished -= 1
	if finished <= 0:
		queue_free()

func getXP(xp = 1):
	if parent == null: return
	parent.getXP(xp + randi_range(0, sqrt(xp)))
