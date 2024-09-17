extends Node2D

var player = null
@export var itemType:Global.weaponType = Global.weaponType.AXE
@onready var as_item: AnimatedSprite2D = $asItem

const AXE = preload("res://code/weapon/axe.tscn")
const SWORD = preload("res://code/weapon/sword.tscn")

func _ready() -> void:
	match itemType:
		Global.weaponType.SWORD:
			as_item.play("sword")

func _on_a_item_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = body
		body.connect("collectItem", collect)

func _on_a_item_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player.disconnect("collectItem", collect)
		player = null

func collect():
	var weapon = null
	match itemType:
		Global.weaponType.AXE:
			weapon = AXE.instantiate()
		_:
			weapon = SWORD.instantiate()
	player.equipWeapon(weapon)
	queue_free()
