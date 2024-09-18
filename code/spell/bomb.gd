extends Node2D

@export var direction:Vector2 = Vector2(1,0)
@export var speed:Vector2 = Vector2(16, 16)
@export var damage:int = 5
@export var spellName = "Bomb"

var directions = [Vector2(1,0), Vector2(-1,0), Vector2(0,1), Vector2(0,-1), Vector2(1,1), Vector2(-1,1), Vector2(-1,1), Vector2(-1,-1)]
var manaDamage = 0
var turnsLeft = 3
var finished = 8
const SPELL = preload("res://code/spell/spell.tscn")

var parent = null
var exploded = false

func _ready() -> void:
	Global.connect("nextTurn", turnEnd)
	damage = damage * finished
	parent = get_parent()
	var pParent = get_parent().get_parent()
	parent.spellFinished()
	parent.remove_child(self)
	pParent.add_sibling(self)
	global_position = parent.global_position

func turnEnd():
	turnsLeft -= 1
	if turnsLeft <= 0 && !exploded:
		exploded = true
		explode()

func explode():
	for c in finished:
		var explosion = SPELL.instantiate()
		explosion.direction = directions[c]
		explosion.manaDamage = manaDamage
		explosion.damage = damage
		add_child(explosion)

func spellFinished():
	finished -= 1
	if finished <= 0:
		print("I executed")
		queue_free()

func getXP(xp = 1):
	if parent == null: return
	parent.getXP(xp)
