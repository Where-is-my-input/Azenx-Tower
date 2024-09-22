extends Node2D
@onready var firehell: Node = $firehell
const ENEMY_SPELL = preload("res://code/enemy/enemy_spell.tscn")
@onready var cb_boss: CharacterBody2D = $cbBoss
@onready var bombshelling: Node = $bombshelling
const BOMB = preload("res://code/spell/bomb.tscn")
const ONE_HUNDRED_SWINGS = preload("res://code/boss/one_hundred_swings.tscn")

func floorOver():
	get_parent().floorOver()

func spellFinished():
	cb_boss.attacking = false
	cb_boss.prepareAttack()
	Global.enemyTurn.emit()

func spawnFirehell():
	for c in firehell.get_children():
		if randi_range(0,2) == 0: continue
		var newFireball = ENEMY_SPELL.instantiate()
		newFireball.direction = Vector2(0, 1)
		newFireball.damage = cb_boss.atk
		add_child(newFireball)
		newFireball.global_position = c.global_position
	Global.enemyTurn.emit()
	cb_boss.prepareAttack()

func bombShelling():
	for c in bombshelling.get_children():
		if randi_range(0,2) == 0: continue
		var newFireball = BOMB.instantiate()
		newFireball.enemyBomb = true
		newFireball.damage = cb_boss.atk
		add_child(newFireball)
		newFireball.global_position = c.global_position
	Global.enemyTurn.emit()
	cb_boss.prepareAttack()

func oneHundredSwings():
	var swings = ONE_HUNDRED_SWINGS.instantiate()
	swings.damage = cb_boss.atk
	add_child(swings)
	swings.global_position = cb_boss.global_position
	cb_boss.prepareAttack()
