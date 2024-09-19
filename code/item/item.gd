extends Node2D

var player = null
@export var itemType:Global.weaponType = Global.weaponType.AXE
@onready var as_item: AnimatedSprite2D = $asItem

var weaponName = "Axe"

const AXE = preload("res://code/weapon/axe.tscn")
const SWORD = preload("res://code/weapon/sword.tscn")
@export var SPELL:PackedScene
@export var BOMB:PackedScene

func _ready() -> void:
	match itemType:
		Global.weaponType.SWORD:
			as_item.play("sword")
			weaponName = "Sword"
		Global.weaponType.FIREBALL:
			as_item.play("fireball")
			weaponName = "Fireball"
		Global.weaponType.BOMB:
			as_item.play("bomb")
			weaponName = "Bomb"

func _on_a_item_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Global.manaLog.emit("Press numpad 8 to pick up the " + weaponName)
		Global.manaLog.emit("Press V to pick up the " + weaponName)
		player = body
		body.connect("collectItem", collect)

func _on_a_item_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player.disconnect("collectItem", collect)
		player = null

func collect():
	var weapon = null
	var spell = null
	match itemType:
		Global.weaponType.AXE:
			weapon = AXE.instantiate()
		Global.weaponType.FIREBALL:
			spell = SPELL
		Global.weaponType.BOMB:
			spell = BOMB
		_:
			weapon = SWORD.instantiate()
	if weapon != null:
		player.equipWeapon(weapon)
	else:
		player.equipSpell(spell)
	queue_free()
