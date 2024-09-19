extends Node2D
@onready var spawns: Node = $spawns

@export var tile:Node2D
const FLOOR_EXIT = preload("res://code/world/floor_exit.tscn")
const PLAYER = preload("res://code/player/player.tscn")
const FADE_OUT = preload("res://code/HUD/fade_out.tscn")
const LBL_ANIMATED_LOG = preload("res://code/HUD/lbl_animated_log.tscn")

const ENEMY = preload("res://code/enemy/zombie.tscn")
const SPIRIT_WOLF = preload("res://code/enemy/spirit_wolf.tscn")
const GOBLIN = preload("res://code/enemy/goblin.tscn")

const COLLECTIBLE = preload("res://code/item/collectible.tscn")
const SWORD = preload("res://code/item/sword.tscn")
const AXE = preload("res://code/item/item.tscn")

var playerSpawned = false
var exitSpawned = false
var exitFailSafePos
var spawnFailSafePos
var turn = 0

var playerSpawnPos

func _ready() -> void:
	Global.connect("spawnPlayer", playerSpawn)
	Global.connect("spawnEnemy", spawnEnemy)
	Global.connect("spawnExit", spawnExit)
	Global.connect("spawnItem", spawnItem)
	#Global.connect("floorGenerated", forceSpawn)
	Global.connect("nextTurn", nextTurn)
	Global.connect("floorGenerated", floorGenerated)
	Global.connect("damageAnimLog", damageAnimLog)
	tile.generate()
	#get_tree().paused = true

func damageAnimLog(type, value, pos):
	var log = LBL_ANIMATED_LOG.instantiate()
	log.get_child(0).setValues(type, value)
	#log.type = type
	add_child(log)
	log.global_position = pos

func spawnItem(pos):
	match randi_range(0,3):
		0:
			spawn(SWORD, pos)
		1:
			spawn(AXE, pos)
		2:
			spawn(COLLECTIBLE, pos)

func floorGenerated():
	if playerSpawnPos == null && spawnFailSafePos == null: spawnFailSafePos = (Vector2(0,0) * Vector2(64, 64)) + Vector2(32, 32)
	Global.player.get_child(0).global_position = playerSpawnPos if playerSpawnPos != null else spawnFailSafePos
	Global.player.get_child(0).connect("dead", gameOver)
	Global.player.enterFloor()
	add_child(Global.player)
	forceSpawn()

func gameOver():
	add_child(FADE_OUT.instantiate())

func playerSpawn(pos, forceSpawn = false):
	spawnFailSafePos = pos
	var rand = randf_range(0, 1)
	if (playerSpawned || rand > 0.1) && !forceSpawn: return
	#if Global.player == null && false:
		#spawn(PLAYER, pos)
	#else:
	#Global.player.enterFloor((Vector2(pos) * Vector2(64, 64)) + Vector2(32, 32))
	#Global.player.get_child(0).global_position = (Vector2(pos) * Vector2(64, 64)) + Vector2(32, 32)
	playerSpawnPos = (Vector2(pos) * Vector2(64, 64)) + Vector2(32, 32)
	#Global.player.enterFloor()
	#add_child(Global.player)
	playerSpawned = true

func spawnEnemy(pos):
	if Global.floor < 25 && randi_range(1,4) == 4: return
	match randi_range(0,2):
		Global.enemyType.SPIRIT_WOLF:
			spawn(SPIRIT_WOLF, pos)
		Global.enemyType.GOBLIN:
			spawn(GOBLIN, pos)
		_:
			spawn(ENEMY, pos)

func spawnExit(pos, forceSpawn = false):
	exitFailSafePos = pos
	var rand = randf_range(0, 1)
	if (exitSpawned || rand > 0.1) && !forceSpawn: return
	exitSpawned = true
	Global.setDoorCoordinates.emit(pos)
	spawn(FLOOR_EXIT, pos)

func spawn(node, pos):
	if pos == null: pos = Vector2(0,0)
	var spawnedNode = node.instantiate()
	spawnedNode.global_position = (Vector2(pos) * Vector2(64, 64)) + Vector2(32, 32)
	if spawnedNode.get_child(0).is_in_group("Enemy"):
		spawnedNode.get_child(0).level = Global.floor - sqrt(Global.floor) * 2 + 1
		spawnedNode.get_child(0).levelScale()
	spawns.add_child(spawnedNode)

func forceSpawn():
	if !playerSpawned:
		playerSpawn(spawnFailSafePos, true)
	if !exitSpawned:
		spawnExit(exitFailSafePos, true)

func nextTurn():
	turn += 1
	await get_tree().create_timer(0.01).timeout
	for c in spawns.get_children():
		if c != null && c.is_in_group("Enemy") && c.get_child(0) is CharacterBody2D:
			c.get_child(0).playTurn()
			if c.get_child(0).is_in_group("PlayTurn"): await get_tree().create_timer(0.2).timeout
	Global.enemyTurn.emit()
