extends Node2D

@export var tile:Node2D
const FLOOR_EXIT = preload("res://code/world/floor_exit.tscn")
const PLAYER = preload("res://code/player/player.tscn")
const ENEMY = preload("res://code/enemy/enemy.tscn")
var playerSpawned = false
var exitSpawned = false
var exitFailSafePos
var spawnFailSafePos
var turn = 0

func _ready() -> void:
	Global.connect("spawnPlayer", playerSpawn)
	Global.connect("spawnEnemy", spawnEnemy)
	Global.connect("spawnExit", spawnExit)
	Global.connect("floorGenerated", forceSpawn)
	Global.connect("nextTurn", nextTurn)
	tile.generate()

func playerSpawn(pos, forceSpawn = false):
	spawnFailSafePos = pos
	var rand = randf_range(0, 1)
	if (playerSpawned || rand > 0.1) && !forceSpawn: return
	spawn(PLAYER, pos)
	print(pos)
	playerSpawned = true

func spawnEnemy(pos):
	spawn(ENEMY, pos)

func spawnExit(pos, forceSpawn = false):
	exitFailSafePos = pos
	var rand = randf_range(0, 1)
	if (exitSpawned || rand > 0.1) && !forceSpawn: return
	exitSpawned = true
	print(pos)
	spawn(FLOOR_EXIT, pos)

func spawn(node, pos):
	var spawnedNode = node.instantiate()
	spawnedNode.global_position = (Vector2(pos) * Vector2(64, 64)) + Vector2(32, 32)
	add_child(spawnedNode)

func forceSpawn():
	if !playerSpawned:
		playerSpawn(spawnFailSafePos, true)
	if !exitSpawned:
		spawnExit(exitFailSafePos, true)

func nextTurn():
	turn += 1
